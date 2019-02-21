class SessionsController < ApplicationController
  def new
  end

  def create
    byebug
		user = User.find_by(email: params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
			log_in user
			params[:session][:remember_me] == '1' ? remember(user) : forget(user)
			redirect_to posts_path
		else
			flash.now[:danger] = 'invalid email/password!'
			render 'new'
		end
  end

	def destroy
		log_out if logged_in?
		redirect_to login_path
	end
end
