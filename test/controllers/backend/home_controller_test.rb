require 'test_helper'

class Backend::HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_home_index_url
    assert_response :success
  end

end
