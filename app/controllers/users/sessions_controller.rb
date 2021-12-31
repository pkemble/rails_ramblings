class Users::SessionsController < Devise::SessionsController
 
  def create
    self.resource = resource_class.find_for_authentication(sign_in_params.except(:password, :otp_response_code))
    if resource
      if resource.active_for_authentication?
        if resource && resource.otp_module_disabled?
          continue_sign_in(resource, resource_name)
        elsif resource && resource.otp_module_enabled?
          if params[:user][:otp_response_code].present?
            if resource.authenticate_otp(params[:user][:otp_response_code])
              sign_in(resource, scope: :user)
              continue_sign_in(resource, resource_name)
            else
              if resource.otp_counter < 5
                resource.increment!(:otp_counter)
                render 'two_factors_authentication' and sign_out(resource)
              end
            end
          else
            # wrong password or failed login should get back to login page
            if resource.valid_password?(params[:user][:password])
              render 'two_factors_authentication' and sign_out(resource)
            else
              sign_out(resource)
              respond_with resource, location: new_user_session_path 
            end
          end    
        end
      end
    end
  end
  
  private
  
  def continue_sign_in(resource, resource_name)
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in)
    sign_in(resource_name, resource)
    resource.update_column(:last_action_at,Time.now)
    yield resource if block_given?
    if  params[:redirect_to_path].present?
      respond_with resource, location: params[:redirect_to_path]
    else
      respond_with resource, location: after_sign_in_path_for(resource)
    end
  end
  
end