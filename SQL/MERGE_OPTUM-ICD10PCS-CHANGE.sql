-------MERGE_OPTUM-ICD10PCS-CHANGE
declare @fileRequestId bigint = :fileRequestId;


if (
    select count(*)
    from sys.default_constraints
    where name = 'Reference_Icd_icdId_DF'
) = 0
alter table Reference.Icd
add constraint Reference_Icd_icd_DF default next value for Reference.IcdSeq for icdId;


merge into Reference.Icd m using (
    select i.icdId,
        x.fileRequestId changeFileRequestId,
        x.code,
        x.codeType,
        x.changeType,
        try_convert(datetime2, x.originalStart, 101) originalStart,
        try_convert(datetime2, x.versionEnd, 101) versionEnd,
        try_convert(datetime2, x.revisedStart, 101) revisedStart,
        try_convert(datetime2, x.dateTerminated, 101) dateTerminated,
        x.statusIndicator,
        x.oldDesc,
        x.newDesc,
        upper(x.newDesc) shortDescription,
        upper(x.newDesc) longDescription,
        x.newDesc fullDescription,
        try_convert(datetime2, x.releaseDate, 101) releaseDate,
        try_convert(datetime2, x.effectiveDate, 101) effectiveDate,
        row_number() over(
            partition by x.codeType,
            x.code,
            i.icdVersionType
            order by x.fileRequestId desc,
                i.icdActiveFlag desc,
                i.icdId desc
        ) rn
    from EdmStage.Optum_ICD10PCSChangeHistory x
        left join Reference.Icd i on x.codeType = i.icdCodeType
        and x.code = i.icdCode
        and i.icdVersionType = '10'
        and i.icdDxSg = 'SG'
    where (
            i.icdId is null
            or x.newDesc <> i.IcdFullDesc
        )
        and x.code not like '%[_]%'
        and x.fileRequestId = @fileRequestId
) u on m.icdId = u.icdId


when matched then
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
    when not matched then
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