require "date"
require "yaml"

# We're going to learn more about this tomorrow, but the idea of the next
# 3 lines is:
# Open the file, read it as text, parse it into a hash
departments_file = File.open("data/french_departments.yml")
departments_text = departments_file.read
DEPARMENT_CODES = YAML.load(departments_text)

# The gender numbers had corresponding gender strings, so it's just natural
# to make it a dictionary (hash) representation for it
GENDER_CODES = {
  "1" => "man",
  "2" => "woman"
}

# We needed that crazy validation calculation described in the
# challenge somewhere. It's better in it's own method. :shrug:
def ssn_key_valid?(ssn_number)
  key = ssn_number[-2..-1].to_i
  ssn_without_key = ssn_number[0..-3].delete(" ").to_i
  remainder_of_calculation = (97 - ssn_without_key) % 97
  remainder_of_calculation == key
end


def french_ssn_info(ssn_number)
  # Regexes are VERY unreadable. We make them more bearable by giving them a
  # descriptive variable name. We built this in rubular to extract all the
  # data we needed.
  french_ssn_pattern = /^(?<gender_code>[12])(?<year_of_birth>\d{2})(?<month_of_birth>0[1-9]|1[0-2])(?<department_of_birth>\d{2})\d{8}$/

  # Antonio suggested we remove the spaces to make the input more consistent.
  # That's a good idea.
  ssn_number_without_spaces = ssn_number.delete(" ")

  # We match our ssn without all the spaces against the regex we created.
  ssn_data = ssn_number_without_spaces.match(french_ssn_pattern)

  # There are 2 conditions for our SSN number to be valid:
  # 1. It must match the ssn pattern (if it doesn't match it returns nil)
  # 2. It must have a valid SSN key
  # so  (1    &&      2)   must be truthy
  if ssn_data && ssn_key_valid?(ssn_number)
    # The information we have in our regex is still not the final version of
    # the data we need, so in the next 4 lines we're doing convertions.
    # 1. We use our GENDER_CODES dictionary to convert the number into words.
    gender = GENDER_CODES[ssn_data[:gender_code]]
    # 2. We convert year to 19XX because no millennial was ever born in France
    year = "19#{ssn_data[:year_of_birth]}"
    # 3. We use Date's default month names constant (an Array) to que month name
    month = Date::MONTHNAMES[ssn_data[:month_of_birth].to_i]
    # 4. We use our parsed department codes hash to get the department name
    department = DEPARMENT_CODES[ssn_data[:department_of_birth]]

    # We interpolate the converted data into our return string.
    return "a #{gender}, born in #{month}, #{year} in #{department}."
  else
    # Or return the invalid message
    return "The number is invalid"
  end
end
