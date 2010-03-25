class CreateGlossaries < ActiveRecord::Migration
  def self.up
    create_table :glossaries do |t|
      t.integer :user_id
      t.integer :from_language, :int
      t.integer :to_language, :int
      t.string  :description, :limit => 250
      t.string  :title
      t.boolean :public
      t.boolean :shared
      t.timestamps
    end
  end

  def self.down
    drop_table :glossaries
  end
end