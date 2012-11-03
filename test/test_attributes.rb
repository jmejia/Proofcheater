require 'test/unit'
require 'shoulda'
require_relative '../lib/proofcheater/attributes'

class TestOptions < Test::Unit::TestCase


  context "specifying key value pair" do
    should "return it" do
      @test_attribute = Proofcheater::Attribute.new({:some_key => "anything_goes"})
      assert_equal "anything_goes", @test_attribute.some_key
    end
  end

end
