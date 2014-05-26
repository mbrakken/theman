class AddProjectsToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :project_id, :integer
    add_index :registrations, :project_id
  end
end
