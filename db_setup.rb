ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => 'database.db'
)

ActiveRecord::Schema.define do
  unless ActiveRecord::Base.connection.tables.include? 'values'
    create_table :values do |table|
      table.column :name, :string
      table.column :votes, :integer, default: 0
    end
  end
end