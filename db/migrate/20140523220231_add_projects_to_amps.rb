class AddProjectsToAmps < ActiveRecord::Migration
  def change
    add_column :amps, :project_id, :integer
    add_index :amps, :project_id
  end
end
