module Cldr
  module Export
    module Data
      class Subdivisions < Base

        def initialize(locale)
          super
          update(:subdivisions => subdivisions)
        end

        private

        def subdivisions
          @subdivisions ||= select('localeDisplayNames/subdivisions/subdivision').inject({}) do |result, node|
            result[node.attribute('type').value.to_sym] = node.content unless draft?(node) or alt?(node)
            result
          end
        end

        def doc
          begin
            super
          rescue Errno::ENOENT
            @doc = Nokogiri::XML('')
          end
        end

        def path
          @path ||= "#{Cldr::Export::Data.dir}/subdivisions/#{Cldr::Export.from_i18n(locale)}.xml"
        end

      end
    end
  end
end
