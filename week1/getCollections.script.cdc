import Artist from 0x02

pub fun main(): Int {
  let accounts = [
    getAccount(0x01),
    getAccount(0x02),
    getAccount(0x03),
    getAccount(0x04),
    getAccount(0x05)
  ]

  for account in accounts {
    	let collectionRef=account
        .getCapability(/public/ArtistPictureCollection)
        .borrow<&Artist.Collection>()
        ?? panic ("Error: Failed to get reference to collection from account")

      if collectionRef == nil {
        log("Error: Collection ref nil")
      } else 	{
        for canvas in collectionRef.getCanvases() {
          log("Display canvas")
          display(canvas:canvas)
        }
      }
  }
  return 0
}


pub fun display(canvas: Artist.Canvas){
  //As log doesn't consider line breaks, it complicates the program 
  //to temporarily store the results. Therefore, don't use the displayBuffer
  //var displayBuffer: String = "" 
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

  log(frameEdge)
  while(currentLine< canvas.height){
    var startIndex:Int = Int(currentLine)*Int(canvas.width)
    var endIndex:Int = Int(currentLine+1)*Int(canvas.width)
    var line = canvas.pixels.slice(from: startIndex, upTo: endIndex)
    //displayBuffer = displayBuffer.concat("|".concat(line).concat("|\n"))
    log("|".concat(line).concat("|"))
    currentLine = currentLine + 1
  }
  log(frameEdge)
}