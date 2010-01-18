class Cldr
  module Format
    class Datetime
      autoload :Base, 'cldr/format/datetime/base'

      # attr_reader :format, :date, :time
      # 
      # def initialize(format, date, time)
      #   @format, @date, @time = date, date, time
      # end
      # 
      # def apply(datetime, options = {})
      #   format.dup % {
      #     :date => options[:date] || date.apply(datetime, options),
      #     :time => options[:time] || time.apply(datetime, options)
      #   }
      # end
    end
  end
end