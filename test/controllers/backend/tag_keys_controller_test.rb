require 'test_helper'

class Backend::TagKeysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_tag_key = admin_tag_keys(:one)
  end

  test "should get index" do
    get admin_tag_keys_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_tag_key_url
    assert_response :success
  end

  test "should create admin_tag_key" do
    assert_difference('Admin::TagKey.count') do
      post admin_tag_keys_url, params: { admin_tag_key: { catg_id: @admin_tag_key.catg_id, name: @admin_tag_key.name } }
    end

    assert_redirected_to admin_tag_key_url(Admin::TagKey.last)
  end

  test "should show admin_tag_key" do
    get admin_tag_key_url(@admin_tag_key)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_tag_key_url(@admin_tag_key)
    assert_response :success
  end

  test "should update admin_tag_key" do
    patch admin_tag_key_url(@admin_tag_key), params: { admin_tag_key: { catg_id: @admin_tag_key.catg_id, name: @admin_tag_key.name } }
    assert_redirected_to admin_tag_key_url(@admin_tag_key)
  end

  test "should destroy admin_tag_key" do
    assert_difference('Admin::TagKey.count', -1) do
      delete admin_tag_key_url(@admin_tag_key)
    end

    assert_redirected_to admin_tag_keys_url
  end
end
