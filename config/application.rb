require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)


module NeverCoin
  class Application < Rails::Application
    config.autoload_paths += Dir[Rails.root.join('lib')]

    config.assets.precompile += %w(
      skeuocard.js card-flip-arrow.png card-front-background.png card-invalid-indicator.png
      card-valid-anim.gif card-valid-indicator.png error-pointer.png issuers/visa-chase-sapphire.png
      issuers/visa-simple-front.png products/mastercard-front.png products/visa-back.png
      products/visa-front.png products/discover-front.png products/unionpay-front.png
      products/generic-back.png products/generic-front.png products/amex-front.png 
      products/dinersclubintl-front.png products/jcb-front.png)
    config.assets.precompile += %w(ocra-webfont.woff ocra-webfont.ttf)
  end
end

require 'configatron'
Configatron::Rails.init
