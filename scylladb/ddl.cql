CREATE KEYSPACE IF NOT EXISTS test_kv
  WITH REPLICATION = {
    'class': 'SimpleStrategy',
    'replication_factor': 1
};

CREATE TABLE IF NOT EXISTS test_kv.kv (
  id bigint,
  time bigint,
  datum1 float,
  datum2 float,
  PRIMARY KEY(id)
);