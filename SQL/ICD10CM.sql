
 ---	CALL reference.sp_icd10cm();
 
CREATE OR REPLACE PROCEDURE reference.sp_icd10cm()
AS $$
DECLARE 	
		vIcd_Id        BIGINT = 10000000;

BEGIN

DROP TABLE 
	IF EXISTS #Icd10cm_temp0;




-- select

SELECT 
		stg.*,
		
		ROW_NUMBER() over(
			PARTITION BY
			  --code_Type,
			  code,
			  icd_Version_Type
		  ORDER BY
			  file_Request_Id DESC,
			  icd_Active_Flag DESC,
			  CASE
				  WHEN validity = 'C'
				  THEN 1
				  ELSE 2
			  END,
			  validity,
			  previous_icd_id DESC) rn,		
		MD5(
			NVL(short_Description, '') ||
			NVL(long_Description, '') ||
			NVL(full_Description, '') ||
			NVL(icd_Billable_Ind, 0)||
			NVL(STATUS,'')||
			NVL(validity,'')||
			NVL(effectiveDate,'9999-12-31')
			) row_guid
		--INTO #Icd10cm_temp0
FROM (SELECT
			
			x.code, 
			x.status, 
			x.short_description, 
			x.long_description, 
			x.full_description, 
			----x.code_effective_date, 
			x.change_effective_date, 
			x.termination_date, 
			x.release_date, 
			x.file_date, 
			x.validity,			
			CASE 
				WHEN x.validity = 'C'
					THEN 1
				ELSE 0
				END icd_Billable_Ind,		
			1 code_Type,
			
			i.icd_Id as previous_icd_id,
			i.icd_Version_Type,	
			i.icd_Active_Flag,			
			c.change_Type                  AS changeType ,
			CAST(c.original_Start AS  DATE)    originalStart ,
			CAST( c.version_End AS    DATE)    versionEnd ,
			CAST(c.revised_Start AS   DATE)    revisedStart ,
			CAST(c.date_Terminated AS DATE)    dateTerminated ,
			c.status_Indicator ,
			c.old_description            AS oldDesc ,
			c.new_description            AS newDesc ,
			CAST(c.release_Date AS        DATE)    releaseDate ,
			CAST(c.code_effective_date AS DATE)    effectiveDate ,
			
			CAST(REPLACE(REPLACE(REPLACE(x.file_load_dt, '-', ''), ' ', ''), ':', '') AS BIGINT) AS File_Request_Id
	FROM   edwraw.Optum_ICD10CM_Base x
	LEFT JOIN   Reference.ref_Icd i
	ON
		--x.codeType = i.icd_Code_Type
		x.code = i.icd_Code
	AND i.icd_Version_Type = '10'
	AND i.icd_DxSg = 'DX'
	LEFT JOIN edwraw.Optum_ICD10CM_Change c
	ON
		x.code = c.code
		--AND x.codeType = c.codeType
		--AND x.fileRequestId <= c.fileRequestId
		--AND dw_effective_end_date = CAST('9999-12-31' AS DATETIME) ---??
	WHERE
		(
			i.icd_Id IS NULL
		OR  x.short_Description <> i.Icd_Short_Desc
		OR  x.long_Description <> i.Icd_Long_Desc
		OR  x.full_Description <> i.Icd_Full_Desc)
	AND x.code NOT LIKE '%[_]%'
		--and x.fileRequestId = file_Request_Id
	--AND dw_effective_end_date = CAST('9999-12-31' AS DATETIME) --??
	) stg;








-- update



UPDATE  reference.ref_icd tgt
	SET dw_effective_end_date 	= GETDATE()
FROM #Icd10cm_temp0 src
WHERE tgt.Icd_Id = src.previous_icd_id
AND dw_effective_end_date = CAST('9999-12-31' AS DATETIME)
AND tgt.row_guid <> src.row_guid;


WITH max_icd_id
AS (
	SELECT 	
			NVL(MAX(icd_id), 0) as Icd_Id	 
	FROM  Reference.ref_Icd
	)
SELECT 
        CASE 
                WHEN Icd_Id < 1000000 then 1000000
                ELSE  Icd_Id
                END
        INTO vIcd_Id		
FROM max_icd_id;


-- insert

INSERT INTO reference.ref_icd (
	icd_id,
	icd_Code,
	icd_Code_Std,
	icd_Version_Type,
	icd_Code_Type,
	icd_DxSg,
	icd_Short_Desc,
	icd_Long_Desc,
	icd_Full_Desc,
	icd_Billable_Ind,
	icd_Status,
	icd_Code_Validity,
	icd_Effective_Date,
	icd_Active_Flag,
	icd_Create_Date,
	icd_Noc_Flag,
	
	dw_effective_start_date,
	dw_effective_end_date,
	file_request_id,
	row_guid
	)
SELECT 
	COALESCE(previous_icd_id, vIcd_Id + ROW_NUMBER() OVER (ORDER BY 1)) AS Icd_Id,
	code,
	replace(code, '.', ''),
	'10',
	code_Type,
	'DX',
	short_Description,
	long_Description,
	full_Description,
	icd_Billable_Ind,
	STATUS,
	validity,
	CAST(effectiveDate AS DATE) code_effective_Date,
	1 AS Active_Flag,
	GETDATE() Create_Date,
	CASE 
		WHEN upper(full_Description) LIKE '%NOT OTHERWISE SPECIFIED%'
			THEN 1
		WHEN upper(full_Description) LIKE '%NOT OTHERWISE CLASSIFIED%'
			THEN 1
		WHEN upper(full_Description) LIKE '%NOT ELSEWHERE CLASSIFIED%'
			THEN 1
		WHEN upper(full_Description) LIKE '%NOT ELSEWHERE SPECIFIED%'
			THEN 1     
		WHEN upper(full_Description) LIKE '%UNSPECIFIED%'
			THEN 1     
		WHEN upper(full_Description) LIKE '%^UNLISTED%'
			THEN 1
		ELSE 0
		END Noc_Flag,
		
	GETDATE() AS dw_effective_start_date,
	'9999-12-31' AS dw_effective_end_date,
	file_request_id,
	row_guid
FROM #Icd10cm_temp0
WHERE row_guid NOT IN (
						SELECT 
								row_guid
						FROM reference.ref_icd
						WHERE dw_effective_end_date = CAST('9999-12-31' AS DATETIME)
						);

END;
    $$ language plpgsql;
