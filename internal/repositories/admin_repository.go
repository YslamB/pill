package repositories

import (
	"context"

	"pharmacy/internal/models/form"
	"pharmacy/internal/queries"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgxpool"
)

type AdminRepository struct {
	db *pgxpool.Pool
}

func NewAdminRepository(db *pgxpool.Pool) *AdminRepository {
	return &AdminRepository{db}
}

func (r *AdminRepository) CreateCity(ctx context.Context, form form.CreateCity) gin.H {

	// r.db.QueryRow(ctx, queries.CreateCity, form.Name).Scan(&id, &password)

	return gin.H{"message": "Successfully saved into database"}
}

func (r *AdminRepository) CreatePharmacy(ctx context.Context, form form.CreatePharmacy) (string, int, error) {

	var password string
	var id int

	err := r.db.QueryRow(ctx, queries.CreatePharmacy, form.Name).Scan(&id, &password)

	return password, id, err
}

func (r *AdminRepository) AdminLogin(ctx context.Context, form form.Login) (string, int, error) {

	var password string
	var id int

	err := r.db.QueryRow(ctx, queries.AdminLogin, form.Username).Scan(&id, &password)

	return password, id, err
}
