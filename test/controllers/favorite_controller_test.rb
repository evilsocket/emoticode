require 'test_helper'

class FavoriteControllerTest < ActionController::TestCase
  test "should get make" do
    get :make
    assert_response :success
  end

end
