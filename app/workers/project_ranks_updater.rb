class ProjectRanksUpdater < BaseWorker

  def perform(project_id)
    User.find_each do |user|
      RankUpdater.perform_async(user.id, project_id)
    end
  end
end
