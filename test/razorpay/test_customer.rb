require 'test_helper'
require 'razorpay/customer'
require 'razorpay/collection'

module Razorpay
  # Tests for Razorpay::Customer
  class RazorpayCustomerTest < Minitest::Test
    def setup
      @customer_id = 'cust_6vRXClWqnLhV14'

      # Any request that ends with customers/customer_id
      stub_get(%r{customers/#{@customer_id}$}, 'fake_customer')
      stub_get(%r{customers$}, 'customer_collection')
    end

    def test_customer_should_be_defined
      refute_nil Razorpay::Customer
    end

    def test_customer_should_be_created
      stub_post(/customers$/, 'fake_customer', 'email=test%40razorpay.com&contact=9876543210')
      customer = Razorpay::Customer.create email: 'test@razorpay.com', contact: '9876543210'

      assert_equal 'test@razorpay.com', customer.email
      assert_equal '9876543210', customer.contact
    end

    def test_edit_customer
      new_email="test.edit@razorpay.com"
      stub_put(%r{customers/#{@customer_id}$}, 'fake_customer_edited', "email=#{new_email}")
      customer = Razorpay::Customer.edit(@customer_id, "email=#{new_email}")
      assert_instance_of Razorpay::Customer, customer
      assert_equal customer.email, new_email
    end

    def test_fetch_all_customers
      customers = Razorpay::Customer.all
      assert_instance_of Razorpay::Collection, customers
    end

    def test_fetch_specific_customer
      customer = Razorpay::Customer.fetch(@customer_id)
      assert_instance_of Razorpay::Customer, customer
      assert_equal customer.id, @customer_id
    end
  end
end
