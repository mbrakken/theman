class Rank < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  has_many :amps, through: :project
  has_many :contributions, through: :project
  has_many :hostings, through: :project

  validates :user_id, uniqueness: { scope: :project_id }

  def calculate_value
    amped_follows.count +
    contributed_follows.count*2 +
    hosting_follows.count*4
  end

  def update_value
    self.value = calculate_value
    save
  end

  def associated_follows
    [amped_follows, contributed_follows, hosting_follows].flatten.map(&:user).uniq
  end

  def amped_follows
    @amped_follows ||= amps.where(user_id: followed_user_ids)
  end

  def contributed_follows
    @contributed_follows ||= contributions.where(user_id: followed_user_ids)
  end

  def hosting_follows
    @hosting_follows ||= hostings.where(user_id: followed_user_ids)
  end

  def followed_user_ids
    @followed_user_ids ||= user.followed_user_ids
  end
end
