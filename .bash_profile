function idsentry() {
   ACTION=$1
   shift;
if [ "$ACTION" == "run" ]; then
   WEBJOB_NAME=$1
   shift;
   echo "webjob name: $WEBJOB_NAME"
   echo "action: $ACTION"
   az webapp webjob triggered run --name IDSentry2 --resource-group IDSentryResourceGroup -w $WEBJOB_NAE $@
el
   echo "apparently action isn't run"
   echo "$ACTION"
   az webapp webjob triggered $ACTION --name IDSentry2 --resource-group IDSentryResourceGroup $@
fi
}
export -f idsentry

function json:filter_by_name {
   read IN
   jq '.[] | .name' <<< IN
}
export -f json:filter_by_name
