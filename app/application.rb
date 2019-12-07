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
        rw "#{item}\n"
      end
    elsif pm.call(/search/)
      search_term = req.params["q"]
      rw handle_search(search_term)
    elsif pm.call(/cart/)
      if @@cart.empty?
        rw("Your cart is empty")
      else
        @@cart.each do |item|
          rw "#{item}\n"
        end
      end
    elsif pm.call(/add/)
      item_param = req.params["item"]
      if @@items.include?(item_param)
        @@cart << item_param
        rw("added #{item_param}")
      else
        rw("We don't have that item")
      end
    else
      rw "Path Not Found"
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