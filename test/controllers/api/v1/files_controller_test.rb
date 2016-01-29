require 'test_helper'

class Api::V1::FilesControllerTest < ActionController::TestCase
  test "should get upload" do
    get :upload
    assert_response :success
  end

end
