class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE students (id INTEGER PRIMARY KEY, name TEXT, grade INTEGER);
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE students;
    SQL
    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
    INSERT INTO students(name, grade) VALUES (?,?);
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
    sql2 = <<-SQL
    SELECT students.id FROM students ORDER BY students.id DESC LIMIT 1;
    SQL
    @id = DB[:conn].execute(sql2)[0][0]
  end

  def self.create(hash)
    new_student = Student.new(hash[:name], hash[:grade])
    new_student.save
    new_student
  end

end
