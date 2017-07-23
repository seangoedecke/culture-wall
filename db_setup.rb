ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => 'database.db'
)

ActiveRecord::Schema.define do
  unless ActiveRecord::Base.connection.tables.include? 'values'
    create_table :values do |table|
      table.column :name, :string
      table.column :votes, :integer, default: 0
      table.column :wall_id, :integer
    end
  end

	unless ActiveRecord::Base.connection.tables.include? 'walls'
    create_table :walls do |table|
      table.column :name, :string
      table.column :unique_hash_id, :string
      table.column :is_paid, :boolean, default: false
    end
  end
end