Проблемный вариант:
ClothingItems (item_id, name, description, purchase_date, price, image_url, user_id, username, user_email, category_id, category_name, color_id, color_name, size_id, size_value, brand_id, brand_name, season_names, material_names, occasion_names)
Проблемы этой структуры:
Избыточность: username, email повторяются для каждого предмета одежды пользователя

Аномалия обновления: при изменении email пользователя нужно обновлять все его предметы одежды

Аномалия удаления: удаление последнего предмета одежды может потерять информацию о пользователе

Повторяющиеся группы: season_names, material_names, occasion_names содержат множественные значения

Частичные зависимости: category_name зависит только от category_id, а не от всего первичного ключа

Users (user_id PK, username, email, password_hash, created_at, last_login)

Categories (category_id PK, name, type, description)
Colors (color_id PK, name, hex_code, color_family)
Sizes (size_id PK, size_system, value, body_measurements)
Brands (brand_id PK, name, country, website)
Seasons (season_id PK, name, description)
Materials (material_id PK, name, description, care_instructions)
Occasions (occasion_id PK, name, formality_level)

ClothingItems (item_id PK, name, description, purchase_date, price, image_url, 
              is_favorite, last_worn, wear_count, condition, storage_location, created_at,
              user_id FK, category_id FK, color_id FK, size_id FK, brand_id FK)
