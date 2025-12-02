-- НОРМАЛИЗОВАННАЯ СХЕМА ДО 3NF ДЛЯ "КАПСУЛЬНЫЙ ГАРДЕРОБ" (SQLite)

-- Пользователи системы
CREATE TABLE Users (
    user_id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL UNIQUE,
    email TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    created_at TEXT DEFAULT (datetime('now')),
    last_login TEXT,
    avatar_url TEXT,
    preferences TEXT -- JSON с настройками пользователя
);

-- Категории одежды
CREATE TABLE Categories (
    category_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    type TEXT NOT NULL CHECK(type IN ('верх', 'низ', 'обувь', 'аксессуары', 'верхняя одежда')),
    description TEXT,
    icon_name TEXT,
    created_at TEXT DEFAULT (datetime('now'))
);

-- Цветовая палитра
CREATE TABLE Colors (
    color_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    hex_code TEXT CHECK(hex_code GLOB '#[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]'),
    color_family TEXT,
    created_at TEXT DEFAULT (datetime('now'))
);

-- Системы размеров
CREATE TABLE Sizes (
    size_id INTEGER PRIMARY KEY AUTOINCREMENT,
    size_system TEXT NOT NULL CHECK(size_system IN ('RU', 'EU', 'US', 'UK', 'INT')),
    value TEXT NOT NULL,
    body_measurements TEXT,
    category_id INTEGER,
    created_at TEXT DEFAULT (datetime('now')),
    FOREIGN KEY (category_id) REFERENCES Categories(category_id) ON DELETE SET NULL
);

-- Бренды и производители
CREATE TABLE Brands (
    brand_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    country TEXT,
    website TEXT,
    logo_url TEXT,
    created_at TEXT DEFAULT (datetime('now'))
);

-- Сезонность одежды
CREATE TABLE Seasons (
    season_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL CHECK(name IN ('Лето', 'Зима', 'Весна', 'Осень', 'Демисезон', 'Всесезонное')),
    description TEXT,
    icon_name TEXT,
    created_at TEXT DEFAULT (datetime('now'))
);

-- Материалы и ткани
CREATE TABLE Materials (
    material_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT,
    care_instructions TEXT,
    is_natural BOOLEAN DEFAULT FALSE,
    created_at TEXT DEFAULT (datetime('now'))
);

-- Поводы и события
CREATE TABLE Occasions (
    occasion_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    formality_level INTEGER CHECK(formality_level BETWEEN 1 AND 5),
    description TEXT,
    icon_name TEXT,
    created_at TEXT DEFAULT (datetime('now'))
);

-- Основная таблица: предметы одежды
CREATE TABLE ClothingItems (
    item_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT,
    purchase_date TEXT,
    price DECIMAL(10, 2),
    image_url TEXT,
    thumbnail_url TEXT,
    is_favorite BOOLEAN DEFAULT FALSE,
    last_worn TEXT,
    wear_count INTEGER DEFAULT 0,
    condition TEXT CHECK(condition IN ('отличное', 'хорошее', 'удовлетворительное', 'плохое', 'на выброс')) DEFAULT 'хорошее',
    storage_location TEXT,
    notes TEXT,
    created_at TEXT DEFAULT (datetime('now')),
    updated_at TEXT DEFAULT (datetime('now')),
    
    -- Внешние ключи
    user_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    color_id INTEGER,
    size_id INTEGER,
    brand_id INTEGER,
    
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id) ON DELETE RESTRICT,
    FOREIGN KEY (color_id) REFERENCES Colors(color_id) ON DELETE SET NULL,
    FOREIGN KEY (size_id) REFERENCES Sizes(size_id) ON DELETE SET NULL,
    FOREIGN KEY (brand_id) REFERENCES Brands(brand_id) ON DELETE SET NULL
);

-- Связь: предметы и сезоны (многие-ко-многим)
CREATE TABLE ItemSeasons (
    item_id INTEGER,
    season_id INTEGER,
    priority INTEGER DEFAULT 1, -- 1=основной, 2=второстепенный
    created_at TEXT DEFAULT (datetime('now')),
    PRIMARY KEY (item_id, season_id),
    FOREIGN KEY (item_id) REFERENCES ClothingItems(item_id) ON DELETE CASCADE,
    FOREIGN KEY (season_id) REFERENCES Seasons(season_id) ON DELETE CASCADE
);

-- Связь: предметы и материалы (многие-ко-многим с процентным соотношением)
CREATE TABLE ItemMaterials (
    item_id INTEGER,
    material_id INTEGER,
    percentage INTEGER CHECK(percentage BETWEEN 1 AND 100),
    created_at TEXT DEFAULT (datetime('now')),
    PRIMARY KEY (item_id, material_id),
    FOREIGN KEY (item_id) REFERENCES ClothingItems(item_id) ON DELETE CASCADE,
    FOREIGN KEY (material_id) REFERENCES Materials(material_id) ON DELETE CASCADE
);

-- Связь: предметы и поводы (многие-ко-многим)
CREATE TABLE ItemOccasions (
    item_id INTEGER,
    occasion_id INTEGER,
    suitability_level INTEGER CHECK(suitability_level BETWEEN 1 AND 5) DEFAULT 3,
    created_at TEXT DEFAULT (datetime('now')),
    PRIMARY KEY (item_id, occasion_id),
    FOREIGN KEY (item_id) REFERENCES ClothingItems(item_id) ON DELETE CASCADE,
    FOREIGN KEY (occasion_id) REFERENCES Occasions(occasion_id) ON DELETE CASCADE
);

