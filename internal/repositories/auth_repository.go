package repositories

import (
	"context"
	"pharmacy/internal/models/form"
	"pharmacy/internal/queries"

	"github.com/jackc/pgx/v5/pgxpool"
)

type AuthRepository struct {
	db *pgxpool.Pool
}

func NewAuthRepository(db *pgxpool.Pool) *AuthRepository {
	return &AuthRepository{db}
}

func (r *AuthRepository) PharmacyLogin(ctx context.Context, form form.Login) (string, int, error) {
	var password string
	var id int
	err := r.db.QueryRow(
		ctx, queries.PharmacyLogin, form.Username,
	).Scan(&id, &password)

	return password, id, err
}

func (r *AuthRepository) AdminLogin(ctx context.Context, form form.Login) (string, int, error) {
	var password string
	var id int
	err := r.db.QueryRow(
		ctx, queries.AdminLogin, form.Username,
	).Scan(&id, &password)

	return password, id, err
}
