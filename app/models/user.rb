class User < ActiveRecord::Base
	before_save { email.downcase! }
	EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :username, :presence => true, :uniqueness => true, :length => { :in => 3..20 }
	validates :email, :presence => true, uniqueness: { case_sensitive: false }, :format => EMAIL_REGEX
	validates :password, :confirmation => true
	validates_length_of :password, :in => 6..20, :on => :create

	has_secure_password
end
