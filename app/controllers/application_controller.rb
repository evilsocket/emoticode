class ApplicationController < ActionController::Base
  # protect from CSRF attacks
  protect_from_forgery with: :exception
  # initialize instance variables that are globals to the whole app
  before_filter :initialize_globals
  # if a RecordNotFound exception is raised, automatically render the 404 page
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404

  def render_404
    render :file => 'public/404.html', :status => :not_found, :layout => false
  end

  def initialize_globals
    @languages    = Language.all
    @pages        = Page.all
    @users        = User.where( :status => User::STATUSES[:confirmed] ).order('created_at DESC').limit(20) 
    @current_user = User.find_by_id( session[:id] )
    if @current_user.nil? == false
      @current_user.last_seen_at = Time.now
      @current_user.save
    end
  end

  # a method to fetch languages by their names without performing a
  # new query since all languages are loaded as globals
  def langs_by_names(names)
    @languages.select { |lang| names.include? lang.name.to_sym }
  end

  def sign_in(user)
    @current_user = user
    @current_user.last_login = Time.now
    @current_user.last_login_ip = request.remote_ip
    @current_user.save

    session[:id] = @current_user.id
  end

  def sign_out
    @current_user = nil
    session.delete(:id)
  end

  def redirect_to_root
    redirect_to root_path
  end

  protected

  def authenticate!
    redirect_to sign_in_url, error: 'You dont have enough permissions to be here' unless @current_user
  end

  def not_authenticated!
    redirect_to root_url, error: 'Already authenticated.' unless !@current_user    
  end
end
