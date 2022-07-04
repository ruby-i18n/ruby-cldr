# frozen_string_literal: true

module Cldr
  module Export
    class Element
      class << self
        def chain(node)
          "/" + (node.ancestors.reverse.drop(1) + [node]).map { |ancestor| formatted_name_with_attrs(ancestor) }.join("/")
        end

        def inheritance_chain(node)
          "/" + (node.ancestors.reverse.drop(1) + [node]).map { |ancestor| formatted_name_with_distinguishing_attrs(ancestor) }.join("/")
        end

        private

        def formatted_name_with_attrs(node)
          attrs = node.attributes.values.sort_by(&:name)
          "#{node.name}#{attrs.map { |attribute| "[@#{attribute.name}=\"#{attribute.value}\"]" }.join("")}"
        end

        def formatted_name_with_distinguishing_attrs(node)
          distinguishing = Cldr::Ldml::ATTRIBUTES.fetch(node.name.to_sym, {}).select { |_name, attribute| attribute.distinguishing? }.keys
          attrs = node.attributes.values.sort_by(&:name).select { |attribute| distinguishing.include?(attribute.name.to_sym) }
          "#{node.name}#{attrs.map { |attribute| "[@#{attribute.name}=\"#{attribute.value}\"]" }.join("")}"
        end
      end
    end
  end
end
