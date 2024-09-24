require "pg"

class DatabasePersistence
  def initialize(logger)
    @db = if Sinatra::Base.production?
            PG.connect(ENV['DATABASE_URL'])
          else
            PG.connect(dbname: "nagivator")
          end
    @logger = logger
  end

  def disconnect
    @db.close
  end

  def query(statement, *params)
    @logger.info "#{statement}: #{params}"
    @db.exec_params(statement, params)
  end

  def all_events
    sql = <<~SQL
      select * from events;
    SQL

    result = query(sql)

    result.map do |tuple|
      tuple_to_event_hash(tuple)
    end
  end

  private

  def tuple_to_event_hash(tuple)
    { id: tuple["id"].to_i,
      name: tuple["name"],
      start_time: tuple["start_time"],
      end_time: tuple["end_time"],
      details: tuple["details"],
      completed: tuple["completed"] }
  end
end
