class Application

  @@items = ["Apples","Carrots","Pears"]
  @@cart = []

  def path_match(something)
    req.path.match(something)
  end
  
  req = @@req

  def call(env)
    resp = Rack::Response.new
    @@req = Rack::Request.new(env)
    


    if self.path_match(/items/)
      @@items.each do |item|
        resp.write "#{item}\n"
      end
    elsif req.path.match(/search/)
      search_term = req.params["q"]
      resp.write handle_search(search_term)
    elsif req.path.match(/cart/)
      if @@cart.empty?
        resp.write("Your cart is empty")
      else
        @@cart.each do |item|
          resp.write "#{item}\n"
        end
      end
    elsif req.path.match(/add/)
      item_param = req.params["item"]
      if @@items.include?(item_param)
        @@cart << item_param
        resp.write("added #{item_param}")
      else
        resp.write("We don't have that item")
      end
    else
      resp.write "Path Not Found"
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