-- table_data_size.sql
USE DB001
-- �ꎞ�\�̍쐬
DECLARE @temp table(
  name NVARCHAR(128)
  , rows bigint
  , reserved nvarchar(80)
  , data nvarchar(80)
  , index_size nvarchar(80)
  , unused nvarchar(80)
);
-- �e�[�u�����Ƃ�sp_spaceused�����s�����ʂ��ꎞ�\�ɓo�^
INSERT INTO
  @temp
EXEC sp_MSforeachtable N'exec sp_spaceused ''?''';
-- ���ʂ��o��
SELECT * FROM @temp