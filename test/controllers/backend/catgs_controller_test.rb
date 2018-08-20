require 'test_helper'

class Backend::CatgsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @catg = catgs(:one)
  end

  test "should get index" do
    get catgs_url
    assert_response :success
  end

  test "should get new" do
    get new_catg_url
    assert_response :success
  end

  test "should create catg" do
    assert_difference('Catg.count') do
      post catgs_url, params: { catg: { name: @catg.name, seq: @catg.seq } }
    end

    assert_redirected_to catg_url(Catg.last)
  end

  test "should show catg" do
    get catg_url(@catg)
    assert_response :success
  end

  test "should get edit" do
    get edit_catg_url(@catg)
    assert_response :success
  end

  test "should update catg" do
    patch catg_url(@catg), params: { catg: { name: @catg.name, seq: @catg.seq } }
    assert_redirected_to catg_url(@catg)
  end

  test "should destroy catg" do
    assert_difference('Catg.count', -1) do
      delete catg_url(@catg)
    end

    assert_redirected_to catgs_url
  end
end
