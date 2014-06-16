class UserRanksUpdater < BaseWorker

  def perform(user_id)
    Project.find_each{ |project| RankUpdater.perform_async(user_id, project.id)}
  end
end
