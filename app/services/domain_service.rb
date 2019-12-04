require 'rubygems'
require 'mechanize'
require 'anemone'
class DomainService
  def self.call(rootUrl,max_urls)
    @staticAssets = Hash.new  # For Storing statisAssets 
    @pagesCrawled = Array.new # which has been already crawled  
    $agent = Mechanize.new 
    urls = getAllUrls(rootUrl,max_urls)
    urls.each do |url|
      unless hasBeenCrawled?(url)
        begin crawlLink(url)
        rescue  Mechanize::ResponseCodeError  => ex
          puts "Status code error"+ ex.response_code
          # $log.info("Status code error->"+ex.response_code)
        rescue => e
          puts "here is failed request (#{e.inspect}), skipping it..."
        end
      end
    end
    return @staticAssets
  end
  def self.getAllUrls(rootUrl,max_urls)   # It will give all the uniq urls for single domain 
    urls,i = Array.new,1
    Anemone.crawl(rootUrl) do |anemone|
      anemone.on_every_page do |page|
        if urls.length < max_urls && !urls.include?(page.url)
          urls.push(page.url)
          i = i+1
        else
          return urls
        end
      end
    end
  end

  def self.hasBeenCrawled?(link)  # to check link already been crawled or not 
    return @pagesCrawled.include?(link.to_s)
  end

  def self.crawlLink(parentLink)  # crawl the link and find static assets 
    html = getPage($agent, parentLink);
    links = getHrefAndSrcLinks(html)
    creatingHashKey(parentLink)
    links.each do |link|
      if areYouAStaticAsset?(link)
        addToHash(parentLink, link) 
      end 
    end
    @pagesCrawled << parentLink.to_s
  end

  private 
  def self.getHrefAndSrcLinks(html)
    return html.xpath('//*[@href]/@href | //*[@src]/@src')
  end
  
  def self.isStaticAsset?(link)
    return link.to_s =~ /(jpg|jpeg|gif|png|css|js|ico|xml|rss|txt|svg|css)$/
  end
  
  def self.addToHash(parentLink, link) #add the static asset to corresponding hash
    @staticAssets[parentLink.to_s].push(link.to_s) 
  end
  
  def self.areYouAStaticAsset?(link)
    if isStaticAsset?(link) 
      return true;
    else 
      return false;
    end
  end
  
  def self.creatingHashKey(parentLink)
    @staticAssets[parentLink.to_s] = Array.new
  end

  def self.getPage(agent, url)  #get whole page content to find all static assets 
    page = agent.get(url)		
    return Nokogiri::HTML(page.body)
  end
end