class HomeController < ApplicationController
  def index
     
  end

  def crawl
    @domain_name = params[:domain_name]
    @max_urls = params[:max_urls].to_i
    if(params[:domain_name].present? && params[:max_urls].present?)
      @output = DomainService.call(@domain_name,@max_urls)
    else
      respond_to do |format|
        format.html { redirect_to root_path(@domain_name,@max_urls) }
      end
    end 
  end
end
