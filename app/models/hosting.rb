class Hosting < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  delegate :update_ranks, to: :project
  after_commit :update_ranks
end
