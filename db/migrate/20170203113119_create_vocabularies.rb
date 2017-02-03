class CreateVocabularies < ActiveRecord::Migration[5.0]
  def change
    create_table :vocabularies do |t|
      t.string :title
      t.text :content
      t.belongs_to :character, index: true

      t.timestamps
    end
  end
end
