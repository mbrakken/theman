class OfferTag < ActiveRecord::Base
  has_many :offer_taggings
  has_many :users, through: :offer_taggings

end
