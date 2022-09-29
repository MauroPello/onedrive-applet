let busy = false;
let busyText = "Currently busy!";
let notBusyText = "Not doing anything!";

function isBusy(){
    return !busy;
}

function toggleBusy(){
    busy = !busy;
    downloadButton.enabled = !busy;
    uploadButton.enabled = !busy;
    subLabel.text = getInfo();
}

function getInfo(){
    if(busy)
        return busyText;
    return notBusyText;
}

function upload(){
    toggleBusy();

    // upload "onedrive --synchronize --upload-only"

    toggleBusy();
}

function download(){
    toggleBusy();

    // download "onedrive --synchronize --download-only"

    toggleBusy();
}