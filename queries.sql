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


SELECT * FROM owners;
SELECT* FROM species;
UPDATE animals SET species_id = CASE WHEN name LIKE '%mon' THEN 2 ELSE 1 END;
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

SELECT * FROM vets;
SELECT * FROM species;
SELECT * FROM specializations;
SELECT * FROM visits;
--last animal seen by William Tatcher
SELECT a.name AS last_animal_seen_by_william_tatcher
FROM animals a
JOIN visits v ON a.id = v.animal_id
WHERE v.vet_id = (SELECT id FROM vets WHERE name = 'William Tatcher')
ORDER BY v.visit_date DESC
LIMIT 1;
--different animals seen by Stephanie Mendez
SELECT COUNT(DISTINCT v.animal_id) AS num_animals_seen_by_stephanie_mendez
FROM visits v
WHERE v.vet_id = (SELECT id FROM vets WHERE name = 'Stephanie Mendez');
--List all vets and their specialties, including vets with no specialties
SELECT v.name, s.name AS specialty
FROM vets v
LEFT JOIN specializations sp ON v.id = sp.vet_id
LEFT JOIN species s ON sp.species_id = s.id;
--List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020
SELECT a.name AS animal_name, v.visit_date
FROM animals a
JOIN visits v ON a.id = v.animal_id
WHERE v.vet_id = (SELECT id FROM vets WHERE name = 'Stephanie Mendez')
AND v.visit_date BETWEEN '2020-04-01' AND '2020-08-30';
--What animal has the most visits to vets
SELECT a.name AS animal_name, COUNT(v.animal_id) AS num_visits
FROM animals a
JOIN visits v ON a.id = v.animal_id
GROUP BY a.name
ORDER BY num_visits DESC
LIMIT 1;
--Who was Maisy Smith's first visit
SELECT a.name AS first_visit_animal, v.visit_date AS first_visit_date
FROM animals a
JOIN visits v ON a.id = v.animal_id
WHERE v.vet_id = (SELECT id FROM vets WHERE name = 'Maisy Smith')
ORDER BY v.visit_date ASC
LIMIT 1;
--Details for most recent visit: animal information, vet information, and date of visit
SELECT a.name AS animal_name, v.name AS vet_name, vi.visit_date
FROM visits vi
JOIN animals a ON vi.animal_id = a.id
JOIN vets v ON vi.vet_id = v.id
ORDER BY vi.visit_date DESC
LIMIT 1;
--How many visits were with a vet that did not specialize in that animal's species
SELECT COUNT(*) AS num_visits_without_specialization
FROM visits v
LEFT JOIN specializations sp ON v.vet_id = sp.vet_id AND v.animal_id = sp.species_id
WHERE sp.vet_id IS NULL;
--What specialty should Maisy Smith consider getting? Look for the species she gets the most
SELECT species.name AS species, COUNT(*) AS visits
FROM visits
JOIN vets ON vets.id = visits.vet_id
JOIN animals ON animals.id = visits.animal_id
JOIN species ON species.id = animals.species_id
WHERE vets.name = 'Maisy Smith'
GROUP BY species.name
ORDER BY COUNT(*) DESC
LIMIT 2;
