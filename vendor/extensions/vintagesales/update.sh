#changed to update the products page

##  To do, insert the vs lines for localization
##  Add some switches for different functions

export FROM=~/www/mystore8
export TO=~/www/mystore9
export TO_EXT=$TO/vendor/extensions/vintagesales
echo TO=$TO
echo TO_EXT=$TO_EXT

for dir in app/views/products \
	app/views/shared \
	config/localization \
	app/models/calculator/ 
do
  echo "mkdir -p $TO_EXT/$dir"
  mkdir -p $TO_EXT/$dir
done

for file in app/views/shared/_products.html.erb \
	app/views/products/_products.html.erb \
	public/images/content_bg.gif \
	public/images/logo.png \
	public/stylesheets/vintagesales.css \
	config/initializers/vintagesales.rb \
	config/locales/en-US.yml \
	config/locales/en-GB.yml \
	vendor/extensions/vintagesales/update.sh \
	vendor/extensions/vintagesales/vintagesales_extension.rb \
	vendor/extensions/vintagesales/app/views/shared/_products.html.erb \
	vendor/extensions/vintagesales/app/models/calculator/vintagesales_standard_calculator.rb \
	vendor/extensions/vintagesales/app/models/calculator/vintagesales_priority_calculator.rb \
	vendor/extensions/vintagesales/app/models/calculator/vintagesales_overnight_calculator.rb \
	start.sh \
	public/images/logo.png \
	script/kitchenware-upload.rb \
	script/book-upload.rb \
	config/database.yml
do
#ls -l $FROM/$file
#echo  $TO/$file
#ls -l $TO/$file
echo "cp $FROM/$file $TO/$file"
cp $FROM/$file $TO/$file
done

cp -r $FROM/upload $TO
