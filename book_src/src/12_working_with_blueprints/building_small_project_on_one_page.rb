# encoding: utf-8

require 'gooddata'

GoodData.with_connection('user', 'password') do |client|
  blueprint = GoodData::Model::ProjectBlueprint.build('Acme project') do |p|
    p.add_date_dimension('committed_on')
    p.add_dataset('devs') do |d|
      d.add_anchor('attr.dev')
      d.add_label('label.dev_id', :reference => 'attr.dev')
      d.add_label('label.dev_email', :reference => 'atr.dev')
    end
    p.add_dataset('commits') do |d|
      d.add_anchor('attr.commits_id')
      d.add_fact('fact.lines_changed')
      d.add_date('committed_on')
      d.add_reference('devs')
    end
  end
  project = GoodData::Project.create_from_blueprint(blueprint, auth_token: '')
  puts "Created project #{project.pid}"

  # Load data
  commits_data = [
    ['lines_changed', 'committed_on', 'devs'],
    [1, '01/01/2014', 1],
    [3, '01/02/2014', 2],
    [5, '05/02/2014', 3]]
  project.upload(commits_data, blueprint, 'commits')

  devs_data = [
    ['dev', 'email'],
    [1, 'tomas@gooddata.com'],
    [2, 'petr@gooddata.com'],
    [3, 'jirka@gooddata.com']]
  project.upload(devs_data, blueprint, 'devs')

  # create a metric
  metric = project.facts('lines_changed').create_metric
  metric.save
  report = project.create_report(title: 'Awesome_report', top: [metric], left: ['dev_id'])
  report.save
  ['john@example.com'].each do |email|
    p.invite(email, 'admin', "Guys checkout this report #{report.browser_uri}")
  end
end
