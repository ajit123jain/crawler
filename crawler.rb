require 'rubygems'
require 'mechanize'
require 'anemone'

class Modular 
  def getAllUrls(rootUrl,max_urls)   # It will give all the urls for single domain 
    urls,i = Array.new,1
    puts "********** List of all the urls *************"
    Anemone.crawl(rootUrl) do |anemone|
      anemone.on_every_page do |page|
        if urls.length < max_urls && !urls.include?(page.url)
          urls.push(page.url)
          puts "#{i}  #{page.url}"
          i = i+1
        else
          return urls
        end
      end
    end
  end

  def hasBeenCrawled?(link)  # to check link already been crawled or not 
    return $pagesCrawled.include?(link.to_s)
  end

  def crawlLink(parentLink)  # crawl the link and find static assets 
    html = getPage($agent, parentLink);
    links = getHrefAndSrcLinks(html)
    creatingHashKey(parentLink)
    links.each do |link|
      if areYouAStaticAsset?(link)
        addToHash(parentLink, link) 
      end 
    end
    $pagesCrawled << parentLink.to_s
  end

  private
  def getHrefAndSrcLinks(html)
    return html.xpath('//*[@href]/@href | //*[@src]/@src')
  end
  
  def isStaticAsset?(link)
    return link.to_s =~ /(jpg|jpeg|gif|png|css|js|ico|xml|rss|txt|svg|css)$/
  end
  
  def addToHash(parentLink, link) #add the static asset to corresponding hash
    $staticAssets[parentLink.to_s].push(link.to_s) 
  end
  
  def areYouAStaticAsset?(link)
    if isStaticAsset?(link) 
      return true;
    else 
      return false;
    end
  end
  
  def creatingHashKey(parentLink)
    $staticAssets[parentLink.to_s] = Array.new
  end

  def getPage(agent, url)  #get whole page content to find all static assets 
    page = agent.get(url)		
    return Nokogiri::HTML(page.body)
  end
end

# Main logic start from here  
$staticAssets = Hash.new  # For Storing statisAssets 
$pagesCrawled = Array.new # which has been already crawled 
$file = open('myfile.out', 'w')
puts "Please Give Root URL or Domain Name" #Format with https 
rootUrl = gets.chomp # Root URL or Domain Name 
$agent = Mechanize.new 
modular = Modular.new
puts "Please give me maxium no of urls you want to crawl"
max_urls = gets.chomp.to_i
urls = modular.getAllUrls(rootUrl,max_urls)

urls.each do |url|
  unless modular.hasBeenCrawled?(url)
    begin modular.crawlLink(url)
    rescue  Mechanize::ResponseCodeError  => ex
      puts "Status code error"+ ex.response_code
      # $log.info("Status code error->"+ex.response_code)
    rescue => e
      puts "here is failed request (#{e.inspect}), skipping it..."
    end
  end
end
puts "***********  List of all the urls with their static assets count ***************"
j = 1
$staticAssets.each do |key,value|  # printing all the URLs with their static assets 
  puts "URL Index: #{j}  URL Value: #{key} Static Assets count: #{value.length}"
  j = j+1
  value.each_with_index do |val,i|
    puts "   #{i}  #{val}"
  end
  puts ""
end
$file.puts $staticAssets
