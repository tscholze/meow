class AddPermissionsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean, :default => true
    add_column :users, :can_upload_image, :boolean, :default => true
    add_column :users, :can_delete_image, :boolean, :default => true
  end
end
