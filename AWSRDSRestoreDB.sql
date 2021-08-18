DECLARE @DBName AS VARCHAR(100)='exampledb'
DECLARE @DBFile AS VARCHAR(100)='examplefile.bak'
DECLARE @DBBucket AS VARCHAR(100)='example-bucket'
exec msdb.dbo.rds_restore_database
@restore_db_name='@DBName',
@s3_arn_to_restore_from='arn:aws-us-gov:s3:::@DBBucket/@DBFile';
