class SearchController < ApplicationController
  before_filter :check_query

  def search
    @phrase  = params[:what]
    @escaped = @phrase.parameterize.gsub /-/, ' '
    @escaped = @escaped[0..199]
    @escaped = Riddle::Query.escape @escaped
    @sources = Source.search( @escaped, :star => true ).page( params[:page] )

    begin
      @cloud = @sources.map { |s| s.tags }.flatten.sort { |a,b| a.sources_count <=> b.sources_count }[1..70].shuffle
    rescue
      @cloud = []
    end
  end

  private

  def check_query
    render_404 if params[:what].nil? or params[:what].length < 4
  end
end
