require 'active_support/inflector'
require 'net/http'
require 'faraday'

module ProductClassifier
  PRODUCT_HASH = {
  }

  food_file = File.new File.dirname(__FILE__) + "/../data/food"
  toys_file = File.new File.dirname(__FILE__) + "/../data/toys"

  while item = food_file.gets do
    PRODUCT_HASH[item.strip.to_sym] = Food
  end

  while item = toys_file.gets do
    PRODUCT_HASH[item.strip.to_sym] = Toy
  end
  food_file.close
  toys_file.close

  CONN = Faraday.new(:url => "http://www.medguideindia.com") do |faraday|
    faraday.request :url_encoded
    #faraday.response :logger
    faraday.adapter Faraday.default_adapter
    faraday.options[:timeout] = 9
    faraday.options[:open_timeout] = 5
  end

  def self.type keywords
    return Medicine if is_medicine?(keywords)
    keywords.each do |k|
      klass = PRODUCT_HASH[k.singularize.downcase.to_sym]
      return klass if klass
    end
    return Product
  end

  def self.is_medicine? keywords
    return true if keywords.include? "medicine"
    start = keywords.index("of") ? keywords.index("of") + 1 : 0
    name = keywords.slice(start .. -1).join(" ").downcase
    uri = URI "http://www.medguideindia.com/list_brand_byCode1.php?undefined=undefined&getCountriesByLetters=1&letters=#{URI.escape name}"

    begin
      res = CONN.post "/list_brand_byCode1.php?undefined=undefined&getCountriesByLetters=1&letters=#{URI.escape name}", {:rndval => Time.now.to_i.to_s}
    rescue Faraday::Error::ClientError
      puts "Problem in medicine API request. Please make sure your net connection works."
      raise ProductError.new
    end
    meds = []
    if res.body != ""
      meds.push *res.body.downcase.split("|")
      meds.map!{|med| med.split(" (").first}
    end
    meds.compact.include? name
  end
end
