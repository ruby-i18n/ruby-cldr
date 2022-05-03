# frozen_string_literal: true

module Cldr
  module Export
    module Resolver
      class AmbiguousPathError < StandardError; end

      EMPTY_OVERRIDE = "∅∅∅"

      protected

      # Resolve values from a CLDR dataset, following the inheritance chain and aliases.
      # Useful for flattening the data.
      def resolve_value(locale, path)
        get_child_with_locale_inheritance(locale, path)
      end

      private

      def get_child_with_locale_inheritance(locale, path)
        ancestors = Cldr::Locale::Fallbacks.new[locale]
        child = ancestors.lazy.map do |ancestor|
          if ancestor == :root
            get_root_child(locale, path)
          else
            get_child(ancestor, path)
          end
        end.reject(&:nil?).first
        child&.text == EMPTY_OVERRIDE ? nil : child
      end

      def get_child(locale, path)
        results = self[locale].xpath(path)
        raise AmbiguousPathError, "Path `#{path}` is not specific enough. Found #{results.size} matches" if results.size > 1
        return nil if results.empty?

        node = results.first
        node.nil? ? nil : Cldr::Export::Element.new(node.dup, locale: locale)
      end

      def get_root_child(original_locale, path)
        # `root` locale is special, in that a path missing might just mean that an ancestor is aliased.
        # So we chop off the last segment of the path and look for an alias until we either find one or hit the root path.
        chop_path(path).lazy.with_index.map do |(subpath, rest), index|
          child = get_child(:root, subpath)
          if aliased?(child)
            next_path = [File.expand_path(child.children.first.attribute("path").value, subpath), rest].reject(&:empty?).join("/")
            return get_child_with_locale_inheritance(original_locale, next_path)
          end

          # Either the exact path matches right away, or you're only going to return if you find an alias.
          return Cldr::Export::Element.new(child.dup, locale: :root) if child && index == 0
        rescue AmbiguousPathError
          next
        end.reject(&:nil?).first
      end

      def aliased?(node)
        node && node.children.first.name == "alias"
      end

      # For each index, yield the elements before and after that index as a pair.
      # e.g. [1, 2, 3] yields:
      #   [[], [1, 2, 3]],
      #   [[1], [2, 3]],
      #   [[1, 2], [3]],
      #   [[1, 2, 3], []]
      def partitions(parts)
        return to_enum(:partitions, parts) unless block_given?

        (0..parts.length).each do |i|
          first = parts[0...i]
          rest = parts[i..]
          yield([first, rest])
        end
      end

      # Given a path, yield new paths by chopping off segments.
      # If strip_final_predicate is set, and the final segment
      # in a new path contains a predicate, then it will also yield the
      # new path without that final predicate.
      def chop_path(path, strip_final_predicate: true)
        return to_enum(:chop_path, path, strip_final_predicate: strip_final_predicate) unless block_given?

        start = path.match(%r{^/{0,2}})[0]
        parts = path.gsub(%r{^/{0,2}}, "").split("/")
        partitions(parts).to_a.reverse.each do |(first, rest)|
          new_path = start + first.join("/")
          yield [new_path, rest.join("/")]

          if strip_final_predicate
            new_path_with_final_attributes_stripped = start + (first[0...-1] + [strip_predicates(first.last)]).join("/")
            yield [new_path_with_final_attributes_stripped, rest.join("/")] unless new_path_with_final_attributes_stripped == new_path
          end
        end
      end

      def strip_predicates(path)
        return nil if path.nil?
        # This is a hacky regex that would fail if there were
        # predicates with `]` characters in them.
        # Seems to be "good enough" for now.
        path.gsub(/\[[^\]]+\]/, "")
      end
    end
  end
end
