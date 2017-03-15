require 'sqlite3'

class Robot
attr_reader :name, :city, :state, :department, :id

  def initialize(robot_params)
    @name = robot_params["name"]
    @city = robot_params["city"]
    @state = robot_params["state"]
    @department = robot_params["department"]
    @database = SQLite3::Database.new('db/robot_world_development.db')
    @database.results_as_hash = true
    @id = robot_params["id"] if robot_params["id"]
  end

  def self.database
    database = SQLite3::Database.new('db/robot_world_development.db')
    database.results_as_hash = true
    database
  end

  def self.all
    self.database
    robots = database.execute("SELECT * FROM robots")
    robots.map do |robot|
      Robot.new(robot)
    end
  end

  def save
    @database.execute("INSERT INTO robots (name, city, state, department) VALUES (?, ?, ?, ?);", @name, @city, @state, @department)
  end

  def self.find_by_id(id)
    self.database
    robot = database.execute("SELECT * FROM robots WHERE id = ?;", id).first
    Robot.new(robot)
  end

  def self.find_all_by_city(robot_params)
    self.database
    require "pry"; binding.pry

    robot = database.execute("SELECT * FROM robots WHERE city = ?;", robot_params["city"]).count
    Robot.new(robot)
  end

  def self.update(id, robot_params)
    database.execute("UPDATE robots
                      SET name = ?,
                          city = ?,
                          state = ?,
                          department = ?
                          WHERE id = ?;",
                          robot_params["name"],
                          robot_params["city"],
                          robot_params["state"],
                          robot_params["department"],
                          id)
    Robot.find_by_id(id)
  end

  def self.destroy(id)
    database.execute("DELETE FROM robots
                      WHERE id = ?;", id)
  end
end
