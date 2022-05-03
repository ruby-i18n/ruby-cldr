# frozen_string_literal: true

require "nokogiri"

module Cldr
  module Export
    class FlattenedDataSet < DataSet
      private

      def compute(*args, **kwargs, &block)
        flatten(*args, **kwargs, &block)
      end

      def flatten(locale, flatten_aliases: false, flatten_locale_inheritance: false, flatten_lateral_inheritance: false)
        data_file = parent[locale]
        return data_file unless flatten_aliases || flatten_locale_inheritance || flatten_lateral_inheritance

        temp_data_set = Cldr::Export::DataSet.new(parent: parent)
        temp_data_set[locale] = Cldr::Export::DataFile.new(data_file.doc.dup, minimum_draft_status: data_file.minimum_draft_status)

        doc = temp_data_set[locale].doc
        flatten_aliases!(locale, doc, temp_data_set) if flatten_aliases
        flatten_lateral_inheritance!(locale, doc) if flatten_lateral_inheritance
        flatten_locale_inheritance!(locale, doc) if flatten_locale_inheritance

        temp_data_set[locale]
      end

      def flatten_aliases!(locale, doc, temp_data_set)
        aliases.each do |alias_node|
          insertion_path = Cldr::Export::Element.cldr_path(alias_node.parent)
          path = File.expand_path(alias_node.attribute("path").value, insertion_path)
          resolved = temp_data_set.resolve_value(locale, path)

          next unless resolved&.locale == locale
          ensure_path_exists(doc, insertion_path)
          resolved.node.children.each do |child|
            merge_value(locale, doc, insertion_path, child)
          end
        end
      end

      def flatten_lateral_inheritance!(locale, doc)
        raise NotImplementedError # TODO: Implement this.
      end

      def flatten_locale_inheritance!(locale, doc)
        raise NotImplementedError # TODO: Implement this.
      end

      def ensure_path_exists(doc, path)
        chop_path(path, strip_final_predicate: false).to_a.reverse.reduce(nil) do |parent, (subpath, _rest)|
          existing = doc.at_xpath(subpath)

          if existing.nil?
            new_child = new_child_from_path(subpath, doc)
            parent.add_child(new_child)
          else
            existing
          end
        end
      end

      def merge_value(locale, doc, insertion_point, value)
        value_path = Cldr::Export::Element.cldr_path(value)
        value.traverse do |node|
          next unless node.is_a?(Nokogiri::XML::Element)

          node_path = File.join(insertion_point, Cldr::Export::Element.cldr_path(node))
          if doc.at_xpath(node_path).nil?
            parent_node_path = File.dirname(node_path)
            ensure_path_exists(doc, parent_node_path)
            new_child = doc.at_xpath(parent_node_path).add_child(node)
          end
        end
      end

      def new_child_from_path(path, doc)
        part = path.split("/").last
        name = part.gsub(/\[[^\]]+\]/, "")

        attrs = part.scan(/\[@([^\]]+)=['"]([^\]]+)['"]\]/).to_h
        new_child = Nokogiri::XML::Element.new(name, doc)
        attrs.each do |key, value|
          new_child[key] = value
        end
        new_child
      end

      def aliases
        # Aliases have to be flattened in a particular order:
        # 1. More deeply nested aliases must be flattened before less deeply nested aliases.
        # 2. Aliases that are referenced by other aliases must be flattened before the referencing aliases.
        alias_nodes = parent[:root].xpath("//alias")
        max_chain_lengths = longest_chains(alias_nodes)
        alias_nodes.sort_by do |alias_node|
          [
            alias_node.path.gsub(%r{^/{0,2}}, "").split("/").length * -1,
            max_chain_lengths[Cldr::Export::Element.cldr_path(alias_node.parent)],
          ]
        end
      end

      def normalize(path)
        # TODO: Do this right.
        # It's meant to normalize things like the quotes around attributes,
        # but this simple implementation will mess up any attribute values that
        # contain quotes.
        path.gsub("'", "\"")
      end

      def longest_chains(alias_nodes)
        # Computes the length of the alias chain that starts at each alias node.
        pointers = {}
        alias_nodes.each do |alias_node|
          root_path = normalize(File.expand_path(alias_node.attribute("path").value, Cldr::Export::Element.cldr_path(alias_node.parent)))
          pointers[Cldr::Export::Element.cldr_path(alias_node.parent)] = root_path
        end

        pointers.keys.to_h do |path|
          count = 0
          curr = path
          while pointers.key?(curr)
            count += 1
            curr = pointers[curr]
          end
          [path, count]
        end
      end
    end
  end
end
