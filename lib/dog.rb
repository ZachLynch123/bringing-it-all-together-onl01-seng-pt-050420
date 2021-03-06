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
    dog.save
    dog
    
  end
  
  
   def save 
    if self.id 
      self.update
    else
      sql = <<-SQL
      INSERT INTO dogs (name, breed)
      VALUES (?,?)
      SQL
      
      DB[:conn].execute(sql, self.name, self.breed)
        @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]

   end
      
  end
  
  def find_by_name(name)
    sql = <<-SQL
      SELECT * FROM dogs 
      WHERE name = ?
    
    SQL
    DB[:conn].execute(sql, name).map do |row|

      self.new_from_db(row)
    end
    
  end

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
end