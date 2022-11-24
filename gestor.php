<html><head> <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0, 
minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
	<style>
html,body{padding:0;margin:0;background:black;color:white}
a{color:white}
input[type=text]{color:green;background:#1e1a15}
		</style>
	<script src="css/motor.js?dd=z"></script>
	<script language="javascript" type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/6.65.7/codemirror.min.js"></script>
<script language="javascript" type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/6.65.7/mode/perl/perl.min.js"></script>
<script language="javascript" type="text/javascript" src="https://codemirror.net/5/addon/display/autorefresh.js"></script>

<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/6.65.7/codemirror.min.css"></link>
<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/6.65.7/theme/abbott.min.css"></link>
</head>
<body>
<?php
function show_files($start) {
    $contents = scandir($start);
   array_splice($contents, 0,2);
 if(dirname($start)."/"!="./"){  echo "<a href='gestor.php?folder=./'>./</a>"; 
    echo "<br>"; } 
 if($start!="./"){
  echo "<a href='gestor.php?folder=".dirname($start)."/'>".dirname($start)."/</a>";
  } else { echo "HOME"; }
    echo "<ul>";
    foreach ($contents as $item ) {
        if ( is_dir("$start/$item") && (substr($item, 0,1) != '.') ) {
          if(is_dir($start."/".$item)){
    
            echo "<li><a href='gestor.php?folder=$start$item/'>$item/</a></li>";
} 
        } else {
            echo "<li><a href='gestor.php?edit=edit&path=$start&file=$item'>$item</a></li>";
        }
      
    }
    echo "</ul>";
}

 if(isset($_POST['action'])){
  $action = $_POST['action'];
    if($action=='save' ){
               save(); }
    if($action=='load'){
             load(); }
   if($action=='delete' ){
        delete(); 
    }
    }
    function save() {
   $content = $_POST['content'];
   $fh = fopen($_POST['path'].$_POST['file'],'w');
   fwrite($fh,urldecode(str_replace("textar","textarea",$content)));
   fclose($fh);    }
    
    function load() {
    $fh = fopen($_POST['path'].$_POST['file'],'r');
while ($line = fgets($fh)) {
  echo "mmmm".(str_replace("textar","textar",$line));
}
fclose($fh);
    }
     function delete() {
        unlink($_POST['path'].$_POST['file']);
    }


if(isset($_GET['folder'])){
$fold = urldecode($_GET['folder']);
if($_GET['folder']==''){
show_files('./');
}else{
show_files($fold);
} }  
?>
<?php
 if(isset($_GET['edit'])){   ?>

 <input type="text" id="filename" value="<?php echo $_GET['file']; ?>"><br>
<textarea id="editor"
onblur="doBlur(this)"><?php
$fh = fopen($_GET['path'].$_GET['file'],'r');
while ($line = fgets($fh)) {
  echo(str_replace("textarea","textar",$line));
}
fclose($fh);
?></textarea>
<button id="save">save</button>
<button id="load" style="display:none">load</button><br><br><br><br><br><br><br><br>
<button id="delete">delete</button>
 <button id="aut">delete</button>
  
 	<script>
 var editor = CodeMirror.fromTextArea(document.getElementById('editor'), {
    lineNumbers: true,
    mode: 'text/x-perl',
    theme: 'abbott',
});
editor.setSize("100%", "80%");
 	var url = "gestor.php";
<?php echo "var file='".$_GET['file']."';  ";?>
<?php echo "var path ='".$_GET['path']."';  "; ?>
 var formData = new FormData();
 $(document).ready(function() {
 $("#save").click(function() {
  var text =  encodeURIComponent(editor.getValue());
 	formData.append('file',file);
    formData.append('path',path);
    formData.append('content', text); 
    formData.append('action','save');
      jQuery.ajax({
        url : url,
        contentType: false,
   processData: false,
        data : formData,
        type: 'POST', success:function(res){
editor.blur();
},
        error:function (){}
    });
    return true;
});
$("#delete").click(function() {
	formData.append('file',file);
    formData.append('path',path);
    formData.append('action','delete');
    jQuery.ajax({
        url : url,
        contentType: false,
   processData: false,
        data : formData,
        type: 'POST',
        error:function (){}
    });
    return  true;
});
$("#load").click( function() {
	alert('');
	formData.append('file',file);
    formData.append('path',path);
    formData.append('action','load');
    jQuery.ajax({
        url : url,
    contentType: false,
   processData: false,
        data : formData,
        type: 'POST',
        success : function(html) {
            $("#html_content").val(html);
        },
        error:function (){}
    });
    return true;
});
});
function doBlur(obj) {
  setTimeout(function() { obj.focus(); }, 10);
}
</script>
<?php  } ?>
