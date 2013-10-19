object false

child(@user) do
  attributes :username, :created_at, :avatar
  node :source_count do |u|
    u.sources.count
  end
  node :total_views do |u|
    u.sources.sum :views
  end
  child(:profile) do
    attributes :aboutme, :website
  end
end

child(@sources) do
  object @source
  attributes :id, :created_at, :title, :name, :views  
  child(:user) do
    attributes :username, :avatar
  end
  child(:language) do
    attributes :title, :name
  end
end

child(:pager) do
  node(:pages) { |m| @user.sources.public.count.to_f / @per_page }
  node(:per_page) { |m| @per_page }
end
