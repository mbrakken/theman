class UsersController < ApplicationController
  before_action :authorize_user!, only: :edit
  before_action :set_user, only: [:edit, :update, :twitter_email]

  def show
    @user = User.find(params[:id])
  end

  def twitter_email
  end

  def edit

  end

  def index
    if params[:offer_tag]
      @users = User.tagged_with(params[:offer_tag])
    else
      @users = User.all
    end
  end

  def update
    @user.update_attributes(user_params)
    respond_to do |format|
      if session[:pre_authorization_page]
        format.html { redirect_to session[:pre_authorization_page] }
      else
        format.html { redirect_to root_path }
      end
      format.js
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:email, :avatar, :mobile_num, :default_identity_id, :offer_tag_list)
  end
end
