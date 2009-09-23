
require "csv"
require 'action_controller/test_process'

file = `ls upload/*.csv | grep -v and-r`.chomp
info = CSV.read(ARGV.first || file)           
######info.shift                                    

# TODO: set this list by eliminating the expected cols
properties = %w[Size ] + ["Condition", "standard shipping", "priority shipping", "overnight shipping"]

# expect these fields
fields = properties + ["Product Name","Product Details","List Price","Image File Name1","Image File Name2","Image File Name3","Image File Name4","Image File Name5","Image File Name6","Image File Name7","Image File Name8","Image File Name9","Taxon info","Delivery Cost","Meta Description","Meta Keywords"]

# set up convenient name mapping 
$names = {}                      
info.first.each_with_index { |v,i| $names[v] = i }

unless $names.keys.all? {|n| fields.include?(n) } 
  puts $names.keys.reject {|n| fields.include?(n) }.inspect
  raise "funny names"                                      
end                                                        


$main = []
$row = [] 
def get(n)    # I would use lambda, but call syntax is ugly...
  if $names[n] 
    $row[$names[n]]  # query: other closure-y things that would work?
  else
    ''
  end
end                                                                


# initial value and pattern for sku
psku = "P0000"                     

stop = false
# check image availability
info[1..-1].each do |line| 
  $row = line              
  next if get("Image File Name1").blank?
  get("Image File Name1").split(',').map(&:strip).each do |file|
    pick = `find upload | grep -i "/#{file}"`.chomp         
    if pick.empty?                                             
      puts "Warning: couldn't find #{file}"                    
      puts "  Other = #{get "Image File Name1"}"                
      stop = true                                              
    end                                                        
  end                                                        
  next if get("Image File Name2").blank?
  get("Image File Name2").split(',').map(&:strip).each do |file|
    pick = `find upload | grep -i "/#{file}"`.chomp         
    if pick.empty?                                             
      puts "Warning: couldn't find #{file}"                    
      puts "  Other = #{get "Image File Name2"}"                
    end                                                        
  end                                                        
  next if get("Image File Name3").blank?
  get("Image File Name3").split(',').map(&:strip).each do |file|
    pick = `find upload | grep -i "/#{file}"`.chomp         
    if pick.empty?                                             
      puts "Warning: couldn't find #{file}"                    
      puts "  Other = #{get "Image File Name3"}"                
    end                                                        
  end                                                          
  next if get("Image File Name4").blank?
  get("Image File Name4").split(',').map(&:strip).each do |file|
    pick = `find upload | grep -i "/#{file}"`.chomp         
    if pick.empty?                                             
      puts "Warning: couldn't find #{file}"                    
      puts "  Other = #{get "Image File Name4"}"                
    end                                                        
  end                                                          
  next if get("Image File Name5").blank?
  get("Image File Name5").split(',').map(&:strip).each do |file|
    pick = `find upload | grep -i "/#{file}"`.chomp         
    if pick.empty?                                             
      puts "Warning: couldn't find #{file}"                    
      puts "  Other = #{get "Image File Name4"}"                
    end                                                        
  end                                                          
  next if get("Image File Name6").blank?
  get("Image File Name6").split(',').map(&:strip).each do |file|
    pick = `find upload | grep -i "/#{file}"`.chomp         
    if pick.empty?                                             
      puts "Warning: couldn't find #{file}"                    
      puts "  Other = #{get "Image File Name6"}"                
    end                                                        
  end                                                          
  next if get("Image File Name7").blank?
  get("Image File Name7").split(',').map(&:strip).each do |file|
    pick = `find upload | grep -i "/#{file}"`.chomp         
    if pick.empty?                                             
      puts "Warning: couldn't find #{file}"                    
      puts "  Other = #{get "Image File Name7"}"                
    end                                                        
  end                                                          
  next if get("Image File Name8").blank?
  get("Image File Name8").split(',').map(&:strip).each do |file|
    pick = `find upload | grep -i "/#{file}"`.chomp         
    if pick.empty?                                             
      puts "Warning: couldn't find #{file}"                    
      puts "  Other = #{get "Image File Name8"}"                
    end                                                        
  end                                                          
  next if get("Image File Name9").blank?
  get("Image File Name9").split(',').map(&:strip).each do |file|
    pick = `find upload | grep -i "/#{file}"`.chomp         
    if pick.empty?                                             
      puts "Warning: couldn't find #{file}"                    
      puts "  Other = #{get "Image File Name9"}"                
    end                                                        
  end                                                          
