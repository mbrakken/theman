class ContributionsController < ApplicationController
  before_filter :authorize_user!, only: [:new, :create, :edit, :update]
  before_filter :set_contribution, only: [:show, :claim]
  before_filter :set_user_contribution, only: [:edit, :update, :destroy, :retract]
  before_filter :set_project, only: [:create]

  def new
    @contribution = @project.contributions.new
  end

  def create
    @contribution = @project.contributions.new(contribution_params)
    if current_user
      @contribution.user = current_user
    else
      redirect_to project_path(@project), notice: 'need a better flow for handling non-authenticated contributors' and return
    end
    if @contribution.save
      # binding.pry
      if @contribution.user == @project.creator
        @contribution.request
      else
        @contribution.propose
      end
      flash[:notice] = "Your contribution has been recorded"
      redirect_to project_path(@project)
    else
      redirect_to project_path(@project), notice: 'There was an issue recording your contribution.'
    end
  end

  def create_global
    @contribution = Contribution.create(contribution_params)
    redirect_to projects_path, notice: 'Thank you for contributing. Someone will be in touch with you shortly.'
  end

  def index
    set_project if params[:project_id]
    @contributions = @project.present? ? @project.contributions : Contribution.all
    if %w( proposed requested claimed accepted).include?(params[:scope])
      @contributions = @contributions.send(params[:scope])
    else
      @contributions = @contributions.requested
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def claim
    @contribution.claim ? flash[:notice] = "You have taken responsibility for this contribution" : flash[:error] = "Invalid transition"
    redirect_to project_contributions_path(@contribution.project)
  end

  private

  def set_contribution
    @contribution = Contribution.find(params[:id])
  end

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_user_contribution
    @contribution = current_user.contributions.find(params[:id])
  end

  def contribution_params
    params.require(:contribution).permit(:note, :email)
  end

end
