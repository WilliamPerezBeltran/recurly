# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#





Rule.create(country:"australia", iso:"au", tin_type:"au_abn", tin_name:"australian business number", format:"NN NNN NNN NNN", example:"10 120 000 004")
Rule.create(country:"australia", iso:"au", tin_type:"au_acn", tin_name:"australian company numbe", format:"NNN NNN NNN", example:"101 200 000")
Rule.create(country:"canada", iso:"ca", tin_type:"ca_gst", tin_name:"canada gst number", format:"NNNNNNNNNRT0001", example:"123456789RT0001")
Rule.create(country:"india", iso:"in", tin_type:"in_gst", tin_name:"indian gst numbe", format:"NNXXXXXXXXXXNAN", example:"123456789RT0001")
