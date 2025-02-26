package queries

var CreatePharmacy = `
	insert into 
	pharmacies(
		name,
		address,
		images,
		phone,
		email,
		open_time,
		close_time
	)
	values (
		$1,
		$2,
		$3,
		$4,
		$5,
		$6,
		$7
	)
`

var CreateCity = `
	insert into cities (name)
	values ($1)
`
