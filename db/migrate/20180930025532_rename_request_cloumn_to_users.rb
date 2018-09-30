class RenameRequestCloumnToUsers < ActiveRecord::Migration[5.2]
  def change
  	rename_column :users, :reset_set_at, :reset_sent_at
  end
end
