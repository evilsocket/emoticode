object false

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
  node(:pages) { |m| Source.public.count.to_f / @per_page }
  node(:per_page) { |m| @per_page }
end
