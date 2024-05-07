class CreateDocuments < ActiveRecord::Migration[7.1]
  def change
    create_table :documents, id: false do |t|
      t.uuid :uuid, primary_key: true, null: false
      t.string :pdf_url, null: false
      t.text :description
      t.string :customer_name, null: false
      t.string :contract_value, null: false

      t.timestamps
    end

    add_index :documents, :uuid, unique: true
    add_index :documents, :pdf_url, unique: true
  end
end
