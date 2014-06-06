class ContributionsController < ApplicationController
  before_action :authorize_user!, only: [:new, :create, :edit, :update]
  before_action :set_contribution, only: [:show, :edit, :update, :destroy, :retract]

  def new
    @contribution = @project.contributions.new
  end

  def create
    @contribution = current_user.contributions.new contribution_params
    if @contribution.save
      flash[:notice] = "Contribution recorded"
      redirect_to session.delete(:retun_to)
    else
      redirect_to session.delete(:retun_to) || :back, notice: 'There was an issue recording your contribution.'
    end

  end

  def create_global
    @contribution = Contribution.create(contribution_params)
    redirect_to support_content_index_path, notice: 'Thank you for contributing. Someone will be in touch with you shortly.'
  end

  def index
    respond_to do |format|
      format.html
      format.js
  end

  private

  def set_contribution
    @contribution = Contribution.find(params[:id])
  end

  def set_project
    @project = Project.find(params[:project_id])
  end

  # def set_contribution
  #   @contribution = current_user.contributions.find(params[:id])
  # end

  def contribution_params
    params.require(:contribution).permit(:note, :email)
  end
end
