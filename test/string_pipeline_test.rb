require 'test_helper'

class StringPipelineTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, StringPipeline
  end

=begin
  Before:
    create new StringPipeline
    stub a few modules

  Test:

    What does it do with no modules?

    Add modules -> was the module added?

    Add module -> remove module -> was the module removed?

    Add a simple module -> process a simple word -> was the module applied?

    Add 2 modules -> were they applied in the correct order?

    Does it collect the correct stats?

=end
end
