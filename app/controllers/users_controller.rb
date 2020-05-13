class UsersController < ApplicationController
	def show
		@user = User.find(params[:id])
    @qr = RQRCode::QRCode.new(@user.provisioning_uri("the marble notebook"), :size => 10, :level => :h )
	end

	def new
		@user = User.new
	end
	
	def create
	  @user = User.new(user_params)
    if @user.save(user_params)
      log_in @user
      flash[:success] = "welcome"
      redirect_to posts_path
    else
      render 'new'
    end
	end
  
  def edit
    @user = @current_user
    if @user.save(user_params)
      flash[:success] = "saved"
      redirect_to posts_path
    end
  end
	
	private
	 def user_params
	   params.require(:user).permit(:username, :email, :password, :password_confirmation)
	 end
end
