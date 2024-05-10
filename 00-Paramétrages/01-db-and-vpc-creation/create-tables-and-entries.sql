USE measurements;

-- Table pour les relevés de CO2
CREATE TABLE IF NOT EXISTS co2_measurements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    location VARCHAR(255) NOT NULL,
    date DATE NOT NULL,
    co2_level FLOAT NOT NULL
);

-- Ajout de deux relevés de CO2
INSERT INTO co2_measurements (location, date, co2_level) VALUES 
    ('Centre-ville', '2024-04-01', 450),
    ('Zone industrielle', '2024-04-02', 600);

-- Table pour les relevés de PM2.5
CREATE TABLE IF NOT EXISTS pm25_measurements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    location VARCHAR(255) NOT NULL,
    date DATE NOT NULL,
    pm25_level FLOAT NOT NULL
);

-- Ajout de deux relevés de PM2.5
INSERT INTO pm25_measurements (location, date, pm25_level) VALUES 
    ('Parc urbain', '2024-04-01', 15),
    ('Zone résidentielle', '2024-04-02', 12);

-- Table pour les relevés d'ozone
CREATE TABLE IF NOT EXISTS ozone_measurements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    location VARCHAR(255) NOT NULL,
    date DATE NOT NULL,
    ozone_level FLOAT NOT NULL
);

-- Ajout de deux relevés d'ozone
INSERT INTO ozone_measurements (location, date, ozone_level) VALUES 
    ('Zone industrielle', '2024-04-01', 80),
    ('Centre-ville', '2024-04-02', 70);
