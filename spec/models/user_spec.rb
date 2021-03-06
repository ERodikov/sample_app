require 'spec_helper'

describe User do
  
  before do
  	@user = User.new(name:"Eugene Rodikov", email:"e.rodikov@gmail.com", password:"testpass", password_confirmation:"testpass")
  end

  subject{ @user }

  it{ should respond_to(:name) }
  it{ should respond_to(:email) }
  it{ should respond_to(:password_digest) }
  it{ should respond_to(:password) }
  it{ should respond_to(:password_confirmation) }
  it{ should respond_to(:remember_token) }
  it{ should respond_to(:authenticate) }


  it{ should be_valid }

  describe "When name is not present" do
  	before {@user.name = " "}
  	it {should_not be_valid }
  end

  describe "When email is not presents" do
  	before { @user.email = " "}
  	it { should_not be_valid }
  end

  describe "When name is too long" do
  	before { @user.name = "a" * 51 }
  	it { should_not be_valid }
  end

  describe "When password is too long" do
  	before{ @user.password = @user.password_confirmation = "a" * 5 }
  	it{ should_not be_valid}
  end

  describe "When email format is invalid" do
  	it "should be valid" do
  		addresses = %w[user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com foo@bar_baz.com]
  		addresses.each do |invalid_address|
  			@user.email = invalid_address
  			@user.should_not be_valid
  		end
  	end
  end

describe "When email format is valid" do
	it "should be valid" do
		addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
		addresses.each do |valid_address| 
			@user.email = valid_address
			@user.should be_valid
		end
	end
end

describe "When email address is already taken" do
	before do
		user_clone = @user.dup
		user_clone.save	
	end
	it {should_not be_valid}
end

describe "When password isn't present" do
	before{ @user.password =  @user.password_confirmation = " "}
	it{ should_not be_valid}
end

describe "When password doesn't match password_confirmation" do
	before{ @user.password_confirmation = "testpassword1"}
	it{ should_not be_valid}
end

describe "When password confirmation is null" do
	before{ @user.password_confirmation = nil}
	it{ should_not be_valid} 
end

describe "return value of authenticate method" do
	before do
		@user.password = @user.password_confirmation = "password"
		@user.save
	end	
	let(:found_user) { User.find_by_email(@user.email) }

	describe "with valid password" do
		it{ should == found_user.authenticate(@user.password) }
	end 

	describe "with invalid password" do
		let(:user_for_invalid_password) { found_user.authenticate("blablabla") }
		it{ should_not == user_for_invalid_password}
		specify{ user_for_invalid_password.should be_false}
	end
end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

end
