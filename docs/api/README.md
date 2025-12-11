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
URL: {{base_url}}/auth/login?username=avemne

##  Wardrobe Management
Login Capsule Wardrobe
Name: Success - Valid Credentials
Method: POST
URL:  {{base_url}}/auth/login?username=avemne

Name: Error - Invalid Credentials
Method: POST
URL: {{base_url}}/auth/login?username=avemne

## Get All Clothing Items
Name: Success - With Items (Default Pagination)
Method: GET
URL:  {{base_url}}/tasks?status=deactive

Name: Error - Unauthorized
Method: GET
URL:  {{base_url}}/tasks?status=deactive

## Create Clothing Item
Name: Success - Item Created (Basic Fields)
Method: POST
URL: {{base_url}}/wardrobe/items

Name: Error - Category Not Found
Method: POST
URL: {{base_url}}/wardrobe/items

## Update Clothing Item
Name: Success - Item Updated
Method: PATCH
URL: {{base_url}}/wardrobe/items/1

Name: Error - Item Not Found
Method: PATCH
URL: {{base_url}}/wardrobe/items/9

## Delete Clothing Item
Name: Success - Item Deleted
Method: DELETE
URL: {{base_url}}/wardrobe/items/1

Name: Error - Item Not Found
Method: DELETE
URL: {{base_url}}/wardrobe/items/999

📂 Categories Management
## Get All Categories
Name: Success - With Items (Default Pagination)
Method: GET
URL: {{base_url}}/wardrobe/categories

Name: Success - Empty Wardrobe
Method: GET
URL: {{base_url}}/wardrobe/categories

Name: Error - Unauthorized
Method: GET
URL: {{base_url}}/wardrobe/categories


