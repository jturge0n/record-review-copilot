class CreateFindings < ActiveRecord::Migration[7.1]
  def change
    create_table :findings do |t|
      t.references :document, null: false, foreign_key: true
      t.string :category
      t.string :label
      t.text :value
      t.date :date
      t.float :confidence
      t.integer :source_start
      t.integer :source_end

      t.timestamps
    end
  end
end
