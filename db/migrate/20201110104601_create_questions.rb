class CreateQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.text :description
      t.references :user
      t.references :topic
      t.timestamps
    end
  end
end
