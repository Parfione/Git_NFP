extends RichTextLabel

func init(in_text:String,lien:String):
	if lien : 
		text= "[b][url=%s]%s[/url]" % [lien,in_text]
	else :
		text = "[b]"+in_text


func _on_meta_clicked(meta):
	OS.shell_open(meta)
