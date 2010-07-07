module Panda
  module Finders
    
    def self.included(base)
      base.extend(ClassMethods)
      base.extend(PathFinder)
    end
    
    module ClassMethods
      
      def find(id)
        find_by_path(one_path, {:id => id})
      end

      def find_by(map)
        find_by_path(many_path, map).first
      end

      def all(map={})
        find_by_path(many_path, map)
      end

      private

      def find_all_by_has_many(relation_name, relation_value)
         map = {}
         map[relation_name.to_sym] = relation_value
         has_many_path = build_hash_many_path(many_path, relation_name)
         find_by_path(has_many_path, map)
      end

      def method_missing(method_symbol, *arguments)
        method_name = method_symbol.to_s
        if method_name =~ /^find_all_by_([_a-zA-Z]\w*)$/
          find_all_by_has_many($1, arguments.pop)
        else
          super
        end
      end
      
    end
    
    module PathFinder
      
      def find_object_by_path(url, map={})
        full_url = object_url(url, map)
        params = element_params(url, map)
        self.connection.get(full_url, params)
      end
      
      def find_by_path(url, map={})
        object = find_object_by_path(url, map)
        if object.is_a?(Array)
          object.map{|o| Panda::const_get("#{name.split('::').last}").new(o)}
        elsif object["id"]
          Panda::const_get("#{name.split('::').last}").new(object)
        else
          Error.new(object).raise!
        end
      end
      
    end
    
  end
end