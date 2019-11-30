require 'rubygems'
require 'mechanize'
require 'anemone'

def getAllUrls(rootUrl,max_urls)
  urls,i = Array.new,1
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

def getPage(agent, url)
  page = agent.get(url)		
  return Nokogiri::HTML(page.body)
end

def hasBeenCrawled?(link)
  return $pagesCrawled.include?(link.to_s)
end

def crawlLink(parentLink)
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
  
def getHrefAndSrcLinks(html)
  return html.xpath('//*[@href]/@href | //*[@src]/@src')
end

def isStaticAsset?(link)
  return link.to_s =~ /(jpg|jpeg|gif|png|css|js|ico|xml|rss|txt|svg|css)$/
end

def addToHash(parentLink, link)
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



# Main logic start from here  
$staticAssets = Hash.new  # For Storing statisAssets 
$pagesCrawled = Array.new # which has been already crawled 
rootUrl = gets.chomp # Root URL or Domain Name 
$agent = Mechanize.new 
# poplify = Poplify.new
max_urls = gets.chomp.to_i
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
j = 1
$staticAssets.each do |key,value|  # printing all the URLs with their static assets 
  puts "#{j}  #{key} #{value.length}"
  j = j+1
  value.each_with_index do |val,i|
    puts "   #{i}  #{val}"
  end
end
 










# begin crawlLink(rootUrl)
# rescue  Mechanize::ResponseCodeError  => ex
# 	puts "Status code error"+ ex.response_code
#   # $log.info("Status code error->"+ex.response_code)
# rescue => e
#   puts "here is failed request (#{e.inspect}), skipping it..."
# end

# $staticAssets.each do |key,value|
#   puts "#{key}"
#   value.each_with_index do |val,i|
#     puts "   #{i}  #{val}"
#   end
# end
# puts getAllUrls.length 