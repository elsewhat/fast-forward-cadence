import Artist from 0x02

transaction {
	let picture: @Artist.Picture?
	let collectionRef: &Artist.Collection

	prepare(account: AuthAccount){
		let printerRef  = getAccount(0x02)
			.getCapability(/public/ArtistPicturePrinter)
			.borrow<&Artist.Printer>()
			?? panic ("Error: Failed to get reference to printer from account")

	    self.collectionRef=account
			.getCapability(/public/ArtistPictureCollection)
			.borrow<&Artist.Collection>()
			?? panic ("Error: Failed to get reference to collection from account")			

		let pixels = "*   * * *   *   * * *   *"
	    let canvas = Artist.Canvas(
	      width: printerRef.width,
	      height: printerRef.height,
	      pixels: pixels
	    )
	    self.picture <- printerRef.print(canvas: canvas)


	}
	execute {
		if self.picture != nil {
			self.collectionRef.deposit(picture: <- self.picture!)
		}else {
			log("Error: Picture could not be printed")
			destroy self.picture
		}
	}
}