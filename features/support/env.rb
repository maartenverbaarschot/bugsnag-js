# Any 'run once' setup should go here as this file is evaluated
# when the environment loads.
# Any helper functions added here will be available in step
# definitions

# install rubygems
run_required_commands([
  ['bundle', 'install'],
])

# install node_modules
Dir.chdir('features/fixtures') do
  run_required_commands([
    ['npm', 'install', '--no-package-lock'],
  ])
end

# start the web server
pid = Process.spawn('features/fixtures/node_modules/.bin/serve --port=53621 features/fixtures',
  :out => '/dev/null',
  :err => '/dev/null',
)
Process.detach pid

require_relative './browserstack_driver'
bs_local = bs_local_start

$driver = driver_start

# Scenario hooks
Before do
  # Runs before every Scenario
end

After do
  # Runs after every Scenario
  $driver.navigate.to 'about:blank'
end

at_exit do
  # Runs when the test run is completed
  $driver.quit
  bs_local.stop
  begin
    Process.kill('HUP', pid)
  rescue
  end
end
