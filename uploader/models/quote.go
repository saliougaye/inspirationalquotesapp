package models

import (
	"fmt"

	"go.mongodb.org/mongo-driver/bson"
)

type Quote struct {
	Quote  string
	Author string
	Genre  string
}

func (q Quote) ToString() string {
	quote := fmt.Sprintf("%s\n%s\n%s\n", q.Quote, q.Genre, q.Author)

	return quote
}

func (q Quote) ToBson(doc *bson.D, err error) {
	data, err := bson.Marshal(q)

	if err != nil {
		return
	}

	err = bson.Unmarshal(data, doc)

	return
}
