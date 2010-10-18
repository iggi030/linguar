class AddColumnToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :hobbies, :string
    add_column :users, :profession, :string
    add_column :users, :age, :int
    add_column :users, :gender, :int
  end

  def self.down
    remove_column :users, :gender
    remove_column :users, :age
    remove_column :users, :profession
    remove_column :users, :hobbies
  end
end
