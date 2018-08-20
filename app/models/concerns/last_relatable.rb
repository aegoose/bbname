module LastRelatable
  extend ActiveSupport::Concern

  included do
    # include LastRelatable::ClassMethods
  end

  module ClassMethods
    def last_at(ty, opts = {})
      cls = opts[:class_name]
      clskey = opts[:class_key] || :id
      fkey = opts[:foreign_key]
      key_hash_str = (opts[:key_hash] || {}).to_s
      tystr = "last_#{ty}"

      class_eval <<-RUBY, __FILE__, __LINE__ + 1
      after_save do
        if @#{tystr} && read_attribute("#{fkey}").blank?
          kid = @#{tystr}.read_attribute("#{clskey}")
          if kid
            update_column("#{fkey}", kid)
          end
        end
      end

      def #{tystr}
        if @#{tystr}.blank? && !#{fkey}.blank?
          if #{cls}.is_a? Class
            @#{tystr} = #{cls}.find_by_#{clskey}(#{fkey})
          else
            @#{tystr} = #{cls}.select { |x| x.#{clskey} == #{fkey} }&.first
          end
        end
        @#{tystr}
      end

      def #{tystr}=(obj)
        key_hash = eval("#{key_hash_str}")
        @#{tystr} = obj
        if obj.blank?
          write_attribute("#{fkey}", nil)
          key_hash.keys{ |k| write_attribute(k, nil) }
        else
          write_attribute("#{fkey}", obj.read_attribute("#{clskey}"))
          key_hash.each {|k,v| write_attribute(k, obj.read_attribute(v)) unless v.blank? }
        end
      end
      RUBY
    end
  end
end
