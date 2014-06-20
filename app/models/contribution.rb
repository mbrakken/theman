class Contribution < ActiveRecord::Base

  belongs_to :project
  belongs_to :user

  # validates_presence_of :note, only: [:create, :edit, :update]

  delegate :email, to: :user, prefix: true

  delegate :update_ranks, to: :project
  after_commit :update_ranks



  scope :proposed, -> { where(state: 'proposed') }
  scope :requested, -> { where(state: 'requested') }
  scope :claimed, -> { where(state: 'claimed') }
  scope :accepted, -> { where(state: 'accepted') }
  scope :closed, -> { where(state: 'closed') }
  scope :global, -> { where(global: true) }

end
