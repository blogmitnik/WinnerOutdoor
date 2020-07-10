class NewslettersController < ApplicationController
	skip_before_action :authenticate_user!
	before_action :set_newsletter, only: [:destroy]

	def create
	  	if Newsletter.find_by_email(params[:newsletter]['email'])
	  	  flash[:alert] = "Email is already subscribed!"
	      redirect_to root_path
	  	else
	  		@newsletter = Newsletter.create(newsletter_params)
			if @newsletter.save
				flash[:notice] = "Thanks for subscription! Your email is now in the mailing list"
				redirect_to root_path
			else
				flash[:alert] = "Something went wrong! Pleaes try again later..."
	      		redirect_to root_path
			end
	    end
	end

	private

	def set_newsletter
		@newsletter = Newsletter.find(params[:id])
	end

	def newsletter_params
		params.require(:newsletter).permit(:name, :email)
	end
end
