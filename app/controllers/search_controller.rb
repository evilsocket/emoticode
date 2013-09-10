class SearchController < ApplicationController
  before_filter :check_query

  def search
    @phrase  = Riddle::Query.escape(params[:what])
    @sources = Source.search( @phrase, :star => true, :with => { :private => false } ).page( params[:page] )

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
