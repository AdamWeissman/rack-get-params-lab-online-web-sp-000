class Application

  @@items = ["Apples","Carrots","Pears"]
  @@cart = []

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)
    
    pm = -> (something) {req.path.match(something)}
    rw = -> (this) {resp.write"#{this}"}
    
    if pm.call(/items/)
      @@items.each do |item|
        rw.call "#{item}\n"
      end
    elsif pm.call(/search/)
      rw handle_search(req.params["q"])
    elsif pm.call(/cart/)
      if @@cart.empty?
        rw.call("Your cart is empty")
      else
        @@cart.each do |item|
          rw.call "#{item}\n"
        end
      end
    elsif pm.call(/add/)
      item_param = req.params["item"]
      if @@items.include?(item_param)
        @@cart << item_param
        rw.call("added #{item_param}")
      else
        rw.call("We don't have that item")
      end
    else
      rw.call "Path Not Found"
    end

    resp.finish
  end

  def handle_search(search_term)
    if @@items.include?(search_term)
      return "#{search_term} is one of our items"
    else
      return "Couldn't find #{search_term}"
    end
  end
end