class Tweet
  include DataMapper::Resource
  
  property :id, Integer, :key => true, :serial => true
  property :text, String, :nullable => false, :length => 140
  property :source, String, :nullable => false, :length => 255
  property :in_reply_to, String, :length => 140
  property :username, String, :nullable => false, :length => 255
  property :created_at, DateTime, :nullable => false
  property :published_at, DateTime, :nullable => false
  
  belongs_to :twitter_account

  validates_present :text, :key => "uniq_text"
  validates_present :source, :key => "uniq_source"
  validates_present :created_at, :key => "uniq_created_at"
  
  ##
  # This returns true if the tweet is a reply to someone, false if it isn't
  def reply?
    !self.in_reply_to.nil?
  end
  
  ##
  # This returns the user that was being replied to if this was a reply
  def replying_to
    return nil unless self.reply?
    user = self.text[0...self.text.index(" ")]
    return nil unless user[0...1] == "@"
    user
  end

  ##
  # This provides a summary of the text update, if it's longer than 30 characters
  def text_summary
    summary = attribute_get(:text)
    summary = summary[(summary.index(" ") + 1)...summary.length] if summary[0...1] == "@"
    summary = (summary.length > 30 ? "#{summary[0..30]}..." : summary[0..30])
    summary
  end
  
  ##
  # This builds a direct url to the tweet
  def url
    "http://twitter.com/#{attribute_get(:username)}/statuses/#{attribute_get(:id)}"
  end
  
  def sort_value
    attribute_get(:published_at)
  end
  
  def <=>(cmp)
    case sort_value <=> cmp.sort_value
    when -1
      1
    when 1
      -1
    else
      0
    end
  end
  
end