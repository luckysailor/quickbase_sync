require 'quickbase_sync/import'
require 'quickbase_sync/export'

module QuickbaseSync
  module WebRoutes
    def self.registered(app)
      app.get "/" do
        erb :index
      end
    
      app.get '/imports' do 
        erb :imports
      end
    
      app.get '/exports' do
        db = params['table']
        app = params['app']
        @fields = []
        @header = "Exports"
        if db && app
          qb = QuickbaseSync::Export.new(:app => app)
          @fields = qb.get_field_names(db)
          @header = "App: #{app.downcase} | Table: #{db.capitalize}"
          qb.sign_out
        end
        erb :exports
      end
      
      app.get '/api' do
        erb :api
      end
    end
  end
end