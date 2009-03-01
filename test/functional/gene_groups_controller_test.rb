require 'test_helper'

class GeneGroupsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:gene_groups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create gene_group" do
    assert_difference('GeneGroup.count') do
      post :create, :gene_group => { }
    end

    assert_redirected_to gene_group_path(assigns(:gene_group))
  end

  test "should show gene_group" do
    get :show, :id => gene_groups(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => gene_groups(:one).id
    assert_response :success
  end

  test "should update gene_group" do
    put :update, :id => gene_groups(:one).id, :gene_group => { }
    assert_redirected_to gene_group_path(assigns(:gene_group))
  end

  test "should destroy gene_group" do
    assert_difference('GeneGroup.count', -1) do
      delete :destroy, :id => gene_groups(:one).id
    end

    assert_redirected_to gene_groups_path
  end
end
