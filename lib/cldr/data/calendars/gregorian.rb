class Cldr
  module Data
    class Calendars
      class Gregorian < Base
        def initialize(locale)
          super
          update(
            :months              => contexts('month'),
            :days                => contexts('day'),
            :eras                => contexts('era'),
            :quarters            => contexts('quarter'),
            :periods             => periods,
            :fields              => fields,
            :'formats.date'      => formats('date'),
            :'formats.time'      => formats('time'),
            :'formats.datetime'  => formats('dateTime')
          )
        end

        def calendar
          @calendar ||= select('dates/calendars/calendar[@type="gregorian"]').first
        end

        def contexts(kind)
          select(calendar, "#{kind}s/#{kind}Context").inject({}) do |result, node|
            context = node.attribute('type').value.to_sym
            result[context] = widths(node, kind, context)
            result
          end
        end

        def widths(node, kind, context)
          select(node, "#{kind}Width").inject({}) do |result, node|
            width  = node.attribute('type').value.to_sym
            result[width] = elements(node, kind, context, width)
            result
          end
        end

        def elements(node, kind, context, width)
          aliased = select(node, 'alias').first
          if aliased
            xpath_to_key(aliased.attribute('path').value, kind, context, width)
          else
            select(node, kind).inject({}) do |result, node|
              key = node.attribute('type').value
              key = key =~ /^\d*$/ ? key.to_i : key.to_sym
              result[key] = node.content
              result
            end
          end
        end
        
        def xpath_to_key(xpath, kind, context, width)
          kind    = (xpath =~ %r(/([^\/]*)Width) && $1) || kind
          context = (xpath =~ %r(Context\[@type='([^\/]*)'\]) && $1) || context
          width   = (xpath =~ %r(Width\[@type='([^\/]*)'\]) && $1) || width
          :"calendars.gregorian.#{kind}s.#{context}.#{width}"
        end
        
        def xpath_width
        end

        def periods
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
          if default = default_format(type)
            formats = default.merge(formats)
          end
          formats
        end
        
        def default_format(type)
          if node = select(calendar, "#{type}Formats/default").first
            key = node.attribute('choice').value.to_sym
            { :default => :"calendars.gregorian.formats.#{type.downcase}.#{key}" }
          end
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