module Panda
  class Cloud < Base
    class << self
      
      def find(id)
        cloud = find_by_path(get_one_path, {:id => id})
        
        c = Panda.connection
        cloud.connection = Panda::Connection.new({
          :access_key => c.access_key,
          :secret_key => c.secret_key,
          :api_host => c.api_host,
          :api_port => c.api_port,
          :cloud_id => cloud.id
        })

        cloud
      end

    end
    
    def videos
      Video[connection]
    end
    
    def encodings
      Encoding[connection]
    end
    
    def profiles
      Profile[connection]
    end
    
  end
end