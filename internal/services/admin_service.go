package services

import (
	"context"
	"net/http"

	"pharmacy/internal/models/form"
	"pharmacy/internal/models/response"
	"pharmacy/internal/repositories"
	"pharmacy/pkg/utils"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgxpool"
	"golang.org/x/crypto/bcrypt"
)

type AdminService struct {
	repo *repositories.AdminRepository
}

func NewAdminService(db *pgxpool.Pool) *AdminService {
	return &AdminService{repositories.NewAdminRepository(db)}
}

func (s *AdminService) CreatePharmacy(ctx context.Context, form form.CreatePharmacy) response.Response {

	pass, id, err := s.repo.CreatePharmacy(ctx, form)

	if err != nil || pass == "" {
		return response.Response{
			Error:  err,
			Status: http.StatusNotFound,
		}
	}

	comparationError := bcrypt.CompareHashAndPassword(
		[]byte(pass),
		[]byte(form.Password),
	)

	if comparationError != nil {
		return response.Response{
			Error:  comparationError,
			Status: http.StatusUnauthorized,
		}
	}

	accessToken, refreshToken := utils.CreateRefreshAccsessToken(id, "manager")

	return response.Response{Data: gin.H{"access_token": accessToken, "refresh_token": refreshToken}, Status: http.StatusOK}
}
