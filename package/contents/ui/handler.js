let busy = false;
let lastAction = "";
let busyText = "Currently busy!";
let notBusyText = "Not doing anything!";

// to set the last action done for user messages
function setLastAction(value){
    lastAction = value;
}

// toggle for state
function toggleBusy(){
    busy = !busy;
    downloadBtn.enabled = !busy;
    uploadBtn.enabled = !busy;
    dryrunCb.enabled = !busy;
    stopBtn.enabled = busy;
    subLabel.text = getInfo();
}

// returns current state (used for toolTipSubText)
function getInfo(){
    if(busy)
        return busyText;
    return notBusyText;
}