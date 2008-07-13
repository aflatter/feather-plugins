module Admin
  class Tweets < Base
    include_plugin_views __FILE__

    def index
      @tweets = Tweet.all
      display @tweets
    end

    def delete
      @tweet = Tweet[params[:id]]
      @tweet.destroy
      expire_index
      redirect url(:admin_tweets)
    end

  end
end