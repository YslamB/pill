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

var Product = `	
	select 
		ps.id,
		ps.name,
		pps.price,
		phs.name pharmacy,
		ps.description,
		pps.id in (select ph_ps_id from bookmarks where device_id = 'test_device_id') bookmark,
		ps.images
	from pharmacy_products pps
	left join products ps on pps.product_id = ps.id
	left join pharmacies phs on phs.id = pps.pharmacy_id
	where pps.status = true and pps.id = $1;
`

var Bookmarks = `
	select 
		json_agg(
			json_build_object(
				'id', pps.id,
				'name',ps.name,
				'price',pps.price,
				'pharmacy',ph.name,
				'bookmark', true,
				'images',ps.images	
			)
		)
	from bookmarks bs
	left join pharmacy_products pps on pps.id = bs.ph_ps_id
	left join products ps on ps.id = pps.product_id
	left join pharmacies ph on ph.id = pps.pharmacy_id
	where device_id = $1;
`

var AllProducts = `	
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
	from pharmacy_products main_pps 
	left join pharmacy_products pps on pps.product_id = main_pps.product_id
	left join products ps on pps.product_id = ps.id and ps.id = main_pps.product_id
	left join pharmacies phs on phs.id = pps.pharmacy_id
	-- left join categories cs on cs.id = pcs.category_id
	where pps.status = true and main_pps.id = $1;
`

var CategoryProducts = `
	select 
		json_agg(
			json_build_object(
				'id', ps.id,
				'name', ps.name,
				'price', pps.price,
				'category', cs.name,
				'pharmacy', phs.name,
				'bookmark', pps.id in (select ph_ps_id from bookmarks where device_id = 'test_device_id'),
				'images', ps.images
			)
		)
	from pharmacy_products pps
	left join products ps on pps.product_id = ps.id
	left join pharmacies phs on phs.id = pps.pharmacy_id
	left join product_categories pcs on pcs.product_id = ps.id
	left join categories cs on cs.id = pcs.category_id
	where pps.status = true and cs.id = $1;
`

var Search = `	
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
	where pps.status = true and ps.name ilike '%' || $1 || '%';
`
