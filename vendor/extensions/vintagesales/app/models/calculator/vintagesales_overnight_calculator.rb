class Calculator::VintageSalesOvernightCalculator < Calculator
  
  def self.description
    I18n.t("vs_overnight_shipping")
  end

  def self.register
    super                                
    ShippingMethod.register_calculator(self)
    ShippingRate.register_calculator(self)
  end
  
  def compute(order)
    return if order.nil?
    return (15.0 * order.size) if order[0].variant.product.taxons[0].name == "Books"
    
    @index = 0
    order[0].variant.product.properties.each {|x|
       if x.name == "overnight shipping" 
	   @property_value = order[0].variant.product.product_properties.at(@index)
	else
	   @index += 1
        end
    }
    return @property_value.value[1..-1].to_f
  end  
end