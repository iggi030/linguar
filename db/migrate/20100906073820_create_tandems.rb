class CreateTandems < ActiveRecord::Migration
  def self.up
    create_table :tandems do |t|
      t.integer :user_id
      t.string  :motivation,  :limit => 120
      t.string  :location,    :limit => 35
      t.decimal :lat
      t.decimal :lng
      t.integer :post_type
      t.integer :learning_language
      t.timestamps
    end
    #execute("ALTER TABLE tandems MODIFY lat numeric(15,10);")
    #execute("ALTER TABLE tandems MODIFY lng numeric(15,10);")
  end

  def self.down
    drop_table :tandems
  end
end
