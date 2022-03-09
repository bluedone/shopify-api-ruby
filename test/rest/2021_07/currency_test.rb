# typed: strict
# frozen_string_literal: true

$VERBOSE = nil
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require "minitest/autorun"
require "webmock/minitest"

require "shopify_api"
require_relative "../../test_helper"

class Currency202107Test < Test::Unit::TestCase
  def setup
    super

    test_session = ShopifyAPI::Auth::Session.new(id: "id", shop: "test-shop.myshopify.io", access_token: "this_is_a_test_token")
    ShopifyAPI::Context.activate_session(test_session)
    modify_context(api_version: "2021-07")
  end

  def teardown
    super

    ShopifyAPI::Context.deactivate_session
  end

  sig do
    void
  end
  def test_1()
    stub_request(:get, "https://test-shop.myshopify.io/admin/api/2021-07/currencies.json")
      .with(
        headers: {"X-Shopify-Access-Token"=>"this_is_a_test_token", "Accept"=>"application/json"},
        body: {}
      )
      .to_return(status: 200, body: JSON.generate({"currencies" => [{"currency" => "CAD", "rate_updated_at" => "2018-01-23T19:01:01-05:00", "enabled" => true}, {"currency" => "EUR", "rate_updated_at" => "2018-01-23T19:01:01-05:00", "enabled" => true}, {"currency" => "JPY", "rate_updated_at" => "2018-01-23T19:01:01-05:00", "enabled" => true}]}), headers: {})

    ShopifyAPI::Currency.all()

    assert_requested(:get, "https://test-shop.myshopify.io/admin/api/2021-07/currencies.json")
  end

end
