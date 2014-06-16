class RankUpdater < BaseWorker

  def perform(user_id, project_id)
    Rank.where(user_id: user_id, project_id: project_id).first_or_initialize.update_value
  end
end
