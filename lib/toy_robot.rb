class ToyRobot

  MAX_POSITION = 4

  attr_reader :position_x, :position_y, :facing, :already_placed

  def initialize
    super
    @position_x = 0
    @position_y = 0
    @facing = FACING[:NORTH]
    @already_placed = false
  end

  def read_commands(commands)
    commands.each do |command|
      read_command(command)
    end
  end

  def read_command(command)
    parsed_command = parse_command(command)
    case parsed_command["action"]
    when "PLACE"
      raise "Wrong number of parameters" unless parsed_command["params"].length== 3
      place(parsed_command["params"][0], parsed_command["params"][1], parsed_command["params"][2])
    when "MOVE"
      raise "Wrong number of parameters" unless parsed_command["params"].empty?
      move if @already_placed
    when "RIGHT"
      raise "Wrong number of parameters" unless parsed_command["params"].empty?
      right if @already_placed
    when "LEFT"
      raise "Wrong number of parameters" unless parsed_command["params"].empty?
      left if @already_placed
    when "REPORT"
      raise "Wrong number of parameters" unless parsed_command["params"].empty?
      report if @already_placed
    else
      raise "Unknown action: " + parsed_command["action"]
    end
  end

  def place(pos_x, pos_y, facing)
    #Validations
    raise "Position X cannot be empty" if pos_x.nil?
    raise "Position Y cannot be empty" if pos_x.nil?
    raise "Positions have to be a number" unless (pos_x.is_a? Numeric) && (pos_y.is_a? Numeric)
    raise "Position can't be higher than " + MAX_POSITION.to_s if (pos_x > MAX_POSITION || pos_y > MAX_POSITION)
    raise "Position can't be negative" if (pos_x < 0 || pos_y < 0)
    raise "Not a valid facing value" unless FACING.key?(facing.to_sym)

    @position_x = pos_x.to_i
    @position_y = pos_y.to_i
    @facing = FACING[facing.to_sym]

    @already_placed = true
  end

  def move
    case @facing
    when FACING[:NORTH]
      @position_y = @position_y + 1 unless @position_y == MAX_POSITION
    when FACING[:EAST]
      @position_x = @position_x + 1 unless @position_x == MAX_POSITION
    when FACING[:SOUTH]
      @position_y = @position_y - 1 unless @position_y == 0
    when FACING[:WEST]
      @position_x = @position_x - 1 unless @position_x == 0
    end
  end

  def left
    degrees = @facing - 90
    degrees = 270 if degrees < 0

    @facing = degrees
  end

  def right
    degrees = @facing + 90
    degrees = 0 if degrees == 360

    @facing = degrees
  end

  def report
    text = "Output: " + @position_x.to_s + ", " + @position_y.to_s + ", " + FACING.key(@facing).to_s
    puts text

    text
  end

  private

  FACING = {
    NORTH: 0,
    EAST: 90,
    SOUTH: 180,
    WEST: 270
  }

  def parse_command(command)
    segments = command.split
    action = segments[0].sub ' ', ''

    params = command.sub action, ''

    result = {}
    result["action"] = action

    return result if params.nil?

    params = params.gsub(/\s+/, "")
    result["params"] = params.split(',')

    result
  end

end