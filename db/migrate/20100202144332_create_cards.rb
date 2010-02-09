class CreateCards < ActiveRecord::Migration
  def self.up
    create_table :cards do |t|
      t.integer :glossary_id
      t.string :question
      t.string :answer
      t.timestamps
    end
  end

  def self.down
    drop_table :cards
  end
end
