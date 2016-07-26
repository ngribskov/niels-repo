class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.datetime :start
      t.datetime :stop
      t.string :project
      t.string :description
      t.boolean :open?
      t.time :elapsed

      t.timestamps null: false
    end
  end
end
