class AddProjectsToRanks < ActiveRecord::Migration
  def change
    add_column :ranks, :project_id, :integer
    add_index :ranks, :project_id
  end
end
