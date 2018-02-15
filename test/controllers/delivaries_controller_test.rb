require 'test_helper'

class DelivariesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @delivary = delivaries(:one)
  end

  test "should get index" do
    get delivaries_url
    assert_response :success
  end

  test "should get new" do
    get new_delivary_url
    assert_response :success
  end

  test "should create delivary" do
    assert_difference('Delivary.count') do
      post delivaries_url, params: { delivary: { date: @delivary.date, deliver: @delivary.deliver, name: @delivary.name } }
    end

    assert_redirected_to delivary_url(Delivary.last)
  end

  test "should show delivary" do
    get delivary_url(@delivary)
    assert_response :success
  end

  test "should get edit" do
    get edit_delivary_url(@delivary)
    assert_response :success
  end

  test "should update delivary" do
    patch delivary_url(@delivary), params: { delivary: { date: @delivary.date, deliver: @delivary.deliver, name: @delivary.name } }
    assert_redirected_to delivary_url(@delivary)
  end

  test "should destroy delivary" do
    assert_difference('Delivary.count', -1) do
      delete delivary_url(@delivary)
    end

    assert_redirected_to delivaries_url
  end
end
