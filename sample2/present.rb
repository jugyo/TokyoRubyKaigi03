[Object, Numeric, NilClass, TrueClass, FalseClass, String].each do |klass|
  klass.class_eval do
    def present?
      not blank?
    end
  end
end
