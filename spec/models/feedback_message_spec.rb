require "spec_helper"

describe FeedbackMessage do
  it "validates the presence of name, email and content" do
    feedback_message = FeedbackMessage.new
    %w[name email content].each do |attr|
      feedback_message.should have(1).error_on(attr)
    end
  end
end
