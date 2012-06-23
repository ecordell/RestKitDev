class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.string :name

      t.timestamps
    end
  end
end
