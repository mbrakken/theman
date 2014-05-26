class AddProjectsToHostings < ActiveRecord::Migration
  def change
    add_column :hostings, :project_id, :integer
    add_index :hostings, :project_id
  end
end
