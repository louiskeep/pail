-------MERGE_OPTUM-ICD10PCS-CHANGE
declare @fileRequestId bigint = :fileRequestId;


if (
    select count(*)
    from sys.default_constraints
    where name = 'Reference_Icd_icdId_DF'
) = 0


alter table Reference.Icd
add constraint Reference_Icd_icd_DF default next value for Reference.IcdSeq for icdId;


--merge into Reference.Icd m using (
    select i.icd_Id,
        --x.fileRequestId changeFileRequestId,
        x.code,
        --x.codeType,
        x.change_Type,
                CAST(x.original_Start AS  DATE)    original_Start ,
		        CAST(x.version_End AS    DATE)    version_End ,
		        CAST(x.revised_Start AS   DATE)    revised_Start ,
		        CAST(x.date_Terminated AS DATE)    date_Terminated ,
        x.status_Indicator,
        x.old_Description,
        x.new_description,
        upper(x.new_description) short_Description,
        upper(x.new_description) long_Description,
        x.new_description full_Description,
                CAST(x.release_Date AS        DATE) as release_Date,
		        CAST(x.code_effective_date AS DATE)    effective_Date,
        row_number() over(
            partition by --x.codeType,
            x.code,
            i.icd_Version_Type
            order by --x.file_Request_Id desc,
                i.icd_Active_Flag desc,
                i.icd_Id desc
        ) rn
    from edwraw.Optum_ICD10PCS_Change x
        --left join Reference.ref_Icd i on x.codeType = i.icdCodeType
        left join Reference.ref_Icd i on i.icd_Code_Type = '1'
        and x.code = i.icd_Code
        and i.icd_Version_Type = '10'
        and i.icd_DxSg = 'SG'
    where (
            i.icd_Id is null
            or x.new_description <> i.Icd_Full_Desc
        )
        and x.code not like '%[_]%'
        --and x.fileRequestId = @fileRequestId
--) u on m.icdId = u.icdId


--when matched then


update
set m.icdShortDesc = u.shortDescription,
    m.icdLongDesc = u.longDescription,
    m.icdFullDesc = u.fullDescription,
    m.icdReuseDate = case
        when m.icdActiveFlag = 0 then sysdatetime()
    end,
    m.icdActiveFlag = 1,
    m.icdEffectiveDate = case
        when m.icdEffectiveDate is not null then m.icdEffectiveDate
        else u.effectiveDate
    end,
    m.icdUpdateDate = sysdatetime(),
    m.icdNocFlag = case
        when m.icdNocFlag = 1 then 1
        when upper(u.fullDescription) like '%NOT OTHERWISE SPECIFIED%' then 1
        when upper(u.fullDescription) like '%NOT OTHERWISE CLASSIFIED%' then 1
        when upper(u.fullDescription) like '%NOT ELSEWHERE CLASSIFIED%' then 1
        when upper(u.fullDescription) like '%NOT ELSEWHERE SPECIFIED%' then 1
        when upper(u.fullDescription) like '%UNSPECIFIED%' then 1
        when upper(u.fullDescription) like '%^UNLISTED%' then 1
        else 0
    end
    
        
    --when not matched then

insert (
        icdCode,
        icdCodeStd,
        icdVersionType,
        icdCodeType,
        icdDxSg,
        icdShortDesc,
        icdLongDesc,
        icdFullDesc,
        icdEffectiveDate,
        icdActiveFlag,
        icdCreateDate,
        icdNocFlag
    )
values (
        u.code,
        replace(u.code, '.', ''),
        '10',
        u.codeType,
        'SG',
        u.shortDescription,
        u.longDescription,
        u.fullDescription,
        u.effectiveDate,
        1,
        sysdatetime(),
case
            when upper(u.fullDescription) like '%NOT OTHERWISE SPECIFIED%' then 1
            when upper(u.fullDescription) like '%NOT OTHERWISE CLASSIFIED%' then 1
            when upper(u.fullDescription) like '%NOT ELSEWHERE CLASSIFIED%' then 1
            when upper(u.fullDescription) like '%NOT ELSEWHERE SPECIFIED%' then 1
            when upper(u.fullDescription) like '%UNSPECIFIED%' then 1
            when upper(u.fullDescription) like '%^UNLISTED%' then 1
            else 0
        end
    ) output deleted.icdId,
    deleted.icdPreviousIcdId,
    deleted.icdCode,
    deleted.icdCodeStd,
    deleted.icdVersionType,
    deleted.icdCodeType,
    deleted.icdDxSg,
    deleted.icdShortDesc,
    deleted.icdLongDesc,
    deleted.icdFullDesc,
    deleted.icdBillableInd,
    deleted.icdStatus,
    deleted.icdCodeValidity,
    deleted.icdCodeValidityChangeDate,
    deleted.icdOrderNumber,
    deleted.icdReuseDate,
    deleted.icdEffectiveDate,
    deleted.icdDeactivationDate,
    deleted.icdActiveFlag,
    deleted.icdCreateDate,
    deleted.icdUpdateDate,
    deleted.icdNocFlag,
    deleted.icdCategoryId,
    @fileRequestId into Reference.Icd_History;