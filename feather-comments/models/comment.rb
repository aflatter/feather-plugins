class Comment < DataMapper::Base
  property :article_id, :integer
  property :name, :string
  property :website, :string
  property :comment, :text
  property :created_at, :datetime
  
  validates_presence_of :name, :website, :comment
  
  def self.all_for_post(article_id, method = :all)
    self.send(method, {:article_id => article_id, :order => "created_at DESC"})
  end

end