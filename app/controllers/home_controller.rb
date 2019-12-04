class HomeController < ApplicationController
  require 'home_helper'
  $output_hash = nil
  def index
     
  end

  def crawl
    @domain_name = params[:domain_name]
    @max_urls = params[:max_urls].to_i
    if(params[:domain_name].present? && params[:max_urls].present?)
      $output_hash = DomainService.call(@domain_name,@max_urls)
      @output = $output_hash
    else
      respond_to do |format|
        format.html { redirect_to root_path(@domain_name,@max_urls) }
      end
    end 
  end

  def show
    @key = params[:key]
    @assets = $output_hash[@key]
  end
end
