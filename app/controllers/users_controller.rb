class UsersController < ApplicationController
  before_action :set_user, excerpt: %i(index new create)

  def index
    @users = User.all
  end

  def show; end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new user_params

    if @user.save
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
      return if @user
      render file: "#{Rails.root}/public/404", status: :not_found
    end

    def user_params
      params.require(:user).permit :name, :email, :password, :password_confirmation
    end

    def not_found
      render :status => 404
    end
end
