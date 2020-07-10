desc 'Send weekly newsletter email'
task weekly_newsletter_email: :environment do
  UserMailer.newsletter_mailer
end