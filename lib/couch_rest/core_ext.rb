require 'addressable/uri'

class Object
  def tap
    yield(self)
    self
  end
end

class Hash
  def stringify_keys_and_jsonify_values!(values=%w(key startkey endkey))
    keys.each do |key|
      value = self.delete(key)
      value = value.to_json if values.include?(key.to_s)
      self[key.to_s] = value.to_s
    end
    self
  end
end

class String
  def to_uri(*args)
    case args.first
    when String
      path = args.first
      params = (args.length > 1 ? args.last : {})
    when Hash
      path = ''
      params = args.first
    end

    Addressable::URI.join(self, path).tap do |uri|
      uri.query_values = params.stringify_keys_and_jsonify_values! if params.any?
    end
  end
end
