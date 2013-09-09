module AdditionalTax
  def additional_tax
    (cost + value_added_tax) * 0.024
  end
end
