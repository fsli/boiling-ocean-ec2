class Api::V1::LoginController < ApplicationController
  skip_before_filter  :verify_authenticity_token
      def index
        if session[:username]
          render json: {loginStatus: true, token: session[:token]}
        else
          render json: [loginStatus: false]
        end
      end
      
      def show
        render :nothing => true, :status => :method_not_allowed
  
      end
        
      def create
        ret = validate_login
        if ret[:result]
          param_username = params[:username]
          param_password = params[:password]
          user = User.find_by(username: param_username)
          result = true
          if user
            salt = user['salt']
            password1 = user['password']
            password2 = BCrypt::Engine.hash_secret(param_password, salt)
            if password1 == password2
              token = SecureRandom.urlsafe_base64
              session[:username] = param_username
              session[:token] = token
            else
              result = false
            end
          else
             result = false
          end
          if result
             render json: {result: result, token: session[:token], message: "User is already logged in."}
          else
             render json: {result: result, message: "Cannot match username and password."}
          end
        else
          render json: ret
        end
       
      end
      
      def update
        render :nothing => true, :status => :method_not_allowed
      end
      
      def destroy
        reset_session
        render json: {result: true, message: "User  has logged out."}
      end
      
      private def validate_login
        param_username = params[:username]
        param_password = params[:password]
        if !param_username
          ret = {result: false, message: 'username is required!'}
          return ret
        end 
        if !param_password
          ret = {result: false, message: 'password is required!'}
          return ret
        end 
        return {result: true}
      end
end
