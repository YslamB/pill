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

type AuthService struct {
	repo *repositories.AuthRepository
}

func NewAuthService(db *pgxpool.Pool) *AuthService {
	return &AuthService{repositories.NewAuthRepository(db)}
}

func (s *AuthService) PharmacyLogin(ctx context.Context, form form.Login) response.Response {

	pass, id, err := s.repo.PharmacyLogin(ctx, form)

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

func (s *AuthService) AsdminLogin(ctx context.Context, form form.Login) response.Response {

	pass, id, err := s.repo.AdminLogin(ctx, form)

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

	return response.Response{Data: gin.H{"access_token": accessToken, "refresh_token": refreshToken}, Status: http.StatusCreated}
}
