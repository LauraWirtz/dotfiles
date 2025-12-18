if [ "`busctl get-property --user sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0 Visible`" == "b true" ]
then
	`busctl call --user sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0 SetVisible b false`
else
	`busctl call --user sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0 SetVisible b true`
fi
