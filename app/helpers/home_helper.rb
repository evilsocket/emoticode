module HomeHelper
  def tag_cloud( tags, min_size = 9, max_size = 20 )
    min_occurs = tags.map(&:sources_count).min
    max_occurs = tags.map(&:sources_count).max
    cloud = {}

    tags.each do |tag|
      weight = ( Math.log(tag.sources_count) - Math.log(min_occurs) ) / ( Math.log(max_occurs) - Math.log(min_occurs) )
      size   = min_size + ( ( max_size - min_size ) * weight ).round

      cloud[tag.value] = [ tag, size, tag.sources_count ]
    end

    cloud
  end
end
