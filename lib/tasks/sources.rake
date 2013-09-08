class PageViews
	extend Garb::Model

	metrics :pageviews
	dimensions :page_path
end

namespace :sources do
  desc "Update sources views using Analytics API"
  task update_views: :environment do

    Rails.logger.level = 1
    Rails.logger.info "********* GOOGLE ANALYTICS PAGE VIEWS UPDATER STARTED *********"
    Rails.logger.info "Logging into Analytics account ..."

    google = Rails.application.config.secrets['Google']

    Garb::Session.api_key = google['api_key']
    Garb::Session.login google['username'], google['password'] 

    profile = Garb::Management::Profile.all.detect {|p| p.web_property_id == google['profile'] }

    Rails.logger.info "Start updating."

    Source.order('created_at DESC').find_each_with_order do |source|
    	results = PageViews.results( profile, :filters => {
	        :page_path.eql => source.path
	      }, 
	      :start_date => Time.at( source.created_at ), 
	      :end_date => Time.now 
	    ).first

	    unless results.nil?
        source.views = results.pageviews
        source.save
		    Rails.logger.info "Updated '#{source.path}' with #{source.views} views."
	    else
        Rails.logger.error "Error updating '#{source.path} ."
	    end
    end

    Rails.logger.info "DONE"
  end
end
