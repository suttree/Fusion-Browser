class DesktopController < ApplicationController
  require 'open-uri'

  def index
    @webpage = request.env['REQUEST_URI'].split('http://')[1]
    @webpage = 'www.suttree.com/' if ! @webpage
  end

  def fusion_browser
    # Get the url from the environment table and tidy it up
    @proxy_url = request.env['REQUEST_URI'].split('/fusion_browser/')[1]
    @proxy_url = @proxy_url.gsub(/http:\/\//,'')

    # Use a combination of URI.parse and uri.read
    # to parse the url and find the relevant base uri.
    # This is has the pleasant knock-on effect of
    # following things like 302 headers correctly.
    uri = URI.parse('http://' + @proxy_url)

    # Use render text with a Proc so that we can stream content
    # directly to the browser, rather than doing it all in one go
    # which is slowing down the whole proxying process. Note that
    # we just spit out the base href and javascript at the top of
    # the page - not clean but it's quick and works - duncan 18.10.06

    # Stream it
    #render :text => Proc.new { |response, output|
    #  uri.open {|f|
    #    #@headers["Content-Type"] = f.content_type
    #    #@headers["Set-Cookie"] = f.meta["set-cookie"]
    #    output.write '<base href="' + f.base_uri.to_s + '">'
    #    f.each_line {|line| output.write line }
    #  }
    #}, :layout => false

    # Render it in one go so that we can set headers. This would be 
    # useful if we wanted to proxy cookies, mainly, but we'll stop 
    # short of that here for security reasons.
    @headers = {}
    @content = []
    begin
      uri.open {|f|
          @headers['Content-Type'] = f.content_type
          @headers['X-FUSIOn'] = 'halp'
          @headers['Set-Cookie'] = f.meta["set-cookie"]
          @content = '<base href="' + f.base_uri.to_s + '">'
          f.each_line {|line| @content += line}
      }
    rescue
      @content = "<div style='height:100%;background-color: #2e3f50;'><img src='/images/sad.tab.png'></div>"
    end
  end

  def fusion_meta
    # Get the url from the environment table and tidy it up
    @webpage = request.env['REQUEST_URI'].split('/fusion_meta/')[1]
  end

  def browse
    redirect_to "/#{params[:q]}"
  end

  def google
    redirect_to "/http://www.google.com/search?q=#{params[:q]}"
  end
end
