class CreateMails < ActiveRecord::Migration
  def self.up
    create_table :mails do |t|
      t.integer :author_id
      t.string :subject
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :mails
  end
end
