class CreateGlownerships < ActiveRecord::Migration
  def self.up
    create_table :glownerships do |t|
      t.integer :user_id
      t.integer :glossary_id
      t.timestamps
    end
  end

  def self.down
    drop_table :glownerships
  end
end
