var ClockEntry = React.createClass({
  propTypes: {
    project: React.PropTypes.string,
    start: React.PropTypes.string,
    stop: React.PropTypes.string,
    elapsed: React.PropTypes.string,
    open: React.PropTypes.bool,
    description: React.PropTypes.string,
    id: React.PropTypes.number
  },

  render: function() {
    // debugger;
    var yesorno= "Closed";
    if(this.props.open){
      yesorno = "Open";
    }

    return (
      <tr>
          <td>{this.props.id}</td>
          <td>{this.props.project}</td>
          <td>{this.props.start}</td>
          <td>{this.props.stop}</td>
          <td>{this.props.elapsed}</td>
          <td>{yesorno}</td>
          <td>{this.props.description}</td>
      </tr>
    );
  }
});
