namespace :slack do
  desc "Notify Lunch Menu"
  task :notify_lunch_menu => :environment do
    puts "Notifying lunch menu job is running"
    SlackMessageServices::SendMenu.call("#lunch")
    puts "Notifying lunch is running on background"
  end
end