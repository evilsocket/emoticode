class SourceController < ApplicationController
  before_filter :authenticate!, only: [ :new, :create ]

  def show
    @source = Source
    .joins(:language)
    .where(languages: { name: params[:language_name] })
    .where(sources: { name: params[:source_name] })
    .first!
  end

  def new
    # @source = Source.new
  end

  def create

  end
end
