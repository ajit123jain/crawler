require 'rubygems'
require 'mechanize'
require 'anemone'


def getAllUrls 
  urls = [] 
  i = 1
  Anemone.crawl("https://www.bbc.co.uk/") do |anemone|
    anemone.on_every_page do |page|
      if urls.length < 100
        urls.push(page.url)
      end
      puts "#{i}  #{page.url}"
      i = i+1
    end
  end
  return urls
  # puts "Uniq pages"
  # Anemone.crawl("https://crossotel-staging.herokuapp.com/") do |anemone|
  #   anemone.after_crawl do |pages|
  #     puts pages.uniq!.size
  #   end
  # end
end

def getPage(agent, url)
  page = agent.get(url)		
  return Nokogiri::HTML(page.body)
end

def isOutOfDomain?(link)  
	return (link.to_s.start_with?('http') || link.to_s.start_with?('https') || link.to_s.include?('www.googletagmanager.com')  || link.to_s.include?('player.vimeo.com') )
end

def hasBeenCrawled?(link)
	return !$pagesCrawled.include?(link.to_s)
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

def isValidLink?(link)
	return !isOutOfDomain?(link.to_s) && hasBeenCrawled?(link)  && !(link =~ /^.*\.bbc\.uk/)
end

def creatingHashKey(parentLink)
  $staticAssets[parentLink.to_s] = Array.new
end


def crawlLink(parentLink)
  html = getPage($agent, parentLink);
  links = getHrefAndSrcLinks(html)
  creatingHashKey(parentLink)
  links.each do |link|
    if !isValidLink?(link) 
      next
    end
    if areYouAStaticAsset?(link)
      addToHash(parentLink, link)
    else 
      $pagesCrawled << link.to_s
      crawlLink(link)
    end 
  end
end

# Main logic start from here  
$staticAssets = Hash.new
$pagesCrawled = Array.new
rootUrl = 'https://bbc.co.uk/'
$agent = Mechanize.new 

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
puts getAllUrls.length 