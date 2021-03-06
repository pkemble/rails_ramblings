class User < ActiveRecord::Base
	attr_accessor :remember_token
	before_save { email.downcase! }
	EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :username, :presence => true, :uniqueness => true, :length => { :in => 3..20 }
	validates :email, :presence => true, uniqueness: { case_sensitive: false }, :format => EMAIL_REGEX
	validates :password, :confirmation => true
	validates_length_of :password, :in => 6..20, :on => :create

	has_secure_password
  has_one_time_password

	def User.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
														BCrypt::Engine.cost
		BCrypt::Password.create(string, cost: cost)
	end
	
	def User.new_token
		SecureRandom.urlsafe_base64
	end
	
	def remember
		self.remember_token = User.new_token
		update_attribute( :remember_digest, User.digest(remember_token) )
	end
	
	def authenticated?(remember_token)
		return false if remember_digest.nil?
		BCrypt::Password.new(remember_digest).is_password?(remember_token)
	end
	
	def forget
		update_attribute(:remember_digest, nil)
	end
end
