class CreateUserFollows < ActiveRecord::Migration[6.0]
  def change
    create_table :user_follows do |t|
      t.references :user
      t.references :topic
      t.integer :followed_user_id

      t.timestamps
    end
  end
end
