# encoding: UTF-8

require 'gooddata'

# Project ID
PROJECT_ID = 'we1vvh4il93r0927r809i3agif50d7iz'

GoodData.with_connection do |c|
  GoodData.with_project(PROJECT_ID) do |project|
    path = File.join(File.dirname(__FILE__), '..', '..', 'data', 'users.csv')
    puts "Loading #{path}"
    CSV.foreach(path) do |row|
      email = row[0]
      role_name = row[1]
      user = project.users.find { |user| user.email == email }
      role = project.roles.find { |role| role.title == role_name }
      project.set_user_roles(user, role)
    end
  end
end