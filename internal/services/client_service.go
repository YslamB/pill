package services

import (
	"context"
	"net/http"
	"pharmacy/internal/models/response"
	"pharmacy/internal/repositories"

	"github.com/jackc/pgx/v5/pgxpool"
)

type ClientService struct {
	repo *repositories.ClientRepository
}

func NewClientService(db *pgxpool.Pool) *ClientService {
	return &ClientService{repositories.NewClientRepository(db)}
}

func (s *ClientService) Pharmacies(ctx context.Context) response.Response {

	data, err := s.repo.Pharmacies(ctx)

	if err != nil {
		return response.Response{
			Error:  err,
			Status: http.StatusUnauthorized,
		}
	}

	return response.Response{Data: data}
}

func (s *ClientService) Categories(ctx context.Context) response.Response {

	data, err := s.repo.Categories(ctx)

	if err != nil {
		return response.Response{
			Error:  err,
			Status: http.StatusUnauthorized,
		}
	}

	return response.Response{Data: data}
}

func (s *ClientService) Products(ctx context.Context) response.Response {

	data, err := s.repo.Products(ctx)

	if err != nil {
		return response.Response{
			Error:  err,
			Status: http.StatusUnauthorized,
		}
	}

	return response.Response{Data: data}
}
