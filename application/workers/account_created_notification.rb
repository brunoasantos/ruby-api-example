class Api
  module Workers
    class AccountCreatedNotification
      include Sidekiq::Worker

      def perform(user_id)
        user = Models::User[user_id]
        raise 'User not found' unless user

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
