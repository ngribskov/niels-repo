var Clock = React.createClass({
  propTypes: {
    csrf: React.PropTypes.string,
    open: React.PropTypes.bool,
    initProject: React.PropTypes.string,
    initDescription: React.PropTypes.string
  },
componentDidMount: function(){
  $(".project").val(this.props.initProject);
  $(".description").val(this.props.initDescription);
},
componentWillMount: function(){
    this.doAjax();
},
getInitialState: function(){

  return{ open: this.props.open,
          entries: []};
},

doDisplay: function(){
  var display = "";
  if (this.state.open==false) {
    display = "Closed";
  } else {
    display = "Open";
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
},

onSuccess: function(response){
  if (response.open == false) {
    $(".project").val("")
    $(".description").val("")
  }
  this.setState({
    entries: response
  });
},

doAjax: function(data){
  $.ajax({
    type: data? "POST" : "GET",
    url: "/",
    data: data ? data : null,
    dataType: 'json',
    success: this.onSuccess
  });

},

time: function(){
  var currentdate = new Date();
  var plusOrMinus = "+"
  // if (currentdate.getTimezoneOffset() < 0) {
  //   plusOrMinus = "-";
  // }
  // var utc = currentdate.getTimezoneOffset()/60;
  // if (utc < 10){
  //   utc = "0"+utc+":00"
  // }

  time =currentdate.getFullYear() + "-"
       + (currentdate.getMonth() + 1) + "-"
       + currentdate.getDate() + " "
       + currentdate.getHours() + ":"
       + currentdate.getMinutes() + ":"
       + currentdate.getSeconds() //+ " UTC "
      //  + plusOrMinus
      //  + utc;
  return time;
},
  setTime: function(){
    this.setState({
      time: this.time()
    });

  },
  componentDidMount: function(){
   window.setInterval(function () {
    this.setTime();
  }.bind(this), 1000);
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
    // var time = this.time();
    var timeEntries = this.makeList();
    return (
    <div>
      <div className='container'>
        <div>
        <p>{display}</p>
        <p>{this.state.time}</p>
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
      <div className='container'>
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
