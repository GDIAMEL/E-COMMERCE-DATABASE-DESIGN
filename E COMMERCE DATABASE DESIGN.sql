-- Create database
CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;

-- Brand table
CREATE TABLE brand (
    brand_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    logo_url VARCHAR(255),
    website VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Product Category table
CREATE TABLE product_category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    parent_category_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_category_id) REFERENCES product_category(category_id) ON DELETE SET NULL
);

-- Product table
CREATE TABLE product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    brand_id INT,
    category_id INT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    base_price DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (brand_id) REFERENCES brand(brand_id) ON DELETE SET NULL,
    FOREIGN KEY (category_id) REFERENCES product_category(category_id) ON DELETE SET NULL
);

-- Product Image table
CREATE TABLE product_image (
    image_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    image_url VARCHAR(255) NOT NULL,
    is_primary BOOLEAN DEFAULT FALSE,
    display_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(product_id) ON DELETE CASCADE
);

-- Size Category table
CREATE TABLE size_category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Size Option table
CREATE TABLE size_option (
    size_id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    abbreviation VARCHAR(10),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES size_category(category_id) ON DELETE CASCADE
);

-- Color table
CREATE TABLE color (
    color_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    hex_code VARCHAR(7),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Product Item table (actual purchasable items)
CREATE TABLE product_item (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    SKU VARCHAR(50) UNIQUE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(product_id) ON DELETE CASCADE
);

-- Product Variation table (links products with their variations)
CREATE TABLE product_variation (
    variation_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    color_id INT,
    size_id INT,
    item_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(product_id) ON DELETE CASCADE,
    FOREIGN KEY (color_id) REFERENCES color(color_id) ON DELETE SET NULL,
    FOREIGN KEY (size_id) REFERENCES size_option(size_id) ON DELETE SET NULL,
    FOREIGN KEY (item_id) REFERENCES product_item(item_id) ON DELETE CASCADE
);

-- Attribute Category table
CREATE TABLE attribute_category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Attribute Type table
CREATE TABLE attribute_type (
    type_id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    data_type ENUM('text', 'number', 'boolean', 'date') DEFAULT 'text',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES attribute_category(category_id) ON DELETE CASCADE
);

-- Product Attribute table
CREATE TABLE product_attribute (
    attribute_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    attribute_category_id INT NOT NULL,
    attribute_value TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(product_id) ON DELETE CASCADE,
    FOREIGN KEY (attribute_category_id) REFERENCES attribute_category(category_id) ON DELETE CASCADE
);

-- Insert sample data for testing

-- Insert brands
INSERT INTO brand (name, description, website) VALUES
('Nike', 'Global sports apparel and footwear company', 'https://www.nike.com'),
('Apple', 'Consumer electronics and software manufacturer', 'https://www.apple.com'),
('H&M', 'Fashion retailer offering clothing for men, women, and children', 'https://www.hm.com');

-- Insert product categories
INSERT INTO product_category (name, description) VALUES
('Clothing', 'Clothing items including shirts, pants, dresses');
INSERT INTO product_category (name, description, parent_category_id) VALUES
('T-shirts', 'Short-sleeved casual shirts', 1),
('Jeans', 'Denim pants', 1),
('Electronics', 'Electronic devices and accessories', NULL),
('Smartphones', 'Mobile phones with advanced features', 4);

-- Insert products
INSERT INTO product (brand_id, category_id, name, description, base_price) VALUES
(1, 2, 'Nike Dri-FIT T-Shirt', 'Moisture-wicking fabric keeps you dry and comfortable', 29.99),
(2, 5, 'iPhone 14', 'Apple smartphone with advanced features', 799.99),
(3, 3, 'H&M Slim Fit Jeans', 'Comfortable everyday jeans with modern fit', 49.99);

-- Insert colors
INSERT INTO color (name, hex_code) VALUES
('Black', '#000000'),
('White', '#FFFFFF'),
('Red', '#FF0000'),
('Blue', '#0000FF');

-- Insert size categories
INSERT INTO size_category (name, description) VALUES
('Clothing Sizes', 'Standard clothing sizes'),
('Shoe Sizes', 'US standard shoe sizes');

-- Insert size options
INSERT INTO size_option (category_id, name, abbreviation) VALUES
(1, 'Small', 'S'),
(1, 'Medium', 'M'),
(1, 'Large', 'L'),
(1, 'Extra Large', 'XL'),
(2, 'Size 8', '8'),
(2, 'Size 9', '9'),
(2, 'Size 10', '10');

-- Insert product items (specific variations that can be purchased)
INSERT INTO product_item (product_id, price, stock_quantity, SKU) VALUES
(1, 29.99, 100, 'NIKE-TS-BLK-M'),
(1, 29.99, 75, 'NIKE-TS-WHT-M'),
(2, 799.99, 50, 'APPL-IP14-BLK-128'),
(3, 49.99, 200, 'HM-JN-BLU-32');

-- Insert product variations
INSERT INTO product_variation (product_id, color_id, size_id, item_id) VALUES
(1, 1, 2, 1),  -- Black, Medium Nike T-shirt
(1, 2, 2, 2),  -- White, Medium Nike T-shirt
(2, 1, NULL, 3), -- Black iPhone (no size)
(3, 4, 2, 4);  -- Blue, Medium H&M Jeans

-- Insert attribute categories
INSERT INTO attribute_category (name, description) VALUES
('Physical', 'Physical attributes like weight, dimensions'),
('Technical', 'Technical specifications'),
('Material', 'Material composition information');

-- Insert attribute types
INSERT INTO attribute_type (category_id, name, data_type) VALUES
(1, 'Weight', 'number'),
(1, 'Dimensions', 'text'),
(2, 'Storage', 'text'),
(2, 'Battery Life', 'text'),
(3, 'Fabric Composition', 'text');

-- Insert product attributes
INSERT INTO product_attribute (product_id, attribute_category_id, attribute_value) VALUES
(1, 3, '100% Polyester'),
(2, 1, '172g'),
(2, 2, '128GB'),
(3, 3, '98% Cotton, 2% Elastane');