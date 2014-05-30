class CreateOfferTaggings < ActiveRecord::Migration
  def change
    create_table :offer_taggings do |t|
      t.belongs_to :offer_tag, index: true
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
