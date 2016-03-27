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
    print(figureName)
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
        \"type\":\"LABEL_DETECTION\",
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
    results = extractJSONContent(jsonText$responses[[1]]$labelAnnotations)
    file.remove("base64figure.txt")
}

earthquakeFigureNames <- c("Earthquake1.jpg", "Earthquake2.jpg", "Earthquake3.jpg", "Earthquake4.jpg", 
                "Earthquake5.jpg", "Earthquake6.jpg", "Earthquake7.jpg", "Earthquake8.jpg", 
                "Earthquake9.jpg", "Earthquake10.jpg");
                
floodFigureNames <- c("flood1.jpg", "flood2.jpg", "flood3.jpg", "flood4.jpg", 
                "flood5.jpg", "flood6.jpg", "flood7.jpg", "flood8.jpg", 
                "flood9.jpg", "flood10.jpg");

allFiles <- list.files("images")

lapply(allFiles[2], parseFigure, directorayName = "images")