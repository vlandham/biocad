require 'test_helper'

class MicroarraysControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:microarrays)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_microarray
    assert_difference('Microarray.count') do
      post :create, :microarray => { }
    end

    assert_redirected_to microarray_path(assigns(:microarray))
  end

  def test_should_show_microarray
    get :show, :id => microarrays(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => microarrays(:one).id
    assert_response :success
  end

  def test_should_update_microarray
    put :update, :id => microarrays(:one).id, :microarray => { }
    assert_redirected_to microarray_path(assigns(:microarray))
  end

  def test_should_destroy_microarray
    assert_difference('Microarray.count', -1) do
      delete :destroy, :id => microarrays(:one).id
    end

    assert_redirected_to microarrays_path
  end
end
