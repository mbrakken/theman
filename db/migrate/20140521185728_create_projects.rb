class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.text :description
      t.string :city
      t.string :state
      t.string :country
      t.integer :creator_id
      t.integer :organization_id
      t.string :url
      t.string :slug

      t.timestamps
    end
  end
end
