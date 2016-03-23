library(RCurl)
#Note: Please change the broswer key of your own on Line 31.

parseFigure <- function(figureName){
    print(figureName)
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
    }"), fileConn)
    close(fileConn)
    
    # Call the Google Vision API. Please input your broswer key here.
    resp <- system('curl -v -k -s -H "Content-Type: application/json" https://vision.googleapis.com/v1/images:annotate?key=YOUR_BROWSER_KEY --data-binary @base64figure.txt')
    print(resp)
    file.remove("base64figure.txt")
}

earthquakeFigureNames <- c("Earthquake1.jpg", "Earthquake2.jpg", "Earthquake3.jpg", "Earthquake4.jpg", 
                "Earthquake5.jpg", "Earthquake6.jpg", "Earthquake7.jpg", "Earthquake8.jpg", 
                "Earthquake9.jpg", "Earthquake10.jpg");
                
floodFigureNames <- c("flood1.jpg", "flood2.jpg", "flood3.jpg", "flood4.jpg", 
                "flood5.jpg", "flood6.jpg", "flood7.jpg", "flood8.jpg", 
                "flood9.jpg", "flood10.jpg");

lapply(earthquakeFigureNames, parseFigure)