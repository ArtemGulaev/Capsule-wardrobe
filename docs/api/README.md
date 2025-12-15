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
##  Authentication
Login

Name: Error - User not found
Method: POST
{{base_url}}/api/auth/login?username=23423&password=WrongPass

Name: Success Login
Method: POST
{{base_url}}/api/auth/login?username=artem&password=Password123

##  Wardrobe Management
## Get All Clothing Items
Name: Success - With Items
Method: GET
URL:  {{base_url}}/api/items/1

Name: Error - Unauthorized
Method: GET
URL:  {{base_url}}/api/items/999

## Create Clothing Item
Name: Success - Item Created
Method: POST
URL: {{base_url}}/api/items?name=Футболка&type=верх&color=белый

Name: Error - Category Not Found
Method: POST
URL: {{base_url}}/api/items?type=низ

## Update Clothing Item
Name: Success - Item Updated
Method: PATCH
URL: {{base_url}}/api/items/1?name=Футболка+новая

Name: Error - Item Not Found
Method: PATCH
URL: {{base_url}}/api/items/999?color=красный

## Delete Clothing Item
Name: Success - Item Deleted
Method: DELETE
URL: {{base_url}}/api/items/1

Name: Error - Item Not Found
Method: DELETE
URL: {{base_url}}/api/items/999

📂 Categories Management
## Get All Categories
Name: Success - With Items
Method: GET
URL: {{base_url}}/categories

Name: Success - Empty Wardrobe
Method: GET
URL: {{base_url}}/categories?with_count=true
