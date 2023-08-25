---MERGE_OPTUM-HCPCS-BASE---

declare @fileRequestId bigint = :fileRequestId;
declare @hcpcsLevel varchar(1) = '2';
declare @hcpcsLevelType varchar(10) = 'HCPCS';

-- find codes in the file
-- already in the table  drop table if exists #hcpcs ;

select h.hcpcsId,
    o.fileRequestId,
    o.code,
    o.shortDescription,
    o.longDescription,
    o.fullDescription --,o.nonFacilityTotalRVU
    --,o.facilityTotalRVU
,
    case
        when upper(o.fullDescription) like '%UNSPECIFIED%' then 1
        when upper(o.fullDescription) like '%UNCLASSIFIED%' then 1
        when upper(o.fullDescription) like '%UNLISTED %' then 1
        when upper(o.fullDescription) like '%NOT OTHERWISE SPECIFIED%' then 1
        when upper(o.fullDescription) like '%NOT OTHERWISE CLASSIFIED%' then 1
        when upper(o.fullDescription) like '%NOT ELSEWHERE SPECIFIED%' then 1
        else 0
    end nocFlag,
    case
        when h.hcpcsEffectiveDate is not null then h.hcpcsEffectiveDate
        when h.hcpcsId is null
        and isnull(o.status, '~') <> 'D' then case
            when patindex(
                '%[0-9][0-9][0-9][0-9][_][0-9][0-9]%',
                fr.originalFileName
            ) > 0 then dateadd(
                day,
                0,
                replace(
                    substring(
                        fr.originalFileName,
                        patindex(
                            '%[0-9][0-9][0-9][0-9][_][0-9][0-9]%',
                            fr.originalFileName
                        ),
                        7
                    ),
                    '_',
                    '-'
                ) + '-01'
            )
            when patindex('%[0-9][0-9][0-9][0-9]%', fr.originalFileName) > 0 then dateadd(
                day,
                0,
                replace(
                    substring(
                        fr.originalFileName,
                        patindex('%[0-9][0-9][0-9][0-9]%', fr.originalFileName),
                        4
                    ),
                    '_',
                    '-'
                ) + '-01-01'
            )
        end
    end effectiveDate,
    case
        when o.status = 'D' then case
            when patindex(
                '%[0-9][0-9][0-9][0-9][_][0-9][0-9]%',
                fr.originalFileName
            ) > 0 then dateadd(
                day,
                -1,
                replace(
                    substring(
                        fr.originalFileName,
                        patindex(
                            '%[0-9][0-9][0-9][0-9][_][0-9][0-9]%',
                            fr.originalFileName
                        ),
                        7
                    ),
                    '_',
                    '-'
                ) + '-01'
            )
            when patindex('%[0-9][0-9][0-9][0-9]%', fr.originalFileName) > 0 then dateadd(
                day,
                -1,
                replace(
                    substring(
                        fr.originalFileName,
                        patindex('%[0-9][0-9][0-9][0-9]%', fr.originalFileName),
                        4
                    ),
                    '_',
                    '-'
                ) + '-01-01'
            )
        end
    end terminationDate,
    h.hcpcsNocFlag,
    h.hcpcsEffectiveDate,
    h.hcpcsTerminationDate,
    case
        when h.hcpcsId is null
        or o.shortDescription <> h.hcpcsShortDesc
        or o.longDescription <> h.hcpcsLongDesc
        or o.fullDescription <> h.hcpcsFullDesc
        or (
            o.status = 'D'
            and h.hcpcsTerminationDate is null
        ) --or isnull(o.facilityTotalRVU, -1) <> isnull(h.hcpcsTotalFacilityPractiveExpenseRvu, -1)
        --or isnull(o.nonFacilityTotalRVU, -1) <> isnull(h.hcpcsTotalNonFacilityPracticeExpenseRvu, -1) then 1
        else 0
    end hasDiff into #hcpcs
    ------------------------     from EdmStage.Optum_HCPCSBase o          ------------------------
    join EdmLib.FileRequest fr on o.fileRequestId = fr.fileRequestId
    left join Reference.Hcpcs h on o.code = h.hcpcsCode
    and hcpcsLevel = @hcpcsLevel
    and hcpcsActiveFlag = 1 -- decide which codes have an update  drop table if exists #hcpcs_diff ;
select * into #hcpcs_diff
from #hcpcs
where hasDiff = 1
    or nocFlag <> hcpcsNocFlag
    or isnull(terminationDate, '9999-12-31') <> isnull(hcpcsTerminationDate, '9999-12-31');
