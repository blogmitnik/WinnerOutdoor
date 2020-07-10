class UserMailer < ApplicationMailer
	default from: 'admin@winner-stock.com'

	def send_welcome_email(user)
		@user = user
		mail(:to => @user.email, :subject => "Welcome to Winner Event")
	end

	def newsletter_mailer
	    @newsletter = Newsletter.all
	    emails = @newsletter.collect(&:email)
	    emails.each do |email|
			new_request(email).deliver
		end
	end

	def new_request(email)
		mail(to: email, subject: 'Winner Event Weekly Newsletter!')
	end
end
