require 'test_helper'

class InteractionsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:interactions)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_interaction
    assert_difference('Interaction.count') do
      post :create, :interaction => { }
    end

    assert_redirected_to interaction_path(assigns(:interaction))
  end

  def test_should_show_interaction
    get :show, :id => interactions(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => interactions(:one).id
    assert_response :success
  end

  def test_should_update_interaction
    put :update, :id => interactions(:one).id, :interaction => { }
    assert_redirected_to interaction_path(assigns(:interaction))
  end

  def test_should_destroy_interaction
    assert_difference('Interaction.count', -1) do
      delete :destroy, :id => interactions(:one).id
    end

    assert_redirected_to interactions_path
  end
end
