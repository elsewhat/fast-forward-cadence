import Artist from "./artist.contract.cdc"

//Execute with 
//>flow scripts execute displayCollection.script.cdc --args-json='[{"type":"Address", "value":"0x01cf0e2f2f715450"}]'

// Return an array of formatted Pictures that exist in the account with the a specific address.
// Return nil if that account doesn't have a Picture Collection.
pub fun main(address: Address): [String]? {
    let account = getAccount(address)
    let collectionRef=account
        .getCapability(/public/ArtistPictureCollection)
        .borrow<&Artist.Collection>()
        ?? panic ("Error: Failed to get reference to collection from account")

    let collectionContent:[String] = []

    if collectionRef == nil {
        return nil
    } else 	{
        for canvas in collectionRef.getCanvases() {
            collectionContent.append(getFormattedPicture(canvas:canvas))
        }
        return collectionContent
    }
}

pub fun convert(canvas: Artist.Canvas):String{
  var displayBuffer: String = "" 
  var currentLine:UInt8  = 0
  var frameEdge:String = ""
  var currentColumn:UInt8 = 0


  while (currentColumn<canvas.width+2){
    //First and last should be a plus so use modula operator
    if(currentColumn%(canvas.width+1) == 0){
      frameEdge = frameEdge.concat("+")
    }else {
      frameEdge = frameEdge.concat("-")
    }
    currentColumn = currentColumn+1
  }

  displayBuffer = displayBuffer.concat(frameEdge)
  while(currentLine< canvas.height){
    var startIndex:Int = Int(currentLine)*Int(canvas.width)
    var endIndex:Int = Int(currentLine+1)*Int(canvas.width)
    var line = canvas.pixels.slice(from: startIndex, upTo: endIndex)
    displayBuffer = displayBuffer.concat("|".concat(line).concat("|\n"))
    //log("|".concat(line).concat("|"))
    currentLine = currentLine + 1
  }
  displayBuffer = displayBuffer.concat(frameEdge)

  return displayBuffer
}

pub fun getFormattedPicture(canvas: Artist.Canvas): String {
  let frameHorizontal = "+-----+"
  let frameVertical = "|"

  let height = Int(canvas.height)
  let width = Int(canvas.width)
  
  var row = 0
  var picture = ""
  picture = picture.concat(frameHorizontal)
  while row < height {
    let pixels = canvas.pixels.slice(from: row * width, upTo: (row + 1) * width)
    picture = picture.concat(frameVertical.concat(pixels).concat(frameVertical))
    row = row + 1
  }
  picture = picture.concat(frameHorizontal)
  return picture;
}