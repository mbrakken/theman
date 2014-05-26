class Amp < ActiveRecord::Base
  # belongs_to :event
  belongs_to :project
  belongs_to :user

  # delegate :update_ranks, to: :event
  delegate :update_ranks, to: :project
  after_commit :update_ranks

end
