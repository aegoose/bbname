module ApplicationHelper
  include Captcha::Helper

  # 左侧栏高亮判断
  def resource_matcher(controller_actions_hashes)
    matches = controller_actions_hashes.map do |controller, actions|
      (controller.to_s == controller_name) &&
        (actions.blank? ? true : actions.map(&:to_s).include?(action_name))
    end
    lambda do
      matches.detect { |m| m == true } && (block_given? ? yield : true)
    end
  end

  def to_date(d, options = nil)
    return '' if d.blank?
    I18n.localize(d, options)
  end
  alias :l :to_date

  def qr_t(key)
    arr = key.to_s.split('.')
    arr.delete_at(0) if arr.first == 'query'
    arr.each_index do |idx|
      newkey = arr[idx..-1].prepend('query').join('.')
      return I18n.t(newkey) if I18n.exists?(newkey)
    end
    return I18n.t arr.join('.'), scope: :query unless arr.blank?
    I18n.t key
  end

  def attr_t(key)
    key = key.to_s
    return I18n.t key, scope: [:'activerecord.attributes'] unless key.start_with? 'activerecord.'
    I18n.t key
  end


  # override the page_entries_info from gem kaminari
  def page_entries_info(collection, options = {})
    entry_name = options[:entry_name] || collection.entry_name
    entry_name = entry_name.pluralize unless collection.total_count == 1

    if collection.total_pages < 2
      t('helpers.page_entries_info.one_page.display_entries', entry_name: entry_name, count: collection.total_count, total_pages: collection.total_pages)
    else
      first = collection.offset_value + 1
      last = (sum = collection.offset_value + collection.limit_value) > collection.total_count ? collection.total_count : sum
      t('helpers.page_entries_info.more_pages.display_entries', entry_name: entry_name, first: first, last: last, total: collection.total_count, total_pages: collection.total_pages)
    end.html_safe
  end

  def cus_index_catgs
    [
      # ['所有客户', :all],
      ['定期', :fix],
      ['保险', :insure],
      ['理财', :financial],
      ['最近生日', :birthday],
      ['最近定期到期', :out_fix],
      ['最近保险到期', :out_insure],
      ['最近理财到期', :out_financial],
    ]
  end

  def cus_idex_catg(catg)
    cus_index_catgs.select do |x|
      x[1].to_s == catg.to_s
    end.first
  end

end
