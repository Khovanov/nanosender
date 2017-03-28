class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.references :user, foreign_key: true
      t.string :messenger
      t.text :body
      t.boolean :delivered

      t.timestamps
    end
    add_index :messages, [ :user_id, :messenger, :body ], unique: true
  end
end
