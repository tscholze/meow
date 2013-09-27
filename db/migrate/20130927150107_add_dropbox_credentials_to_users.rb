class AddDropboxCredentialsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :dropbox_user_id, :string
    add_column :users, :dropbox_access_token, :string
  end
end
