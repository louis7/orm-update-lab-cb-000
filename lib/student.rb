require_relative "../config/environment.rb"
require'pry'
class Student
attr_accessor :name, :grade
attr_reader   :id
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

def initialize (name,grade,id=nil)
  @name= name
  @grade= grade
  @id= id
end



def self.create_table
  sql = "CREATE TABLE students (
    id INTEGER PRIMARY KEY,
    name TEXT,
    age INTEGER,
    breed TEXT,
    owner_id INTEGER
); "
DB[:conn].execute(sql)
end

def self.drop_table
  sql = "DROP TABLE students; "
DB[:conn].execute(sql)
end

def save
  # always Remember that sql returns a array of arrays
  if self.id
    self.update
  else
  sql = "INSERT INTO students (name,grade)VALUES (?,?)"
  DB[:conn].execute(sql,self.name, self.grade)
  @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]

  end
end


def update
  sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
   DB[:conn].execute(sql, self.name, self.grade, self.id)
end

def self.create(name,grade)
  student= self.new(name,grade)
  student.save
  student
end



def self.new_from_db(row)
  array = row
  student = self.new(array[1],array[2],array[0])
  student
end


def self.find_by_name(name)
  stored_name = name
  sql  = "SELECT* FROM students WHERE name = ?"
  result = DB[:conn].execute(sql, stored_name)
  student = self.new_from_db(result[0][0])
  student
end


end
