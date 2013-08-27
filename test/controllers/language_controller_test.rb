require 'test_helper'

class LanguageControllerTest < ActionController::TestCase
  test "should get archive" do
    get :archive
    assert_response :success
  end

end
