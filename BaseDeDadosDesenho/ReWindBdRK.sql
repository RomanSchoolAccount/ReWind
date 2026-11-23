-- =====================================================
-- REWIND - BASE DE DADOS
-- MySQL 8.0+
-- Estrutura consolidada em rewindbd
-- =====================================================

CREATE DATABASE IF NOT EXISTS `rewindbd`
    DEFAULT CHARACTER SET utf8mb4
    COLLATE utf8mb4_0900_ai_ci;

USE `rewindbd`;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- =====================================================
-- 1. UTILIZADOR
-- =====================================================

CREATE TABLE IF NOT EXISTS `utilizador` (
    `idUtilizador` INT NOT NULL AUTO_INCREMENT,
    `Nome` VARCHAR(100) NOT NULL,
    `Email` VARCHAR(255) NOT NULL,
    `PalavraPasse` VARCHAR(255) NOT NULL,
    `Foto_Perfil` VARCHAR(255) DEFAULT 'default_user.png',
    `Data_Criacao` DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`idUtilizador`),
    UNIQUE KEY `uq_utilizador_email` (`Email`)
) ENGINE=InnoDB;

-- =====================================================
-- 2. ROLE
-- =====================================================

CREATE TABLE IF NOT EXISTS `role` (
    `idRole` INT NOT NULL AUTO_INCREMENT,
    `NomeRole` VARCHAR(50) NOT NULL,
    PRIMARY KEY (`idRole`),
    UNIQUE KEY `uq_role_nome` (`NomeRole`)
) ENGINE=InnoDB;

-- =====================================================
-- 3. UTILIZADOR_ROLE
-- =====================================================

