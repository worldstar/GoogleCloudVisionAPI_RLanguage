library(RCurl)
#Note: Please change the broswer key of your own on Line 30.

parseFigure <- function(figureName){
    # Read the file and turn the binary figure into the base64 string.
    f = paste(getwd(), "images/", figureName, sep = .Platform$file.sep)
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
    resp <- system('curl -v -k -s -H "Content-Type: application/json" https://vision.googleapis.com/v1/images:annotate?key=YOUR_BROWSER_KEY --data-binary @base64figure.txt')
    print(resp)
    file.remove("base64figure.txt")
}

parseFigure("NonEarthquake4.jpg")