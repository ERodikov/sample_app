FactoryGirl.define do
  factory :user do
    name     "Eugene Rodikov"
    email    "e.rodikov@gmail.com"
    password "1234567890"
    password_confirmation "1234567890"
  end
end