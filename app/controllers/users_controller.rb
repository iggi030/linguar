class UsersController < ApplicationController
  
  before_filter :can_edit, :only => [:edit, :update, :destroy, :confirm_delete]
  before_filter :require_admin, :only => [:admin, :ban, :remove_ban]
  before_filter :require_login, :except => [:login, :register, :new, :create, :forgot_password]
  skip_filter :check_privacy, :only => [:login, :logout, :forgot_password]
  
  
  def index
    @users = User.paginate(:page => params[:page], :order => 'online_at desc')
    @users_count = User.count
  end

  def show
    @user = User.find(params[:id])
  end

  def new
  end

  def create
    @user = User.new(params[:user])
    render :action => :new and return false unless @user.save
    if logged_in?
      redirect_to users_path and return true
    else
      do_login(@user)
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    @user.profile_updated_at = Time.now.utc
    if @user.save
      redirect_to @user
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    if params[:confirm] != "1"
      flash[:notice] = "You must check the confirmation box"
      redirect_to confirm_delete_user_path(@user)
    else
      @user.destroy
      redirect_to users_path
    end
  end

  def confirm_delete
    @user = User.find(params[:id])
  end
  
  def admin
    @user = User.find(params[:id])
    @user.toggle!(:admin)
    redirect_to user_path(@user)
  end
  
  def ban
    @user = User.find(params[:id])
  end
  
  def remove_ban
    @user = User.find(params[:id])
    @user.remove_ban
    redirect_to user_path(@user)
  end
    
  def login
    redirect_to root_path and return false if logged_in?
    if request.post?
      @user = User.authenticate(params[:user][:email], params[:user][:password]) unless params[:user].blank?
      if @user
        do_login(@user)
      else
        flash[:notice] = "Invalid user/password combination"
        render :action => :login and return false
      end
    end
  end
  
  def logout
    redirect_to root_path and return false unless logged_in?
    @flash = flash[:notice]
    @user = User.find_by_id(session[:user_id])
    if @user
      @user.logged_out = true
      @user.auth_token = nil
      @user.auth_token_exp = nil
      @user.save!
    end
    cookies.delete :auth_token
    reset_session
    flash[:notice] = @flash
    redirect_to login_path
  end
  
  def contact
    
  end
  
  def sendmail
    from = current_user.email
    recipient = User.find(params[:id]).email
    subject = "User #{current_user} has send you a message on linguar.com"
    message = params[:user][:message]
    UserMailer.deliver_contact(recipient, subject, message, from)
    flash[:notice] = "Message to #{User.find(params[:id])} sent sucessfully"
    redirect_to :controller => "home", :action => "index"
  end
  
  def forgot_password
    logger.debug("___---Sinking")
    if params[:user]
      u = User.find_by_email(params[:user][:email])
      if u and u.send_new_password
        logger.debug("SenT password!")
        flash[:notice]  = "A new password has been sent by email."
        redirect_to login_url
      else
        logger.debug("Couldnt send password!")
        flash[:notice]  = "Couldn't send password"
        redirect_to login_url
      end
    end
  end

  def change_password
    @user=session[:user]
    if request.post?
      @user.update_attributes(:password=>params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
      if @user.save
        flash[:message]="Password Changed"
      end
    end
  end
    
  protected
    
  def do_login(user)
    user.logged_out = false
    user.online_at = Time.now.utc if user.online_at.nil?
    session[:user_id] = user.id
    session[:online_at] = user.online_at
    user.online_at = Time.now.utc
    user.auth_token = Digest::SHA1.hexdigest(Time.now.utc.to_s + rand(123456789).to_s) unless user.auth_token?
    user.auth_token_exp = 2.weeks.from_now
    cookies[:auth_token] = { :value => user.auth_token, :expires => user.auth_token_exp }
    user.save!
    redirect_to root_path
  end
    
end
