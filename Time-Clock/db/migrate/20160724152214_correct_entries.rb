class CorrectEntries < ActiveRecord::Migration
  def change
    remove_column :entries, :open?
    remove_column :entries, :elapsed
    add_column :entries, :open, :boolean
    add_column :entries, :elapsed, :int


  end
end
