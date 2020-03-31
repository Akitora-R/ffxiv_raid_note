function saveProgress() {
    let progressSelect=$("#progress");
    $.ajax({
        type: "POST",
        url: "ajaxSaveProgress",
        data: {progress:progressSelect.val()},
        dataType: "json",
        success: function (resp) {

        }
    });
}