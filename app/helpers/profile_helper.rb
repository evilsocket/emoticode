module ProfileHelper
  include SeoHelper
  
  def page_title
    if controller.action_name == 'show'
      paged "#{@user.username} | emoticode" rescue super
    else
      paged "#{@user.username} ( #{controller.action_name.capitalize} ) | emoticode" rescue super
    end
  end

  def metas
    make_seo do |seo|
      u = @user || @current_user

      if u.profile.aboutme.nil?      
        seo.description = paged seo.user.description % u.username
      else
        seo.description = u.profile.aboutme
      end
=begin      
      if u.profile.avatar?
        seo.metas.each_with_index do |meta,i|
          if meta.values.first == 'og:image'
            seo.metas[i][:content] = image_url(u.avatar)
            break
          end
        end
      end
=end
    end
  end

  def rating_stars( rating, n_stars = 5 )
    n_filled = ( ( n_stars / 100.0 ) * ( rating.average * 100 ) ).to_i
    n_empty  = n_stars - n_filled

    return (1..n_empty).map { '&#x2606' } + (1..n_filled).map { '&#x2605' }
  end
end
