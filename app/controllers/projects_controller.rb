class ProjectsController < ApplicationController
  before_action :authorize_user!, only: [:new, :create, :edit, :update]
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def show
    @contributions = @project.contributions
    respond_to do |format|
      format.html
    end
  end

  def index
    if current_user
      @ranked_projects = Rank.joins(:project).where(user_id: current_user.id ).order('ranks.value desc')
      @projects = current_user.created_projects
      @contributed_projects = current_user.contributed_projects
    else
      @projects = Project.all
      flash[:notice] = "Welcome to The Mutual Aid Network! You're seeing a list of all projects currently in our system. <a href='#{root_path}'>Connect one of your social media accounts</a> to see projects tailored to you.".html_safe
    end
    respond_to do |format|
      format.html
    end
  end

  def new
    @project = Project.new
    @organization = Organization.all
  end

  def edit
  end

  def create
    @project = current_user.created_projects.new(project_params)
    if @project.save
      @project.hosts << current_user
      @project.contributors << current_user
      ProjectMailer.created(@project).deliver
      redirect_to @project, notice: 'Your project was successfully added.'
    else
      render action: 'new'
    end
  end

  def update
    @project.attributes=(project_params)
    if @project.save
      redirect_to @project, notice: 'Your project had been successfully updated.'
    else
      render action: 'edit'
    end
  end

  private

  def set_project
    @project = Project.find(params[:id]) if params[:id]
  end

  def project_params
    params.require(:project).permit :title, :description, :url, :organization_name
  end
end
