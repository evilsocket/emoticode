every 3.days do
  rake 'sources:update_views'
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
