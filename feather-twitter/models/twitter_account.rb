require 'timeout'

class TwitterAccount
  include DataMapper::Resource
  include Timeout
  
  property :id, Integer, :key => true, :serial => true
  property :username, String
  property :ignore_replies, Boolean, :nullable => false, :default => true
  property :last_scan_at, DateTime
  
  has n, :tweets
  
  after :create, :scan_if_out_of_date
  after :update, :scan_if_out_of_date
  
  def out_of_date?
    attribute_get(:last_scan_at).nil? || ((attribute_get(:last_scan_at).to_time + (60 * 30)) < Time.now)
  end
  
  def load_xml
    begin
      timeout(5) do
        return Net::HTTP.get(URI.parse("http://twitter.com/statuses/user_timeline/#{attribute_get(:username)}.xml"))
      end
    rescue Timeout::Error
      return false
    end
  end
  
  def scan_if_out_of_date
    scan if out_of_date?
  end

  ##
  # This scans for new Tweets
  def scan
    # Grab Twitter statuses as xml
    if xml = load_xml
      # Loop through statuses
      (Hpricot(xml) / "statuses" / "status").each do |status|
        # Ensure it's unique, and that we don't already have it
        if Tweet.first(:id => (status/"id").first.innerText).nil?
          # Save the new tweet
          tweet = Tweet.create(
            :id               => (status/"id").first.innerText,
            :text             => (status/"text").first.innerText,
            :source           => (status/"source").first.innerText,
            :in_reply_to      => ((status/"in_reply_to").first.nil? || (status/"in_reply_to").first.innerText == "") ? nil : (status/"in_reply_to").first.innerText,
            :username         => (status/"user"/"screen_name").first.innerText,
            :published_at     => DateTime.parse((status/"created_at").first.innerText),
            :created_at       => DateTime.now,
            :twitter_account  => self
          )
        end
      end
      # Set the last scan time
      attribute_set(:last_scan_at, DateTime.now)
      save
    else
      puts "Could not load twitter statuses for #{attribute_get(:username)}"
      return false
    end
  end

end