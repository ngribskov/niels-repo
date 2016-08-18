var Polaroid = React.createClass({
  propTypes: {
    photos: React.PropTypes.array
  },

  makeDisplay: function(){
    var photoEntry;
    var photo;
    var allPhotos=[];
    for(var i=0;i<this.props.photos.length;i++){
      photo = this.props.photos[i];
      var id = photo[3] + "";
      var style = "left:"+photo[1]+"; top: -" + photo[2];
      var source ="~/app/assets/imagages/"+ id +".jpg";
      var transform = "transform: rotate("+photo[0]+"deg)";
      photoEntry = (
        <div className="photo" id={id} htmlStyle={style}>
          <a href={source} data-lightbox={id} data-title="stub">
            <img id={id} src={source} htmlStyle={transform}/>
          </a>
        </div>
      );

      allPhotos.push(photoEntry);
    }
    return allPhotos;
  },
  render:function(){ return(
    <div></div>
  )}


});
