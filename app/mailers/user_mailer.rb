class UserMailer < ApplicationMailer
	default from: 'admin@livereco.com'

	def send_welcome_email(user)
		@user = user
		mail(:to => @user.email, :subject => "Welcome to Livereco")
	end

	def send_default_password_email(full_name, email, password)
		@full_name = full_name
		@email = email
		@password = password
		mail(:to => @email, :subject => "Check Your default password now")
	end

	def newsletter_mailer
	    @newsletter = Newsletter.all
	    emails = @newsletter.collect(&:email)
	    emails.each do |email|
			new_request(email).deliver
		end
	end

	def new_request(email)
		mail(to: email, subject: 'Liverecot Weekly Newsletter!')
	end
end
