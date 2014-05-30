class User < ActiveRecord::Base
  has_many :registrations
  has_many :hostings
  has_many :amps
  has_many :ranks

  has_many :follows, foreign_key: :follower_id
  has_many :complete_follows, -> { complete }, class_name: 'Follow', foreign_key: :follower_id
  has_many :followed_users, -> { distinct }, through: :complete_follows, source: :followee

  has_many :followings, foreign_key: :followee_id, class_name: 'Follow'
  has_many :following_users, -> { distinct }, through: :followings, source: :followee

  has_many :registrations
  has_many :created_projects, class_name: 'Project', foreign_key: :creator_id
  has_many :registered_projects, -> { distinct }, through: :registrations, source: :project
  has_many :hosted_projects, -> { distinct }, through: :hostings, source: :project
  has_many :amped_projects, -> { distinct }, through: :amps, source: :project

  has_many :following_amps, through: :followed_users, source: :amps
  has_many :following_registrations, through: :followed_users, source: :amps
  has_many :following_hostings, through: :followed_users, source: :amps

  has_many :following_amped_projects, through: :followed_users, source: :amped_projects
  has_many :following_registered_projects, through: :followed_users, source: :registered_projects
  has_many :following_hosted_projects, through: :followed_users, source: :hosted_projects

  has_many :org_administrations
  has_many :administered_orgs, through: :org_administrations, source: :organization

  has_many :identities
  has_one :facebook_identity, -> { where provider: 'facebook' }, class_name: 'Identity'
  has_one :twitter_identity, -> { where provider: 'twitter' }, class_name: 'Identity'
  has_one :linkedin_identity, -> { where provider: 'linkedin' }, class_name: 'Identity'
  has_one :google_identity, -> { where provider: 'google' }, class_name: 'Identity'
  belongs_to :default_identity, class_name: 'Identity'

  has_many :offer_taggings
  has_many :offer_tags, through: :offer_taggings

  before_update :update_man_identity
  after_create :update_ranks

  def update_man_identity
    if default_identity_id_changed?
      self.avatar = default_identity.info['image']
      self.email = default_identity.info['email'] if default_identity.info['email']
    end
  end

  def following_user_ids
    followed_users.pluck(:id)
  end

  def registered?(project)
    registrations.exists? project_id: project.id
  end

  def amplified?(project)
    amps.exists? project_id: project.id
  end

  def update_ranks
    UserRanksUpdater.perform_async(self.id)
  end

  def self.tagged_with(name)
    OfferTag.find_by_name!(name).users
  end

  def self.tag_counts
    OfferTag.select("offer_tags.*, count(offer_taggings.offer_tag_id) as count").
      joins(:offer_taggings).group("offer_taggings.offer_tag_id")
  end

  def offer_tag_list
    offer_tags.map(&:name).join(", ")
  end

  def offer_tag_list=(names)
    self.offer_tags = names.split(",").map do |n|
      OfferTag.where(name: n.strip).first_or_create!
    end
  end

  def following_projects
    # Event.joins(:)
    # Event.find_by_sql(
    # 'SELECT projects.*
    # FROM projects
    # INNER JOIN registrations
    # ON projects.id = registrations.project_id
    # INNER JOIN users
    # ON users.id = registrations.user_id
    # WHERE users.id IN (SELECT follower_id FROM follows WHERE followee_id IS NOT NULL)
    # GROUP BY projects.id')

    # (SELECT(SELECT COUNT(id) FROM registrations WHERE registrations.project_id = projects.id) * 2 +
    #   (SELECT COUNT(id) FROM hostings WHERE hostings.project_id = projects.id) * 4 +
    #   (SELECT COUNT(id) FROM amps WHERE amps.project_id = projects.id) * 1) AS project_weight
  end
end
