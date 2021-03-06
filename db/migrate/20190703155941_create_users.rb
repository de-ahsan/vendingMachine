class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.bigint :deposit_amount, default: 0
      t.integer :role

      t.timestamps
    end
  end
end
