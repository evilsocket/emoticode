object @source
attributes :id, :created_at, :title, :description, :text, :name, :views
child(:user) do
  attributes :username, :avatar
end
child(:language) do
  attributes :title, :name
end


