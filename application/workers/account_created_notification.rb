class Api
  module Workers
    class AccountCreatedNotification
      include Sidekiq::Worker

      def perform(user_id)
        user = Services::GetUser.call(user_id)
        mail = ::Mail.new do
          from    SYSTEM_EMAIL
          to      user.email
          subject 'Account created'
          body    'Your account was successfully created'
        end

        mail.deliver!
      end
    end
  end
end
