every 60.minutes do
  rake 'sources:update_latest_views'
end

every 3.days do
  rake 'sources:update_views'
end

every 60.minutes do
  rake 'sitemap:submit'
end

every 30.minutes do
  rake 'social:publish_random'
end

every 5.minutes do
  rake 'social:publish_new'
end

every 2.days do
  rake 'ts:rebuild'
end
