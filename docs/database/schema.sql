-- Пользователи системы
Users (
  user_id INT PRIMARY KEY,
  username VARCHAR(50) NOT NULL UNIQUE,
  email VARCHAR(100) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  last_login TIMESTAMP
)

-- Категории одежды
Categories (
  category_id INT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  type ENUM('верх', 'низ', 'обувь', 'аксессуары', 'верхняя одежда') NOT NULL,
  description TEXT
)

-- Цвета
Colors (
  color_id INT PRIMARY KEY,
  name VARCHAR(30) NOT NULL,
  hex_code CHAR(7),
  color_family VARCHAR(20)
)

-- Размеры
Sizes (
  size_id INT PRIMARY KEY,
  size_system ENUM('RU', 'EU', 'US', 'UK') NOT NULL,
  value VARCHAR(10) NOT NULL,
  body_measurements TEXT
)

-- Бренды
Brands (
  brand_id INT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  country VARCHAR(50),
  website VARCHAR(255)
)

-- Сезоны
Seasons (
  season_id INT PRIMARY KEY,
  name VARCHAR(20) NOT NULL,
  description TEXT
)

-- Материалы
Materials (
  material_id INT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  description TEXT,
  care_instructions TEXT
)

-- События/поводы
Occasions (
  occasion_id INT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  formality_level INT CHECK (formality_level BETWEEN 1 AND 5)
)

-- Предметы одежды (основная таблица)
ClothingItems (
  item_id INT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  purchase_date DATE,
  price DECIMAL(10, 2),
  image_url VARCHAR(500),
  is_favorite BOOLEAN DEFAULT FALSE,
  last_worn DATE,
  wear_count INT DEFAULT 0,
  condition ENUM('отличное', 'хорошее', 'удовлетворительное', 'плохое') DEFAULT 'хорошее',
  storage_location VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  -- Внешние ключи
  user_id INT NOT NULL,
  category_id INT NOT NULL,
  color_id INT,
  size_id INT,
  brand_id INT,
  
  FOREIGN KEY (user_id) REFERENCES Users(user_id),
  FOREIGN KEY (category_id) REFERENCES Categories(category_id),
  FOREIGN KEY (color_id) REFERENCES Colors(color_id),
  FOREIGN KEY (size_id) REFERENCES Sizes(size_id),
  FOREIGN KEY (brand_id) REFERENCES Brands(brand_id)
)

-- Связи многие-ко-многим
ItemSeasons (
  item_id INT,
  season_id INT,
  PRIMARY KEY (item_id, season_id),
  FOREIGN KEY (item_id) REFERENCES ClothingItems(item_id),
  FOREIGN KEY (season_id) REFERENCES Seasons(season_id)
)

ItemMaterials (
  item_id INT,
  material_id INT,
  percentage INT CHECK (percentage BETWEEN 1 AND 100),
  PRIMARY KEY (item_id, material_id),
  FOREIGN KEY (item_id) REFERENCES ClothingItems(item_id),
  FOREIGN KEY (material_id) REFERENCES Materials(material_id)
)

ItemOccasions (
  item_id INT,
  occasion_id INT,
  PRIMARY KEY (item_id, occasion_id),
  FOREIGN KEY (item_id) REFERENCES ClothingItems(item_id),
  FOREIGN KEY (occasion_id) REFERENCES Occasions(occasion_id)
)

-- Комплекты одежды
Outfits (
  outfit_id INT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  occasion_id INT,
  rating INT CHECK (rating BETWEEN 1 AND 5),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  last_worn DATE,
  weather_conditions TEXT,
  user_id INT NOT NULL,
  
  FOREIGN KEY (user_id) REFERENCES Users(user_id),
  FOREIGN KEY (occasion_id) REFERENCES Occasions(occasion_id)
)

-- Связь комплектов и предметов одежды
OutfitItems (
  outfit_id INT,
  item_id INT,
  PRIMARY KEY (outfit_id, item_id),
  FOREIGN KEY (outfit_id) REFERENCES Outfits(outfit_id),
  FOREIGN KEY (item_id) REFERENCES ClothingItems(item_id)
)
