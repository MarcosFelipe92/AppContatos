const createTable = '''
  CREATE TABLE contacts(
  id INTEGER PRIMARY KEY,
  name VARCHAR(200) not null UNIQUE,
  email VARCHAR(200) not null,
  phone VARCHAR(20) not null
  );
''';

const insertContacts = '''
  INSERT INTO contacts (name, email, phone) VALUES
  ('Marcos', 'marcos@gmail.com', '62993456171'),
  ('Maria', 'maria@gmail.com', '62983413171'),
  ('Felipe', 'felipe@gmail.com', '11995452171'),
  ('Luana', 'luana@gmail.com', '11999546586'),
  ('Melissa', 'melissa@gmail.com', '11999546586'),
  ('Thiago', 'thiago@gmail.com', '11999546586'),
  ('Lucas', 'lucas@gmail.com', '11999546586'),
  ('Pedro', 'pedro@gmail.com', '11999546586'),
  ('Arthur', 'arthur@gmail.com', '11999546586'),
  ('Gabriel', 'gabriel@gmail.com', '11999546586'),
  ('Witalo', 'witalo@gmail.com', '11999546586');
''';
