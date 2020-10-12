require "date"
require "yaml"

departments_file = File.open("data/french_departments.yml")
departments_text = departments_file.read

DEPARMENT_CODES = YAML.load(departments_text)
GENDER_CODES = {
  "1" => "man",
  "2" => "woman"
}

def ssn_key_valid?(ssn_number)
  key = ssn_number[-2..-1].to_i
  ssn_without_key = ssn_number[0..-3].delete(" ").to_i
  remainder_of_calculation = (97 - ssn_without_key) % 97
  remainder_of_calculation == key
end

def french_ssn_info(ssn_number)
  french_ssn_pattern = /^(?<gender_code>[12])(?<year_of_birth>\d{2})(?<month_of_birth>0[1-9]|1[0-2])(?<department_of_birth>\d{2})\d{8}$/
  ssn_number_without_spaces = ssn_number.delete(" ")
  ssn_data = ssn_number_without_spaces.match(french_ssn_pattern)

  if ssn_data && ssn_key_valid?(ssn_number)
    gender = GENDER_CODES[ssn_data[:gender_code]]
    year = "19#{ssn_data[:year_of_birth]}"
    month = Date::MONTHNAMES[ssn_data[:month_of_birth].to_i]
    department = DEPARMENT_CODES[ssn_data[:department_of_birth]]

    return "a #{gender}, born in #{month}, #{year} in #{department}."
  else
    return "The number is invalid"
  end
end
