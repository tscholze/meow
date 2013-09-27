class AddChecksumToCats < ActiveRecord::Migration
  def change
    add_column :cats, :checksum, :string
  end
end
