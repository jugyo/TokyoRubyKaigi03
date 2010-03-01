class User
  include DataMapper::Resource

  PASSWORD_SALT = 'trk03'

  property :id, Serial
  property :name, String, :length => 60
  property :password, String, :length => 160
  timestamps :at

  has 1, :session, :child_key => [:user_id]
  has n, :tweets, :child_key => [:user_id]
  has n, :followings
  has n, :followers

  def timeline
    Tweet.all(:user_id => followings.map{|f| f.who} << id, :order => [:id.desc], :limit => Tweet::TIMELINE_LIMIT).map do |tweet|
      [User.get(tweet.user_id), tweet]
    end
  end

  def self.password_crypt(plain_text)
    Digest::SHA1.hexdigest(PASSWORD_SALT + plain_text)
  end
  
  def password=(plain_text)
    attribute_set(:password, User.password_crypt(plain_text))
  end

  after :create do
    self.session = Session.new(:id => id)
    self.save
    self
  end
end

class Session
  include DataMapper::Resource

  SALT = 'trk03'
  EXPIRE_TIME = 3600

  property :id, String, :length => 160, :key => true
  property :user_id, Integer
  property :expired_at, DateTime

  belongs_to :user

  def id=(user_id)
    attribute_set(:id, Digest::SHA1.hexdigest("#{user_id}#{Session::SALT}#{Time.now.to_f}"))
  end

  before :save do
    attribute_set(:expired_at, DateTime.now + EXPIRE_TIME)
  end
end

class Tweet
  include DataMapper::Resource

  TIMELINE_LIMIT = 20

  property :id, Serial
  property :user_id, Integer
  property :body, String, :length => 140
  timestamps :at

  belongs_to :user
end

class Following
  include DataMapper::Resource

  property :id, Serial
  property :who, Integer
  timestamps :at

  belongs_to :user
end

class Follower
  include DataMapper::Resource

  property :id, Serial
  property :who, Integer
  timestamps :at
  
  belongs_to :user
end
