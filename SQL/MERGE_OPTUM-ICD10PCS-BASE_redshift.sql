---MERGE_OPTUM-ICD10PCS-BASE---

declare @file_request_id bigint = :file_request_id;


if (
    select count(*)
    from sys.default_constraints
    where name = 'Reference_Icd_icd_id_DF'
) = 0


alter table Reference.Icd
add constraint Reference_Icd_icd_DF default next value for Reference.IcdSeq for icd_id;


--merge into Reference.Icd m using (

select x0.*
    from (
            select i.icd_id,
                --x.*,
                    x.code,
                    x.status,
                    x.short_description,
                    x.long_description,
                    x.full_description,
                    x.code_effective_date,
                    x.change_effective_date,
                    x.termination_date,
                    --x.release_date,
                    x.file_date,
                    x.validity,
      			
      			--c.file_request_id changefile_request_id,
                c.change_Type,
                CAST(c.original_Start AS  DATE)    original_Start ,
		        CAST( c.version_End AS    DATE)    version_End ,
		        CAST(c.revised_Start AS   DATE)    revised_Start ,
		        CAST(c.date_Terminated AS DATE)    date_Terminated ,
                    c.status_Indicator,
                    c.old_Description,
                    c.new_Description,
                CAST(c.release_Date AS        DATE) as release_Date,
		        CAST(c.code_effective_date AS DATE)    effective_Date,
                row_number() over(
                    partition by '1',
                    x.code,
                    i.icd_Version_Type
                    order by --x.file_request_id desc,
                        i.icd_Active_Flag desc,
                        case
                            when x.validity = 'C' then 1
                            else 2
                        end,
                        x.validity,
                        i.icd_id desc
                ) rn
            from edwraw.Optum_ICD10PCS_Base x
                --left join Reference.ref_Icd i on x.codeType = i.icd_code_type
                left join Reference.ref_Icd i on i.icd_code_type = '1'
                and x.code = i.icd_Code
                and i.icd_Version_Type = '10'
                and i.icd_dxsg = 'SG'

                left join edwraw.Optum_ICD10PCS_Change c on x.code = c.code
                --and x.codeType = c.codeType
                and c.code_type = '1'
                --and x.file_request_id <= c.file_request_id
            where (
                    i.icd_id is null
                    or x.short_Description <> i.Icd_Short_Desc
                    or x.long_Description <> i.Icd_Long_Desc
                    or x.full_Description <> i.Icd_Full_Desc
                )
                and x.code not like '%[_]%'
                --and x.file_request_id = :file_request_id
        ) x0
    where x0.rn = 1

--) u on m.icd_id = u.icd_id


--when matched then

update
set m.icdShortDesc = u.shortDescription,
    m.icdLongDesc = u.longDescription,
    m.icdFullDesc = u.fullDescription,
    m.icdBillableInd = case
        when m.icdBillableInd = 1 then 1
        when u.validity = 'C' then 1
        else 0
    end,
    m.icdStatus = u.status,
    m.icdCodeValidity = u.validity,
    m.icdCodeValidityChangeDate = case
        when m.icdCodeValidityChangeDate is not null then m.icdCodeValidityChangeDate
        when m.icdCodeValidity is null
        and u.validity is not null then sysdatetime()
        when m.icdCodeValidity <> u.validity then sysdatetime()
    end,
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
        icdBillableInd,
        icdStatus,
        icdCodeValidity,
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
case
            when u.validity = 'C' then 1
            else 0
        end,
        u.status,
        u.validity,
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
    ) output deleted.icd_id,
    deleted.icdPreviousicd_id,
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
    @file_request_id into Reference.Icd_History;