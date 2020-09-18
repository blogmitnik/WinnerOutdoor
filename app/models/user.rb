class User < ApplicationRecord
	extend FriendlyId
	friendly_id :name, use: :slugged

	self.implicit_order_column = "created_at"
	
  	# Include default devise modules. Others available are:
  	# :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  	devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable,
		:trackable

	devise :omniauthable, omniauth_providers: [:google_oauth2, :facebook]

  	has_many  :access_grants, class_name: "Doorkeeper::AccessGrant", foreign_key: :resource_owner_id, dependent: :delete_all
  	has_many  :access_tokens, class_name: "Doorkeeper::AccessToken", foreign_key: :resource_owner_id, dependent: :delete_all

  	# Add some password complexity requirements
	validate :password_complexity

	def password_complexity
		if password.present? and not password.match(/\A(?=.{6,})(?=.*\d)(?=.*[a-z])(?=.*[A-Z])/)
			errors.add :password, "must include at least one lowercase letter, one uppercase letter, and one digit"
		end
	end

	# actually pasword from has_secure_password has a 72 character limit anyway, but w/e
  	validates :password, presence: true, length: { minimum: 6, maximum: 72 }

	# Add validations for the username and full name length
	validates :name, :username, presence: true, length: { minimum: 3, maximum: 12 }
	validates :username, presence: true, length: { minimum: 3, maximum: 32 },
    format: { with: /\A[0-9a-zA-Z]+([-._]?[0-9a-zA-Z]+)*\Z/}, uniqueness: { case_sensitive: false }
    # Add validations for the email address format
	validates_uniqueness_of :email, case_sensitive: false
	validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }

	after_create :send_admin_mail

	def send_admin_mail
		UserMailer.send_welcome_email(self).deliver_later
	end

	def self.from_omniauth(access_token)
		data = access_token.info
		user = User.where(email: data['email']).first

		# Uncomment the section below if you want users to be created if they don't exist
		unless user
			generated_password = Devise.friendly_token.first(10)
			full_name = data['name']
			username = data['name'].parameterize + "-" + Devise.friendly_token[0,5]
			email = data['email']
			image = data['image']
			provider = access_token.provider
			uid = access_token.uid

		    user = User.create(
		    	name: full_name,
		    	username: username,
		    	image: image,
				email: email,
				password: generated_password,
				provider: provider,
				uid: uid
		    )
		    # Send generated password information to user's email
			UserMailer.send_default_password_email(full_name, email, generated_password).deliver_now
		end
		user
	end

	def delete_access_token
		@graph ||= Koala::Facebook::API.new(auth.credentials.token)
		@graph.delete_connections(auth.uid, "permissions")
	end
end
