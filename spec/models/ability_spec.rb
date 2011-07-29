require "spec_helper"
require "cancan/matchers"

describe "Ability" do
  describe "as guest" do
    before(:each) do
      @ability = Ability.new(nil)
    end

    it "can only view and create users" do
      @ability.should be_able_to(:login, :users)
      @ability.should be_able_to(:show, :users)
      @ability.should be_able_to(:create, :users)
      @ability.should be_able_to(:unsubscribe, :users)
      @ability.should_not be_able_to(:update, :users)
    end

    it "can only view episodes which are published" do
      @ability.should be_able_to(:index, :episodes)
      @ability.should be_able_to(:show, Factory.build(:episode, :published_at => 2.days.ago))
      @ability.should_not be_able_to(:show, Factory.build(:episode, :published_at => 2.days.from_now))
      @ability.should_not be_able_to(:create, :episodes)
      @ability.should_not be_able_to(:update, :episodes)
      @ability.should_not be_able_to(:destroy, :episodes)
    end

    it "can access any info pages" do
      @ability.should be_able_to(:access, :info)
    end

    it "can create feedback messages" do
      @ability.should be_able_to(:create, :feedback_messages)
    end

    it "cannot even create comments" do
      @ability.should_not be_able_to(:create, :comments)
      @ability.should_not be_able_to(:update, :comments)
      @ability.should_not be_able_to(:destroy, :comments)
      @ability.should_not be_able_to(:index, :comments)
    end
  end

  describe "as normal user" do
    before(:each) do
      @user = Factory(:user)
      @ability = Ability.new(@user)
    end

    it "can update himself, but not other users" do
      @ability.should be_able_to(:show, User.new)
      @ability.should be_able_to(:login, :users)
      @ability.should be_able_to(:logout, :users)
      @ability.should be_able_to(:create, :users)
      @ability.should be_able_to(:update, @user)
      @ability.should_not be_able_to(:update, User.new)
      @ability.should_not be_able_to(:ban, :users)
    end

    it "can create comments and update/destroy within 15 minutes if he owns them" do
      @ability.should be_able_to(:create, :comments)
      @ability.should be_able_to(:update, Factory(:comment, :user => @user, :created_at => 10.minutes.ago))
      @ability.should_not be_able_to(:update, Factory(:comment, :user => @user, :created_at => 20.minutes.ago))
      @ability.should be_able_to(:destroy, Factory(:comment, :user => @user, :created_at => 10.minutes.ago))
      @ability.should_not be_able_to(:destroy, Factory(:comment, :user => @user, :created_at => 20.minutes.ago))
      @ability.should_not be_able_to(:destroy, Factory(:comment, :user => User.new, :created_at => 10.minutes.ago))
    end

    it "can create feedback messages" do
      @ability.should be_able_to(:create, :feedback_messages)
    end

    it "can only view episodes which are published" do
      @ability.should be_able_to(:index, :episodes)
      @ability.should be_able_to(:show, Factory.build(:episode, :published_at => 2.days.ago))
      @ability.should_not be_able_to(:show, Factory.build(:episode, :published_at => 2.days.from_now))
      @ability.should_not be_able_to(:create, :episodes)
      @ability.should_not be_able_to(:update, :episodes)
      @ability.should_not be_able_to(:destroy, :episodes)
    end

    it "can access any info pages" do
      @ability.should be_able_to(:access, :info)
    end
  end

  describe "as banned user" do
    before(:each) do
      @user = Factory(:user, :banned_at => Time.now)
      @ability = Ability.new(@user)
    end

    it "cannot create or update comments" do
      @ability.should_not be_able_to(:create, :comments)
      @ability.should_not be_able_to(:update, :comments)
    end
  end

  describe "as moderator" do
    before(:each) do
      @user = Factory(:user, :moderator => true)
      @ability = Ability.new(@user)
    end

    it "can ban users" do
      @ability.should be_able_to(:ban, :users)
    end

    it "can revert versions" do
      @ability.should be_able_to(:revert, :versions)
    end

    it "can list, update and destroy any comments" do
      @ability.should be_able_to(:update, Factory(:comment, :user => User.new, :created_at => 20.minutes.ago))
      @ability.should be_able_to(:destroy, Factory(:comment, :user => User.new, :created_at => 20.minutes.ago))
      @ability.should be_able_to(:index, :comments)
    end

    it "can view episodes which are not yet published" do
      @ability.should be_able_to(:index, Factory.build(:episode, :published_at => 2.days.from_now))
      @ability.should be_able_to(:show, Factory.build(:episode, :published_at => 2.days.from_now))
    end

    it "can update episode show notes, nothing else" do
      @ability.should be_able_to(:update, :episodes, :notes)
      @ability.should_not be_able_to(:update, :episodes, :name)
      @ability.should_not be_able_to(:update, :episodes, :name)
      @ability.should_not be_able_to(:destroy, :episodes)
    end
  end

  describe "as admin" do
    it "can access all" do
      user = Factory(:user, :admin => true)
      ability = Ability.new(user)
      ability.should be_able_to(:access, :all)
    end
  end
end
