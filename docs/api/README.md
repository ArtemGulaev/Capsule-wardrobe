# Capsule Wardrobe API Documentation
## Base URL
{{base_url}} https://9bd132c9-60ba-40d6-a5c4-2b0b36901eac.mock.pstmn.io 

## Endpoints
### Authentication
- `POST /auth/login` - авторизация пользователя
### Item
- `GET /tasks` - получить все одежды
- `POST /tasks` - создать одежду
- `PATCH /tasks/:id` - обновить одежду
- `DELETE /tasks/:id` - удалить одежду
### Categories
- `GET /categories` - получить категории


## Примеры запросов
🔐 Login (Авторизация)
Успешный вход:
POST {{base_url}}/auth/login

📊 Get Wardrobe Statistics (Статистика гардероба)
Запрос:

GET {{base_url}}/wardrobe/statistics
Authorization: Bearer {{auth_token}}
