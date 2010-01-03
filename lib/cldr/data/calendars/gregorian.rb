module Cldr
  module Data
    class Calendars
      class Gregorian < Base
        def initialize(locale)
          super
          update(
            :months      => contexts('month'),
            :days        => contexts('day'),
            :eras        => contexts('era'),
            :quarters    => contexts('quarter'),
            :day_periods => day_periods,
            :fields      => fields,
            :'formats.date'      => formats('date'),
            :'formats.time'      => formats('time'),
            :'formats.datetime'  => formats('dateTime')
          )
        end
        
        def calendar
          @calendar ||= select('dates/calendars/calendar[@type="gregorian"]').first
        end

        def contexts(type)
          result = select(calendar, "#{type}s/#{type}Context").inject({}) do |result, node|
            result[node.attribute('type').value.to_sym] = widths(node, type)
            result
          end
          result.update(:default => :format) unless result.empty? # TODO where can we get the default from?
          result
        end

        def widths(node, type)
          result = select(node, "#{type}Width").inject({}) do |result, node|
            result[node.attribute('type').value.to_sym] = elements(node, type)
            result
          end
          result.update(:default => :wide) unless result.empty? # TODO where can we get the default from?
          result
        end

        def elements(node, type)
          select(node, "#{type}").inject({}) do |result, node|
            key = node.attribute('type').value
            key = key =~ /^\d*$/ ? key.to_i : key.to_sym
            result[key] = node.content
            result
          end
        end

        def day_periods
          am = select(calendar, "am").first
          pm = select(calendar, "pm").first

          result = {}
          result[:am] = am.content if am
          result[:pm] = pm.content if pm
          result
        end

        def eras
          base_path = calendar.path.gsub('/ldml/', '') + '/eras'
          keys = select("#{base_path}/*").map { |node| node.name }

          eras = keys.inject([]) do |result, name|
            path = "#{base_path}/#{name}/*"
            key  = name.gsub('era', '').gsub(/s$/, '').downcase.to_sym
            result << extract(path, :key   => lambda { |node| node.attribute('type').value.to_i rescue 0 },
                                    :value => lambda { |node| { key => node.content } })
          end
          eras.inject({}) { |result, data| result.deep_merge(data) }
        end

        def formats(type)
          formats = select(calendar, "#{type}Formats/#{type}FormatLength").inject({}) do |result, node|
            key = node.attribute('type').value.to_sym rescue :format
            result[key] = pattern(node, type)
            result
          end
          # TODO where can we get the default from?
          formats.update(:default => :medium) unless formats.empty? || type == 'dateTime'
          formats
        end

        def pattern(node, type)
          select(node, "#{type}Format/pattern").inject({}) do |result, node|
            result[:pattern] = node.content
            result
          end
        end

        def fields
          select(calendar, "fields/field").inject({}) do |result, node|
            key  = node.attribute('type').value.to_sym
            name = node.xpath('displayName').first
            result[key] = name.content if name
            result
          end
        end
      end
    end
  end
end