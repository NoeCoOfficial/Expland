extends Panel

func showDeleteIslandPopup(Island_Name : String):
	$"..".visible = true
	updateNotice(Island_Name)

func updateNotice(Island_Name : String):
	$Notice.text = 'Are you sure you want to delete "' + Island_Name + '"?'
