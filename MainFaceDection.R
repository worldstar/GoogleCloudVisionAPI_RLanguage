library(RCurl)
library(httr)
library(RJSONIO)
#Note: Please change the broswer key of your own.
browserKey = "YOUR_BROWSER_KEY"

extractJSONContent <- function(x){
    test <- list()
    counter = 1;
    for(i in x){
        str(i)
        # print(i$mid)
        # print(i$description)
        # print(i$score)
    }
    
    return(test)
}

parseFigure <- function(figureName, directorayName){
    # Read the file and turn the binary figure into the base64 string.
    f = paste(getwd(), directorayName, figureName, sep = .Platform$file.sep)
    img = readBin(f, "raw", file.info(f)[1, "size"])
    b64 = base64Encode(img, "character")
    
    # Save the base64 string into a text file.
    fileConn<-file("base64figure.txt")
    writeLines(paste("{
      \"requests\":[
        {
          \"image\":{
            \"content\":\"",b64, "\"
                     },
    \"features\":[
      {
        \"type\":\"FACE_DETECTION\",
        \"maxResults\":3
      }
      ]
    }
    ]
    }"), fileConn)
    close(fileConn)
    
    # Call the Google Vision API. Please input your broswer key here.
    httpheader1 <- c(Accept="application/json; charset=UTF-8",
                "Content-Type"="application/json", "Content-Length"= nchar(lines))
                
    r <- POST(paste("https://vision.googleapis.com/v1/images:annotate?key=", browserKey), httpheader=httpheader1,
        body=upload_file("base64figure.txt"), encode="json", verbose())
    jsonText <- content(r, type = "application/json")
    results = extractJSONContent(jsonText$responses[[1]]$faceAnnotations)
    file.remove("base64figure.txt")
}

parseFigure("NonEarthquake4.jpg", directorayName = "images")