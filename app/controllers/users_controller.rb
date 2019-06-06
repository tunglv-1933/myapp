class UsersController < ApplicationController
  before_action :set_user, only: %i(show update destroy)
  before_action :logged_in_user, only: %i(edit update)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: %i(destroy)

  def index
    @users = User.paginate page: params[:page]
  end

  def show; end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new user_params

    if @user.save
      log_in user
      flash[:success] = t "welcome_to_the_sample_app"
      redirect_to @user
    else
      render :new
    end
  end

  def update
    if @user.update user_params
      flash[:success] = t "user_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "user_destroyed"
      redirect_to users_url
    else
      flash[:danger] = t "some_thing_was_wrong"
    end
  end

  private

    def set_user
      @user = User.find_by id: params[:id]
      return if !@user.nil?
      render file: "#{Rails.root}/public/404", status: :not_found
    end

    def user_params
      params.require(:user).permit :name, :email, :password, :password_confirmation
    end

    def not_found
      render :status => 404
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = t "please_log_in"
        redirect_to login_url
      end
    end

    def correct_user
      @user = User.find_by id: params[:id]
      redirect_to root_path unless current_user?(user)
    end

    def admin_user
      redirect_to root_url unless current_user.admin?
    end
end
