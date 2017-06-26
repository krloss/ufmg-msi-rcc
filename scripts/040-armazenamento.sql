CREATE DATABASE ufmg_msi_rcc;
-- USE ufmg_msi_rcc;

CREATE TABLE locais (
	id BIGINT PRIMARY KEY, -- geonameId
	nome VARCHAR(250) NOT NULL,
	lat DECIMAL(19,16) NOT NULL,
	lng DECIMAL(19,16) NOT NULL
);
-- coordenadas GEOMETRY NOT NULL
CREATE OR REPLACE VIEW view_locais AS
SELECT id, (GeomFromText(CONCAT('POINT(',lat,' ',lng,')'))) AS coordenadas FROM locais;

CREATE TABLE usuarios (
	id BIGINT NOT NULL, -- siteUserId
	site CHAR(2) NOT NULL, -- site(GitHub,StackOverflow)
	versao SMALLINT UNSIGNED NOT NULL, -- itensRepetidos
	local VARCHAR(250) NOT NULL,
	algoritmo CHAR(2) NOT NULL,
	local_id BIGINT NULL,
	CONSTRAINT pk_usuarios PRIMARY KEY(id,site,versao),
	CONSTRAINT fk_usuarios_locais FOREIGN KEY (local_id) REFERENCES locais(id)
);

CREATE OR REPLACE VIEW view_usuarios AS
SELECT local_id, COUNT(id) AS quantidade FROM usuarios GROUP BY local_id;

SHOW VARIABLES LIKE 'max_allowed_packet';
