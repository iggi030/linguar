class SitemapController < ApplicationController
  def sitemap
    @tandems = Tandem.find(:all, :order => "updated_at DESC", :limit => 50000)
    @glossaries = Glossary.find(:all, :order => "updated_at DESC", :conditions => {:public => true},:limit => 50000)
    @topics = Topic.find(:all, :order => "created_at DESC", :limit => 50000)
    headers["Content-Type"] = "text/xml"
    # set last modified header to the date of the latest entry.
    headers["Last-Modified"] = @tandems[0].updated_at.httpdate
    render :layout => false
  end
end