end                                                            
raise "image errors" if stop                                   


# reformat into UL
def convert_features(txt)
  return "" if txt.blank?
  out = '<p>Features include:</p><ul>'
  txt.lines.drop(1).each do |l|       
    next if l.strip.blank?            
    l.gsub!(/^\s*[*]/,'')             
    out += "<li>#{l}</li>\n"          
  end                                 
  out + '</ul>'                       
end                                   

# split into related groups
# groups are identified by product name, ie all variants must have an empty name cell
def split(lines)                                                                     
  out = []                                                                           
  lines.each do |l|                                                                  
    next if l[1..100].all? &:blank?     # skip sku placeholder                       
    if l[1].blank?                                                                   
      out.last.push l                                                                
    else                                                                             
      out.push [l]                                                                   
    end                                                                              
  end                                                                                
  out                                                                                
end                                                                                  

###### split "A=B, C=D, ..." cell into list of pairs
#####def decode_attributes(nm)                      
#####  (get(nm) || "").split(',').map do |c|        
#####    c.strip.split /\s*=\s*/                    
#####  end                                          
#####end                                            

# options in variants
#####colour_type = OptionType.find_or_create_by_name_and_presentation("colour", "Colour")

# maybe better to extend via costed-options framework
####                                                 
                                                     
# now process as groups of product lines             
split(info[1..-1]).each do |group|                   
  group.each do |line|                               
    $row  = line                                     
    if line == group[0]                              
      # start of a new product group (which might not have format variants)
      puts "Adding new product group #{get "Product Name"}."               
      $main = line                                                         
    else                                                                   
      # merge new info with earlier info                                   
      $row = $main.zip(line).map {|o,n| n.present? ? n : o }               
      puts "Extending product group with format #{get "Format"}"           
    end                                                                    
    product_name = get("Product Name")                                     
    #product_name += ' - ' + get("Format") unless get("Format").blank? || group.count == 1
                                                                                         
    #if get("Sale Price").nil? || get("List Price").nil?                                  
    if get("List Price").nil?                                  
      # validation won't let these fields be blank                                       
      puts "Problem with blank prices for #{product_name} -- rejecting."                 
      next                                                                               
    end                                                                                  
                                                                                         
    tax_category = TaxCategory.find_or_create_by_name("Missouri sales tax")
    if tax_category.nil? 
       puts  "Problem finding or creating Tax Category - Missouri sales tax"
    end
    #in_stock = get("Delivery Information") != "Out of stock"                             
                                                                                         
    # do para conversion here?                                                           
    blurb = get("Product Details").strip # + convert_features(get("Features"))           
                                                                                             
    p = Product.create :name              => product_name,                                   
                       :description       => blurb,                                          
                       :available_on      => Time.zone.now                                  
                                                                                             
    p.price = get("List Price").delete("£$,") if get("List Price")                    
    p.tax_category = tax_category
                                                                                             
    if get("Taxon info").blank?                                                              
      puts "Warning: missing taxon info for #{p.name}"                                       
    else                                                                                     
       taxon_name = get("Taxon info")
       taxon = Taxon.find_by_name(taxon_name)
       if taxon.nil?
	   puts "Warning: missing taxon object for #{p.name}"                                       
	else
          p.taxons << taxon   
      end                                                                                            
    end                                                                                              
                                                                                                              
    p.save!                                                                                  
    # create images                                                                                           
    im1 = get("Image File Name1")
    if im1
       im1.split(',').map(&:strip).each do |file|                                             
       pick = `find upload/images/* | grep -i "/#{file}"`.chomp                                                    
       puts "Using: ===#{pick}=== from #{file}"                                                                
       next if pick.blank?                                                                                     
       mime = "image/" + pick.match(/\w+$/).to_s   
       puts "Using: ===#{pick}=== from #{mime}"                                                                
       i = Image.new(:attachment => ActionController::TestUploadedFile.new(pick, mime))                        
       i.viewable_type = "Product"                                                                             
      # link main image to the product                                                                        
       i.viewable = p                                                                                          
      p.images << i                                                                                           
       i.find_dimensions
       i.save! if i.validate
    end
    end
    im2 = get("Image File Name2")
    if im2
       im2.split(',').map(&:strip).each do |file|                                             
       pick = `find upload/images/* | grep -i "/#{file}"`.chomp                                                    
       puts "Using: ===#{pick}=== from #{file}"                                                                
       next if pick.blank?                                                                                     
       mime = "image/" + pick.match(/\w+$/).to_s   
       puts "Using: ===#{pick}=== from #{mime}"                                                                
       i = Image.new(:attachment => ActionController::TestUploadedFile.new(pick, mime))                        
       i.viewable_type = "Product"                                                                             
      # link main image to the product                                                                        
       i.viewable = p                                                                                          
      p.images << i                                                                                           
       i.find_dimensions
       i.save! if i.validate
    end
    end
    im3 = get("Image File Name3")
    if im3
       im3.split(',').map(&:strip).each do |file|                                             
       pick = `find upload/images/* | grep -i "/#{file}"`.chomp                                                    
       puts "Using: ===#{pick}=== from #{file}"                                                                
       next if pick.blank?                                                                                     
       mime = "image/" + pick.match(/\w+$/).to_s   
       puts "Using: ===#{pick}=== from #{mime}"                                                                
       i = Image.new(:attachment => ActionController::TestUploadedFile.new(pick, mime))                        
       i.viewable_type = "Product"                                                                             
      # link main image to the product                                                                        
       i.viewable = p                                                                                          
      p.images << i                                                                                           
       i.find_dimensions
       i.save! if i.validate
    end
    end
    im4 = get("Image File Name4")
    if im4
       im4.split(',').map(&:strip).each do |file|                                             
         pick = `find upload/images/* | grep -i "/#{file}"`.chomp                                                    
         puts "Using: ===#{pick}=== from #{file}"                                                                
         next if pick.blank?                                                                                     
         mime = "image/" + pick.match(/\w+$/).to_s   
         puts "Using: ===#{pick}=== from #{mime}"                                                                
         i = Image.new(:attachment => ActionController::TestUploadedFile.new(pick, mime))                        
         i.viewable_type = "Product"                                                                             
        # link main image to the product                                                                        
         i.viewable = p                                                                                          
         p.images << i                                                                                           
         i.find_dimensions
         i.save! if i.validate
      end
    end
    im5 = get("Image File Name5")
    if im5
       im5.split(',').map(&:strip).each do |file|                                             
       pick = `find upload/images/* | grep -i "/#{file}"`.chomp                                                    
       puts "Using: ===#{pick}=== from #{file}"                                                                
       next if pick.blank?                                                                                     
       mime = "image/" + pick.match(/\w+$/).to_s   
       puts "Using: ===#{pick}=== from #{mime}"                                                                
       i = Image.new(:attachment => ActionController::TestUploadedFile.new(pick, mime))                        
       i.viewable_type = "Product"                                                                             
      # link main image to the product                                                                        
       i.viewable = p                                                                                          
      p.images << i                                                                                           
       i.find_dimensions
       i.save! if i.validate
    end
    end
    im6 = get("Image File Name6")
    if im6
       im6.split(',').map(&:strip).each do |file|                                             
       pick = `find upload/images/* | grep -i "/#{file}"`.chomp                                                    
       puts "Using: ===#{pick}=== from #{file}"                                                                
       next if pick.blank?                                                                                     
       mime = "image/" + pick.match(/\w+$/).to_s   
       puts "Using: ===#{pick}=== from #{mime}"                                                                
       i = Image.new(:attachment => ActionController::TestUploadedFile.new(pick, mime))                        
       i.viewable_type = "Product"                                                                             
      # link main image to the product                                                                        
       i.viewable = p                                                                                          
      p.images << i                                                                                           
       i.find_dimensions
       i.save! if i.validate
    end
    end
    im7 = get("Image File Name7")
    if im7
       im7.split(',').map(&:strip).each do |file|                                             
       pick = `find upload/images/* | grep -i "/#{file}"`.chomp                                                    
       puts "Using: ===#{pick}=== from #{file}"                                                                
       next if pick.blank?                                                                                     
       mime = "image/" + pick.match(/\w+$/).to_s   
       puts "Using: ===#{pick}=== from #{mime}"                                                                
       i = Image.new(:attachment => ActionController::TestUploadedFile.new(pick, mime))                        
       i.viewable_type = "Product"                                                                             
      # link main image to the product                                                                        
       i.viewable = p                                                                                          
      p.images << i                                                                                           
       i.find_dimensions
       i.save! if i.validate
    end
    end
    im8 = get("Image File Name8")
    if im8
       im8.split(',').map(&:strip).each do |file|                                             
       pick = `find upload/images/* | grep -i "/#{file}"`.chomp                                                    
       puts "Using: ===#{pick}=== from #{file}"                                                                
       next if pick.blank?                                                                                     
       mime = "image/" + pick.match(/\w+$/).to_s   
       puts "Using: ===#{pick}=== from #{mime}"                                                                
       i = Image.new(:attachment => ActionController::TestUploadedFile.new(pick, mime))                        
       i.viewable_type = "Product"                                                                             
      # link main image to the product                                                                        
       i.viewable = p                                                                                          
      p.images << i                                                                                           
       i.find_dimensions
       i.save! if i.validate
    end
    end
    im8 = get("Image File Name8")
    if im8
       im8.split(',').map(&:strip).each do |file|                                             
       pick = `find upload/images/* | grep -i "/#{file}"`.chomp                                                    
       puts "Using: ===#{pick}=== from #{file}"                                                                
       next if pick.blank?                                                                                     
       mime = "image/" + pick.match(/\w+$/).to_s   
       puts "Using: ===#{pick}=== from #{mime}"                                                                
       i = Image.new(:attachment => ActionController::TestUploadedFile.new(pick, mime))                        
       i.viewable_type = "Product"                                                                             
      # link main image to the product                                                                        
       i.viewable = p                                                                                          
      p.images << i                                                                                           
       i.find_dimensions
       i.save! if i.validate
    end
    end
    p.save! if p
                                                                                                              
    properties.each do |k|                                                                                    
      unless get(k).nil? || get(k).empty?     # blank?                                                        
        puts "Info: property from get is #{k}"                                       
        kp = Property.find_or_create_by_name_and_presentation(k,k)                                            
        puts "Info: property name is #{kp}"                                       
        if (k == "Colour")                                                                                    
          the_value = decode_attributes("Colour").map(&:first).                                               
                        to_sentence({:last_word_connector => " or ", :two_words_connector => " or "})         
        else                                                                                                  
          the_value = get k                                                                                   
        end                                                                                                   
        ProductProperty.create :property => kp, :product => p, :value => the_value                            
      end                                                                                                     
    end                                                                                                       
                                                                                                              
    if get("Meta Description").blank?                                                              
      puts "Warning: missing meta description for #{p.name}"                                       
    else                                                                                     
       meta_d = get("Meta Description")
    end                                                                                              
    if get("Meta Keywords").blank?                                                              
      puts "Warning: missing meta keywords for #{p.name}"                                       
    else                                                                                     
       meta_k = get("Meta Keywords")
    end                                                                                              

     v = p.master
     v.meta_keywords = meta_k
     v.meta_description = meta_d
#     v = Variant.create :product => p,  
#	:meta_keywords => meta_k,
#	:meta_description => meta_d
#     puts "Added variant -- #{v.inspect}"
	
#     v.price      = get("Sale Price") ? get("Sale Price").delete("£$,") : p.master_price
     p.price = get("List Price") ? get("List Price").delete("£$,") : p.variants.first.list_price
#     v.option_values << c    unless    c.nil?
     v.save!

     # PURELY for demo purposes, seed with some inventory
     InventoryUnit.create_on_hand(v,1) #if in_stock

     # and include the variant as the singleton, and save the info
#     p.variants << v
     p.save!
#   end

    # register the option types used with this product
    p.option_types = p.variants.map(&:option_values).flatten.map(&:option_type).uniq
    p.save!
  end
end
