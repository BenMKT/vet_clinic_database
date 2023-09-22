/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals;
SELECT * FROM animals WHERE name LIKE '%mon';
SELECT * FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT * FROM animals WHERE neutered = true AND escape_attempts < 3
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = true;
SELECT * FROM animals WHERE name NOT IN ('Gabumon');
SELECT * FROM animals WHERE  weight_kg BETWEEN 10.4 and 17.3;

ALTER TABLE animals ADD species VARCHAR(200); 
BEGIN TRANSACTION;
SELECT * FROM animals;
UPDATE animals SET species='unspecified';
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;
BEGIN TRANSACTION;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
SELECT * FROM animals;
COMMIT;
BEGIN TRANSACTION;
SELECT * FROM animals;
DELETE FROM animals;
SELECT * FROM animals;
ROLLBACK;
BEGIN TRANSACTION;
SELECT * FROM animals;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT DELDOB;
UPDATE animals SET weight_kg = weight_kg * -1;
SELECT * FROM animals;
ROLLBACK TO DELDOB;
SELECT * FROM animals;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
SELECT * FROM animals;
COMMIT;
SELECT COUNT(*) AS total_animals FROM animals;
SELECT COUNT(*) AS never_escaped_animals FROM animals WHERE escape_attempts = 0;
SELECT AVG(weight_kg) AS average_weight_kg FROM animals;
SELECT neutered, MAX(escape_attempts) FROM animals GROUP BY neutered;
SELECT MIN(weight_kg) AS min_weight_kg, MAX(weight_kg) AS max_weight_kg FROM animals;
SELECT AVG(escape_attempts) AS average_escape_attempts FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31';
BEGIN TRANSACTION;
UPDATE animals SET weight_kg = 20.4 WHERE name = 'Boarmon';
SELECT * FROM animals;
COMMIT;

ALTER TABLE animals DROP COLUMN species;
ALTER TABLE animals ADD COLUMN species_id INT;
ALTER TABLE animals ADD COLUMN owner_id INT;
ALTER TABLE animals ADD CONSTRAINT fk_species FOREIGN KEY (species_id) REFERENCES species(id);
ALTER TABLE animals ADD CONSTRAINT fk_owner FOREIGN KEY (owner_id) REFERENCES owners(id);
\d animals;
SELECT * FROM owners;
SELECT* FROM species;
UPDATE animals SET species_id = CASE WHEN name LIKE '%mon' THEN 2 ELSE 1 END;
SELECT * FROM animals;
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
SELECT animals.name FROM animals JOIN owners ON animals.owner_id = owners.id WHERE owners.full_name = 'Melody Pond';
SELECT animals.name FROM animals JOIN species ON animals.species_id = species.id WHERE species.id = 1;
SELECT owners.full_name, animals.name FROM owners LEFT JOIN animals ON owners.id = animals.owner_id;
SELECT animals.name
  FROM animals
  JOIN species ON animals.species_id = species.id
  JOIN owners ON animals.owner_id = owners.id
  WHERE species.name = 'digimon' AND owners.full_name = 'Jennifer Orwell';
SELECT animals.name FROM animals
  JOIN owners ON animals.owner_id = owners.id
  WHERE owners.full_name = 'Dean Winchester' AND animals.escape_attempts = 0;
SELECT species.name, COUNT(animals.id) AS animal_count FROM species
  LEFT JOIN animals ON species.id = animals.species_id
  GROUP BY species.name;
SELECT o.full_name AS owner, COUNT(a.id) AS animals
  FROM owners o
  JOIN animals a ON o.id = a.owner_id
  GROUP BY o.full_name
  ORDER BY animals DESC
  LIMIT 1;