CREATE TABLE IF NOT EXISTS `utilizador_role` (
    `Utilizador_idUtilizador` INT NOT NULL,
    `Role_idRole` INT NOT NULL,
    PRIMARY KEY (`Utilizador_idUtilizador`, `Role_idRole`),
    KEY `idx_utilizador_role_role` (`Role_idRole`),
    CONSTRAINT `fk_utilizador_role_utilizador`
        FOREIGN KEY (`Utilizador_idUtilizador`)
        REFERENCES `utilizador` (`idUtilizador`)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `fk_utilizador_role_role`
        FOREIGN KEY (`Role_idRole`)
        REFERENCES `role` (`idRole`)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =====================================================
-- 4. ARTISTA
-- =====================================================

CREATE TABLE IF NOT EXISTS `artista` (
    `idArtista` INT NOT NULL AUTO_INCREMENT,
    `Nome` VARCHAR(100) NOT NULL,
    `Foto_Artista` VARCHAR(255) DEFAULT 'default_artist.png',
    PRIMARY KEY (`idArtista`)
) ENGINE=InnoDB;

-- =====================================================
-- 5. ALBUM
-- =====================================================

CREATE TABLE IF NOT EXISTS `album` (
    `idAlbum` INT NOT NULL AUTO_INCREMENT,
    `Titulo` VARCHAR(150) NOT NULL,
    `Utilizador_idUtilizador` INT NOT NULL,
    `Capa_Album` VARCHAR(255) DEFAULT 'default_album.png',
    `Data_Lancamento` DATE DEFAULT NULL,
    PRIMARY KEY (`idAlbum`),
    KEY `idx_album_utilizador` (`Utilizador_idUtilizador`),
    CONSTRAINT `fk_album_utilizador`
        FOREIGN KEY (`Utilizador_idUtilizador`)
        REFERENCES `utilizador` (`idUtilizador`)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =====================================================
-- 6. MUSICA
-- =====================================================

CREATE TABLE IF NOT EXISTS `musica` (
    `idMusica` INT NOT NULL AUTO_INCREMENT,
    `Titulo` VARCHAR(150) NOT NULL,
    `Ficheiro_Audio` VARCHAR(500) NOT NULL,
    `Duracao` TIME NOT NULL,
    `Estado` ENUM('Pendente', 'Ativo', 'Rejeitado') NOT NULL DEFAULT 'Pendente',
    `Album_idAlbum` INT NOT NULL,
    PRIMARY KEY (`idMusica`),
    KEY `idx_musica_album` (`Album_idAlbum`),
    CONSTRAINT `fk_musica_album`
        FOREIGN KEY (`Album_idAlbum`)
        REFERENCES `album` (`idAlbum`)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =====================================================
-- 7. MUSICA_ARTISTA
-- =====================================================

CREATE TABLE IF NOT EXISTS `musica_artista` (
    `idMusica_Artista` INT NOT NULL AUTO_INCREMENT,
    `Musica_idMusica` INT NOT NULL,
    `Artista_idArtista` INT NOT NULL,
    `Tipo_Participacao` VARCHAR(30) NOT NULL DEFAULT 'Main',
    PRIMARY KEY (`idMusica_Artista`),
    UNIQUE KEY `uq_musica_artista` (`Musica_idMusica`, `Artista_idArtista`),
    KEY `idx_musica_artista_artista` (`Artista_idArtista`),
    CONSTRAINT `fk_musica_artista_musica`
        FOREIGN KEY (`Musica_idMusica`)
        REFERENCES `musica` (`idMusica`)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `fk_musica_artista_artista`
        FOREIGN KEY (`Artista_idArtista`)
        REFERENCES `artista` (`idArtista`)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =====================================================
-- 8. GENERO
-- =====================================================

CREATE TABLE IF NOT EXISTS `genero` (
    `idGenero` INT NOT NULL AUTO_INCREMENT,
    `Nome` VARCHAR(50) NOT NULL,
    PRIMARY KEY (`idGenero`),
    UNIQUE KEY `uq_genero_nome` (`Nome`)
) ENGINE=InnoDB;

-- =====================================================
-- 9. MUSICA_GENERO
-- =====================================================

CREATE TABLE IF NOT EXISTS `musica_genero` (
    `Musica_idMusica` INT NOT NULL,
    `Genero_idGenero` INT NOT NULL,
    PRIMARY KEY (`Musica_idMusica`, `Genero_idGenero`),
    KEY `idx_musica_genero_genero` (`Genero_idGenero`),
    CONSTRAINT `fk_musica_genero_musica`
        FOREIGN KEY (`Musica_idMusica`)
        REFERENCES `musica` (`idMusica`)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `fk_musica_genero_genero`
        FOREIGN KEY (`Genero_idGenero`)
        REFERENCES `genero` (`idGenero`)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =====================================================
-- 10. PLAYLIST
-- =====================================================

CREATE TABLE IF NOT EXISTS `playlist` (
    `idPlaylist` INT NOT NULL AUTO_INCREMENT,
    `Nome` VARCHAR(100) NOT NULL,
    `E_Publica` BOOLEAN NOT NULL DEFAULT FALSE,
    `Capa_Playlist` VARCHAR(255) DEFAULT 'default_playlist.png',
    `Data_Criacao` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `Utilizador_idUtilizador` INT NOT NULL,
    PRIMARY KEY (`idPlaylist`),
    KEY `idx_playlist_utilizador` (`Utilizador_idUtilizador`),
    CONSTRAINT `fk_playlist_utilizador`
        FOREIGN KEY (`Utilizador_idUtilizador`)
        REFERENCES `utilizador` (`idUtilizador`)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =====================================================
-- 11. PLAYLIST_MUSICA
-- =====================================================

CREATE TABLE IF NOT EXISTS `playlist_musica` (
    `idPlaylist_Musica` INT NOT NULL AUTO_INCREMENT,
    `Playlist_idPlaylist` INT NOT NULL,
    `Musica_idMusica` INT NOT NULL,
    `Data_Adicao` DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`idPlaylist_Musica`),
    UNIQUE KEY `uq_playlist_musica` (`Playlist_idPlaylist`, `Musica_idMusica`),
    KEY `idx_playlist_musica_musica` (`Musica_idMusica`),
    CONSTRAINT `fk_playlist_musica_playlist`
        FOREIGN KEY (`Playlist_idPlaylist`)
        REFERENCES `playlist` (`idPlaylist`)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `fk_playlist_musica_musica`
        FOREIGN KEY (`Musica_idMusica`)
        REFERENCES `musica` (`idMusica`)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =====================================================
-- 12. FAVORITOS
-- =====================================================

CREATE TABLE IF NOT EXISTS `favoritos` (
    `Utilizador_idUtilizador` INT NOT NULL,
    `Musica_idMusica` INT NOT NULL,
    `Data_Favoritado` DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`Utilizador_idUtilizador`, `Musica_idMusica`),
    KEY `idx_favoritos_musica` (`Musica_idMusica`),
    CONSTRAINT `fk_favoritos_utilizador`
        FOREIGN KEY (`Utilizador_idUtilizador`)
        REFERENCES `utilizador` (`idUtilizador`)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `fk_favoritos_musica`
        FOREIGN KEY (`Musica_idMusica`)
        REFERENCES `musica` (`idMusica`)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =====================================================
-- 13. HISTORICO_REPRODUCAO
-- =====================================================

CREATE TABLE IF NOT EXISTS `historico_reproducao` (
    `idHistorico_Reproducao` INT NOT NULL AUTO_INCREMENT,
    `Data_Hora_Reproducao` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `Utilizador_idUtilizador` INT NOT NULL,
    `Musica_idMusica` INT NOT NULL,
    PRIMARY KEY (`idHistorico_Reproducao`),
    KEY `idx_historico_utilizador` (`Utilizador_idUtilizador`),
    KEY `idx_historico_musica` (`Musica_idMusica`),
    CONSTRAINT `fk_historico_utilizador`
        FOREIGN KEY (`Utilizador_idUtilizador`)
        REFERENCES `utilizador` (`idUtilizador`)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `fk_historico_musica`
        FOREIGN KEY (`Musica_idMusica`)
        REFERENCES `musica` (`idMusica`)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =====================================================
-- 14. QUEUE
-- Uma fila por utilizador
-- =====================================================

CREATE TABLE IF NOT EXISTS `queue` (
    `idQueue` INT NOT NULL AUTO_INCREMENT,
    `Utilizador_idUtilizador` INT NOT NULL,
    `Data_Criacao` DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`idQueue`),
    UNIQUE KEY `uq_queue_utilizador` (`Utilizador_idUtilizador`),
    CONSTRAINT `fk_queue_utilizador`
        FOREIGN KEY (`Utilizador_idUtilizador`)
        REFERENCES `utilizador` (`idUtilizador`)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =====================================================
-- 15. MUSICAS_QUEUE
-- Músicas e respetiva ordem dentro de cada fila
-- =====================================================

CREATE TABLE IF NOT EXISTS `musicas_queue` (
    `idMusica_Queue` INT NOT NULL AUTO_INCREMENT,
    `Queue_idQueue` INT NOT NULL,
    `Musica_idMusica` INT NOT NULL,
    `Ordem` INT NOT NULL,
    `Data_Adicao` DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`idMusica_Queue`),
    UNIQUE KEY `uq_musicas_queue_ordem` (`Queue_idQueue`, `Ordem`),
    KEY `idx_musicas_queue_musica` (`Musica_idMusica`),
    CONSTRAINT `fk_musicas_queue_queue`
        FOREIGN KEY (`Queue_idQueue`)
        REFERENCES `queue` (`idQueue`)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `fk_musicas_queue_musica`
        FOREIGN KEY (`Musica_idMusica`)
        REFERENCES `musica` (`idMusica`)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =====================================================
-- 16. TOPMUSICASMAISOUDAS
-- =====================================================

CREATE TABLE IF NOT EXISTS `topmusicasmaisouvidas` (
    `idTopMusicasMaisOuvidas` INT NOT NULL AUTO_INCREMENT,
    `Periodo` VARCHAR(20) NOT NULL,
    `Data_Atualizacao` DATETIME DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`idTopMusicasMaisOuvidas`)
) ENGINE=InnoDB;

-- =====================================================
-- 17. MUSICASTOP
-- =====================================================

CREATE TABLE IF NOT EXISTS `musicastop` (
    `Musica_idMusica` INT NOT NULL,
    `TopMusicasMaisOuvidas_idTopMusicasMaisOuvidas` INT NOT NULL,
    `Posicao` INT NOT NULL,
    PRIMARY KEY (`Musica_idMusica`, `TopMusicasMaisOuvidas_idTopMusicasMaisOuvidas`),
    UNIQUE KEY `uq_musicastop_posicao`
        (`TopMusicasMaisOuvidas_idTopMusicasMaisOuvidas`, `Posicao`),
    KEY `idx_musicastop_top` (`TopMusicasMaisOuvidas_idTopMusicasMaisOuvidas`),
    CONSTRAINT `fk_musicastop_musica`
        FOREIGN KEY (`Musica_idMusica`)
        REFERENCES `musica` (`idMusica`)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `fk_musicastop_top`
        FOREIGN KEY (`TopMusicasMaisOuvidas_idTopMusicasMaisOuvidas`)
        REFERENCES `topmusicasmaisouvidas` (`idTopMusicasMaisOuvidas`)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =====================================================
-- 18. MUSICA_LETRA_SINCRONIZADA
-- =====================================================

CREATE TABLE IF NOT EXISTS `musica_letra_sincronizada` (
    `idMusica_Letra_Sincronizada` INT NOT NULL AUTO_INCREMENT,
    `Musica_idMusica` INT NOT NULL,
    `Tempo_Segundos` INT NOT NULL,
    `Texto_Linha` TEXT NOT NULL,
    PRIMARY KEY (`idMusica_Letra_Sincronizada`),
    KEY `idx_letra_musica_tempo` (`Musica_idMusica`, `Tempo_Segundos`),
    CONSTRAINT `fk_letra_musica`
        FOREIGN KEY (`Musica_idMusica`)
        REFERENCES `musica` (`idMusica`)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =====================================================
-- 19. SEGUIDOR_ARTISTA
-- =====================================================

CREATE TABLE IF NOT EXISTS `seguidor_artista` (
    `idSeguidor_Artista` INT NOT NULL AUTO_INCREMENT,
    `Utilizador_idUtilizador` INT NOT NULL,
    `Artista_idArtista` INT NOT NULL,
    `Data_Seguido` DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`idSeguidor_Artista`),
    UNIQUE KEY `uq_seguidor_artista` (`Utilizador_idUtilizador`, `Artista_idArtista`),
    KEY `idx_seguidor_artista_artista` (`Artista_idArtista`),
    CONSTRAINT `fk_seguidor_artista_utilizador`
        FOREIGN KEY (`Utilizador_idUtilizador`)
        REFERENCES `utilizador` (`idUtilizador`)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `fk_seguidor_artista_artista`
        FOREIGN KEY (`Artista_idArtista`)
        REFERENCES `artista` (`idArtista`)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =====================================================
-- 20. SEGUIDOR_UTILIZADOR
-- =====================================================

CREATE TABLE IF NOT EXISTS `seguidor_utilizador` (
    `idSeguidor` INT NOT NULL,
    `idSeguido` INT NOT NULL,
    `Data_Seguido` DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`idSeguidor`, `idSeguido`),
    KEY `idx_seguidor_utilizador_seguido` (`idSeguido`),
    CONSTRAINT `fk_seguidor_utilizador_seguidor`
        FOREIGN KEY (`idSeguidor`)
        REFERENCES `utilizador` (`idUtilizador`)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `fk_seguidor_utilizador_seguido`
        FOREIGN KEY (`idSeguido`)
        REFERENCES `utilizador` (`idUtilizador`)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `chk_utilizador_nao_segue_a_si` CHECK (`idSeguidor` <> `idSeguido`)
) ENGINE=InnoDB;

