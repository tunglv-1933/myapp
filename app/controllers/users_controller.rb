class UsersController < ApplicationController
  before_action :set_user, only: %i(show update destroy)
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: %i(destroy)

  def index
    @users = User.page(params[:page]).per(Settings.user_per_page).order_by_name(:desc)
  end

  def show
    @microposts = @user.microposts.page(params[:page]).per(Settings.user_per_page)
  end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new user_params

    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = t "please_check_your_email_to_activate_your_account"
      redirect_to root_url
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
    return if @user
    render file: "#{Rails.root}/public/404", status: :not_found
  end

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end

  def not_found
    render :status => 404
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "please_log_in"
    redirect_to login_url
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to root_path unless current_user?(user)
  end

  def admin_user
    return if current_user.admin?
    redirect_to root_url
  end
end
