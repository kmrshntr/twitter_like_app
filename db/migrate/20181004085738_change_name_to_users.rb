class ChangeNameToUsers < ActiveRecord::Migration[5.2]
  def change
  	rename_column :comments, :post_id, :micropost_id
  end
end
