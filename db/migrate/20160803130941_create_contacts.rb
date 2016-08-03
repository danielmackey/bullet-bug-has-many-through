class CreateContacts < ActiveRecord::Migration[5.0]
  def change
    create_table :contacts do |t|
      t.string :value
      t.references :person, foreign_key: true

      t.timestamps
    end
  end
end
