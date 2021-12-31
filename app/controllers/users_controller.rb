class UsersController < ApplicationController
  def activate_2fa
    qrcode = RQRCode::QRCode.new(current_user.provisioning_uri(nil, issuer: 'your-app-url.com'), :size => 12, :level => :h)
    @svg = qrcode.as_svg(offset: 0, color: '000', 
                    shape_rendering: 'crispEdges', 
                    module_size: 4)   
    respond_to :html
  end

  def activate_2fa_update
    if secure_params.key?(:otp_response_code)
      if @user.authenticate_otp(secure_params[:otp_response_code])
        @user.otp_module_enabled!
        # do something here
      else
        # do something here
      end
    else
      #turn off 2FA
      @user.otp_module_disabled!
    end
  end
end
