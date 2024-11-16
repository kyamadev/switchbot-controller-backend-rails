class AddSwitchbotColumnsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :switchbot_token, :string
    add_column :users, :switchbot_secret, :string
  end
end
