require 'test_helper'

class CancersControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:cancers)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_cancer
    assert_difference('Cancer.count') do
      post :create, :cancer => { }
    end

    assert_redirected_to cancer_path(assigns(:cancer))
  end

  def test_should_show_cancer
    get :show, :id => cancers(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => cancers(:one).id
    assert_response :success
  end

  def test_should_update_cancer
    put :update, :id => cancers(:one).id, :cancer => { }
    assert_redirected_to cancer_path(assigns(:cancer))
  end

  def test_should_destroy_cancer
    assert_difference('Cancer.count', -1) do
      delete :destroy, :id => cancers(:one).id
    end

    assert_redirected_to cancers_path
  end
end
