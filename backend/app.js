const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const multer = require('multer');
const { createClient } = require('@supabase/supabase-js');

const app = express();
const upload = multer({ storage: multer.memoryStorage() });

app.use(cors());
app.use(express.json());

const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',        
  password: 'a@12@master@#lolpro1',
  database: 'rewindbd' 
});

const supabase = createClient('https://crquiefsxacingrlvoao.supabase.co', 'sb_publishable_88lA8L6s-lP5_swNh40jCg_6n0vr53q');

db.connect((err) => {
  if (err) {
    console.error('Erro ao ligar ao MySQL:', err);
    return;
  }
  console.log('Ligado à base de dados MySQL!');
});

//Partes de utilizador

app.get('/', (req, res) => {
  res.send('API Rewind a funcionar!');
});

app.get('/utilizador', (req, res) => {
  db.query('SELECT * FROM utilizador', (err, results) => {
    if (err) return res.status(500).json({ erro: err.message });
    res.json(results);
  });
});

/* Conecção de utilizador e role utilizador_role :PPPPP */

app.get('/utilizador_role', (req, res) => {
  db.query('SELECT * FROM utilizador_role', (err, results) => {
    if (err) return res.status(500).json({ erro: err.message });
    res.json(results);
  });
});

app.get('/role', (req, res) => {
  db.query('SELECT * FROM role', (err, results) => {
    if (err) return res.status(500).json({ erro: err.message });
    res.json(results);
  });
});

app.get('/album', (req, res) => {
  db.query('SELECT * FROM album', (err, results) => {
    if (err) return res.status(500).json({ erro: err.message });
    res.json(results);
  });
});

app.get('/favoritos', (req, res) => {
  db.query('SELECT * FROM favoritos', (err, results) => {
    if (err) return res.status(500).json({ erro: err.message });
    res.json(results);
  });
});

app.get('/historico_reproducao', (req, res) => {
  db.query('SELECT * FROM historico_reproducao', (err, results) => {
    if (err) return res.status(500).json({ erro: err.message });
    res.json(results);
  });
});

app.get('/queue', (req, res) => {
  db.query('SELECT * FROM queue', (err, results) => {
    if (err) return res.status(500).json({ erro: err.message });
    res.json(results);
  });
});

//Parte de artista e seguir 

app.get('/artista', (req, res) => {
  db.query('SELECT * FROM artista', (err, results) => {
    if (err) return res.status(500).json({ erro: err.message });
    res.json(results);
  });
});



//musicas

app.get('/musica', async (req, res) => {
  const { data, error } = await supabase
    .from('musica')
    .select('*')
    .order('created_at', { ascending: false });

  if (error) return res.status(500).json({ erro: error.message });
  res.json(data);
});

app.post('/musica', upload.single('ficheiro'), async (req, res) => {
  try {
    const { titulo, duracao } = req.body;
    const ficheiro = req.file;

    if (!ficheiro) {
      return res.status(400).json({ erro: 'Nenhum ficheiro de áudio enviado.' });
    }

    const nomeFicheiro = `${Date.now()}_${ficheiro.originalname}`;

    const { error: uploadError } = await supabase.storage
      .from('musicas')
      .upload(nomeFicheiro, ficheiro.buffer, {
        contentType: ficheiro.mimetype,
      });

    if (uploadError) throw uploadError;

    const { data: publicUrlData } = supabase.storage
      .from('musicas')
      .getPublicUrl(nomeFicheiro);

    const { data, error: dbError } = await supabase
      .from('musica')
      .insert([
        {
          titulo: titulo,
          Ficheiro_Audio: publicUrlData.publicUrl,
          duracao: duracao || null,
        },
      ])
      .select();

    if (dbError) throw dbError;

    res.status(201).json(data);
  } catch (err) {
    res.status(500).json({ erro: err.message });
  }
});

app.get('/genero', (req, res) => {
  db.query('SELECT * FROM genero', (err, results) => {
    if (err) return res.status(500).json({ erro: err.message });
    res.json(results);
  });
});

app.get('/musicastop', (req, res) => {
  db.query('SELECT * FROM musicastop', (err, results) => {
    if (err) return res.status(500).json({ erro: err.message });
    res.json(results);
  });
});

app.get('/topmusicasmaisouvidas', (req, res) => {
  db.query('SELECT * FROM topmusicasmaisouvidas', (err, results) => {
    if (err) return res.status(500).json({ erro: err.message });
    res.json(results);
  });
});

app.get('/playlist', (req, res) => {
  db.query('SELECT * FROM playlist', (err, results) => {
    if (err) return res.status(500).json({ erro: err.message });
    res.json(results);
  });
});

