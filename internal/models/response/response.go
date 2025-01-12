package response

type ResultMessage struct {
	Tk string `json:"tk"`
	Ru string `json:"ru"`
	En string `json:"en"`
}

type ServerError struct {
	Message ResultMessage `json:"message"`
}
