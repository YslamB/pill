package queries

var Pharmacies = `
	select 
		json_agg(
			json_build_object(
				'id', p.id,
				'status', p.open_status,
				'name', p.name,
				'address', p.address,
				'phone', p.phone,
				'email', p.email,
				'images', p.images
			)
		)
	from pharmacies p
	where status = true;
`
var Categories = `
	select 
		json_agg(
			json_build_object(
				'id', c.id,
				'name', c.name,
				'icon', c.icon
			)
		)
	from categories c
	where status = true;
`

var Products = `	
	select 
		json_agg(
			json_build_object(
				'id', ps.id,
				'name', ps.name,
				'price', pps.price,
				-- 'category', cs.name,
				'pharmacy', phs.name,
				'bookmark', pps.id in (select ph_ps_id from bookmarks where device_id = 'test_device_id'),
				'images', ps.images
			)
		)
	from pharmacy_products pps
	left join products ps on pps.product_id = ps.id
	left join pharmacies phs on phs.id = pps.pharmacy_id
	-- left join categories cs on cs.id = pcs.category_id
	where pps.status = true;
`
