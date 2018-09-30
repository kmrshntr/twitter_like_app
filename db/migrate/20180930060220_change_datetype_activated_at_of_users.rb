class ChangeDatetypeActivatedAtOfUsers < ActiveRecord::Migration[5.2]
  def change
  	change_column :users, :activated_at, :datetime
  end
end
