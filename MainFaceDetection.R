library(RCurl)
library(httr)
library(RJSONIO)
#Note: Please change the broswer key of your own.
browserKey = "YOUR_BROWSER_KEY"

extractJSONContent <- function(x){
    test <- list()
    print(paste("$detectionConfidence: ", x[[1]]$detectionConfidence))
    print(paste("$landmarkingConfidence: ", x[[1]]$landmarkingConfidence))
    print(paste("detectionConfidence: ", x[[1]]$joyLikelihood))
    print(paste("$joyLikelihood: ", x[[1]]$sorrowLikelihood))
    print(paste("$angerLikelihood: ", x[[1]]$angerLikelihood))
    print(paste("$surpriseLikelihood: ", x[[1]]$surpriseLikelihood))
    print(paste("$underExposedLikelihood: ", x[[1]]$underExposedLikelihood))
    print(paste("$blurredLikelihood: ", x[[1]]$blurredLikelihood))
    print(paste("$headwearLikelihood: ", x[[1]]$headwearLikelihood))
    
    return(x)
}

parseFigure <- function(figureName, directorayName){
    # Read the file and turn the binary figure into the base64 string.
    f = paste(getwd(), directorayName, figureName, sep = .Platform$file.sep)
    img = readBin(f, "raw", file.info(f)[1, "size"])
    b64 = base64Encode(img, "character")
    
    # Save the base64 string into a text file.
    fileConn<-file("base64figure.txt")
    lines = paste("{
      \"requests\":[
        {
          \"image\":{
            \"content\":\"", b64, "\"
                     },
    \"features\":[
      {
        \"type\":\"FACE_DETECTION\",
        \"maxResults\":3
      }
      ]
    }
    ]
    }")
    writeLines(lines, fileConn)
    close(fileConn)
    
    # Call the Google Vision API. Please input your broswer key here.
    httpheader1 <- c(Accept="application/json; charset=UTF-8",
                "Content-Type"="application/json", "Content-Length"= nchar(lines))
                
    r <- POST(paste("https://vision.googleapis.com/v1/images:annotate?key=", browserKey), httpheader=httpheader1,
        body=upload_file("base64figure.txt"), encode="json", verbose())
    jsonText <- content(r, type = "application/json")
    results = extractJSONContent(jsonText$responses[[1]]$faceAnnotations)
    file.remove("base64figure.txt")
    
    return(results)
}

parseFigure("NonEarthquake4.jpg", directorayName = "images")