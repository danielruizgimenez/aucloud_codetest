require "test/unit"
require_relative '../lib/toy_robot'

class TestToyRobot < Test::Unit::TestCase

  def test_no_action_without_place
    robot = ToyRobot.new
    robot.read_command "MOVE"

    assert_equal(robot.position_x, 0)
    assert_equal(robot.position_y, 0)
  end

  def test_move_y
    robot = ToyRobot.new
    robot.read_command "PLACE 0, 0, NORTH"
    robot.read_command "MOVE"

    assert_equal(0, robot.position_x)
    assert_equal(1, robot.position_y)
  end

  def test_move_y_limit
    robot = ToyRobot.new
    robot.read_command "PLACE 0, 0, NORTH"
    robot.read_command "MOVE"
    robot.read_command "MOVE"
    robot.read_command "MOVE"
    robot.read_command "MOVE"

    assert_equal(0, robot.position_x)
    assert_equal(4, robot.position_y)

    robot.read_command "MOVE"
    assert_equal(4, robot.position_y)

    robot.read_command "PLACE 0, 1, SOUTH"
    robot.read_command "MOVE"
    assert_equal(0, robot.position_y)

    robot.read_command "MOVE"
    assert_equal(0, robot.position_y)
  end

  def test_move_x
    robot = ToyRobot.new
    robot.read_command "PLACE 0, 0, EAST"
    robot.read_command "MOVE"

    assert_equal(1, robot.position_x)
    assert_equal(0, robot.position_y)
  end

  def test_move_x_limit
    robot = ToyRobot.new
    robot.read_command "PLACE 0, 0, EAST"
    robot.read_command "MOVE"
    robot.read_command "MOVE"
    robot.read_command "MOVE"
    robot.read_command "MOVE"

    assert_equal(4, robot.position_x)
    assert_equal(0, robot.position_y)

    robot.read_command "MOVE"
    assert_equal(4, robot.position_x)

    robot.read_command "PLACE 1, 0, WEST"
    robot.read_command "MOVE"
    assert_equal(0, robot.position_x)

    robot.read_command "MOVE"
    assert_equal(0, robot.position_x)
  end

  def test_place
    robot = ToyRobot.new
    robot.read_command "PLACE 0, 0, EAST"
    assert_equal(0, robot.position_x)
    assert_equal(0, robot.position_y)
    assert_equal(90, robot.facing)

    robot.read_command "PLACE 2, 3, WEST"
    assert_equal(2, robot.position_x)
    assert_equal(3, robot.position_y)
    assert_equal(270, robot.facing)

    error = assert_raise(RuntimeError) { robot.read_command("PLACE 5, 3, WEST") }
    assert_equal("Position can't be higher than 4", error.to_s)

    error = assert_raise(RuntimeError) { robot.read_command("PLACE -1, 3, WEST") }
    assert_equal("Position can't be negative", error.to_s)
  end

  def test_place_wrong_numbers
    robot = ToyRobot.new

    error = assert_raise(RuntimeError) { robot.read_command "PLACE asd, asd, EAST" }
    assert_equal("Positions have to be a number", error.to_s)

    error = assert_raise(RuntimeError) { robot.read_command "PLACE asd, 2, EAST" }
    assert_equal("Positions have to be a number", error.to_s)

    error = assert_raise(RuntimeError) { robot.read_command "PLACE 1, asd, EAST" }
    assert_equal("Positions have to be a number", error.to_s)
  end

  def test_left
    robot = ToyRobot.new
    robot.read_command "PLACE 0, 0, EAST"
    robot.read_command "LEFT"

    assert_equal(0, robot.facing)

    robot.read_command "LEFT"
    assert_equal(270, robot.facing)
  end

  def test_right
    robot = ToyRobot.new
    robot.read_command "PLACE 0, 0, SOUTH"
    robot.read_command "RIGHT"

    assert_equal(270, robot.facing)

    robot.read_command "RIGHT"
    assert_equal(0, robot.facing)
  end

  def test_report
    robot = ToyRobot.new

    assert_equal("Output: 0, 0, NORTH", robot.report)

    robot.read_command "PLACE 2, 3, SOUTH"
    assert_equal("Output: 2, 3, SOUTH", robot.report)
  end

  def test_wrong_action
    robot = ToyRobot.new

    error = assert_raise(RuntimeError) { robot.read_command("ACTION 1, 2, 3") }
    assert_equal("Unknown action: ACTION", error.to_s)
  end

  def test_wrong_params
    robot = ToyRobot.new

    error = assert_raise(RuntimeError) { robot.read_command("MOVE asd, 2, 3") }
    assert_equal("Wrong number of parameters", error.to_s)

    error = assert_raise(RuntimeError) { robot.read_command("PLACE 1, 2, 3, 9") }
    assert_equal("Wrong number of parameters", error.to_s)

    error = assert_raise(RuntimeError) { robot.read_command("LEFT asd, 2, 3") }
    assert_equal("Wrong number of parameters", error.to_s)

    error = assert_raise(RuntimeError) { robot.read_command("RIGHT asd, 2, 3") }
    assert_equal("Wrong number of parameters", error.to_s)

    error = assert_raise(RuntimeError) { robot.read_command("REPORT asd, 2, 3") }
    assert_equal("Wrong number of parameters", error.to_s)
  end

end
