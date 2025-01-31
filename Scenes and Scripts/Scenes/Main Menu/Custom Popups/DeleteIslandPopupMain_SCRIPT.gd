extends Panel

var Island_To_Delete : String

func showDeleteIslandPopup(Island_Name : String):
	$"..".visible = true
	Island_To_Delete = Island_Name
	updateNotice(Island_Name)

func updateNotice(Island_Name : String):
	$Notice.text = 'Are you sure you want to delete "' + Island_Name + '"?'

func getIslandToDelete():
	return Island_To_Delete
