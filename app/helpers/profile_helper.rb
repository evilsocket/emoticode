module ProfileHelper
  include SeoHelper
  
  def page_title
    paged "#{@user.username} | emoticode" rescue super
  end

  def metas
    make_seo do |seo|
      seo.description = paged seo.user.description % (@user || @current_user).username
    end
  end

  def rating_stars( rating, n_stars = 5 )
    n_filled = ( ( n_stars / 100.0 ) * ( rating.average * 100 ) ).to_i
    n_empty  = n_stars - n_filled

    return (1..n_empty).map { '&#x2606' } + (1..n_filled).map { '&#x2605' }
  end
end
