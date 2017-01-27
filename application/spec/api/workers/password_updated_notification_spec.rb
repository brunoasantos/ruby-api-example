require 'spec_helper'

describe Api::Workers::PasswordUpdatedNotification do
  include Mail::Matchers

  it 'send an email to the user' do
    Mail::TestMailer.deliveries.clear 
    user = create(:user, email: 'foo@example.com')
    subject.perform(user.id)
    expect have_sent_email.from(SYSTEM_EMAIL)
                            .to('foo@example.com')
                            .with_subject('Password update')
                            .with_body('Your password was successfully updated')
  end

  it 'fails when user is not found' do
    expect { subject.perform(0) }.to raise_error(Api::Exceptions::NotFoundError)
  end
end
