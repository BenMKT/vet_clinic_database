/* Populate database with sample data. */

INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) 
VALUES 
('Agumon', '2020-02-03', 0, true, 10.23),
('Gabumon', '2018-11-15', 2, true, 08),
('Pikachu', '2021-01-07', 1, false, 15.04),
('Devimon', '2017-05-12', 5, true, 11);

INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) 
VALUES
('Charmander', '2021-11-15', 0, false, -11),
('Plantmon', '2020-02-08', 2, true, -5.7),
('Squirtle', '1993-04-02', 3, false, -12.13),
('Angemon', '2005-06-12', 1, true, -45),
('Boarmon', '2005-06-07', 7, true, 24.4),
('Blossom', '1998-10-13', 3, true, 17),
('Ditto', '2022-05-14', 4, true, 22);

--INSERT DATA INTO owners TABLE
INSERT INTO owners (full_name, age)
VALUES
('Sam Smith', 34),
('Jennifer Orwell', 19),
('Bob', 45),
('Melody Pond', 77),
('Dean Winchester', 14),
('Jodie Whittaker', 38);

--INSERT DATA INTO species TABLE
INSERT INTO species (name)
VALUES
('pokemon'),
('digimon');

UPDATE animals
SET owner_id = (
  SELECT o.id
  FROM owners o
  WHERE o.full_name = CASE
    WHEN animals.name = 'Agumon' THEN 'Sam Smith'
    WHEN animals.name IN ('Gabumon', 'Pikachu') THEN 'Jennifer Orwell'
    WHEN animals.name IN ('Devimon', 'Plantmon') THEN 'Bob'
    WHEN animals.name IN ('Charmander', 'Squirtle', 'Blossom') THEN 'Melody Pond'
    WHEN animals.name IN ('Angemon', 'Boarmon') THEN 'Dean Winchester'
    ELSE NULL
  END
);
SELECT * FROM animals;