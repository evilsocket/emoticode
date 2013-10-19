object false

child(@users) do
  object @user
  attributes :username, :created_at, :avatar
end

child(:pager) do
  node(:pages) { |m| User.confirmed.count.to_f / @per_page }
  node(:per_page) { |m| @per_page }
end
