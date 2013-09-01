require 'test_helper'

class SitemapsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get languages" do
    get :languages
    assert_response :success
  end

  test "should get snippets" do
    get :snippets
    assert_response :success
  end

end
