class Api::V1::UsersController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  def index
    data = User.all.select(:id,:username, :picture)
    results = Array.new()
    data.each do |row|
      results.push({id: row['id'], username: row['username'], picture: row['picture']})
    end
    render json: results
  end
  
  def show
    user_id = params[:id]
    data = User.select(:id, :username, :picture).find(user_id)
    result = {id: data['id'],username: data['username'], picture: data['picture']}
    render json: result
  end
  
  def create
    param_username = params[:username]
    user = User.create(username: "#{param_username}")
    
    render json: {username: user['username'], id: user['id'], message: "User has been created successfully." }
  end
  
  def update
    param_username = params[:username]
    param_password = params[:password]
    param_picture = params[:picture]
    param_id = params[:id].to_i
    ret = validate_user_update
    if ret[:result]
      user = User.find_by(id: param_id)
      logger.debug(user['salt']==nil)
        if user['salt'] == nil
          salt = BCrypt::Engine.generate_salt
          encrypted_password = BCrypt::Engine.hash_secret(param_password, salt)
          user.update(username: param_username, picture: param_picture, password: encrypted_password, salt:salt)
        else
          salt = user['salt']
          encrypted_password = BCrypt::Engine.hash_secret(param_password, salt)
          user.update(username: param_username, picture: param_picture, password: encrypted_password)
        end
        new_username = user['username']
        new_picture = user['picture']
        render json: {username: new_username, picture: new_picture, id: user['id'], message: "User has been updated successfully." }
    else
      render json: ret
    end
  end
  
  def destroy
    
    param_id = params[:id]
    user = User.find_by(id: param_id)
    user.destroy()
    render json: {id: user['id'], message: "User has been deleted successfully." }
  end

  def update_password
    render json: {message: "Password has been updated successfully." }
  end
  
  private def validate_user_update
    param_username = params[:username]
    param_id = params[:id].to_i
    if param_username != nil
        data = User.where(username: param_username)
        for u in data
          if u.id != param_id.to_i && u.username == param_username
            return {result: false, message: "Username #{param_username} already exists."}
          end
        end
    end
    return {result: true}
  end
end