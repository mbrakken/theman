class Contribution < ActiveRecord::Base

  belongs_to :project
  belongs_to :contributor, class_name: "User"

  validates_presence_of :note, only: [:create, :edit, :update]

  scope :proposed, -> { where(state: 'proposed') }
  scope :accepted, -> { where(state: 'accepted') }
  scope :closed, -> { where(state: 'closed') }
  scope :global, -> { where(global: !nil) }

  after_create :update_ranks

  def update_ranks

  end

end
