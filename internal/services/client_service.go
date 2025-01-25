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

	return response.Response{Data: response.Data{Data: data}}
}

func (s *ClientService) Categories(ctx context.Context) response.Response {

	data, err := s.repo.Categories(ctx)

	if err != nil {
		return response.Response{
			Error:  err,
			Status: http.StatusUnauthorized,
		}
	}

	return response.Response{Data: response.Data{Data: data}}
}

func (s *ClientService) Products(ctx context.Context) response.Response {

	data, err := s.repo.Products(ctx)

	if err != nil {
		return response.Response{
			Error:  err,
			Status: http.StatusUnauthorized,
		}
	}

	return response.Response{Data: response.Data{Data: data}}
}

func (s *ClientService) Product(ctx context.Context, id int) response.Response {

	data, err := s.repo.Product(ctx, id)

	if err != nil {
		return response.Response{
			Error:  err,
			Status: http.StatusUnauthorized,
		}
	}

	return response.Response{Data: response.Data{Data: data}}
}

func (s *ClientService) Bookmarks(ctx context.Context, d_id string) response.Response {

	data, err := s.repo.Bookmarks(ctx, d_id)

	if err != nil {
		return response.Response{
			Error:  err,
			Status: http.StatusUnauthorized,
		}
	}

	return response.Response{Data: response.Data{Data: data}}
}

func (s *ClientService) AllProducts(ctx context.Context, id int) response.Response {

	data, err := s.repo.AllProducts(ctx, id)

	if err != nil {
		return response.Response{
			Error:  err,
			Status: http.StatusUnauthorized,
		}
	}

	return response.Response{Data: response.Data{Data: data}}
}

func (s *ClientService) CategoryProducts(ctx context.Context, id int) response.Response {

	data, err := s.repo.CategoryProducts(ctx, id)

	if err != nil {
		return response.Response{
			Error:  err,
			Status: http.StatusUnauthorized,
		}
	}

	return response.Response{Data: response.Data{Data: data}}
}
