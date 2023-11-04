class CreateAudios < ActiveRecord::Migration[7.0]
  def change
    create_table :audios do |t|
      t.string :title
      t.string :src
      t.string :link
      t.references :folder, null: false, foreign_key: true

      t.timestamps
    end
  end
end
