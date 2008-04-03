require File.join(File.join(File.dirname(__FILE__), "controllers"), "comments")
require File.join(File.join(File.dirname(__FILE__), "models"), "comment")

Hooks::Routing.add_route do
  { :url => "/comments/create", :controller => "Comments", :action => "create" }
end

Hooks::View.register_view do
  { :name => "after_post", :partial => "comments" }
end

Hooks::View.register_view do
  { :name => "after_post_in_list", :partial => "comments" }
end