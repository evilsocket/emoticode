class SourceController < ApplicationController
  before_filter :authenticate!, only: [ :new, :raw, :create ]

  def show
    @source = source_by_params
    @cloud = @source.tags.to_a.shuffle
    @comment = Comment.new
  end

  def raw
    show
    render :text => @source.text, :content_type => 'text/plain'
  end

  def embed
    @source = source_by_params
    @hash   = Digest::MD5.hexdigest( @source.name )
    @code = Albino.colorize @source.text, @source.language.syntax
    @code = @code.empty? ? "<pre>#{h(@source.text)}</pre>" : @code

    render :partial => 'source/embed.js'
  end

  def new
    # @source = Source.new
  end

  def create

  end

  private

  def source_by_params
    Source
    .joins(:language)
    .where(languages: { name: params[:language_name] })
    .where(sources: { name: params[:source_name] })
    .first!
  end
end
