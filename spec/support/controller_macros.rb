module ControllerMacros
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    def it_should_require_admin_for_actions(*actions)
      actions.each do |action|
        it "#{action} action should require admin" do
          get action, :id => 1 # so routes work for those requiring id
          response.should redirect_to(root_url)
        end
      end
    end
  end
end
