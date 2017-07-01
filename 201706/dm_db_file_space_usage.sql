-- ���Ɉꎞ�\���쐬�ς݂ł���΍폜
IF OBJECT_ID('tempdb..#dm_db_file_space_usage', 'U') IS NOT NULL
BEGIN
  DROP TABLE #dm_db_file_space_usage
END

-- �ꎞ�\�̍쐬
SELECT
  *
INTO #dm_db_file_space_usage 
FROM (
SELECT
  m.database_id
  , m.file_id
  , m.type_desc
  , m.name
  , m.physical_name
  , u.total_page_count * 8 AS total_size_kb
  , u.allocated_extent_page_count * 8 AS used_size_kb
  , u.unallocated_extent_page_count * 8 AS free_size_kb
  , FORMAT(CONVERT(decimal, u.allocated_extent_page_count) / u.total_page_count * 100, '0.00') AS used_in_percent
FROM sys.dm_db_file_space_usage u left join sys.master_files m on u.database_id = m.database_id and u.file_id = m.file_id
WHERE 1 <> 1
) AS src

-- sp_MSforeachdb���g�p���e�f�[�^�x�[�X�ɑ΂��ăN�G�������s���A���ʂ��ꎞ�\�Ɋi�[
INSERT INTO 
  #dm_db_file_space_usage
EXEC sp_MSforeachdb 'USE ?;
SELECT
  m.database_id
  , m.file_id
  , m.type_desc
  , m.name
  , m.physical_name
  , u.total_page_count * 8 AS total_size_kb
  , u.allocated_extent_page_count * 8 AS used_size_kb
  , u.unallocated_extent_page_count * 8 AS free_size_kb
  , FORMAT(CONVERT(decimal, u.allocated_extent_page_count) / u.total_page_count * 100, ''0.00'') AS used_in_percent
FROM sys.dm_db_file_space_usage u left join sys.master_files m on u.database_id = m.database_id and u.file_id = m.file_id'

-- �ꎞ�\�̌��ʂ��W�v���ĕԋp
select db_name(database_id) as database_name, * from #dm_db_file_space_usage ORDER BY database_id, file_id
