// JavaScript Document

function setName(name)
{
	document.getElementById('author').innerHTML=name;
}

function setWeibo(weibo)
{
	document.getElementById("weibo").innerHTML=weibo;
}

function setCommentCount(count)
{
	document.getElementById("count").innerHTML=count;
}

function setRepost(repost)
{
    document.getElementById("blog").innerHTML=repost;
	
}

function setRealRepost(repost)
{
    document.getElementById("realrepostdata").innerHTML=repost;
    
}

function setPhotoPos(width,height)
{
	var actWidth=(98-width)/2;
	var actHeight=(73-height)/2;
    
	document.getElementById("upload").style.left=actWidth+'px';
	document.getElementById("upload").style.top=actHeight+'px';
	
	document.getElementById("upload").style.width=width+'px';
	document.getElementById("upload").style.height=height+'px';
	
}

function resetPhoto()
{
    document.getElementById("upload").src="photo_default.png";
    document.getElementById("upload").style.width=98+'px';
	document.getElementById("upload").style.height=73+'px';		
    document.getElementById("upload").style.left=0+'px';
    document.getElementById("upload").style.top=0+'px';
}

function setBigPhotoPos(width,height)
{
	var actWidth=(200-width)/2;
	var actHeight=(150-height)/2;
    
	document.getElementById("upload").style.left=actWidth+'px';
	document.getElementById("upload").style.top=actHeight+'px';
}

function setComment(comment)
{
	document.getElementById("photo_raw_comment").innerHTML=comment;
}


function setDetailComment(comment)
{
	document.getElementById("photocommentdetail").innerHTML=comment;
    
}
function setStyle(style)
{
	if (style==0)
	{
		document.getElementById("head_style").src="head_renren@2x.png";
		return;
	}
	if (style==1)
	{
		document.getElementById("head_style").src="head_wb@2x.png";
		return;
	}
}

function setTitle(title)
{
	document.getElementById("title").innerHTML=title;
    
}

function gotoDetail()
{
	window.location.href="//gotoDetail";
}

function setAlbumName(album)
{
    document.getElementById("albumName").innerHTML=album;
}

function setPhotoNumber(number)
{
    document.getElementById("photonumber").innerHTML=number;
}

function setAlbumAuthor(author)
{
    document.getElementById("albumauthor").innerHTML=author;
}
