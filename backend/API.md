# API

Prepend the Render url:

https://recommendations-backend-h7dq.onrender.com/

## Users

Create a user

```POST /api/v1/users```

Body:

```json
{
    "user": {
        "first_name": "sarah",
        "last_name": "llewelyn",
        "email": "se.llewelyn@gmail.com",
        "password": "blahblah"
    }
    
}
```

## Auth

Get OAuth token with user credentials

```POST /oauth/token```

Body:

```json
{
	"grant_type": "password",
	"email": "ziggy@example.com",
	"password": "password",
	"client_id": "censored",
	"client_secret": "censored"
}
```

---

Auth Headers for an authenticated endpoint

ie ```GET /api/v1/tests```

Headers:

```json
{
  "Authorization": "Bearer eL0GRRgrmVe5lLcYoxcCegqMIhGbyvpOYxTG6c1lx5s"
}
```

---

How to get secrets.

Each client (web, android, iOS) has its own secret / uid.  Right now, they're seeded via the ```rails db:seed```
 script.  Can be retrieved for each via ```rails c```.

```shell
Doorkeeper::Application.find_by(name: "iOS Client").secret
Doorkeeper::Application.find_by(name: "iOS Client").uid
```


