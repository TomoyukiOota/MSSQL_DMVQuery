USE tempdb

-- ���Ɉꎞ�\���쐬�ς݂ł���΍폜
IF OBJECT_ID('tempdb..#dm_db_log_space_usage', 'U') IS NOT NULL
BEGIN
  DROP TABLE #dm_db_log_space_usage
END

-- �ꎞ�\�̍쐬
SELECT
  *
INTO #dm_db_log_space_usage 
FROM (
  SELECT
    *
  FROM
    sys.dm_db_log_space_usage
  WHERE 1 <> 1
) AS src

-- sp_MSforeachdb���g�p���e�f�[�^�x�[�X�ɑ΂��ăN�G�������s���A���ʂ��ꎞ�\�Ɋi�[
INSERT INTO 
  #dm_db_log_space_usage
EXEC sp_MSforeachdb 'USE ?; 
IF (SELECT count(*) FROM sys.master_files WHERE database_id = DB_ID() AND type = 1) > 0
BEGIN
  SELECT
    *
  FROM
    sys.dm_db_log_space_usage
END
'

-- �ꎞ�\�̌��ʂ��W�v���ĕԋp

  SELECT
    db_name(database_id) AS db_name
    , database_id
    , total_log_size_in_bytes/1024 AS total_size_kb
    , used_log_space_in_bytes/1024 AS used_size_kb
    , (total_log_size_in_bytes - used_log_space_in_bytes)/1024 AS free_size_kb
	, FORMAT(used_log_space_in_percent, '0.00') AS used_in_percent
  FROM #dm_db_log_space_usage
