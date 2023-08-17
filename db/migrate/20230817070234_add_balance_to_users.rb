class AddBalanceToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :balance, :decimal, default: 10000.0
  end
end
