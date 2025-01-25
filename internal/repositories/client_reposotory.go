package repositories

import (
	"context"
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
