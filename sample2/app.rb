# -*- coding: utf-8 -*-

configure :development do
  require 'ruby-debug'
end

configure do  
  DataMapper::setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/db.sqlite3")
  set :sessions, true
end

helpers do
  def user_authentication
    return if session[:ssid].nil?
    @user = User.first(:session => {:id => session[:ssid], :expired_at.gte => Time.now})
    @is_login = @user.present?
  end

  def login?
    @is_login == true
  end
end

before do
  user_authentication
end

not_found do
  'page not found.'
end

error do
  '<p>Do you think whale is so cute?</p><br />' + request.env['sinatra.error'].message
end

get '/' do
  @current_users = User.all(:id.not => @user.id, :order => [:id.desc], :limit => 20)
  erb :index
end

get '/login' do
  erb :login
end

post '/login' do
  user = User.first(:name => params[:name], :password => User.password_crypt(params[:password]))
  redirect '/signup' if user.blank?
  user.session.destroy! if user.session.present?
  user.session = Session.new(:id => user.id)
  user.save
  session[:ssid] = user.session.id
  redirect '/'
end

get '/signup' do
  erb :signup
end

post '/signup' do
  halt 400, 'your name already used !!' if User.first(:name => params[:name]).present?
  user = User.create(params)
  session[:ssid] = user.session.id
  redirect '/'
end

get '/logout' do
  session[:ssid] = nil
  redirect '/'
end

post '/tweet' do
  @user.tweets << Tweet.new(params)
  @user.save
  redirect '/'
end

get '/:name/follow' do
  following_user = User.first(:name => params[:name])
  @user.followings << Following.new(:who => following_user.id)
  @user.save
  following_user.followers << Follower.new(:who => @user.id)
  following_user.save
  redirect '/'
end

get '/:name/remove' do
  remove_user = User.first(:name => params[:name])
  @user.followings.first(:who => remove_user.id).destroy!
  remove_user.followers.first(:who => @user.id).destroy!
  redirect '/'
end

get '/:name' do
  @someone = User.first(:name => params[:name])
  pass if @someone.blank?
  @someone.tweets.all(:order => [:id.desc], :limit => Tweet::TIMELINE_LIMIT = 20)
  @followed = User.first(:id => @user.id, :followings => {:who => @someone.id}).present?
  erb :user
end
