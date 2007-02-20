#          Copyright (c) 2006 Michael Fellinger m.fellinger@gmail.com
# All files in this distribution are subject to the terms of the Ruby license.

require 'spec/spec_helper'

include Ramaze

class TCAuthHelperController < Controller
  helper :auth

  def index
    self.class.name
  end

  def session_inspect
    session.inspect
  end

  def secured
    "Secret content"
  end
  pre :secured, :login_required
end

class TCAuthHashHelperController < TCAuthHelperController
  trait :auth_table => {
      'manveru' => '5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8'
    }
end

class TCAuthMethodHelperController < TCAuthHelperController
  trait :auth_table => :auth_table

  def auth_table
    { 'manveru' => '5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8' }
  end
end

class TCAuthLambdaHelperController < TCAuthHelperController
  trait :auth_table => lambda{
      { 'manveru' => '5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8' }
    }
end

context "StackHelper" do
  ramaze
  [
    TCAuthHashHelperController,
    TCAuthMethodHelperController,
    TCAuthLambdaHelperController
  ].each do |controller|
    ctx = Context.new('/', Global.mapping.invert[controller])

    specify "checking security" do
      ctx.get('/secured').should == ''
      ctx.post('/login', 'username' => 'manveru', 'password' => 'password')
      ctx.get('/secured').should == 'Secret content'
      ctx.get('/logout')
      ctx.get('/secured').should == ''
    end
  end
end