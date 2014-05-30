class OfferTagging < ActiveRecord::Base
  belongs_to :offer_tag
  belongs_to :user
end
