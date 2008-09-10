require 'test_helper'

class GenesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:genes)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_gene
    assert_difference('Gene.count') do
      post :create, :gene => { }
    end

    assert_redirected_to gene_path(assigns(:gene))
  end

  def test_should_show_gene
    get :show, :id => genes(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => genes(:one).id
    assert_response :success
  end

  def test_should_update_gene
    put :update, :id => genes(:one).id, :gene => { }
    assert_redirected_to gene_path(assigns(:gene))
  end

  def test_should_destroy_gene
    assert_difference('Gene.count', -1) do
      delete :destroy, :id => genes(:one).id
    end

    assert_redirected_to genes_path
  end
end
