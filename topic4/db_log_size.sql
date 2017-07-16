-- db_log_size.sql
-- �ꎞ�\�̍쐬
DECLARE @dm_db_log_space_usage table(
  database_name nvarchar(128)
  , total_size_kb bigint
  , used_size_kb bigint
  , free_size_kb bigint
  , used_in_percent real
);
-- sp_MSforeachdb���g�p���e�f�[�^�x�[�X�ɑ΂��ăN�G�������s���A���ʂ��ꎞ�\�Ɋi�[
INSERT INTO 
  @dm_db_log_space_usage
EXEC sp_MSforeachdb 'USE ?; 
-- �X�i�b�v�V���b�g�f�[�^�x�[�X�͏��O
IF (SELECT count(*) FROM sys.master_files WHERE database_id = DB_ID() AND type = 1) > 0
BEGIN
  SELECT
    DB_NAME(database_id)
    , total_log_size_in_bytes/1024 AS total_size_kb
    , used_log_space_in_bytes/1024 AS used_size_kb
    , (total_log_size_in_bytes - used_log_space_in_bytes)/1024 AS free_size_kb
    , FORMAT(used_log_space_in_percent, ''0.00'') AS used_in_percent
  FROM
    sys.dm_db_log_space_usage
  ORDER BY
    database_id 
END
'
-- �ꎞ�\�̌��ʂ��W�v���ĕԋp
SELECT * FROM @dm_db_log_space_usage