-- Комплекты одежды (луки)
CREATE TABLE Outfits (
    outfit_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT,
    occasion_id INTEGER,
    rating INTEGER CHECK(rating BETWEEN 1 AND 5),
    weather_conditions TEXT,
    is_public BOOLEAN DEFAULT FALSE,
    created_at TEXT DEFAULT (datetime('now')),
    last_worn TEXT,
    wear_count INTEGER DEFAULT 0,
    user_id INTEGER NOT NULL,
    
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (occasion_id) REFERENCES Occasions(occasion_id) ON DELETE SET NULL
);

-- Связь: комплекты и предметы (многие-ко-многим)
CREATE TABLE OutfitItems (
    outfit_id INTEGER,
    item_id INTEGER,
    item_order INTEGER DEFAULT 0,
    created_at TEXT DEFAULT (datetime('now')),
    PRIMARY KEY (outfit_id, item_id),
    FOREIGN KEY (outfit_id) REFERENCES Outfits(outfit_id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES ClothingItems(item_id) ON DELETE CASCADE
);

-- История носки (аудит использования)
CREATE TABLE WearHistory (
    wear_id INTEGER PRIMARY KEY AUTOINCREMENT,
    item_id INTEGER,
    outfit_id INTEGER,
    wear_date TEXT NOT NULL,
    occasion_id INTEGER,
    weather TEXT,
    notes TEXT,
    rating INTEGER CHECK(rating BETWEEN 1 AND 5),
    created_at TEXT DEFAULT (datetime('now')),
    
    FOREIGN KEY (item_id) REFERENCES ClothingItems(item_id) ON DELETE CASCADE,
    FOREIGN KEY (outfit_id) REFERENCES Outfits(outfit_id) ON DELETE SET NULL,
    FOREIGN KEY (occasion_id) REFERENCES Occasions(occasion_id) ON DELETE SET NULL
);

-- =============================================
-- ИНДЕКСЫ ДЛЯ ОПТИМИЗАЦИИ ПРОИЗВОДИТЕЛЬНОСТИ
-- =============================================

-- Индексы для ClothingItems (самая часто используемая таблица)
CREATE INDEX idx_clothing_user_id ON ClothingItems(user_id);
CREATE INDEX idx_clothing_category_id ON ClothingItems(category_id);
CREATE INDEX idx_clothing_color_id ON ClothingItems(color_id);
CREATE INDEX idx_clothing_brand_id ON ClothingItems(brand_id);
CREATE INDEX idx_clothing_condition ON ClothingItems(condition);
CREATE INDEX idx_clothing_last_worn ON ClothingItems(last_worn);
CREATE INDEX idx_clothing_is_favorite ON ClothingItems(is_favorite);
CREATE INDEX idx_clothing_created_at ON ClothingItems(created_at);

-- Индексы для пользователей
CREATE INDEX idx_users_email ON Users(email);
CREATE INDEX idx_users_created_at ON Users(created_at);

-- Индексы для категорий
CREATE INDEX idx_categories_type ON Categories(type);

-- Индексы для размеров
CREATE INDEX idx_sizes_system_value ON Sizes(size_system, value);

-- Индексы для промежуточных таблиц
CREATE INDEX idx_item_seasons_item_id ON ItemSeasons(item_id);
CREATE INDEX idx_item_seasons_season_id ON ItemSeasons(season_id);
CREATE INDEX idx_item_materials_item_id ON ItemMaterials(item_id);
CREATE INDEX idx_item_occasions_item_id ON ItemOccasions(item_id);

-- Индексы для комплектов
CREATE INDEX idx_outfits_user_id ON Outfits(user_id);
CREATE INDEX idx_outfits_occasion_id ON Outfits(occasion_id);
CREATE INDEX idx_outfits_rating ON Outfits(rating);
CREATE INDEX idx_outfits_last_worn ON Outfits(last_worn);

-- Индексы для истории носки
CREATE INDEX idx_wear_history_item_id ON WearHistory(item_id);
CREATE INDEX idx_wear_history_wear_date ON WearHistory(wear_date);
CREATE INDEX idx_wear_history_occasion_id ON WearHistory(occasion_id);

-- =============================================
-- ТРИГГЕРЫ ДЛЯ АВТОМАТИЧЕСКИХ ОБНОВЛЕНИЙ
-- =============================================

-- Триггер для автоматического обновления updated_at в ClothingItems
CREATE TRIGGER update_clothingitems_timestamp 
AFTER UPDATE ON ClothingItems 
BEGIN
    UPDATE ClothingItems SET updated_at = datetime('now') 
    WHERE item_id = NEW.item_id;
END;

-- Триггер для обновления wear_count и last_worn при добавлении в WearHistory
CREATE TRIGGER update_item_wear_stats 
AFTER INSERT ON WearHistory 
BEGIN
    UPDATE ClothingItems 
    SET wear_count = wear_count + 1,
        last_worn = NEW.wear_date
    WHERE item_id = NEW.item_id;
    
    -- Обновляем статистику комплекта, если он указан
    UPDATE Outfits 
    SET wear_count = wear_count + 1,
        last_worn = NEW.wear_date
    WHERE outfit_id = NEW.outfit_id;
END;
