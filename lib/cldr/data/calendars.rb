module Cldr
  module Data
    class Calendars < Base
      def data
        if calendar = select('dates/calendars/calendar[@type="gregorian"]').first
          {
            :calendars => {
              :gregorian => {
                :months      => months(calendar),
                :days        => days(calendar),
                :eras        => eras(calendar),
                :quarters    => quarters(calendar),
                :day_periods => day_periods(calendar),
                :formats     => {
                  :date      => formats(calendar, 'date'),
                  :time      => formats(calendar, 'time'),
                  :datetime  => formats(calendar, 'dateTime'),
                  # TODO available_formats, interval_formats
                },
                :fields      => fields(calendar)
              }
            }
          }
        else
          { }
        end
      end

      def months(calendar)
        contexts(calendar, 'month')
      end

      def days(calendar)
        contexts(calendar, 'day')
      end

      def quarters(calendar)
        contexts(calendar, 'quarter')
      end

      def contexts(node, type)
        doc.xpath("#{node.path}/#{type}s/#{type}Context").inject({}) do |result, node|
          result[node.attribute('type').value.to_sym] = widths(node, type)
          result
        end.merge(:default => :format) # TODO where can we get the default from?
      end

      def widths(node, type)
        doc.xpath("#{node.path}/#{type}Width").inject({}) do |result, node|
          result[node.attribute('type').value.to_sym] = elements(node, type)
          result
        end.merge(:default => :wide) # TODO where can we get the default from?
      end

      def elements(node, type)
        doc.xpath("#{node.path}/#{type}").inject({}) do |result, node|
          key = node.attribute('type').value
          key = key =~ /^\d*$/ ? key.to_i : key.to_sym
          result[key] = node.content
          result
        end
      end

      def day_periods(calendar)
        am = doc.xpath("#{calendar.path}/am").first
        pm = doc.xpath("#{calendar.path}/pm").first

        result = {}
        result[:am] = am.content if am
        result[:pm] = pm.content if pm
        result
      end

      def eras(calendar)
        base_path = calendar.path.gsub('/ldml/', '') + '/eras'
        keys = select("#{base_path}/*").map { |node| node.name }

        eras = keys.inject([]) do |result, name|
          path = "#{base_path}/#{name}/*"
          key  = name.gsub('era', '').gsub(/s$/, '').downcase.to_sym
          result << extract(path, :key   => lambda { |node| node.attribute('type').value.to_i rescue 0 },
                                  :value => lambda { |node| { key => node.content } })
        end
        eras = eras.inject({}) { |result, data| result.deep_merge(data) }
      end

      def formats(calendar, type)
        formats = doc.xpath("#{calendar.path}/#{type}Formats/#{type}FormatLength").inject({}) do |result, node|
          key = node.attribute('type').value.to_sym rescue :format
          result[key] = pattern(node, type)
          result
        end
        # TODO where can we get the default from?
        formats.merge!(:default => :medium) unless type == 'dateTime'
        formats
      end

      def pattern(calendar, type)
        doc.xpath("#{calendar.path}/#{type}Format/pattern").inject({}) do |result, node|
          result[:pattern] = node.content
          result
        end
      end

      def fields(calendar)
        doc.xpath("#{calendar.path}/fields/field").inject({}) do |result, node|
          key  = node.attribute('type').value.to_sym
          name = node.xpath('displayName').first
          result[key] = name.content if name
          result
        end
      end
    end
  end
end