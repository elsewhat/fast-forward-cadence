import Artist from 0x01cf0e2f2f715450

transaction {
	prepare(account: AuthAccount) {
		let collection <- Artist.createCollection()
		account.save(
			<- collection,
			to: /storage/ArtistPictureCollection
		)
		account.link<&Artist.Collection>(
			/public/ArtistPictureCollection,
			target: /storage/ArtistPictureCollection
		)
	}
}