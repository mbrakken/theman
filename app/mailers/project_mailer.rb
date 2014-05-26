class ProjectMailer < ActionMailer::Base

  def created(project)
    @project = project
    @creator = project.creator
    mail to: @creator.email, subject: 'You posted a project to the Mutual Aid Network'
  end
end
