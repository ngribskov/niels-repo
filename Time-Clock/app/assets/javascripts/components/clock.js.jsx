var Clock = React.createClass({
  propTypes: {
    csrf: React.PropTypes.string,
    open: React.PropTypes.bool,
    initProject: React.PropTypes.string,
    initDescription: React.PropTypes.string
  },

componentWillMount: function(){
  $(".project").val(this.props.initProject);
  $(".description").val(this.props.initDescription);
    this.doAjax();
},
getInitialState: function(){

  return{ open: this.props.open,
          entries: []};
},

doDisplay: function(){
  var display = "";
  if (this.state.open==false) {
    display = "Currently: Clocked Out";
  } else {
    display = "Currently: Clocked In";
  }
  return display;
},

onClockIn: function(){
  // event.preventDefault();
  this.setState({
    open: true
  });
   data ={start: this.time(),
          open: true,
       project: $(".project").val(),
   description: $(".description").val()};
  this.doAjax(data);

},
onClockOut: function(){
  // event.preventDefault();
  this.setState({
    open: false
  });
  data ={stop: this.time(),
          open: false,
       project: $(".project").val(),
   description: $(".description").val()};
  this.doAjax(data);
  $(".project").val("");
  $(".description").val("");
},

onSuccess: function(response){
  this.setState({
    entries: response
  });
},

doAjax: function(data,url){
  $.ajax({
    type: data? "POST" : "GET",
    url: url? url : "/",
    data: data ? data : null,
    dataType: 'json',
    success: this.onSuccess
  });

},

time: function(){
  var currentdate = new Date();
  var hours;
  var minutes;
  var seconds;

  if (currentdate.getHours() < 10){hours = "0" + currentdate.getHours()
  }else{hours = currentdate.getHours()}
  if (currentdate.getMinutes() < 10){minutes = "0" + currentdate.getMinutes()
  }else{minutes = currentdate.getMinutes()}
  if (currentdate.getSeconds() < 10){seconds = "0" + currentdate.getSeconds()
  }else{seconds = currentdate.getSeconds()}

  time =currentdate.getFullYear() + "-"
       + (currentdate.getMonth() + 1) + "-"
       + currentdate.getDate() + " "
       + hours + ":"
       + minutes + ":"
       + seconds
  return time;
},
  setTime: function(){
    this.setState({
      time: this.time()
    });

  },
  componentDidMount: function(){
    $(".project").val(this.props.initProject);
    $(".description").val(this.props.initDescription);
   window.setInterval(function () {
    this.setTime();
  }.bind(this), 1000);
},

filterSubmit: function(event){
  event.preventDefault();
  data = { project : $("#project-filter").val(),
             start : $("#start").val(),
              stop : $("#stop").val(),
      current_time : this.time()};
  url = '/filter';
  this.doAjax(data,url);
},

clearFilter: function(event){
  event.preventDefault();

  $("#project-filter").val("");
  $("#start").val("");
  $("#stop").val("");
  this.doAjax();
},

  makeList: function(){
    var entry;
    var allEntries = []
    var entryItem;
    for(var i=0; i<this.state.entries.length;i++){
      entry = this.state.entries[i]
      entryItem = (
        <ClockEntry      id={entry.id}
                    project={entry.project}
                      start={entry.start}
                       stop={entry.stop}
                    elapsed={entry.elapsed}
                       open={entry.open}
                description={entry.description} />
      );
    allEntries.push(entryItem)
  }
    return allEntries;
  },



  render: function() {
    var display = this.doDisplay();
    var timeEntries = this.makeList();
    return (
    <div>
      <div className='container'>
        <div className = "col-md-12">
        <div>
          <h3>{display}</h3>
          <p>The Current Time is {this.state.time}</p>
          <button className="btn btn-success" onClick={this.onClockIn}>Clock In</button>
          <button className="btn btn-danger" onClick={this.onClockOut}>Clock Out</button>
        </div>
        <div className="input-group">
          <label id='project'>Project Name: </label>
          <input id='project' className='form-control project' type='text'></input>
          <br/>
          <label id='description'>Description: </label>
          <input id='description' className='form-control description' type='text-area'></input>
        </div>
      </div>
      </div>
      <div className='container'>
        <form id="filter-form" className="filter-form" action='filter'method="POST">
          <input name="authenticity_token" id="authenticity_token" value={this.props.csrf} type="hidden"/>
          <div className='col-md-2'>
            <label htmlFor="project-filter">Project</label>
            <input id="project-filter" type="text" className="form-control project-filter"/>
          </div>
          <div className="col-md-2">
            <label htmlFor="start">Start</label>
            <input id="start" type="date" className="form-control start"/>
          </div>
          <div className="col-md-2">
            <label htmlFor="stop">Stop</label>
            <input id="stop" type="date" className="form-control stop"/>
          </div>
          <div className="col-md-1">
            <label htmlFor="filter-submit"/>
            <input id="filter-submit" type="submit" value="Filter" className="btn"  onClick={this.filterSubmit}/>
          </div>
          <div className="col-md-1">
            <label htmlFor="filter-clear"/>
            <input id="filter-clear" type="submit" value="Clear Filter" className="btn"  onClick={this.clearFilter}/>
          </div>
        </form>
      </div>
      <div className = "container">
        <table className="table">
          <thead>
            <tr>
              <th>ID</th>
              <th>Project</th>
              <th>Start Time</th>
              <th>Stop Time</th>
              <th>Elapsed Time</th>
              <th>Open?</th>
              <th>Description</th>
            </tr>
          </thead>
          <tbody>
            {timeEntries}
          </tbody>
        </table>
      </div>
    </div>
    );
  }
});
