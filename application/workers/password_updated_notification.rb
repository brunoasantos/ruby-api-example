class Api
  module Workers
    class PasswordUpdatedNotification
      include Sidekiq::Worker

      def perform(user_id)
        user = Services::GetUser.call(user_id)
        mail = ::Mail.new do
          from    SYSTEM_EMAIL
          to      user.email
          subject 'Password updated'
          body    'Your password was successfully updated'
        end

        mail.deliver!
      end
    end
  end
end
