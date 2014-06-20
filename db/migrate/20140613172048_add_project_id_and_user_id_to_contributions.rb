class AddProjectIdAndUserIdToContributions < ActiveRecord::Migration
  def change
    add_reference :contributions, :project, index: true
    add_reference :contributions, :user, index: true
  end
end