app.post('/playlist', (req, res) => {
 const {nome, utilizador_id } = req.body;

 const sql = 'INSERT INTO playlist (nome, utilizador_id) VALUES (?,?)';
 db.query(sql, [nome, utilizador_id], (err, result) => {
  if(err) return res.status(500).json({ erro: err.message});
  res.status(201).json({id: result_insertId, nome, utilizador_id});
 });
});


// Conecção de musica com todos as outras tabelas profissionais tuff tuff tuff

app.get('/musica_artista', (req, res) => {
  db.query('SELECT * FROM musica_artista', (err, results) => {
    if (err) return res.status(500).json({ erro: err.message });
    res.json(results);
  });
});

app.get('/musica_genero', (req, res) => {
  db.query('SELECT * FROM musica_genero', (err, results) => {
    if (err) return res.status(500).json({ erro: err.message });
    res.json(results);
  });
});

app.get('/musica_letra_sincronizada', (req, res) => {
  db.query('SELECT * FROM musica_letra_sincronizada', (err, results) => {
    if (err) return res.status(500).json({ erro: err.message });
    res.json(results);
  });
});

app.get('/musicas_queue', (req, res) => {
  db.query('SELECT * FROM musicas_queue', (err, results) => {
    if (err) return res.status(500).json({ erro: err.message });
    res.json(results);
  });
});

app.get('/playlist_musica', (req, res) => {
  db.query('SELECT * FROM playlist_musica', (err, results) => {
    if (err) return res.status(500).json({ erro: err.message });
    res.json(results);
  });
});

/* Conecção Seguidor  */

app.get('/seguidor_artista', (req, res) => {
  db.query('SELECT * FROM seguidor_artista', (err, results) => {
    if (err) return res.status(500).json({ erro: err.message });
    res.json(results);
  });
});

app.put('/seguidor_artista', (req, res) => {
  const { Utilizador_idUtilizador, Artista_idArtista , Data_Seguido} = req.body;

  const sql='INSERT INTO seguidor_artista (idSeguidor_Artista,Utilizador_idUtilizador,Artista_idArtista,Data_Seguido) VALUES (?,?,?)';

  const data = Data_Seguido || new Date();

    db.query(sql, [Utilizador_idUtilizador, Artista_idArtista, data], (err, result) => {
    if (err) return res.status(500).json({ erro: err.message });
    
    res.status(201).json({idSeguidor_Artista: result.insertId,Utilizador_idUtilizador,Artista_idArtista,Data_Seguido: data});
  });
});

app.delete('/seguidor_artista/:utilizadorId/:artistaId', (req, res) => {
  const { utilizadorId, artistaId } = req.params;

  const sql = 'DELETE FROM seguidor_artista WHERE Utilizador_idUtilizador = ? AND Artista_idArtista = ?';

  db.query(sql, [utilizadorId, artistaId], (err, result) => {
    if (err) return res.status(500).json({ erro: err.message });

    if (result.affectedRows === 0) {
      return res.status(404).json({ mensagem: 'Registo não encontrado.' });
    }
  });
});



app.get('/seguidor_utilizador', (req, res) => {
  db.query('SELECT * FROM seguidor_utilizador', (err, results) => {
    if (err) return res.status(500).json({ erro: err.message });
    res.json(results);
  });
});

app.post('/seguidor_utilizador', (req, res) =>{
  const { idSeguidor , idSeguido , Data_Seguido } = req.body;

  const sql = 'INSERT INTO seguidor_utilizador (idSeguidor, idSeguido, Data_Seguido) VALUES(?,?,?)';

  const BananaData = Data_Seguido || new Date();

  db.query(sql [idSeguidor, idSeguido, BananaData], (err, result) =>{
    if (err) return res.status(500).json({ erro: err.message });

    res.status(201).json({id: result.insertId, idSeguidor, idSeguido, Data_Seguido: data});
  });
});

app.delete('/seguidor_utilizador/:utilizadorId/:artistaId', (req, res) => {
  const { idSeguidor, idSeguido, Data_Seguido } = req.params;

  const sql = 'DELETE FROM seguidor_utilizador WHERE idSeguidor = ? AND idSeguido = ?';

  db.query(sql, [idSeguido, idSeguidor], (err,result) =>{
        if (err) return res.status(500).json({ erro: err.message });

    if (result.affectedRows === 0) {
      return res.status(404).json({ mensagem: 'Sem Seguidores.' });
  }});
});


app.listen(4545, '0.0.0.0', () => {
  console.log('API a correr na porta 4545');
});
