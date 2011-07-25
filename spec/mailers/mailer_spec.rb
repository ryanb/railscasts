require "spec_helper"

describe Mailer do
  describe "feedback" do
    let(:message) { Factory(:feedback_message) }
    let(:mail) { Mailer.feedback(message) }

    it "includes message with name and email" do
      mail.subject.should eq("RailsCasts Feedback from #{message.name}")
      mail.to.should eq(["feedback@railscasts.com"])
      mail.from.should eq([message.email])
      mail.body.encoded.should match(message.content)
    end
  end

  describe "comment_response" do
    let(:user) { Factory(:user) }
    let(:comment) { Factory(:comment) }
    let(:mail) { Mailer.comment_response(comment, user) }

    it "includes comment content and link to comment page" do
      mail.subject.should eq("Comment Response on RailsCasts")
      mail.to.should eq([user.email])
      mail.from.should eq(["noreply@railscasts.com"])
      mail.body.encoded.should include(comment.content)
      mail.body.encoded.should include(episode_url(comment.episode, :view => "comments"))
      mail.body.encoded.should include(unsubscribe_url(user.generated_unsubscribe_token))
    end
  end
end
