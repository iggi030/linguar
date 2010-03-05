class CreateKnowabilities < ActiveRecord::Migration
  def self.up
    create_table :knowabilities do |t|
      t.integer :card_id
      t.integer :user_id
      t.float   :ef
      t.integer :n
      t.integer :scheduled_in
      t.timestamps
    end
  end

  def self.down
    drop_table :knowabilities
  end
end
