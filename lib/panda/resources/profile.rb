module Panda
  class Profile < Resource
    include Panda::Updatable

    def encodings
      @encodings ||= EncodingScope.new(self)
    end

    class << self
      def method_missing(method_symbol, *arguments)
        Scope.new(self, Profile).send(method_symbol, *arguments)
      end
    end

  end
end