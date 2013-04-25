class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login
      t.string :email
      t.string :firstname
      t.string :lastname      
      t.string :hashed_password
      t.string :salt
      t.timestamps
    end
  end
end
