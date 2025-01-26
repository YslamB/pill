package repositories

import (
	"context"
	"fmt"
	"pharmacy/internal/models/response"
	"pharmacy/internal/queries"

	"github.com/jackc/pgx/v5/pgxpool"
)

type ClientRepository struct {
	db *pgxpool.Pool
}

func NewClientRepository(db *pgxpool.Pool) *ClientRepository {
	return &ClientRepository{db}
}

func (r *ClientRepository) Pharmacies(ctx context.Context) ([]interface{}, error) {
	var phs = make([]interface{}, 0)

	// var password string
	// var id int

	err := r.db.QueryRow(ctx, queries.Pharmacies).Scan(&phs)

	return phs, err
}

func (r *ClientRepository) Categories(ctx context.Context) ([]interface{}, error) {
	var c = make([]interface{}, 0)

	err := r.db.QueryRow(ctx, queries.Categories).Scan(&c)

	return c, err
}

func (r *ClientRepository) Products(ctx context.Context) ([]interface{}, error) {
	var c = make([]interface{}, 0)

	err := r.db.QueryRow(ctx, queries.Products).Scan(&c)

	return c, err
}

func (r *ClientRepository) Product(ctx context.Context, id int) (interface{}, error) {
	var p response.Product

	err := r.db.QueryRow(ctx, queries.Product, id).Scan(&p.ID, &p.Name, &p.Price, &p.Pharmacy, &p.Description, &p.Bookmark, &p.Images)

	return p, err
}

func (r *ClientRepository) Bookmarks(ctx context.Context, d_id string) ([]interface{}, error) {
	var b = make([]interface{}, 0)

	err := r.db.QueryRow(ctx, queries.Bookmarks, d_id).Scan(&b)

	return b, err
}

func (r *ClientRepository) AllProducts(ctx context.Context, id int) ([]interface{}, error) {
	var c = make([]interface{}, 0)

	err := r.db.QueryRow(ctx, queries.AllProducts, id).Scan(&c)

	return c, err
}

func (r *ClientRepository) CategoryProducts(ctx context.Context, id int) ([]interface{}, error) {
	var c = make([]interface{}, 0)

	err := r.db.QueryRow(ctx, queries.CategoryProducts, id).Scan(&c)
	fmt.Println(c)
	return c, err
}

func (r *ClientRepository) Search(ctx context.Context, query string) ([]interface{}, error) {
	var s = make([]interface{}, 0)
	fmt.Println(query)
	err := r.db.QueryRow(ctx, queries.Search, query).Scan(&s)

	return s, err
}
