require "spec_helper"
require 'pry'

describe "Dog" do

  let(:teddy) {Dog.new(name: "Teddy", breed: "cockapoo")}

  before(:each) do
    DB[:conn].execute("DROP TABLE IF EXISTS dogs")
    sql =  <<-SQL
      CREATE TABLE IF NOT EXISTS dogs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT
        )
    SQL
    DB[:conn].execute(sql)
  end

  describe "attributes" do
    it 'has a name and a breed' do
      dog = Dog.new(name: "Fido", breed: "lab")
      expect(dog.name).to eq("Fido")
      expect(dog.breed).to eq("lab")
    end

    it 'has an id that defaults to `nil` on initialization' do
      expect(teddy.id).to eq(nil)
    end

    it 'accepts key value pairs as arguments to initialize' do
      params = {id: 1, name: "Caldwell", breed: "toy poodle"}

      dog = Dog.new(params)
      expect(dog.name).to eq("Caldwell")
      expect(dog.breed).to eq("toy poodle")
    end
  end

  describe ".create_table" do
    it 'creates the dogs table in the database' do
      DB[:conn].execute("DROP TABLE IF EXISTS dogs")
      Dog.create_table
      table_check_sql = "SELECT tbl_name FROM sqlite_master WHERE type='table' AND tbl_name='dogs';"
      expect(DB[:conn].execute(table_check_sql)[0]).to eq(['dogs'])
    end
  end

  describe ".drop_table" do
    it 'drops the dogs table from the database' do
      Dog.drop_table
      table_check_sql = "SELECT tbl_name FROM sqlite_master WHERE type='table' AND tbl_name='dogs';"
      expect(DB[:conn].execute(table_check_sql)[0]).to eq(nil)
    end
  end

  

  describe ".create" do
    it 'takes in a hash of attributes and uses metaprogramming to create a new dog object. Then it uses the #save method to save that dog to the database'do
      Dog.create(name: "Ralph", breed: "lab")
      expect(DB[:conn].execute("SELECT * FROM dogs")).to eq([[1, "Ralph", "lab"]])
    end
    it 'returns a new dog object' do
      dog = Dog.create(name: "Dave", breed: "podle")

      expect(teddy).to be_an_instance_of(Dog)
      expect(dog.name).to eq("Dave")
    end
  end

  describe '.new_from_db' do
    it 'creates an instance with corresponding attribute values' do
      row = [1, "Pat", "poodle"]
      pat = Dog.new_from_db(row)

      expect(pat.id).to eq(row[0])
      expect(pat.name).to eq(row[1])
      expect(pat.breed).to eq(row[2])
    end
  end
  
 
end
