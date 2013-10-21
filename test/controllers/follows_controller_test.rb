require 'test_helper'

class FollowsControllerTest < ActionController::TestCase
  setup do
    @follow = follows(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:follows)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create follow" do
    assert_difference('Follow.count') do
      post :create, follow: { follow_id: @follow.follow_id, follow_type: @follow.follow_type, user_id: @follow.user_id }
    end

    assert_redirected_to follow_path(assigns(:follow))
  end

  test "should show follow" do
    get :show, id: @follow
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @follow
    assert_response :success
  end

  test "should update follow" do
    patch :update, id: @follow, follow: { follow_id: @follow.follow_id, follow_type: @follow.follow_type, user_id: @follow.user_id }
    assert_redirected_to follow_path(assigns(:follow))
  end

  test "should destroy follow" do
    assert_difference('Follow.count', -1) do
      delete :destroy, id: @follow
    end

    assert_redirected_to follows_path
  end
end
