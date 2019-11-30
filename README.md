# crawler
Crawler for Finding Asset and all the urls
## Requirements for this to run  
#### ruby installed 
#### Anemone Gem
#### Mechanize Gem

## Instructions (for run this programme on terminal)
  ### Input format 
  #### ruby crawler.rb
  #### https://poplify.com/
  #### 10  

  ### Output format 
    ********** List of all the urls *************
    1  https://poplify.com/
    2  https://poplify.com/contact/
    ***********  List of all the urls with their static assets count ***************
    URL Index: 1  URL Value: https://poplify.com/ Static Assets count: 2
      0  http://newpoplify.poplify.com/wp-content/uploads/2016/12/poplilogo.png
      1  https://poplify.com/wp-content/uploads/2018/11/cropped-poplilogo-32x32.png
      
    URL Index: 2  URL Value: https://poplify.com/contact/ Static Assets count: 2
      0  http://newpoplify.poplify.com/wp-content/uploads/2016/12/poplilogo.png
      1  https://poplify.com/wp-content/uploads/2018/11/cropped-poplilogo-32x32.png
      2  https://poplify.com/wp-content/uploads/2018/11/cropped-poplilogo-192x192.png
  