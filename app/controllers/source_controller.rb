class SourceController < ApplicationController
  before_filter :authenticate!, only: [ :new, :create ]

  def show
    @source = Source
    .joins(:language)
    .where(languages: { name: params[:language_name] })
    .where(sources: { name: params[:source_name] })
    .first!
    @cloud = @source.tags.to_a.shuffle
  end

  def raw
    show
    render :text => @source.text, :content_type => 'text/plain'
  end

  def embed
    show
    
    # TODO Move this shit to the proper view!
    hash = Digest::MD5.hexdigest( "EMBED_SNIPPET_CODE_#{@source.id}" )
    code = Albino.colorize @source.text, @source.language.syntax
    code = code.empty? ? "<pre>#{h(@source.text)}</pre>" : code
  
    js = 'document.open();';
    container = <<CNT 
<div class="snipt-embed" onmouseover="document.getElementById('emoticode-#{hash}').style.display = 'block';return false;" onmouseout="document.getElementById('emoticode-#{hash}').style.display = 'none';return false;" style="position: relative;">
CNT
    js << "document.writeln('#{container.strip.gsub( "'", %q(\\\') )}');"
                
    code.each_line do |line|
      js << "document.writeln('#{line.strip.gsub( "'", %q(\\\') ) }');" unless line.strip.empty?
    end
    
    footer = '<div style="background-color: rgb(17, 17, 17); color: rgb(208, 208, 208); float: right;' <<
      'padding: 5px 10px; border-top-left-radius: 5px; border-bottom-right-radius: 5px; ' <<
      'font-style: normal; font-variant: normal; font-weight: normal; font-size: 11px; ' <<
      'line-height: normal; font-family: Arial, sans-serif; display: none; position: absolute; ' <<
      'bottom: 0px; right: 0px;" id="emoticode-' << hash << '">code hosted by <a href="' << @source.url << '" ' <<
      'style="color: #0084FF; text-decoration: none;">emoticode.net</a></div>'
                 
    js << "document.writeln('#{footer.gsub( "'", %q(\\\') )}');" << 
          "document.writeln('</div>');" <<
          "document.close();"

    render :text => js, :content_type => 'application/javascript'
  end

  def new
    # @source = Source.new
  end

  def create

  end
end
