package queries

var PharmacyLogin = `
	select id, password from pharmacy_managers where username = $1;
`

var AdminLogin = `
	select id, password from admins where username = $1;
`
