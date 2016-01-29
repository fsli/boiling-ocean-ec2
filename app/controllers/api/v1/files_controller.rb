class Api::V1::FilesController < ApplicationController
    skip_before_filter  :verify_authenticity_token
    def index
      
      render :nothing => true, :status => :method_not_allowed

    end
    
    def show
      render :nothing => true, :status => :method_not_allowed

    end
      
    def create
      name = SecureRandom.urlsafe_base64
      content_type = params[:fileUpload].content_type
      extension = get_file_extension(content_type)
      if extension == nil
        render json: {message: "Content type #{content_type} is not allowed."}
        return
      end
      fullname = name + '.' + extension
      directory = "public/upload"
      path = File.join(directory, fullname)
      url = "/upload/" + fullname
      File.open(path, "wb") { |f| f.write(params[:fileUpload].read) }
      render json: {fullname: fullname, url: url, message: "Image has been uploaded successfully." }
    end
    
    def update
      render :nothing => true, :status => :method_not_allowed
    end
    
    def destroy
      render :nothing => true, :status => :method_not_allowed
    end
    
    private def get_file_extension (content_type)
      extension = nil
      if content_type == "image/png"
        extension = "png"
      elsif content_type == "image/jpeg" || content_type == "image/jpg"
        extension = "jpg"
      end 
      return extension
    end
end
