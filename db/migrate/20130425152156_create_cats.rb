class CreateCats < ActiveRecord::Migration
  def change
    create_table :cats do |t|
      t.string :extname
      t.timestamps
    end
  end
end
