require "net/http"
require "hpricot"
require "uri"
require File.join(File.join(File.join(File.dirname(__FILE__), "controllers"), "admin"), "tweets")
require File.join(File.join(File.join(File.dirname(__FILE__), "controllers"), "admin"), "twitter_accounts")
require File.join(File.join(File.dirname(__FILE__), "models"), "tweet")
require File.join(File.join(File.dirname(__FILE__), "models"), "twitter_account")

Merb::Router.prepend do |r|
  r.namespace :admin do |admin|
    admin.resources :tweets
    admin.resources :twitter_accounts
    admin.match('/twitter_accounts/:id/scan').to(:controller => 'twitter_accounts', :action => 'scan').name(:scan_admin_twitter_account)
  end
end

Hooks::Menu.add_menu_item "Tweets", "/admin/tweets"

Articles.after nil, :only => [:index, :show] do
    TwitterAccount.all.each { |account| account.scan if account.out_of_date? }
end

ArticlesPresenter.before :prepare do
  @collection.concat(Tweet.all.to_a)
end

# FIXME
# Usage of slices should render this line unnecessary (I think)
Articles.include_plugin_views(__FILE__)