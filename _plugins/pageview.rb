require 'googleauth'
require 'google/apis/analytics_v3'
Analytics = Google::Apis::AnalyticsV3

module Jekyll
  class PageViewFetcher < Generator
    def generate(site)
      # Authorize with Google API, require GOOGLE_ACCOUNT_TYPE=service_account, GOOGLE_CLIENT_EMAIL, GOOGLE_PRIVATE_KEY envs
      scopes = ['https://www.googleapis.com/auth/analytics.readonly']
      auth = Google::Auth.get_application_default(scopes)
      
      # Prepare service client
      service = Analytics::AnalyticsService.new
      service.authorization = auth
      
      # API Params
      id = site.config['ga_profile_id']
      start_date = '2010-11-07'
      end_date = Time.now.strftime("%Y-%m-%d")
      metric = 'ga:pageviews'
      dimension = 'ga:pagepath'
      filter = 'ga:pagepath=~^/(truyen-dai|truyen-ngan|one-shot|manga)/[^/]+/$;ga:pagepath!~/\d+/?$'
      
      # Call API to get pageviews
      response = service.get_ga_data(id, start_date, end_date, metric, dimensions: dimension, filters: filter)
      pageviews = Hash[response.rows]
      
      site.posts.docs.each do |post|
        post.data['pageviews'] = pageviews[post.permalink]
      end
    end
  end
end
