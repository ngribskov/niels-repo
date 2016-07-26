class WelcomeController < ApplicationController
  def index
    @entry = Entry.last
    if @entry.open == true
    else
      @entry = Entry.new
      @entry.open = false
    end
    @entry.project = @entry.project || ""
    @entry.description = @entry.description || ""
    if request.xhr?
      render json: prep_entries
    end
  end

  def update
    status = params
    if status['open'] == 'true'
      entry = Entry.new
      entry.start = status['start']
      entry.project = status['project']
      entry.description = status['description']
      entry.open = true
      entry.save
    else
      entry = Entry.last
      entry.stop = status['stop']
      entry.open = false
      entry.project = status['project']
      entry.description = status['description']
      entry.elapsed = entry.stop - entry.start
      entry.save

    end
    render json: prep_entries
  end

  private
  def prep_entries
    all = Entry.all
    @@entries = []
    all.each do |i|
      elapsed = i.elapsed||0
      if i.stop
        stoptime = i.stop.to_time.strftime('%D %H:%M:%S')
      else
        stoptime = ""
      end
      out = {project: i.project,
             start: i.start.to_time.strftime('%D %H:%M:%S'),
             stop: stoptime,
             elapsed: secs_to_string(elapsed),
             open: i.open,
             description: i.description}
      @@entries.push(out)
    end
    return @@entries.reverse
  end

  def secs_to_string(seconds)
    time_string = Time.at(seconds).utc.strftime("%H:%M:%S")


    return time_string
  end
end
