class AddTandaFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :tanda_access_token, :string
    add_column :users, :tanda_refresh_token, :string
    add_column :users, :tanda_token_expires_at, :datetime
  end
end
