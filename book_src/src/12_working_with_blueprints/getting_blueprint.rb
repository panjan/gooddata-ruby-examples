# encoding: utf-8

require 'gooddata'

GoodData.with_connection do |client|
  GoodData.with_project('project_id') do |project|
    blueprint = project.blueprint

    # now you can start working with it
    blueprint.datasets.count # => 3
    blueprint.datasets(:all, include_date_dimensions: true).count # => 4
    blueprint.attributes.map(&:title)

    # You can also store it into file as json
    blueprint.store_to_file('model.json')
  end
end
