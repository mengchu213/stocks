class ChangeDefaultStatusInUsers < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :status, from: 'pending', to: 'Pending'
  end
end