--select *
--from #hcpcs_diff ;
-- truncate table Reference.HcpcsHistory ;
-- create a historical copy of
-- each hcpcs before it changes
insert into Reference.HcpcsHistory
select h.*,
    sysdatetime() historyDateTime,
    @fileRequestId triggeringFileRequestId
from #hcpcs_diff d
    join Reference.Hcpcs h on d.hcpcsId = h.hcpcsId;
declare @maxHcpcsId bigint;
select @maxHcpcsId = max(hcpcsId)
from Reference.Hcpcs;
declare @currentHcpcsId bigint;
select @currentHcpcsId = convert(bigint, current_value)
from sys.sequences
where object_id = object_id('Reference.HcpcsSeq');
if @maxHcpcsId > @currentHcpcsId begin print 'Re-sequencing ...'
declare @reSequenceDDL varchar(500) = 'alter sequence Reference.HcpcsSeq restart with ' + convert(varchar(10), @maxHcpcsId + 1);
exec sp_sqlexec @reSequenceDDL;
end;
--select @maxHcpcsId
merge into Reference.Hcpcs m using #hcpcs_diff u
on m.hcpcsId = u.hcpcsId
when matched then
update
set m.hcpcsShortDesc = u.shortDescription,
    m.hcpcsLongDesc = u.longDescription,
    m.hcpcsFullDesc = u.fullDescription --,m.hcpcsTotalNonFacilityPracticeExpenseRvu = u.nonFacilityTotalRVU                   
    --,m.hcpcsTotalFacilityPractiveExpenseRvu = u.facilityTotalRVU                   
,
    m.hcpcsNocFlag = u.nocFlag,
    m.hcpcsEffectiveDate = u.effectiveDate,
    m.hcpcsTerminationDate = u.terminationDate,
    m.hcpcsUpdateDate = sysdatetime()
    when not matched then
insert (
        hcpcsCode,
        hcpcsLevel,
        hcpcsShortDesc,
        hcpcsLongDesc,
        hcpcsFullDesc,
        hcpcsEffectiveDate,
        hcpcsTerminationDate --,hcpcsTotalNonFacilityPracticeExpenseRvu
        --,hcpcsTotalFacilityPractiveExpenseRvu
,
        hcpcsNocFlag,
        hcpcsLevelType,
        hcpcsActiveFlag,
        hcpcsCreateDate
    )
values (
        u.code,
        @hcpcsLevel,
        u.shortDescription,
        u.longDescription,
        u.fullDescription,
        u.effectiveDate,
        u.terminationDate --,u.nonFacilityTotalRVU
        --,u.facilityTotalRVU
,
        u.nocFlag,
        @hcpcsLevelType,
        1,
        sysdatetime()
    );

-- maintain codes that are configured for manual override

merge into Reference.Hcpcs m using (
    select *
    from Reference.HcpcsOverride
    where hcpcsLevel = @hcpcsLevel
        and hcpcsActiveFlag = 1
) u on m.hcpcsId = u.hcpcsId
and m.hcpcsCode = u.hcpcsCode
and m.hcpcsLevel = u.hcpcsLevel
when matched then
update
set m.hcpcsCategoryId = u.hcpcsCategoryId,
    m.hcpcsShortDesc = u.hcpcsShortDesc,
    m.hcpcsLongDesc = u.hcpcsLongDesc,
    m.hcpcsFullDesc = u.hcpcsFullDesc,
    m.hcpcsEffectiveDate = u.hcpcsEffectiveDate,
    m.hcpcsTerminationDate = u.hcpcsTerminationDate,
    m.hcpcsTotalNonFacilityPracticeExpenseRvu = u.hcpcsTotalNonFacilityPracticeExpenseRvu,
    m.hcpcsTotalFacilityPractiveExpenseRvu = u.hcpcsTotalFacilityPractiveExpenseRvu,
    m.hcpcsReuseDate = u.hcpcsReuseDate,
    m.hcpcsPreviousId = u.hcpcsPreviousId,
    m.hcpcsStatus = u.hcpcsStatus,
    m.hcpcsActiveFlag = u.hcpcsActiveFlag,
    m.hcpcsCreateDate = u.hcpcsCreateDate,
    m.hcpcsUpdateDate = u.hcpcsUpdateDate,
    m.hcpcsNocInd = u.hcpcsNocInd,
    m.hcpcsNocFlag = u.hcpcsNocFlag,
    m.hcpcsLevelType = u.hcpcsLevelType;