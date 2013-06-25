class String
  # I must be hallucinating, why isn't this here?
  def transliterate
    ActiveSupport::Inflector.transliterate(self)
  end
end