require 'data_mapper' # metagem, requires common plugins too.

# need install dm-sqlite-adapter
# if on heroku, use Postgres database
# if not use sqlite3 database I gave you
if ENV['DATABASE_URL']
  DataMapper::setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
else
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/app.db")
end

class User
    include DataMapper::Resource
    property :id, Serial
    property :email, String
    property :name, String
    property :password, String
    property :created_at, DateTime
    # 0 : Normal User, 1 : Pro User, 2 : Admin User
    property :type, Integer, :default => 0

    def login(password)
    	return self.password == password
    end
    
    def getLibrary()
      @lib ||= Library.first(:user_id => self.id)
      return @lib
    end
end

# Perform basic sanity checks and initialize all relationships
# Call this when you've defined all your models
DataMapper.finalize

# automatically create the post table
User.auto_upgrade!

