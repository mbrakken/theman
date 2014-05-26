class ContentController < ApplicationController

  def support
    render layout: 'application'
    @page_title = "Mutual Aid Network | Support and Contribute"
  end

end
