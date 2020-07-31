# Program represents time in minutes
class Task
  def initialize(description:, min_to_prev:)
    @description = description
    @min_to_prev = min_to_prev
    @realtime = nil
  end

  def set_realtime(prev_rt)
    raise "Already in realtime silly!" if realtime?

    @realtime = prev_rt + @min_to_prev * 60
  end

  def realtime
    raise "Realtime not set" if !realtime?

    @realtime
  end

  def print
    puts "----------------------------------"
    puts "#{"%02d" % @realtime.hour}:#{"%02d" % @realtime.min}"
    puts @description
  end

  private

  def realtime?
    !@realtime.nil?
  end
end

class Schedule
  def initialize(tasks:, hour:, min:)
    @tasks = tasks
    
    current_realtime = Time.new(2020, 7, 31, hour, min) 
    @tasks.each do |task|
      current_realtime = task.set_realtime(current_realtime)
    end
  end

  def print
    @tasks.each(&:print)
    puts "----------------------------------"
  end
end

tasks = [
  Task.new(
    min_to_prev: 0,
    description: "Start Levain",
  ),
  Task.new(
    min_to_prev: 5*60+25,
    description: "Begin Autolyse",
  ),
  Task.new(
    min_to_prev: 35,
    description: "Start Mix your dough, optionally use rhubaud method.",
  ),
  Task.new(
    min_to_prev: 15,
    description: "Bulk fermentation begins, performing 2 folds spaced 15 minutes apart, and last fold 30 minutes after the 2nd, totally 3 folds. Allow dough to rest for remainder of bulk fermentation",
  ),
  Task.new(
    min_to_prev: 3*60+45,
    description: "Preshape loaves",
  ),
  Task.new(
    min_to_prev: 25,
    description: "Shape your loaves and place them in their proofing baskets. Place them in plastic bags to prevent drying out, and proof them overnight in the fridge.",
  ),
  Task.new(
    min_to_prev: 14*60,
    description: "Preheat oven with dutch ovens in their, for an hour",
  ),
  Task.new(
    min_to_prev: 1*60,
    description: "Bake",
  ),
]

schedule = Schedule.new(tasks: tasks, hour: ARGV[0], min: ARGV[1])
schedule.print
