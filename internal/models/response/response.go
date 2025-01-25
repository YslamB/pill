package response

type ResultMessage struct {
	Tk string `json:"tk"`
	Ru string `json:"ru"`
	En string `json:"en"`
}

type ServerError struct {
	Message ResultMessage `json:"message"`
}

type Pharmacy struct {
	ID      int    `json:"id"`
	Status  bool   `json:"status"`
	Name    string `json:"name"`
	Address string `json:"address"`
	Phone   string `json:"phone"`
	Email   string `json:"email"`
	Images  []string
}

type Pharmacies struct {
	Pharmacies []interface{} `json:"pharmacies"`
}
