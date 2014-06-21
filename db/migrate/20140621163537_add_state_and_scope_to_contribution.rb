class AddStateAndScopeToContribution < ActiveRecord::Migration
  def change
    add_column :contributions, :state, :string
    add_column :contributions, :scope, :string, default: 'local'
  end
end
