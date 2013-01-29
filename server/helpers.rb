class App < Sinatra::Base
  App.helpers do
    def haml_partial(page, options={})
      haml page, options.merge!(:layout => false)
    end

    def erb_partial(page, options={})
      erb page, options.merge!(:layout => false)
    end

    def json(body_hash, status=200, headers={})
      body = if params[:readable]
        JSON.pretty_generate(body_hash)
      else
        body_hash.to_json
      end
      halt status, headers.merge({'Content-Type' => 'application/json'}), body
    end

    # TODO: improve this method
    def link_to(text, href)
      if request.path_info == href
        "<a class='on' href='#{href}'>#{text}</a>"
      else
        "<a href='#{href}'>#{text}</a>"
      end
    end

    # TODO: cleanup
    def link_to_order(text, href, order)
      if params['dir'] == 'asc'
        direction = 'desc'
        arrow = '&#x25BC;'
      else
        direction = 'asc'
        arrow = '&#x25B2;'
      end

      link = "#{href}?order=#{order}&dir=#{direction}"
      if request.params['order'] == order
        "<a class='on' href='#{link}'>#{text}&nbsp;#{arrow}</a>"
      else
        "<a href='#{link}'>#{text}</a>"
      end
    end
  end
end
