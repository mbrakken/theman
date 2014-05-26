class Project < ActiveRecord::Base

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]

  has_many :hostings
  has_many :registrations
  has_many :amps
  belongs_to :organization
  has_many :hosts, -> { distinct }, through: :hostings, source: :user
  has_many :attendees, -> { distinct }, through: :registrations, source: :user
  has_many :amplifiers, -> { distinct }, through: :amps, source: :user
  has_many :ranks
  belongs_to :organization
  belongs_to :creator, class_name: "User"

  validates_presence_of :title

  after_create :update_ranks

  delegate :email, to: :creator, prefix: true
  delegate :name, to: :organization, prefix: true, allow_nil: true

  def organization_name=(name)
    self.organization = Organization.where(name: name).first_or_initialize
  end

  def update_ranks
    EventRanksUpdater.perform_async(self.id)
  end

  def slug_candidates
    [:title]
  end

end
