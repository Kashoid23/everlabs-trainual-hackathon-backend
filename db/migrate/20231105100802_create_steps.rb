class CreateSteps < ActiveRecord::Migration[7.0]
  def change
    create_table :steps do |t|
      t.text :content

      t.timestamps
    end
  end
end
