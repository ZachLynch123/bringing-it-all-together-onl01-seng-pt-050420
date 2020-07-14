require 'pry'
class Dog 
  
  attr_accessor :name, :breed
  attr_reader :id 
  
  def initialize(params)
    @id = params[:id]
    @name = params[:name]
    @breed = params[:breed]
    
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS dogs (
    id INTEGER PRIMARY KEY, 
    name TEXT, 
    breed TEXT
    )
    SQL
    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    sql = "DROP TABLE IF EXISTS dogs"
    
    DB[:conn].execute(sql)
  end
  
  def self.new_from_db(row)
    new_dog = self.new(id: row[0], name: row[1], breed: row[2])
    new_dog
  end
  
  def self.find_by_id(id)
    sql =<<-SQL
    SELECT * FROM dogs
    WHERE id = ?
    SQL
    DB[:conn].execute(sql, id).map do |row|
      self.new_from_db(row)
    end
  end
  
  def self.create(params)
    dog = Dog.new(params)
    
  end

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
end