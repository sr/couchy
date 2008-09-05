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
