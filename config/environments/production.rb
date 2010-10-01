config.cache_classes = true
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching = true
config.action_view.cache_template_loading = true
config.action_mailer.raise_delivery_errors = true

ActionMailer::Base.delivery_method = :sendmail

ActionMailer::Base.sendmail_settings = {
:location       => '/usr/sbin/sendmail',
:arguments      => '-i -t'
}