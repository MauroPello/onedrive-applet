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
    downloadButton.enabled = !busy;
    uploadButton.enabled = !busy;
    subLabel.text = getInfo();
}

// returns current state (used for toolTipSubText)
function getInfo(){
    if(busy)
        return busyText;
    return notBusyText;
}