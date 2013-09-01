class SearchController < ApplicationController
  before_filter :check_query

  def search
    @phrase = params[:what]

    tokens = @phrase.split(/\W/).map { |token| token.downcase.to_sym }
    langs  = langs_by_names( tokens ) 

    @sources = Rails.cache.fetch "search_for_#{tokens.join('_')}", :expires_in => 1.week do
      Source.search( @phrase, langs ).page( params[:page] ).all
    end

    @cloud = @sources.map { |s| s.tags } .flatten
  end

  private

  def check_query
    render_404 if params[:what].nil? or params[:what].length < 4
  end
end
