require_relative "../french_ssn"

# Rspec code here
describe "#ssn_key_valid?" do
  it "should return true for 1 84 12 76 451 089 46" do
    actual = ssn_key_valid?("1 84 12 76 451 089 46")
    expect(actual).to eq(true)
  end

  it "should return false for 1 84 12 76 451 089 45" do
    actual = ssn_key_valid?("1 84 12 76 451 089 45")
    expect(actual).to eq(false)
  end
end

describe "#french_ssn_info" do
  it "should return the correct info for 1 84 12 76 451 089 46" do
    actual = french_ssn_info("1 84 12 76 451 089 46")
    expected = "a man, born in December, 1984 in Seine-Maritime."
    expect(actual).to eq(expected)
  end

  it "should return the invalid info for 1 84 12 76 451 089 45" do
    actual = french_ssn_info("1 84 12 76 451 089 45")
    expected = "The number is invalid"
    expect(actual).to eq(expected)
  end

  it "should say it's invalid for an invalid number" do
    actual = french_ssn_info("123")
    expected = "The number is invalid"
    expect(actual).to eq(expected)
  end
end
