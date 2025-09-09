class CreateDocuments < ActiveRecord::Migration[7.1]
  def change
    create_table :documents do |t|
      t.string :title
      t.string :status
      t.text :text
      t.boolean :redact

      t.timestamps
    end
  end
end
