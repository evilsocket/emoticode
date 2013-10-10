module SeoHelper
  require 'deepstruct'

  def paged(s)
    if params[:page].to_i > 1
      "#{s} ( Page #{params[:page]} )"
    else
      s
    end
  end

  def default_seo
    seo = DeepStruct.new Rails.application.config.seo

    # prepare defaults
    seo.title       = page_title || paged( seo.default.title )
    seo.description = paged seo.default.description
    seo.keywords    = seo.default.keywords % @languages.map(&:title).join(', ')
    seo.metas       = seo.default.metas

    seo
  end

  def make_seo
    seo = self.default_seo

    # let the caller put custom data
    yield seo

    # return compiled list of meta tags
    [
      { property: 'og:title', content: seo.title },
      { property: 'og:description', content: seo.description },
      { name: 'title', content: seo.title },
      { name: 'description', content: seo.description },
      { name: 'keywords', content: seo.keywords },
    ] + seo.metas
  end

  def link_to_source(source, attrs = {}, lang_in_title = false)
    attrs =  {
      :title => "#{source.language.title} - #{source.title}"
    }
    .merge(attrs)

    title = lang_in_title ? "#{source.language.title} - #{source.title}" : source.title

    link_to title, source_with_language_url(language_name: source.language.name, source_name: source.name), attrs
  end

  def link_to_language(language, attrs = {})
    attrs =  {
      :title => "#{language.title} code snippets."
    }
    .merge(attrs)

    link_to language.title, language_archive_url(language.name), attrs
  end
end
