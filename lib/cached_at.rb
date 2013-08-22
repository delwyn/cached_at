require "cached_at/version"

module CachedAt
  def self.included(klass)
    klass.instance_eval do
      before_save :_set_cached_at
    end
  end

  def cache_key
    case
    when new_record?
      "#{self.class.model_name.cache_key}/new"
    when timestamp = self[:cached_at]
      timestamp = timestamp.utc.to_s(:number)
      "#{self.class.model_name.cache_key}/#{id}-#{timestamp}"
    else
      "#{self.class.model_name.cache_key}/#{id}"
    end
  end

  def touch(name = nil)
    update_column :cached_at, current_time_from_proper_timezone
  end

  private
  def _set_cached_at
    self.cached_at = current_time_from_proper_timezone if new_record? || self.changed?
  end
end
