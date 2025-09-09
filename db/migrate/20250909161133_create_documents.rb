class CreateDocuments < ActiveRecord::Migration[7.1]
  def change
    create_table :documents do |t|
      t.string  :title, null: false
      t.string  :status, null: false, default: "uploaded"
      t.text    :text
      t.boolean :redact, null: false, default: true

      t.timestamps
    end
  end
end
