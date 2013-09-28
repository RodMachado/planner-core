require 'test_helper'

class Venues::SetupListCellTest < Cell::TestCase
  test "display" do
    invoke :display
    assert_select "p"
  end
  
  test "javascript" do
    invoke :javascript
    assert_select "p"
  end
  

end
