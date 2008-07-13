module Admin
  class TwitterAccounts < Base
    include_plugin_views __FILE__
    before :find_twitter_account, :only => [:scan, :show, :edit, :delete, :update]

    def index
      @twitter_accounts = TwitterAccount.all
      display @twitter_accounts
    end
    
    def new
      @twitter_account = TwitterAccount.new
      display @twitter_account
    end
    
    def create
      @twitter_account = TwitterAccount.new(params[:twitter_account])
      if @twitter_account.save
        redirect_back_or_default(url(:admin_twitter_accounts))
      else
        render :new
      end
    end
    
    def scan
      @twitter_account.scan
      redirect url(:admin_twitter_accounts)
    end

    def show
      display @twitter_account
    end

    def edit
      display @twitter_account
    end

    def update
      res = true
      res = @twitter_account.update_attributes(params[:twitter_account]) unless params[:twitter_account].nil?
      if res
        @twitter_account.scan if params[:force] && params[:force] == "true" && @twitter_account.out_of_date?
        expire_index
        redirect url(:admin_twitter_accounts, @twitter_account)
      else
        render :edit
      end
    end
    
    def delete
      @twitter_account.destroy
      redirect url(:admin_twitter_accounts)
    end
    
    private
      def find_twitter_account
        @twitter_account = TwitterAccount.get(params[:id])
      end
  end
end