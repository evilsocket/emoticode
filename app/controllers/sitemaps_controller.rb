class SitemapsController < ApplicationController
  ITEMS_PER_PAGE = 200

  def index
    respond_to do |format|
      format.xml {
        @last_snippet = Source.where(:private => false).order('created_at DESC').limit(1).first
        @total = Source.where(:private => false).count
        @pages = ( @total / ITEMS_PER_PAGE ).round

        if @total % ITEMS_PER_PAGE != 0 
          @pages += 1
        end
      }
    end
  end

  def languages
    # @languages already loaded in ApplicationController
    respond_to do |format|
      format.xml
    end
  end

  def snippets
    respond_to do |format|
      format.xml {
        @page    = params[:page]
        @sources = Source.where(:private => false).joins(:language).paginate( :page => params[:page], :per_page => ITEMS_PER_PAGE )
      }
    end
  end
end
