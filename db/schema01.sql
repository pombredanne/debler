DROP TABLE IF EXISTS package_versions;
DROP TABLE IF EXISTS packages;
DROP TABLE IF EXISTS gems;

CREATE TABLE gems (
  name VARCHAR(60) UNIQUE PRIMARY KEY,
  level INT NOT NULL DEFAULT 1,
  opts JSON NOT NULL DEFAULT '{}',
  native boolean
);

CREATE TABLE packages (
  name VARCHAR(60) REFERENCES gems(name) ON DELETE RESTRICT,
  slot INT[],
  metadata JSON NOT NULL DEFAULT '{}',
  PRIMARY KEY (name, slot)
);

CREATE TABLE package_versions (
  name VARCHAR(60),
  slot INT[],
  version INT[] NOT NULL,
  revision INT NOT NULL,
  state VARCHAR(16) DEFAULT 'scheduled',
  format INT[] NULL,
  scheduled_at timestamptz NOT NULL,
  changelog TEXT,
  distribution VARCHAR(25),
  PRIMARY KEY (name, slot, version, revision),
  FOREIGN KEY (name, slot) REFERENCES packages(name, slot) ON DELETE RESTRICT
);
