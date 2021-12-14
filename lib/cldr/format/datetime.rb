# frozen_string_literal: true

module Cldr
  module Format
    class Datetime
      autoload :Base, "cldr/format/datetime/base"

      attr_reader :format, :date, :time

      def initialize(format, date, time)
        @format = format
        @date = date
        @time = time
      end

      def apply(datetime, options = {})
        format.gsub(/(\{\{(date|time)\}\})/) do
          case Regexp.last_match(2)
          when "date"
            options[:date] || date.apply(datetime, options)
          when "time"
            options[:time] || time.apply(datetime, options)
          end
        end
      end
    end
  end
end
