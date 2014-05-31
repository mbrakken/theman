class DropOfferTags < ActiveRecord::Migration
  def up
    drop_table :offer_tags
    drop_table :offer_taggings
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
