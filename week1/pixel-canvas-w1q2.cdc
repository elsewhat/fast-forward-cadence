
pub struct Canvas {

  pub let width: UInt8
  pub let height: UInt8
  pub let pixels: String

  init(width: UInt8, height: UInt8, pixels: String) {
    self.width = width
    self.height = height
    // The following pixels
    // 123
    // 456
    // 789
    // should be serialized as
    // 123456789
    self.pixels = pixels
  }
}

pub resource Picture {
  pub let canvas: Canvas
  
  init(canvas: Canvas) {
    self.canvas = canvas
  }

  pub fun display(){
    //As log doesn't consider line breaks, it complicates the program 
    //to temporarily store the results. Therefore, don't use the displayBuffer
    //var displayBuffer: String = "" 
    var currentLine:UInt8  = 0
    var frameEdge:String = ""
    var currentColumn:UInt8 = 0

    while (currentColumn<self.canvas.width+2){
      //First and last should be a plus so use modula operator
      if(currentColumn%(self.canvas.width+1) == 0){
        frameEdge = frameEdge.concat("+")
      }else {
        frameEdge = frameEdge.concat("-")
      }
      currentColumn = currentColumn+1
    }

    log(frameEdge)
    while(currentLine< self.canvas.height){
      var startIndex:Int = Int(currentLine)*Int(self.canvas.width)
      var endIndex:Int = Int(currentLine+1)*Int(self.canvas.width)
      var line = self.canvas.pixels.slice(from: startIndex, upTo: endIndex)
      //displayBuffer = displayBuffer.concat("|".concat(line).concat("|\n"))
      log("|".concat(line).concat("|"))
      currentLine = currentLine + 1
    }
    log(frameEdge)
    
    
  }
}

pub fun serializeStringArray(_ lines: [String]): String {
  var buffer = ""
  for line in lines {
    buffer = buffer.concat(line)
  }

  return buffer
}

pub resource Printer {
  pub let printHistory:{String: Bool}
  
  init() {
    self.printHistory = {}
  }

  pub fun print(canvas: Canvas): @Picture? {
    if (!self.printHistory.containsKey(canvas.pixels)){
      let picture <- create Picture(canvas: canvas)
      picture.display()
      self.printHistory[canvas.pixels]= true
      return picture
    }else {
      log("Canvas has already been printed");
      return nil
    }

  }
}

pub fun main() {
  let pixelsX = [
    "*   *",
    " * * ",
    "  *  ",
    " * * ",
    "*   *"
  ]
  let canvasX = Canvas(
    width: 5,
    height: 5,
    pixels: serializeStringArray(pixelsX)
  )
  let printer <- create Printer()
  printer.print(canvas: canvasX)
  printer.print(canvas: canvasX)
  destroy printer
}