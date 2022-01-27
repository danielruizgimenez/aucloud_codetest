require 'yaml'
require_relative '../lib/toy_robot'

def run_examples
  examples = YAML.load_file('resources/examples.yml')
  examples.each do |name, commands|
    robot = ToyRobot.new
    puts "Running commands for: " + name
    robot.read_commands commands
  end
end

run_examples