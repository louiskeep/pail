"id	clientId	sqlName	sqlText	activeFlag	createDate	sqlType"
"11	38	INSERT_Elig_EligibilityStage	-- use the name and address from the current demographics file"

insert into EdmStage.MD_EligibilityStage
        (stageId
        ,fileRequestId
        ,demo_stageId
        ,demo_recipientOriginalId
        ,demo_recipientCurrentId
        ,demo_recipientSsn
        ,demo_recipientLastName
        ,demo_recipientFirstName
        ,demo_recipientMiddleInitial
        ,demo_recipientSuffix
        ,demo_recipientDob
        ,demo_recipientDod
        ,demo_recipientAddress1
        ,demo_recipientAddress2
        ,demo_recipientCity
        ,demo_recipientState
        ,demo_recipientZipCode
        ,demo_recipientRaceCode
        ,demo_recipientMedicareIdNumber
        ,demo_espdtIndicator
        ,demo_recipientSexCode
        ,demo_identityVerificationIndicator
"		,demo_citizenshipVerificationIndicator"
        ,demo_redetDate
        ,elig_stageId
        ,elig_updateCode
        ,elig_recipientOriginalId
        ,elig_coverageGroup
        ,elig_eligibilityBeginDate
        ,elig_eligibilityEndDate
        ,elig_splitBillAmount
        ,elig_programParticipationIndicator
        ,elig_providerNumber
        ,elig_providerNumber2
        ,elig_coverageType
        ,idlk_stageId
        ,idlk_recipientOriginalId
        ,idlk_recipientCurrentId)
  select row_number() over(partition by 1 order by x1.demo_stageId) stageId
        ,x1.fileRequestId
        ,x1.demo_stageId
        ,x1.demo_recipientOriginalId
        ,x1.demo_recipientCurrentId
        ,x1.demo_recipientSsn
        ,x1.demo_recipientLastName
        ,x1.demo_recipientFirstName
        ,x1.demo_recipientMiddleInitial
        ,x1.demo_recipientSuffix
        ,x1.demo_recipientDob
        ,x1.demo_recipientDod
        ,x1.demo_recipientAddress1
        ,x1.demo_recipientAddress2
        ,x1.demo_recipientCity
        ,x1.demo_recipientState
        ,x1.demo_recipientZipCode
        ,x1.demo_recipientRaceCode
        ,x1.demo_recipientMedicareIdNumber
        ,x1.demo_espdtIndicator
        ,x1.demo_recipientSexCode
        ,x1.demo_identityVerificationIndicator
"		,x1.demo_citizenshipVerificationIndicator"
        ,x1.demo_redetDate
        ,x1.elig_stageId
        ,x1.elig_updateCode
        ,x1.elig_recipientOriginalId
        ,x1.elig_coverageGroup
        ,x1.elig_eligibilityBeginDate
        ,x1.elig_eligibilityEndDate
        ,x1.elig_splitBillAmount
        ,x1.elig_programParticipationIndicator
        ,x1.elig_providerNumber
        ,x1.elig_providerNumber2
        ,x1.elig_coverageType
        ,x1.idlk_stageId
        ,x1.idlk_recipientOriginalId
        ,x1.idlk_recipientCurrentId
    from (select x.fileRequestId
                ,isnull(x.demo_stageId, x.stageId) demo_stageId
                ,x.demo_recipientOriginalId
                ,x.demo_recipientCurrentId
                ,x.demo_recipientSsn
                ,x.demo_recipientLastName
                ,x.demo_recipientFirstName
                ,x.demo_recipientMiddleInitial
                ,x.demo_recipientSuffix
                ,x.demo_recipientDob
                ,x.demo_recipientDod
                ,case when x.demo_stageId is not null then x.demo_recipientAddress1 else ad.addressLine1 end demo_recipientAddress1
                ,case when x.demo_stageId is not null then x.demo_recipientAddress2 else ad.addressLine2 end demo_recipientAddress2
                ,case when x.demo_stageId is not null then x.demo_recipientCity else ad.city end demo_recipientCity
                ,case when x.demo_stageId is not null then x.demo_recipientState else ad.state end demo_recipientState
                ,case when x.demo_stageId is not null then x.demo_recipientZipCode else ad.zip end demo_recipientZipCode
                ,x.demo_recipientRaceCode
                ,x.demo_recipientMedicareIdNumber
                ,x.demo_espdtIndicator
                ,x.demo_recipientSexCode
                ,x.demo_identityVerificationIndicator
"				,x.demo_citizenshipVerificationIndicator"
                ,x.demo_redetDate
                ,x.stageId elig_stageId
                ,x.updateCode elig_updateCode
                ,x.recipientOriginalId elig_recipientOriginalId
                ,x.coverageGroup elig_coverageGroup
                ,x.eligibilityBeginDate elig_eligibilityBeginDate
                ,x.eligibilityEndDate elig_eligibilityEndDate
                ,x.splitBillAmount elig_splitBillAmount
                ,isnull(x.programParticipationIndicator, 'FFS') elig_programParticipationIndicator
                ,x.providerNumber elig_providerNumber
                ,x.providerNumber2 elig_providerNumber2
                ,x.coverageType elig_coverageType
                ,isnull(x.idlk_stageId, x.stageId) idlk_stageId
                ,x.idlk_recipientOriginalId
                ,x.idlk_recipientCurrentId
                ,rank() over(partition by ad.clientId, ad.patientId order by ad.activeFlag desc, case when ad.addressTypeId = 12 then 1 else 2 end, ad.addressTypeId) rnk
            from (select rank() over(partition by e.stageId, e.recipientOriginalId order by pd.patientActiveFlag desc, pd.patientId, convert(date, i.endDateOfId, 101) desc, i.stageId desc, d.stageId desc) rnk
                        ,pd.patientId
"						,d.stageId demo_stageId"
                        ,e.recipientOriginalId demo_recipientOriginalId
                        ,case when i.stageID is not null then i.recipientCurrentId else pd.patientPrimaryNumber end demo_recipientCurrentId
                        ,e.recipientOriginalId idlk_recipientOriginalId
"						,i.stageId idlk_stageId"
                        ,case when i.stageId is not null then i.recipientCurrentId else pd.patientPrimaryNumber end idlk_recipientCurrentId
                        ,case when d.stageId is not null then d.recipientSsn else pd.patientSsn end demo_recipientSsn
                        ,case when d.stageId is not null then d.recipientLastName else pd.patientLastName end demo_recipientLastName
                        ,case when d.stageId is not null then d.recipientFirstName else pd.patientFirstName end demo_recipientFirstName
                        ,case when d.stageId is not null then d.recipientMiddleInitial else left(pd.patientMiddleName, 1) end demo_recipientMiddleInitial
                        ,case when d.stageId is not null then d.recipientSuffix else pd.patientNameSuffix end demo_recipientSuffix
                        ,case when d.stageId is not null then d.recipientDob else replace(convert(varchar(10), pd.PatientBirthDate, 110), '-', '/') end demo_recipientDob
                        ,case when d.stageId is not null then d.recipientDod else replace(convert(varchar(10), pd.patientDeathDate, 110), '-', '/') end demo_recipientDod
                        ,d.recipientAddress1 demo_recipientAddress1
                        ,d.recipientAddress2 demo_recipientAddress2
                        ,d.recipientCity demo_recipientCity
                        ,d.recipientState demo_recipientState
                        ,d.recipientZipCode demo_recipientZipCode
                        ,case when d.stageId is not null then d.recipientRaceCode else m.inValue end demo_recipientRaceCode
                        ,case when d.stageId is not null then d.recipientMedicareIdNumber else pd.patientMedicareNumber end demo_recipientMedicareIdNumber
                        ,case when d.stageId is not null then d.espdtIndicator else case pd.patientEpsdtInd when 1 then 'Y' else 'N' end end demo_espdtIndicator
                        ,case when d.stageId is not null then d.recipientSexCode else pd.patientGenderCode end demo_recipientSexCode
                        ,case when d.stageId is not null then d.identityVerificationIndicator else case when pd.patientIdentityVerificationInd = 1 then 'Y' else 'N' end end demo_identityVerificationIndicator
"						,case when d.stageId is not null then d.citizenshipVerificationIndicator else pd.patientCitenzenshipStatusCode end demo_citizenshipVerificationIndicator"
                        ,case when d.stageId is not null then d.redetDate else replace(convert(varchar(10), pd.patientRederterminationDate, 110), '-', '/') end demo_redetDate
                        ,e.*
                    from EdmStage.MD_Elig e
"					left join EdmStage.MD_IdLk i on e.recipientOriginalId = i.recipientOriginalId"
"					left join EdmStage.MD_Demo d on e.recipientOriginalId = d.recipientOriginalId"
                    left join Patient.PatientDim pd on 'MD' + e.recipientOriginalId = pd.enterprisePatientId
                                                   and pd.clientId = 38
                                                   and pd.patientActiveFlag = 1
                    left join EdmLib.Mapping m on pd.patientRaceCode = m.outValue
                                              and m.name = 'MD_RACE_CODE'
                   where e.fileRequestId = :fileRequestId
"				   ) x"
            join Patient.AddressDim ad on ad.clientId = 38
                                      and x.patientId = ad.patientId
                                      and ad.activeFlag = 1
           where x.rnk = 1) x1
   where x1.rnk = 1
"  option (maxdop 4); 	1	2019-02-11 14:54:39.0166667	mssql"
"12	38	INSERT_Demo_EligibilityStage	insert into EdmStage.MD_EligibilityStage"
        (stageId
        ,fileRequestId
        ,demo_stageId
        ,demo_updateCode
        ,demo_recipientOriginalId
        ,demo_recipientSsn
        ,demo_recipientLastName
        ,demo_recipientFirstName
        ,demo_recipientMiddleInitial
        ,demo_recipientSuffix
        ,demo_recipientPhoneNumber
        ,demo_recipientDob
        ,demo_recipientDod
        ,demo_recipientAddress1
        ,demo_recipientAddress2
        ,demo_recipientCounty
        ,demo_recipientState
        ,demo_recipientZipCode
        ,demo_recipientRaceCode
        ,demo_recipientMedicareIdNumber
        ,demo_espdtIndicator
        ,demo_recipientSexCode
        ,demo_tplIndicator
        ,demo_insuranceCode
        ,demo_dateOfEntry
        ,demo_recipientCurrentId
        ,demo_buyInIndicator
        ,demo_duplicateCardCode
        ,demo_citizenshipVerificationIndicator
        ,demo_identityVerificationIndicator
        ,demo_redetDate
        ,demo_recipientCity
        ,demo_hohName
        ,demo_hohCase)
    select
        row_number() over(partition by 1 order by stageId) stageId
        ,fileRequestId
        ,stageId
        ,updateCode
        ,recipientOriginalId
        ,recipientSsn
        ,recipientLastName
        ,recipientFirstName
        ,recipientMiddleInitial
        ,recipientSuffix
        ,recipientPhoneNumber
        ,recipientDob
        ,recipientDod
        ,recipientAddress1
        ,recipientAddress2
        ,recipientCounty
        ,recipientState
        ,recipientZipCode
        ,recipientRaceCode
        ,recipientMedicareIdNumber
        ,espdtIndicator
        ,recipientSexCode
        ,tplIndicator
        ,insuranceCode
        ,dateOfEntry
        ,recipientCurrentId
        ,buyInIndicator
        ,duplicateCardCode
        ,citizenshipVerificationIndicator
        ,identityVerificationIndicator
        ,redetDate
        ,recipientCity
        ,hohName
        ,hohCase
    from EdmStage.MD_Demo
"    where fileRequestId = :fileRequestId ;	1	2019-02-11 14:55:12.6033333	mssql"
"13	38	INSERT_IdLk_EligibilityStage	-- use the name and address from the current demographics file"
#NAME?
insert into EdmStage.MD_EligibilityStage
        (stageId
        ,fileRequestId
        ,demo_stageId
        ,demo_updateCode
        ,demo_recipientOriginalId
        ,demo_recipientCurrentId
        ,demo_recipientSsn
        ,demo_recipientLastName
        ,demo_recipientFirstName
        ,demo_recipientMiddleInitial
        ,demo_recipientSuffix
        ,demo_recipientDob
        ,demo_recipientDod
"		,demo_recipientAddress1"
"		,demo_recipientAddress2"
"		,demo_recipientCity"
"		,demo_recipientState"
"		,demo_recipientZipCode"
        ,demo_recipientRaceCode
        ,demo_recipientMedicareIdNumber
        ,demo_espdtIndicator
        ,demo_recipientSexCode
        ,demo_identityVerificationIndicator
          ,demo_citizenshipVerificationIndicator
        ,demo_redetDate
        ,idlk_stageId
        ,idlk_updateCode
        ,idlk_recipientOriginalId
        ,idlk_recipientCurrentId
        ,idlk_beginDateOfId
        ,idlk_endDateOfId)
select row_number() over(partition by 1 order by demo_stageId) stageId
      ,fileRequestId
      ,demo_stageId
      ,demo_updateCode
      ,demo_recipientOriginalId
      ,demo_recipientCurrentId
      ,demo_recipientSsn
      ,demo_recipientLastName
      ,demo_recipientFirstName
      ,demo_recipientMiddleInitial
      ,demo_recipientSuffix
      ,demo_recipientDob
      ,demo_recipientDod
      ,demo_recipientAddress1
      ,demo_recipientAddress2
      ,demo_recipientCity
      ,demo_recipientState
      ,demo_recipientZipCode
      ,demo_recipientRaceCode
      ,demo_recipientMedicareIdNumber
      ,demo_espdtIndicator
      ,demo_recipientSexCode
      ,demo_identityVerificationIndicator
"	  ,demo_citizenshipVerificationIndicator"
      ,demo_redetDate
      ,idlk_stageId
      ,idlk_updateCode
      ,idlk_recipientOriginalId
      ,idlk_recipientCurrentId
      ,idlk_beginDateOfId
"      ,idlk_endDateOfId		"
  from (select x.fileRequestId
              ,isnull(x.demo_stageId, x.stageId) demo_stageId
              ,updateCode demo_updateCode
              ,demo_recipientOriginalId
              ,demo_recipientCurrentId
              ,demo_recipientSsn
              ,demo_recipientLastName
              ,demo_recipientFirstName
              ,demo_recipientMiddleInitial
              ,demo_recipientSuffix
              ,demo_recipientDob
              ,demo_recipientDod
              ,case when x.demo_stageId is not null then demo_recipientAddress1 else ad.addressLine1 end demo_recipientAddress1
              ,case when x.demo_stageId is not null then demo_recipientAddress2 else ad.addressLine2 end demo_recipientAddress2
              ,case when x.demo_stageId is not null then demo_recipientCity else ad.city end demo_recipientCity
              ,case when x.demo_stageId is not null then demo_recipientState else ad.state end demo_recipientState
              ,case when x.demo_stageId is not null then demo_recipientZipCode else ad.zip end demo_recipientZipCode
              ,demo_recipientRaceCode
              ,demo_recipientMedicareIdNumber
              ,demo_espdtIndicator
              ,demo_recipientSexCode
              ,demo_identityVerificationIndicator
"			  ,demo_citizenshipVerificationIndicator"
              ,demo_redetDate
              ,x.stageId idlk_stageId
              ,updateCode idlk_updateCode
              ,recipientOriginalId idlk_recipientOriginalId
              ,recipientCurrentId idlk_recipientCurrentId
              ,beginDateOfId idlk_beginDateOfId
              ,endDateOfId idlk_endDateOfId
              ,rank() over(partition by ad.clientId, ad.patientId order by ad.activeFlag desc, case when ad.addressTypeId = 12 then 1 else 2 end, ad.addressTypeId) rnk
          from (select rank() over(partition by i.stageId, i.recipientOriginalId order by pd.patientActiveFlag desc, pd.patientId) rnk
                      ,pd.patientId
"					  ,d.stageId demo_stageId"
                      ,i.recipientOriginalId demo_recipientOriginalId
                      ,i.recipientCurrentId demo_recipientCurrentId
                      ,case when d.stageId is not null then d.recipientSsn else pd.patientSsn end demo_recipientSsn
                      ,case when d.stageId is not null then d.recipientLastName else pd.patientLastName end demo_recipientLastName
                      ,case when d.stageId is not null then d.recipientFirstName else pd.patientFirstName end demo_recipientFirstName
                      ,case when d.stageId is not null then d.recipientMiddleInitial else left(pd.patientMiddleName, 1) end demo_recipientMiddleInitial
                      ,case when d.stageId is not null then d.recipientSuffix else pd.patientNameSuffix end demo_recipientSuffix
                      ,case when d.stageId is not null then d.recipientDob else replace(convert(varchar(10), pd.PatientBirthDate, 110), '-', '/') end demo_recipientDob
                      ,case when d.stageId is not null then d.recipientDod else replace(convert(varchar(10), pd.patientDeathDate, 110), '-', '/') end demo_recipientDod
                      ,d.recipientAddress1 demo_recipientAddress1
                      ,d.recipientAddress2 demo_recipientAddress2
                      ,d.recipientCity demo_recipientCity
                      ,d.recipientState demo_recipientState
                      ,d.recipientZipCode demo_recipientZipCode
                      ,m.inValue demo_recipientRaceCode
                      ,case when d.stageId is not null then d.recipientMedicareIdNumber else pd.patientMedicareNumber end demo_recipientMedicareIdNumber
                      ,case when d.stageId is not null then d.espdtIndicator else case when pd.patientEpsdtInd = 1 then 'Y' else 'N' end end demo_espdtIndicator
                      ,case when d.stageId is not null then d.recipientSexCode else pd.patientGenderCode end demo_recipientSexCode
                      ,case when d.stageId is not null then d.identityVerificationIndicator else case when pd.patientIdentityVerificationInd = 1 then 'Y' else 'N' end end demo_identityVerificationIndicator
"					  ,case when d.stageId is not null then d.citizenshipVerificationIndicator else pd.patientCitenzenshipStatusCode end demo_citizenshipVerificationIndicator"
                      ,case when d.stageId is not null then d.redetDate else replace(convert(varchar(10), pd.patientRederterminationDate, 110), '-', '/') end demo_redetDate
                      ,i.*
                  from EdmStage.MD_IdLk i
"				  left join EdmStage.MD_Demo d on i.recipientOriginalId = d.recipientOriginalId"
                  left join Patient.PatientDim pd on 'MD' + i.recipientOriginalId = pd.enterprisePatientId
                                                     and pd.clientId = 38
"													 and pd.patientActiveFlag = 1"
                  left join EdmLib.Mapping m on pd.patientRaceCode = m.outValue
                                                and m.name = 'MD_RACE_CODE'
                  where i.fileRequestId = :fileRequestId
"				  ) x"
"	          join Patient.AddressDim ad on ad.clientId = 38"
"	                                    and x.patientId = ad.patientId"
"										and ad.activeFlag = 1"
             where x.rnk = 1) x1
" where x1.rnk = 1 ; 	1	2019-02-11 14:55:20.8033333	mssql"
"14	0	MERGE_INTO_InstitutionalClaimInfoRefHeader	insert into ClaimInfo.InstitutionalClaimInfoRefHeader"
      (clientId
"	  ,patientId"
"	  ,payerClaimControlNumber"
"	  ,payerClaimControlNumberExt"
"	  ,adjustedClaimControlNumber"
"	  ,adjustmentSequenceNumber"
"	  ,referralNumber"
"	  ,medicalRecordNumber"
"	  ,priorAuthorizationNumber"
"	  ,peerReviewAuthorizationNumber"
"	  ,valueAddedNetworkTraceNumber"
"	  ,fileRequestId"
"	  ,stageId"
"	  ,createDateTime)"
select x.clientId                                   
      ,x.patientId
"	  ,x.payerClaimControlNumber"
"	  ,x.payerClaimControlNumberExt"
"	  ,x.adjustedClaimControlNumber"
"	  ,x.adjustmentSequenceNumber"
"	  ,x.referralNumber"
"	  ,x.medicalRecordNumber"
"	  ,x.priorAuthorizationNumber"
"	  ,x.peerReviewAuthorizationNumber"
"	  ,x.valueAddedNetworkTraceNumber"
"	  ,x.fileRequestId"
"	  ,x.stageId"
"	  ,x.createDateTime"
  from (select h.institutionalClaimInfoRefHeaderId
              ,c.clientId
              ,p.patientId
"	          ,c.payerClaimControlNumber"
"			  ,c.payerClaimControlNumberExt"
"	          ,c.adjustedClaimControlNumber"
"			  ,c.adjustmentSequenceNumber"
"			  ,c.referralNumber"
"	          ,c.medicalRecordNumber"
"			  ,c.priorAuthorizationNumber"
"	          ,c.peerReviewAuthorizationNumber"
"	          ,c.valueAddedNetworkTraceNumber"
"			  ,c.fileRequestId"
"			  ,c.stageId"
"			  ,current_timestamp createDateTime"
"	          ,row_number() over(partition by c.clientId, c.patientPrimaryNumber, c.payerClaimControlNumber order by p.patientActiveFlag desc) rnk"
          from EdmStandard.InstitutionalClaim c
          join Patient.PatientDim p on c.clientId = p.clientId
                                   and c.patientPrimaryNumber = p.patientPrimaryNumber
"		  left join ClaimInfo.InstitutionalClaimInfoRefHeader h on c.clientId = h.clientId"
"	                                                           and p.patientId = h.patientId"
"	                                                           and c.payerClaimControlNumber = h.payerClaimControlNumber "
"	                                                           and isnull(c.adjustedClaimControlNumber, '~') = isnull(h.adjustedClaimControlNumber, '~')"
"	                                                           and isnull(c.adjustmentSequenceNumber, '~') = isnull(h.adjustmentSequenceNumber, '~')"
"	                                                           and isnull(c.referralNumber, '~') = isnull(h.referralNumber, '~')"
"	                                                           and isnull(c.medicalRecordNumber, '~') = isnull(h.medicalRecordNumber, '~')"
"	                                                           and isnull(c.peerReviewAuthorizationNumber, '~') = isnull(h.peerReviewAuthorizationNumber, '~')"
"	                                                           and isnull(c.valueAddedNetworkTraceNumber, '~') = isnull(h.valueAddedNetworkTraceNumber, '~')"
         where c.fileRequestId = :fileRequestId) x
  where x.rnk = 1
"    and x.institutionalClaimInfoRefHeaderId is null	1	2019-02-12 15:05:17.4300000	mssql"
"15	41	INSERT_FairHealth_ACDCBenchmarkCategoryHistory	insert into EdmStage.FairHealth_ACDCBenchmarkCategoryHistory select * from EdmStage.FairHealth_ACDCBenchmarkCategory where fileRequestId = :fileRequestId ;	1	2019-02-14 11:51:43.5100000	mssql"
"16	41	INSERT_FairHealth_AncillaryHistory	insert into EdmStage.FairHealth_AncillaryHistory select * from EdmStage.FairHealth_Ancillary where fileRequestId = :fileRequestId ;	1	2019-02-14 11:51:43.5100000	mssql"
"17	41	INSERT_FairHealth_FrequencyHistory	insert into EdmStage.FairHealth_FrequencyHistory select * from EdmStage.FairHealth_Frequency where fileRequestId = :fileRequestId ;	1	2019-02-14 11:51:43.5100000	mssql"
"18	41	INSERT_FairHealth_GeographicFactorHistory	insert into EdmStage.FairHealth_GeographicFactorHistory select * from EdmStage.FairHealth_GeographicFactor where fileRequestId = :fileRequestId ;	1	2019-02-14 11:51:43.5100000	mssql"
"19	41	INSERT_FairHealth_ProcedureHistory	insert into EdmStage.FairHealth_ProcedureHistory select * from EdmStage.FairHealth_Procedure where fileRequestId = :fileRequestId ;	1	2019-02-14 11:51:43.5100000	mssql"
"20	41	INSERT_FairHealth_RelativeValueHistory	insert into EdmStage.FairHealth_RelativeValueHistory select * from EdmStage.FairHealth_RelativeValue where fileRequestId = :fileRequestId ;	1	2019-02-14 11:51:43.5100000	mssql"
"21	41	INSERT_FairHealth_Zip5UpHistory	insert into EdmStage.FairHealth_Zip5UpHistory select * from EdmStage.FairHealth_Zip5Up where fileRequestId = :fileRequestId ;	1	2019-02-14 11:51:43.5100000	mssql"
"22	41	INSERT_FairHealth_ZipCodeHistory	insert into EdmStage.FairHealth_ZipCodeHistory select * from EdmStage.FairHealth_ZipCode where fileRequestId = :fileRequestId ;	1	2019-02-14 11:51:43.5100000	mssql"
"23	46	INSERT_MISSING_GroupPolicy	insert into Reference.GroupPolicy"
"			 (clientId"
"			 ,groupPolicyNumber"
"			 ,groupPolicyCategory"
"			 ,groupPolicyName"
"			 ,groupPolicySectionNumber"
"			 ,groupPolicySource"
"			 ,createDate)"
select 46 clientId
      ,r.grpId groupPolicyNumber
      ,r.grpName groupPolicyCategory
      ,r.subgrpName groupPolicyName
      ,r.subgrpId groupPolicySectionNumber
      ,'ERC' groupPolicySource
      ,getDate() 
  from EdmStage.ERC_Member r
  left join Reference.GroupPolicy gp on r.grpId = gp.groupPolicyNumber
                                       and (r.subgrpId = gp.groupPolicySectionNumber or (r.subgrpID is null and gp.groupPolicySectionNumber is null))
                                       and gp.clientId = 46
 where gp.groupPolicyId is null 
   and r.fileRequestId = :fileRequestId
 group by r.grpId
         ,r.grpName
         ,r.subgrpName
"         ,r.subgrpId	1	2019-02-15 11:32:40.8900000	mssql"
"24	46	INSERT_MISSING_Plans	insert into Reference.Plans"
             (clientId 
             ,planNumber
             ,planName
             ,planDesc
             ,planSource
             ,planExclusion
             ,planMedicareInd
             ,plansActiveFlag
             ,createDate)
select 46 clientId
      ,isnull(isnull(r.planId + '/' + substring(r.prodDesc, 1, 8), r.prodDesc), r.grpId + ' - Default ') planNumber
      ,isnull(isnull(r.planId + '/' + substring(r.prodDesc, 1, 8), r.prodDesc), r.grpId + ' - Default ')  planName
      ,isnull(r.planId + ' - ' + r.prodDesc, r.prodDesc) planDesc
      ,'ERC' planSource
      ,0 planExclusion
      ,0 planMedicareInd
      ,1 plansActiveFlag
      ,current_timestamp
  from EdmStage.ERC_Member r
  left join Reference.Plans bp on isnull(r.planId + '/' + substring(r.prodDesc, 1, 8), r.prodDesc) = bp.planNumber 
                              and bp.clientId = 46
 where bp.plansId is null
   and r.fileRequestId = :fileRequestId
   and (isnull(r.planId + '/' + substring(r.prodDesc, 1, 8), r.prodDesc) is not null 
     or ascii(trim(r.grpId)) is not null)
 group by isnull(isnull(r.planId + '/' + substring(r.prodDesc, 1, 8), r.prodDesc), r.grpId + ' - Default ')
"         ,isnull(r.planId + ' - ' + r.prodDesc, r.prodDesc) ; 	1	2019-02-15 11:33:01.1733333	mssql"
"25	46	INSERT_MISSING_Members_aka_RETIRE	insert into EdmStage.ERC_Member"
                              (fileRequestId
                              ,stageId
                              ,grpId
                              ,grpName
                              ,subgrpId
                              ,subgrpName
                              ,planID
                              ,prodDesc
                              ,mbrPlanTyp
                              ,ssn
                              ,mbrID
                              ,firstName
                              ,midInit
                              ,lastName
                              ,mbrSex
                              ,mbrRel
                              ,mbrDOB
                              ,origEffDt1
                              ,termDt)
                        select :fileRequestId
                              ,:maxStageId + row_number() over(partition by 1 order by origEffDt1) stageId
                              ,x.grpId
                              ,x.grpName
                              ,x.subgrpId
                              ,x.subgrpName
                              ,x.planID
                              ,x.prodDesc
                              ,x.mbrPlanTyp
                              ,x.ssn
                              ,x.mbrID
                              ,x.firstName
                              ,x.midInit
                              ,x.lastName
                              ,x.mbrSex
                              ,x.mbrRel
                              ,x.mbrDOB
                              ,x.origEffDt1
                              ,x.termDt
                         from (select g.groupPolicyNumber grpId
                                     ,g.groupPolicyCategory grpName
                                     ,g.groupPolicySectionNumber subgrpId
                                     ,g.groupPolicyName subgrpName
                                     ,substring(bp.planNumber, 1, case when charindex('/', bp.planNumber) > 1 then charindex('/', bp.planNumber)- 1 end) planID
"									 ,replace(bp.planDesc, substring(bp.planNumber, 1, case when charindex('/', bp.planNumber) > 1 then charindex('/', bp.planNumber)- 1 end) + ' - ', '') prodDesc"
                                     ,null mbrPlanTyp -- do i really need to capture this upstream? ... 'cause i'm not...
                                     ,p.PatientSsn ssn
                                     ,p.PatientPrimaryNumber mbrID
                                     ,p.PatientFirstName firstName
                                     ,p.PatientMiddleName midInit
                                     ,p.PatientLastName lastName
                                     ,p.PatientGenderCode mbrSex
                                     ,case when p.RelationshipCode = '18' then 'SUBSCRIBER'
                                           when p.RelationshipCode = '01' and p.PatientGenderCode = 'M' then 'HUSBAND'
                                           when p.RelationshipCode = '01' and p.PatientGenderCode = 'F' then 'WIFE'
                                           when p.RelationshipCode = '01' then 'SPOUSE'
                                           when p.RelationshipCode = '19' and p.PatientGenderCode = 'M' then 'SON'
                                           when p.RelationshipCode = '19' and p.PatientGenderCode = 'F' then 'DAUGHTER'
                                           when p.RelationshipCode = '19' then 'CHILD'
                                      end mbrREL
                                     ,convert(varchar(10), p.patientBirthDate, 101) mbrDOB
                                     ,convert(varchar(10), f.groupPolicyEffectiveDate, 101) origEffDt1
                                     ,convert(varchar(10), dateadd(day, -1, cast(year(sysdatetime()) as varchar(4)) + '-' + cast(month(sysdatetime()) as varchar(2)) + '-01'), 101) termDt -- dates to mm/dd/yyyy
                                 from Patient.PatientDim p
                                 join Patient.EligibilityFact f on p.clientId = f.clientId
                                                                   and p.patientId = f.patientId
                                                                   and f.eligibilityFactActiveFlag = 1
                                                                   and (f.groupPolicyExpirationDate is null
                                                                     or f.groupPolicyExpirationDate > dateadd(day, -1, getdate()))
                                 join Reference.GroupPolicy g on f.groupPolicyId = g.groupPolicyId
                                 join Reference.Plans bp on f.benefitPlanId = bp.plansId
                            left join EdmStage.ERC_Member r on p.patientPrimaryNumber = r.mbrId
                                                               and r.fileRequestId = :fileRequestId
                                where p.ClientId = 46
                                  and r.stageId is null
                                  and p.patientPrimaryNumber is not null -- exclude any potential bad data
                                group by g.groupPolicyNumber
                                        ,g.groupPolicyCategory
                                        ,g.groupPolicySectionNumber
                                        ,g.groupPolicyName
                                        ,substring(bp.planNumber, 1, case when charindex('/', bp.planNumber) > 1 then charindex('/', bp.planNumber)- 1 end)
"										,replace(bp.planDesc, substring(bp.planNumber, 1, case when charindex('/', bp.planNumber) > 1 then charindex('/', bp.planNumber)- 1 end) + ' - ', '')"
                                        ,p.patientSsn
                                        ,p.patientPrimaryNumber
                                        ,p.patientFirstName
                                        ,p.patientMiddleName
                                        ,p.patientLastName
                                        ,p.patientGenderCode
                                        ,case when p.relationshipCode = '18' then 'SUBSCRIBER'
                                              when p.relationshipCode = '01' and p.patientGenderCode = 'M' then 'HUSBAND'
                                              when p.relationshipCode = '01' and p.patientGenderCode = 'F' then 'WIFE'
                                              when p.relationshipCode = '01' then 'SPOUSE'
                                              when p.relationshipCode = '19' and p.patientGenderCode = 'M' then 'SON'
                                              when p.relationshipCode = '19' and p.patientGenderCode = 'F' then 'DAUGHTER'
                                              when p.relationshipCode = '19' then 'CHILD'
                                         end
                                        ,convert(varchar(10), p.patientBirthDate, 101)
"                                        ,convert(varchar(10), f.groupPolicyEffectiveDate, 101)) x	1	2019-02-15 11:33:04.9400000	mssql"
"26	46	GET_TerminationPercentage	select convert(int, round(count(case when planEndDateNormalized < dateadd(month, 1, isnull(try_convert(date, right(left(fileName, 66), 4) + left(right(left(fileName, 66), 8), 2) + '01', 101), convert(date, right(left(fileName, 58), 4) + left(right(left(fileName, 66), 8), 2) + '01', 121)))"
                  then stageId end) 
"	   * 1.0 /  -- convert to decimal"
"	   case count(*) when 0 then 1 else count(*) end * 100, 0))"
  from EdmStandard.MemberReference r
  join EdmLib.FileRequest f on r.fileRequestId = f.fileRequestId
" where r.fileRequestId = :fileRequestId	1	2019-02-15 11:42:58.9400000	mssql"
"27	68	INSERT_INTO_FROM_X220	insert into EdmStage.CH_Member "
"	   (stageId "
"	   ,fileRequestId  "
"	   ,headerId  "
"	   ,detailId  "
"	   ,enterprisePatientId  "
"	   ,enterpriseSubscriberId  "
       ,memberRank 
"	   ,patientPrimaryNumber  "
"	   ,patientPrimaryNumberQualifier  "
"	   ,subscriberPrimaryNumber  "
"	   ,subscriberPrimaryNumberQualifier  "
"	   ,originalMemberIdentifier  "
"	   ,memberSsnQualifier  "
"	   ,memberSsn  "
"	   ,benefitStatusCode  "
"	   ,relationshipCode  "
"	   ,maintenanceTypeCode  "
"	   ,maintenanceReasonCode  "
"	   ,medicarePlanCode  "
"	   ,medicareEligibilityReasonCode  "
"	   ,cobraQualifyingEventCode  "
"	   ,employmentStatusCode  "
"	   ,studentStatusCode  "
"	   ,handicapIndicator  "
"	   ,confidentialityCode  "
"	   ,birthSequenceNumber  "
"	   ,memberNameEntityIdentifierCode  "
"	   ,memberLastName  "
"	   ,memberFirstname  "
"	   ,memberMiddleName  "
"	   ,memberNamePrefix  "
"	   ,memberNameSuffix  "
"	   ,memberBirthDate  "
"	   ,memberDeathDate  "
"	   ,memberGenderCode  "
"	   ,memberMaritalStatusCode  "
"	   ,memberRaceCode  "
"	   ,memberCitizenshipStatusCode  "
"	   ,memberHealthRelatedCode  "
"	   ,memberHeight  "
"	   ,memberWeight  "
"	   ,groupPolicyNumber  "
"	   ,planNumber  "
       ,planBeginDate
       ,planEndDate
"	   ,memberCommunicationNumberQualifier  "
"	   ,memberCommunicationNumber  "
"	   ,memberCommunicationNumberQualifier2  "
"	   ,memberCommunicationNumber2  "
"	   ,memberCommunicationNumberQualifier3  "
"	   ,memberCommunicationNumber3  "
"	   ,memberPrimaryAddressLine1  "
"	   ,memberPrimaryAddressLine2  "
"	   ,memberPrimaryAddressCityName  "
"	   ,memberPrimaryAddressStateCode  "
"	   ,memberPrimaryAddressZipCode  "
"	   ,memberPrimaryAddressCountryCode  "
"	   ,memberPrimaryAddressLocationQualifier  "
"	   ,memberPrimaryAddressLocationIdentifier  "
"	   ,memberMailingAddressLine1  "
"	   ,memberMailingAddressLine2  "
"	   ,memberMailingAddressCityName  "
"	   ,memberMailingAddressStateCode  "
"	   ,memberMailingAddressZipCode  "
"	   ,memberMailingAddressCountryCode  "
"	   ,primaryCareProviderEntityIdentifierCode  	        "
"	   ,primaryCareProviderEntityTypeCode  "
"	   ,primaryCareProviderNPI  "
"	   ,primaryCareProviderLastOrOrganizationName  "
"	   ,primaryCareProviderFirstName  "
"	   ,primaryCareProviderAddressLine1  "
"	   ,primaryCareProviderAddressLine2  "
"	   ,primaryCareProviderCityName  "
"	   ,primaryCareProviderZipCode  "
"	   ,primaryCareProviderStateCode  "
"	   ,memberPriorIncorrectLastName  "
"	   ,memberPriorIncorrectFirstName  "
"	   ,memberPriorIncorrectMiddleName  "
"	   ,memberPriorIncorrectNamePrefix  "
"	   ,memberPriorIncorrectNameSuffix  "
"	   ,memberPriorIncorrectIdentificationCodeQualifier  "
"	   ,memberPriorIncorrectIdentificationCode  "
"	   ,memberPriorIncorrectBirthDate  "
"	   ,memberPriorIncorrectGenderCode  "
"	   ,memberPriorIncorrectMaritalStatusCode  "
"	   ,memberPriorIncorrectRaceCode  "
"	   ,memberPriorIncorrectCitizenshipStatusCode  "
"	   ,memberPriorIncorrectRaceCollectionCode "
"	   ,transactionSetCreationDateTime "
"	   ,memberLanguageCode "
"	   ,memberLanguageUseCode) "
select row_number() over(partition by 1 order by detailId) stageId 
"	  ,t.* "
  from (select d.fileRequestId  
              ,d.headerId  
              ,d.detailId  
              ,'CH'+ mli.REF_ReferenceIdentification enterprisePatientId  
              ,'CH'+ mli.REF_ReferenceIdentification enterprsieSubscriberId  
              ,mid.REF_ReferenceIdentification memberRank  
              ,mli.REF_ReferenceIdentification patientPrimaryNumber  
              ,'MI' patientPrimaryNumberQualifier  
              ,mli.REF_ReferenceIdentification subscriberPrimaryNumber  
              ,'MI' subscriberPrimaryNumberQualifier  
              ,mli.REF_ReferenceIdentification originalMemberIdentifier  
              ,d.Loop2100A_NM1_IdentificationCodeQualifier memberSsnQualifier  
              ,d.Loop2100A_NM1_IdentificationCode memberSsn  
              ,d.INS_BenefitStatusCode benefitStatusCode  
              ,d.INS_IndividualRelationshipCode relationshipCode  
              ,isnull(hc.HD_MaintenanceTypeCode, d.INS_MaintenanceTypeCode) maintenanceTypeCode  
              ,isnull(hc.HD_MaintenanceReasonCode, d.INS_MaintenanceReasonCode) maintenanceReasonCode  
              ,d.INS_MedicareStatus_MedicarePlanCode medicarePlanCode  
              ,d.INS_MedicareStatus_MedicareEligibilityReasonCode medicareEligibilityReasonCode  
              ,d.INS_CobraQualifying cobraQualifyingEventCode  
              ,d.INS_EmpolymentStatusCode employmentStatusCode  
              ,d.INS_StudentStatusCode StudentStatusCode  
              ,case d.INS_YesNoConditionOrReponseCode2 when 'Y' then 1 else 0 end handicapIndicator  
              ,d.INS_ConfidentialityCode confidentialityCode  
              ,d.INS_Number BirthSequenceNumber  
              ,d.Loop2100A_NM1_EntityIdentifierCode memberNameEntityIdentifierCode  
              ,d.Loop2100A_NM1_NameLastOrOrganizationName memberLastName  
              ,d.Loop2100A_NM1_NameFirst memberFirstname  
              ,d.Loop2100A_NM1_NameMiddle memberMiddleName  
              ,d.Loop2100A_NM1_NamePrefix memberNamePrefix  
              ,d.Loop2100A_NM1_NameSuffix memberNameSuffix  
              ,d.Loop2100A_DMG_DateTimePeriod memberBirthDate  
              ,d.INS_DateTimePeriod memberDeathDate  
              ,d.Loop2100A_DMG_GenderCode memberGenderCode  
              ,d.Loop2100A_DMG_MaritalStatusCode memberMaritalStatusCode  
              ,d.Loop2100A_DMG_RaceOrEthnicityCode memberRaceCode  
              ,d.Loop2100A_DMG_CitizenshipStatusCode memberCitizenshipStatusCode  
              ,d.Loop2100A_HLH_HealthRelatedCode memberHealthRelatedCode  
              ,d.Loop2100A_HLH_Height memberHeight  
              ,d.Loop2100A_HLH_Weight memberWeight  
              ,gp.REF_ReferenceIdentification groupPolicyNumber  
              ,case when hc.HD_CoverageLevelCode is null then hc.HD_PlanCoverageDescription
                    when hc.HD_CoverageLevelCode is not null then hc.HD_PlanCoverageDescription + '-' + hc.HD_CoverageLevelCode
                end planNumber
              ,pb.DTP_DateTimePeriod planBeginDate 
              ,pe.DTP_DateTimePeriod planEndDate
              ,d.Loop2100A_PER_CommunicationNumberQualifier memberCommunicationNumberQualifier  
              ,d.Loop2100A_PER_CommunicationNumber memberCommunicationNumber  
              ,d.Loop2100A_PER_CommunicationNumberQualifier2 memberCommunicationNumberQualifier2  
              ,d.Loop2100A_PER_CommunicationNumber2 memberCommunicationNumber2  
              ,d.Loop2100A_PER_CommunicationNumberQualifier3 memberCommunicationNumberQualifier3  
              ,d.Loop2100A_PER_CommunicationNumber3 memberCommunicationNumber3  
              ,d.Loop2100A_N3_AddressInformation memberPrimaryAddressLine1  
              ,d.Loop2100A_N3_AddressInformation2 memberPrimaryAddressLine2  
              ,d.Loop2100A_N4_CityName memberPrimaryAddressCityName  
              ,d.Loop2100A_N4_StateOrProvinceCode memberPrimaryAddressStateCode  
              ,d.Loop2100A_N4_PostalCode memberPrimaryAddressZipCode  
              ,d.Loop2100A_N4_CountryCode memberPrimaryAddressCountryCode  
              ,d.Loop2100A_N4_LocationQualifier memberPrimaryAddressLocationQualifier  
              ,d.Loop2100A_N4_LocationIdentifier memberPrimaryAddressLocationIdentifier  
              ,d.Loop2100C_N3_AddressInformation memberMailingAddressLine1  
              ,d.Loop2100C_N3_AddressInformation2 memberMailingAddressLine2  
              ,d.Loop2100C_N4_CityName memberMailingAddressCityName  
              ,d.Loop2100C_N4_StateOrProvinceCode memberMailingAddressStateCode  
              ,d.Loop2100C_N4_PostalCode memberMailingAddressPostalCode  
              ,d.Loop2100C_N4_CountryCode memberMailingAddressCountryCode  
              ,prv.NM1_EntityIdentifierCode primaryCareProviderEntityIdentifierCode  
              ,prv.NM1_EntityTypeQualifier primaryCareProviderEntityTypeCode 
              ,case when prv.NM1_IdentificationCodeQualifier = 'XX' then prv.NM1_IdentificationCode end primaryCareProviderNPI  
              ,prv.NM1_NameLastOrOrganizationName primaryCareProviderLastOrOrganizationName  
              ,prv.NM1_NameFirst primaryCareProviderFirstName  
              ,prva.N3_AddressInformation primaryCareProviderAddressLine1  
              ,prva.N3_AddressInformation2 primaryCareProviderAddressLine2  
              ,prva.N4_CityName primaryCareProviderCityName  
              ,prva.N4_PostalCode primaryCareProviderZipCode  
              ,prva.N4_StateOrProvinceCode primaryCareProviderStateCode  
              ,d.Loop2100B_NM1_NameLastOrOrganizationName memberPriorIncorrectLastName  
              ,d.Loop2100B_NM1_NameFirst memberPriorIncorrectFirstName  
              ,d.Loop2100B_NM1_NameMiddle memberPriorIncorrectMiddleName  
              ,d.Loop2100B_NM1_NamePrefix memberPriorIncorrectNamePrefix  
              ,d.Loop2100B_NM1_NameSuffix memberPriorIncorrectNameSuffix  
              ,d.Loop2100B_NM1_IdentificationCodeQualifier memberPriorIncorrectIdentificationCodeQualifier  
              ,d.Loop2100B_NM1_IdentificationCode memberPriorIncorrectIdentificationCode  
              ,d.Loop2100B_DMG_DateTimePeriod memberPriorIncorrectBirthDate  
              ,d.Loop2100B_DMG_GenderCode memberPriorIncorrectGenderCode  
              ,d.Loop2100B_DMG_MaritalStatusCode memberPriorIncorrectMaritalStatusCode  
              ,d.Loop2100B_DMG_RaceOrEthnicityCode memberPriorIncorrectRaceCode  
              ,d.Loop2100B_DMG_CitizenshipStatusCode memberPriorIncorrectCitizenshipStatusCode  
              ,d.Loop2100B_DMG_IndustryCode memberPriorIncorrectRaceCollectionCode  
              ,try_convert(datetime2, h.BGN_Date + ' ' + substring(h.BGN_Time, 1, 2) + ':' + substring(h.BGN_Time, 3, 2)) transactionSetCreateDateTime  
              ,ml.LUI_IdentificationCode memberLanguageCode 
              ,ml.LUI_UseOfLanguageIndicator memberLanguageUseCode 
"	      from EdmStageX220.Detail d "
          join EdmStageX220.Header h on d.HeaderId = h.HeaderId  
"			                        and d.FileRequestId = h.FileRequestId  "
"		  join EdmStageX220.MemberLevelIdentifier mli on d.FileRequestId = mli.FileRequestId  "
"		                                             and d.DetailId = mli.DetailId  "
"		                                              -- subscriber/patient primary number  "
"		                                             and mli.REF_ReferenceIdentificationQualifier = '0F'  "
"		  join EdmStageX220.MemberLevelIdentifier mid on d.FileRequestId = mid.FileRequestId  "
"		                                             and d.DetailId = mid.DetailId  "
"		                                              -- member rank  "
"		                                             and mid.REF_ReferenceIdentificationQualifier = 'ZZ'  "
"		  join EdmStageX220.MemberLevelIdentifier gp on d.FileRequestId = gp.FileRequestId  "
"		                                            and d.DetailId = gp.DetailId  "
"		                                             -- group policy number  "
"		                                            and gp.REF_ReferenceIdentificationQualifier = '1L'  "
"		  join EdmStageX220.HealthCoverage hc on d.DetailId = hc.DetailId  "
"		                                     and d.FileRequestId = hc.FileRequestId  "
          join EdmStageX220.HealthCoverageDate pb on hc.HealthCoverageId = pb.HealthCoverageId
                                                 and hc.FileRequestId = pb.FileRequestId 
"		  					                      -- plan begin date"
"		  					                     and pb.DTP_DateTimeQualifier = '348'"
          left  join EdmStageX220.HealthCoverageDate pe on hc.HealthCoverageId = pe.HealthCoverageId
                                                       and hc.FileRequestId = pe.FileRequestId
"								                        -- plan end date"
"								                       and pe.DTP_DateTimeQualifier = '349'"
"		  left join EdmStageX220.ProviderInformation prv on hc.HealthCoverageId = prv.HealthCoverageId  "
"			                                            and hc.FileRequestId = prv.FileRequestId  "
"													     -- primary care provider  "
"											            and prv.NM1_EntityIdentifierCode = 'P3'  "
"		  left join EdmStageX220.ProviderAddress prva on prv.ProviderInformationId = prva.ProviderInformationId  "
"		                                             and prv.FileRequestId = prva.FileRequestId "
"		  left join EdmStageX220.MemberLanguage ml on d.DetailId = ml.DetailId "
"		                                          and d.FileRequestId = ml.FileRequestId "
"			  where d.FileRequestId = :fileRequestId) t ; 	1	2019-02-20 14:50:26.0133333	mssql"
"28	68	INSERT_RETIRED_MEMBERS	insert"
into EdmStage.CH_Member 
"	(stageId"
"	,headerId"
"	,detailId"
"	,fileRequestId"
"	,enterprisePatientId"
"	,enterpriseSubscriberId"
"	,patientPrimaryNumber"
"	,patientPrimaryNumberQualifier"
"	,subscriberPrimaryNumber"
"	,subscriberPrimaryNumberQualifier"
"	,memberSsn"
"	,relationshipCode"
"	,memberLastName"
"	,memberFirstname"
"	,memberMiddleName"
"	,memberBirthDate"
"	,memberDeathDate"
"	,memberGenderCode"
"	,groupPolicyNumber"
"	,planNumber"
"	,planBeginDate"
"	,planEndDate"
"	,transactionSetCreationDateTime"
"	,handicapIndicator"
"	,memberRank) "
select :maxStageId + row_number() over(partition by 1 order by planBeginDate) stageId 
"	  ,:maxStageId + row_number() over(partition by 1 order by planBeginDate) headerId "
"	  ,:maxStageId + row_number() over(partition by 1 order by planBeginDate) detailId "
"	  ,:fileRequestId "
"	  ,x.enterprisePatientId"
"	  ,x.enterpriseSubscriberId"
"	  ,x.patientPrimaryNumber"
"	  ,x.patientPrimaryNumberQualifier"
"	  ,x.subscriberPrimaryNumber"
"	  ,x.subscriberPrimaryNumberQualifier"
"	  ,x.patientSsn"
"	  ,x.relationshipCode"
"	  ,x.memberLastName"
"	  ,x.memberFirstname"
"	  ,x.memberMiddleName"
"	  ,x.memberBirthDate"
"	  ,x.memberDeathDate"
"	  ,x.memberGenderCode"
"	  ,x.groupPolicyNumber"
"	  ,x.planNumber"
"	  ,x.planBeginDate"
"	  ,x.planEndDate"
"	  ,x.transactionSetCreationDateTime"
"	  ,0"
"	  ,x.memberRank"
  from (select p.enterprisePatientId enterprisePatientId 
"	          ,p.enterpriseSubscriberId enterpriseSubscriberId"
"	          ,p.patientPrimaryNumber patientPrimaryNumber"
"	          ,p.patientPrimaryNumberQualifier patientPrimaryNumberQualifier"
"	          ,p.subscriberPrimaryNumber subscriberPrimaryNumber"
"	          ,p.subscriberPrimaryNumberQualifier subscriberPrimaryNumberQualifier"
"	          ,p.patientSsn patientSsn"
"	          ,p.relationshipCode relationshipCode"
"	          ,p.patientLastName memberLastName "
"	          ,p.patientFirstName memberFirstname "
"	          ,p.patientMiddleName memberMiddleName"
"	          ,convert(varchar(10), p.patientBirthDate,112) memberBirthDate"
"	          ,convert(varchar(10), p.patientDeathDate,112) memberDeathDate"
"	          ,p.patientGenderCode memberGenderCode "
"	          ,g.groupPolicyNumber groupPolicyNumber"
"	          ,bp.planNumber planNumber"
"	          ,convert(varchar(10), f.benefitPlanStartDate, 112) planBeginDate "
"	          ,convert(varchar(10), DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1), 112) planEndDate "
"	          ,try_convert(datetime2, getdate()) transactionSetCreationDateTime "
"	          ,right(p.patientprimaryNumber, 2) memberRank"
"	      from Patient.PatientDim p "
"		  join Patient.EligibilityFact f on p.clientId = f.clientId"
"		                                    and p.patientId = f.patientId"
"		                                    and f.eligibilityFactActiveFlag = 1"
"		                                    and (f.groupPolicyExpirationDate is null  "
"		                                      or f.groupPolicyExpirationDate > dateadd(day, -1, getdate()))"
"		  join Reference.GroupPolicy g on f.groupPolicyId = g.groupPolicyId"
"		  join Reference.Plans bp on f.benefitPlanId = bp.plansId"
"		  left join EdmStage.CH_Member r on isnull(r.memberFirstName, '~') = isnull(p.patientFirstName, '~') "
                                        and isnull(r.memberGenderCode, '~') = isnull(p.patientGenderCode, '~') 
                                        and r.patientPrimaryNumber = left(p.patientPrimaryNumber, len(p.patientPrimaryNumber) - 2)
                                        and r.relationshipCode = p.relationshipCode
                                        and (try_convert(datetime2, r.memberBirthDate, 112) = p.patientBirthDate 
                                           or (try_convert(datetime2, r.memberBirthDate, 112) is null 
                                           and p.patientBirthDate is null)) 
"		 where p.ClientId = :clientId "
"		   and r.stageId is null"
"		   and p.patientPrimaryNumber is not null ) x;	1	2019-02-20 15:57:32.1333333	mssql"
"29	36	MERGE_INTO_Nppes	declare @fileRequestId bigint = :fileRequestId ;"

merge into Reference.Nppes m 
using (select cast(npi as nvarchar(255)) npi 
      ,cast(entityTypeCode as nvarchar(255)) entityTypeCode  
      ,cast(providerOrganizationName as nvarchar(255)) providerOrganizationName 
      ,cast(providerLastName as nvarchar(255)) providerLastName 
      ,cast(providerFirstName as nvarchar(255)) providerFirstName 
      ,cast(providerMiddleName as nvarchar(255)) providerMiddleName 
      ,cast(providerNamePrefixText as nvarchar(255)) providerNamePrefixText 
      ,cast(providerNameSuffixText as nvarchar(255)) providerNameSuffixText 
      ,cast(providerCredentialText as nvarchar(255)) providerCredentialText 
      ,cast(providerOtherOrganizationName as nvarchar(255)) providerOtherOrganizationName 
      ,cast(providerOtherOrganizationNameTypeCode as nvarchar(255)) providerOtherOrganizationNameTypeCode 
      ,cast(providerOtherLastName as nvarchar(255)) providerOtherLastName 
      ,cast(providerOtherFirstName as nvarchar(255)) providerOtherFirstName 
      ,cast(providerOtherMiddleName as nvarchar(255)) providerOtherMiddleName 
      ,cast(providerOtherNamePrefixText as nvarchar(255)) providerOtherNamePrefixText 
      ,cast(providerOtherNameSuffixText as nvarchar(255)) providerOtherNameSuffixText 
      ,cast(providerOtherCredentialText as nvarchar(255)) providerOtherCredentialText 
      ,cast(providerOtherLastNameTypeCode as nvarchar(255)) providerOtherLastNameTypeCode 
      ,cast(providerGenderCode as nvarchar(255)) providerGenderCode 
      ,cast(providerEnumerationDate as nvarchar(255)) providerEnumerationDate 
      ,cast(providerFirstLineBusinessMailingAddress as nvarchar(255)) providerBusMailAddressLine1 
      ,cast(providerSecondLineBusinessMailingAddress as nvarchar(255)) providerBusMailAddressLine2 
      ,cast(providerBusinessMailingAddressCityName as nvarchar(255)) providerBusMailCity 
      ,cast(providerBusinessMailingAddressStateName as nvarchar(255)) providerBusMailState 
      ,cast(providerBusinessMailingAddressPostalCode as nvarchar(255)) providerBusMailPostalZoneCode 
      ,cast(providerBusinessMailingAddressCountryCode as nvarchar(255)) providerBusMailCountryCode 
      ,cast(providerBusinessMailingAddressTelephoneNumber as nvarchar(255)) providerBusMailTelephoneNumber 
      ,cast(providerFirstLineBusinessPracticeLocationAddress as nvarchar(255)) providerPracticeLocAddressLine1 
      ,cast(providerSecondLineBusinessPracticeLocationAddress as nvarchar(255)) providerPracticeLocAddressLine2 
      ,cast(providerBusinessPracticeLocationAddressCityName as nvarchar(255)) providerPracticeLocCity 
      ,cast(providerBusinessPracticeLocationAddressStateName as nvarchar(255)) providerPracticeLocState 
      ,cast(providerBusinessPracticeLocationAddressPostalCode as nvarchar(255)) providerPracticeLocPostalZoneCode 
      ,cast(providerBusinessPracticeLocationAddressCountryCode as nvarchar(255)) providerPracticeLocCountryCode 
      ,cast(providerBusinessPracticeLocationAddressTelephoneNumber as nvarchar(255)) providerPracticeLocTelephoneNumber 
      ,cast(lastUpdateDate as nvarchar(255)) lastUpdateDate 
"	from EdmReference.NPPES_CSV "
"	where fileRequestId = @fileRequestId) u "
"	on m.npi = u.npi "
"	when not matched then insert(npi "
      ,entityTypeQualifier 
      ,providerOrganizationName 
      ,providerLastName 
      ,providerFirstName 
      ,providerMiddleName 
      ,providerPrefixName 
      ,providerSuffixName 
      ,providerCredentialText 
      ,providerOtherOrganizationName 
      ,providerOtherOrganizationNameTypeCode 
      ,providerOtherLastName 
      ,providerOtherFirstName 
      ,providerOtherMiddleName 
      ,providerOtherPrefixName 
      ,providerOtherSuffixName 
      ,providerOtherCredentialText 
      ,providerOtherLastNameTypeCode 
      ,providerGenderCode 
      ,providerEnumerationDate 
      ,providerBusMailAddressLine1
      ,providerBusMailAddressLine2
      ,providerBusMailCity
      ,providerBusMailState
      ,providerBusMailPostalZoneCode
      ,providerBusMailCountryCode
      ,providerBusMailTelephoneNumber
      ,providerPracticeLocAddressLine1
      ,providerPracticeLocAddressLine2
      ,providerPracticeLocCity
      ,providerPracticeLocState
      ,providerPracticeLocPostalZoneCode
      ,providerPracticeLocCountryCode
      ,providerPracticeLocTelephoneNumber
      ,lastUpdateDate) 
"	  values(u.npi "
      ,u.entityTypeCode 
      ,u.providerOrganizationName 
      ,u.providerLastName 
      ,u.providerFirstName 
      ,u.providerMiddleName 
      ,u.providerNamePrefixText 
      ,u.providerNameSuffixText 
      ,u.providerCredentialText 
      ,u.providerOtherOrganizationName 
      ,u.providerOtherOrganizationNameTypeCode 
      ,u.providerOtherLastName 
      ,u.providerOtherFirstName 
      ,u.providerOtherMiddleName 
      ,u.providerOtherNamePrefixText 
      ,u.providerOtherNameSuffixText 
      ,u.providerOtherCredentialText 
      ,u.providerOtherLastNameTypeCode 
      ,u.providerGenderCode 
      ,u.providerEnumerationDate 
      ,u.providerBusMailAddressLine1
      ,u.providerBusMailAddressLine2
      ,u.providerBusMailCity
      ,u.providerBusMailState
      ,u.providerBusMailPostalZoneCode
      ,u.providerBusMailCountryCode
      ,u.providerBusMailTelephoneNumber
      ,u.providerPracticeLocAddressLine1
      ,u.providerPracticeLocAddressLine2
      ,u.providerPracticeLocCity
      ,u.providerPracticeLocState
      ,u.providerPracticeLocPostalZoneCode
      ,u.providerPracticeLocCountryCode
      ,u.providerPracticeLocTelephoneNumber
      ,u.lastUpdateDate) 
"	  when matched then update set m.npi = u.npi "
      ,m.entityTypeQualifier = u.entityTypeCode 
      ,m.providerOrganizationName = u.providerOrganizationName 
      ,m.providerLastName = u.providerLastName 
      ,m.providerFirstName = u.providerFirstName 
      ,m.providerMiddleName = u.providerMiddleName 
      ,m.providerPrefixName = u.providerNamePrefixText 
      ,m.providerSuffixName = u.providerNameSuffixText 
      ,m.providerCredentialText = u.providerCredentialText 
      ,m.providerOtherOrganizationName = u.providerOtherOrganizationName 
      ,m.providerOtherOrganizationNameTypeCode = u.providerOtherOrganizationNameTypeCode 
      ,m.providerOtherLastName = u.providerOtherLastName 
      ,m.providerOtherFirstName = u.providerOtherFirstName 
      ,m.providerOtherMiddleName = u.providerOtherMiddleName 
      ,m.providerOtherPrefixName = u.providerOtherNamePrefixText 
      ,m.providerOtherSuffixName = u.providerOtherNameSuffixText 
      ,m.providerOtherCredentialText = u.providerOtherCredentialText 
      ,m.providerOtherLastNameTypeCode = u.providerOtherLastNameTypeCode 
      ,m.providerGenderCode = u.providerGenderCode 
      ,m.providerEnumerationDate = u.providerEnumerationDate 
      ,m.providerBusMailAddressLine1 = u.providerBusMailAddressLine1
      ,m.providerBusMailAddressLine2 = u.providerBusMailAddressLine2
      ,m.providerBusMailCity = u.providerBusMailCity
      ,m.providerBusMailState = u.providerBusMailState
      ,m.providerBusMailPostalZoneCode = u.providerBusMailPostalZoneCode
      ,m.providerBusMailCountryCode = u.providerBusMailCountryCode
      ,m.providerBusMailTelephoneNumber = u.providerBusMailTelephoneNumber
      ,m.providerPracticeLocAddressLine1 = u.providerPracticeLocAddressLine1
      ,m.providerPracticeLocAddressLine2 = u.providerPracticeLocAddressLine2
      ,m.providerPracticeLocCity = u.providerPracticeLocCity
      ,m.providerPracticeLocState = u.providerPracticeLocState
      ,m.providerPracticeLocPostalZoneCode = u.providerPracticeLocPostalZoneCode
      ,m.providerPracticeLocCountryCode = u.providerPracticeLocCountryCode
      ,m.providerPracticeLocTelephoneNumber = u.providerPracticeLocTelephoneNumber
      ,m.lastUpdateDate = u.lastUpdateDate;

declare @functionId bigint ;
select @functionId = function_id
  from sys.partition_functions
 where name = 'FileRequestNppesPfnc' ;

if (select count(*)
      from sys.partition_range_values
"	 where value = @fileRequestId "
"	   and function_id = @functionId) = 0"
begin
"	alter partition scheme FileRequestNppesPscheme next used [PRIMARY] ;"
"	alter partition function FileRequestNppesPfnc() split range (@fileRequestId) ;"
end ;

delete from EdmReference.NPPES_CSV_History where fileRequestId = @fileRequestId ;

insert into EdmReference.NPPES_CSV_History
select *
  from EdmReference.NPPES_CSV
" where fileRequestId = @fileRequestId ; 	1	2019-03-08 11:45:42.7333333	mssql"
"30	0	MERGE_INTO_ProviderDim	merge into Provider.ProviderDim m "
using (select clientId 
             ,providerPrimaryNumber 
"			 ,min(providerPrimaryNumberQualifier) providerPrimaryNumberQualifier "
"			 ,min(providerTypeCode) providerTypeCode "
             ,min(clientProviderTypeCode) clientProviderTypeCode 
"  	         ,min(firstName) providerFirstName "
"  	         ,min(lastOrOrganizationName) providerLastOrOrgName "
"  	         ,min(providerEntityTypeQualifier) entityTypeQualifier "
"			 ,min(recordTypeCode) recordTypeCode "
"			 ,min(transactionSetCreationDateTime) transactionSetCreationDateTime "
"			 ,min(stageId) headerStandardRowNumber "
"			 ,min(stageId) detailStandardRowNumber "
"			 ,min(fileRequestId) fileRequestId "
         from EdmStandard.Provider 
"		where fileRequestId = :fileRequestId "
"		  and providerPrimaryNumber is not null  "
        group by clientId 
                ,providerPrimaryNumber) u 
   on m.clientId = u.clientId 
  and m.providerPrimaryNumber = u.providerPrimaryNumber 
" when matched then update set m.providerFirstName 			   = u.providerFirstName "
"							 ,m.providerLastOrOrgName 		   = u.providerLastOrOrgName "
"							 ,m.entityTypeQualifier 		   = u.entityTypeQualifier "
"							 ,m.recordTypeCode 				   = u.recordTypeCode "
"							 ,m.providerPrimaryNumberQualifier = u.providerPrimaryNumberQualifier "
"							 ,m.providerTypeCode 			   = u.providerTypeCode "
"                             ,m.clientProviderTypeCode 		   = u.clientProviderTypeCode "
"							 ,m.headerStandardRowNumber 	   = u.headerStandardRowNumber "
"							 ,m.detailStandardRowNumber 	   = u.detailStandardRowNumber "
"							 ,m.fileRequestId 				   = u.fileRequestId "
"							 ,m.updateDateTime 				   = sysdatetime() "
 when not matched then insert (clientId 
                              ,providerPrimaryNumber 
"							  ,providerFirstName "
"							  ,providerLastOrOrgName "
"							  ,entityTypeQualifier "
"							  ,recordTypeCode "
"							  ,providerPrimaryNumberQualifier "
"							  ,providerTypeCode "
                              ,clientProviderTypeCode 
"							  ,transactionSetCreationDateTime "
"							  ,headerStandardRowNumber "
"							  ,detailStandardRowNumber "
"							  ,fileRequestId "
"							  ,createDateTime "
"							  ,providerActiveFlag) "
                       values (u.clientId 
                              ,u.providerPrimaryNumber 
"							  ,u.providerFirstName "
"							  ,u.providerLastOrOrgName "
"							  ,u.entityTypeQualifier "
"							  ,u.recordTypeCode "
"							  ,u.providerPrimaryNumberQualifier "
"							  ,u.providerTypeCode "
                              ,u.clientProviderTypeCode 
"							  ,u.transactionSetCreationDateTime "
"							  ,u.headerStandardRowNumber "
"							  ,u.detailStandardRowNumber "
"							  ,u.fileRequestId "
"							  ,getdate() "
"							  ,1); 	1	2019-03-12 19:37:21.0733333	mssql"
"31	0	MERGE_INTO_PatientDim	merge into Patient.PatientDim m "
using (select m.clientId 
             ,m.enterprisePatientId 
             ,min(m.patientPrimaryNumber) patientPrimaryNumber 
             ,min(m.patientPrimaryNumberQualifier) patientPrimaryNumberQualifier 
             ,min(m.enterpriseSubscriberId) enterpriseSubscriberId 
             ,min(m.subscriberPrimaryNumber) subscriberPrimaryNumber 
             ,min(m.subscriberPrimaryNumberQualifier) subscriberPrimaryNumberQualifier 
"			 ,min(m.ssn) ssn"
             ,min(isnull(m.relationshipCode, '~')) relationshipCode 
             ,min(m.firstName) firstName 
             ,min(m.lastName) lastName 
             ,min(m.birthDate) birthDate 
             ,substring(min(m.genderCode), 1, 5) genderCode 
"			 ,substring(min(m.raceCode), 1, 5) raceCode"
             ,min(m.transactionSetCreationDateTime) transactionSetCreationDateTime 
             ,min(convert(datetime2, m.redeterminationDate, 111)) patientRedeterminationDate
             ,min(m.stageId) stageId 
             ,min(m.recordTypeCode) recordTypeCode 
             ,min(rt.recordTypeId) recordTypeId 
             ,min(m.fileRequestId) fileRequestId 
"			 ,max(m.location) location"
"			 ,max(m.division) division"
"			 ,max(m.department) department"
"			 ,max(m.wageType) wageType"
"			 ,max(case when m.isFullTime = 1 then 1 when m.isFullTime = 0 then 0 end) isFullTime"
             ,min(isnull(m.medicareIndicatorCode, '~')) patientMedicareIndicatorCode
"			 ,min(case m.isTemporaryMember when 1 then 1 else 0 end) isTemporary"
         from EdmStandard.Member m 
         join Reference.RecordType rt on m.recordTypeCode = rt.recordTypeCode 
        where m.fileRequestId = :fileRequestId 
          and ascii(ltrim(m.patientPrimaryNumber)) is not null
"		  and ascii(ltrim(m.enterprisePatientId)) is not null"
        group by m.clientId  
                ,m.enterprisePatientId) u 
   on u.clientId = m.clientId 
  and u.enterprisePatientId = m.enterprisePatientId 
  and m.patientActiveFlag = 1
 when not matched then insert (clientId 
                              ,enterprisePatientId 
                              ,patientPrimaryNumber 
                              ,patientPrimaryNumberQualifier 
                              ,enterpriseSubscriberId 
                              ,subscriberPrimaryNumber 
                              ,subscriberPrimaryNumberQualifier
"							  ,patientSsn 	"
                              ,relationshipCode 
                              ,patientFirstName 
                              ,patientLastName 
                              ,patientBirthDate 
                              ,patientGenderCode
"							  ,patientRaceCode"
                              ,transactionSetCreationDateTime 
                              ,headerStandardRowNumber 
                              ,detailStandardRowNumber 
                              ,recordTypeCode 
                              ,recordTypeId 
                              ,fileRequestId 
                              ,createDateTime 
                              ,patientRedeterminationDate 
                              ,patientActiveFlag
"							  ,location"
"							  ,division"
"							  ,department"
"							  ,wageType"
"							  ,isFullTime"
"							  ,patientMedicareIndicatorCode"
"							  ,isTemporary) "
                       values (u.clientId 
                              ,u.enterprisePatientId 
                              ,u.patientPrimaryNumber 
                              ,u.patientPrimaryNumberQualifier 
                              ,u.enterpriseSubscriberId 
                              ,u.subscriberPrimaryNumber 
                              ,u.subscriberPrimaryNumberQualifier 
"							  ,u.ssn"
                              ,u.relationshipCode 
                              ,u.firstName 
                              ,u.lastName 
                              ,u.birthDate 
                              ,u.genderCode 
"							  ,u.raceCode"
                              ,u.transactionSetCreationDateTime 
                              ,u.stageId 
                              ,u.stageId 
                              ,u.recordTypeCode 
                              ,u.recordTypeId 
                              ,u.fileRequestId 
                              ,current_timestamp 
                              ,u.patientRedeterminationDate 
                              ,1
"							  ,u.location"
"							  ,u.division"
"							  ,u.department"
"							  ,u.wageType"
"							  ,u.isFullTime"
"							  ,u.patientMedicareIndicatorCode"
"							  ,u.isTemporary)						   "
"   when matched then update set m.patientPrimaryNumber			   = u.patientPrimaryNumber "
                               ,m.patientPrimaryNumberQualifier    = u.patientPrimaryNumberQualifier 
"                               ,m.enterpriseSubscriberId 		   = u.enterpriseSubscriberId "
"                               ,m.subscriberPrimaryNumber 		   = u.subscriberPrimaryNumber "
                               ,m.subscriberPrimaryNumberQualifier = u.subscriberPrimaryNumberQualifier 
"							   ,m.patientSsn 					   = u.ssn"
"                               ,m.relationshipCode 				   = u.relationshipCode "
"                               ,m.patientFirstName 				   = u.firstName "
"                               ,m.patientLastName 				   = u.lastName "
"                               ,m.patientBirthDate 				   = u.birthDate "
"                               ,m.patientGenderCode				   = u.genderCode "
"							   ,m.patientRaceCode				   = u.raceCode"
                               ,m.transactionSetCreationDateTime   = u.transactionSetCreationDateTime 
"                               ,m.headerStandardRowNumber 		   = u.stageId "
"                               ,m.detailStandardRowNumber 		   = u.stageId "
"                               ,m.recordTypeCode 				   = u.recordTypeCode "
"                               ,m.recordTypeId 					   = u.recordTypeId "
"                               ,m.fileRequestId 				   = u.fileRequestId "
"                               ,m.updateDateTime     			   = current_timestamp "
"                               ,m.patientRedeterminationDate 	   = u.patientRedeterminationDate"
"							   ,m.location						   = u.location"
"							   ,m.division						   = u.division"
"							   ,m.department					   = u.department"
"							   ,m.wageType						   = u.wageType"
"							   ,m.isFullTime					   = u.isFullTime"
"							   ,m.patientMedicareIndicatorCode     = u.patientMedicareIndicatorCode"
"							   ,m.isTemporary                      = u.isTemporary ;   	1	2019-03-13 09:22:47.7233333	mssql"
"32	0	MERGE_INTO_PatientAddressDim	merge into Patient.AddressDim m"
using (select *
         from (select m.clientId
"			          ,pd.patientId"
"			          ,rt.recordTypeId"
"			          ,12 as addressTypeId"
"			          ,'M' as addressTypeCode"
"			          ,g.geographyId addressGeoId"
"			          ,m.primaryAddressLine1 addressLine1"
"			          ,m.primaryAddressLine2 addressLine2"
"			          ,m.primaryCityName city"
"			          ,m.primaryStateCode state"
"			          ,m.primaryCountyCode county"
"			          ,left(m.primaryPostalZoneCode, 5) zip"
"			          ,m.fileRequestId fileRequestId"
"			          ,m.stageId"
"			          ,row_number() over(partition by m.clientId, m.enterprisePatientId order by isnull(left(m.primaryPostalZoneCode, 5), '99999')) rnk"
"		          from EdmStandard.Member m"
"		          join Reference.RecordType rt on rt.recordTypeCode = m.recordTypeCode"
"		          left join Reference.Geography g on g.geographyZipCode = left(m.primaryPostalZoneCode, 5)"
"		                                         and g.geographyDistinctLevel = 'ZIP'"
                 join Patient.PatientDim pd on m.clientId = pd.clientId
"		                                    and m.enterprisePatientId = pd.enterprisePatientId"
"											and pd.patientActiveFlag = 1"
"		         where m.fileRequestId = :fileRequestId"
"		           and ascii(ltrim(m.patientPrimaryNumber)) is not null) x"
        where rnk = 1) u
  on m.clientId = u.clientId
 and m.patientId = u.patientId
 and m.addressTypeId = u.addressTypeId
 and m.activeFlag = 1
 when not matched then 
 insert 
     (clientId
"	 ,patientId"
     ,recordTypeId
"	 ,addressTypeId"
"	 ,addressTypeCode"
"	 ,addressGeoId"
"	 ,addressLine1"
"	 ,addressLine2"
"	 ,city"
"	 ,state"
"	 ,county"
"	 ,zip"
"	 ,fileRequestId"
"	 ,stageId"
     ,addressCount
     ,activeFlag)
values 
     (u.clientId
"	 ,u.patientId"
     ,u.recordTypeId
     ,u.addressTypeId
     ,u.addressTypeCode
     ,u.addressGeoId
     ,u.addressLine1
     ,u.addressLine2
     ,u.city
     ,u.state
     ,u.county
     ,u.zip
     ,u.fileRequestId
     ,u.stageId
     ,1
"     ,1); 	1	2019-03-13 09:26:24.0200000	mssql"
"33	0	INSERT_Missing_EligibilityFact	merge into Patient.EligibilityFact m"
using (select x.clientId
             ,x.eligibilityFactId
             ,x.patientId
"	         ,x.enrollmentIdentifier"
"	         ,x.fileRequestId"
             ,x.memberSequenceNumber patientSequenceNumber
"	         ,x.groupPolicyId"
"	         ,x.groupPolicyEffectiveDate"
"	         ,x.groupPolicyExpirationDate"
"	         ,x.benefitPlanId"
             ,x.benefitPlanStartDate
"	         ,x.benefitPlanEndDate"
"	         ,x.recordTypeId"
"	         ,x.headerStandardRowNumber"
"	         ,x.detailStandardRowNumber"
"	         ,x.transactionSetCreationDateTime"
"	         ,x.eligibilityFactCount"
"	         ,x.eligibilityFactActiveFlag"
"	         ,x.policyIdentifier"
"			 ,x.maintenanceTypeId"
         from (select r.clientId
                     ,ef.eligibilityFactId
                     ,p.patientId
                     ,r.enrollmentIdentifier
                     ,r.fileRequestId
                     ,r.memberSequenceNumber
                     ,r.groupPolicyId
                     ,convert(datetime2, r.groupPolicyEffectiveDate, 111) groupPolicyEffectiveDate
                     ,convert(datetime2, r.groupPolicyExpirationDate, 111) groupPolicyExpirationDate
                     ,r.benefitPlanId
                     ,convert(datetime2, r.planBeginDate, 111) benefitPlanStartDate
                     ,case when try_convert(datetime2, r.planEndDate, 111) > dateadd(year, 2, getdate()) then null
                           else try_convert(datetime2, r.planEndDate, 111)
                      end benefitPlanEndDate
                     ,rt.recordTypeId
                     ,r.stageId headerStandardRowNumber
                     ,r.stageId detailStandardRowNumber
                     ,isnull(r.transactionSetCreationDateTime, getdate()) transactionSetCreationDateTime
                     ,1 eligibilityFactCount
                     ,1 eligibilityFactActiveFlag
"			         ,r.policyIdentifier"
"					 ,r.maintenanceTypeId"
                     ,rank() over(partition by r.clientId
                                              ,p.patientId
                                              ,r.enrollmentIdentifier
                                              ,r.fileRequestId
                                              ,r.groupPolicyId
                                              ,convert(datetime2, r.groupPolicyEffectiveDate, 111)
                                              ,r.benefitPlanId
                                              ,convert(datetime2, r.planBeginDate, 111)
                                              ,rt.recordTypeId
                                      order by r.fileRequestId, stageId desc) rnk
                 from EdmStandard.MemberReference r
                 join Patient.PatientDim p on r.enterprisePatientId = p.enterprisePatientId
                                          and r.ClientId = p.clientId
"										  and p.patientActiveFlag = 1"
                 join Reference.RecordType rt on rt.RecordTypeCode = 'MF'
                 left join Patient.EligibilityFact ef on r.clientId = ef.clientId
                                                     and p.patientId = ef.patientId
"													 and ef.eligibilityFactActiveFlag = 1"
                                                     and isnull(r.enrollmentIdentifier, '~') = isnull(ef.enrollmentIdentifier, '~')
"													 and r.groupPolicyId = ef.groupPolicyId"
                                                     and r.benefitPlanId = ef.benefitPlanId
                                                     and r.planBeginDate = ef.benefitPlanStartDate
            where r.fileRequestId = :fileRequestId
              and r.planBeginDate is not null) x 
      where x.rnk = 1) u
   on m.clientId= u.clientId
  and m.eligibilityFactId = u.eligibilityFactId
 when matched then update set m.groupPolicyExpirationDate = u.groupPolicyExpirationDate
                             ,m.benefitPlanEndDate = u.benefitPlanEndDate
"							 ,m.maintenanceTypeId = u.maintenanceTypeId"
 when not matched then insert (clientId
                              ,patientId
                              ,enrollmentIdentifier
                              ,fileRequestId
                              ,patientSequenceNumber
                              ,groupPolicyId
                              ,groupPolicyEffectiveDate
                              ,groupPolicyExpirationDate
                              ,benefitPlanId
                              ,benefitPlanStartDate
                              ,benefitPlanEndDate
                              ,recordTypeId
                              ,headerStandardRowNumber
                              ,detailStandardRowNumber
                              ,transactionSetCreationDateTime
                              ,eligibilityFactCount
                              ,eligibilityFactActiveFlag
"	                          ,policyIdentifier"
"							  ,maintenanceTypeId)"
"	                   values (u.clientId"
                              ,u.patientId
                              ,u.enrollmentIdentifier
                              ,u.fileRequestId
                              ,u.patientSequenceNumber
                              ,u.groupPolicyId
                              ,u.groupPolicyEffectiveDate
                              ,u.groupPolicyExpirationDate
                              ,u.benefitPlanId
                              ,u.benefitPlanStartDate
                              ,u.benefitPlanEndDate
                              ,u.recordTypeId
                              ,u.headerStandardRowNumber
                              ,u.detailStandardRowNumber
                              ,u.transactionSetCreationDateTime
                              ,u.eligibilityFactCount
                              ,u.eligibilityFactActiveFlag
"	                          ,u.policyIdentifier"
"							  ,u.maintenanceTypeId); 	1	2019-03-13 09:30:35.7800000	mssql"
"34	46	INSERT_MISSING_BiometricDim	insert into Patient.BiometricDim"
           (clientId 
           ,stageId 
           ,fileRequestId 
           ,recordTypeCode 
           ,patientId 
           ,patientPrimaryNumber 
           ,enterprisePatientId 
           ,firstName 
           ,middleName 
           ,lastName 
           ,dob 
           ,ssn 
           ,genderId 
           ,primaryPhoneNumber 
           ,secondaryPhoneNumber 
           ,emailAddress 
           ,eventDate 
           ,biometricQualifierId 
           ,biometricQualifierCode 
           ,biometricValueNormalized 
           ,biometricValueStr 
           ,notes 
           ,createDateTime 
           ,activeFlag)    
 select 46 clientId   
       ,min(b.stageId) stageId  
       ,min(b.fileRequestId) fileRequestId
       ,'BF' recordTypeCode   
       ,pd.patientId
       ,b.mbrID patientPrimaryNumber
       ,pd.enterprisePatientId
       ,min(b.firstName) firstName
"	   ,min(b.mi) middleName"
       ,min(b.lastName) lastName
"	   ,min(try_convert(datetime2, b.dob, 111)) dob"
       ,min(b.ssn) ssn
       ,min(g.genderId) genderId
"	   ,min(b.phone) phone"
"	   ,min(b.alternatePhoneNumber) alternatePhoneNumber"
"	   ,min(b.emailAddress) emailAddress"
"	   ,convert(datetime2, b.eventDate, 111) eventDate"
       ,bqc.biometricQualifierId
       ,bqc.biometricQualifierCode
       ,min(try_cast(b.<columnName> as decimal(10,4))) biometricValueNormalized
       ,b.<columnName> as biometricValueStr
       ,min(b.notes) notes
       ,getdate() createDateTime
       ,1 activeFlag
"	   from EdmStage.ERC_Biometric b"
"	   left join Reference.GenderCode g "
"	          on b.gender = g.genderCode"
"	   left join Patient.PatientDim pd "
"	          on b.mbrID = pd.patientPrimaryNumber         "
             and pd.clientId = 46
"	   join Reference.BiometricQualifierCode bqc "
"	     on (bqc.biometricQualifierCode = :biometricQualifierCode or bqc.biometricQualifierCode +'-'+ bqc.gender = :biometricQualifierCode)"
   left join Patient.BiometricDim bd 
          on 46 = bd.clientId
         and b.mbrID = bd.patientPrimaryNumber    
         and convert(datetime2, b.eventDate, 111) = bd.eventDate
         and bqc.biometricQualifierId = bd.biometricQualifierId
         and b.<columnName> = bd.biometricValueStr
  where isdate(b.eventDate) = 1
    and bd.biometricId is null
    and b.<columnName> is not null
    and (ascii(ltrim(:genderCode)) is null or b.gender = :genderCode)
  group by pd.patientId
          ,b.mbrID
"	      ,pd.enterprisePatientId"
"	      ,convert(datetime2, b.eventDate, 111)"
"	      ,bqc.biometricQualifierId "
          ,bqc.biometricQualifierCode
"	      ,b.<columnName> ;	1	2019-03-15 14:35:44.0600000	mssql"
"35	46	INSERT_BiometricStage	insert into EdmStage.ERC_Biometric"
       (fileRequestId
       ,stageId
       ,ssn
       ,lastName
       ,firstName
       ,mi
       ,dob
       ,gender
       ,phone
       ,eventDate
       ,height
       ,weight
       ,smokerResponse
       ,systolicValue
       ,diastolicValue
       ,hdl
       ,ldl
       ,totalCholesterol
       ,serumCotinineNicotine
       ,glucose
       ,waist
       ,triglycerides
       ,pulse
       ,mbrID
       ,alternatePhoneNumber
       ,emailAddress
       )
select :fileRequestId 
      ,row_number() over(partition by 1 order by mbrId) stageId 
      ,x1.* 
 from (select x.ssn 
             ,x.lastName 
             ,x.firstName 
             ,x.mi 
             ,x.dob 
             ,x.gender 
             ,x.phone 
             ,x.eventDate 
"             ,convert(varchar(10), max(case x.biometricQualifierCode when 'HGT' then x.biometricValueNormalized end)) height 	   "
             ,convert(varchar(10), max(case x.biometricQualifierCode when 'WGT' then x.biometricValueNormalized end)) weight  
             ,max(case x.biometricQualifierCode when 'SMK' then x.biometricValueStr end) smokerResponse 
             ,convert(varchar(10), max(case x.biometricQualifierCode when 'BP-SYS' then x.biometricValueNormalized end)) systolicValue 
             ,convert(varchar(10), max(case x.biometricQualifierCode when 'BP-DIA' then x.biometricValueNormalized end)) diastolicValue 
             ,convert(varchar(10), max(case when x.biometricQualifierCode like 'HDL%' then x.biometricValueNormalized end)) hdl 
             ,convert(varchar(10), max(case x.biometricQualifierCode when 'LDL' then x.biometricValueNormalized end)) ldl 
             ,convert(varchar(10), max(case x.biometricQualifierCode when 'TDL' then x.biometricValueNormalized end)) totalCholesterol 
             ,max(case x.biometricQualifierCode when 'SCN' then x.biometricValueStr end) serumCotinineNicotine 
             ,convert(varchar(10), max(case x.biometricQualifierCode when 'FG' then x.biometricValueNormalized end)) glucose 
             ,convert(varchar(10), max(case x.biometricQualifierCode when 'WST' then x.biometricValueNormalized end)) waist 
             ,convert(varchar(10), max(case x.biometricQualifierCode when 'TG' then x.biometricValueNormalized end)) triglycerides 
             ,convert(varchar(10), max(case x.biometricQualifierCode when 'PUL' then x.biometricValueStr end)) pulse 
             ,x.mbrID 
             ,x.alternatePhoneNumber 
             ,x.emailAddress 
         from (select b.ssn 
                     ,b.lastName 
                     ,b.firstName 
                     ,b.middleName mi 
                     ,replace(convert(varchar(10), b.dob, 111), '/', '') dob 
                     ,g.genderCode gender 
                     ,b.primaryPhoneNumber phone 
                     ,replace(convert(varchar(10), b.eventDate, 111), '/', '') eventDate 
                     ,bqc.biometricQualifierCode  
                     ,b.biometricValueNormalized 
                     ,b.biometricValueStr 
                     ,b.patientPrimaryNumber mbrID 
                     ,b.secondaryPhoneNumber alternatePhoneNumber 
                     ,b.emailAddress 
                     ,rank() over(partition by b.clientId, b.patientPrimaryNumber, b.biometricQualifierId order by b.eventDate desc, b.createDateTime desc, b.biometricId desc) rnk 
                 from Patient.BiometricDim b 
                 join Reference.BiometricQualifierCode bqc on b.biometricQualifierId = bqc.biometricQualifierId 
                 join Reference.GenderCode g on b.genderId = g.genderId) x 
        where x.rnk = 1 
        group by x.ssn 
                ,x.lastName 
                ,x.firstName 
                ,x.mi 
                ,x.dob 
                ,x.gender 
                ,x.phone 
                ,x.eventDate 
                ,x.mbrID 
                ,x.alternatePhoneNumber 
"                ,x.emailAddress) x1;	1	2019-03-15 14:38:00.2766667	mssql"
"36	69	MERGE_ProviderDim_FullName	merge into Provider.ProviderDim m"
using (select pd.clientId
             ,pd.providerId
"       	     ,s.prov_sort_name"
         from EdmStage.Montana_Provider s
         join Provider.ProviderDim pd on s.prov_number = pd.providerPrimaryNumber
                                     and pd.clientId = 69
"       							     and pd.providerActiveFlag = 1"
        where pd.providerFullName is null) u
   on m.clientId = u.clientId
  and m.providerId = u.providerId
" when matched then update set m.providerFullName = u.prov_sort_name;	1	2019-04-03 08:42:43.5466667	mssql"
"37	52	UPDATE_MemberId	with updateMemberIds as "
     (select stageId
            ,fileRequestId
            ,recType
            ,mctCar
            ,subCar
            ,policyNumber
            ,right('00' + cast(useMemberId + case when isNew = 1 then rank() over(partition by enterpriseSubscriberId order by isNew desc) else 0 end as varchar(2)), 2) memberId
            ,oadFlag
            ,lastName
            ,filler1
            ,firstName
            ,filler2
            ,middleInitial
            ,addressLine1
            ,filler3
            ,city
            ,state
            ,zip
            ,zipExt
            ,phone
            ,birthDate
            ,gender
            ,eligStartDate
            ,eligEndDate
            ,filler4
            ,relation
"            ,ssn	  "
        from (select stageId
                    ,fileRequestId
                    ,recType
                    ,mctCar
                    ,subCar
                    ,policyNumber
                    ,memberId
                    ,oadFlag
                    ,lastName
                    ,filler1
                    ,firstName
                    ,filler2
                    ,middleInitial
                    ,addressLine1
                    ,filler3
                    ,city
                    ,state
                    ,zip
                    ,zipExt
                    ,phone
                    ,birthDate
                    ,gender
                    ,eligStartDate
                    ,eligEndDate
                    ,filler4
                    ,relation
                    ,ssn
"			        --"
"	                --,newMemberId"
"	                --,lastMemberId"
"	                --,clientId"
"	                ,enterpriseSubscriberId"
"	                ,case when max(isSame) = 1 then max(case when firstName = patientFirstName then currMemberId end)"
"	                      when max(isNew) = 1 then max(lastMemberId)"
"	                 end useMemberId"
"	                ,case when max(isSame) = 1 then 0"
"	                      when max(isNew) = 1 then 1"
"		              	else 0"
"	                 end isNew"
                from (select m.stageId
                            ,m.fileRequestId
                            ,m.recType
                            ,m.mctCar
                            ,m.subCar
                            ,m.policyNumber
                            ,m.memberId
                            ,m.oadFlag
                            ,m.lastName
                            ,m.filler1
                            ,m.firstName
                            ,m.filler2
                            ,m.middleInitial
                            ,m.addressLine1
                            ,m.filler3
                            ,m.city
                            ,m.state
                            ,m.zip
                            ,m.zipExt
                            ,m.phone
                            ,m.birthDate
                            ,m.gender
                            ,m.eligStartDate
                            ,m.eligEndDate
                            ,m.filler4
                            ,m.relation
                            ,m.ssn
"					         --"
"	                        ,s.patientFirstName"
"	                        ,convert(datetime2, m.birthDate, 101) birthDateNormalized"
"			                ,s.patientBirthDate"
"			                ,m.memberId newMemberId"
"			                ,substring(s.enterprisePatientId, 4, 2) currMemberId"
                            ,s.clientId
"	                        ,s.patientId"
"	                        ,s.enterprisePatientId enterpriseId"
"			                ,s.enterpriseSubscriberId"
"	                        ,case when m.memberId <> '00'"
"			                       and (rtrim(m.memberId) = substring(s.enterprisePatientId, 4, 2)) "
"	                               and (upper(ltrim(rtrim(m.firstName))) <> s.patientFirstName)"
"	                              then 1 else 0 "
"	                          end isNew"
"			                 ,case when (upper(ltrim(rtrim(m.firstName))) = s.patientFirstName)"
"			                        and convert(datetime2, m.birthDate, 101) = s.patientBirthDate"
"	                               then 1 else 0 "
"	                          end isSame"
"			                 ,max(substring(s.enterprisePatientId, 4, 2)) over(partition by s.enterpriseSubscriberId) lastMemberId"
                         from EdmStage.CTC_Member m
                         join Patient.PatientDim s on 'CTC00' + m.policyNumber = s.enterpriseSubscriberId
"						                          and s.clientId = 52) x"
                        where -- neither are subscriber
                              ((newMemberId <> '00' and currMemberId <> '00')
"					          -- both are subscriber"
                           or (newMemberId = '00' and currMemberId = '00'))
"					      and fileRequestId = :fileRequestId	"
                        group by stageId
                                ,fileRequestId
                                ,recType
                                ,mctCar
                                ,subCar
                                ,policyNumber
                                ,memberId
                                ,oadFlag
                                ,lastName
                                ,filler1
                                ,firstName
                                ,filler2
                                ,middleInitial
                                ,addressLine1
                                ,filler3
                                ,city
                                ,state
                                ,zip
                                ,zipExt
                                ,phone
                                ,birthDate
                                ,gender
                                ,eligStartDate
                                ,eligEndDate
                                ,filler4
                                ,relation
                                ,ssn
"                        	    ,newMemberId"
"                        	    ,lastMemberId"
"                        	    ,clientId"
"                        	    ,enterpriseSubscriberId) x1)"
merge into EdmStage.CTC_Member m
using updateMemberIds u 
   on u.stageId = m.stageId
  and u.memberId is NOT null
" when matched then update set m.memberId = u.memberId; 	1	2019-04-15 09:35:50.0433333	mssql"
"38	52	MERGE_SubscriberPrimaryNumber	with subscriber as"
     (select stageId, policyNumber, birthDate, firstName
"	    from EdmStage.CTC_Member"
"	   where relation = '1'"
        and fileRequestId = :fileRequestId
"		and addressLine1 is not null -- exclude ""retired"" subscribers"
"		),"
     dependnt as 
"	 (select *"
"	    from EdmStage.CTC_Member"
"	   where relation <> '1' "
"		 and fileRequestId = :fileRequestId), "
     linked as 
"	 (select stageId, policyNumber + birthDate + substring(upper(firstName), 1, 4) subscriberPrimaryNumber"
         from subscriber
      union all
     select d.stageId, s.policyNumber + s.birthDate + substring(upper(s.firstName), 1, 4) subscriberPrimaryNumber
       from subscriber s
       join dependnt d on s.policyNumber = d.policyNumber),
     d_linked as 
     (select distinct * from linked)
merge into EdmStage.CTC_Member m
using d_linked u
   on m.stageId = u.stageId
  and m.subscriberPrimaryNumber is null
" when matched then update set m.subscriberPrimaryNumber = u.subscriberPrimaryNumber; 	1	2019-04-15 09:39:20.6733333	mssql"
"39	52	RETIRE_Missing_Members	insert into EdmStage.CTC_Member "
       (stageId
"	   ,fileRequestId"
"	   ,policyNumber"
"	   ,memberId"
"	   ,lastName"
"	   ,firstName"
"	   ,birthDate"
"	   ,gender"
"	   ,eligStartDate"
"	   ,eligEndDate"
"	   ,relation"
"	   ,subscriberPrimaryNumber)"
select stage.maxStageId + row_number() over(partition by 1 order by pd.patientId) stageId
      ,:fileRequestId fileRequestId
      ,substring(pd.patientPrimaryNumber, 1, 12) policyNumber
      ,right(pd.enterprisePatientId, 2) memberId
"	  ,left(pd.patientLastName, 19) lastName"
"	  ,left(pd.patientFirstName, 10) firstName"
"	  ,convert(varchar(8), pd.patientBirthDate, 112) birthDate"
"	  ,left(pd.patientGenderCode, 1) gender"
      ,convert(varchar(8), e.benefitPlanStartDate, 112) eligStartDate
"	  ,convert(varchar(8), dateadd(day, -1, convert(date, cast(year(current_timestamp) as varchar(4)) + case when len(month(current_timestamp)) = 1 then '0' else '' end + cast(month(current_timestamp) as varchar(2)) + '01', 112)), 112) eligEndDate"
"	  ,left(rel.inValue, 1) relation"
"	  ,pd.subscriberPrimaryNumber"
  from Patient.PatientDim pd
  cross apply (select max(stageId) maxStageId from EdmStage.CTC_Member) stage
  left join EdmStage.CTC_Member s on pd.patientPrimaryNumber = s.policyNumber + s.birthDate + left(s.firstName, 4)
                                 and pd.patientLastName = s.lastName
"								   and pd.patientFirstName = s.firstName"
"								   and pd.patientBirthDate = convert(datetime2, s.birthDate, 121)"
  join Patient.EligibilityFact e on pd.ClientId = e.ClientId
"			                    and pd.PatientId = e.PatientId"
"								and e.eligibilityFactActiveFlag = 1"
"								and (e.benefitPlanEndDate is null"
"								  or e.benefitPlanEndDate > current_timestamp)"
  left join EdmLib.Mapping rel on rel.name = 'CTC_RELATION_CODE'
                              and pd.relationshipCode = rel.outValue
 where pd.clientId = 52
"   and s.stageId is null;	1	2019-04-15 09:40:51.9400000	mssql"
"40	61	INSERT_NEW_MEMBERS	insert into Patient.PatientDim "
(enterprisePatientId 
,patientPrimaryNumber 
,patientPrimaryNumberQualifier 
,patientSsn 
,patientFirstName 
,patientLastName 
,patientBirthDate 
,patientGenderCode 
,transactionSetCreationDateTime 
,headerStandardRowNumber 
,detailStandardRowNumber 
,fileRequestId 
,createDateTime 
,patientActiveFlag 
,clientId 
,relationshipCode) 
select c.ClientCode + right('0000000000' + cast(next value for EdmStage.Local711_MemberPrimaryNumberSeq as varchar(32)), 10) enterprisePatientId 
"	  ,s.idNumber + s.memberCount patientPrimaryNumber "
"	  ,'MI' patientPrimaryNumberQualifier "
"	  ,s.memberSSN patientSsn "
"	  ,s.firstName patientFirstName "
"	  ,s.lastName patientLastName "
"	  ,try_convert(datetime2, s.dateOfBirth, 112) patientBirthDate "
"	  ,gender patientGenderCode "
"	  ,CURRENT_TIMESTAMP transactionSetCreationDateTime "
"	  ,min(s.stageId) headerStandardRowNumber "
"	  ,min(s.stageId) detailStandardRowNumber "
"	  ,:fileRequestId fileRequestId "
"	  ,CURRENT_TIMESTAMP createDateTime "
"	  ,1 patientActiveFlag "
"	  ,c.clientId "
"	  ,m.outValue relationshipCode "
 from <stageTableName> s 
 left join EdmLib.Mapping m on m.name = 'Local711_RELATIONSHIP_CODE' 
                      and s.memberRelationshipCode = m.inValue 
 left join Reference.Client c on c.clientId = :clientId 
 left join Patient.PatientDim pd on pd.ClientId = :clientId 
                                and isnull(s.firstName, '~') = isnull(pd.patientFirstName, '~') 
                                and isnull(s.lastName, '~') = isnull(pd.patientLastName, '~')
                                and isnull(s.gender, '~') = isnull(pd.patientGenderCode, '~') 
                                and isnull(s.memberSSN, '~') = isnull(pd.patientSsn, '~')
                                and m.outValue = pd.relationshipCode 
                                and (try_convert(datetime2, s.dateOfBirth, 112) = pd.patientBirthDate 
                                  or (try_convert(datetime2, s.dateOfBirth, 112) is null 
                                  and pd.patientBirthDate is null)) 
where pd.patientId is null 
group by s.idNumber
        ,s.memberCount
        ,s.memberSSN 
        ,s.dateOfBirth 
"		,s.firstName "
"		,c.clientCode "
"		,s.lastName "
"		,s.gender "
"		,c.clientId "
"	    ,m.outValue; 	1	2019-04-25 09:11:50.9033333	mssql"
"41	61	MERGE_PRIMARY_NUMBERS_BACK_INTO_STAGE	"
merge into <stageTableName> m
using (select s.stageId
"	         ,min(right(p.enterprisePatientId, 10)) enterprisePatientId"
         from <stageTableName> s
         join EdmLib.Mapping m on m.name = 'Local711_RELATIONSHIP_CODE'
"                              and s.memberRelationshipCode = m.inValue			 "
         join Patient.PatientDim p on p.clientId = 61
"								  and p.patientActiveFlag = 1"
"								  and isnull(s.firstName, '~') = isnull(p.patientFirstName, '~')"
                                  and isnull(s.lastName, '~') = isnull(p.patientLastName, '~')
                                  and isnull(s.gender, '~') = isnull(p.patientGenderCode, '~')
                                  and isnull(s.memberSsn, '~') = isnull(p.patientSsn, '~') --really ssn
                                  and m.outValue = p.relationshipCode
                                  and (try_convert(datetime2, s.dateOfBirth, 112) = p.patientBirthDate
                                     or (try_convert(datetime2, s.dateOfBirth, 112) is null
                                     and p.patientBirthDate is null))
"	    where p.ClientId = :clientId"
          and s.fileRequestId = :fileRequestId
"		  and s.patientPrimaryNumber is null"
        group by s.stageId) u
   on m.stageId = u.stageId
 when matched then update
"  set m.patientPrimaryNumber = u.enterprisePatientId; 	1	2019-04-25 09:32:53.4533333	mssql"
"42	61	UPDATE_SUSCRIBER_PRIMARY_NUMBER	update <stageTableName>"
   set subscriberPrimaryNumber = patientPrimaryNumber
 where fileRequestId = :fileRequestId
   and :clientId is not null
"   and idNumber = memberSsn; 	1	2019-04-25 09:34:06.9333333	mssql"
"43	61	UPDATE_DEPENDENT_SUBSCRIBER_PRIMARY_NUMBER	with subscribers as"
     (select idNumber 
            ,patientPrimaryNumber 
        from <stageTableName> 
"	   where idNumber = memberSsn"
         and fileRequestId = :fileRequestId
"		 ),"
"	 dependents as "
"	 (select dep.stageId"
            ,sub.patientPrimaryNumber subscriberPrimaryNumber
        from subscribers sub
        join <stageTableName> dep on sub.idNumber = dep.idNumber
                                         and dep.idNumber <> dep.memberSSN)
merge into <stageTableName> m 
using (select stageId
             ,max(subscriberPrimaryNumber) subscriberPrimaryNumber
"		 from (select stageId"
                     ,subscriberPrimaryNumber
                 from dependents
                union all
               select m.stageId
                     ,right(pd.enterprisePatientId, 10) subscriberPrimaryNumber
                 from <stageTableName> m
                 left join dependents d on m.stageId = d.stageId
                 join Patient.PatientDim pd on m.idNumber + '00' = pd.patientPrimaryNumber
                                           and pd.clientId = :clientId
                where d.stageId is null) x
"		group by stageId) u"
   on m.stageId = u.stageId
" when matched then update set m.subscriberPrimaryNumber = u.subscriberPrimaryNumber; 	1	2019-04-25 09:44:59.6933333	mssql"
"44	67	INSERT_NEW_MEMBERS	insert into Patient.PatientDim"
      (enterprisePatientId
      ,patientPrimaryNumber
      ,patientPrimaryNumberQualifier
      ,patientSsn
      ,patientFirstName
      ,patientLastName
      ,patientBirthDate
      ,patientGenderCode
      ,transactionSetCreationDateTime
      ,headerStandardRowNumber
      ,detailStandardRowNumber
      ,fileRequestId
      ,createDateTime
      ,patientActiveFlag
      ,clientId
      ,relationshipCode)
select c.ClientCode + right('0000000000' + cast(next value for EdmStage.MALMemberPrimaryNumberSeq as varchar(32)), 10) 
"	   ,right('0000000000' + cast(next value for EdmStage.MALMemberPrimaryNumberSeq as varchar(32)), 10)"
"	   ,'MI'"
"	   ,s.memberId"
"	   ,s.memberFirstName"
"	   ,s.memberLastName"
"	   ,try_convert(datetime2, s.memberDob, 112)"
"	   ,memberGender"
"	   ,CURRENT_TIMESTAMP"
"	   ,min(s.stageId)"
"	   ,min(s.stageId)"
"	   ,:fileRequestId"
"	   ,CURRENT_TIMESTAMP"
"	   ,1"
"	   ,c.clientid"
"	   ,case when s.relationshipCode = '00' then '18'"
"			when s.relationshipCode = '01' then '01'"
"			when s.relationshipCode = '02' then '19'"
"		end "
  from EdmStage.MAL_Member s
  join EdmLib.Mapping m on m.name = 'MAL_RELATIONSHIP_CODE'
                       and s.relationshipCode = m.inValue
  join Reference.Client c on c.clientId = :clientId
  left join Patient.PatientDim pd on pd.ClientId = :clientId
                                 and isnull(s.memberFirstName, '~') = isnull(pd.patientFirstName, '~')
                                 and isnull(s.memberGender, '~') = isnull(pd.patientGenderCode, '~')
                                 and s.memberId = pd.patientSsn --really ssn
                                 and m.outValue = pd.relationshipCode
                                 and (try_convert(datetime2, s.memberDob, 112) = pd.patientBirthDate
                                    or (try_convert(datetime2, s.memberDob, 112) is null
                                    and pd.patientBirthDate is null))
where pd.patientId is null
   and ascii(ltrim(s.memberId)) is not null
 group by s.memberId
         ,s.memberDob
"		 ,s.memberFirstName"
"		 ,c.clientCode"
"		,s.memberLastName"
"		,s.memberGender"
"		,c.clientId"
"		,s.relationshipCode;	1	2019-04-26 19:54:18.6600000	mssql"
"45	67	MERGE_PRIMARY_NUMBERS_BACK_INTO_STAGE	declare @clientId int = :clientId ;"
declare @fileRequestId bigint = :fileRequestId ;

drop table if exists ##mal_member_temp
select p.*
      ,m.inValue 
  into ##mal_member_temp
  from Patient.PatientDim p
  join EdmLib.Mapping m on m.name = 'MAL_RELATIONSHIP_CODE'
                       and p.relationshipCode = m.outValue
 where p.clientId = @clientId
   and p.patientActiveFlag = 1 ;

drop table if exists ##mal_member_stage ;
select u.clientId
      ,m.fileRequestId
"	  ,m.stageId"
"	  ,m.memberGender"
"	  ,m.memberId"
"	  ,m.memberDob"
"	  ,m.relationshipCode"
"	  ,string_agg(m.mpiId, ',') mpiIdList"
"	  ,min(u.patientPrimaryNumber) currPatientPrimaryNumber"
"	  ,m.patientPrimaryNumber"
  into ##mal_member_stage
  from EdmStage.MAL_Member m
  left join ##mal_member_temp u on isnull(m.memberFirstName, '~') = isnull(u.patientFirstName, '~')
                          and isnull(m.memberLastName, '~') = isnull(u.patientLastName, '~')
                          and isnull(m.memberGender, '~') = isnull(u.patientGenderCode, '~')
                          and m.memberId = u.patientSsn --really ssn
                          and m.relationshipCode = u.inValue
                          and (try_convert(datetime2, m.memberDob, 112) = u.patientBirthDate
                             or (try_convert(datetime2, m.memberDob, 112) is null
                             and u.patientBirthDate is null))
  where m.fileRequestId = @fileRequestId
  group by u.clientId
          ,m.fileRequestId
          ,m.stageId
"		  ,m.memberGender"
"		  ,m.memberId"
"	      ,m.memberDob"
"		  ,m.relationshipCode"
"	      ,m.patientPrimaryNumber ;"

if (select count(*)
      from edmLib.fileRequest f
      join ##mal_member_stage s on f.fileRequestId = s.fileRequestId 
                               and s.stageId <= f.clientModelRecordCount
     where isnull(s.patientPrimaryNumber, s.currPatientPrimaryNumber) is null
       and f.fileRequestId = @fileRequestId) > 0
begin

"	merge into ##mal_member_stage m"
"	using (select m.stageId"
"	             ,max(u.patientPrimaryNumber) patientPrimaryNumber"
"				 ,count(*) patientCount"
"				 ,string_agg(u.patientPrimaryNumber, ',') patientNumberList"
"				 ,string_agg(u.patientFirstName, ',') patientFirstNameList"
"				 ,string_agg(u.patientLastName, ',') patientLastNameList"
"	         from ##mal_member_stage m"
             left join ##mal_member_temp u on isnull(m.memberGender, '~') = isnull(u.patientGenderCode, '~')
                                          and m.memberId = u.patientSsn --really ssn
                                          and m.relationshipCode = u.inValue
                                          and (try_convert(datetime2, m.memberDob, 112) = u.patientBirthDate
                                             or (try_convert(datetime2, m.memberDob, 112) is null
                                             and u.patientBirthDate is null))
"	        where isnull(m.patientPrimaryNumber, m.currPatientPrimaryNumber) is null"
"			group by m.stageId"
"		   having count(*) = 1 or"
"			     (count(*) > 1 and count(distinct patientLastName) = 1)) u"
"	  on m.stageId = u.stageId"
"	  when matched then update set m.patientPrimaryNumber = u.patientPrimaryNumber;"

"	  if (select count(*)"
            from edmLib.fileRequest f
            join ##mal_member_stage s on f.fileRequestId = s.fileRequestId 
                                     and s.stageId <= f.clientModelRecordCount
           where isnull(s.patientPrimaryNumber, s.currPatientPrimaryNumber) is null
             and f.fileRequestId = @fileRequestId) > 0
"	  throw 51000, 'Invalid patientPrimaryNumber', 16 ;"
end ;

/*
select s.* --count(*)
  from edmLib.fileRequest f
  join ##mal_member_stage s on f.fileRequestId = s.fileRequestId 
                           and s.stageId <= f.clientModelRecordCount
 where isnull(s.patientPrimaryNumber, s.currPatientPrimaryNumber) is null
   and f.fileRequestId = 83028  --@fileRequestId
 order by stageId ;


select *
  from Patient.PatientDim
 where clientId = 67
   and patientLastName = 'DE SENA'
   and patientSsn = '658684156'
   and patientBirthDate = '1979-07-30 00:00:00' ;

select *
  from ##mal_member_stage
 where stageId = 1 ;

select d.*
  from MPI.PatientLink l 
  join MPI.PatientDetail d on l.detailId = d.detailId
                          and l.clientIdentifier = d.clientIdentifier
 where l.ClientIdentifier = 'MAL'
   and l.mpiid = 'MPI000000000502312' ;

select *
  from Patient.PatientDim
 where clientId = 67
   and patientPrimaryNumber in ('0000026532', '0000027610') ;

*/

merge into EdmStage.MAL_Member m
using (select *
         from ##mal_member_stage u
        where (patientPrimaryNumber is null
          or isnull(u.patientPrimaryNumber, currPatientPrimaryNumber) is not null)) u
   on m.stageId = u.stageId
" when matched then update set m.patientPrimaryNumber = isnull(u.patientPrimaryNumber, currPatientPrimaryNumber); 	1	2019-04-26 19:56:26.3800000	mssql"
"46	67	UPDATE_SUBSCRIBER_PRIMARY_NUMBERS	merge into EdmStage.MAL_Member m"
using (select stageId
             ,min(subscriberPrimaryNumber) subscriberPrimaryNumber
         from (select d.stageId
"		             ,s.patientPrimaryNumber subscriberPrimaryNumber"
                 from EdmStage.MAL_Member d
                 join EdmStage.MAL_Member s on d.employeeSSN + '00' = s.memberSSN
                                           and s.relationshipCode = '00'
                where d.relationshipCode <> '00'
                  and d.fileRequestId = :fileRequestId
                union all
               select s.stageId
"			         ,s.patientPrimaryNumber"
                 from EdmStage.MAL_Member s
                where s.relationshipCode = '00'
                union all
               select d.stageId
"			         ,s.patientPrimaryNumber subscriberPrimaryNumber"
                 from EdmStage.MAL_Member d
                 join EdmStage.MAL_Member s on d.memberId = s.memberId
                                           and d.patientPrimaryNumber <> s.patientPrimaryNumber
"							               and s.relationshipCode = '00'"
                where d.employeeSSN is null
                  and d.relationshipCode <> '00') x
        group by stageId) u
   on m.stageId = u.stageId
" when matched then update set m.subscriberPrimaryNumber = u.subscriberPrimaryNumber; 	1	2019-04-26 19:57:17.7700000	mssql"
"47	69	INSERT_Elig_TPL	insert into EdmStage.Montana_MemberStage"
      (rowNumber
      ,fileRequestId
      ,original_recip_id
"	  ,ssn_first_8"
"	  ,ssn_last_char"
"	  ,teams_id_num"
"	  ,recip_name"
"	  ,recip_ssn"
"	  ,recip_date_of_birth"
"	  ,recip_date_of_death"
"	  ,medicareIndicatorCode"
"	  ,recip_sex_code"
"	  ,recip_area_code"
"	  ,recip_phone_num"
"	  ,recip_addr_line_1"
"	  ,recip_addr_line_2"
"	  ,countyCode"
"	  ,recip_city"
"	  ,recip_state"
"	  ,recip_zip_code"
"	  ,planNumber"
      ,eligBeginDate
      ,eligEndDate
      ,eligAdded
      ,eligLastUpdated)
select stageId rowNumber
      ,:fileRequestId
      ,original_recip_id
"	  ,ssn_first_8"
"	  ,ssn_last_char"
"	  ,teams_id_num"
"	  ,recip_name"
"	  ,recip_ssn"
"	  ,recip_date_of_birth"
"	  ,recip_date_of_death"
"	  ,case when prt_a_elig_end_date_01 = '99999999' and prt_b_elig_end_date_01 = '99999999' then 'C'"
"	        when prt_a_elig_end_date_01 = '99999999' then 'A'"
"			when prt_b_elig_end_date_01 = '99999999' then 'B'"
"			else 'N'"
"	   end medicareIndicatorCode"
"	  ,recip_sex_code"
"	  ,recip_area_code"
"	  ,recip_phone_num"
"	  ,recip_addr_line_1"
"	  ,recip_addr_line_2"
"	  ,null countyCode"
"	  ,recip_city"
"	  ,recip_state"
"	  ,recip_zip_code"
"	  ,'TPL_' + tpl_data_<i>_tpl_status_ind planNumber"
      ,tpl_data_<i>_cov_begin_date eligBeginDate
      ,tpl_data_<i>_cov_end_date eligEndDate
      ,null eligAdded
      ,null eligLastUpdt
  from EdmStage.Montana_Member
" where tpl_data_<i>_cov_end_date <> '00000000'; 	1	2019-05-03 10:51:50.0133333	mssql"
"48	69	INSERT_Elig_QMB	insert into EdmStage.Montana_MemberStage"
      (rowNumber
      ,fileRequestId
      ,original_recip_id
"	  ,ssn_first_8"
"	  ,ssn_last_char"
"	  ,teams_id_num"
"	  ,recip_name"
"	  ,recip_ssn"
"	  ,recip_date_of_birth"
"	  ,recip_date_of_death"
"	  ,medicareIndicatorCode"
"	  ,recip_sex_code"
"	  ,recip_area_code"
"	  ,recip_phone_num"
"	  ,recip_addr_line_1"
"	  ,recip_addr_line_2"
"	  ,countyCode"
"	  ,recip_city"
"	  ,recip_state"
"	  ,recip_zip_code"
"	  ,planNumber"
      ,eligBeginDate
      ,eligEndDate
      ,eligAdded
      ,eligLastUpdated)
select stageId rowNumber
      ,:fileRequestId
      ,original_recip_id
"	  ,ssn_first_8"
"	  ,ssn_last_char"
"	  ,teams_id_num"
"	  ,recip_name"
"	  ,recip_ssn"
"	  ,recip_date_of_birth"
"	  ,recip_date_of_death"
"	  ,case when prt_a_elig_end_date_01 = '99999999' and prt_b_elig_end_date_01 = '99999999' then 'C'"
"	        when prt_a_elig_end_date_01 = '99999999' then 'A'"
"			when prt_b_elig_end_date_01 = '99999999' then 'B'"
"			else 'N'"
"	   end medicareIndicatorCode"
"	  ,recip_sex_code"
"	  ,recip_area_code"
"	  ,recip_phone_num"
"	  ,recip_addr_line_1"
"	  ,recip_addr_line_2"
"	  ,null countyCode"
"	  ,recip_city"
"	  ,recip_state"
"	  ,recip_zip_code"
"	  ,'QMB' planNumber"
      ,qmb_elig_beg_date_0<i> eligBeginDate
      ,qmb_elig_end_date_0<i> eligEndDate
      ,null eligAdded
      ,null eligLastUpdt
  from EdmStage.Montana_Member
" where qmb_elig_end_date_0<i> <> '00000000'; 	1	2019-05-03 10:51:50.0166667	mssql"
"49	69	INSERT_Elig_ManagedCare	insert into EdmStage.Montana_MemberStage"
      (rowNumber
      ,fileRequestId
      ,original_recip_id
"	  ,ssn_first_8"
"	  ,ssn_last_char"
"	  ,teams_id_num"
"	  ,recip_name"
"	  ,recip_ssn"
"	  ,recip_date_of_birth"
"	  ,recip_date_of_death"
"	  ,medicareIndicatorCode"
"	  ,recip_sex_code"
"	  ,recip_area_code"
"	  ,recip_phone_num"
"	  ,recip_addr_line_1"
"	  ,recip_addr_line_2"
"	  ,countyCode"
"	  ,recip_city"
"	  ,recip_state"
"	  ,recip_zip_code"
"	  ,planNumber"
      ,eligBeginDate
      ,eligEndDate
      ,eligAdded
      ,eligLastUpdated)
select stageId rowNumber
      ,:fileRequestId
      ,original_recip_id
"	  ,ssn_first_8"
"	  ,ssn_last_char"
"	  ,teams_id_num"
"	  ,recip_name"
"	  ,recip_ssn"
"	  ,recip_date_of_birth"
"	  ,recip_date_of_death"
"	  ,case when prt_a_elig_end_date_01 = '99999999' and prt_b_elig_end_date_01 = '99999999' then 'C'"
"	        when prt_a_elig_end_date_01 = '99999999' then 'A'"
"			when prt_b_elig_end_date_01 = '99999999' then 'B'"
"			else 'N'"
"	   end medicareIndicatorCode"
"	  ,recip_sex_code"
"	  ,recip_area_code"
"	  ,recip_phone_num"
"	  ,recip_addr_line_1"
"	  ,recip_addr_line_2"
"	  ,null countyCode"
"	  ,recip_city"
"	  ,recip_state"
"	  ,recip_zip_code"
"	  ,'MNGD_' + mngd_care_ind_<i> planNumber"
      ,mngd_care_begin_date_<i> eligBeginDate
      ,mngd_care_end_date_<i> eligEndDate
      ,null eligAdded
      ,null eligLastUpdt
  from EdmStage.Montana_Member
" where mngd_care_end_date_<i> <> '00000000'; 	1	2019-05-03 10:51:50.0166667	mssql"
"50	69	INSERT_Elig_Hospice	insert into EdmStage.Montana_MemberStage"
      (rowNumber
      ,fileRequestId
      ,original_recip_id
"	  ,ssn_first_8"
"	  ,ssn_last_char"
"	  ,teams_id_num"
"	  ,recip_name"
"	  ,recip_ssn"
"	  ,recip_date_of_birth"
"	  ,recip_date_of_death"
"	  ,medicareIndicatorCode"
"	  ,recip_sex_code"
"	  ,recip_area_code"
"	  ,recip_phone_num"
"	  ,recip_addr_line_1"
"	  ,recip_addr_line_2"
"	  ,countyCode"
"	  ,recip_city"
"	  ,recip_state"
"	  ,recip_zip_code"
"	  ,planNumber"
      ,eligBeginDate
      ,eligEndDate
      ,eligAdded
      ,eligLastUpdated)
select stageId rowNumber
      ,:fileRequestId
      ,original_recip_id
"	  ,ssn_first_8"
"	  ,ssn_last_char"
"	  ,teams_id_num"
"	  ,recip_name"
"	  ,recip_ssn"
"	  ,recip_date_of_birth"
"	  ,recip_date_of_death"
"	  ,case when prt_a_elig_end_date_01 = '99999999' and prt_b_elig_end_date_01 = '99999999' then 'C'"
"	        when prt_a_elig_end_date_01 = '99999999' then 'A'"
"			when prt_b_elig_end_date_01 = '99999999' then 'B'"
"			else 'N'"
"	   end medicareIndicatorCode"
"	  ,recip_sex_code"
"	  ,recip_area_code"
"	  ,recip_phone_num"
"	  ,recip_addr_line_1"
"	  ,recip_addr_line_2"
"	  ,null countyCode"
"	  ,recip_city"
"	  ,recip_state"
"	  ,recip_zip_code"
"	  ,'HOSPICE' planNumber"
      ,hospice_begin_date_<i> eligBeginDate
      ,hospice_end_date_<i> eligEndDate
      ,null eligAdded
      ,null eligLastUpdt
  from EdmStage.Montana_Member
" where hospice_begin_date_<i> <> '00000000'; 	1	2019-05-03 10:51:50.0166667	mssql"
"51	69	INSERT_Elig_Pharmacy	insert into EdmStage.Montana_MemberStage"
      (rowNumber
      ,fileRequestId
      ,original_recip_id
"	  ,ssn_first_8"
"	  ,ssn_last_char"
"	  ,teams_id_num"
"	  ,recip_name"
"	  ,recip_ssn"
"	  ,recip_date_of_birth"
"	  ,recip_date_of_death"
"	  ,medicareIndicatorCode"
"	  ,recip_sex_code"
"	  ,recip_area_code"
"	  ,recip_phone_num"
"	  ,recip_addr_line_1"
"	  ,recip_addr_line_2"
"	  ,countyCode"
"	  ,recip_city"
"	  ,recip_state"
"	  ,recip_zip_code"
"	  ,planNumber"
      ,eligBeginDate
      ,eligEndDate
      ,eligAdded
      ,eligLastUpdated)
select stageId rowNumber
      ,:fileRequestId
      ,original_recip_id
"	  ,ssn_first_8"
"	  ,ssn_last_char"
"	  ,teams_id_num"
"	  ,recip_name"
"	  ,recip_ssn"
"	  ,recip_date_of_birth"
"	  ,recip_date_of_death"
"	  ,case when prt_a_elig_end_date_01 = '99999999' and prt_b_elig_end_date_01 = '99999999' then 'C'"
"	        when prt_a_elig_end_date_01 = '99999999' then 'A'"
"			when prt_b_elig_end_date_01 = '99999999' then 'B'"
"			else 'N'"
"	   end medicareIndicatorCode"
"	  ,recip_sex_code"
"	  ,recip_area_code"
"	  ,recip_phone_num"
"	  ,recip_addr_line_1"
"	  ,recip_addr_line_2"
"	  ,null countyCode"
"	  ,recip_city"
"	  ,recip_state"
"	  ,recip_zip_code"
"	  ,'PHARMACY' planNumber"
      ,phar_effect_date_<i> eligBeginDate
      ,phar_term_date_<i> eligEndDate
      ,null eligAdded
      ,null eligLastUpdt
  from EdmStage.Montana_Member
" where phar_term_date_<i> <> '00000000'; 	1	2019-05-03 10:51:50.0166667	mssql"
"52	69	INSERT_Elig_Deprivation	insert into EdmStage.Montana_MemberStage"
      (rowNumber
      ,fileRequestId
      ,original_recip_id
"	  ,ssn_first_8"
"	  ,ssn_last_char"
"	  ,teams_id_num"
"	  ,recip_name"
"	  ,recip_ssn"
"	  ,recip_addr_line_1"
"	  ,recip_addr_line_2"
"	  ,recip_city"
"	  ,recip_state"
"	  ,recip_zip_code"
"	  ,recip_area_code"
"	  ,recip_phone_num"
"	  ,recip_sex_code"
"	  ,recip_date_of_birth"
"	  ,recip_date_of_death"
"	  ,medicareIndicatorCode"
"	  ,countyCode"
"	  ,planNumber"
"	  ,eligBeginDate"
"	  ,eligEndDate"
"	  ,eligAdded"
"	  ,eligLastUpdated)"
select stageId rowNumber
      ,:fileRequestId
      ,original_recip_id
"	  ,ssn_first_8"
"	  ,ssn_last_char"
"	  ,teams_id_num"
"	  ,recip_name"
"	  ,recip_ssn"
"	  ,recip_addr_line_1"
"	  ,recip_addr_line_2"
"	  ,recip_city"
"	  ,recip_state"
"	  ,recip_zip_code + recip_zip_code_part_2 recip_zip_code"
"	  ,recip_area_code"
"	  ,recip_phone_num"
"	  ,recip_sex_code"
"	  ,recip_date_of_birth"
"	  ,recip_date_of_death"
"	  ,case when prt_a_elig_end_date_01 = '99999999' and prt_b_elig_end_date_01 = '99999999' then 'C'"
"	        when prt_a_elig_end_date_01 = '99999999' then 'A'"
"			when prt_b_elig_end_date_01 = '99999999' then 'B'"
"			else 'N'"
"	   end medicareIndicatorCode"
"	  ,recip_county_code_0<i> countyCode"
"	  ,'DPRV_' + deprivation_code_0<i> planNumber"
      ,case when elig_data_001_one_day_auth_date <> '00000000' and dateadd(day, 1, elig_data_001_one_day_auth_date) = recip_elig_beg_date_0<i> then elig_data_001_one_day_auth_date
"	        when elig_data_002_one_day_auth_date <> '00000000' and dateadd(day, 1, elig_data_002_one_day_auth_date) = recip_elig_beg_date_0<i> then elig_data_002_one_day_auth_date"
"	        when elig_data_003_one_day_auth_date <> '00000000' and dateadd(day, 1, elig_data_003_one_day_auth_date) = recip_elig_beg_date_0<i> then elig_data_003_one_day_auth_date"
"	        when elig_data_004_one_day_auth_date <> '00000000' and dateadd(day, 1, elig_data_004_one_day_auth_date) = recip_elig_beg_date_0<i> then elig_data_004_one_day_auth_date"
"	        when elig_data_005_one_day_auth_date <> '00000000' and dateadd(day, 1, elig_data_005_one_day_auth_date) = recip_elig_beg_date_0<i> then elig_data_005_one_day_auth_date"
"	        when elig_data_006_one_day_auth_date <> '00000000' and dateadd(day, 1, elig_data_006_one_day_auth_date) = recip_elig_beg_date_0<i> then elig_data_006_one_day_auth_date"
"	        when elig_data_007_one_day_auth_date <> '00000000' and dateadd(day, 1, elig_data_007_one_day_auth_date) = recip_elig_beg_date_0<i> then elig_data_007_one_day_auth_date"
"	        when elig_data_008_one_day_auth_date <> '00000000' and dateadd(day, 1, elig_data_008_one_day_auth_date) = recip_elig_beg_date_0<i> then elig_data_008_one_day_auth_date"
"	        when elig_data_009_one_day_auth_date <> '00000000' and dateadd(day, 1, elig_data_009_one_day_auth_date) = recip_elig_beg_date_0<i> then elig_data_009_one_day_auth_date"
"	        when elig_data_010_one_day_auth_date <> '00000000' and dateadd(day, 1, elig_data_010_one_day_auth_date) = recip_elig_beg_date_0<i> then elig_data_010_one_day_auth_date"
"	        when elig_data_011_one_day_auth_date <> '00000000' and dateadd(day, 1, elig_data_011_one_day_auth_date) = recip_elig_beg_date_0<i> then elig_data_011_one_day_auth_date"
"	        when elig_data_012_one_day_auth_date <> '00000000' and dateadd(day, 1, elig_data_012_one_day_auth_date) = recip_elig_beg_date_0<i> then elig_data_012_one_day_auth_date"
"	        when elig_data_013_one_day_auth_date <> '00000000' and dateadd(day, 1, elig_data_013_one_day_auth_date) = recip_elig_beg_date_0<i> then elig_data_013_one_day_auth_date"
"	        when elig_data_014_one_day_auth_date <> '00000000' and dateadd(day, 1, elig_data_014_one_day_auth_date) = recip_elig_beg_date_0<i> then elig_data_014_one_day_auth_date"
"	        when elig_data_015_one_day_auth_date <> '00000000' and dateadd(day, 1, elig_data_015_one_day_auth_date) = recip_elig_beg_date_0<i> then elig_data_015_one_day_auth_date"
"	        when elig_data_016_one_day_auth_date <> '00000000' and dateadd(day, 1, elig_data_016_one_day_auth_date) = recip_elig_beg_date_0<i> then elig_data_016_one_day_auth_date"
"	        when elig_data_017_one_day_auth_date <> '00000000' and dateadd(day, 1, elig_data_017_one_day_auth_date) = recip_elig_beg_date_0<i> then elig_data_017_one_day_auth_date"
"	        when elig_data_018_one_day_auth_date <> '00000000' and dateadd(day, 1, elig_data_018_one_day_auth_date) = recip_elig_beg_date_0<i> then elig_data_018_one_day_auth_date"
"	        when elig_data_019_one_day_auth_date <> '00000000' and dateadd(day, 1, elig_data_019_one_day_auth_date) = recip_elig_beg_date_0<i> then elig_data_019_one_day_auth_date"
"	        when elig_data_020_one_day_auth_date <> '00000000' and dateadd(day, 1, elig_data_020_one_day_auth_date) = recip_elig_beg_date_0<i> then elig_data_020_one_day_auth_date"
"	        when elig_data_021_one_day_auth_date <> '00000000' and dateadd(day, 1, elig_data_021_one_day_auth_date) = recip_elig_beg_date_0<i> then elig_data_021_one_day_auth_date"
"	        when elig_data_022_one_day_auth_date <> '00000000' and dateadd(day, 1, elig_data_022_one_day_auth_date) = recip_elig_beg_date_0<i> then elig_data_022_one_day_auth_date"
"	        when elig_data_023_one_day_auth_date <> '00000000' and dateadd(day, 1, elig_data_023_one_day_auth_date) = recip_elig_beg_date_0<i> then elig_data_023_one_day_auth_date"
"	        when elig_data_024_one_day_auth_date <> '00000000' and dateadd(day, 1, elig_data_024_one_day_auth_date) = recip_elig_beg_date_0<i> then elig_data_024_one_day_auth_date"
"	        when elig_data_025_one_day_auth_date <> '00000000' and dateadd(day, 1, elig_data_025_one_day_auth_date) = recip_elig_beg_date_0<i> then elig_data_025_one_day_auth_date"
"	        when elig_data_026_one_day_auth_date <> '00000000' and dateadd(day, 1, elig_data_026_one_day_auth_date) = recip_elig_beg_date_0<i> then elig_data_026_one_day_auth_date"
"	        when elig_data_027_one_day_auth_date <> '00000000' and dateadd(day, 1, elig_data_027_one_day_auth_date) = recip_elig_beg_date_0<i> then elig_data_027_one_day_auth_date"
"	        when elig_data_028_one_day_auth_date <> '00000000' and dateadd(day, 1, elig_data_028_one_day_auth_date) = recip_elig_beg_date_0<i> then elig_data_028_one_day_auth_date"
"	        when elig_data_029_one_day_auth_date <> '00000000' and dateadd(day, 1, elig_data_029_one_day_auth_date) = recip_elig_beg_date_0<i> then elig_data_029_one_day_auth_date"
"	        when elig_data_030_one_day_auth_date <> '00000000' and dateadd(day, 1, elig_data_030_one_day_auth_date) = recip_elig_beg_date_0<i> then elig_data_030_one_day_auth_date"
"	   else recip_elig_beg_date_0<i> end eligBeginDate"
      ,recip_elig_end_date_0<i> eligEndDate
      ,recip_elig_added_0<i> eligAdded
      ,recip_elig_last_updt_0<i> eligLastUpdated
  from EdmStage.Montana_Member
" where recip_elig_beg_date_0<i> <> '00000000'; 	1	2019-05-03 10:52:23.9300000	mssql"
"53	69	INSERT_Elig_Part_A	insert into EdmStage.Montana_MemberStage"
      (rowNumber
      ,fileRequestId
      ,original_recip_id
"	  ,ssn_first_8"
"	  ,ssn_last_char"
"	  ,teams_id_num"
"	  ,recip_name"
"	  ,recip_ssn"
"	  ,recip_date_of_birth"
"	  ,recip_date_of_death"
"	  ,medicareIndicatorCode"
"	  ,recip_sex_code"
"	  ,recip_area_code"
"	  ,recip_phone_num"
"	  ,recip_addr_line_1"
"	  ,recip_addr_line_2"
"	  ,countyCode"
"	  ,recip_city"
"	  ,recip_state"
"	  ,recip_zip_code"
"	  ,planNumber"
      ,eligBeginDate
      ,eligEndDate
      ,eligAdded
      ,eligLastUpdated)
select stageId rowNumber
      ,:fileRequestId
      ,original_recip_id
"	  ,ssn_first_8"
"	  ,ssn_last_char"
"	  ,teams_id_num"
"	  ,recip_name"
"	  ,recip_ssn"
"	  ,recip_date_of_birth"
"	  ,recip_date_of_death"
"	  ,case when prt_a_elig_end_date_01 = '99999999' and prt_b_elig_end_date_01 = '99999999' then 'C'"
"	        when prt_a_elig_end_date_01 = '99999999' then 'A'"
"			when prt_b_elig_end_date_01 = '99999999' then 'B'"
"			else 'N'"
"	   end medicareIndicatorCode"
"	  ,recip_sex_code"
"	  ,recip_area_code"
"	  ,recip_phone_num"
"	  ,recip_addr_line_1"
"	  ,recip_addr_line_2"
"	  ,null countyCode"
"	  ,recip_city"
"	  ,recip_state"
"	  ,recip_zip_code"
"	  ,'PART_A' planNumber"
      ,prt_a_elig_beg_date_<i> eligBeginDate
      ,prt_a_elig_end_date_<i> eligEndDate
      ,null eligAdded
      ,null eligLastUpdt
  from EdmStage.Montana_Member
" where prt_a_elig_beg_date_<i> <> '00000000'; 	1	2019-05-03 10:52:23.9300000	mssql"
"54	69	INSERT_Elig_Part_B	insert into EdmStage.Montana_MemberStage"
      (rowNumber
      ,fileRequestId
      ,original_recip_id
"	  ,ssn_first_8"
"	  ,ssn_last_char"
"	  ,teams_id_num"
"	  ,recip_name"
"	  ,recip_ssn"
"	  ,recip_date_of_birth"
"	  ,recip_date_of_death"
"	  ,medicareIndicatorCode"
"	  ,recip_sex_code"
"	  ,recip_area_code"
"	  ,recip_phone_num"
"	  ,recip_addr_line_1"
"	  ,recip_addr_line_2"
"	  ,countyCode"
"	  ,recip_city"
"	  ,recip_state"
"	  ,recip_zip_code"
"	  ,planNumber"
      ,eligBeginDate
      ,eligEndDate
      ,eligAdded
      ,eligLastUpdated)
select stageId rowNumber
      ,:fileRequestId
      ,original_recip_id
"	  ,ssn_first_8"
"	  ,ssn_last_char"
"	  ,teams_id_num"
"	  ,recip_name"
"	  ,recip_ssn"
"	  ,recip_date_of_birth"
"	  ,recip_date_of_death"
"	  ,case when prt_a_elig_end_date_01 = '99999999' and prt_b_elig_end_date_01 = '99999999' then 'C'"
"	        when prt_a_elig_end_date_01 = '99999999' then 'A'"
"			when prt_b_elig_end_date_01 = '99999999' then 'B'"
"			else 'N'"
"	   end medicareIndicatorCode"
"	  ,recip_sex_code"
"	  ,recip_area_code"
"	  ,recip_phone_num"
"	  ,recip_addr_line_1"
"	  ,recip_addr_line_2"
"	  ,null countyCode"
"	  ,recip_city"
"	  ,recip_state"
"	  ,recip_zip_code"
"	  ,'PART_B' planNumber"
      ,prt_b_elig_beg_date_<i> eligBeginDate
      ,prt_b_elig_end_date_<i> eligEndDate
      ,null eligAdded
      ,null eligLastUpdt
  from EdmStage.Montana_Member
" where prt_b_elig_beg_date_<i> <> '00000000'; 	1	2019-05-03 10:52:23.9300000	mssql"
"55	0	QT3_MONITOR_2MIN_LONG_RUNNING_SESSIONS	set nocount on"

declare @nonEdmLongRunning int
declare @edmLongRunning int
declare @eveningStart int = 20
declare @morningStart int = 7
declare @hour int = datepart(hour, sysdatetime())

declare @edmUserList table
(userName varchar(100))

insert into @edmUserList values ('edm_admin')
insert into @edmUserList values ('')

insert into @edmUserList
select distinct loginame
  from sys.sysprocesses
 where loginame like 'TELLIGEN%'
    or loginame like 'CORP_USER_DOM%'

select @nonEdmLongRunning = case when @hour > @eveningStart or @hour < @morningStart then -5
                                 else -2 end

select @edmLongRunning = case when @hour > @eveningStart or @hour < @morningStart then -20
                              else -7 end
"								 							  "
select '[' + db_name(dbid) + '|' + trim(sp.loginame) + '] There' + 
       case when count(*) > 1 
"	        then ' are ' + cast(count(*) as varchar(10)) + ' long running sessions.' "
"			else ' is ' +  cast(count(*) as varchar(10)) + ' long running session.'"
       end
  from sys.sysprocesses sp
  left join @edmUserList eul on sp.loginame = eul.userName
 where status = 'runnable'
   and ((eul.userName is null and last_batch < dateadd(minute, @nonEdmLongRunning, sysdatetime()))
     or (eul.userName is NOT null and last_batch < dateadd(minute, @edmLongRunning, sysdatetime())))
 group by loginame
          ,dbid
"having count(*) > 0;	0	2019-05-24 10:53:10.8566667	mssql"
"56	0	QT3_MONITOR_2MIN_BLOCKED_SESSIONS	select '[' + db_name(dbid) + '] There' + "
       case when count(*) > 1 
"	        then ' are ' + cast(count(*) as varchar(10)) + ' blocked sessions.' "
"			else ' is ' +  cast(count(*) as varchar(10)) + ' blocked session.'"
       end
  from sys.sysprocesses
 where blocked = 1
 group by dbid
"having count(*) > 0;	1	2019-05-24 16:19:45.7066667	mssql"
"57	0	QT3_MONITOR_2MIN_CPU_USAGE	declare @eveningStart int = 20;"
declare @morningStart int = 7;
declare @hour int = datepart(hour, sysdatetime());
declare @ts bigint; 
select @ts = (select cpu_ticks/(cpu_ticks/ms_ticks) from sys.dm_os_sys_info); 
declare @output nvarchar(max) = '';
declare @cpuPeakCount int;

select @cpuPeakCount = case when @hour > @eveningStart and @hour < @morningStart then 10 
                            else 4 end;

select @output = @output + char(13) + char(10) + '['+ convert(varchar(30), eventTime, 121) +'] cpu utilization reached ' + cast(cpuUtilization as varchar(20)) + '%'
  from (select *
"	          ,sum(case when cast(cpuUtilization as int) > 63 then 1 else 0 end) over(partition by 1) exceededThreshold"
          from (select top(10)
"	                   SQLProcessUtilization cpuUtilization"
"	                  ,dateadd(ms,-1 *(@ts - [timestamp]),sysdatetime()) eventTime"
                  from (select record.value('(./Record/@id)[1]','int')AS record_id, 
                               record.value('(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]','int')AS [SystemIdle], 
                               record.value('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]','int')AS [SQLProcessUtilization], 
                               [timestamp]      
                          from (select [timestamp], convert(xml, record) AS [record]             
                                  from sys.dm_os_ring_buffers             
                                 where ring_buffer_type =N'RING_BUFFER_SCHEDULER_MONITOR'AND record like'%%')AS x ) AS y 
                         order by record_id desc) x) x1
 where x1.exceededThreshold > @cpuPeakCount;

select *
  from (select substring(@output, 3, len(@output)) output) x
" where ascii(trim(x.output)) is not null	1	2019-05-24 16:36:08.0333333	mssql"
"58	0	QT3_MONITOR_2HR_FAILED_JOBS	with jobHistory as"
     (select try_convert(datetime2, cast(jh.run_date as varchar(8)) + ' ' +
             case when len(jh.run_time) = 5 then '0' + left(jh.run_time, 1) + ':' + substring(cast(run_time as varchar(5)), 2, 2) + ':' + right(run_time, 2)
"      	          when len(jh.run_time) = 4 then '00' + ':' + left(jh.run_time, 2) + ':' + right(run_time, 2)"
"      	          when len(jh.run_time) = 3 then '00' + ':0' + left(jh.run_time, 1) + ':' + right(run_time, 2)"
"      	          when len(jh.run_time) = 2 then '00:00' + right(run_time, 2)"
"      	          when len(jh.run_time) = 1 then '00:00:0' + right(run_time, 1)"
"      	  	      else left(jh.run_time, 2) + ':' + substring(cast(run_time as varchar(6)), 3, 2) + ':' + right(run_time, 2) end"
"      	    , 121) run_date_time"
"      	    ,j.name"
"      	    ,js.step_name"
            ,sql_severity
"			,jh.message"
       from msdb.dbo.sysjobs AS j
        join msdb.dbo.sysjobsteps AS js ON js.job_id = j.job_id
        join msdb.dbo.sysjobhistory AS jh ON jh.job_id = j.job_id
"	   ),"
"	jobHistoryRank as"
    (select jh.* 
           ,row_number() over(partition by jh.name, jh.step_name order by jh.run_date_time desc, jh.sql_severity desc) rnk
       from jobHistory jh)
select '[' + try_convert(varchar(19), run_date_time, 121) +'] ' + name + ' (' + step_name + ') :' + message
  from jobHistoryRank
 where rnk = 1
   and sql_severity > 0
"   and run_date_time >= dateadd(minute, -150, sysdatetime()) 	1	2019-05-28 14:09:25.6300000	mssql"
"59	34	MEMBER-INSERT_BULK_REQUEST_STAGE	insert into MPI.BulkRequestStage "
       (BulkRequestStageId 
       ,ClientIdentifier 
       ,OriginalPatientIdentifier 
       ,CurrentPatientIdentifier 
       ,PolicyNumber 
       ,FirstName 
       ,MiddleName 
       ,LastName 
       ,SSN 
       ,DOB 
       ,Gender 
       ,AddressLine1 
       ,AddressLine2 
       ,City 
       ,State 
       ,ZIP 
       ,Telephone)
select stageId BulkRequestStageId
"	  ,'COC' ClientIdentifier "
      ,policyNumber OriginalPatientIdentifier 
"	  ,null CurrentPatientIdentifier "
"	  ,policyNumber PolicyNumber "
"	  ,firstName FirstName "
"	  ,null MiddleName "
"	  ,lastName LastName "
"	  ,case when patientSsn = '000000000' then null else patientSsn end SSN"
"	  ,left(birthdate, 4) +'-'+ right(left(birthdate, 6), 2) +'-'+ right(birthdate, 2) + ' 00:00:00'  DOB "
"	  ,gender Gender "
"	  ,addressLine1 AddressLine1 "
"	  ,addressLine2 AddressLine2 "
"	  ,city City "
"	  ,state State "
"	  ,zip ZIP "
"	  ,null Telephone"
  from EdmStage.COC_Member
" where fileRequestId = :fileRequestId	1	2019-05-31 08:45:59.1833333	mssql"
"60	34	MEMBER_CLAIM-INSERT_BULK_REQUEST_STAGE	insert into MPI.BulkRequestStage"
       (BulkRequestStageId
       ,ClientIdentifier
       ,OriginalPatientIdentifier
       ,CurrentPatientIdentifier
       ,PolicyNumber
       ,FirstName
       ,MiddleName
       ,LastName
       ,SSN
       ,DOB
       ,Gender
       ,AddressLine1
       ,AddressLine2
       ,City
       ,State
       ,ZIP
       ,Telephone)
select stageId BulkRequestStageId
       ,'COC' ClientIdentifier
       ,memberKey OriginalPatientIdentifier
"	   ,null CurrentPatientIdentifier"
"	   ,memberNumber PolicyNumber"
"	   ,memberFirstName FirstName"
"	   ,null MiddleName"
"	   ,memberLastName LastName"
"	   ,case when memberSsn = '000000000' then null else memberSsn end SSN"
"	   ,right(memberDob, 4) +'-'+ left(memberDob, 2) +'-'+ substring(memberDob, 4, 2) + ' 00:00:00' DOB"
"	   ,memberGender Gender"
"	   ,addressLine1 AddressLine1"
"	   ,null AddressLine2"
"	   ,city City"
"	   ,state State"
"	   ,zip ZIP"
"	   ,null Telephone"
  from EdmStage.COC_MemberClaim
 where fileRequestId = :fileRequestId 
"   and enterprisePatientId is null	1	2019-05-31 08:49:59.8266667	mssql"
"61	34	MEMBER-MERGE_BULK_REQUEST_STAGE_DEDUP	merge into EdmStage.COC_Member m"
using (select mc.fileRequestId
             ,mc.stageId
"       	     ,d.MPIID"
         from EdmStage.COC_Member mc
         join MPI.BulkRequestStageDedup d on mc.stageId = d.BulkRequestStageId
                                         and d.MPIID is not null
        where mc.enterprisePatientId is null
          and mc.fileRequestId = :fileRequestId) u
   on m.fileRequestId = u.fileRequestId
  and m.stageId = u.stageId
" when matched then update set m.enterprisePatientId = u.MPIID; 	1	2019-06-05 08:39:56.3266667	mssql"
"62	34	MEMBER_CLAIM-MERGE_BULK_REQUEST_STAGE_DEDUP	merge into EdmStage.COC_MemberClaim m"
using (select mc.fileRequestId
             ,mc.stageId
"       	     ,d.MPIID"
         from EdmStage.COC_MemberClaim mc
         join MPI.BulkRequestStageDedup d on mc.stageId = d.BulkRequestStageId
                                         and d.MPIID is not null
        where mc.enterprisePatientId is null
          and mc.fileRequestId = :fileRequestId) u
   on m.fileRequestId = u.fileRequestId
  and m.stageId = u.stageId
" when matched then update set m.enterprisePatientId = u.MPIID; 	1	2019-06-05 08:39:56.3333333	mssql"
"63	0	QT3_MONITOR_2HR_FAILED_REPLICATION	declare @output nvarchar(max) = '';"
select @output = @output + char(13) + char(10) + char(13) + char(10) +'[' + cast(fr.fileRequestId as varchar(255)) + '] ' + fr.fileName + ' failed to replicate for ' + cl.clientCode
  from PAW.EdmLib.FileRequest fr
  join Reference.Client cl on fr.clientId = cl.clientId
  left join EdmStage.Control c on fr.fileRequestId = c.fileRequestId
 where fr.processType in ('MEMBER', 'PROVIDER', 'PHARMACY_CLAIM') --('UM_REQUESTS', 'REFERENCE', 'NONE')
    and (c.controlId is null and isnull(c.bulkReplicate, 0) = 0)
"	and fr.fileRequestId > 477"
"	and isnull(fr.purged, 0) = 0"
"	and fr.clientId not in (32)"
"	and fr.completeFlag = 1"
"	and fr.replicationFlag = 1"
"	and fr.replicationCompleteDateTime < dateadd(minute, -60, sysdatetime())"
"	and @@SERVERNAME = 'DMHMSPMSQ01'"
 
 select *
  from (select substring(@output, 5, len(@output)) output) x
" where ascii(trim(x.output)) is not null	1	2019-06-06 20:17:44.4266667	mssql"
"64	0	MERGE_INTO_InstitutionalClaimInfoRefLine	insert into ClaimInfo.InstitutionalClaimInfoRefHeader"
      (clientId
"	  ,patientId"
"	  ,payerClaimControlNumber"
"	  ,payerClaimControlNumberExt"
"	  ,adjustedClaimControlNumber"
"	  ,adjustmentSequenceNumber"
"	  ,referralNumber"
"	  ,medicalRecordNumber"
"	  ,priorAuthorizationNumber"
"	  ,peerReviewAuthorizationNumber"
"	  ,valueAddedNetworkTraceNumber"
"	  ,fileRequestId"
"	  ,stageId"
"	  ,createDateTime)"
select x.clientId                                   
      ,x.patientId
"	  ,x.payerClaimControlNumber"
"	  ,x.payerClaimControlNumberExt"
"	  ,x.adjustedClaimControlNumber"
"	  ,x.adjustmentSequenceNumber"
"	  ,x.referralNumber"
"	  ,x.medicalRecordNumber"
"	  ,x.priorAuthorizationNumber"
"	  ,x.peerReviewAuthorizationNumber"
"	  ,x.valueAddedNetworkTraceNumber"
"	  ,x.fileRequestId"
"	  ,x.stageId"
"	  ,x.createDateTime"
  from (select h.institutionalClaimInfoRefHeaderId
              ,c.clientId
              ,p.patientId
"	          ,c.payerClaimControlNumber"
"			  ,c.payerClaimControlNumberExt"
"	          ,c.adjustedClaimControlNumber"
"			  ,c.adjustmentSequenceNumber"
"			  ,c.referralNumber"
"	          ,c.medicalRecordNumber"
"			  ,c.priorAuthorizationNumber"
"	          ,c.peerReviewAuthorizationNumber"
"	          ,c.valueAddedNetworkTraceNumber"
"			  ,c.fileRequestId"
"			  ,c.stageId"
"			  ,current_timestamp createDateTime"
"	          ,row_number() over(partition by c.clientId, c.patientPrimaryNumber, c.payerClaimControlNumber order by p.patientActiveFlag desc) rnk"
          from EdmStandard.InstitutionalClaim c
          join Patient.PatientDim p on c.clientId = p.clientId
                                   and c.patientPrimaryNumber = p.patientPrimaryNumber
"		  left join ClaimInfo.InstitutionalClaimInfoRefHeader h on c.clientId = h.clientId"
"	                                                           and p.patientId = h.patientId"
"	                                                           and c.payerClaimControlNumber = h.payerClaimControlNumber "
"	                                                           and isnull(c.adjustedClaimControlNumber, '~') = isnull(h.adjustedClaimControlNumber, '~')"
"	                                                           and isnull(c.adjustmentSequenceNumber, '~') = isnull(h.adjustmentSequenceNumber, '~')"
"	                                                           and isnull(c.referralNumber, '~') = isnull(h.referralNumber, '~')"
"	                                                           and isnull(c.medicalRecordNumber, '~') = isnull(h.medicalRecordNumber, '~')"
"	                                                           and isnull(c.peerReviewAuthorizationNumber, '~') = isnull(h.peerReviewAuthorizationNumber, '~')"
"	                                                           and isnull(c.valueAddedNetworkTraceNumber, '~') = isnull(h.valueAddedNetworkTraceNumber, '~')"
         where c.fileRequestId = :fileRequestId) x
  where x.rnk = 1
"    and x.institutionalClaimInfoRefHeaderId is null	1	2019-06-13 15:01:41.3733333	mssql"
"65	0	MERGE_INTO_ProfessionalClaimInfoRefHeader	insert into ClaimInfo.ProfessionalClaimInfoRefHeader"
      (clientId
      ,patientId
      ,payerClaimControlNumber
      ,payerClaimControlNumberExt
      ,adjustedClaimControlNumber
      ,adjustmentSequenceNumber
      ,referralNumber
      ,medicalRecordNumber
      ,priorAuthorizationNumber
      ,peerReviewAuthorizationNumber
      ,valueAddedNetworkTraceNumber
      ,fileRequestId
      ,stageId
      ,createDateTime)
select x.clientId                                 
      ,x.patientId
      ,x.payerClaimControlNumber
      ,x.payerClaimControlNumberExt
      ,x.adjustedClaimControlNumber
      ,x.adjustmentSequenceNumber
"	  ,x.referralNumber"
      ,x.medicalRecordNumber
"	  ,x.priorAuthorizationNumber"
      ,x.peerReviewAuthorizationNumber
      ,x.valueAddedNetworkTraceNumber
      ,x.fileRequestId
      ,x.stageId
      ,x.createDateTime
  from (select p.clientId
              ,p.patientId
              ,c.payerClaimControlNumber
              ,c.payerClaimControlNumberExt
              ,c.adjustedClaimControlNumber
              ,c.adjustmentSequenceNumber
"			  ,c.referralNumber"
              ,c.medicalRecordNumber
"			  ,c.priorAuthorizationNumber"
              ,c.peerReviewAuthorizationNumber
              ,c.valueAddedNetworkTraceNumber
              ,c.fileRequestId
              ,c.stageId
              ,current_timestamp createDateTime
              ,row_number() over(partition by c.clientId, c.patientPrimaryNumber, c.payerClaimControlNumber order by p.patientActiveFlag desc) rnk
          from EdmStandard.ProfessionalClaim  c
          join Patient.PatientDim p on c.clientId = p.clientId
                                   and c.patientPrimaryNumber = p.patientPrimaryNumber
          left join ClaimInfo.ProfessionalClaimInfoRefHeader h on p.clientId = h.clientId
                                                              and p.patientId = h.patientId
                                                              and c.payerClaimControlNumber = h.payerClaimControlNumber
                                                              and isnull(c.payerClaimControlNumberExt, '~') = isnull(h.payerClaimControlNumberExt, '~')
                                                              and isnull(c.adjustedClaimControlNumber, '~')  = isnull(h.adjustedClaimControlNumber, '~')
                                                              and isnull(c.adjustmentSequenceNumber, '~')  = isnull(h.adjustmentSequenceNumber, '~')
"															  and isnull(c.referralNumber, '~') = isnull(h.referralNumber, '~')"
                                                              and isnull(c.medicalRecordNumber, '~') = isnull(h.medicalRecordNumber, '~')
"															  and isnull(c.priorAuthorizationNumber, '~') = isnull(h.priorAuthorizationNumber, '~')"
                                                              and isnull(c.peerReviewAuthorizationNumber, '~')  = isnull(h.peerReviewAuthorizationNumber, '~')
                                                              and isnull(c.valueAddedNetworkTraceNumber, '~')  = isnull(h.valueAddedNetworkTraceNumber , '~')
         where c.fileRequestId = :fileRequestId
           and h.professionalClaimInfoRefHeaderId is null) x
" where x.rnk = 1	1	2019-06-18 17:33:29.0700000	mssql"
"66	0	MERGE_INTO_ProfessionalClaimInfoRefLine	insert into ClaimInfo.ProfessionalClaimInfoRefLine"
(clientId
,patientId
,slPriorAuthorizationOrReferralNumber1
,slPriorAuthorizationOrReferralNumber2
,slPriorAuthorizationOrReferralNumber3
,slPriorAuthorizationOrReferralNumber4
,slPriorAuthorizationOrReferralNumber5
,fileRequestId
,stageId
,createDateTime)
select clientId
      ,patientId
      ,slPriorAuthorizationOrReferralNumber1
      ,slPriorAuthorizationOrReferralNumber2
      ,slPriorAuthorizationOrReferralNumber3
      ,slPriorAuthorizationOrReferralNumber4
      ,slPriorAuthorizationOrReferralNumber5
      ,fileRequestId
      ,stageId
      ,sysdatetime()
  from (select p.clientId
              ,p.patientId
"	          ,c.slPriorAuthorizationOrReferralNumber1"
"	          ,c.slPriorAuthorizationOrReferralNumber2"
"	          ,c.slPriorAuthorizationOrReferralNumber3"
"	          ,c.slPriorAuthorizationOrReferralNumber4"
"	          ,c.slPriorAuthorizationOrReferralNumber5"
"			  ,c.fileRequestId"
"			  ,c.stageId"
"	          ,row_number() over(partition by p.clientId, p.patientId, c.slPriorAuthorizationOrReferralNumber1, c.slPriorAuthorizationOrReferralNumber2, c.slPriorAuthorizationOrReferralNumber3, c.slPriorAuthorizationOrReferralNumber4, c.slPriorAuthorizationOrReferralNumber5 order by c.stageId) rnk"
          from EdmStandard.ProfessionalClaim c
          join Patient.PatientDim p on c.clientId = p.clientId
                                   and c.patientPrimaryNumber = p.patientPrimaryNumber
          left join ClaimInfo.ProfessionalClaimInfoRefLine l on p.clientId = l.clientId
                                                            and p.patientId = l.patientId
"													        and c.slPriorAuthorizationOrReferralNumber1 = l.slPriorAuthorizationOrReferralNumber1"
"													        and isnull(c.slPriorAuthorizationOrReferralNumber2, '~') = isnull(l.slPriorAuthorizationOrReferralNumber2, '~')"
"													        and isnull(c.slPriorAuthorizationOrReferralNumber3, '~') = isnull(l.slPriorAuthorizationOrReferralNumber3, '~')"
"													        and isnull(c.slPriorAuthorizationOrReferralNumber4, '~') = isnull(l.slPriorAuthorizationOrReferralNumber4, '~')"
"													        and isnull(c.slPriorAuthorizationOrReferralNumber5, '~') = isnull(l.slPriorAuthorizationOrReferralNumber5, '~')"
         where c.slPriorAuthorizationOrReferralNumber1 is not null
           and c.fileRequestId = :fileRequestId
           and l.professionalClaimInfoRefLineId is null) x
"   where x.rnk = 1	1	2019-06-18 17:37:30.7366667	mssql"
"68	34	MEMBER-MISSING_MPI_COUNT	select count(*) from EdmStage.COC_Member where enterprisePatientId is null	1	2019-06-26 20:48:25.1900000	mssql"
"69	34	MEMBER_CLAIM-MISSING_MPI_COUNT	select count(*) from EdmStage.COC_MemberClaim where enterprisePatientId is null	1	2019-06-26 20:48:37.2733333	mssql"
"71	67	MEMBER_PHONE-INSERT_BULK_REQUEST_STAGE	insert into MPI.BulkRequestStage"
       (BulkRequestStageId
       ,ClientIdentifier
       ,OriginalPatientIdentifier
       ,CurrentPatientIdentifier
       ,PolicyNumber
       ,FirstName
       ,MiddleName
       ,LastName
       ,SSN
       ,DOB
       ,Gender
       ,AddressLine1
       ,AddressLine2
       ,City
       ,State
       ,ZIP
       ,Telephone)
select stageId BulkRequestStageId
       ,'MAL' ClientIdentifier
       ,replace(emplid, '_', '') OriginalPatientIdentifier
"	   ,null CurrentPatientIdentifier"
"	   ,replace(emplid, '_', '') PolicyNumber"
"	   ,isnull(first_name, 'NA9') FirstName"
"	   ,middle_name MiddleName"
"	   ,isnull(last_name, 'NA9') LastName"
"	   ,null SSN"
"	   ,left(date_of_birth, 4) +'-'+ right(left(date_of_birth, 6), 2) +'-'+ right(date_of_birth, 2) + ' 00:00:00' DOB"
"	   ,gender Gender"
"	   ,address_1 AddressLine1"
"	   ,address_2 AddressLine2"
"	   ,city City"
"	   ,state State"
"	   ,zip ZIP"
"	   ,phone Telephone"
  from EdmStage.MAL_MemberPhone
 where fileRequestId = :fileRequestId 
"   and mpiID is null	1	2019-07-11 10:49:32.0333333	mssql"
"72	67	MEMBER_PHONE-MERGE_BULK_REQUEST_STAGE_DEDUP	merge into EdmStage.MAL_MemberPhone m"
using (select mc.fileRequestId
             ,mc.stageId
"       	     ,d.MPIID"
         from EdmStage.MAL_MemberPhone mc
         join MPI.BulkRequestStageDedup d on mc.stageId = d.BulkRequestStageId
                                         and d.MPIID is not null
        where mc.mpiID is null
          and mc.fileRequestId = :fileRequestId) u
   on m.fileRequestId = u.fileRequestId
  and m.stageId = u.stageId
" when matched then update set m.mpiID = u.MPIID; 	1	2019-07-11 10:50:07.7400000	mssql"
"73	67	MEMBER_PHONE-MISSING_MPI_COUNT	select count(*) from EdmStage.MAL_MemberPhone where MPIID is null	1	2019-07-11 10:50:27.4600000	mssql"
"74	67	MPI-INSERT_BULK_REQUEST_STAGE	insert into MPI.BulkRequestStage"
       (BulkRequestStageId
       ,ClientIdentifier
       ,OriginalPatientIdentifier
       ,CurrentPatientIdentifier
       ,PolicyNumber
       ,FirstName
       ,MiddleName
       ,LastName
       ,SSN
       ,DOB
       ,Gender
       ,AddressLine1
       ,AddressLine2
       ,City
       ,State
       ,ZIP
       ,Telephone)
select stageId BulkRequestStageId
       ,'MAL' ClientIdentifier
       ,memberId + dependentNumber OriginalPatientIdentifier
"	   ,null CurrentPatientIdentifier"
"	   ,memberId policyNumber"
"	   ,isnull(memberFirstName, 'NA9') FirstName"
"	   ,null MiddleName"
"	   ,isnull(memberLastName, 'NA9') LastName"
"	   ,memberId SSN"
"	   ,case when memberDob = '00000101' then '00000000' else left(memberDob, 4) +'-'+ right(left(memberDob, 6), 2) +'-'+ right(memberDob, 2) end + ' 00:00:00' DOB"
"	   ,memberGender Gender"
"	   ,memberAddress AddressLine1"
"	   ,null AddressLine2"
"	   ,memberCity City"
"	   ,memberState State"
"	   ,case left(memberZip, 4)"
"	         when '0000' then right(memberZip, 5) + '0000'"
"			 else memberZip"
"		end ZIP "
"	   ,null Telephone"
  from EdmStage.MAL_Member2
  where fileRequestId = :fileRequestId 
"   and mpiID is null 	1	2019-07-11 11:51:51.6933333	mssql"
"75	67	MPI-MERGE_BULK_REQUEST_STAGE_DEDUP	merge into EdmStage.MAL_Member2 m"
using (select mc.fileRequestId
             ,mc.stageId
             ,d.MPIID
         from EdmStage.MAL_Member2 mc
         join MPI.BulkRequestStageDedup d on mc.stageId = d.BulkRequestStageId
                                         and d.MPIID is not null
        where mc.mpiid is null
          and mc.fileRequestId = :fileRequestId
"		  ) u"
   on m.fileRequestId = u.fileRequestId
  and m.stageId = u.stageId
" when matched then update set m.mpiid = u.MPIID;	1	2019-07-11 11:52:27.3200000	mssql"
"76	67	MEMBER-MISSING_MPI_COUNT	select count(*) from EdmStage.MAL_Member where MPIID is null 	1	2019-07-11 11:52:46.0900000	mssql"
"77	67	INSERT_MISSING_Members_aka_RETIRE	declare @clientId int = :clientId ;"
declare @fileRequestId bigint = :fileRequestId ;
--select max(stageId) from EdmStage.MAL_Member2 ;
declare @maxStageId bigint = :maxStageId ;

alter table EdmStage.MAL_Member2 alter column coverageType nvarchar(255) ;

insert into EdmStage.MAL_Member2
      (stageId
          ,fileRequestId
          ,mpiid
"		  ,subscriberMpiID"
          ,subscriberPrimaryNumber
          ,relationshipCode
          ,memberFirstName
          ,memberLastName
          ,memberDob
          ,memberGender
          ,memberSsn
          ,memberId
          ,maritalStatus
          ,transactionDate
          ,coverageStartDate
          ,coverageTermDate
          ,coverageType
          ,planTypeCode)
select @maxStageId + row_number() over(partition by 1 order by d.patientId) stageId
      ,@fileRequestId fileRequestId
      ,d.enterprisePatientId
"	  ,d.enterpriseSubscriberId"
      ,d.subscriberPrimaryNumber
      ,rel.inValue relationshipCode
      ,d.patientFirstName memberFirstName
      ,d.patientLastName memberLastName
      ,replace(convert(varchar(10), d.patientBirthDate, 121), '-', '') memberDob
      ,d.patientGenderCode memberGender
      ,d.patientSsn +'XX' memberSsn
      ,d.patientSsn memberId
      ,d.patientMaritalStatusCode maritalStatus
      ,replace(convert(varchar(10), sysdatetime(), 121), '-', '') transactionDate
      ,replace(convert(varchar(10), e.benefitPlanStartDate, 121), '-', '') coverageStartDate
      ,replace(convert(varchar(10), dateadd(day, -1, dateadd(month, 1, try_convert(date, left(right(fr.fileName, 12), 4) +'-'+ left(right(left(right(fr.fileName, 12), 8), 4), 2) +'-01', 121))), 121), '-', '') coverageTermDate
      ,pl.planNumber coverageType
      ,pl.planType planTypeCode
  from Patient.PatientDim d
  left join EdmStage.MAL_Member2 m on d.enterprisePatientId = m.mpiid
  join Patient.EligibilityFact e on d.clientId = e.clientId
                                and d.patientId = e.patientId
"								and e.eligibilityFactActiveFlag = 1"
                                and (e.benefitPlanEndDate is null
                                  or e.benefitPlanEndDate > sysdatetime())
  join EdmLib.FileRequest fr on fr.fileRequestId = @fileRequestId
  left join EdmLib.Mapping rel on d.relationshipCode = rel.outValue
                              and rel.name = 'MAL_RELATIONSHIP_CODE'
  join Reference.Plans pl on e.benefitPlanId = pl.plansId
 where d.clientId = @clientId
   and m.mpiid is null 
"   and d.patientActiveFlag = 1	1	2019-07-15 15:10:18.6200000	mssql"
"78	55	RETIRE_Missing_Members	insert into EdmStage.NorthernIllinois_Member"
(stageId
,fileRequestId
,policyNum
,memberId
,ssn
,lastName
,firstName
,birthDate
,gender
,relation
,policyType
,eligibilityStartDate
,eligibilityEndDate
,vendorUniqueId)
select :maxStageId + row_number() over(partition by 1 order by pd.patientId) stageId
      ,:fileRequestId fileRequestId
"	  ,left('00000' + ef.policyIdentifier, 15) policyNum"
"	  ,right(pd.patientPrimaryNumber, 5) memberId"
"	  ,'000000' + pd.patientSsn ssn"
"	  ,pd.patientLastName lastName"
"	  ,pd.patientFirstname firstName"
"	  ,convert(varchar(8), pd.patientBirthDate, 112) birthDate"
"	  ,pd.patientGenderCode gender"
"	  ,isnull(rel.inValue, replace(pd.relationshipCode, '~', '')) relation"
"	  ,pl.planNumber policyType"
"	  ,convert(varchar(8), ef.benefitPlanStartDate, 112) eligibilityStartDate"
"	  ,convert(varchar(8), dateadd(day, -1, dateadd(month, 1, convert(datetime2, cast(datepart(year, sysdatetime()) as varchar(4)) + case when datepart(month, sysdatetime()) < 10 then '0' else '' end + cast(datepart(month, sysdatetime()) as varchar(2)) + '01', 120))), 112) eligibilityEndDate"
"	  ,left(pd.patientPrimaryNumber, 9) vendorUniqueId"
  from Patient.PatientDim pd
  join Patient.EligibilityFact ef on pd.clientId = ef.clientId
"  							     and pd.patientId = ef.patientId"
"  							     and (ef.benefitPlanEndDate is null"
"  							       or ef.benefitPlanEndDate > sysdatetime())"
  left join EdmStage.NorthernIllinois_Member m on pd.patientPrimaryNumber = m.vendorUniqueId + m.memberId
                                    
  join Reference.Plans pl on ef.benefitPlanId = pl.plansId
  left join EdmLib.Mapping rel on pd.relationshipCode = rel.outValue
                              and rel.name = 'NorthernIllinois_RELATIONSHIP_CODE'
 where pd.clientId = 55
"   and m.stageId is null; 	1	2019-07-23 18:30:46.9866667	mssql"
"79	0	QT3_MONITOR_2MIN_MEMORY_USAGE	SELECT case when cntr_value >= 300 then 'WARNING'"
            else 'CRITICAL' end +
"			': ' + rtrim(counter_name) + ' = ' + cast(cntr_value as varchar(32)) + '     ***** [warning: 300-600, critical: <300]'"
  FROM sys.dm_os_performance_counters
 WHERE [object_name] LIKE '%Manager%'
   AND [counter_name] = 'Page life expectancy'
   and cntr_value <= 600
"   and datepart(hour, sysdatetime()) between 8 and 19	1	2019-08-05 14:04:14.9666667	mssql"
"80	42	MERGE_OPTUM-CPT-BASE	declare @fileRequestId bigint = :fileRequestId ;"

declare @hcpcsLevel varchar(1) = '1' ;
declare @hcpcsLevelType varchar(10) = 'CPT' ;

#NAME?
#NAME?
drop table if exists #hcpcs ;

select h.hcpcsId
      ,o.fileRequestId
      ,o.code
      ,o.shortDescription
      ,o.longDescription
      ,o.fullDescription
      ,o.nonFacilityTotalRVU
      ,o.facilityTotalRVU
"	  ,case when upper(o.fullDescription) like '%UNSPECIFIED%' then 1 "
"	  	    when upper(o.fullDescription) like '%UNCLASSIFIED%' then 1"
"	  	    when upper(o.fullDescription) like '%UNLISTED %' then 1"
"	        when upper(o.fullDescription) like '%NOT OTHERWISE SPECIFIED%' then 1 "
"	        when upper(o.fullDescription) like '%NOT OTHERWISE CLASSIFIED%' then 1 "
"	        when upper(o.fullDescription) like '%NOT ELSEWHERE SPECIFIED%' then 1 "
"	        else 0 end nocFlag"
"	  ,case when h.hcpcsEffectiveDate is not null "
"	        then h.hcpcsEffectiveDate"
"	        when h.hcpcsId is null"
"	         and isnull(o.status, '~') <> 'D' "
"	  	  then dateadd(day, 0, replace(substring(fr.originalFileName, patindex('%[0-9][0-9][0-9][0-9][_][0-9][0-9]%', fr.originalFileName), 7), '_', '-') + '-01') end effectiveDate"
"	  ,case when o.status = 'D' then dateadd(day, -1, replace(substring(fr.originalFileName, patindex('%[0-9][0-9][0-9][0-9][_][0-9][0-9]%', fr.originalFileName), 7), '_', '-') + '-01') end terminationDate"
      ,h.hcpcsNocFlag
"	  ,h.hcpcsEffectiveDate"
      ,h.hcpcsTerminationDate
"	  ,case when h.hcpcsId is null"
              or o.shortDescription <> h.hcpcsShortDesc
              or o.longDescription <> h.hcpcsLongDesc
              or o.fullDescription <> h.hcpcsFullDesc
              or isnull(o.facilityTotalRVU, -1) <> isnull(h.hcpcsTotalFacilityPractiveExpenseRvu, -1)
              or isnull(o.nonFacilityTotalRVU, -1) <> isnull(h.hcpcsTotalNonFacilityPracticeExpenseRvu, -1) 
"	 	   then 1 "
"	 	   else 0 "
"	    end hasDiff"
   into #hcpcs
        ------------------------
   from EdmStage.Optum_CPTBase o
        ------------------------
   join EdmLib.FileRequest fr on o.fileRequestId = fr.fileRequestId
   left join Reference.Hcpcs h on o.code = h.hcpcsCode
"   						      and hcpcsLevel = @hcpcsLevel"
"							  and hcpcsActiveFlag = 1"

#NAME?
drop table if exists #hcpcs_diff ;

select *
  into #hcpcs_diff 
  from #hcpcs
 where hasDiff = 1
    or nocFlag <> hcpcsNocFlag
    or isnull(terminationDate, '9999-12-31') <> isnull(hcpcsTerminationDate, '9999-12-31') ;

-- truncate table Reference.HcpcsHistory ;
 
#NAME?
#NAME?
insert into Reference.HcpcsHistory
select h.*, sysdatetime() historyDateTime, @fileRequestId triggeringFileRequestId
  from #hcpcs_diff d
  join Reference.Hcpcs h on d.hcpcsId = h.hcpcsId;

declare @maxHcpcsId bigint ;
select @maxHcpcsId = max(hcpcsId)
  from Reference.Hcpcs ;

declare @currentHcpcsId bigint ;
select @currentHcpcsId = convert(bigint, current_value)
  from sys.sequences
 where object_id = object_id('Reference.HcpcsSeq') ;

if @maxHcpcsId > @currentHcpcsId
begin
"	print 'Re-sequencing ...'"
"	declare @reSequenceDDL varchar(500) = 'alter sequence Reference.HcpcsSeq restart with ' + convert(varchar(10), @maxHcpcsId + 1) ;"
"	exec sp_sqlexec @reSequenceDDL ;"
end ;

merge into Reference.Hcpcs m
using #hcpcs_diff u
   on m.hcpcsId = u.hcpcsId
 when matched then update
"	  set m.hcpcsShortDesc = u.shortDescription"
"		 ,m.hcpcsLongDesc = u.longDescription"
"		 ,m.hcpcsFullDesc = u.fullDescription"
"		 ,m.hcpcsTotalNonFacilityPracticeExpenseRvu = u.nonFacilityTotalRVU"
"		 ,m.hcpcsTotalFacilityPractiveExpenseRvu = u.facilityTotalRVU"
"		 ,m.hcpcsNocFlag = u.nocFlag"
"		 ,m.hcpcsEffectiveDate = u.effectiveDate"
"		 ,m.hcpcsTerminationDate = u.terminationDate"
"		 ,m.hcpcsUpdateDate = sysdatetime()"
 when not matched then insert
"		 (hcpcsCode"
"		 ,hcpcsLevel"
"		 ,hcpcsShortDesc"
"		 ,hcpcsLongDesc"
"		 ,hcpcsFullDesc"
"		 ,hcpcsEffectiveDate"
"		 ,hcpcsTerminationDate"
"		 ,hcpcsTotalNonFacilityPracticeExpenseRvu"
"		 ,hcpcsTotalFacilityPractiveExpenseRvu"
"		 ,hcpcsNocFlag"
"		 ,hcpcsLevelType"
"		 ,hcpcsActiveFlag"
"		 ,hcpcsCreateDate)"
"		 values"
"		 (u.code"
"		 ,@hcpcsLevel"
"		 ,u.shortDescription"
"		 ,u.longDescription"
"		 ,u.fullDescription"
"		 ,u.effectiveDate"
"		 ,u.terminationDate"
"		 ,u.nonFacilityTotalRVU"
"		 ,u.facilityTotalRVU"
"		 ,u.nocFlag"
"		 ,@hcpcsLevelType"
"		 ,1"
"		 ,sysdatetime()); "
"		 "
#NAME?
merge into Reference.Hcpcs m
using (select *
         from Reference.HcpcsOverride
        where hcpcsLevel = @hcpcsLevel
          and hcpcsActiveFlag = 1) u
   on m.hcpcsId = u.hcpcsId
  and m.hcpcsCode = u.hcpcsCode
  and m.hcpcsLevel = u.hcpcsLevel
" when matched then update set m.hcpcsCategoryId							= u.hcpcsCategoryId"
"                             ,m.hcpcsShortDesc							= u.hcpcsShortDesc"
"                             ,m.hcpcsLongDesc							= u.hcpcsLongDesc"
"                             ,m.hcpcsFullDesc							= u.hcpcsFullDesc"
"                             ,m.hcpcsEffectiveDate						= u.hcpcsEffectiveDate"
"                             ,m.hcpcsTerminationDate					= u.hcpcsTerminationDate"
"                             ,m.hcpcsTotalNonFacilityPracticeExpenseRvu	= u.hcpcsTotalNonFacilityPracticeExpenseRvu"
"                             ,m.hcpcsTotalFacilityPractiveExpenseRvu	= u.hcpcsTotalFacilityPractiveExpenseRvu"
"                             ,m.hcpcsReuseDate							= u.hcpcsReuseDate"
"                             ,m.hcpcsPreviousId							= u.hcpcsPreviousId"
"                             ,m.hcpcsStatus								= u.hcpcsStatus"
"                             ,m.hcpcsActiveFlag							= u.hcpcsActiveFlag"
"                             ,m.hcpcsCreateDate							= u.hcpcsCreateDate"
"                             ,m.hcpcsUpdateDate							= u.hcpcsUpdateDate"
"                             ,m.hcpcsNocInd								= u.hcpcsNocInd"
"                             ,m.hcpcsNocFlag							= u.hcpcsNocFlag"
"                             ,m.hcpcsLevelType							= u.hcpcsLevelType ; 	1	2019-08-06 00:00:00.0000000	mssql"
"81	42	MERGE_OPTUM-CPT-CATEGORY	declare @fileRequestId bigint = :fileRequestId ;"

declare @hcpcsLevel varchar(1) = '1' ;
declare @hcpcsLevelType varchar(10) = 'CPT' ;

drop table if exists #cpt_category_temp0 ;

select x.stageId
      ,x.fileRequestId
"	  ,x.code"
"	  ,x.codeDescription"
"	  ,x.nonFacilityTotalRVU"
"	  ,x.facilityTotalRVU"
"	  ,x.section rawSection"
"	  ,x.category rawCategory"
"	  ,x.subCategory rawSubCategory"
"	  ,x.subSection rawSubSection"
      ,case when patindex('[0-9][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][-][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][ ]%', replace(replace(section, '[', ''), ']', '')) = 1
"	        then trim(right(replace(replace(section, '[', ''), ']', ''), len(replace(replace(section, '[', ''), ']', ''))-11))"
"			when patindex('[0-9][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][-][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z]', replace(replace(section, '[', ''), ']', '')) = 1"
"	        then null"
"			when patindex('[0-9][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][ ]%', replace(replace(section, '[', ''), ']', '')) = 1"
"	        then trim(right(replace(replace(section, '[', ''), ']', ''), len(replace(replace(section, '[', ''), ']', ''))-6))"
"			when patindex('[0-9][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z]', replace(replace(section, '[', ''), ']', '')) = 1"
"	        then null"
"			when patindex('[0-9][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][-][0-9][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][-][0-9][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z]', replace(section, ', ', '-')) = 1"
"	        then null"
"			else section"
"	   end section"
"	  ,case when patindex('[0-9][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][-][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][ ]%', replace(replace(category, '[', ''), ']', '')) = 1"
"	        then trim(right(replace(replace(category, '[', ''), ']', ''), len(replace(replace(category, '[', ''), ']', ''))-11))"
"			when patindex('[0-9][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][-][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z]', replace(replace(category, '[', ''), ']', '')) = 1"
"	        then null"
"			when patindex('[0-9][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][ ]%', replace(replace(category, '[', ''), ']', '')) = 1"
"	        then trim(right(replace(replace(category, '[', ''), ']', ''), len(replace(replace(category, '[', ''), ']', ''))-6))"
"			when patindex('[0-9][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z]', replace(replace(category, '[', ''), ']', '')) = 1"
"	        then null"
"			when patindex('[0-9][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][-][0-9][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][-][0-9][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z]', replace(category, ', ', '-')) = 1"
"	        then null"
"			else category"
"	   end category"
"	  ,case when patindex('[0-9][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][-][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][ ]%', replace(replace(subCategory, '[', ''), ']', '')) = 1"
"	        then trim(right(replace(replace(subCategory, '[', ''), ']', ''), len(replace(replace(subCategory, '[', ''), ']', ''))-11))"
"			when patindex('[0-9][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][-][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z]', replace(replace(subCategory, '[', ''), ']', '')) = 1"
"	        then null"
"			when patindex('[0-9][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][ ]%', replace(replace(subCategory, '[', ''), ']', '')) = 1"
"	        then trim(right(replace(replace(subCategory, '[', ''), ']', ''), len(replace(replace(subCategory, '[', ''), ']', ''))-6))"
"			when patindex('[0-9][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z]', replace(replace(subCategory, '[', ''), ']', '')) = 1"
"	        then null"
"			when patindex('[0-9][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][-][0-9][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][-][0-9][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z]', replace(subCategory, ', ', '-')) = 1"
"	        then null"
"			else subCategory"
"	   end subCategory"
"	  ,case when patindex('[0-9][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][-][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][ ]%', replace(replace(subSection, '[', ''), ']', '')) = 1"
"	        then trim(right(replace(replace(subSection, '[', ''), ']', ''), len(replace(replace(subSection, '[', ''), ']', ''))-11))"
"			when patindex('[0-9][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][-][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z]', replace(replace(subSection, '[', ''), ']', '')) = 1"
"	        then null"
"			when patindex('[0-9][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][ ]%', replace(replace(subSection, '[', ''), ']', '')) = 1"
"	        then trim(right(replace(replace(subSection, '[', ''), ']', ''), len(replace(replace(subSection, '[', ''), ']', ''))-6))"
"			when patindex('[0-9][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z]', subSection) = 1"
"	        then null"
"			when patindex('[0-9][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][-][0-9][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][-][0-9][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z]', replace(subSection, ', ', '-')) = 1"
"	        then null"
"			else subSection"
"	   end subSection"
"	  ,case when patindex('[0-9][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][-][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][ ]%', replace(replace(subSubSection, '[', ''), ']', '')) = 1"
"	        then trim(right(replace(replace(subSubSection, '[', ''), ']', ''), len(replace(replace(subSubSection, '[', ''), ']', ''))-11))"
"			when patindex('[0-9][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][-][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z]', replace(replace(subSubSection, '[', ''), ']', '')) = 1"
"	        then null"
"			when patindex('[0-9][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][ ]%', replace(replace(subSubSection, '[', ''), ']', '')) = 1"
"	        then trim(right(replace(replace(subSubSection, '[', ''), ']', ''), len(replace(replace(subSubSection, '[', ''), ']', ''))-6))"
"			when patindex('[0-9][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z]', replace(replace(subSubSection, '[', ''), ']', '')) = 1"
"	        then null"
"			when patindex('[0-9][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][-][0-9][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][-][0-9][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z]', replace(subSubSection, ', ', '-')) = 1"
"	        then null"
"			else subSubSection"
"	   end subSubSection"
"	  ,createDateTime"
  into #cpt_category_temp0
  from EdmStage.Optum_CPTCategory x ;

drop table if exists #cpt_category_temp1 ;

select stageId
      ,fileRequestId
"	  ,code"
"	  ,codeDescription"
"	  ,nonFacilityTotalRVU"
"	  ,facilityTotalRVU"
"	  ,rawSection"
"	  ,rawCategory"
"	  ,rawSubCategory"
"	  ,rawSubSection"
"	  ,section"
"	  ,case when section = category then null"
"	        else category"
"	   end category"
"	  ,case when category = subCategory then null"
"	        else subCategory"
"	   end subCategory "
"	  ,case when subCategory = subSection then null"
"	        else subSection"
"	   end subSection "
"	  ,createDateTime"
  into #cpt_category_temp1
  from #cpt_category_temp0 ; 

drop table if exists #cpt_category_temp2 ;

select stageId
      ,fileRequestId
"	  ,code"
"	  ,codeDescription"
"	  ,nonFacilityTotalRVU"
"	  ,facilityTotalRVU"
"	  ,rawSection"
"	  ,rawCategory"
"	  ,rawSubCategory"
"	  ,rawSubSection"
"	  ,section"
"	  ,coalesce(category, subcategory, subsection) category"
"	  ,coalesce(subcategory, subsection) subCategory "
"	  ,subsection subSection "
"	  ,createDateTime"
  into #cpt_category_temp2
  from #cpt_category_temp1 ; 

drop table if exists #cpt_category_temp ;

select stageId
      ,fileRequestId
"	  ,code"
"	  ,codeDescription"
"	  ,nonFacilityTotalRVU"
"	  ,facilityTotalRVU"
"	  ,rawSection"
"	  ,rawCategory"
"	  ,rawSubCategory"
"	  ,rawSubSection"
"	  ,section"
"	  ,isnull(case when section = category then null"
"	               else category"
"	          end, section) category"
"	  ,case when category = subCategory then null"
"	        else subCategory"
"	   end subCategory "
"	  ,case when subCategory = subSection then null"
"	        else subSection"
"	   end subSection "
"	  ,createDateTime"
  into #cpt_category_temp
  from #cpt_category_temp2 ; 

drop table if exists #cpt_category_stage ;

select hc.hcpcsCategoryId
      ,h.hcpcsId
"	  ,h.hcpcsCategoryId currentHcpcsCategoryId"
      ,c.section
      ,c.category
      ,c.subCategory
      ,c.subSection
"	  ,c.rawSection"
"	  ,c.rawCategory"
"	  ,c.rawSubCategory"
"	  ,c.rawSubSection"
  into #cpt_category_stage
  from #cpt_category_temp c
  join Reference.Hcpcs h on c.code = h.hcpcsCode
  left join Reference.HcpcsCategory hc on c.section = hc.hcpcsSection
"  					                  and isnull(c.category, '~') = isnull(hc.hcpcsCategory, '~')"
"  					                  and isnull(c.subCategory, '~') = isnull(hc.hcpcsSubCategory, '~')"
"  					                  and isnull(c.subSection, '~') = isnull(hc.hcpcsSubSection, '~')"
"  					                  and h.hcpcsLevel = @hcpcsLevel "
"  					                  and h.hcpcsLevelType = @hcpcsLevelType ;"

declare @badHcpcsCategoryCount int ;
select @badHcpcsCategoryCount = count(distinct isnull(section, '')+','+isnull(category, '')+','+isnull(subCategory,'')+','+isnull(subSection,''))
  from #cpt_category_stage 
 where hcpcsCategoryId is null
   and currentHcpcsCategoryId is not null 
   and (patindex('[0-9][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z]%', replace(replace(section, '[', ''), ']', '')) = 1 
     or patindex('[0-9][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z]%', replace(replace(category, '[', ''), ']', '')) = 1 
     or patindex('[0-9][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z]%', replace(replace(subCategory, '[', ''), ']', '')) = 1 
     or patindex('[0-9][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z]%', replace(replace(subSection, '[', ''), ']', '')) = 1
"	 or ((category is null or subCategory is null) and subSection is not null)"
"	 or (category is null and subCategory is not null)) ;"

declare @errorMessage varchar(1000) = convert(varchar(10), @badHcpcsCategoryCount) + ' HCPCS Categories contain an invalid description.  The purpose of this load is to normalize the descriptions so they no longer contain references to specific codes or ranges.'

if @badHcpcsCategoryCount > 0
"	throw 51000, @errorMessage, 16 ;"

declare @missingSectionOrCategoryCount int ;
select @badHcpcsCategoryCount = count(distinct isnull(section, '')+','+isnull(category, '')+','+isnull(subCategory,'')+','+isnull(subSection,''))
  from #cpt_category_stage 
 where section is null
    or category is null ;

set @errorMessage = convert(varchar(10), @missingSectionOrCategoryCount) + ' HCPCS Category records do not have a section or category.' ;

if @missingSectionOrCategoryCount > 0
"	throw 51000, @errorMessage, 16 ;"

merge into Reference.HcpcsCategory m
using (select distinct 
              section
"       	     ,category"
"       	     ,subCategory"
"       	     ,subSection"
         from #cpt_category_stage x
        where hcpcsCategoryId is null) u
   on u.section = m.hcpcsSection
  and isnull(u.category, '~') = isnull(m.hcpcsCategory, '~')
  and isnull(u.subCategory, '~') = isnull(m.hcpcsSubCategory, '~')
  and isnull(u.subSection, '~') = isnull(m.hcpcsSubSection, '~')
  and m.hcpcsLevel = @hcpcsLevel 
  and m.hcpcsLevelType = @hcpcsLevelType
 when not matched then insert (hcpcsSection
"		                      ,hcpcsCategory"
"		                      ,hcpcsSubCategory"
"		                      ,hcpcsSubSection"
"		                      ,hcpcsLevel"
"		                      ,hcpcsLevelType)"
                       values (u.section
                              ,u.category
                              ,u.subCategory
                              ,u.subSection
                              ,@hcpcsLevel
                              ,@hcpcsLevelType) ;

drop table if exists #cpt_category_stage_2 ;

select hc.hcpcsCategoryId
      ,h.hcpcsId
"	  ,h.hcpcsCategoryId currentHcpcsCategoryId"
"	  ,c.code"
      ,c.section
      ,c.category
      ,c.subCategory
      ,c.subSection
"	  ,c.rawSection"
"	  ,c.rawCategory"
"	  ,c.rawSubCategory"
"	  ,c.rawSubSection"
  into #cpt_category_stage_2
  from #cpt_category_temp c
  join Reference.Hcpcs h on c.code = h.hcpcsCode
  left join Reference.HcpcsCategory hc on c.section = hc.hcpcsSection
"  					                  and isnull(c.category, '~') = isnull(hc.hcpcsCategory, '~')"
"  					                  and isnull(c.subCategory, '~') = isnull(hc.hcpcsSubCategory, '~')"
"  					                  and isnull(c.subSection, '~') = isnull(hc.hcpcsSubSection, '~')"
"  					                  and h.hcpcsLevel = @hcpcsLevel "
"  					                  and h.hcpcsLevelType = @hcpcsLevelType ;"

merge into Reference.HcpcsCategory m
using (select distinct
"	          c.hcpcsCategoryId"
"	         --,c.currentHcpcsCategoryId"
"	         ,c.section"
"	         ,c.category"
"	         ,c.subCategory"
"	         ,c.subSection"
"	         --,c.rawSection"
"	         --,c.rawCategory"
"	         --,c.rawSubCategory"
"	         --,c.rawSubSection"
"	     from #cpt_category_stage c"
"	    where hcpcsCategoryId is null "
"	      and currentHcpcsCategoryId is null) u"
   on m.hcpcsCategoryId = u.hcpcsCategoryId
 when not matched
 then insert(
"		 hcpcsSection"
"		,hcpcsCategory"
"		,hcpcsSubCategory"
"		,hcpcsSubSection"
"		,hcpcsLevel"
"		,hcpcsLevelType)"
"	  values("
"		 u.section"
"		,u.subCategory"
"		,u.subCategory"
"		,u.subSection"
"		,@hcpcsLevel"
"		,@hcpcsLevelType) ;"
"		"
drop table if exists #cpt_category_stage_3 ;

select hc.hcpcsCategoryId
      ,h.hcpcsId
"	  ,h.hcpcsCategoryId currentHcpcsCategoryId"
"	  ,c.code"
      ,c.section
      ,c.category
      ,c.subCategory
      ,c.subSection
"	  ,c.rawSection"
"	  ,c.rawCategory"
"	  ,c.rawSubCategory"
"	  ,c.rawSubSection"
"	  ,rank() over(partition by c.code, c.section,isnull(c.category, '~'), isnull(c.subCategory, '~'), isnull(c.subSection, '~') order by hc.hcpcsCategoryId) rnk"
  into #cpt_category_stage_3
  from #cpt_category_temp c
  join Reference.Hcpcs h on c.code = h.hcpcsCode
  join Reference.HcpcsCategory hc on c.section = hc.hcpcsSection
"  					             and isnull(c.category, '~') = isnull(hc.hcpcsCategory, '~')"
"  					             and isnull(c.subCategory, '~') = isnull(hc.hcpcsSubCategory, '~')"
"  					             and isnull(c.subSection, '~') = isnull(hc.hcpcsSubSection, '~')"
"  					             and h.hcpcsLevel = @hcpcsLevel "
"  					             and h.hcpcsLevelType = @hcpcsLevelType ;"

merge into Reference.Hcpcs m
using (select distinct hcpcsId, hcpcsCategoryId from #cpt_category_stage_3 where rnk = 1) u
   on m.hcpcsId = u.hcpcsId
 when matched then update set m.hcpcsCategoryId = u.hcpcsCategoryId
"                             ,m.hcpcsUpdateDate = sysdatetime() ; 	1	2019-08-07 00:00:00.0000000	mssql"
"82	42	MERGE_OPTUM-CPT-CHANGE	merge into Reference.Hcpcs target"
using (
"	select * from ("
"		select  "
"			h.hcpcsId"
"			,c.code"
"			,c.newDesc"
"			,rank() over ("
"				partition by c.code"
"				order by c.releaseDate"
"			) rnk"
"		from EdmStage.Optum_CPTChange c"
"		join Reference.Hcpcs h on c.[code] = h.hcpcsCode"
"							and h.HcpcsLevel = '1' "
"							and hcpcsActiveFlag = 1"
"							and (hcpcsTerminationDate is null or hcpcsTerminationDate > SYSDATETIME())"
"	) x"
"	where x.rnk = 1"
) source
on source.hcpcsId = target.hcpcsId
when matched
"	then update"
"	set target.hcpcsFullDesc = source.newDesc;"
when not matched
"	then insert("
"		hcpcsCode"
"		,hcpcsLevel"
"		,hcpcsShortDesc"
"		,hcpcsLongDesc"
"		,hcpcsFullDesc"
"		,hcpcsLevelType)"
"	)"
"	values("
"		source.code"
"		,'1'"
"		,source.newDesc"
"		,source.newDesc"
"		,source.newDesc"
"		,'CPT'"
"	)"
";	0	2019-08-09 00:00:00.0000000	mssql"
"83	42	MERGE_OPTUM-CPT-INDICATOR	merge into Reference.HcpcsIndicators target"
using (
"	select h.hcpcsId"
"		,hi.hcpcsIndicatorsId"
"		,c.ageCode"
"		,c.sexCode"
"		,c.modifier51ExemptCode"
"		,c.addOnAMACode"
"		,c.nonCoveredInd"
"		,c.consciousSedInd"
   from EdmStage.Optum_CPTIndicator c
   left join Reference.Hcpcs h on c.code = h.hcpcsCode
"		  and h.HcpcsLevel = '1' "
"		  and hcpcsActiveFlag = 1"
"		  and (hcpcsTerminationDate is null or hcpcsTerminationDate > SYSDATETIME())"
   left join Reference.HcpcsIndicators hi on h.hcpcsId = hi.hcpcsId
) source
on source.hcpcsIndicatorsId = target.hcpcsIndicatorsId
when matched
"	then update"
"	set target.ageCode = source.ageCode"
"		,target.ageCodeDesc = case"
"				when source.ageCode = '1' then 'Maternity'"
"				when source.ageCode = '2' then 'Age edit applied'"
"				when source.ageCode = 'I' then 'Unknown'"
"				when source.ageCode = 'N' then 'Unknown'"
"				when source.ageCode is null then 'Age edit does not apply'"
"				else null"
"			end"
"		,target.sexCode = source.sexCode"
"		,target.secCodeDesc = case"
"				when source.sexCode = '1' then 'Male'"
"				when source.sexCode = '2' then 'Female'"
"				when source.sexCode is null then 'Sex indicator does not apply'"
"				else null"
"			end"
"		,target.modifier51ExemptCode = source.modifier51ExemptCode"
"		,target.modifier51ExempCodeDesc = case "
"				when source.modifier51ExemptCode = '1' then 'Modifier 51 exempt (AMA)'"
"				when source.modifier51ExemptCode = '2' then 'Modifier 51 exempt (Optum)'"
"				else null"
"			end"
"		,target.addOnAMACode = source.addOnAMACode"
"		,target.addOnAmaCodeDesc = case"
"				when source.addOnAMACode = '1' then 'Add-on code as identified by the AMA in the CPT book'"
"				when source.addOnAMACode is null then 'Add-on indicator does not apply. Add-on codes denote additional or supplemental procedures'"
"				else null"
"			end"
"		,target.nonCoveredInd = source.nonCoveredInd"
"		,target.consciousSedInd = source.consciousSedInd"
when not matched
"	then insert("
"		hcpcsId"
"		,ageCode"
"		,ageCodeDesc"
"		,sexCode"
"		,secCodeDesc"
"		,modifier51ExemptCode"
"		,modifier51ExempCodeDesc"
"		,addOnAMACode"
"		,addOnAmaCodeDesc"
"		,nonCoveredInd"
"		,consciousSedInd"
"	)"
"	values("
"		source.hcpcsId"
"		,source.ageCode"
"		,case"
"			when source.ageCode = '1' then 'Maternity'"
"			when source.ageCode = '2' then 'Age edit applied'"
"			when source.ageCode = ''  then 'Age edit does not apply'"
"			else 'Unknown'"
"		end"
"		,source.sexCode"
"		,case"
"			when source.sexCode = '1' then 'Male'"
"			when source.sexCode = '2' then 'Female'"
"			when source.sexCode = ''  then 'Sex indicator does not apply'"
"			else 'Unknown'"
"		end"
"		,source.modifier51ExemptCode"
"		,case"
"			when source.modifier51ExemptCode = '1' then 'Modifier 51 exempt (AMA)'"
"			when source.modifier51ExemptCode = '2' then 'Modifier 51 exempt (Optum)'"
"			when source.modifier51ExemptCode = '' then 'Modifier 51 exemption indicator does not apply'"
"			else 'Unknown'"
"		end"
"		,source.addOnAMACode"
"		,case"
"			when source.addOnAMACode = '1' then 'Add-on code as identified by the AMA in the CPT book'"
"			when source.addOnAMACode = '2' then 'Add-on code as identified by Optum'"
"			when source.addOnAMACode = ''  then 'Add-on indicator does not apply. Add-on codes denote additional or supplemental procedures'"
"			else 'Unknown'"
"		end"
"		,source.nonCoveredInd"
"		,source.consciousSedInd"
"	)"
";	0	2019-08-09 00:00:00.0000000	mssql"
"84	39	INSERT_PROVIDER_HISTORY	insert into EdmStage.ID_Provider"
      (stageId
      ,fileRequestId
      ,providerId
      ,providerType
      ,providerSpecialtyType
      ,providerSpecialty
      ,lastName
      ,firstName
      ,initial
      ,sex
      ,streetAddress1
      ,streetAddress2
      ,city
      ,county
      ,state
      ,zipCode
      ,phoneNumber
      ,secondaryNumber
      ,emergencyNumber
      ,faxNumber
      ,emailAddress
      ,transactionSetCreationDateTime
      ,networkEffectiveDate
      ,networkTerminationDate
      ,entityTypeQualifier
"	  ,transactionCode"
"	  ,providerStatus)"
select stageId
      ,fileRequestId
      ,providerId
      ,providerType
      ,providerSpecialtyType
      ,providerSpecialty
      ,lastName
      ,firstName
      ,initial
      ,sex
      ,streetAddress1
      ,streetAddress2
      ,city
      ,county
      ,state
      ,zipCode
      ,phoneNumber
      ,secondaryNumber
      ,emergencyNumber
      ,faxNumber
      ,emailAddress
      ,transactionSetCreationDateTime
      ,networkEffectiveDate
      ,networkTerminationDate
      ,entityTypeQualifier
"	  ,transactionCode"
"	  ,providerStatus"
  from EdmStage.ID_ProviderHistory
" where fileRequestId = :fileRequestId	1	2019-08-22 15:23:06.4466667	mssql"
"85	42	MERGE_OPTUM-CPT-MODIFIER	merge into [Reference].[Modifier] target"
using (
"	select "
"		m.[modifierId]"
"		,om.modifier"
"		,om.description"
"	from EdmStage.Optum_CPTModifier om"
"	left join [Reference].[Modifier] m on om.modifier = m.modifierCode "
"										and om.description = m.modifierDesc "
"										and m.ModifierActiveFlag = 1"
"	where fileRequestId = :fileRequestId"
) source
on source.modifierId = target.modifierId
when not matched
"	then insert("
"		modifierCode"
"		,hcpcsLevel"
"		,modifierDesc"
"		,modifierCreateDate"
"		,modifierActiveFlag"
"	)"
"	values("
"		source.modifier"
"		,'1'"
"		,source.description"
"		,sysdatetime()"
"		,1"
"	)"
";	0	2019-08-09 00:00:00.0000000	mssql"
"86	42	MERGE_OPTUM-CPT-MODIFIER-FLAG	merge into [Reference].[Modifier] target"
using (
"	select "
"		m.modifierId"
"		,omf.modifier"
"		,omf.description"
"		,omf.ambulanceFlag"
"	from EdmStage.Optum_CPTModifierFlag omf"
"	left join [Reference].[Modifier] m on omf.modifier = m.modifierCode"
"										and omf.description = m.modifierDesc "
"										and m.ModifierActiveFlag = 1"
"	where fileRequestId = :fileRequestId"
) source
on source.modifierId = target.modifierId
when matched
"	then update"
"	set target.modifierAmbulanceFlag = case"
"			when source.ambulanceFlag = 'Y' then 1"
"			else null"
"		end"
"		,target.modifierUpdateDate = sysdatetime()"
when not matched
"	then insert("
"		modifierCode"
"		,hcpcsLevel"
"		,modifierDesc"
"		,modifierAmbulanceFlag"
"		,modifierCreateDate"
"		,modifierActiveFlag"
"	)"
"	values("
"		source.modifier"
"		,'1'"
"		,source.description"
"		,case"
"			when source.ambulanceFlag = 'Y' then 1"
"			else null"
"		end"
"		,sysdatetime()"
"		,1"
"	)"
";	0	2019-08-09 00:00:00.0000000	mssql"
"87	42	MERGE_OPTUM-CPT-MODIFIER-XWALK-MEDICARE	--do not use"
merge into Reference.HcpcsModifier target
using(
"	select hm.hcpcsModifierId"
"		,h.hcpcsId"
"		,m.modifierId"
"	from EdmStage.[Optum_CPTModifierXWalk] mx"
"	left join Reference.Hcpcs h on mx.code = h.hcpcsCode"
"								and hcpcsLevel	= '1'"
"								and hcpcsActiveFlag = 1"
"								and (hcpcsTerminationDate is null or hcpcsTerminationDate > SYSDATETIME())"
"	left join Reference.Modifier m on mx.modifier = m.modifierCode"
"	left join Reference.HcpcsModifier hm on hm.hcpcsId = h.hcpcsId "
"										and m.modifierId = hm.modifierId"
"										and hm.[hcpcsModifierActiveFlag] = '1'"
"	where fileRequestId = :fileRequestId"
) source
on source.hcpcsModifierId = target.hcpcsModifierId
when not matched
"	then insert("
"		hcpcsId"
"		,modifierId"
"		,hcpcsModifierType"
"		,hcpcsModifierActiveFlag"
"		,hcpcsModifierCreateDate"
"	)"
"	values("
"		hcpcsId"
"		,modifierId"
"		,'MEDICARE'"
"		,1"
"		,sysdatetime()"
"	)"
";	0	2019-08-09 00:00:00.0000000	mssql"
"88	42	MERGE_OPTUM-CPT-MODIFIER-XWALK-PHYSICIAN	--do not use"
merge into Reference.HcpcsModifier target
using(
"	select hm.hcpcsModifierId"
"		,h.hcpcsId"
"		,m.modifierId"
"	from EdmStage.[Optum_CPTModifierXWalk] mx"
"	left join Reference.Hcpcs h on mx.code = h.hcpcsCode"
"								and hcpcsLevel	= '1'"
"								and hcpcsActiveFlag = 1"
"								and (hcpcsTerminationDate is null or hcpcsTerminationDate > SYSDATETIME())"
"	left join Reference.Modifier m on mx.modifier = m.modifierCode"
"	left join Reference.HcpcsModifier hm on hm.hcpcsId = h.hcpcsId "
"										and m.modifierId = hm.modifierId"
"										and hm.[hcpcsModifierActiveFlag] = '1'"
"	where fileRequestId = :fileRequestId"
) source
on source.hcpcsModifierId = target.hcpcsModifierId
when not matched
"	then insert("
"		hcpcsId"
"		,modifierId"
"		,hcpcsModifierType"
"		,hcpcsModifierActiveFlag"
"		,hcpcsModifierCreateDate"
"	)"
"	values("
"		hcpcsId"
"		,modifierId"
"		,'PHYSICIAN'"
"		,1"
"		,sysdatetime()"
"	)"
";	0	2019-08-09 00:00:00.0000000	mssql"
"99	34	MEMBER-DUPLICATE_MPI_COUNT	select count(*)"
  from (select enterprisePatientId
              ,count(*) recordCount
"	          ,string_agg(m.patientSsn, ', ') within group (order by m.patientSsn) patientSsnList"
"	          ,count(distinct patientSsn) patientSsnCount"
"	          ,string_agg(m.birthDate, ', ') within group (order by m.patientSsn) birthDateList"
"	          ,count(distinct birthDate) birthDateCount"
"	          ,string_agg(m.gender, ', ')  within group (order by m.patientSsn) genderList"
"	          ,count(distinct gender) genderCount"
"	          ,max(fileRequestId) fileRequestId"
"	          ,string_agg(m.stageId, ', ') within group (order by m.patientSsn) stageIdList"
          from EdmStage.COC_Member m
         group by m.enterprisePatientId
        having count(distinct case when m.patientSsn = '000000000' then null else m.patientSsn end) > 1
            or count(distinct m.birthDate) > 1
            or count(distinct m.gender) > 1) x
  left join EdmStage.COC_Member_IgnoreDuplicateCheck dc on x.enterprisePatientId = dc.enterprisePatientId
                                                       and x.patientSsnList = dc.patientSsnList
"													   and x.birthDateList = dc.birthDateList"
"													   and x.genderList = dc.genderList"
"													   and dc.activeFlag = 1"
" where dc.id is null; 	1	2019-09-07 09:44:46.0600000	mssql"
"100	34	MEMBER_CLAIM-DUPLICATE_MPI_COUNT	select count(*)"
  from EdmStage.COC_MemberClaim
" where 1 = 2	1	2019-09-07 09:44:51.1933333	mssql"
"101	0	QT3_MONITOR_2MIN_VOLUME_PERCENT_FREE	declare @percentFreeThreshold int = 21;"

with volumeStats as
     (select st.volume_mount_point mountPoint
"	        ,st.total_bytes totalBytes"
            ,(st.available_bytes*1.0)/st.total_bytes * 100 percentFree
        from sys.master_files f
       cross apply sys.dm_os_volume_stats(f.database_id, f.file_id) st
       group by st.volume_mount_point
"	           ,st.total_bytes"
"			   ,st.available_bytes)"
select v.mountPoint + ' has ' + substring(cast(percentFree as varchar(100)), 1, 5) + '% free which affects the following databases: ' + string_agg(t.databaseName, ', ')
  from volumeStats v
  join PAW.EdmLib.VolumeStatistics t on v.mountPoint = t.mountPoint
 where percentFree < @percentFreeThreshold
 group by v.mountPoint
         ,v.totalBytes
"         ,v.percentFree;	1	2019-08-30 12:44:41.4900000	mssql"
"102	34	MEMBER-MERGE_SUBSCIRBER_INFO	-- for those that don't have a policy number"
-- but are now set to themselves, use the last
#NAME?
#NAME?
#NAME?
merge into EdmStage.COC_Member m
using (select m.stageId
      ,p.enterprisePatientId
"	  ,p.patientPrimaryNumber"
  from EdmStage.COC_Member m
  join Patient.PatientDim p on m.enterprisePatientId = p.enterprisePatientId
                           and p.clientId = 34
"						   and p.patientActiveFlag = 1"
 where m.policyNumber is null
   and m.relationship = 'EE') u
  on m.stageId = u.stageId
 when matched then update set m.enterpriseSubscriberId = u.enterprisePatientId
                             ,m.subscriberPrimaryNumber = u.patientPrimaryNumber ;

#NAME?
with subscriber as 
     (select stageId subscriberStageId
"	        ,policyNumber"
"	        ,enterprisePatientId enterpriseSubscriberId"
"			,policyNumber + birthdate + gender + left(firstName, 4) subscriberPrimaryNumber"
        from EdmStage.COC_Member s
       where relationship = 'EE'
"	     and policyNumber is not null)"
merge into EdmStage.COC_Member m
using (select d.stageId
             ,max(s.enterpriseSubscriberId) enterpriseSubscriberId
"	         ,max(d.policyNumber + birthdate + gender + left(firstName, 4)) subscriberPrimaryNumber"
"	         ,max(subscriberStageId) subscriberStageId"
         from EdmStage.COC_Member d
         join subscriber s on d.policyNumber = s.policyNumber
"		where d.enterpriseSubscriberId is null"
        group by d.stageId
       having count(distinct s.enterpriseSubscriberId) = 1
          and count(distinct d.policyNumber + birthdate + gender + left(firstName, 4)) = 1) u
  on m.stageId = u.stageId
when matched then update set m.enterpriseSubscriberId = u.enterpriseSubscriberId
"                            ,m.subscriberPrimaryNumber = u.subscriberPrimaryNumber; 	1	2019-09-08 12:17:47.0266667	mssql"
"103	34	MEMBER-TOTAL_RECORD_COUNT	select count(*) from EdmStage.COC_Member	1	2019-09-08 16:21:24.8266667	mssql"
"104	34	MEMBER_CLAIM-TOTAL_RECORD_COUNT	select count(*) from EdmStage.COC_MemberClaim	1	2019-09-08 16:21:29.8600000	mssql"
"105	34	MEMBER-MERGE_PLAN_END_DATES	with newEndDateList as "
     (select m.stageId
      ,case when m.relationship <> lead(relationship, 1) over(partition by m.enterprisePatientId order by startDate, stageId)
"	         and startDate <> lead(startDate, 1) over(partition by m.enterprisePatientId order by startDate, stageId)"
"			then convert(varchar(8), dateadd(day, -1, lead(startDate, 1) over(partition by m.enterprisePatientId order by startDate, stageId)), 112)"
"			 end newEndDate"
  from EdmStage.COC_Member m
 where m.endDate is null)
merge into EdmStage.COC_Member m
using (select *
         from newEndDateList
        where newEndDate is not null) u
   on m.stageId = u.stageId
" when matched then update set m.endDate = u.newEndDate; 	1	2019-09-09 12:43:03.7666667	mssql"
"106	34	MEMBER-RETIRE_MEMBERS	WITH maximums as (select max(stageId) stageId, max(fileRequestId) fileRequestId from EdmStage.COC_Member),"
"	 PatientInfo AS (SELECT m.fileRequestId"
"						   ,'928' policySource"
"						   ,p.clientId"
"						   ,p.patientId"
"						   ,p.enterprisePatientId"
"						   ,p.tempEnterprisePatientId"
"						   ,p.patientPrimaryNumber"
"						   ,LEFT(p.patientFirstName,10) AS FirstName"
"						   ,LEFT(p.patientLastName,20) AS LastName"
"						   ,LEFT(rel.inValue, 2) relationship"
"						   ,LEFT(p.patientGenderCode,1) AS GenderCode"
"						   ,LEFT(p.patientSsn,9) AS patientSsn"
"						   ,CONVERT(varchar(8), p.patientBirthDate, 112) birthdate"
"						   ,p.enterpriseSubscriberId"
"						   ,P.subscriberPrimaryNumber"
"						   ,sub.patientSsn subscriberSsn"
"						   ,LEFT(e.policyIdentifier,9) AS policyIdentifier"
"						   ,e.groupPolicyId"
"						   ,gp.groupPolicyNumber"
"						   ,CONVERT(VARCHAR(10),CONVERT(DATE,e.groupPolicyEffectiveDate,101)) AS groupPolicyEffectiveDate"
"						   ,CONVERT(VARCHAR(10), CONVERT(DATE,e.groupPolicyExpirationDate,101)) AS groupPolicyExpirationDate"
"						   ,REPLACE(CONVERT(VARCHAR(10),CONVERT(DATE,e.groupPolicyEffectiveDate,101)),'-','') AS GroupPolicyStartDate"
"					 FROM Patient.PatientDim  p"
"					 CROSS APPLY maximums m"
"					 LEFT JOIN Patient.PatientDim sub "
"					 	 ON p.clientId = sub.clientId"
"					 	 AND p.enterpriseSubscriberId = sub.enterprisePatientId"
"					 	 AND p.recordTypeId = 28"
"					 JOIN EdmLib.Mapping rel "
"					 	 ON p.relationshipCode = rel.outValue"
"					 	 AND rel.name = 'COC_RELATIONSHIP_CODE2'"
"					 JOIN Patient.EligibilityFact e "
"					 	 ON p.clientId = e.clientId"
"					 	 AND p.patientId = e.patientId"
"						 and e.groupPolicyId > 9"
"					 	 AND e.eligibilityFactActiveFlag = 1"
"						 AND e.policyIdentifier is not null"
"						 and e.maintenanceTypeId not in (11, 24, 26) "
"						 AND (e.benefitPlanEndDate IS NULL"
"		    				  OR e.benefitPlanEndDate > sysdatetime())"
"					 JOIN Reference.GroupPolicy gp "
"					 	 ON e.groupPolicyId = gp.groupPolicyId"
"					 WHERE p.clientId = 34"
"					 AND p.patientActiveFlag = 1"
"					 and p.isTemporary = 0),"
"	 R1 AS (SELECT p.*"
"			      ,REPLACE(CONVERT(VARCHAR(10),CONVERT(DATE,sysdatetime(),101)),'-','') AS TerminationDate"
"				  ,'030' AS MaintenanceTypeCode"
"				  ,1 retireRuleNumber"
"		    FROM PatientInfo p"
"			left join EdmStage.COC_MemberExclusion e"
"                  on p.subscriberSsn	= e.subscriberSsn"
"                 and p.lastName	 	= e.lastName	 "
"                 and p.firstName	 	= e.firstName	 "
"                 and p.relationship 	= e.relationship"
"		    LEFT JOIN EdmStage.COC_Member s"
"		    	 ON p.enterprisePatientId = s.enterprisePatientId"
"		    WHERE s.enterprisePatientId IS NULL"
"			  and e.subscriberSsn is null),"
"	 R23 AS (SELECT p.*"
"			      ,s.startDate"
"				  ,CASE WHEN p.GroupPolicyStartDate < s.startDate THEN REPLACE(CONVERT(VARCHAR(10),DATEADD(DD,-1,CONVERT(DATE,LEFT(s.startDate,4) +'-'+ SUBSTRING(s.StartDate,5,2) +'-'+ RIGHT(s.startDate,2)))),'-','') END TerminationDate"
"			      ,CASE WHEN p.GroupPolicyStartDate < s.startDate THEN '030'"
"				   ELSE CASE WHEN p.GroupPolicyStartDate > s.startDate THEN '024' END"
"				   END MaintenanceTypeCode"
"				  ,23 retireRuleNumber"
"		    FROM PatientInfo p"
"		    JOIN EdmStage.COC_Member s"
"		    	 ON p.enterprisePatientId = s.enterprisePatientId"
"		    	 AND p.groupPolicyNumber = s.policyGroup"
"		    JOIN maximums m"
"		    	 ON s.fileRequestId = m.fileRequestId"
"			WHERE p.GroupPolicyStartDate != s.startDate),"
"	 R456 AS (SELECT p.*, s.startDate, s.endDate"
"			      ,CASE WHEN p.GroupPolicyStartDate < s.startDate THEN REPLACE(CONVERT(VARCHAR(10),DATEADD(DD,-1,CONVERT(DATE,LEFT(s.startDate,4) +'-'+ SUBSTRING(s.StartDate,5,2) +'-'+ RIGHT(s.startDate,2)))),'-','')"
"				   END TerminationDate"
"				   --"
"				  ,CASE WHEN p.GroupPolicyStartDate >= s.startDate THEN '024'"
"				   ELSE CASE WHEN p.GroupPolicyStartDate < s.startDate THEN '030' END "
"				   END MaintenanceTypeCode"
"				   ,456 retireRuleNumber"
"		    FROM PatientInfo p"
"		    JOIN EdmStage.COC_Member s"
"		    	 ON p.enterprisePatientId = s.enterprisePatientId"
"		    	 AND p.groupPolicyNumber != s.policyGroup"
"				 AND s.endDate IS NULL"
"		    JOIN maximums m"
"		    	 ON s.fileRequestId = m.fileRequestId),"
"	 RU AS (SELECT fileRequestId"
"				  ,policySource"
"				  ,groupPolicyNumber AS policyGroup"
"				  ,subscriberSsn"
"				  ,LastName"
"				  ,FirstName"
"				  ,relationship"
"				  ,GenderCode"
"				  ,patientSsn"
"				  ,birthdate"
"				  ,GroupPolicyStartDate AS StartDate"
"				  ,TerminationDate AS EndDate"
"				  ,policyIdentifier AS policyNumber"
"				  ,enterprisePatientId"
"				  ,enterpriseSubscriberId"
"				  ,subscriberPrimaryNumber"
"				  ,tempEnterprisePatientId"
"				  ,MaintenanceTypeCode"
"				  ,retireRuleNumber"
"		    FROM R1"
"			UNION"
"			SELECT fileRequestId"
"				  ,policySource"
"				  ,groupPolicyNumber AS policyGroup"
"				  ,subscriberSsn"
"				  ,LastName"
"				  ,FirstName"
"				  ,relationship"
"				  ,GenderCode"
"				  ,patientSsn"
"				  ,birthdate"
"				  ,GroupPolicyStartDate AS StartDate"
"				  ,TerminationDate AS EndDate"
"				  ,policyIdentifier AS policyNumber"
"				  ,enterprisePatientId"
"				  ,enterpriseSubscriberId"
"				  ,subscriberPrimaryNumber"
"				  ,tempEnterprisePatientId"
"				  ,MaintenanceTypeCode"
"				  ,retireRuleNumber"
"		    FROM R23"
"			UNION"
"			SELECT fileRequestId"
"				  ,policySource"
"				  ,groupPolicyNumber AS policyGroup"
"				  ,subscriberSsn"
"				  ,LastName"
"				  ,FirstName"
"				  ,relationship"
"				  ,GenderCode"
"				  ,patientSsn"
"				  ,birthdate"
"				  ,GroupPolicyStartDate AS StartDate"
"				  ,TerminationDate AS EndDate"
"				  ,policyIdentifier AS policyNumber"
"				  ,enterprisePatientId"
"				  ,enterpriseSubscriberId"
"				  ,subscriberPrimaryNumber"
"				  ,tempEnterprisePatientId"
"				  ,MaintenanceTypeCode"
"				  ,retireRuleNumber"
"		    FROM R456)"
INSERT INTO EdmStage.COC_Member (stageId
      ,fileRequestId
      ,policySource
      ,policyGroup
      ,subscriberSsn
      ,lastName
      ,firstName
      ,relationship
      ,gender
      ,patientSsn
      ,birthdate
      ,startDate
      ,endDate
      ,policyNumber
      ,enterprisePatientId
      ,enterpriseSubscriberId
      ,subscriberPrimaryNumber
      ,tempEnterprisePatientId
"	  ,maintenanceTypeCode"
"	  ,retireRuleNumber)"
SELECT ROW_NUMBER() OVER(PARTITION BY 1 ORDER BY (SELECT NULL)) + m.stageId AS stageId
      ,m.fileRequestId
      ,policySource
      ,LEFT(policyGroup,6) AS policyGroup
"	  ,r.subscriberSsn"
"	  ,r.LastName"
"	  ,r.FirstName"
"	  ,r.relationship"
"	  ,r.GenderCode"
"	  ,r.patientSsn"
"	  ,r.birthdate"
"	  ,r.StartDate"
"	  ,r.EndDate"
"	  ,r.policyNumber"
"	  ,r.enterprisePatientId"
"	  ,r.enterpriseSubscriberId"
"	  ,r.subscriberPrimaryNumber"
"	  ,r.tempEnterprisePatientId"
"	  ,r.MaintenanceTypeCode"
"	  ,r.retireRuleNumber"
FROM RU r
JOIN maximums m
"	 on r.fileRequestId = m.fileRequestId ; 	0	2019-09-09 12:45:14.3800000	mssql"
"107	34	MEMBER-INSERT_MANUAL_MEMBERS	with maximum as (select max(stageId) maxStageId, max(fileRequestId) maxFileRequestId from EdmStage.COC_Member)"
    ,memberList as (select pd.patientId
"	                      ,ef.eligibilityFactId"
                          ,pd.enterprisePatientId
                          ,isnull(ef.enrollmentIdentifier, left(pd.patientPrimaryNumber, 9)) policyNumber
"						  ,pd.patientPrimaryNumber"
                          ,case when pd.patientFirstName like 'BABY%' and len(pd.patientFirstName)> 10
"						        then replace(pd.patientFirstName, ' ', '')"
"						   else pd.patientFirstName end firstName"
                          ,pd.patientLastName lastName
                          ,m.inValue relationship
                          ,case when pd.patientSsn is null then '000000000' else pd.patientSsn end patientSsn
"						  ,case when sd.patientSsn is null then '000000000' else sd.patientSsn end subscriberSsn"
                          ,convert(varchar(8), pd.patientBirthDate, 112) birthdate
                          ,pd.patientGenderCode gender
"						  ,gp.groupPolicyNumber"
                          ,convert(varchar(8), ef.benefitPlanStartDate, 112) startDate
                          ,convert(varchar(8), ef.benefitPlanEndDate, 112) endDate
                          ,pd.enterpriseSubscriberId
                          ,pd.subscriberPrimaryNumber
"						  ,case when ef.benefitPlanStartDate is null then 'A' else 1 end eligibilityConfirmedId"
"						  ,case when pd.recordTypeId = 13 then 1 else 0 end isTemporaryMember"
                      from Patient.PatientDim pd
"					  left join Patient.PatientDim sd on pd.clientId = sd.clientId"
"					                                 and pd.subscriberId = sd.patientId"
                      left join EdmLib.Mapping m on pd.relationshipCode = m.outValue
                                                and m.name = 'COC_RELATIONSHIP_CODE2'
                      left join Patient.EligibilityFact ef on pd.clientId = ef.clientId
                                                          and pd.patientId = ef.patientId
"														  and ef.eligibilityFactActiveFlag = 1"
"					  left join Reference.GroupPolicy gp on ef.groupPolicyId = gp.groupPolicyId"
"					  left join EdmStage.COC_Member coc on isnull(ef.enrollmentIdentifier, left(pd.patientPrimaryNumber, 9))  = coc.policyNumber"
"					                                   and case when pd.patientFirstName like 'BABY%' and len(pd.patientFirstName)> 10"
"													            then replace(pd.patientFirstName, ' ', '')"
"													       else pd.patientFirstName end = coc.firstName"
"													   and pd.patientLastName = coc.lastName"
"													   and case when pd.patientSsn is null then '000000000' else pd.patientSsn end = coc.patientSsn"
"					                                   and isnull(ef.enrollmentIdentifier, left(pd.patientPrimaryNumber, 9)) = coc.policyNumber"
"													   and convert(varchar(8), ef.benefitPlanStartDate, 112) = coc.startDate"
                     where pd.clientId = 34
                       and pd.recordTypeId = 13
"					   and pd.patientActiveFlag = 1"
"					   and coc.stageId is null)"
insert into EdmStage.COC_Member
      (stageId
      ,fileRequestId
      ,policySource
      ,policyGroup
      ,policyNumber
      ,subscriberSsn
      ,firstName
      ,lastName
      ,relationship
      ,patientSsn
      ,birthdate
      ,gender
      ,startDate
      ,endDate
      ,enterpriseSubscriberId
      ,subscriberPrimaryNumber
"	  ,isTemporaryMember"
      ,tempEnterprisePatientId)
select mx.maxStageId + row_number() over(partition by 1 order by ml.patientId) stageId
      ,mx.maxFileRequestId fileRequestId
"	  ,'928' policySource"
"	  ,left(ml.groupPolicyNumber, 6) policyGroup"
      ,left(ml.policyNumber, 9) policyNumber
      ,left(ml.subscriberSsn, 9) subscriberSsn
      ,left(ml.firstName, 10) firstName
      ,left(ml.lastName, 20) lastName
      ,left(ml.relationship, 2) relationship
      ,left(ml.patientSsn, 9) patientSsn
      ,ml.birthdate
      ,left(ml.gender, 1)
      ,ml.startDate
      ,ml.endDate
      ,ml.enterpriseSubscriberId
      ,ml.subscriberPrimaryNumber
"	  ,ml.isTemporaryMember"
      ,ml.enterprisePatientId tempEnterprisePatientId
  from memberList ml
 cross apply maximum mx
    -- fail safe, make sure the eligibility dates were added, if not address this manually until they are
" where cast(eligibilityConfirmedId as int) = 1;  	1	2019-09-19 12:29:55.6233333	mssql"
"108	34	MEMBER-UPDATE_MANUAL_MEMBERS	 -- if we receive a member that did not replicate"
#NAME?
#NAME?
#NAME?
merge into Patient.PatientDim m
using (select distinct m.fileRequestId
             ,p.clientId
             ,p0.patientId
         from EdmStage.COC_Member m
         join Patient.PatientDim p on m.tempEnterprisePatientId = p.enterprisePatientId
                                  and p.clientId = 34
                                  and p.recordTypeId = 13
         join Patient.PatientDim p0 on m.enterprisePatientId = p0.enterprisePatientId
                                           and p0.clientId = 34
        where m.enterprisePatientId is not null) u
 on m.clientId = u.clientId
 and m.patientId = u.patientId
 when matched then update set m.patientActiveFlag = 0
 ,m.updateDateTime = sysdatetime();

merge into Patient.PatientDim m
using (select m.fileRequestId
             ,p.clientId
             ,p.patientId
             ,min(m.enterprisePatientId) enterprisePatientId
             ,m.tempEnterprisePatientId
         from EdmStage.COC_Member m
         join Patient.PatientDim p on m.tempEnterprisePatientId = p.enterprisePatientId
                                  and p.clientId = 34
                                  and p.recordTypeId = 13
        where m.enterprisePatientId is not null
"		group by m.fileRequestId"
"		,p.clientId"
"		,p.patientId"
"		,m.tempEnterprisePatientId) u"
   on m.clientId = u.clientId
  and m.patientId = u.patientId
 when matched then update set m.enterprisePatientId = u.enterprisePatientId
                             ,m.tempEnterprisePatientId = u.tempEnterprisePatientId
                             ,m.recordTypeId = 28
                             ,m.updateDateTime = sysdatetime()
"                             ,m.fileRequestId = u.fileRequestId;	1	2019-09-19 12:29:55.7200000	mssql"
"109	34	COC_BCBS_PREPROCESS-9999-MERGE_BCBS_LOCATION_NUMBER	declare @fileRequestId bigint = :fileRequestId ;"

#NAME?
#NAME?
drop table if exists tempdb.dbo.##COC_ProviderBCBS_existingLocation;

select distinct s.stageId
               ,a.locationNumber
into ##COC_ProviderBCBS_existingLocation
from EdmStage.COC_ProviderBCBS s
join Provider.ProviderDim p on s.providerNumber = p.providerPrimaryNumber
                           and p.clientId = 34
join Provider.AddressDim a on p.clientId = a.clientId
                          and p.providerId = a.providerId
                          and s.addressLine1 = a.line1
                          and isnull(s.addressLine2, '~') = isnull(a.line2, '~')
                          and s.city = a.city
                          and s.state = a.state
                          and s.zip = a.zip
                          and a.activeFlag = 1
"						  and a.locationNumber <> a.npi"
where s.addressLine1 is not null
  and ((s.city is not null and s.state is not null)
     or s.zip is not null)
  and s.fileRequestId = @fileRequestId
  and a.locationNumber is not null;

#NAME?
merge into EdmStage.COC_ProviderBCBS p
using ##COC_ProviderBCBS_existingLocation el
   on p.stageId = el.stageId
 when matched
 then update set p.locationNumber = el.locationNumber;

#NAME?
#NAME?
drop table if exists tempdb.dbo.##COC_ProviderBCBS_nolocation;

select *
  into ##COC_ProviderBCBS_nolocation
  from EdmStage.COC_ProviderBCBS
 where locationNumber is null;

#NAME?
drop table if exists tempdb.dbo.##COC_ProviderBCBS_maxlocation;

select nl.providerNumber
      ,cast(isnull(max(a.locationNumber),0) as int) maxLocationNumber
  into ##COC_ProviderBCBS_maxlocation
  from ##COC_ProviderBCBS_nolocation nl
  left join Provider.ProviderDim p on nl.providerNumber = p.providerPrimaryNumber
                                  and p.clientId = 34
  left join Provider.AddressDim a on p.clientId = a.clientId
                                 and p.providerId = a.providerId
"						         and a.locationNumber <> a.npi"
 group by nl.providerNumber;

#NAME?
drop table if exists tempdb.dbo.##COC_ProviderBCBS_denseranked;

select  s.stageId
       ,s.providerNumber
       ,cast(dense_rank() over(partition by s.providerNumber order by s.addressLine1, s.addressLine2, s.city,s.state, s.zip) as int) locationNumber
into  ##COC_ProviderBCBS_denseranked
from EdmStage.COC_ProviderBCBS s
left join Provider.ProviderDim p on s.providerNumber = p.providerPrimaryNumber
                                and p.clientId = 34
left join Provider.AddressDim a on p.clientId = a.clientId
                               and p.providerId = a.providerId
                               and s.addressLine1 = a.line1
                               and isnull(s.addressLine2, '~') = isnull(a.line2, '~')
                               and s.city = a.city
                               and s.state = a.state
                               and s.zip = a.zip
                               and a.activeFlag = 1
"						       and a.locationNumber <> a.npi"
where s.addressLine1 is not null
  and ((s.city is not null and s.state is not null)
     or s.zip is not null)
  and s.fileRequestId = @fileRequestId
  and a.addressId is null;

#NAME?
merge into ##COC_ProviderBCBS_denseranked dr
using ##COC_ProviderBCBS_maxlocation ml
   on dr.providerNumber = ml.providerNumber
 when matched
 then update set dr.locationNumber = dr.locationNumber + ml.maxLocationNumber;

#NAME?
merge into EdmStage.COC_ProviderBCBS s
using ##COC_ProviderBCBS_denseranked dr
   on s.stageId = dr.stageId
 when matched
" then update set s.locationNumber = right('000' + cast(dr.locationNumber as varchar(5)), 4); 	1	2019-09-18 12:00:00.0000000	mssql"
"110	61	INSERT_LasVegasBeechStreetIntoLocal711	truncate table EdmStage.Local711_ProviderBeechStreet;"

insert into EdmStage.Local711_ProviderBeechStreet
SELECT [stageId]
      ,:fileRequestId [fileRequestId]
      ,[recType]
      ,[updateType]
      ,[extractDate]
      ,[providerId]
      ,[providerType]
      ,[facCode]
      ,[corpName]
      ,[aliasCorpName]
      ,[providerLastName]
      ,[providerFirstName]
      ,[providerMiddleName]
      ,[providerSuffix]
      ,[degree]
      ,[dateOfBirth]
      ,[languageCode]
      ,[providerAliasLastName]
      ,[providerAliasFirstname]
      ,[providerAliasMiddleName]
      ,[providerAliasSuffix]
      ,[tin]
      ,[tinType]
      ,[addressType]
      ,[addressLine1]
      ,[addressLine2]
      ,[suite]
      ,[city]
      ,[state]
      ,[zip]
      ,[county]
      ,[country]
      ,[msa]
      ,[latitude]
      ,[longitude]
      ,[billingAddressLine1]
      ,[billingAddressLine2]
      ,[billingSuite]
      ,[billingCity]
      ,[billingState]
      ,[billingZip]
      ,[billingCounty]
      ,[billingCountry]
      ,[billingMSA]
      ,[billingLatitude]
      ,[billingLongitude]
      ,[locationId]
      ,[phone]
      ,[productId]
      ,[marketDesc]
      ,[effectiveDate]
      ,[termDate]
      ,[specCode]
      ,[roleCode]
      ,[demoSsn]
      ,[npi]
      ,[licenseNumber]
      ,[boardCertId]
      ,[upin]
      ,[networkCode]
      ,[patAcceptInd]
      ,[hospAffiliation]
      ,[locationNumber]
"  FROM [EdmStage].[LasVegas_ProviderBeechStreet]; 	1	2019-10-11 19:50:49.9933333	mssql"
"111	51	INSERT_MISSING_Providers	insert into Provider.ProviderDim "
       (clientId 
       ,providerPrimaryNumber 
       ,providerPrimaryNumberQualifier 
       ,providerTypeCode 
       ,providerFirstName 
       ,providerLastOrOrgName 
       ,entityTypeQualifier 
       ,recordTypeCode 
       ,transactionSetCreationDateTime 
       ,headerStandardRowNumber 
       ,detailStandardRowNumber 
       ,fileRequestId 
       ,createDateTime 
       ,providerActiveFlag) 
select 51 clientId  
"	   ,r.providerId providerPrimaryNumber  "
"	   ,'G2' providerPrimaryNumberQualifier  "
"	   ,'12' providerTypeCode  "
"	   ,min(r.providerFirstName) providerFirstName  "
"	   ,min(case when r.providerLastName is not null then r.providerLastName else r.corpName end) providerLastOrOrgName  "
"	   ,case when r.providerLastName is not null then '1'  "
"	         when r.corpName is not null then '2'  "
"	         else 3  "
"	    end entityTypeQualifier  "
"	   ,'PF' recordTypeCode  "
"	   ,getdate() transactionSetCreationDateTime  "
"	   ,min(r.stageId) headerStandardRowNumber  "
"	   ,min(r.stageId) detailStandardRowNumber  "
"	   ,r.fileRequestId fileRequestId  "
      ,getdate() createDateTime 
      ,1 providerActiveFlag 
  from EdmStage.LasVegas_ProviderBeechStreet r  
  left join Provider.ProviderDim pd on pd.providerPrimaryNumber = r.providerId  
                                   and pd.clientId = 51  
"								   and pd.providerActiveFlag = 1  "
 where r.fileRequestId = :fileRequestId  
   and pd.providerId is null  
 group by clientId  
"	      ,r.providerId  "
"		  ,r.fileRequestId  "
"		  ,case when r.providerLastName is not null then '1'  "
"	            when r.corpName is not null then '2'  "
"	            else 3  "
"	       end	1	2019-10-12 10:04:41.7000000	mssql"
"112	51	INSERT_ProviderTemp1	insert into EdmStage.LasVegas_ProviderBeechStreetTemp1 "
      (stageId
      ,fileRequestId
      ,recType
      ,updateType
      ,extractDate
      ,providerId
      ,providerType
      ,facCode
      ,corpName
      ,aliasCorpName
      ,providerLastName
      ,providerFirstName
      ,providerMiddleName
      ,providerSuffix
      ,degree
      ,dateOfBirth
      ,languageCode
      ,providerAliasLastName
      ,providerAliasFirstname
      ,providerAliasMiddleName
      ,providerAliasSuffix
      ,tin
      ,tinType
      ,addressType
      ,addressLine1
      ,addressLine2
      ,suite
      ,city
      ,state
      ,zip
      ,county
      ,country
      ,msa
      ,latitude
      ,longitude
      ,billingAddressLine1
      ,billingAddressLine2
      ,billingSuite
      ,billingCity
      ,billingState
      ,billingZip
      ,billingCounty
      ,billingCountry
      ,billingMSA
      ,billingLatitude
      ,billingLongitude
      ,locationId
      ,phone
      ,productId
      ,marketDesc
      ,effectiveDate
      ,termDate
      ,specCode
      ,roleCode
      ,demoSsn
      ,npi
      ,licenseNumber
      ,boardCertId
      ,upin
      ,networkCode
      ,patAcceptInd
      ,hospAffiliation
      ,clientId
      ,edmProviderId)
select r.stageId
      ,r.fileRequestId
      ,r.recType
      ,r.updateType
      ,r.extractDate
      ,r.providerId
      ,r.providerType
      ,r.facCode
      ,r.corpName
      ,r.aliasCorpName
      ,r.providerLastName
      ,r.providerFirstName
      ,r.providerMiddleName
      ,r.providerSuffix
      ,r.degree
      ,r.dateOfBirth
      ,r.languageCode
      ,r.providerAliasLastName
      ,r.providerAliasFirstname
      ,r.providerAliasMiddleName
      ,r.providerAliasSuffix
      ,r.tin
      ,r.tinType
      ,r.addressType
      ,r.addressLine1
      ,r.addressLine2
      ,r.suite
      ,r.city
      ,r.state
      ,r.zip
      ,r.county
      ,r.country
      ,r.msa
      ,r.latitude
      ,r.longitude
      ,r.billingAddressLine1
      ,r.billingAddressLine2
      ,r.billingSuite
      ,r.billingCity
      ,r.billingState
      ,r.billingZip
      ,r.billingCounty
      ,r.billingCountry
      ,r.billingMSA
      ,r.billingLatitude
      ,r.billingLongitude
      ,r.locationId
      ,r.phone
      ,r.productId
      ,r.marketDesc
      ,r.effectiveDate
      ,r.termDate
      ,r.specCode
      ,r.roleCode
      ,r.demoSsn
      ,r.npi
      ,r.licenseNumber
      ,r.boardCertId
      ,r.upin
      ,r.networkCode
      ,r.patAcceptInd
      ,r.hospAffiliation
      ,pd.clientId
      ,pd.providerId edmProviderId
  from EdmStage.LasVegas_ProviderBeechStreet r
  join Provider.ProviderDim pd on r.providerId = pd.providerPrimaryNumber
                              and pd.clientId = 51
                              and pd.providerActiveFlag = 1
" where r.fileRequestId = :fileRequestId 	1	2019-10-12 10:08:22.1400000	mssql"
"113	51	INSERT_MISSING_Address	insert into Provider.AddressDim "
      (clientId 
"	   ,providerId "
"	   ,fileRequestId "
"	   ,stageId "
"	   ,transactionSetCreationDateTime "
"	   ,npi "
"	   ,addressTypeId "
"	   ,line1 "
"	   ,line2 "
"	   ,city "
"	   ,state "
"	   ,zip "
"	   ,zip4 "
"	   ,locationNumber "
"	   ,activeFlag) "
select clientId 
"	   ,providerId "
"	   ,fileRequestId "
"	   ,stageId "
"	   ,sysdatetime() transactionSetCreationDateTime "
"	   ,npi "
"	   ,addressTypeId "
"	   ,line1 "
"	   ,line2 "
"	   ,city "
"	   ,state "
"	   ,zip "
"	   ,zip4 "
"	   ,right('0000' + cast(currentLocationNumber + rnk as varchar(7)), 5) locationNumber "
"	   ,1 activeFlag "
  from (select t1.clientId 
              ,t1.edmProviderId providerId 
"	           ,t1.fileRequestId "
"	           ,min(t1.stageId) over(partition by t1.clientId, t1.edmProviderId)  stageId "
"			   ,ad.addressId"
"	           ,t1.npi "
"	           ,16 addressTypeId "
"	           ,t1.addressLine1 line1 "
"	           ,t1.addressLine2 line2 "
"	           ,ltrim(upper(t1.city)) city "
"	           ,ltrim(upper(t1.state)) state "
"	           ,case when len(t1.zip) > 4 then substring(t1.zip, 1, 5) end zip "
"	           ,case when len(t1.zip) > 5 then substring(replace(t1.zip, '-', ''), 6, 4) end zip4  "
"	           ,isnull(cast(max(ad.locationNumber) over(partition by t1.clientId, t1.edmProviderId) as int), 0) currentLocationNumber "
"	           ,sum(case when t1.edmProviderId = ad.providerId and"
"			                  t1.addressLine1 = ad.line1 and "
                              (t1.npi = ad.npi or (t1.npi is null and ad.npi is null)) and 
                              (t1.addressLine2 = ad.line2 or (t1.addressLine2 is null and ad.line2 is null)) and 
"				              ltrim(upper(t1.city)) = ltrim(upper(ad.city)) and "
"					          ltrim(upper(t1.state)) = ltrim(upper(ad.state)) and "
"				              replace(t1.zip, '-', '') = replace(concat(ad.zip, ad.zip4), '-', '') "
"			             then 1 "
"				         else 0 "
"	            end) over(partition by t1.clientId, t1.edmProviderId, t1.addressLine1, t1.npi, t1.addressLine2, t1.city, t1.state, t1.zip) addressCount "
"	           ,dense_rank() over(partition by t1.clientId, t1.edmProviderId  "
"	                              order by case when t1.addressLine1 = ad.line1 and "
                                                     (t1.npi = ad.npi or (t1.npi is null and ad.npi is null)) and 
                                                     (t1.addressLine2 = ad.line2 or (t1.addressLine2 is null and ad.line2 is null)) and 
                                                     ltrim(upper(t1.city)) = ltrim(upper(ad.city)) and 
                                                     ltrim(upper(t1.state)) = ltrim(upper(ad.state)) and 
                                                     replace(t1.zip, '-', '') = replace(concat(ad.zip, ad.zip4), '-', '') 
"			                                    then 1 "
"				                                else 0 "
"	                                       end "
"							              ,t1.addressLine1 "
"							              ,t1.addressLine2 "
"							              ,t1.city "
"							              ,t1.state "
"							              ,t1.zip) rnk "
          from EdmStage.LasVegas_ProviderBeechStreetTemp1 t1 
          left join Provider.AddressDim ad on t1.edmProviderId = ad.providerId 
                                          and t1.clientId = ad.clientId 
"								          and ad.addressTypeId = 16 -- practice location "
"								          and ad.activeFlag = 1 "
         where t1.fileRequestId = :fileRequestId) x 
 where addressCount = 0 
 group by clientId 
"		  ,providerId "
"		  ,npi"
"		  ,fileRequestId "
"		  ,stageId "
"		  ,addressTypeId "
"		  ,line1 "
"		  ,line2 "
"		  ,city "
"		  ,state "
"		  ,zip "
"		  ,zip4 "
"		  ,right('0000' + cast(currentLocationNumber + rnk as varchar(7)), 5); 	1	2019-10-12 10:13:22.9800000	mssql"
"114	51	INSERT_Provider_Stage	insert "
  into EdmStage.LasVegas_ProviderBeechStreetStage 
      (stageId 
      ,fileRequestId 
      ,recType 
      ,updateType 
      ,extractDate 
      ,providerId 
      ,providerType 
      ,facCode 
      ,corpName 
      ,aliasCorpName 
      ,providerLastName 
      ,providerFirstName 
      ,providerMiddleName 
      ,providerSuffix 
      ,degree 
      ,dateOfBirth 
      ,languageCode 
      ,providerAliasLastName 
      ,providerAliasFirstname 
      ,providerAliasMiddleName 
      ,providerAliasSuffix 
      ,tin 
      ,tinType 
      ,addressType 
      ,addressLine1 
      ,addressLine2 
      ,suite 
      ,city 
      ,state 
      ,zip 
      ,county 
      ,country 
      ,msa 
      ,latitude 
      ,longitude 
      ,billingAddressLine1 
      ,billingAddressLine2 
      ,billingSuite 
      ,billingCity 
      ,billingState 
      ,billingZip 
      ,billingCounty 
      ,billingCountry 
      ,billingMSA 
      ,billingLatitude 
      ,billingLongitude 
      ,locationId 
      ,phone 
      ,productId 
      ,marketDesc 
      ,effectiveDate 
      ,termDate 
      ,specCode 
      ,roleCode 
      ,demoSsn 
      ,npi 
      ,licenseNumber 
      ,boardCertId 
      ,upin 
      ,networkCode 
      ,patAcceptInd 
      ,hospAffiliation 
      ,clientId 
      ,edmProviderId 
      ,locationNumber) 
select t1.stageId 
      ,t1.fileRequestId 
      ,t1.recType 
      ,t1.updateType 
      ,t1.extractDate 
      ,t1.providerId 
      ,t1.providerType 
      ,t1.facCode 
      ,t1.corpName 
      ,t1.aliasCorpName 
      ,t1.providerLastName 
      ,t1.providerFirstName 
      ,t1.providerMiddleName 
      ,t1.providerSuffix 
      ,t1.degree 
      ,t1.dateOfBirth 
      ,t1.languageCode 
      ,t1.providerAliasLastName 
      ,t1.providerAliasFirstname 
      ,t1.providerAliasMiddleName 
      ,t1.providerAliasSuffix 
      ,t1.tin 
      ,t1.tinType 
      ,t1.addressType 
      ,t1.addressLine1 
      ,t1.addressLine2 
      ,t1.suite 
      ,t1.city 
      ,t1.state 
      ,t1.zip 
      ,t1.county 
      ,t1.country 
      ,t1.msa 
      ,t1.latitude 
      ,t1.longitude 
      ,t1.billingAddressLine1 
      ,t1.billingAddressLine2 
      ,t1.billingSuite 
      ,t1.billingCity 
      ,t1.billingState 
      ,t1.billingZip 
      ,t1.billingCounty 
      ,t1.billingCountry 
      ,t1.billingMSA 
      ,t1.billingLatitude 
      ,t1.billingLongitude 
      ,t1.locationId 
      ,t1.phone 
      ,t1.productId 
      ,t1.marketDesc 
      ,t1.effectiveDate 
      ,t1.termDate 
      ,t1.specCode 
      ,t1.roleCode 
      ,t1.demoSsn 
      ,t1.npi 
      ,t1.licenseNumber 
      ,t1.boardCertId 
      ,t1.upin 
      ,t1.networkCode 
      ,t1.patAcceptInd 
      ,t1.hospAffiliation 
      ,t1.clientId 
      ,t1.edmProviderId 
      ,ad.locationNumber  
  from EdmStage.LasVegas_ProviderBeechStreetTemp1 t1  
  join Provider.AddressDim ad on t1.edmProviderId = ad.providerId  
                             and t1.clientId = ad.clientId  
"						      and ad.addressTypeId = 16 -- practice location  "
"						      and ad.activeFlag = 1 "
"						      and (t1.npi = ad.npi or (t1.npi is null and ad.npi is null)) "
"							  and t1.addressLine1 = ad.line1 "
"							  and (t1.addressLine2 = ad.line2 or (t1.addressLine2 is null and ad.line2 is null)) "
"							  and ltrim(upper(t1.city)) = ad.city "
"							  and ltrim(upper(t1.state)) = ad.state "
"							  and replace(t1.zip, '-', '') = replace(concat(ad.zip, ad.zip4), '-', '') "
" where t1.fileRequestId = :fileRequestId 	1	2019-10-12 10:15:22.0800000	mssql"
"115	51	INSERT_Provider_Final	insert into EdmStage.LasVegas_ProviderBeechStreet "
select stageId 
      ,fileRequestId 
      ,recType 
      ,updateType 
      ,extractDate 
      ,providerId 
      ,providerType 
      ,facCode 
      ,corpName 
      ,aliasCorpName 
      ,providerLastName 
      ,providerFirstName 
      ,providerMiddleName 
      ,providerSuffix 
      ,degree 
      ,dateOfBirth 
      ,languageCode 
      ,providerAliasLastName 
      ,providerAliasFirstname 
      ,providerAliasMiddleName 
      ,providerAliasSuffix 
      ,tin 
      ,tinType 
      ,addressType 
      ,addressLine1 
      ,addressLine2 
      ,suite 
      ,city 
      ,state 
      ,zip 
      ,county 
      ,country 
      ,msa 
      ,latitude 
      ,longitude 
      ,billingAddressLine1 
      ,billingAddressLine2 
      ,billingSuite 
      ,billingCity 
      ,billingState 
      ,billingZip 
      ,billingCounty 
      ,billingCountry 
      ,billingMSA 
      ,billingLatitude 
      ,billingLongitude 
      ,locationId 
      ,phone 
      ,productId 
      ,marketDesc 
      ,effectiveDate 
      ,termDate 
      ,specCode 
      ,roleCode 
      ,demoSsn 
      ,npi 
      ,licenseNumber 
      ,boardCertId 
      ,upin 
      ,networkCode 
      ,patAcceptInd 
      ,hospAffiliation 
      ,locationNumber 
  from EdmStage.LasVegas_ProviderBeechStreetStage
" where fileRequestId = :fileRequestId 	1	2019-10-12 10:17:00.6500000	mssql"
"116	0	STRIVE_MEMBER-ADD_NEW_GROUP_POLICIES	declare @clientId int = :clientId ;"

insert into Reference.GroupPolicy
(clientId, groupPolicyNumber, groupPolicyCategory, groupPolicyName, groupPolicySource, createDate) 
select @clientId,  groupName groupPolicyNumber, groupName groupPolicyCategory, groupName groupPolicyName, c.clientCode, sysdatetime()
  from <tableSchema>.<tableName> m
  join Reference.Client c on c.clientId = @clientId
  left join Reference.GroupPolicy gp on c.clientId = gp.clientId
                                    and m.groupName = gp.groupPolicyNumber
 where ascii(trim(m.groupName)) is not null
   and gp.groupPolicyId is null
" group by m.groupName, c.clientCode; 	1	2019-11-07 16:38:31.0900000	mssql"
"117	0	STRIVE_MEMBER-ADD_NEW_PLANS	declare @clientId int = :clientId ;"

insert into Reference.Plans
(clientId, planNumber, planName, planDesc, planSource, createDate, planEffectiveDate, plansActiveFlag, planMedicareInd, planExclusion) 
select @clientId,  m.insurancePlan planNumber, insurancePlan planName, insurancePlan planDesc, c.clientCode planSource, sysdatetime(), '2020-01-01', 1, 0, 0
  from <tableSchema>.<tableName> m
  join Reference.Client c on c.clientId = @clientId
  left join Reference.Plans pl on c.clientId = pl.clientId
                              and m.insurancePlan = pl.planNumber
 where ascii(trim(m.insurancePlan)) is not null
   and pl.plansId is null
" group by m.insurancePlan, c.clientCode; 	1	2019-11-07 16:39:07.5333333	mssql"
"118	0	STRIVE_MEMBER-MISSING_MPI_COUNT	declare @clientId int = :clientId ;"
"select count(*) from <tableSchema>.<tableName> where enterprisePatientId is null	1	2019-11-13 15:02:31.8700000	mssql"
"119	0	STRIVE_MEMBER-INSERT_BULK_REQUEST_STAGE	declare @clientId int = :clientId ;"

insert into MPI.BulkRequestStage 
       (BulkRequestStageId 
       ,ClientIdentifier 
       ,OriginalPatientIdentifier 
       ,CurrentPatientIdentifier 
       ,PolicyNumber 
       ,FirstName 
       ,MiddleName 
       ,LastName 
       ,SSN 
       ,DOB 
       ,Gender 
       ,AddressLine1 
       ,AddressLine2 
       ,City 
       ,State 
       ,ZIP 
       ,Telephone)
select stageId BulkRequestStageId
"	  ,c.clientCode ClientIdentifier "
      ,x.employeeID OriginalPatientIdentifier 
"	  ,null CurrentPatientIdentifier "
"	  ,x.employeeID PolicyNumber "
"	  ,firstName FirstName "
"	  ,null MiddleName "
"	  ,lastName LastName "
"	  ,null SSN"
"	  ,left(convert(date, birthDate, 101), 4) +'-'+ right(left(convert(date, birthDate, 101), 7), 2) +'-'+ right(convert(date, birthDate, 101), 2) + ' 00:00:00'  DOB "
"	  ,gender Gender "
"	  ,null AddressLine1 "
"	  ,null AddressLine2 "
"	  ,null City "
"	  ,null State "
"	  ,null ZIP "
"	  ,null Telephone"
  from <tableSchema>.<tableName> x
  join Reference.Client c on c.clientId = @clientId
" where fileRequestId = :fileRequestId 	1	2019-11-13 15:14:14.2200000	mssql"
"120	0	STRIVE_MEMBER-MERGE_BULK_REQUEST_STAGE_DEDUP	declare @clientId int = :clientId ;"

merge into <tableSchema>.<tableName> m
using (select m0.fileRequestId
             ,m0.stageId
"       	     ,d.MPIID"
         from <tableSchema>.<tableName> m0
         join MPI.BulkRequestStageDedup d on m0.stageId = d.BulkRequestStageId
                                         and d.MPIID is not null
        where m0.enterprisePatientId is null
          and m0.fileRequestId = :fileRequestId) u
   on m.fileRequestId = u.fileRequestId
  and m.stageId = u.stageId
" when matched then update set m.enterprisePatientId = u.MPIID; 	1	2019-11-13 18:01:50.8866667	mssql"
"121	0	STRIVE_MEMBER-DUPLICATE_MPI_COUNT	declare @clientId int = :clientId ;"

select count(*)
  from (select enterprisePatientId
              ,count(*) recordCount
"	          ,string_agg(m.birthDate, ', ') within group (order by m.employeeId) birthDateList"
"	          ,count(distinct birthDate) birthDateCount"
"	          ,string_agg(m.gender, ', ')  within group (order by m.employeeId) genderList"
"	          ,count(distinct gender) genderCount"
"	          ,max(fileRequestId) fileRequestId"
"	          ,string_agg(m.stageId, ', ') within group (order by m.employeeId) stageIdList"
          from <tableSchema>.<tableName> m
         group by m.enterprisePatientId
        having count(distinct m.birthDate) > 1
"            or count(distinct m.gender) > 1) x  	1	2019-11-13 18:06:49.7400000	mssql"
"122	0	STRIVE_MEMBER-RETIRE_MEMBERS	declare @clientId int = :clientId ;"

with maximums as (select max(stageId) stageId, max(fileRequestId) fileRequestId from <tableSchema>.<tableName>)
insert into <tableSchema>.<tableName>
      (stageId
      ,fileRequestId
      ,enterprisePatientId
"	  ,tempEnterprisePatientId"
"	  ,originalEmployeeId"
"	  ,currentEmployeeId"
"	  ,firstName"
"	  ,lastName"
"	  ,birthDate"
"	  ,employeeId"
"	  ,email"
"	  ,location"
"	  ,division"
"	  ,department"
      ,groupName
"	  ,gender"
"	  ,wageType"
"	  ,insurancePlan"
"	  ,dateStarted"
"	  ,primaryInsured"
"	  ,fullTime"
"	  ,dateTerminated"
"	  ,hcFlag)"
select row_number() over(partition by 1 order by p.patientId) + m.stageId stageId
      ,m.fileRequestId
      ,p.enterprisePatientId
"	  ,p.tempEnterprisePatientId"
"	  ,null originalEmployeeId"
"	  ,null currentEmployeeId"
"	  ,p.patientFirstName firstName"
"	  ,p.patientLastName lastName"
"	  ,convert(varchar(10), p.patientBirthDate, 101) birthDate"
"	  ,p.patientPrimaryNumber employeeId"
"	  ,em.emailAddress email"
"	  ,p.location"
"	  ,p.division"
"	  ,p.department"
      ,case when gp.groupPolicyId > 9 then gp.groupPolicyNumber end groupName
"	  ,p.patientGenderCode gender"
"	  ,p.wageType"
"	  ,case when pl.plansId > 9 then pl.planNumber end insurancePlan"
"	  ,convert(varchar(10), e.benefitPlanStartDate, 101) dateStarted"
"	  ,case when p.relationshipCode = '18' then 'TRUE' when p.relationshipCode = '21' then null else 'FALSE' end primaryInsured"
"	  ,case when p.isFullTime = 1 then 'TRUE' when p.isFullTime = 0 then 'FALSE' end fullTime"
"	  ,convert(varchar(10), dateadd(day, -1, cast(year(sysdatetime()) as varchar(4)) + '-'+ cast(month(sysdatetime()) as varchar(2)) + '-01'), 101) dateTerminated"
"	  ,null hcFlag"
  from Patient.PatientDim p
 cross apply maximums m
  left join Patient.PatientDim sub on p.clientId = sub.clientId
                                  and p.enterpriseSubscriberId = sub.enterprisePatientId
"								  and p.recordTypeId = 28"
  left join Patient.EmailDim em on p.clientId = em.clientId
                               and p.patientId = em.patientId
"							   and em.activeFlag = 1"
  left join <tableSchema>.<tableName> s on p.enterprisePatientId = s.enterprisePatientId
  join Patient.EligibilityFact e on p.clientId = e.clientId
                                and p.patientId = e.patientId
"								and e.eligibilityFactActiveFlag = 1"
"								and (e.benefitPlanEndDate is null"
"								  or e.benefitPlanEndDate > sysdatetime())"
  join Reference.GroupPolicy gp on e.groupPolicyId = gp.groupPolicyId
  join Reference.Plans pl on e.benefitPlanId = pl.plansId
 where p.clientId = @clientId
   and p.patientActiveFlag = 1
"   and s.stageId is null; 	1	2019-11-13 18:26:58.9266667	mssql"
"123	0	STRIVE_MEMBER-TOTAL_RECORD_COUNT	declare @clientId int = :clientId ;"
"select count(*) from <tableSchema>.<tableName>	1	2019-11-13 19:10:38.6766667	mssql"
"124	0	INSERT_Missing_PatientEmailDim	insert into Patient.EmailDim"
(clientId
,patientId
,fileRequestId
,stageId
,recordTypeId
,communicationQualifierCode
,communicationQualifierId
,emailAddress
,activeFlag
,createDateTime)
select x.clientId
      ,x.patientId
"	  ,x.fileRequestId"
"	  ,x.stageId"
"	  ,x.recordTypeId"
"	  ,x.communicationQualifierCode"
"	  ,x.communicationQualifierId"
"	  ,x.emailAddress"
"	  ,1 activeFlag"
"	  ,sysdatetime() createDateTime"
  from (select r.clientId
              ,p.patientId
              ,r.fileRequestId
"        	  ,r.stageId stageId"
"        	  ,rt.recordTypeId"
"        	  ,r.primaryEmailAddressQualifier communicationQualifierCode"
"        	  ,cq.communicationQualifierId"
"        	  ,r.primaryEmailAddress emailAddress"
"        	  ,rank() over(partition by r.clientId, p.patientId order by r.stageId desc) rnk"
          from EdmStandard.Member r
          join Patient.PatientDim p on r.enterprisePatientId = p.enterprisePatientId
                                   and r.ClientId = p.clientId
"         						  and p.patientActiveFlag = 1"
          join Reference.RecordType rt on rt.RecordTypeCode = 'MF'
          left join Patient.EmailDim em on r.clientId = em.clientId
                                       and p.patientId = em.patientId
"         						      and em.activeFlag = 1"
          left join Reference.CommunicationQualifier cq on r.primaryEmailAddressQualifier = cq.communicationQualifierCode
         where r.fileRequestId = :fileRequestId
           and ascii(trim(r.primaryEmailAddress)) is not null
           and em.emailId is null) x
" where rnk = 1 ;	1	2019-11-13 20:39:39.1400000	mssql"
"125	0	STRIVE_MEMBER_ADDRESS-INSERT_BULK_REQUEST_STAGE	declare @clientId int = :clientId ;"

insert into MPI.BulkRequestStage 
       (BulkRequestStageId 
       ,ClientIdentifier 
       ,OriginalPatientIdentifier 
       ,CurrentPatientIdentifier 
       ,PolicyNumber 
       ,FirstName 
       ,MiddleName 
       ,LastName 
       ,SSN 
       ,DOB 
       ,Gender 
       ,AddressLine1 
       ,AddressLine2 
       ,City 
       ,State 
       ,ZIP 
       ,Telephone)
select stageId BulkRequestStageId
"	  ,c.clientCode ClientIdentifier "
      ,x.employeeID OriginalPatientIdentifier 
"	  ,null CurrentPatientIdentifier "
"	  ,x.employeeID PolicyNumber "
"	  ,isnull(firstName, 'Unknown') FirstName "
"	  ,null MiddleName "
"	  ,isnull(lastName, 'Unknown') LastName "
"	  ,case when len(employeeTaxID)>8 then employeeTaxID end SSN"
"	  ,left(convert(date, birthDate, 101), 4) +'-'+ right(left(convert(date, birthDate, 101), 7), 2) +'-'+ right(convert(date, birthDate, 101), 2) + ' 00:00:00'  DOB "
"	  ,gender Gender "
"	  ,addressLine1 AddressLine1 "
"	  ,addressLine2 AddressLine2 "
"	  ,cityName City "
"	  ,stateCode State "
"	  ,postalZoneCode ZIP "
"	  ,primaryTelephoneNumber Telephone"
from <tableSchema>.<tableName> x
join Reference.Client c on c.clientId = @clientId
"where fileRequestId = :fileRequestId 	1	2019-12-03 13:44:00.0000000	mssql"
"126	0	STRIVE_MEMBER_ADDRESS-MERGE_BULK_REQUEST_STAGE_DEDUP	declare @clientId int = :clientId ;"

merge into <tableSchema>.<tableName> m
using (select m0.fileRequestId
             ,m0.stageId
"       	     ,d.MPIID"
         from <tableSchema>.<tableName> m0
         join MPI.BulkRequestStageDedup d on m0.stageId = d.BulkRequestStageId
                                         and d.MPIID is not null
        where m0.enterprisePatientId is null
          and m0.fileRequestId = :fileRequestId) u
   on m.fileRequestId = u.fileRequestId
  and m.stageId = u.stageId
" when matched then update set m.enterprisePatientId = u.MPIID; 	1	2019-12-03 13:44:00.0000000	mssql"
"127	0	STRIVE_MEMBER_ADDRESS-MISSING_MPI_COUNT	declare @clientId int = :clientId ;"
"select count(*) from <tableSchema>.<tableName> where enterprisePatientId is null	1	2019-12-03 13:44:00.0000000	mssql"
"128	0	STRIVE_MEMBER_ADDRESS-DUPLICATE_MPI_COUNT	declare @clientId int = :clientId ;"

select count(*)
  from (select enterprisePatientId
              ,count(*) recordCount
"	          ,string_agg(m.birthDate, ', ') within group (order by m.employeeId) birthDateList"
"	          ,count(distinct birthDate) birthDateCount"
"	          ,string_agg(m.gender, ', ')  within group (order by m.employeeId) genderList"
"	          ,count(distinct gender) genderCount"
"	          ,max(fileRequestId) fileRequestId"
"	          ,string_agg(m.stageId, ', ') within group (order by m.employeeId) stageIdList"
          from <tableSchema>.<tableName> m
         group by m.enterprisePatientId
        having count(distinct m.birthDate) > 1
"            or count(distinct m.gender) > 1) x  	1	2019-12-03 13:44:00.0000000	mssql"
"129	0	STRIVE_MEMBER_ADDRESS-TOTAL_RECORD_COUNT	declare @clientId int = :clientId ;"
"select count(*) from <tableSchema>.<tableName>	1	2019-12-03 13:44:00.0000000	mssql"
"130	0	STRIVE_MEMBER_ADDRESS-ADD_NEW_GROUP_POLICIES	declare @clientId int = :clientId ;"

insert into Reference.GroupPolicy
(clientId, groupPolicyNumber, groupPolicyCategory, groupPolicyName, groupPolicySource, createDate) 
select @clientId,  groupName groupPolicyNumber, groupName groupPolicyCategory, groupName groupPolicyName, c.clientCode, sysdatetime()
  from <tableSchema>.<tableName> m
  join Reference.Client c on c.clientId = @clientId
  left join Reference.GroupPolicy gp on c.clientId = gp.clientId
                                    and m.groupName = gp.groupPolicyNumber
 where ascii(trim(m.groupName)) is not null
   and gp.groupPolicyId is null
" group by m.groupName, c.clientCode; 	1	2019-12-03 13:44:00.0000000	mssql"
"131	0	STRIVE_MEMBER_ADDRESS-ADD_NEW_PLANS	declare @clientId int = :clientId ;"

insert into Reference.Plans
(clientId, planNumber, planName, planDesc, planSource, createDate, planEffectiveDate, plansActiveFlag, planMedicareInd, planExclusion) 
select @clientId,  m.insurancePlan planNumber, insurancePlan planName, insurancePlan planDesc, c.clientCode planSource, sysdatetime(), '2020-01-01', 1, 0, 0
  from <tableSchema>.<tableName> m
  join Reference.Client c on c.clientId = @clientId
  left join Reference.Plans pl on c.clientId = pl.clientId
                              and m.insurancePlan = pl.planNumber
 where ascii(trim(m.insurancePlan)) is not null
   and pl.plansId is null
" group by m.insurancePlan, c.clientCode; 	1	2019-12-03 13:44:00.0000000	mssql"
"132	0	STRIVE_MEMBER_ADDRESS-RETIRE_MEMBERS	declare @clientId int = :clientId ;"

with maximums as (select max(stageId) stageId, max(fileRequestId) fileRequestId from <tableSchema>.<tableName>)
insert into <tableSchema>.<tableName>
"	  (stageId"
"	  ,fileRequestId"
"	  ,enterprisePatientId"
"	  ,tempEnterprisePatientId"
"	  ,originalEmployeeId"
"	  ,currentEmployeeId"
"	  ,firstName"
"	  ,lastName"
"	  ,birthDate"
"	  ,employeeId"
"	  ,email"
"	  ,location"
"	  ,division"
"	  ,department"
"	  ,groupName"
"	  ,gender"
"	  ,wageType"
"	  ,insurancePlan"
"	  ,dateStarted"
"	  ,primaryInsured"
"	  ,fullTime"
"	  ,dateTerminated"
"	  ,hcFlag"
"	  ,addressLine1"
"	  ,addressLine2"
"	  ,cityName"
"	  ,stateCode"
"	  ,postalZoneCode"
"	  ,primaryTelephoneNumber)"
select row_number() over(partition by 1 order by p.patientId) + m.stageId stageId
"	  ,m.fileRequestId"
"	  ,p.enterprisePatientId"
"	  ,p.tempEnterprisePatientId"
"	  ,null originalEmployeeId"
"	  ,null currentEmployeeId"
"	  ,p.patientFirstName firstName"
"	  ,p.patientLastName lastName"
"	  ,convert(varchar(10), p.patientBirthDate, 101) birthDate"
"	  ,p.patientPrimaryNumber employeeId"
"	  ,em.emailAddress email"
"	  ,p.location"
"	  ,p.division"
"	  ,p.department"
"	  ,case when gp.groupPolicyId > 9 then gp.groupPolicyNumber end groupName"
"	  ,p.patientGenderCode gender"
"	  ,p.wageType"
"	  ,case when pl.plansId > 9 then pl.planNumber end insurancePlan"
"	  ,convert(varchar(10), e.benefitPlanStartDate, 101) dateStarted"
"	  ,case when p.relationshipCode = '18' then 'TRUE' when p.relationshipCode = '21' then null else 'FALSE' end primaryInsured"
"	  ,case when p.isFullTime = 1 then 'TRUE' when p.isFullTime = 0 then 'FALSE' end fullTime"
"	  ,convert(varchar(10), dateadd(day, -1, cast(year(sysdatetime()) as varchar(4)) + '-'+ cast(month(sysdatetime()) as varchar(2)) + '-01'), 101) dateTerminated"
"	  ,null hcFlag"
"	  ,ad.addressLine1 addressLine1"
"	  ,ad.addressLine2 addressLine2"
"	  ,ad.city cityName"
"	  ,ad.state stateCode"
"	  ,ad.zip postalZoneCode"
"	  ,null primaryTelephoneNumber"
from Patient.PatientDim p
cross apply maximums m
left join Patient.PatientDim sub on p.clientId = sub.clientId
"								and p.enterpriseSubscriberId = sub.enterprisePatientId"
"								and p.recordTypeId = 28"
left join Patient.EmailDim em on p.clientId = em.clientId
"								and p.patientId = em.patientId"
"								and em.activeFlag = 1"
left join Patient.AddressDim ad on p.clientId = ad.clientId
"								and p.patientId = ad.patientId"
"								and ad.activeFlag = 1"
left join <tableSchema>.<tableName> s on p.enterprisePatientId = s.enterprisePatientId
join Patient.EligibilityFact e on p.clientId = e.clientId
"								and p.patientId = e.patientId"
"								and e.eligibilityFactActiveFlag = 1"
"								and (e.benefitPlanEndDate is null"
"									or e.benefitPlanEndDate > sysdatetime())"
join Reference.GroupPolicy gp on e.groupPolicyId = gp.groupPolicyId
join Reference.Plans pl on e.benefitPlanId = pl.plansId
where p.clientId = @clientId
"	and p.patientActiveFlag = 1"
"	and s.stageId is null; "
"	1	2019-12-03 13:44:00.0000000	mssql"
"133	0	INSERT_INTO_FROM_X220	insert into <tableSchema>.<tableName>"
"	   (stageId "
"	   ,fileRequestId  "
"	   ,headerId  "
"	   ,detailId  "
      -- ,memberRank 
"	   ,patientPrimaryNumber  "
"	   ,patientPrimaryNumberQualifier  "
"	   ,subscriberPrimaryNumber  "
"	   ,subscriberPrimaryNumberQualifier  "
"	   ,originalMemberIdentifier  "
"	   ,memberSsnQualifier  "
"	   ,memberSsn  "
"	   ,benefitStatusCode  "
"	   ,relationshipCode  "
"	   ,maintenanceTypeCode  "
"	   ,maintenanceReasonCode  "
"	   ,medicarePlanCode  "
"	   ,medicareEligibilityReasonCode  "
"	   ,cobraQualifyingEventCode  "
"	   ,employmentStatusCode  "
"	   ,studentStatusCode  "
"	   ,handicapIndicator  "
"	   ,confidentialityCode  "
"	   ,birthSequenceNumber  "
"	   ,memberNameEntityIdentifierCode  "
"	   ,memberLastName  "
"	   ,memberFirstname  "
"	   ,memberMiddleName  "
"	   ,memberNamePrefix  "
"	   ,memberNameSuffix  "
"	   ,memberBirthDate  "
"	   ,memberDeathDate  "
"	   ,memberGenderCode  "
"	   ,memberMaritalStatusCode  "
"	   ,memberRaceCode  "
"	   ,memberCitizenshipStatusCode  "
"	   ,memberHealthRelatedCode  "
"	   ,memberHeight  "
"	   ,memberWeight  "
"	   ,groupPolicyNumber  "
"	   ,planNumber  "
       ,planBeginDate
       ,planEndDate
"	   ,memberCommunicationNumberQualifier  "
"	   ,memberCommunicationNumber  "
"	   ,memberCommunicationNumberQualifier2  "
"	   ,memberCommunicationNumber2  "
"	   ,memberCommunicationNumberQualifier3  "
"	   ,memberCommunicationNumber3  "
"	   ,memberPrimaryAddressLine1  "
"	   ,memberPrimaryAddressLine2  "
"	   ,memberPrimaryAddressCityName  "
"	   ,memberPrimaryAddressStateCode  "
"	   ,memberPrimaryAddressZipCode  "
"	   ,memberPrimaryAddressCountryCode  "
"	   ,memberPrimaryAddressLocationQualifier  "
"	   ,memberPrimaryAddressLocationIdentifier  "
"	   ,memberMailingAddressLine1  "
"	   ,memberMailingAddressLine2  "
"	   ,memberMailingAddressCityName  "
"	   ,memberMailingAddressStateCode  "
"	   ,memberMailingAddressZipCode  "
"	   ,memberMailingAddressCountryCode  "
"	   ,primaryCareProviderEntityIdentifierCode  	        "
"	   ,primaryCareProviderEntityTypeCode  "
"	   ,primaryCareProviderNPI  "
"	   ,primaryCareProviderLastOrOrganizationName  "
"	   ,primaryCareProviderFirstName  "
"	   ,primaryCareProviderAddressLine1  "
"	   ,primaryCareProviderAddressLine2  "
"	   ,primaryCareProviderCityName  "
"	   ,primaryCareProviderZipCode  "
"	   ,primaryCareProviderStateCode  "
"	   ,memberPriorIncorrectLastName  "
"	   ,memberPriorIncorrectFirstName  "
"	   ,memberPriorIncorrectMiddleName  "
"	   ,memberPriorIncorrectNamePrefix  "
"	   ,memberPriorIncorrectNameSuffix  "
"	   ,memberPriorIncorrectIdentificationCodeQualifier  "
"	   ,memberPriorIncorrectIdentificationCode  "
"	   ,memberPriorIncorrectBirthDate  "
"	   ,memberPriorIncorrectGenderCode  "
"	   ,memberPriorIncorrectMaritalStatusCode  "
"	   ,memberPriorIncorrectRaceCode  "
"	   ,memberPriorIncorrectCitizenshipStatusCode  "
"	   ,memberPriorIncorrectRaceCollectionCode "
"	   ,transactionSetCreationDateTime "
"	   ,memberLanguageCode "
"	   ,memberLanguageUseCode) "
select row_number() over(partition by 1 order by detailId) stageId 
"	  ,t.* "
  from (select d.fileRequestId  
              ,d.headerId  
              ,d.detailId  
              --,mid.REF_ReferenceIdentification memberRank  
              ,mli.REF_ReferenceIdentification patientPrimaryNumber  
              ,'MI' patientPrimaryNumberQualifier  
              ,mli.REF_ReferenceIdentification subscriberPrimaryNumber  
              ,'MI' subscriberPrimaryNumberQualifier  
              ,mli.REF_ReferenceIdentification originalMemberIdentifier  
              ,d.Loop2100A_NM1_IdentificationCodeQualifier memberSsnQualifier  
              ,d.Loop2100A_NM1_IdentificationCode memberSsn  
              ,d.INS_BenefitStatusCode benefitStatusCode  
              ,d.INS_IndividualRelationshipCode relationshipCode  
               ,isnull(hc.HD_MaintenanceTypeCode, d.INS_MaintenanceTypeCode) maintenanceTypeCode  
              ,isnull(hc.HD_MaintenanceReasonCode, d.INS_MaintenanceReasonCode) maintenanceReasonCode  
              ,d.INS_MedicareStatus_MedicarePlanCode medicarePlanCode  
              ,d.INS_MedicareStatus_MedicareEligibilityReasonCode medicareEligibilityReasonCode  
              ,d.INS_CobraQualifying cobraQualifyingEventCode  
              ,d.INS_EmpolymentStatusCode employmentStatusCode  
              ,d.INS_StudentStatusCode StudentStatusCode  
              ,case d.INS_YesNoConditionOrReponseCode2 when 'Y' then 1 else 0 end handicapIndicator  
              ,d.INS_ConfidentialityCode confidentialityCode  
              ,d.INS_Number BirthSequenceNumber  
              ,d.Loop2100A_NM1_EntityIdentifierCode memberNameEntityIdentifierCode  
              ,d.Loop2100A_NM1_NameLastOrOrganizationName memberLastName  
              ,d.Loop2100A_NM1_NameFirst memberFirstname  
              ,d.Loop2100A_NM1_NameMiddle memberMiddleName  
              ,d.Loop2100A_NM1_NamePrefix memberNamePrefix  
              ,d.Loop2100A_NM1_NameSuffix memberNameSuffix  
              ,d.Loop2100A_DMG_DateTimePeriod memberBirthDate  
              ,d.INS_DateTimePeriod memberDeathDate  
              ,d.Loop2100A_DMG_GenderCode memberGenderCode  
              ,d.Loop2100A_DMG_MaritalStatusCode memberMaritalStatusCode  
              ,d.Loop2100A_DMG_RaceOrEthnicityCode memberRaceCode  
              ,d.Loop2100A_DMG_CitizenshipStatusCode memberCitizenshipStatusCode  
              ,d.Loop2100A_HLH_HealthRelatedCode memberHealthRelatedCode  
              ,d.Loop2100A_HLH_Height memberHeight  
              ,d.Loop2100A_HLH_Weight memberWeight  
              ,gp.REF_ReferenceIdentification groupPolicyNumber  
              ,case when hc.HD_CoverageLevelCode is null then hc.HD_PlanCoverageDescription
                    when hc.HD_CoverageLevelCode is not null then isnull(hc.HD_PlanCoverageDescription + '-', '') + hc.HD_CoverageLevelCode
                end planNumber
              ,pb.DTP_DateTimePeriod planBeginDate 
              ,pe.DTP_DateTimePeriod planEndDate
              ,d.Loop2100A_PER_CommunicationNumberQualifier memberCommunicationNumberQualifier  
              ,d.Loop2100A_PER_CommunicationNumber memberCommunicationNumber  
              ,d.Loop2100A_PER_CommunicationNumberQualifier2 memberCommunicationNumberQualifier2  
              ,d.Loop2100A_PER_CommunicationNumber2 memberCommunicationNumber2  
              ,d.Loop2100A_PER_CommunicationNumberQualifier3 memberCommunicationNumberQualifier3  
              ,d.Loop2100A_PER_CommunicationNumber3 memberCommunicationNumber3  
              ,d.Loop2100A_N3_AddressInformation memberPrimaryAddressLine1  
              ,d.Loop2100A_N3_AddressInformation2 memberPrimaryAddressLine2  
              ,d.Loop2100A_N4_CityName memberPrimaryAddressCityName  
              ,d.Loop2100A_N4_StateOrProvinceCode memberPrimaryAddressStateCode  
              ,d.Loop2100A_N4_PostalCode memberPrimaryAddressZipCode  
              ,d.Loop2100A_N4_CountryCode memberPrimaryAddressCountryCode  
              ,d.Loop2100A_N4_LocationQualifier memberPrimaryAddressLocationQualifier  
              ,d.Loop2100A_N4_LocationIdentifier memberPrimaryAddressLocationIdentifier  
              ,d.Loop2100C_N3_AddressInformation memberMailingAddressLine1  
              ,d.Loop2100C_N3_AddressInformation2 memberMailingAddressLine2  
              ,d.Loop2100C_N4_CityName memberMailingAddressCityName  
              ,d.Loop2100C_N4_StateOrProvinceCode memberMailingAddressStateCode  
              ,d.Loop2100C_N4_PostalCode memberMailingAddressPostalCode  
              ,d.Loop2100C_N4_CountryCode memberMailingAddressCountryCode  
              ,prv.NM1_EntityIdentifierCode primaryCareProviderEntityIdentifierCode  
              ,prv.NM1_EntityTypeQualifier primaryCareProviderEntityTypeCode 
              ,case when prv.NM1_IdentificationCodeQualifier = 'XX' then prv.NM1_IdentificationCode end primaryCareProviderNPI  
              ,prv.NM1_NameLastOrOrganizationName primaryCareProviderLastOrOrganizationName  
              ,prv.NM1_NameFirst primaryCareProviderFirstName  
              ,prva.N3_AddressInformation primaryCareProviderAddressLine1  
              ,prva.N3_AddressInformation2 primaryCareProviderAddressLine2  
              ,prva.N4_CityName primaryCareProviderCityName  
              ,prva.N4_PostalCode primaryCareProviderZipCode  
              ,prva.N4_StateOrProvinceCode primaryCareProviderStateCode  
              ,d.Loop2100B_NM1_NameLastOrOrganizationName memberPriorIncorrectLastName  
              ,d.Loop2100B_NM1_NameFirst memberPriorIncorrectFirstName  
              ,d.Loop2100B_NM1_NameMiddle memberPriorIncorrectMiddleName  
              ,d.Loop2100B_NM1_NamePrefix memberPriorIncorrectNamePrefix  
              ,d.Loop2100B_NM1_NameSuffix memberPriorIncorrectNameSuffix  
              ,d.Loop2100B_NM1_IdentificationCodeQualifier memberPriorIncorrectIdentificationCodeQualifier  
              ,d.Loop2100B_NM1_IdentificationCode memberPriorIncorrectIdentificationCode  
              ,d.Loop2100B_DMG_DateTimePeriod memberPriorIncorrectBirthDate  
              ,d.Loop2100B_DMG_GenderCode memberPriorIncorrectGenderCode  
              ,d.Loop2100B_DMG_MaritalStatusCode memberPriorIncorrectMaritalStatusCode  
              ,d.Loop2100B_DMG_RaceOrEthnicityCode memberPriorIncorrectRaceCode  
              ,d.Loop2100B_DMG_CitizenshipStatusCode memberPriorIncorrectCitizenshipStatusCode  
              ,d.Loop2100B_DMG_IndustryCode memberPriorIncorrectRaceCollectionCode  
              ,try_convert(datetime2, h.BGN_Date + ' ' + substring(h.BGN_Time, 1, 2) + ':' + substring(h.BGN_Time, 3, 2)) transactionSetCreateDateTime  
              ,ml.LUI_IdentificationCode memberLanguageCode 
              ,ml.LUI_UseOfLanguageIndicator memberLanguageUseCode 
"	      from EdmStageX220.Detail d "
          join EdmStageX220.Header h on d.HeaderId = h.HeaderId  
"			                        and d.FileRequestId = h.FileRequestId  "
"		  left join EdmStageX220.MemberLevelIdentifier mli on d.FileRequestId = mli.FileRequestId  "
"		                                                  and d.DetailId = mli.DetailId  "
"		                                                   -- subscriber/patient primary number  "
"		                                                  and mli.REF_ReferenceIdentificationQualifier = '0F'  "
"		  left join EdmStageX220.MemberLevelIdentifier mid on d.FileRequestId = mid.FileRequestId  "
"		                                                  and d.DetailId = mid.DetailId  "
"		                                                   -- member rank  "
"		                                                  and mid.REF_ReferenceIdentificationQualifier = 'ZZ'  "
"		  left join EdmStageX220.MemberLevelIdentifier gp on d.FileRequestId = gp.FileRequestId  "
"		                                                 and d.DetailId = gp.DetailId  "
"		                                                  -- group policy number  "
"		                                                 and gp.REF_ReferenceIdentificationQualifier = '1L'  "
"		  left join EdmStageX220.HealthCoverage hc on d.DetailId = hc.DetailId  "
"		                                     and d.FileRequestId = hc.FileRequestId  "
          left join EdmStageX220.HealthCoverageDate pb on hc.HealthCoverageId = pb.HealthCoverageId
                                                      and hc.FileRequestId = pb.FileRequestId 
"		  					                           -- plan begin date"
"		  					                          and pb.DTP_DateTimeQualifier = '348'"
          left join EdmStageX220.HealthCoverageDate pe on hc.HealthCoverageId = pe.HealthCoverageId
                                                      and hc.FileRequestId = pe.FileRequestId
"								                       -- plan end date"
"								                      and pe.DTP_DateTimeQualifier = '349'"
"		  left join EdmStageX220.ProviderInformation prv on hc.HealthCoverageId = prv.HealthCoverageId  "
"			                                            and hc.FileRequestId = prv.FileRequestId  "
"													     -- primary care provider  "
"											            and prv.NM1_EntityIdentifierCode = 'P3'  "
"		  left join EdmStageX220.ProviderAddress prva on prv.ProviderInformationId = prva.ProviderInformationId  "
"		                                             and prv.FileRequestId = prva.FileRequestId "
"		  left join EdmStageX220.MemberLanguage ml on d.DetailId = ml.DetailId "
"		                                          and d.FileRequestId = ml.FileRequestId "
"			  where d.FileRequestId = :fileRequestId "
"			  ) t ; 	1	2019-12-06 10:28:43.0000000	mssql"
"134	0	MPI-INSERT_BULK_REQUEST_STAGE	insert into MPI.BulkRequestStage "
       (BulkRequestStageId 
       ,ClientIdentifier 
       ,OriginalPatientIdentifier 
       ,CurrentPatientIdentifier 
       ,PolicyNumber 
       ,FirstName 
       ,MiddleName 
       ,LastName 
       ,SSN 
       ,DOB 
       ,Gender 
       ,AddressLine1 
       ,AddressLine2 
       ,City 
       ,State 
       ,ZIP 
       ,Telephone)
select m.stageId BulkRequestStageId
"	  ,c.clientCode ClientIdentifier "
      ,m.patientPrimaryNumber OriginalPatientIdentifier 
"	  ,null CurrentPatientIdentifier "
"	  ,m.patientPrimaryNumber PolicyNumber "
"	  ,isnull(m.memberFirstname, 'UNKNOWN') FirstName "
"	  ,null MiddleName "
"	  ,isnull(m.memberLastName, 'UNKNOWN') LastName "
"	  ,case when m.memberSsn = '000000000' then null else m.memberSsn end SSN"
"	  ,case when year(try_convert(datetime2, memberBirthDate)) > 1800 then left(m.memberBirthDate, 4) +'-'+ right(left(memberBirthDate, 6), 2) +'-'+ right(memberBirthDate, 2) + ' 00:00:00' end  DOB "
"	  ,isnull(m.memberGenderCode, 'U') Gender "
"	  ,m.memberPrimaryAddressLine1 AddressLine1 "
"	  ,m.memberPrimaryAddressLine2 AddressLine2 "
"	  ,m.memberPrimaryAddressCityName City "
"	  ,m.memberPrimaryAddressStateCode State "
"	  ,m.memberPrimaryAddressZipCode ZIP "
"	  ,null Telephone"
  from <tableSchema>.<tableName> m
  join EdmLib.FileRequest fr on fr.fileRequestId = :fileRequestId
  join Reference.Client c on fr.clientId = c.clientId
" where m.fileRequestId = :fileRequestId ; 	1	2019-12-06 12:08:49.3466667	mssql"
"135	0	MPI-MERGE_BULK_REQUEST_STAGE_DEDUP	merge into <tableSchema>.<tableName> m"
using (select mc.fileRequestId
             ,mc.stageId
"       	     ,d.MPIID"
         from <tableSchema>.<tableName> mc
         join MPI.BulkRequestStageDedup d on mc.stageId = d.BulkRequestStageId
                                         and d.MPIID is not null
        where mc.enterprisePatientId is null
          and mc.fileRequestId = :fileRequestId) u
   on m.fileRequestId = u.fileRequestId
  and m.stageId = u.stageId
" when matched then update set m.enterprisePatientId = u.MPIID; 	1	2019-12-06 12:10:31.1566667	mssql"
"136	0	MPI-MISSING_MPI_COUNT	select count(*) from <tableSchema>.<tableName> where enterprisePatientId is null	1	2019-12-06 12:11:20.0566667	mssql"
"137	0	MPI-TOTAL_RECORD_COUNT	select count(*) from <tableSchema>.<tableName>	1	2019-12-06 12:12:14.8033333	mssql"
"138	0	MPI-DUPLICATE_MPI_COUNT	select count(*)"
  from (select enterprisePatientId
              ,count(*) recordCount
"	          ,string_agg(m.memberSsn, ', ') within group (order by m.memberSsn) patientSsnList"
"	          ,count(distinct memberSsn) patientSsnCount"
"	          ,string_agg(m.memberBirthDate, ', ') within group (order by m.memberSsn) birthDateList"
"	          ,count(distinct memberBirthDate) birthDateCount"
"	          ,string_agg(m.memberGenderCode, ', ')  within group (order by m.memberSsn) genderList"
"	          ,count(distinct memberGenderCode) genderCount"
"	          ,max(fileRequestId) fileRequestId"
"	          ,string_agg(m.stageId, ', ') within group (order by m.memberSsn) stageIdList"
          from <tableSchema>.<tableName> m
         group by m.enterprisePatientId
        having count(distinct case when m.memberSsn = '000000000' then null else m.memberSsn end) > 1
            or count(distinct m.memberBirthDate) > 1
"            or count(distinct m.memberGenderCode) > 1) x 	1	2019-12-06 12:16:16.7733333	mssql"
"139	0	MPI-ADD_NEW_PLANS	declare @clientId int = :clientId ;"

insert into Reference.Plans
(clientId, planNumber, planName, planDesc, planSource, createDate, planEffectiveDate, plansActiveFlag, planMedicareInd, planExclusion) 
select @clientId,  m.planNumber planNumber, m.planNumber planName, m.planNumber planDesc, c.clientCode planSource, sysdatetime(), '2020-01-01', 1, 0, 0
  from <tableSchema>.<tableName> m
  join Reference.Client c on c.clientId = @clientId
  left join Reference.Plans pl on c.clientId = pl.clientId
                              and m.planNumber = pl.planNumber
 where ascii(trim(m.planNumber)) is not null
   and pl.plansId is null
" group by m.planNumber, c.clientCode; 	1	2019-12-06 13:25:37.2300000	mssql"
"140	0	MPI-ADD_NEW_GROUP_POLICIES	declare @clientId int = :clientId ;"

insert into Reference.GroupPolicy
(clientId, groupPolicyNumber, groupPolicyCategory, groupPolicyName, groupPolicySource, createDate) 
select @clientId, m.groupPolicyNumber groupPolicyNumber, m.groupPolicyNumber groupPolicyCategory, m.groupPolicyNumber groupPolicyName, c.clientCode, sysdatetime()
  from <tableSchema>.<tableName> m
  join Reference.Client c on c.clientId = @clientId
  left join Reference.GroupPolicy gp on c.clientId = gp.clientId
                                    and m.groupPolicyNumber = gp.groupPolicyNumber
 where ascii(trim(m.groupPolicyNumber)) is not null
   and gp.groupPolicyId is null
" group by m.groupPolicyNumber, c.clientCode;	1	2019-12-06 13:26:22.3966667	mssql"
"141	72	MPI-ADD_NEW_GROUP_POLICIES	insert into Reference.GroupPolicy"
(clientId, groupPolicyNumber, groupPolicyCategory, groupPolicyName, groupPolicySource, createDate) 
select 72, m.groupPolicyNumber groupPolicyNumber, m.groupPolicyNumber groupPolicyCategory, m.groupPolicyNumber groupPolicyName, 'NASI' clientCode, sysdatetime()
  from <tableSchema>.<tableName> m
  left join Reference.GroupPolicy gp on m.groupPolicyNumber = gp.groupPolicyNumber
 where ascii(trim(m.groupPolicyNumber)) is not null
   and gp.groupPolicyId is null
" group by m.groupPolicyNumber	0	2019-12-06 13:54:56.6433333	mssql"
"142	72	MPI-ADD_NEW_PLANS	insert into Reference.Plans"
(clientId, planNumber, planName, planDesc, planSource, createDate, planEffectiveDate, plansActiveFlag, planMedicareInd, planExclusion) 
select 72,  m.planNumber planNumber, m.planNumber planName, m.planNumber planDesc, 'NASI' planSource, sysdatetime(), '2020-01-01', 1, 0, 0
  from <tableSchema>.<tableName> m
  left join Reference.Plans pl on m.planNumber = pl.planNumber
 where ascii(trim(m.planNumber)) is not null
   and pl.plansId is null
" group by m.planNumber	0	2019-12-06 13:56:24.1800000	mssql"
"143	58	STRIVE_MEMBER_ADDRESS-MERGE_SUBSCRIBER_INFO	declare @clientId int = :clientId ;"
update EdmStage.Telligen_Member set primaryInsured = 'TRUE' where employeeID not like '%-s' and primaryInsured is null

merge into EdmStage.Telligen_Member m
using ( select m.stageId
       ,s.employeeID subscriberPrimaryNumber
       ,min(s.enterprisePatientId) enterpriseSubscriberId -- use the 1st MPIID
   from EdmStage.Telligen_Member m
   join --subscribers 
   (select *
   from EdmStage.Telligen_Member
 where primaryInsured = 'TRUE'
  and employeeID not like '%-s') s on m.employeeID = s.employeeID + '-s'
 where isnull(upper(m.primaryInsured), 'FALSE') = 'FALSE'
 group by m.stageId, s.employeeID) u
 on m.stageId = u.stageId
 when matched then update set m.subscriberPrimaryNumber = u.subscriberPrimaryNumber
"                             ,m.enterpriseSubscriberId = u.enterpriseSubscriberId; 	1	2019-12-06 16:12:23.7433333	mssql"
"144	73	NECA_MEMBER_PREPROCESS	declare @fileRequestId bigint = :fileRequestId ;"

update EdmStage.Neca_Member
   set transactionSetCreationDateTime = substring(replace(convert(varchar(30), sysdatetime()), ' ', 'T'), 1, 19)
 where transactionSetCreationDateTime is null ;

update EdmStage.Neca_Member
set patientPrimaryNumber = RIGHT('0000' + memberNumber + subscriberPolicyId, 11), patientPrimaryNumberQualifier = 'MI' 
where fileRequestId = @fileRequestId
and patientPrimaryNumber is null ;

update EdmStage.Neca_Member
set subscriberPrimaryNumber = RIGHT('00' + subscriberPolicyId, 11), subscriberPrimaryNumberQualifier = 'MI' 
where subscriberPrimaryNumber is null ;

if (select count(*) from EdmStage.Neca_Member where memberPrimaryAddressLine2 is not null) >
   (select count(*) from EdmStage.Neca_Member where memberPrimaryAddressLine1 is not null)
update EdmStage.Neca_Member
set memberPrimaryAddressLine1 = memberPrimaryAddressLine2
,memberPrimaryAddressLine2 = memberPrimaryAddressLine1;

update EdmStage.Neca_Member
   set memberSsn = right('0000000' + memberSsn, 9)
  where len(memberSsn) < 9

update EdmStage.Neca_Member
   set subscriberSsn = right('0000000' + subscriberSsn, 9)
  where len(subscriberSsn) < 9

update EdmStage.Neca_Member
   set memberPhoneNumber = subscriberPhone
 where memberPhoneNumber is null
   and subscriberPhone is not null; 

update EdmStage.Neca_Member
   set planNumber = 'NECA-Default'
 where planNumber is null;

update EdmStage.Neca_Member
   set groupPolicyNumber = 'NECA-Default'
 where groupPolicyNumber is null; 
 
update EdmStage.Neca_Member
set relationshipCode = case relationshipCode
                            when 'E' then '18'
"                       	    when 'S' then '01'"
"                       	    when 'D' then '19'"
"                       	    else '~' + relationshipCode"
                       end
 where relationshipCode not in ('18', '01', '19')
"   and relationshipCode not like '~%';  	1	2019-12-12 12:00:00.0000000	mssql"
"145	73	NECA_MEMBER_UPDATE_SUBSCRIBER_INFO	declare @fileRequestId bigint = :fileRequestId ;"

update EdmStage.Neca_Member
set enterpriseSubscriberId = enterprisePatientId
where relationshipCode = '18'
and enterpriseSubscriberId is null;

with subscriberList as (
select stageId
      ,memberSsn
      ,patientPrimaryNumber
      ,enterprisePatientId
  from EdmStage.Neca_Member
 where relationshipCode = '18'),
 dependentList as 
 (select d.stageId
              ,s.patientPrimaryNumber
"			  ,s.enterprisePatientId"
"			  ,s.memberSsn"
"			  ,s.stageId subscriberStageId"
"			  ,rank() over(partition by d.stageId order by case when s.memberSsn is not null then 1 else 2 end, s.stageId desc) rnk"
          from EdmStage.Neca_Member d
          join subscriberLIst s on d.subscriberPrimaryNumber = s.patientPrimaryNumber
         where d.relationshipCode <> '18'
           and d.enterpriseSubscriberId is null),
 dependentListRnk as
 (select *
    from dependentList
   where rnk = 1)
merge into EdmStage.Neca_Member m
using dependentListRnk u
   on m.stageId = u.stageId
" when matched then update set m.enterpriseSubscriberId = m.enterprisePatientId; 	1	2019-12-12 22:45:01.2533333	mssql"
"146	72	NASI_MEMBER_PREPROCESS	declare @fileRequestId bigint = :fileRequestId ;"

update <tableSchema>.<tableName>
   set groupPolicyNumber = 'NASI-Default'
 where groupPolicyNumber is null ;

-- override what the X12 preprocess util did b/c there's an issue
-- that'll figure out later
-- or set it if didn't go thru X12 processing
update <tableSchema>.<tableName>
   set transactionSetCreationDateTime = substring(replace(convert(varchar(30), sysdatetime()), ' ', 'T'), 1, 19)
 where transactionSetCreationDateTime is null
    or transactionSetCreationDateTime like '% %' ;

merge into <tableSchema>.<tableName> m
using (
select d.stageId
  from <tableSchema>.<tableName> d
  join <tableSchema>.<tableName> s on d.enterpriseSubscriberId = s.enterprisePatientId
                             and d.memberSsn = s.memberSsn
 where d.relationshipCode not in ('18', 'M', 'F')) u
 on m.stageId = u.stageId
" when matched then update set m.memberSsn = null ; 	0	2019-12-17 13:17:08.3266667	mssql"
"147	72	UPDATE_SUBSCRIBER_INFO	declare @fileRequestId bigint = :fileRequestId ;"

update EdmStage.Nasi_MemberCSV
  set enterpriseSubscriberId = enterprisePatientId
 where dependentNumber = '0'
   and enterpriseSubscriberId is null;

merge into EdmStage.Nasi_MemberCSV m
using (select distinct d.stageId
             ,s.enterprisePatientId enterpriseSubscriberId
         from EdmStage.Nasi_MemberCSV d
         join EdmStage.Nasi_MemberCSV s on s.memberAlternateId = d.memberAlternateId
"   	    							and s.dependentNumber = '0'"
        where d.dependentNumber <> '0'
"		  and d.enterpriseSubscriberId is null) u"
   on m.stageId = u.stageId
" when matched then update set m.enterpriseSubscriberId = u.enterpriseSubscriberId  ;	1	2019-12-17 13:29:36.1800000	mssql"
"148	58	STRIVE_MEMBER_ADDRESS-ADD_NEW_GROUP_POLICIES	declare @clientId int = :clientId ;"

update EdmStage.Telligen_Member
   set groupName = 'THP-Spouse-Default'
 where groupName is null
   and employeeID like '%-s'

insert into Reference.GroupPolicy
(clientId, groupPolicyNumber, groupPolicyCategory, groupPolicyName, groupPolicySource, createDate) 
select @clientId,  groupName groupPolicyNumber, groupName groupPolicyCategory, groupName groupPolicyName, c.clientCode, sysdatetime()
  from <tableSchema>.<tableName> m
  join Reference.Client c on c.clientId = @clientId
  left join Reference.GroupPolicy gp on c.clientId = gp.clientId
                                    and m.groupName = gp.groupPolicyNumber
 where ascii(trim(m.groupName)) is not null
   and gp.groupPolicyId is null
" group by m.groupName, c.clientCode; 	1	2019-12-23 14:25:31.5166667	mssql"
"149	58	STRIVE_MEMBER_ADDRESS-RETIRE_MEMBERS	declare @clientId int = :clientId ;"

update EdmStage.Telligen_Member
   set dateStarted = '01/01/' + cast(year(dateTerminated) as varchar(4))
 where dateStarted is null
   and dateTerminated is not null; 

with maximums as (select max(stageId) stageId, max(fileRequestId) fileRequestId from EdmStage.Telligen_Member)
insert into EdmStage.Telligen_Member
"	  (stageId"
"	  ,fileRequestId"
"	  ,enterprisePatientId"
"	  ,tempEnterprisePatientId"
"	  ,originalEmployeeId"
"	  ,currentEmployeeId"
"	  ,firstName"
"	  ,lastName"
"	  ,birthDate"
"	  ,employeeId"
"	  ,email"
"	  ,location"
"	  ,division"
"	  ,department"
"	  ,groupName"
"	  ,gender"
"	  ,wageType"
"	  ,insurancePlan"
"	  ,dateStarted"
"	  ,primaryInsured"
"	  ,fullTime"
"	  ,dateTerminated"
"	  ,hcFlag"
"	  ,addressLine1"
"	  ,addressLine2"
"	  ,cityName"
"	  ,stateCode"
"	  ,postalZoneCode"
"	  ,primaryTelephoneNumber)"
select row_number() over(partition by 1 order by p.patientId) + m.stageId stageId
"	  ,m.fileRequestId"
"	  ,p.enterprisePatientId"
"	  ,p.tempEnterprisePatientId"
"	  ,null originalEmployeeId"
"	  ,null currentEmployeeId"
"	  ,p.patientFirstName firstName"
"	  ,p.patientLastName lastName"
"	  ,convert(varchar(10), p.patientBirthDate, 101) birthDate"
"	  ,p.patientPrimaryNumber employeeId"
"	  ,em.emailAddress email"
"	  ,p.location"
"	  ,p.division"
"	  ,p.department"
"	  ,case when gp.groupPolicyId > 9 then gp.groupPolicyNumber end groupName"
"	  ,p.patientGenderCode gender"
"	  ,p.wageType"
"	  ,case when pl.plansId > 9 then pl.planNumber end insurancePlan"
"	  ,convert(varchar(10), e.benefitPlanStartDate, 101) dateStarted"
"	  ,case when p.relationshipCode = '18' then 'TRUE' when p.relationshipCode = '21' then null else 'FALSE' end primaryInsured"
"	  ,case when p.isFullTime = 1 then 'TRUE' when p.isFullTime = 0 then 'FALSE' end fullTime"
"	  ,convert(varchar(10), dateadd(day, -1, cast(year(sysdatetime()) as varchar(4)) + '-'+ cast(month(sysdatetime()) as varchar(2)) + '-01'), 101) dateTerminated"
"	  ,null hcFlag"
"	  ,ad.addressLine1 addressLine1"
"	  ,ad.addressLine2 addressLine2"
"	  ,ad.city cityName"
"	  ,ad.state stateCode"
"	  ,ad.zip postalZoneCode"
"	  ,null primaryTelephoneNumber"
from Patient.PatientDim p
cross apply maximums m
left join Patient.PatientDim sub on p.clientId = sub.clientId
"								and p.enterpriseSubscriberId = sub.enterprisePatientId"
"								and p.recordTypeId = 28"
left join Patient.EmailDim em on p.clientId = em.clientId
"								and p.patientId = em.patientId"
"								and em.activeFlag = 1"
left join Patient.AddressDim ad on p.clientId = ad.clientId
"								and p.patientId = ad.patientId"
"								and ad.activeFlag = 1"
left join EdmStage.Telligen_Member s on p.enterprisePatientId = s.enterprisePatientId
                                    and (isnull(s.insurancePlan, '~') <> 'THP-Terminated-Default')
join Patient.EligibilityFact e on p.clientId = e.clientId
"								and p.patientId = e.patientId"
"								and e.eligibilityFactActiveFlag = 1"
"								and (e.benefitPlanEndDate is null"
"									or e.benefitPlanEndDate > sysdatetime())"
join Reference.GroupPolicy gp on e.groupPolicyId = gp.groupPolicyId
join Reference.Plans pl on e.benefitPlanId = pl.plansId
where p.clientId = @clientId
"	and p.patientActiveFlag = 1"
"	and s.stageId is null ; 	1	2019-12-23 14:45:19.5166667	mssql"
"150	0	HWB_VALIDATE_REFERRAL	declare @fileRequestId bigint = :fileRequestId ;"
declare @runId bigint = :runId ;

insert into EdmStage.HWB_ReferralFeedback
(runId
,stageId
,fileRequestId
,configuredRuleId
,feedbackMessage
,feedbackType
,fieldName
,originalFieldValue
,createDateTime
,recordCount)
select @runId
      ,r.stageId
      ,r.fileRequestId
"	  ,0 configuredRuleId"
"	  ,case when r.patientPrimaryNumber is null then '[patientPrimaryNumber] is required.'"
"	        when pd.patientId is null and r.patientPrimaryNumber is not null then '[patientPrimaryNumber] is invalid.'"
       end feedbackMessage
"	  ,case when r.patientPrimaryNumber is null or pd.patientId is null then 'W' end feedbackType"
"	  ,'[patientPrimaryNumber]' fieldName"
"	  ,r.patientPrimaryNumber originalFieldValue"
"	  ,sysdatetime() createDateTime"
"	  ,1 recordCount"
  from EdmStage.HWB_Referral r
  left join Patient.PatientDim pd on r.patientPrimaryNumber = pd.patientPrimaryNumber
                                 and r.clientId = pd.clientId
 where pd.patientId is null

insert into EdmStage.HWB_ReferralFeedback
(runId
,stageId
,fileRequestId
,configuredRuleId
,feedbackMessage
,feedbackType
,fieldName
,originalFieldValue
,createDateTime
,recordCount)
select @runId
      ,r.stageId
      ,r.fileRequestId
"	  ,0 configuredRuleId"
"	  ,case when r.moduleCode is null then '[moduleCode] is required.'"
"	        when m.moduleId is null and r.moduleCode is not null then '[moduleCode] is invalid.'"
       end feedbackMessage
"	  ,case when r.moduleCode is null or m.moduleId is null then 'E' end feedbackType"
"	  ,'[moduleCode]' fieldName"
"	  ,r.moduleCode originalFieldValue"
"	  ,sysdatetime() createDateTime"
"	  ,1 recordCount"
  from EdmStage.HWB_Referral r
  left join ProgramModule.Module m on r.moduleCode = m.moduleCode
 where m.moduleId is null

insert into EdmStage.HWB_ReferralFeedback
(runId
,stageId
,fileRequestId
,configuredRuleId
,feedbackMessage
,feedbackType
,fieldName
,originalFieldValue
,createDateTime
,recordCount)
select @runId
      ,r.stageId
      ,r.fileRequestId
"	  ,0 configuredRuleId"
"	  ,case when x.value is null then '[servicesCode] is required.'"
"	        when s.servicesId is null and x.value is not null then '[servicesCode] is invalid.'"
       end feedbackMessage
"	  ,case when x.value is null or s.servicesId is null then 'E' end feedbackType"
"	  ,'[servicesCode]' fieldName"
"	  ,x.value originalFieldValue"
"	  ,sysdatetime() createDateTime"
"	  ,1 recordCount"
  from EdmStage.HWB_Referral r
  cross apply string_split(r.servicesCodeList, ',') x 
  left join ProgramModule.Services s on x.value = s.servicesCode
 where s.servicesId is null

insert into EdmStage.HWB_ReferralFeedback
(runId
,stageId
,fileRequestId
,configuredRuleId
,feedbackMessage
,feedbackType
,fieldName
,originalFieldValue
,createDateTime
,recordCount)
select @runId
      ,r.stageId
      ,r.fileRequestId
"	  ,0 configuredRuleId"
"	  ,case when i.icdId is null and r.prinDX is not null then '[prinDX] is invalid.'"
       end feedbackMessage
"	  ,case when i.icdId is null and r.prinDX is not null then 'W' end feedbackType"
"	  ,'[prinDX]' fieldName"
"	  ,r.prinDX originalFieldValue"
"	  ,sysdatetime() createDateTime"
"	  ,1 recordCount"
  from EdmStage.HWB_Referral r
  left join Reference.Icd i on replace(r.prinDX, '.', '') = i.icdCodeStd
 where r.prinDX is not null
   and i.icdId is null

insert into EdmStage.HWB_ReferralFeedback
(runId
,stageId
,fileRequestId
,configuredRuleId
,feedbackMessage
,feedbackType
,fieldName
,originalFieldValue
,createDateTime
,recordCount)
select @runId
      ,r.stageId
      ,r.fileRequestId
"	  ,0 configuredRuleId"
"	  ,case when i.icdId is null and x.value is not null then '[otherDxCode] is invalid.'"
       end feedbackMessage
"	  ,case when x.value is null or i.icdId is null then 'W' end feedbackType"
"	  ,'[otherDxCode]' fieldName"
"	  ,x.value originalFieldValue"
"	  ,sysdatetime() createDateTime"
"	  ,1 recordCount"
  from EdmStage.HWB_Referral r
  cross apply string_split(r.otherDxCodeList, ',') x 
  left join Reference.Icd i on replace(x.value, '.', '') = i.icdCodeStd
 where i.icdId is null
   and x.value is not null; 

merge into EdmStage.HWB_Referral m
using (select r.stageId
             ,max(case when f.feedbackType = 'E' then 1 else 0 end) hasError
         from EdmStage.HWB_Referral r 
         left join EdmStage.HWB_ReferralFeedback f on r.fileRequestId = f.fileRequestId
                                                  and f.runId = @runId
"										          and r.stageId = f.stageId"
"		group by r.stageId) u"
  on m.stageId = u.stageId
when matched then update set m.hasError = u.hasError;
"	1	2019-12-26 17:16:25.9066667	mssql"
"151	0	HWB_GET_REFERRAL_ERROR_COUNT	select count(distinct stageId)"
  from EdmStage.HWB_ReferralFeedback
 where feedbackType = 'E'
   and fileRequestId = :fileRequestId
"   and runId = :runId	1	2019-12-30 15:50:57.4100000	mssql"
"152	0	HWB_LOAD_HISTORY	insert into EdmStage.HWB_ReferralHistory"
select *
      ,null referralFeedback -- nothing to add, for now...
  from EdmStage.HWB_Referral
" where fileRequestId = :fileRequestId	1	2019-12-30 16:14:44.8466667	mssql"
"153	71	STRIVE_MEMBER_ADDRESS-MERGE_PLAN_START_OR_END_DATES	declare @clientId int = :clientId ;"
update EdmStage.DouglasCounty_Member set dateTerminated = null where dateTerminated = 'NA' ;
" 	1	2019-12-31 12:00:00.0000000	mssql"
"154	71	STRIVE_MEMBER_ADDRESS-GENERIC_PREPROCESS	declare @clientId int = :clientId ;"

update EdmStage.DouglasCounty_Member set fullTime = 'TRUE' where fullTime = 'YES' ; 

update EdmStage.DouglasCounty_Member set fullTime = 'FALSE' where fullTime = 'NO' ;

update EdmStage.DouglasCounty_Member
 set dateStarted = left(dateStarted, 6) + case when right(dateStarted, 2) > 19 then '19'
            else '20'
"	   end + right(dateStarted, 2)"
 where len(dateStarted) = 8;

update EdmStage.DouglasCounty_Member
set birthDate = left(birthDate, 6) + case when right(birthDate, 2) > 19 then '19'
            else '20'
"	   end + right(birthDate, 2)"
 where len(birthDate) = 8;

declare @adddressLine1NullCount int ;
declare @addressLine2NullCount int ;

select @adddressLine1NullCount = count(*)
  from EdmStage.DouglasCounty_Member
 where addressLine1 is null

select @addressLine2NullCount = count(*)
  from EdmStage.DouglasCounty_Member
 where addressLine2 is null

--select @adddressLine1NullCount, @addressLine2NullCount

if @adddressLine1NullCount > @addressLine2NullCount
update EdmStage.DouglasCounty_Member
  set addressLine1 = addressLine2, addressLine2 = addressLine1; 


update EdmStage.DouglasCounty_Member 
set dateTerminated = null
"where dateTerminated = 'NA' ; 	1	2019-12-31 12:00:00.0000000	mssql"
"155	71	STRIVE_MEMBER_ADDRESS-MERGE_SUBSCRIBER_INFO	declare @clientId int = :clientId ;"
update EdmStage.DouglasCounty_Member set subscriberPrimaryNumber = employeeId where primaryInsured = 'TRUE' and subscriberPrimaryNumber is null ; 
update EdmStage.DouglasCounty_Member set enterpriseSubscriberId = enterprisePatientId where primaryInsured = 'TRUE' and enterpriseSubscriberId is null ;
" 	1	2019-12-31 12:00:00.0000000	mssql"
"156	72	INSERT_INTO_FROM_X220	insert into EdmStage.NASI_Member"
"	   (stageId "
"	   ,fileRequestId  "
"	   ,headerId  "
"	   ,detailId  "
      -- ,memberRank 
"	   ,patientPrimaryNumber  "
"	   ,patientPrimaryNumberQualifier  "
"	   ,subscriberPrimaryNumber  "
"	   ,subscriberPrimaryNumberQualifier  "
"	   ,originalMemberIdentifier  "
"	   ,memberSsnQualifier  "
"	   ,memberSsn  "
"	   ,benefitStatusCode  "
"	   ,relationshipCode  "
"	   ,maintenanceTypeCode  "
"	   ,maintenanceReasonCode  "
"	   ,medicarePlanCode  "
"	   ,medicareEligibilityReasonCode  "
"	   ,cobraQualifyingEventCode  "
"	   ,employmentStatusCode  "
"	   ,studentStatusCode  "
"	   ,handicapIndicator  "
"	   ,confidentialityCode  "
"	   ,birthSequenceNumber  "
"	   ,memberNameEntityIdentifierCode  "
"	   ,memberLastName  "
"	   ,memberFirstname  "
"	   ,memberMiddleName  "
"	   ,memberNamePrefix  "
"	   ,memberNameSuffix  "
"	   ,memberBirthDate  "
"	   ,memberDeathDate  "
"	   ,memberGenderCode  "
"	   ,memberMaritalStatusCode  "
"	   ,memberRaceCode  "
"	   ,memberCitizenshipStatusCode  "
"	   ,memberHealthRelatedCode  "
"	   ,memberHeight  "
"	   ,memberWeight  "
"	   ,groupPolicyNumber  "
"	   ,planNumber  "
       ,planBeginDate
       ,planEndDate
"	   ,memberCommunicationNumberQualifier  "
"	   ,memberCommunicationNumber  "
"	   ,memberCommunicationNumberQualifier2  "
"	   ,memberCommunicationNumber2  "
"	   ,memberCommunicationNumberQualifier3  "
"	   ,memberCommunicationNumber3  "
"	   ,memberPrimaryAddressLine1  "
"	   ,memberPrimaryAddressLine2  "
"	   ,memberPrimaryAddressCityName  "
"	   ,memberPrimaryAddressStateCode  "
"	   ,memberPrimaryAddressZipCode  "
"	   ,memberPrimaryAddressCountryCode  "
"	   ,memberPrimaryAddressLocationQualifier  "
"	   ,memberPrimaryAddressLocationIdentifier  "
"	   ,memberMailingAddressLine1  "
"	   ,memberMailingAddressLine2  "
"	   ,memberMailingAddressCityName  "
"	   ,memberMailingAddressStateCode  "
"	   ,memberMailingAddressZipCode  "
"	   ,memberMailingAddressCountryCode  "
"	   ,primaryCareProviderEntityIdentifierCode  	        "
"	   ,primaryCareProviderEntityTypeCode  "
"	   ,primaryCareProviderNPI  "
"	   ,primaryCareProviderLastOrOrganizationName  "
"	   ,primaryCareProviderFirstName  "
"	   ,primaryCareProviderAddressLine1  "
"	   ,primaryCareProviderAddressLine2  "
"	   ,primaryCareProviderCityName  "
"	   ,primaryCareProviderZipCode  "
"	   ,primaryCareProviderStateCode  "
"	   ,memberPriorIncorrectLastName  "
"	   ,memberPriorIncorrectFirstName  "
"	   ,memberPriorIncorrectMiddleName  "
"	   ,memberPriorIncorrectNamePrefix  "
"	   ,memberPriorIncorrectNameSuffix  "
"	   ,memberPriorIncorrectIdentificationCodeQualifier  "
"	   ,memberPriorIncorrectIdentificationCode  "
"	   ,memberPriorIncorrectBirthDate  "
"	   ,memberPriorIncorrectGenderCode  "
"	   ,memberPriorIncorrectMaritalStatusCode  "
"	   ,memberPriorIncorrectRaceCode  "
"	   ,memberPriorIncorrectCitizenshipStatusCode  "
"	   ,memberPriorIncorrectRaceCollectionCode "
"	   ,transactionSetCreationDateTime "
"	   ,memberLanguageCode "
"	   ,memberLanguageUseCode) "
select row_number() over(partition by 1 order by detailId) stageId 
"	  ,t.* "
  from (select d.fileRequestId  
              ,d.headerId  
              ,d.detailId  
              --,mid.REF_ReferenceIdentification memberRank  
              ,mli.REF_ReferenceIdentification patientPrimaryNumber  
              ,'MI' patientPrimaryNumberQualifier  
              ,mli.REF_ReferenceIdentification subscriberPrimaryNumber  
              ,'MI' subscriberPrimaryNumberQualifier  
              ,mli.REF_ReferenceIdentification originalMemberIdentifier  
              ,d.Loop2100A_NM1_IdentificationCodeQualifier memberSsnQualifier  
              ,d.Loop2100A_NM1_IdentificationCode memberSsn  
              ,d.INS_BenefitStatusCode benefitStatusCode  
              ,d.INS_IndividualRelationshipCode relationshipCode  
              ,d.INS_MaintenanceTypeCode maintenanceTypeCode  
              ,d.INS_MaintenanceReasonCode maintenanceReasonCode  
              ,d.INS_MedicareStatus_MedicarePlanCode medicarePlanCode  
              ,d.INS_MedicareStatus_MedicareEligibilityReasonCode medicareEligibilityReasonCode  
              ,d.INS_CobraQualifying cobraQualifyingEventCode  
              ,d.INS_EmpolymentStatusCode employmentStatusCode  
              ,d.INS_StudentStatusCode StudentStatusCode  
              ,case d.INS_YesNoConditionOrReponseCode2 when 'Y' then 1 else 0 end handicapIndicator  
              ,d.INS_ConfidentialityCode confidentialityCode  
              ,d.INS_Number BirthSequenceNumber  
              ,d.Loop2100A_NM1_EntityIdentifierCode memberNameEntityIdentifierCode  
              ,d.Loop2100A_NM1_NameLastOrOrganizationName memberLastName  
              ,d.Loop2100A_NM1_NameFirst memberFirstname  
              ,d.Loop2100A_NM1_NameMiddle memberMiddleName  
              ,d.Loop2100A_NM1_NamePrefix memberNamePrefix  
              ,d.Loop2100A_NM1_NameSuffix memberNameSuffix  
              ,d.Loop2100A_DMG_DateTimePeriod memberBirthDate  
              ,d.INS_DateTimePeriod memberDeathDate  
              ,d.Loop2100A_DMG_GenderCode memberGenderCode  
              ,d.Loop2100A_DMG_MaritalStatusCode memberMaritalStatusCode  
              ,d.Loop2100A_DMG_RaceOrEthnicityCode memberRaceCode  
              ,d.Loop2100A_DMG_CitizenshipStatusCode memberCitizenshipStatusCode  
              ,d.Loop2100A_HLH_HealthRelatedCode memberHealthRelatedCode  
              ,d.Loop2100A_HLH_Height memberHeight  
              ,d.Loop2100A_HLH_Weight memberWeight  
              ,gp.REF_ReferenceIdentification groupPolicyNumber  
              ,case when hc.HD_CoverageLevelCode is null then hc.HD_PlanCoverageDescription
                    when hc.HD_CoverageLevelCode is not null then hc.HD_PlanCoverageDescription + '-' + hc.HD_CoverageLevelCode
                end planNumber
              ,pb.DTP_DateTimePeriod planBeginDate 
              ,pe.DTP_DateTimePeriod planEndDate
              ,d.Loop2100A_PER_CommunicationNumberQualifier memberCommunicationNumberQualifier  
              ,d.Loop2100A_PER_CommunicationNumber memberCommunicationNumber  
              ,d.Loop2100A_PER_CommunicationNumberQualifier2 memberCommunicationNumberQualifier2  
              ,d.Loop2100A_PER_CommunicationNumber2 memberCommunicationNumber2  
              ,d.Loop2100A_PER_CommunicationNumberQualifier3 memberCommunicationNumberQualifier3  
              ,d.Loop2100A_PER_CommunicationNumber3 memberCommunicationNumber3  
              ,d.Loop2100A_N3_AddressInformation memberPrimaryAddressLine1  
              ,d.Loop2100A_N3_AddressInformation2 memberPrimaryAddressLine2  
              ,d.Loop2100A_N4_CityName memberPrimaryAddressCityName  
              ,d.Loop2100A_N4_StateOrProvinceCode memberPrimaryAddressStateCode  
              ,d.Loop2100A_N4_PostalCode memberPrimaryAddressZipCode  
              ,d.Loop2100A_N4_CountryCode memberPrimaryAddressCountryCode  
              ,d.Loop2100A_N4_LocationQualifier memberPrimaryAddressLocationQualifier  
              ,d.Loop2100A_N4_LocationIdentifier memberPrimaryAddressLocationIdentifier  
              ,d.Loop2100C_N3_AddressInformation memberMailingAddressLine1  
              ,d.Loop2100C_N3_AddressInformation2 memberMailingAddressLine2  
              ,d.Loop2100C_N4_CityName memberMailingAddressCityName  
              ,d.Loop2100C_N4_StateOrProvinceCode memberMailingAddressStateCode  
              ,d.Loop2100C_N4_PostalCode memberMailingAddressPostalCode  
              ,d.Loop2100C_N4_CountryCode memberMailingAddressCountryCode  
              ,prv.NM1_EntityIdentifierCode primaryCareProviderEntityIdentifierCode  
              ,prv.NM1_EntityTypeQualifier primaryCareProviderEntityTypeCode 
              ,case when prv.NM1_IdentificationCodeQualifier = 'XX' then prv.NM1_IdentificationCode end primaryCareProviderNPI  
              ,prv.NM1_NameLastOrOrganizationName primaryCareProviderLastOrOrganizationName  
              ,prv.NM1_NameFirst primaryCareProviderFirstName  
              ,prva.N3_AddressInformation primaryCareProviderAddressLine1  
              ,prva.N3_AddressInformation2 primaryCareProviderAddressLine2  
              ,prva.N4_CityName primaryCareProviderCityName  
              ,prva.N4_PostalCode primaryCareProviderZipCode  
              ,prva.N4_StateOrProvinceCode primaryCareProviderStateCode  
              ,d.Loop2100B_NM1_NameLastOrOrganizationName memberPriorIncorrectLastName  
              ,d.Loop2100B_NM1_NameFirst memberPriorIncorrectFirstName  
              ,d.Loop2100B_NM1_NameMiddle memberPriorIncorrectMiddleName  
              ,d.Loop2100B_NM1_NamePrefix memberPriorIncorrectNamePrefix  
              ,d.Loop2100B_NM1_NameSuffix memberPriorIncorrectNameSuffix  
              ,d.Loop2100B_NM1_IdentificationCodeQualifier memberPriorIncorrectIdentificationCodeQualifier  
              ,d.Loop2100B_NM1_IdentificationCode memberPriorIncorrectIdentificationCode  
              ,d.Loop2100B_DMG_DateTimePeriod memberPriorIncorrectBirthDate  
              ,d.Loop2100B_DMG_GenderCode memberPriorIncorrectGenderCode  
              ,d.Loop2100B_DMG_MaritalStatusCode memberPriorIncorrectMaritalStatusCode  
              ,d.Loop2100B_DMG_RaceOrEthnicityCode memberPriorIncorrectRaceCode  
              ,d.Loop2100B_DMG_CitizenshipStatusCode memberPriorIncorrectCitizenshipStatusCode  
              ,d.Loop2100B_DMG_IndustryCode memberPriorIncorrectRaceCollectionCode  
              ,try_convert(datetime2, h.BGN_Date + ' ' + substring(h.BGN_Time, 1, 2) + ':' + substring(h.BGN_Time, 3, 2)) transactionSetCreateDateTime  
              ,ml.LUI_IdentificationCode memberLanguageCode 
              ,ml.LUI_UseOfLanguageIndicator memberLanguageUseCode 
"	      from EdmStageX220.Detail d "
          join EdmStageX220.Header h on d.HeaderId = h.HeaderId  
"			                        and d.FileRequestId = h.FileRequestId  "
"		  left join EdmStageX220.MemberLevelIdentifier mli on d.FileRequestId = mli.FileRequestId  "
"		                                                  and d.DetailId = mli.DetailId  "
"		                                                   -- subscriber/patient primary number  "
"		                                                  and mli.REF_ReferenceIdentificationQualifier = '0F'  "
"		  left join EdmStageX220.MemberLevelIdentifier mid on d.FileRequestId = mid.FileRequestId  "
"		                                                  and d.DetailId = mid.DetailId  "
"		                                                   -- member rank  "
"		                                                  and mid.REF_ReferenceIdentificationQualifier = 'ZZ'  "
"		  left join EdmStageX220.MemberLevelIdentifier gp on d.FileRequestId = gp.FileRequestId  "
"		                                                 and d.DetailId = gp.DetailId  "
"		                                                  -- group policy number  "
"		                                                 and gp.REF_ReferenceIdentificationQualifier = '1L'  "
"		  left join EdmStageX220.HealthCoverage hc on d.DetailId = hc.DetailId  "
"		                                     and d.FileRequestId = hc.FileRequestId  "
          left join EdmStageX220.HealthCoverageDate pb on hc.HealthCoverageId = pb.HealthCoverageId
                                                      and hc.FileRequestId = pb.FileRequestId 
"		  					                           -- plan begin date"
"		  					                          and pb.DTP_DateTimeQualifier = '348'"
          left join EdmStageX220.HealthCoverageDate pe on hc.HealthCoverageId = pe.HealthCoverageId
                                                      and hc.FileRequestId = pe.FileRequestId
"								                       -- plan end date"
"								                      and pe.DTP_DateTimeQualifier = '349'"
"		  left join EdmStageX220.ProviderInformation prv on hc.HealthCoverageId = prv.HealthCoverageId  "
"			                                            and hc.FileRequestId = prv.FileRequestId  "
"													     -- primary care provider  "
"											            and prv.NM1_EntityIdentifierCode = 'P3'  "
"		  left join EdmStageX220.ProviderAddress prva on prv.ProviderInformationId = prva.ProviderInformationId  "
"		                                             and prv.FileRequestId = prva.FileRequestId "
"		  left join EdmStageX220.MemberLanguage ml on d.DetailId = ml.DetailId "
"		                                          and d.FileRequestId = ml.FileRequestId "
"	     where d.FileRequestId = :fileRequestId "
"		    -- only load subscriber/employee and spouse, ignore all other dependents"
"		   and d.INS_IndividualRelationshipCode in ('18', '20', '01', '53')) t ; 	0	2020-01-03 11:52:16.1800000	mssql"
"157	0	HWB_GET_REFERRAL_WARNING_COUNT	select count(distinct stageId)"
  from EdmStage.HWB_ReferralFeedback
 where feedbackType = 'W'
   and fileRequestId = :fileRequestId
"   and runId = :runId	1	2020-01-09 09:23:58.1933333	mssql"
"158	58	STRIVE_MEMBER_ADDRESS-GENERIC_PREPROCESS	-- this needs to run before the MPI util so"
#NAME?
#NAME?
-- padded with 0s on the left
declare @clientId int = :clientId ;

#NAME?
#NAME?
#NAME?
update EdmStage.Telligen_Member
   set insurancePlan = 'THP-NotEnrolled-Default'
      ,dateStarted = '1/1/'+convert(varchar(4), year(sysdatetime()))
      ,dateTerminated = case when dateTerminated is not null then dateTerminated else '12/31/'+convert(varchar(4), year(sysdatetime())) end
 where dateStarted is null 
   and dateTerminated is null
   and insurancePlan is null; 

#NAME?
#NAME?
#NAME?
update EdmStage.Telligen_Member
   set insurancePlan = 'THP-Terminated-Default'
      ,dateStarted = '1/1/'+case when convert(int, year(dateTerminated)) < convert(int, year(sysdatetime())) then convert(varchar(4), year(dateTerminated)) else convert(varchar(4), year(sysdatetime())) end
      ,dateTerminated = case when dateTerminated is not null then dateTerminated else '12/31/'+convert(varchar(4), year(sysdatetime())) end
 where dateStarted is null 
   and dateTerminated is not null
   and insurancePlan is null; 

update EdmStage.Telligen_Member
   set employeeId = right('0000'+employeeId, 4)
" where len(employeeId) < 4 ; 	1	2020-01-10 11:00:45.0766667	mssql"
"159	39	INSERT_INTO_FROM_X220	declare @fileRequestId bigint = :fileRequestId ;"

insert into EdmStage.ID_Member
"	   (stageId "
"	   ,fileRequestId  "
"	   ,headerId  "
"	   ,detailId  "
      -- ,memberRank 
"	   ,enterprisePatientId"
"	   ,enterpriseSubscriberId"
"	   ,patientPrimaryNumber  "
"	   ,patientPrimaryNumberQualifier  "
"	   ,subscriberPrimaryNumber  "
"	   ,subscriberPrimaryNumberQualifier  "
"	   ,originalMemberIdentifier  "
"	   ,memberSsnQualifier  "
"	   ,memberSsn  "
"	   ,benefitStatusCode  "
"	   ,relationshipCode  "
"	   ,maintenanceTypeCode  "
"	   ,maintenanceReasonCode  "
"	   ,medicarePlanCode  "
"	   ,medicareEligibilityReasonCode  "
"	   ,cobraQualifyingEventCode  "
"	   ,employmentStatusCode  "
"	   ,studentStatusCode  "
"	   ,handicapIndicator  "
"	   ,confidentialityCode  "
"	   ,birthSequenceNumber  "
"	   ,memberNameEntityIdentifierCode  "
"	   ,memberLastName  "
"	   ,memberFirstname  "
"	   ,memberMiddleName  "
"	   ,memberNamePrefix  "
"	   ,memberNameSuffix  "
"	   ,memberBirthDate  "
"	   ,memberDeathDate  "
"	   ,memberGenderCode  "
"	   ,memberMaritalStatusCode  "
"	   ,memberRaceCode  "
"	   ,memberCitizenshipStatusCode  "
"	   ,memberHealthRelatedCode  "
"	   ,memberHeight  "
"	   ,memberWeight  "
"	   ,groupPolicyNumber  "
"	   ,planNumber  "
       ,planBeginDate
       ,planEndDate
"	   ,memberCommunicationNumberQualifier  "
"	   ,memberCommunicationNumber  "
"	   ,memberCommunicationNumberQualifier2  "
"	   ,memberCommunicationNumber2  "
"	   ,memberCommunicationNumberQualifier3  "
"	   ,memberCommunicationNumber3  "
"	   ,memberPrimaryAddressLine1  "
"	   ,memberPrimaryAddressLine2  "
"	   ,memberPrimaryAddressCityName  "
"	   ,memberPrimaryAddressStateCode  "
"	   ,memberPrimaryAddressZipCode  "
"	   ,memberPrimaryAddressCountryCode  "
"	   ,memberPrimaryAddressLocationQualifier  "
"	   ,memberPrimaryAddressLocationIdentifier  "
"	   ,memberMailingAddressLine1  "
"	   ,memberMailingAddressLine2  "
"	   ,memberMailingAddressCityName  "
"	   ,memberMailingAddressStateCode  "
"	   ,memberMailingAddressZipCode  "
"	   ,memberMailingAddressCountryCode  "
"	   ,primaryCareProviderEntityIdentifierCode  	        "
"	   ,primaryCareProviderEntityTypeCode  "
"	   ,primaryCareProviderNPI  "
"	   ,primaryCareProviderLastOrOrganizationName  "
"	   ,primaryCareProviderFirstName  "
"	   ,primaryCareProviderAddressLine1  "
"	   ,primaryCareProviderAddressLine2  "
"	   ,primaryCareProviderCityName  "
"	   ,primaryCareProviderZipCode  "
"	   ,primaryCareProviderStateCode  "
"	   ,memberPriorIncorrectLastName  "
"	   ,memberPriorIncorrectFirstName  "
"	   ,memberPriorIncorrectMiddleName  "
"	   ,memberPriorIncorrectNamePrefix  "
"	   ,memberPriorIncorrectNameSuffix  "
"	   ,memberPriorIncorrectIdentificationCodeQualifier  "
"	   ,memberPriorIncorrectIdentificationCode  "
"	   ,memberPriorIncorrectBirthDate  "
"	   ,memberPriorIncorrectGenderCode  "
"	   ,memberPriorIncorrectMaritalStatusCode  "
"	   ,memberPriorIncorrectRaceCode  "
"	   ,memberPriorIncorrectCitizenshipStatusCode  "
"	   ,memberPriorIncorrectRaceCollectionCode "
"	   ,transactionSetCreationDateTime "
"	   ,memberLanguageCode "
"	   ,memberLanguageUseCode"
       ,enrollmentIdentifier) 
select row_number() over(partition by 1 order by detailId) stageId 
"	  ,x.*"
  from (
select distinct t.* 
  from (select d.fileRequestId  
              ,d.headerId  
              ,d.detailId  
              --,mid.REF_ReferenceIdentification memberRank   
              ,'ID' + mli.REF_ReferenceIdentification enterprisePatientId
              ,'ID' + mli.REF_ReferenceIdentification enterpriseSubscriberId
              ,mli.REF_ReferenceIdentification patientPrimaryNumber  
              ,'MI' patientPrimaryNumberQualifier  
              ,mli.REF_ReferenceIdentification subscriberPrimaryNumber  
              ,'MI' subscriberPrimaryNumberQualifier  
              ,mli.REF_ReferenceIdentification originalMemberIdentifier  
              ,d.Loop2100A_NM1_IdentificationCodeQualifier memberSsnQualifier  
              ,d.Loop2100A_NM1_IdentificationCode memberSsn  
              ,d.INS_BenefitStatusCode benefitStatusCode  
              ,d.INS_IndividualRelationshipCode relationshipCode 
              ,isnull(hc.HD_MaintenanceTypeCode, d.INS_MaintenanceTypeCode) maintenanceTypeCode  
              ,isnull(hc.HD_MaintenanceReasonCode, d.INS_MaintenanceReasonCode) maintenanceReasonCode  
              ,d.INS_MedicareStatus_MedicarePlanCode medicarePlanCode  
              ,d.INS_MedicareStatus_MedicareEligibilityReasonCode medicareEligibilityReasonCode  
              ,d.INS_CobraQualifying cobraQualifyingEventCode  
              ,d.INS_EmpolymentStatusCode employmentStatusCode  
              ,d.INS_StudentStatusCode StudentStatusCode  
              ,case d.INS_YesNoConditionOrReponseCode2 when 'Y' then 1 else 0 end handicapIndicator  
              ,d.INS_ConfidentialityCode confidentialityCode  
              ,d.INS_Number BirthSequenceNumber  
              ,d.Loop2100A_NM1_EntityIdentifierCode memberNameEntityIdentifierCode  
              ,d.Loop2100A_NM1_NameLastOrOrganizationName memberLastName  
              ,d.Loop2100A_NM1_NameFirst memberFirstname  
              ,d.Loop2100A_NM1_NameMiddle memberMiddleName  
              ,d.Loop2100A_NM1_NamePrefix memberNamePrefix  
              ,d.Loop2100A_NM1_NameSuffix memberNameSuffix  
              ,d.Loop2100A_DMG_DateTimePeriod memberBirthDate  
              ,d.INS_DateTimePeriod memberDeathDate  
              ,d.Loop2100A_DMG_GenderCode memberGenderCode  
              ,d.Loop2100A_DMG_MaritalStatusCode memberMaritalStatusCode  
              ,d.Loop2100A_DMG_RaceOrEthnicityCode memberRaceCode  
              ,d.Loop2100A_DMG_CitizenshipStatusCode memberCitizenshipStatusCode  
              ,d.Loop2100A_HLH_HealthRelatedCode memberHealthRelatedCode  
              ,d.Loop2100A_HLH_Height memberHeight  
              ,d.Loop2100A_HLH_Weight memberWeight  
              ,case when hcp.REF_ReferenceIdentification is not null then gp.REF_ReferenceIdentification end groupPolicyNumber  
              ,hcp.REF_ReferenceIdentification planNumber
              ,pb.DTP_DateTimePeriod planBeginDate 
              ,pe.DTP_DateTimePeriod planEndDate
              ,d.Loop2100A_PER_CommunicationNumberQualifier memberCommunicationNumberQualifier  
              ,d.Loop2100A_PER_CommunicationNumber memberCommunicationNumber  
              ,d.Loop2100A_PER_CommunicationNumberQualifier2 memberCommunicationNumberQualifier2  
              ,d.Loop2100A_PER_CommunicationNumber2 memberCommunicationNumber2  
              ,d.Loop2100A_PER_CommunicationNumberQualifier3 memberCommunicationNumberQualifier3  
              ,d.Loop2100A_PER_CommunicationNumber3 memberCommunicationNumber3  
              ,d.Loop2100A_N3_AddressInformation memberPrimaryAddressLine1  
              ,d.Loop2100A_N3_AddressInformation2 memberPrimaryAddressLine2  
              ,d.Loop2100A_N4_CityName memberPrimaryAddressCityName  
              ,d.Loop2100A_N4_StateOrProvinceCode memberPrimaryAddressStateCode  
              ,d.Loop2100A_N4_PostalCode memberPrimaryAddressZipCode  
              ,d.Loop2100A_N4_CountryCode memberPrimaryAddressCountryCode  
              ,d.Loop2100A_N4_LocationQualifier memberPrimaryAddressLocationQualifier  
              ,d.Loop2100A_N4_LocationIdentifier memberPrimaryAddressLocationIdentifier  
              ,d.Loop2100C_N3_AddressInformation memberMailingAddressLine1  
              ,d.Loop2100C_N3_AddressInformation2 memberMailingAddressLine2  
              ,d.Loop2100C_N4_CityName memberMailingAddressCityName  
              ,d.Loop2100C_N4_StateOrProvinceCode memberMailingAddressStateCode  
              ,d.Loop2100C_N4_PostalCode memberMailingAddressPostalCode  
              ,d.Loop2100C_N4_CountryCode memberMailingAddressCountryCode  
              ,prv.NM1_EntityIdentifierCode primaryCareProviderEntityIdentifierCode  
              ,prv.NM1_EntityTypeQualifier primaryCareProviderEntityTypeCode 
              ,case when prv.NM1_IdentificationCodeQualifier = 'XX' then prv.NM1_IdentificationCode end primaryCareProviderNPI  
              ,prv.NM1_NameLastOrOrganizationName primaryCareProviderLastOrOrganizationName  
              ,prv.NM1_NameFirst primaryCareProviderFirstName  
              ,prva.N3_AddressInformation primaryCareProviderAddressLine1  
              ,prva.N3_AddressInformation2 primaryCareProviderAddressLine2  
              ,prva.N4_CityName primaryCareProviderCityName  
              ,prva.N4_PostalCode primaryCareProviderZipCode  
              ,prva.N4_StateOrProvinceCode primaryCareProviderStateCode  
              ,d.Loop2100B_NM1_NameLastOrOrganizationName memberPriorIncorrectLastName  
              ,d.Loop2100B_NM1_NameFirst memberPriorIncorrectFirstName  
              ,d.Loop2100B_NM1_NameMiddle memberPriorIncorrectMiddleName  
              ,d.Loop2100B_NM1_NamePrefix memberPriorIncorrectNamePrefix  
              ,d.Loop2100B_NM1_NameSuffix memberPriorIncorrectNameSuffix  
              ,d.Loop2100B_NM1_IdentificationCodeQualifier memberPriorIncorrectIdentificationCodeQualifier  
              ,d.Loop2100B_NM1_IdentificationCode memberPriorIncorrectIdentificationCode  
              ,d.Loop2100B_DMG_DateTimePeriod memberPriorIncorrectBirthDate  
              ,d.Loop2100B_DMG_GenderCode memberPriorIncorrectGenderCode  
              ,d.Loop2100B_DMG_MaritalStatusCode memberPriorIncorrectMaritalStatusCode  
              ,d.Loop2100B_DMG_RaceOrEthnicityCode memberPriorIncorrectRaceCode  
              ,d.Loop2100B_DMG_CitizenshipStatusCode memberPriorIncorrectCitizenshipStatusCode  
              ,d.Loop2100B_DMG_IndustryCode memberPriorIncorrectRaceCollectionCode  
              ,try_convert(datetime2, h.BGN_Date + ' ' + substring(h.BGN_Time, 1, 2) + ':' + substring(h.BGN_Time, 3, 2)) transactionSetCreateDateTime  
              ,ml.LUI_IdentificationCode memberLanguageCode 
              ,ml.LUI_UseOfLanguageIndicator memberLanguageUseCode 
"			  ,hce.REF_ReferenceIdentification enrollmentIdentifier"
"	      from EdmStageX220.Detail d "
          join EdmStageX220.Header h on d.HeaderId = h.HeaderId  
"			                        and d.FileRequestId = h.FileRequestId  "
"		  left join EdmStageX220.MemberLevelIdentifier mli on d.FileRequestId = mli.FileRequestId  "
"		                                                  and d.DetailId = mli.DetailId  "
"		                                                   -- subscriber/patient primary number  "
"		                                                  and mli.REF_ReferenceIdentificationQualifier = '0F'  "
"		  left join EdmStageX220.MemberLevelIdentifier mid on d.FileRequestId = mid.FileRequestId  "
"		                                                  and d.DetailId = mid.DetailId  "
"		                                                   -- member rank  "
"		                                                  and mid.REF_ReferenceIdentificationQualifier = 'ZZ'  "
"		  left join EdmStageX220.MemberLevelIdentifier gp on d.FileRequestId = gp.FileRequestId  "
"		                                                 and d.DetailId = gp.DetailId  "
"		                                                  -- group policy number  "
"		                                                 and gp.REF_ReferenceIdentificationQualifier = '1L'  "
"		  left join EdmStageX220.HealthCoverage hc on d.DetailId = hc.DetailId  "
"		                                     and d.FileRequestId = hc.FileRequestId  "
"		  left join EdmStageX220.HealthCoveragePolicy hcp on hc.FileRequestId = hcp.FileRequestId"
"		                                                 and hc.HealthCoverageId = hcp.HealthCoverageId"
"														 and hcp.REF_ReferenceIdentificationQualifier = 'RB' -- = rate code = planNumber"
"		  left join EdmStageX220.HealthCoveragePolicy hce on hc.FileRequestId = hce.FileRequestId"
"		                                                 and hc.HealthCoverageId = hce.HealthCoverageId"
"														 and hce.REF_ReferenceIdentificationQualifier = 'X9' -- enrollmentIdentifier"
          left join EdmStageX220.HealthCoverageDate pb on hc.HealthCoverageId = pb.HealthCoverageId
                                                      and hc.FileRequestId = pb.FileRequestId 
"		  					                           -- plan begin date"
"		  					                          and pb.DTP_DateTimeQualifier = '348'"
          left join EdmStageX220.HealthCoverageDate pe on hc.HealthCoverageId = pe.HealthCoverageId
                                                      and hc.FileRequestId = pe.FileRequestId
"								                       -- plan end date"
"								                      and pe.DTP_DateTimeQualifier = '349'"
"		  left join EdmStageX220.ProviderInformation prv on hc.HealthCoverageId = prv.HealthCoverageId  "
"			                                            and hc.FileRequestId = prv.FileRequestId  "
"													     -- primary care provider  "
"											            and prv.NM1_EntityIdentifierCode = 'P3'  "
"		  left join EdmStageX220.ProviderAddress prva on prv.ProviderInformationId = prva.ProviderInformationId  "
"		                                             and prv.FileRequestId = prva.FileRequestId "
"		  left join EdmStageX220.MemberLanguage ml on d.DetailId = ml.DetailId "
"		                                          and d.FileRequestId = ml.FileRequestId "
"	     where d.FileRequestId = @fileRequestId "
"	     union all"
"	    select d.fileRequestId  "
              ,d.headerId  
              ,d.detailId  
              --,mid.REF_ReferenceIdentification memberRank   
              ,'ID' + mli.REF_ReferenceIdentification enterprisePatientId
              ,'ID' + mli.REF_ReferenceIdentification enterpriseSubscriberId
              ,mli.REF_ReferenceIdentification patientPrimaryNumber  
              ,'MI' patientPrimaryNumberQualifier  
              ,mli.REF_ReferenceIdentification subscriberPrimaryNumber  
              ,'MI' subscriberPrimaryNumberQualifier  
              ,mli.REF_ReferenceIdentification originalMemberIdentifier  
              ,d.Loop2100A_NM1_IdentificationCodeQualifier memberSsnQualifier  
              ,d.Loop2100A_NM1_IdentificationCode memberSsn  
              ,d.INS_BenefitStatusCode benefitStatusCode  
              ,d.INS_IndividualRelationshipCode relationshipCode 
              ,isnull(hc.HD_MaintenanceTypeCode, d.INS_MaintenanceTypeCode) maintenanceTypeCode  
              ,isnull(hc.HD_MaintenanceReasonCode, d.INS_MaintenanceReasonCode) maintenanceReasonCode  
              ,d.INS_MedicareStatus_MedicarePlanCode medicarePlanCode  
              ,d.INS_MedicareStatus_MedicareEligibilityReasonCode medicareEligibilityReasonCode  
              ,d.INS_CobraQualifying cobraQualifyingEventCode  
              ,d.INS_EmpolymentStatusCode employmentStatusCode  
              ,d.INS_StudentStatusCode StudentStatusCode  
              ,case d.INS_YesNoConditionOrReponseCode2 when 'Y' then 1 else 0 end handicapIndicator  
              ,d.INS_ConfidentialityCode confidentialityCode  
              ,d.INS_Number BirthSequenceNumber  
              ,d.Loop2100A_NM1_EntityIdentifierCode memberNameEntityIdentifierCode  
              ,d.Loop2100A_NM1_NameLastOrOrganizationName memberLastName  
              ,d.Loop2100A_NM1_NameFirst memberFirstname  
              ,d.Loop2100A_NM1_NameMiddle memberMiddleName  
              ,d.Loop2100A_NM1_NamePrefix memberNamePrefix  
              ,d.Loop2100A_NM1_NameSuffix memberNameSuffix  
              ,d.Loop2100A_DMG_DateTimePeriod memberBirthDate  
              ,d.INS_DateTimePeriod memberDeathDate  
              ,d.Loop2100A_DMG_GenderCode memberGenderCode  
              ,d.Loop2100A_DMG_MaritalStatusCode memberMaritalStatusCode  
              ,d.Loop2100A_DMG_RaceOrEthnicityCode memberRaceCode  
              ,d.Loop2100A_DMG_CitizenshipStatusCode memberCitizenshipStatusCode  
              ,d.Loop2100A_HLH_HealthRelatedCode memberHealthRelatedCode  
              ,d.Loop2100A_HLH_Height memberHeight  
              ,d.Loop2100A_HLH_Weight memberWeight  
              ,case when susp.N1_name is not null then gp.REF_ReferenceIdentification end groupPolicyNumber  
              ,susp.N1_name planNumber
              ,left(susp.DTP_DateTimePeriod, charindex('-', susp.DTP_DateTimePeriod)-1) planBeginDate 
              ,substring(susp.DTP_DateTimePeriod, charindex('-', susp.DTP_DateTimePeriod)+1, len(DTP_DateTimePeriod)) planEndDate
              ,d.Loop2100A_PER_CommunicationNumberQualifier memberCommunicationNumberQualifier  
              ,d.Loop2100A_PER_CommunicationNumber memberCommunicationNumber  
              ,d.Loop2100A_PER_CommunicationNumberQualifier2 memberCommunicationNumberQualifier2  
              ,d.Loop2100A_PER_CommunicationNumber2 memberCommunicationNumber2  
              ,d.Loop2100A_PER_CommunicationNumberQualifier3 memberCommunicationNumberQualifier3  
              ,d.Loop2100A_PER_CommunicationNumber3 memberCommunicationNumber3  
              ,d.Loop2100A_N3_AddressInformation memberPrimaryAddressLine1  
              ,d.Loop2100A_N3_AddressInformation2 memberPrimaryAddressLine2  
              ,d.Loop2100A_N4_CityName memberPrimaryAddressCityName  
              ,d.Loop2100A_N4_StateOrProvinceCode memberPrimaryAddressStateCode  
              ,d.Loop2100A_N4_PostalCode memberPrimaryAddressZipCode  
              ,d.Loop2100A_N4_CountryCode memberPrimaryAddressCountryCode  
              ,d.Loop2100A_N4_LocationQualifier memberPrimaryAddressLocationQualifier  
              ,d.Loop2100A_N4_LocationIdentifier memberPrimaryAddressLocationIdentifier  
              ,d.Loop2100C_N3_AddressInformation memberMailingAddressLine1  
              ,d.Loop2100C_N3_AddressInformation2 memberMailingAddressLine2  
              ,d.Loop2100C_N4_CityName memberMailingAddressCityName  
              ,d.Loop2100C_N4_StateOrProvinceCode memberMailingAddressStateCode  
              ,d.Loop2100C_N4_PostalCode memberMailingAddressPostalCode  
              ,d.Loop2100C_N4_CountryCode memberMailingAddressCountryCode  
              ,prv.NM1_EntityIdentifierCode primaryCareProviderEntityIdentifierCode  
              ,prv.NM1_EntityTypeQualifier primaryCareProviderEntityTypeCode 
              ,case when prv.NM1_IdentificationCodeQualifier = 'XX' then prv.NM1_IdentificationCode end primaryCareProviderNPI  
              ,prv.NM1_NameLastOrOrganizationName primaryCareProviderLastOrOrganizationName  
              ,prv.NM1_NameFirst primaryCareProviderFirstName  
              ,prva.N3_AddressInformation primaryCareProviderAddressLine1  
              ,prva.N3_AddressInformation2 primaryCareProviderAddressLine2  
              ,prva.N4_CityName primaryCareProviderCityName  
              ,prva.N4_PostalCode primaryCareProviderZipCode  
              ,prva.N4_StateOrProvinceCode primaryCareProviderStateCode  
              ,d.Loop2100B_NM1_NameLastOrOrganizationName memberPriorIncorrectLastName  
              ,d.Loop2100B_NM1_NameFirst memberPriorIncorrectFirstName  
              ,d.Loop2100B_NM1_NameMiddle memberPriorIncorrectMiddleName  
              ,d.Loop2100B_NM1_NamePrefix memberPriorIncorrectNamePrefix  
              ,d.Loop2100B_NM1_NameSuffix memberPriorIncorrectNameSuffix  
              ,d.Loop2100B_NM1_IdentificationCodeQualifier memberPriorIncorrectIdentificationCodeQualifier  
              ,d.Loop2100B_NM1_IdentificationCode memberPriorIncorrectIdentificationCode  
              ,d.Loop2100B_DMG_DateTimePeriod memberPriorIncorrectBirthDate  
              ,d.Loop2100B_DMG_GenderCode memberPriorIncorrectGenderCode  
              ,d.Loop2100B_DMG_MaritalStatusCode memberPriorIncorrectMaritalStatusCode  
              ,d.Loop2100B_DMG_RaceOrEthnicityCode memberPriorIncorrectRaceCode  
              ,d.Loop2100B_DMG_CitizenshipStatusCode memberPriorIncorrectCitizenshipStatusCode  
              ,d.Loop2100B_DMG_IndustryCode memberPriorIncorrectRaceCollectionCode  
              ,try_convert(datetime2, h.BGN_Date + ' ' + substring(h.BGN_Time, 1, 2) + ':' + substring(h.BGN_Time, 3, 2)) transactionSetCreateDateTime  
              ,ml.LUI_IdentificationCode memberLanguageCode 
              ,ml.LUI_UseOfLanguageIndicator memberLanguageUseCode 
"			  ,hce.REF_ReferenceIdentification enrollmentIdentifier"
"	      from EdmStageX220.Detail d "
          join EdmStageX220.Header h on d.HeaderId = h.HeaderId  
"			                        and d.FileRequestId = h.FileRequestId  "
"		  left join EdmStageX220.MemberLevelIdentifier mli on d.FileRequestId = mli.FileRequestId  "
"		                                                  and d.DetailId = mli.DetailId  "
"		                                                   -- subscriber/patient primary number  "
"		                                                  and mli.REF_ReferenceIdentificationQualifier = '0F'  "
"		  left join EdmStageX220.MemberLevelIdentifier mid on d.FileRequestId = mid.FileRequestId  "
"		                                                  and d.DetailId = mid.DetailId  "
"		                                                   -- member rank  "
"		                                                  and mid.REF_ReferenceIdentificationQualifier = 'ZZ'  "
"		  left join EdmStageX220.MemberLevelIdentifier gp on d.FileRequestId = gp.FileRequestId  "
"		                                                 and d.DetailId = gp.DetailId  "
"		                                                  -- group policy number  "
"		                                                 and gp.REF_ReferenceIdentificationQualifier = '1L'  "
"		  left join EdmStageX220.HealthCoverage hc on d.DetailId = hc.DetailId  "
"		                                     and d.FileRequestId = hc.FileRequestId "
"		  left join EdmStageX220.HealthCoveragePolicy hce on hc.FileRequestId = hce.FileRequestId"
"		                                                 and hc.HealthCoverageId = hce.HealthCoverageId"
"														 and hce.REF_ReferenceIdentificationQualifier = 'X9' -- enrollmentIdentifier"
"		  join EdmStageX220.MemberReportingCategory susp on d.FileRequestId = susp.FileRequestId"
"		                                                and d.DetailId = susp.DetailId"
"														and susp.N1_name = 'SUSP'"
"		  left join EdmStageX220.ProviderInformation prv on hc.HealthCoverageId = prv.HealthCoverageId  "
"			                                            and hc.FileRequestId = prv.FileRequestId  "
"													     -- primary care provider  "
"											            and prv.NM1_EntityIdentifierCode = 'P3'  "
"		  left join EdmStageX220.ProviderAddress prva on prv.ProviderInformationId = prva.ProviderInformationId  "
"		                                             and prv.FileRequestId = prva.FileRequestId "
"		  left join EdmStageX220.MemberLanguage ml on d.DetailId = ml.DetailId "
"		                                          and d.FileRequestId = ml.FileRequestId "
"	     where d.FileRequestId = @fileRequestId"
"		 union all"
"		 select d.fileRequestId  "
               ,d.headerId  
               ,d.detailId  
               --,mid.REF_ReferenceIdentification memberRank   
               ,'ID' + mli.REF_ReferenceIdentification enterprisePatientId
               ,'ID' + mli.REF_ReferenceIdentification enterpriseSubscriberId
               ,mli.REF_ReferenceIdentification patientPrimaryNumber  
               ,'MI' patientPrimaryNumberQualifier  
               ,mli.REF_ReferenceIdentification subscriberPrimaryNumber  
               ,'MI' subscriberPrimaryNumberQualifier  
               ,mli.REF_ReferenceIdentification originalMemberIdentifier  
               ,d.Loop2100A_NM1_IdentificationCodeQualifier memberSsnQualifier  
               ,d.Loop2100A_NM1_IdentificationCode memberSsn  
               ,d.INS_BenefitStatusCode benefitStatusCode  
               ,d.INS_IndividualRelationshipCode relationshipCode 
               --,isnull(hc.HD_MaintenanceTypeCode, d.INS_MaintenanceTypeCode) maintenanceTypeCode  
               --,isnull(hc.HD_MaintenanceReasonCode, d.INS_MaintenanceReasonCode) maintenanceReasonCode  
"			   ,d.INS_MaintenanceTypeCode maintenanceTypeCode  "
               ,d.INS_MaintenanceReasonCode maintenanceReasonCode  
               ,d.INS_MedicareStatus_MedicarePlanCode medicarePlanCode  
               ,d.INS_MedicareStatus_MedicareEligibilityReasonCode medicareEligibilityReasonCode  
               ,d.INS_CobraQualifying cobraQualifyingEventCode  
               ,d.INS_EmpolymentStatusCode employmentStatusCode  
               ,d.INS_StudentStatusCode StudentStatusCode  
               ,case d.INS_YesNoConditionOrReponseCode2 when 'Y' then 1 else 0 end handicapIndicator  
               ,d.INS_ConfidentialityCode confidentialityCode  
               ,d.INS_Number BirthSequenceNumber  
               ,d.Loop2100A_NM1_EntityIdentifierCode memberNameEntityIdentifierCode  
               ,d.Loop2100A_NM1_NameLastOrOrganizationName memberLastName  
               ,d.Loop2100A_NM1_NameFirst memberFirstname  
               ,d.Loop2100A_NM1_NameMiddle memberMiddleName  
               ,d.Loop2100A_NM1_NamePrefix memberNamePrefix  
               ,d.Loop2100A_NM1_NameSuffix memberNameSuffix  
               ,d.Loop2100A_DMG_DateTimePeriod memberBirthDate  
               ,d.INS_DateTimePeriod memberDeathDate  
               ,d.Loop2100A_DMG_GenderCode memberGenderCode  
               ,d.Loop2100A_DMG_MaritalStatusCode memberMaritalStatusCode  
               ,d.Loop2100A_DMG_RaceOrEthnicityCode memberRaceCode  
               ,d.Loop2100A_DMG_CitizenshipStatusCode memberCitizenshipStatusCode  
               ,d.Loop2100A_HLH_HealthRelatedCode memberHealthRelatedCode  
               ,d.Loop2100A_HLH_Height memberHeight  
               ,d.Loop2100A_HLH_Weight memberWeight  
               ,gp.REF_ReferenceIdentification groupPolicyNumber  
"			   ,right(cob.COB_ReferenceIdentification, 5) planNumber"
               ,cobb.DTP_DateTimePeriod planBeginDate 
               ,cobe.DTP_DateTimePeriod planEndDate
               ,d.Loop2100A_PER_CommunicationNumberQualifier memberCommunicationNumberQualifier  
               ,d.Loop2100A_PER_CommunicationNumber memberCommunicationNumber  
               ,d.Loop2100A_PER_CommunicationNumberQualifier2 memberCommunicationNumberQualifier2  
               ,d.Loop2100A_PER_CommunicationNumber2 memberCommunicationNumber2  
               ,d.Loop2100A_PER_CommunicationNumberQualifier3 memberCommunicationNumberQualifier3  
               ,d.Loop2100A_PER_CommunicationNumber3 memberCommunicationNumber3  
               ,d.Loop2100A_N3_AddressInformation memberPrimaryAddressLine1  
               ,d.Loop2100A_N3_AddressInformation2 memberPrimaryAddressLine2  
               ,d.Loop2100A_N4_CityName memberPrimaryAddressCityName  
               ,d.Loop2100A_N4_StateOrProvinceCode memberPrimaryAddressStateCode  
               ,d.Loop2100A_N4_PostalCode memberPrimaryAddressZipCode  
               ,d.Loop2100A_N4_CountryCode memberPrimaryAddressCountryCode  
               ,d.Loop2100A_N4_LocationQualifier memberPrimaryAddressLocationQualifier  
               ,d.Loop2100A_N4_LocationIdentifier memberPrimaryAddressLocationIdentifier  
               ,d.Loop2100C_N3_AddressInformation memberMailingAddressLine1  
               ,d.Loop2100C_N3_AddressInformation2 memberMailingAddressLine2  
               ,d.Loop2100C_N4_CityName memberMailingAddressCityName  
               ,d.Loop2100C_N4_StateOrProvinceCode memberMailingAddressStateCode  
               ,d.Loop2100C_N4_PostalCode memberMailingAddressPostalCode  
               ,d.Loop2100C_N4_CountryCode memberMailingAddressCountryCode  
               ,prv.NM1_EntityIdentifierCode primaryCareProviderEntityIdentifierCode  
               ,prv.NM1_EntityTypeQualifier primaryCareProviderEntityTypeCode 
               ,case when prv.NM1_IdentificationCodeQualifier = 'XX' then prv.NM1_IdentificationCode end primaryCareProviderNPI  
               ,prv.NM1_NameLastOrOrganizationName primaryCareProviderLastOrOrganizationName  
               ,prv.NM1_NameFirst primaryCareProviderFirstName  
               ,prva.N3_AddressInformation primaryCareProviderAddressLine1  
               ,prva.N3_AddressInformation2 primaryCareProviderAddressLine2  
               ,prva.N4_CityName primaryCareProviderCityName  
               ,prva.N4_PostalCode primaryCareProviderZipCode  
               ,prva.N4_StateOrProvinceCode primaryCareProviderStateCode  
               ,d.Loop2100B_NM1_NameLastOrOrganizationName memberPriorIncorrectLastName  
               ,d.Loop2100B_NM1_NameFirst memberPriorIncorrectFirstName  
               ,d.Loop2100B_NM1_NameMiddle memberPriorIncorrectMiddleName  
               ,d.Loop2100B_NM1_NamePrefix memberPriorIncorrectNamePrefix  
               ,d.Loop2100B_NM1_NameSuffix memberPriorIncorrectNameSuffix  
               ,d.Loop2100B_NM1_IdentificationCodeQualifier memberPriorIncorrectIdentificationCodeQualifier  
               ,d.Loop2100B_NM1_IdentificationCode memberPriorIncorrectIdentificationCode  
               ,d.Loop2100B_DMG_DateTimePeriod memberPriorIncorrectBirthDate  
               ,d.Loop2100B_DMG_GenderCode memberPriorIncorrectGenderCode  
               ,d.Loop2100B_DMG_MaritalStatusCode memberPriorIncorrectMaritalStatusCode  
               ,d.Loop2100B_DMG_RaceOrEthnicityCode memberPriorIncorrectRaceCode  
               ,d.Loop2100B_DMG_CitizenshipStatusCode memberPriorIncorrectCitizenshipStatusCode  
               ,d.Loop2100B_DMG_IndustryCode memberPriorIncorrectRaceCollectionCode  
               ,try_convert(datetime2, h.BGN_Date + ' ' + substring(h.BGN_Time, 1, 2) + ':' + substring(h.BGN_Time, 3, 2)) transactionSetCreateDateTime  
               ,ml.LUI_IdentificationCode memberLanguageCode 
               ,ml.LUI_UseOfLanguageIndicator memberLanguageUseCode 
               ,substring(cob.COB_ReferenceIdentification, 1, charindex('+', cob.COB_ReferenceIdentification)-1) enrollmentIdentifier
           from EdmStageX220.CoordinationOfBenefit cob
           join EdmStageX220.HealthCoverage hc on cob.FileRequestId = hc.FileRequestId
                                              and cob.HealthCoverageId = hc.HealthCoverageId
           join EdmStageX220.CoordinationOfBenefitDate cobb on cob.FileRequestId = cobb.FileRequestId
                                                           and cob.CoordinationOfBenefitId = cobb.CoordinationOfBenefitId
"          												   and cobb.DTP_DateTimeQualifier = 344 -- begin"
           join EdmStageX220.CoordinationOfBenefitDate cobe on cob.FileRequestId = cobe.FileRequestId
                                                           and cob.CoordinationOfBenefitId = cobe.CoordinationOfBenefitId
"   	      											  and cobe.DTP_DateTimeQualifier = 345 -- end"
           join EdmStageX220.Detail d on cob.FileRequestId = d.FileRequestId
                                     and cob.detailId = d.detailId
           join EdmStageX220.Header h on d.FileRequestId = h.FileRequestId
                                     and d.HeaderId = h.headerId
           join EdmStageX220.MemberLevelIdentifier mli on d.FileRequestId = mli.FileRequestId
                                                      and d.detailId = mli.detailId
"   	      	                                           -- subscriber/patient primary number  "
                                                      and mli.REF_ReferenceIdentificationQualifier = '0F'  
           left join EdmStageX220.ProviderInformation prv on hc.HealthCoverageId = prv.HealthCoverageId  
                                                         and hc.FileRequestId = prv.FileRequestId  
"           										         -- primary care provider  "
"           								                and prv.NM1_EntityIdentifierCode = 'P3'  "
           left join EdmStageX220.ProviderAddress prva on prv.ProviderInformationId = prva.ProviderInformationId  
                                                      and prv.FileRequestId = prva.FileRequestId 
           left join EdmStageX220.MemberLanguage ml on d.DetailId = ml.DetailId 
                                                   and d.FileRequestId = ml.FileRequestId 
           left join EdmStageX220.HealthCoveragePolicy hce on cob.FileRequestId = hce.FileRequestId
                                                          and cob.HealthCoverageId = hce.HealthCoverageId
"														   -- enrollmentIdentifier"
"          												  and hce.REF_ReferenceIdentificationQualifier = 'X9' "
           left join EdmStageX220.MemberLevelIdentifier gp on d.FileRequestId = gp.FileRequestId  
                                                          and d.DetailId = gp.DetailId  
                                                           -- group policy number  
                                                          and gp.REF_ReferenceIdentificationQualifier = '1L'  
          where cob.FileRequestId = @fileRequestId
            and cob.COB_ReferenceIdentification like '%MED[_]%'
"			  ) t) x"
"		option (maxdop 4, recompile) 	1	2020-01-14 16:19:29.8266667	mssql"
"160	71	STRIVE_MEMBER_ADDRESS-INSERT_BULK_REQUEST_STAGE	declare @fileRequestId bigint = :fileRequestId ;"
declare @clientId int = :clientId ;

insert into MPI.BulkRequestStage
       (BulkRequestStageId
       ,ClientIdentifier
       ,OriginalPatientIdentifier
       ,CurrentPatientIdentifier
       ,PolicyNumber
       ,FirstName
       ,MiddleName
       ,LastName
       ,SSN
       ,DOB
       ,Gender
       ,AddressLine1
       ,AddressLine2
       ,City
       ,State
       ,ZIP
       ,Telephone)
select stageId BulkRequestStageId
      ,c.clientCode ClientIdentifier
      ,x.employeeID OriginalPatientIdentifier
      ,null CurrentPatientIdentifier
      ,x.employeeID PolicyNumber
      ,isnull(firstName, 'Unknown') FirstName
      ,null MiddleName
      ,isnull(lastName, 'Unknown') LastName
      ,case when len(employeeTaxID)>8 then employeeTaxID end SSN
      ,convert(varchar(10), coalesce(try_convert(date, birthDate, 101)
                                    ,try_convert(date, case when left(birthDate, 2) like '%/%' then '0' + left(birthDate, 1)
                                                       else left(birthDate, 2) end + '/' +
                                                       case when substring(birthDate, charindex('/', birthDate)+1, 2) like '%/%' then '0' + left(substring(birthDate, charindex('/', birthDate)+1, 2), 1)
                                                             else substring(birthDate, charindex('/', birthDate)+1, 2) end + '/' +
                                                       right(birthDate, 4), 101)
                                    ,convert(date, left(birthDate, 10), 121))) + ' 00:00:00'  DOB
      ,gender Gender
      ,addressLine1 AddressLine1
      ,addressLine2 AddressLine2
      ,cityName City
      ,stateCode State
      ,postalZoneCode ZIP
      ,primaryTelephoneNumber Telephone
  from EdmStage.DouglasCounty_Member x
  join Reference.Client c on c.clientId = @clientId
" where fileRequestId = @fileRequestId ;	1	2020-01-24 14:00:37.6266667	mssql"
"161	73	NECA_MEMBER_RETIRE	declare @fileRequestId bigint = :fileRequestId ;"
declare @clientId int = 73 ;

with maximums as (select max(stageId) stageId, max(fileRequestId) fileRequestId from EdmStage.Neca_Member)
insert into EdmStage.Neca_Member
"	  (patientPrimaryNumber"
"	  ,enterprisePatientId"
"	  ,memberSsn"
"	  ,stageId"
"	  ,fileRequestId"
"	  ,subscriberSsn"
"	  ,subscriberLastName"
"	  ,subscriberFirstName"
"	  ,memberPrimaryAddressLine1"
"	  ,memberPrimaryAddressLine2"
"	  ,memberPrimaryAddressCityName"
"	  ,memberPrimaryAddressStateCode"
"	  ,memberPrimaryAddressZipCode"
"	  ,subscriberBirthDate"
"	  ,subscriberGender"
"	  ,subscriberPhone"
"	  ,memberLastName"
"	  ,memberFirstName"
"	  ,memberNumber"
"	  ,memberBirthDate"
"	  ,memberGenderCode"
"	  ,relationshipCode"
"	  ,subscriberPolicyId"
"	  ,clientPlanCode"
"	  ,terminationDate"
"	  ,effectiveDate"
"	  ,local"
"	  ,subgroup"
"	  ,benefitPlan"
"	  ,emailAddress"
"	  ,groupPolicyNumber"
"	  ,planNumber"
"	  ,patientPrimaryNumberQualifier"
"	  ,enterpriseSubscriberId"
"	  ,subscriberPrimaryNumber"
"	  ,subscriberPrimaryNumberQualifier"
"	  ,memberPhoneNumber"
"	  ,transactionSetCreationDateTime)"
select p.patientPrimaryNumber
"	  ,p.enterprisePatientId"
"	  ,p.patientSsn memberSsn"
"	  ,row_number() over(partition by 1 order by p.patientId) + m.stageId stageId"
"	  ,m.fileRequestId"
"	  ,null subscriberSsn"
"	  ,null subscriberLastName"
"	  ,null subscriberFirstName"
"	  ,ad.addressLine1 memberPrimaryAddressLine1"
"	  ,ad.addressLine2 memberPrimaryAddressLine2"
"	  ,ad.city memberPrimaryAddressCityName"
"	  ,ad.state memberPrimaryAddressStateCode"
"	  ,ad.zip memberPrimaryAddressZipCode"
"	  ,null subscriberBirthDate"
"	  ,null subscriberGender"
"	  ,null subscriberPhone"
"	  ,p.patientLastName memberLastName"
"	  ,p.patientFirstName memberFirstName"
"	  ,e.patientSequenceNumber memberNumber"
"	  ,convert(varchar(10), p.patientBirthDate, 112) memberBirthDate"
"	  ,p.patientGenderCode memberGenderCode"
"	  ,p.relationshipCode"
"	  ,null subscriberPolicyId"
"	  ,null clientPlanCode"
"	  ,convert(varchar(10), dateadd(day, -1, cast(year(sysdatetime()) as varchar(4)) + '-'+ cast(month(sysdatetime()) as varchar(2)) + '-01'), 112) terminationDate"
"	  ,convert(varchar(10), e.benefitPlanStartDate, 112)  effectiveDate"
"	  ,local"
"	  ,subgroup"
"	  ,benefitPlan"
"	  ,em.emailAddress"
"	  ,gp.groupPolicyNumber"
"	  ,pl.planNumber"
"	  ,p.patientPrimaryNumberQualifier"
"	  ,case when p.relationshipCode = '18' then p.enterprisePatientId else p.enterpriseSubscriberId end enterpriseSubscriberId"
"	  ,p.subscriberPrimaryNumber"
"	  ,p.subscriberPrimaryNumberQualifier"
"	  ,null memberPhoneNumber"
"	  ,substring(replace(convert(varchar(30), p.transactionSetCreationDateTime), ' ', 'T'), 1, 19) transactionSetCreationDateTime"
from Patient.PatientDim p
cross apply maximums m
left join Patient.PatientDim sub on p.clientId = sub.clientId
"								and p.enterpriseSubscriberId = sub.enterprisePatientId"
"								and p.recordTypeId = 28"
left join Patient.EmailDim em on p.clientId = em.clientId
"								and p.patientId = em.patientId"
"								and em.activeFlag = 1"
left join Patient.AddressDim ad on p.clientId = ad.clientId
"								and p.patientId = ad.patientId"
"								and ad.activeFlag = 1"
left join EdmStage.Neca_Member s on p.enterprisePatientId = s.enterprisePatientId
join Patient.EligibilityFact e on p.clientId = e.clientId
"								and p.patientId = e.patientId"
"								and e.eligibilityFactActiveFlag = 1"
"								and (e.benefitPlanEndDate is null"
"									or e.benefitPlanEndDate > sysdatetime())"
join Reference.GroupPolicy gp on e.groupPolicyId = gp.groupPolicyId
join Reference.Plans pl on e.benefitPlanId = pl.plansId
where p.clientId = @clientId
"	and p.patientActiveFlag = 1"
"	and s.stageId is null; 	1	2020-02-04 12:24:23.7366667	mssql"
"162	37	MERGE_ZIP	declare @fileRequestId bigint = :fileRequestId ;"

insert into Reference.Geography
      (geographyId
      ,geographyZipCode
      ,geographyZip4CodeLow
      ,geographyZip4CodeHigh
      ,geographyCityName
      ,geographyStateCode
      ,geographyCountyName
      ,geographyAreaCode
      ,geographyCityTypeCode
      ,geographyCityAliasAbbreviation
      ,geographyCityAliasName
      ,geographyLatitude
      ,geographyLongitude
      ,geographyElevation
      ,geographyTimeZone
      ,geographyCountyFipsCode
      ,geographyDayLightSavingFlag
      ,geographyPreferredLastLineKey
      ,geographyClassificationCode
      ,geographyMultiCountyFlag
      ,geographyStateFipsCode
      ,geographyCityStateKey
      ,geographyCityAliasCode
      ,geographyPrimaryRecord
      ,geographyCityNameMixedCase
      ,geographyCityNameAliasMixedCase
      ,geographyStateAnsiCode
      ,geographyCountyAnsiCode
      ,geographyFacilityCode
      ,geographyCityDeliveryInd
      ,geographyCarrierRouteRateSortation
      ,geographyFinanceNumber
      ,geographyUniqueZipName
      ,geographyDistinctLevel
      ,geographyTimezoneName
      ,lastFileRequestId
      ,createDateTime)
select next value for Reference.GeographySEQ
      ,f.zipCode geographyZipCode
      ,null geographyZip4CodeLow
      ,null geographyZip4CodeHigh
      ,f.city geographyCityName
      ,f.state geographyStateCode
      ,f.countyName geographyCountyName
      ,f.areaCode geographyAreaCode
      ,f.cityType geographyCityTypeCode
      ,f.cityAliasAbbreviation geographyCityAliasAbbreviation
      ,f.cityAlias geographyCityAliasName
      ,f.latitude geographyLatitude
      ,f.longitude geographyLongitude
      ,f.elevation geographyElevation
      ,f.timezone geographyTimeZone
      ,f.countyFips geographyCountyFipsCode
      ,f.daylightSavings geographyDayLightSavingFlag
      ,f.preferredLastLineKey geographyPreferredLastLineKey
      ,f.classificationCode geographyClassificationCode
      ,f.multiCountyFlag geographyMultiCountyFlag
      ,f.stateFips geographyStateFipsCode
      ,f.cityStateKey geographyCityStateKey
      ,f.cityAliasCode geographyCityAliasCode
      ,f.primaryRecord geographyPrimaryRecord
      ,f.cityMixedCase geographyCityNameMixedCase
      ,f.cityAliasMixedCase geographyCityNameAliasMixedCase
      ,f.stateAnsiCode geographyStateAnsiCode
      ,f.countyAnsiCode geographyCountyAnsiCode
      ,f.facilityCode geographyFacilityCode
      ,f.cityDeliveryIndicator geographyCityDeliveryInd
      ,f.carrierRouteRateSortation geographyCarrierRouteRateSortation
      ,f.financeNumber geographyFinanceNumber
      ,f.uniqueZipNameIndicator geographyUniqueZipName
      ,'ZIP' geographyDistinctLevel
      ,null geographyTimezoneName
      ,@fileRequestId
      ,sysdatetime()
  from EdmStage.ZipCode_ZIP f
  left join Reference.Geography g on f.zipCode = g.geographyZipCode
                                 and g.geographyDistinctLevel = 'ZIP'
 where try_convert(int, zipCode) is not null
   and g.geographyId is null
   and f.primaryRecord = 'P';

insert into Reference.Geography
      (geographyId
      ,geographyCityName
      ,geographyStateCode
      ,geographyCityAliasAbbreviation
      ,geographyCityAliasName
      ,geographyPreferredLastLineKey
      ,geographyStateFipsCode
      ,geographyCityStateKey
      ,geographyPrimaryRecord
      ,geographyCityNameMixedCase
      ,geographyCityNameAliasMixedCase
      ,geographyStateAnsiCode
      ,geographyFacilityCode
      ,geographyDistinctLevel
      ,lastFileRequestId
      ,createDateTime)
select next value for Reference.GeographySEQ geographyId
      ,geographyCityName
      ,geographyStateCode
      ,geographyCityAliasAbbreviation
      ,geographyCityAliasName
      ,geographyPreferredLastLineKey
      ,geographyStateFipsCode
      ,geographyCityStateKey
      ,geographyPrimaryRecord
      ,geographyCityNameMixedCase
      ,geographyCityNameAliasMixedCase
      ,geographyStateAnsiCode
      ,geographyFacilityCode
      ,geographyDistinctLevel
      ,@fileRequestId
      ,sysdatetime()
  from (select distinct 
               f.city geographyCityName
              ,f.state geographyStateCode
              ,f.cityAliasAbbreviation geographyCityAliasAbbreviation
              ,f.cityAlias geographyCityAliasName
              ,f.preferredLastLineKey geographyPreferredLastLineKey
              ,f.stateFips            geographyStateFipsCode
              ,f.cityStateKey         geographyCityStateKey
              ,f.primaryRecord        geographyPrimaryRecord
              ,f.cityMixedCase        geographyCityNameMixedCase
              ,f.cityAliasMixedCase   geographyCityNameAliasMixedCase
              ,f.stateAnsiCode        geographyStateAnsiCode
              ,f.facilityCode         geographyFacilityCode
              ,'CITY'               geographyDistinctLevel
          from EdmStage.ZipCode_ZIP f
          left join Reference.Geography g on f.state = g.geographyStateCode
                                         and f.city = g.geographyCityName
                                         and g.geographyDistinctLevel = 'CITY'
         where f.state is not null
           and f.primaryRecord = 'P'
           and g.geographyId is null ) x;

insert into Reference.Geography
      (geographyId
"	  ,geographyStateCode"
      ,geographyStateFipsCode
      ,geographyStateAnsiCode
      ,geographyDistinctLevel
      ,lastFileRequestId
      ,createDateTime)
select next value for Reference.GeographySEQ geographyId
      ,geographyStateCode
      ,geographyStateFipsCode
"	  ,geographyStateAnsiCode"
"	  ,geographyDistinctLevel"
      ,@fileRequestId
      ,sysdatetime()
  from (select distinct
               f.state geographyStateCode
              ,f.stateFips geographyStateFipsCode
              ,f.stateAnsiCode geographyStateAnsiCode
              ,'STATE' geographyDistinctLevel
          from EdmStage.ZipCode_ZIP f
          left join Reference.Geography g on f.state = g.geographyStateCode
                                         and g.geographyDistinctLevel = 'STATE'
         where f.state is not null
           and f.primaryRecord = 'P'
"           and g.geographyId is null ) x; 	1	2020-02-05 17:28:39.6600000	mssql"
"163	37	MERGE_ZIP4	declare @fileRequestId bigint = :fileRequestId ; "

-- dedup to prevent infinite recursion ;
drop table if exists EdmStage.ZipCode_ZIPPlus4_dedup ;
select *
  into EdmStage.ZipCode_ZIPPlus4_dedup
  from (select *
              ,rank() over(partition by zipCode, plus4Low order by stageId desc) rnk
          from EdmStage.ZipCode_ZIPPlus4
"		 where baseAlternateCode = 'B'"
"	       and ActionType = 'A'"
"	       and try_convert(int, plus4Low) is not null"
"		   and 1 = 2) x"
 where x.rnk = 1 ;

insert into EdmStage.ZipCode_ZIPPlus4_dedup
select *  
  from (select *
              ,rank() over(partition by zipCode, plus4Low order by stageId desc) rnk
          from EdmStage.ZipCode_ZIPPlus4
"		 where baseAlternateCode = 'B'"
"	       and ActionType = 'A'"
"	       and try_convert(int, plus4Low) is not null) x"
 where x.rnk = 1 ;

create index ZipCode_ZIPPlus4_dedupIdx on EdmStage.ZipCode_ZIPPlus4_dedup(zipCode, plus4Low)
include (fileRequestId
"		,stageId"
"		,plus4High) ;"

-- ok, start working ...
#NAME?
drop table if exists ##zip4_temp ;
create table ##zip4_temp
(fileRequestId bigint
,zipCode nvarchar(255)
,plus4Low nvarchar(255)
,plus4High nvarchar(255)) ;

#NAME?
-- corresponding Reference.Geography record, if exists
drop table if exists ##zip4_temp2 ;
create table ##zip4_temp2
(geographyId bigint
,geographyZip4CodeLow nvarchar(255)
,geographyZip4CodeHigh nvarchar(255)
,fileRequestId bigint
,zipCode nvarchar(255)
,plus4Low nvarchar(255)
,plus4High nvarchar(255)
,isNew int
,isTooLow int
,isTooHigh int) ;

#NAME?
drop table if exists ##zip4_temp3 ;
create table ##zip4_temp3
(fileRequestId bigint
,geographyId bigint
,geographyZip4CodeLow nvarchar(255)
,geographyZip4CodeHigh nvarchar(255)
,zipCode nvarchar(255)
,plus4Low nvarchar(255)
,plus4High nvarchar(255)
,rangeCount int
,hasOverlap int
,isNew int
,isTooLow int
,isTooHigh int) ;

#NAME?
drop table if exists ##zip4_final ;
create table ##zip4_final
(fileRequestId bigint
,geographyId bigint
,geographyZip4CodeLow nvarchar(255)
,geographyZip4CodeHigh nvarchar(255)
,zipCode nvarchar(255)
,plus4Low nvarchar(255)
,plus4High nvarchar(255)
,rangeCount int
,hasOverlap int
,isNew int
,isTooLow int
,isTooHigh int) ;

with zipCodeList as 
     (select fileRequestId
            ,stageId
            ,zipCode
            ,0 lvl
            ,plus4Low
            ,try_convert(int, plus4Low) plus4LowInt 
            ,plus4High
"		    ,rank() over(partition by zipCode order by rnk) rnk"
        from (select fileRequestId
                    ,stageId
"	                ,zipCode"
"					,0 lvl"
"	                ,plus4Low"
"					,try_convert(int, plus4Low) plus4LowInt "
"	                ,plus4High"
"	                ,case when try_convert(int, plus4Low) is not null and"
"	                           try_convert(int, lag(plus4Low, 1) over(partition by zipCode order by plus4Low, plus4High)) is not null "
                          then try_convert(int, plus4Low) - try_convert(int, lag(plus4Low, 1) over(partition by zipCode order by plus4Low, plus4High))
                          when rank() over(partition by zipCode order by plus4Low, plus4High) = 1 then 1
"		             end diff"
                    ,rank() over(partition by zipCode order by plus4Low) rnk
                from EdmStage.ZipCode_ZIPPlus4_dedup
               where try_convert(int, plus4Low) is not null) x
        where x.rnk = 1
           or x.diff > 1
"		union all"
"		select c.fileRequestId"
              ,c.stageId
"	          ,c.zipCode"
"			  ,p.lvl + 1 lvl"
"	          ,c.plus4Low"
"			  ,try_convert(int, p.plus4Low)+ 1 plus4LowInt"
"	          ,c.plus4High"
"			  ,p.rnk"
"		  from EdmStage.ZipCode_ZIPPlus4_dedup c "
"		  join zipCodeList p on c.zipCode = p.zipCode"
"		                    and try_convert(int, c.plus4Low) = p.plus4LowInt + 1"
"		 where try_convert(int, c.plus4Low) is not null)"
insert into ##zip4_temp
select fileRequestId
      ,zipCode
"	  ,min(plus4Low) plus4Low"
"	  ,max(plus4Low) plus4High"
  from zipCodeList
 group by fileRequestId
         ,zipCode
"		 ,rnk"
 option (maxrecursion 10000) ;

#NAME?
#NAME?
#NAME?
insert into ##zip4_temp2
select g.geographyId
      ,g.geographyZip4CodeLow
"	  ,g.geographyZip4CodeHigh"
      ,a.*
"	  ,case when g.geographyId is null then 1 else 0 end isNew"
"	  ,case when g.geographyId is not null"
"	         and a.plus4High > g.geographyZip4CodeHigh"
"			then 1 "
"			else 0 end isTooLow"
"	  ,case when g.geographyId is not null"
"	         and a.plus4Low < g.geographyZip4CodeLow"
"			then 1 "
"			else 0 end isTooHigh"
  from ##zip4_temp a
  left join Reference.Geography g on a.zipCode = geographyZipCode
                                 and g.geographyDistinctLevel = 'ZIP4'
"								 and a.plus4Low <= g.geographyZip4CodeLow"
"								 and a.plus4High >= g.geographyZip4CodeHigh"
  where case when g.geographyId is null
"	        then 1"
"	        when a.plus4Low < g.geographyZip4CodeLow"
"			  or a.plus4High > g.geographyZip4CodeHigh"
"			then 1 "
"			else 0 end = 1 ;"

#NAME?
insert into ##zip4_temp3
select fileRequestId
      ,geographyId
"	  ,geographyZip4CodeLow"
"	  ,geographyZip4CodeHigh"
"	  ,zipCode"
"	  ,case when max(geographyZip4CodeLow) over(partition by zipCode, plus4Low, plus4High) > min(geographyZip4CodeHigh) over(partition by zipCode, plus4Low, plus4High)"
"	        then geographyZip4CodeLow"
"			else plus4Low"
"	   end plus4Low"
      ,case when count(*) over(partition by zipCode, plus4Low, plus4High) > 1 
"	         and lead(geographyZip4CodeLow, 1) over(partition by zipCode, plus4Low, plus4High order by geographyZip4CodeLow, geographyZip4CodeHigh) is not null"
"	        then right('0000' + convert(varchar(4), convert(int, lead(geographyZip4CodeLow, 1) over(partition by zipCode, plus4Low, plus4High order by geographyZip4CodeLow, geographyZip4CodeHigh)) - 1), 4)"
"			else plus4High"
"	   end plus4High"
"	  ,count(*) over(partition by zipCode, plus4Low, plus4High) rangeCount"
"	  ,case when max(geographyZip4CodeLow) over(partition by zipCode, plus4Low, plus4High) > min(geographyZip4CodeHigh) over(partition by zipCode, plus4Low, plus4High) then 1 else 0 end hasOverlap"
"	  ,max(isNew) over(partition by zipCode, plus4Low, plus4High) isNew"
"	  ,case when max(geographyZip4CodeLow) over(partition by zipCode, plus4Low, plus4High) > min(geographyZip4CodeHigh) over(partition by zipCode, plus4Low, plus4High) then 0 else max(isTooLow) over(partition by zipCode, plus4Low, plus4High) end isTooLow"
"	  ,case when max(geographyZip4CodeLow) over(partition by zipCode, plus4Low, plus4High) > min(geographyZip4CodeHigh) over(partition by zipCode, plus4Low, plus4High) then 0 else max(isTooHigh) over(partition by zipCode, plus4Low, plus4High) end isTooHigh"
  from ##zip4_temp2 ;

insert into ##zip4_final
select *
  from ##zip4_temp3 
 where (geographyZip4CodeLow <> plus4Low
     or geographyZip4CodeHigh  <> plus4High); 

/*
select *
  from ##zip4_final ;

declare @zipCode nvarchar(5) = '34001' ; 

select zipCode
      ,plus4Low
"	  ,plus4High"
  from EdmStage.ZipCode_ZIPPlus4 
 where zipCode = @zipCode
 order by plus4Low

select *
  from ##zip4_final
 where zipCode = @zipCode
 order by plus4Low

select *
  from ##zip4_temp
 where zipCode = @zipCode
 order by plus4Low

select *
  from Reference.Geography
 where geographyDistinctLevel = 'ZIP4'
   and geographyZipCode = @zipCode
 order by geographyZip4CodeLow, geographyZip4CodeHigh ; 

select *
  from Reference.Geography
 where geographyDistinctLevel = 'ZIP'
   and geographyZipCode = @zipCode
 order by geographyZip4CodeLow, geographyZip4CodeHigh ; 
*/

#NAME?
#NAME?
merge into Reference.Geography m
using (select * from ##zip4_final where isNew = 0) u
   on m.geographyId = u.geographyId
 when matched then update set m.geographyZip4CodeLow = case when u.isTooHigh = 1 then u.plus4Low else m.geographyZip4CodeLow end
                             ,m.geographyZip4CodeHigh = case when u.hasOverlap = 1 then u.plus4High 
"							                                 when u.isTooLow = 1 then u.plus4High else m.geographyZip4CodeHigh end"
"							 ,m.lastFileRequestId = u.fileRequestId"
"							 ,m.updateDateTime = sysdatetime();"

#NAME?
insert into Reference.Geography
      (geographyId
"	  ,geographyZipCode"
      ,geographyZip4CodeLow
"	  ,geographyZip4CodeHigh"
"	  ,geographyCityName"
"	  ,geographyStateCode"
"	  ,geographyCountyName"
"	  ,geographyAreaCode"
"	  ,geographyCityTypeCode"
"	  ,geographyCityAliasAbbreviation"
"	  ,geographyCityAliasName"
"	  ,geographyLatitude"
"	  ,geographyLongitude"
"	  ,geographyElevation"
"	  ,geographyTimeZone"
"	  ,geographyCountyFipsCode"
"	  ,geographyDayLightSavingFlag"
"	  ,geographyPreferredLastLineKey"
"	  ,geographyClassificationCode"
"	  ,geographyMultiCountyFlag"
"	  ,geographyStateFipsCode"
"	  ,geographyCityStateKey"
"	  ,geographyCityAliasCode"
"	  ,geographyPrimaryRecord"
"	  ,geographyCityNameMixedCase"
"	  ,geographyCityNameAliasMixedCase"
"	  ,geographyStateAnsiCode"
"	  ,geographyCountyAnsiCode"
"	  ,geographyFacilityCode"
"	  ,geographyCityDeliveryInd"
"	  ,geographyCarrierRouteRateSortation"
"	  ,geographyFinanceNumber"
"	  ,geographyUniqueZipName"
"	  ,geographyDistinctLevel"
"	  ,geographyTimezoneName"
"	  ,lastFileRequestId"
"	  ,createDateTime)"
select next value for Reference.GeographySEQ
      ,g.geographyZipCode
      ,f.plus4Low geographyZip4CodeLow
"	  ,f.plus4High geographyZip4CodeHigh"
"	  ,g.geographyCityName"
"	  ,g.geographyStateCode"
"	  ,g.geographyCountyName"
"	  ,g.geographyAreaCode"
"	  ,g.geographyCityTypeCode"
"	  ,g.geographyCityAliasAbbreviation"
"	  ,g.geographyCityAliasName"
"	  ,g.geographyLatitude"
"	  ,g.geographyLongitude"
"	  ,g.geographyElevation"
"	  ,g.geographyTimeZone"
"	  ,g.geographyCountyFipsCode"
"	  ,g.geographyDayLightSavingFlag"
"	  ,g.geographyPreferredLastLineKey"
"	  ,g.geographyClassificationCode"
"	  ,g.geographyMultiCountyFlag"
"	  ,g.geographyStateFipsCode"
"	  ,g.geographyCityStateKey"
"	  ,g.geographyCityAliasCode"
"	  ,g.geographyPrimaryRecord"
"	  ,g.geographyCityNameMixedCase"
"	  ,g.geographyCityNameAliasMixedCase"
"	  ,g.geographyStateAnsiCode"
"	  ,g.geographyCountyAnsiCode"
"	  ,g.geographyFacilityCode"
"	  ,g.geographyCityDeliveryInd"
"	  ,g.geographyCarrierRouteRateSortation"
"	  ,g.geographyFinanceNumber"
"	  ,g.geographyUniqueZipName"
"	  ,'ZIP4' geographyDistinctLevel"
"	  ,g.geographyTimezoneName"
"	  ,f.fileRequestId"
"	  ,sysdatetime()"
  from ##zip4_final f
  join Reference.Geography g on f.zipCode = g.geographyZipCode
                            and g.geographyDistinctLevel = 'ZIP'
 where f.isNew = 1 
"   and g.geographyId is null ; 	1	2020-02-05 17:40:19.4433333	mssql"
"164	73	NECA_SUBSCRIBER_INFO-MAX_MISSING_COUNT	select count(*)"
  from EdmStage.Neca_Member
" where enterpriseSubscriberId is null	1	2020-02-17 14:15:07.1466667	mssql"
"165	38	MPI-INSERT_MANUAL_MEMBERS	/*"
"	Purpose: associate manually added temporary members to other temporary members or members on file."
*/
set nocount on ;

/*
CREATE NONCLUSTERED INDEX [PatientDimIdx4]
ON [Patient].[PatientDim] ([clientId],[patientBirthDate],[recordTypeId],[patientActiveFlag],[patientId])
INCLUDE ([patientPrimaryNumber],[patientFirstName],[patientLastName])
GO
*/

declare @fileRequestId bigint = :fileRequestId ;

declare @firstNameLen int  ;
declare @lastNameLen int ;

select @firstNameLen = isnull(try_convert(int, outValue), 2)
  from EdmLib.Mapping
 where name = 'MD_MEMBER_PREPROCESS'
   and inValue = 'FIRST_NAME_LEN' ;

select @lastNameLen = isnull(try_convert(int, outValue), 4)
  from EdmLib.Mapping
 where name = 'MD_MEMBER_PREPROCESS'
   and inValue = 'LAST_NAME_LEN' ;

drop table if exists EdmStage.MD_TempMemberStage ;

create table EdmStage.MD_TempMemberStage
(matchTypeId int 
,matchTypeName nvarchar(255)
,clientId int
,tempPatientId nvarchar(255)
,tempPatientIdCount int
,tempPatientIdList nvarchar(max)
,patientIdList nvarchar(max)
,patientNumberList nvarchar(max)
,patientCount int) ;

insert into EdmStage.MD_TempMemberStage
select 1 matchTypeId
      ,'dob|ssn' matchTypeName
      ,clientId
      ,min(case when patientPrimaryNumber like 'TEMP%' and recordTypeId in (11, 13, 36) then patientPrimaryNumber end) tempPatientId
"	  ,count(distinct case when patientPrimaryNumber like 'TEMP%' and recordTypeId in (11, 13, 36) then patientPrimaryNumber end) tempPatientIdCount"
      ,string_agg(case when patientPrimaryNumber like 'TEMP%' and recordTypeId in (11, 13, 36) then patientPrimaryNumber end, ',') within group (order by patientId) tempPatientIdList
"	  ,string_agg(patientId, ',') within group (order by patientId)  patientIdList"
"	  ,string_agg(patientPrimaryNumber, ',') within group (order by patientId)  patientNumberList"
"	  ,count(distinct patientPrimaryNumber) patientCount"
  from Patient.PatientDim
 where clientId = 38
   and patientActiveFlag = 1
   and patientSsn is not null
   and patientPrimaryNumber <> 'TEMP'
 group by clientId
         ,patientBirthDate
         ,patientSsn
having count(*) > 1
   and sum(case when patientPrimaryNumber like 'TEMP%' and recordTypeId in (11, 13, 36) then 1 else 0 end) > 0 
option (maxdop 1) ; 
 
insert into EdmStage.MD_TempMemberStage
select 2 matchTypeId
      ,'dob|firstName' + convert(varchar(2), @firstNameLen) + '|lastName' + convert(varchar(2), @lastNameLen) matchTypeName
      ,clientId
      ,min(case when patientPrimaryNumber like 'TEMP%' and recordTypeId in (11, 13, 36) then patientPrimaryNumber end) tempPatientId
"	  ,count(distinct case when patientPrimaryNumber like 'TEMP%' and recordTypeId in (11, 13, 36) then patientPrimaryNumber end) tempPatientIdCount"
      ,string_agg(case when patientPrimaryNumber like 'TEMP%' and recordTypeId in (11, 13, 36) then patientPrimaryNumber end, ',') within group (order by patientId) tempPatientIdList
"	  ,string_agg(patientId, ',') within group (order by patientId)  patientIdList"
"	  ,string_agg(patientPrimaryNumber, ',') within group (order by patientId)  patientNumberList"
"	  ,count(distinct patientPrimaryNumber) patientCount"
  from Patient.PatientDim
 where clientId = 38
   and patientActiveFlag = 1
   and patientPrimaryNumber <> 'TEMP'
 group by clientId
         ,patientBirthDate
         ,left(patientFirstName, @firstNameLen)
         ,left(patientLastName, @lastNameLen)
having count(*) > 1
   and sum(case when patientPrimaryNumber like 'TEMP%' and recordTypeId in (11, 13, 36) then 1 else 0 end) > 0 
option (maxdop 1) ; 

drop table if exists ##temp_MD_members_src_3 ;

create table ##temp_MD_members_src_3 
(lvl int
,clientId int
,tempPatientId bigint
,tempPatientPrimaryNumber nvarchar(255)
,tempBirthDate datetime2
,tempSsn nvarchar(255)
,tempFirstName nvarchar(255)
,tempLastName nvarchar(255)
,tempPatientIdList nvarchar(max)
,tempPatientIdCount int
,currPatientId bigint
,currPatientPrimaryNumber nvarchar(255)
,currBirthDate datetime2
,currSsn nvarchar(255)
,currFirstName nvarchar(255)
,currLastName nvarchar(255)
,patientIdList nvarchar(max)
,patientNumberList nvarchar(max)
,patientCount int
,rnk int) ;

with tempPatientList as
"	 (select 0 lvl"
"			,clientId"
"			,patientId tempPatientId"
"			,patientPrimaryNumber tempPatientPrimaryNumber"
"			,patientBirthDate tempBirthDate"
"			,patientSsn tempSsn"
"			,patientFirstName tempFirstName"
"			,patientLastName tempLastName"
"			,convert(nvarchar(max), patientPrimaryNumber) tempPatientIdList"
"			,1 tempPatientIdCount"
"			,patientId currPatientId"
"			,patientPrimaryNumber currPatientPrimaryNumber"
"			,patientBirthDate currBirthDate"
"			,patientSsn currSsn"
"			,patientFirstName currFirstName"
"			,patientLastName currLastName"
"			,patientId"
"			,patientPrimaryNumber"
"			,patientBirthDate"
"			,patientSsn"
"			,patientFirstName"
"			,patientLastName"
"			,convert(nvarchar(max), patientId) patientIdList"
"			,convert(nvarchar(max), patientPrimaryNumber) patientNumberList"
"			,1 patientCount"
"		from Patient.PatientDim"
"	   where clientId = 38"
"		 and recordTypeId in (11, 13, 36) -- manually added"
"		 and patientPrimaryNumber like 'TEMP%'"
"		 and patientPrimaryNumber <> 'TEMP'"
"		 and patientActiveFlag = 1"
"	   union all"
"	  select t.lvl + 1 lvl"
"			,t.clientId"
"			,t.tempPatientId"
"			,t.tempPatientPrimaryNumber"
"			,t.tempBirthDate"
"			,t.tempSsn"
"			,t.tempFirstName"
"			,t.tempLastName"
"			,convert(nvarchar(max), t.tempPatientIdList + case when pd.patientPrimaryNumber like 'TEMP%' then ',' + pd.patientPrimaryNumber else '' end) tempPatientIdList"
"			,t.tempPatientIdCount + case when pd.patientPrimaryNumber like 'TEMP%' then 1 else 0 end tempPatientIdCount"
"			,pd.patientId currPatientId"
"			,pd.patientPrimaryNumber currPatientPrimaryNumber"
"			,pd.patientBirthDate currBirthDate"
"			,pd.patientSsn currentSsn"
"			,pd.patientFirstName currFirstName"
"			,pd.patientLastName currLastName"
"			,pd.patientId"
"			,pd.patientPrimaryNumber"
"			,pd.patientBirthDate"
"			,pd.patientSsn"
"			,pd.patientFirstName"
"			,pd.patientLastName"
"			,convert(nvarchar(max), t.patientIdList + ',' + convert(nvarchar(255), pd.patientId)) patientIdList"
"			,convert(nvarchar(max), t.patientNumberList + ',' + pd.patientPrimaryNumber) patientNumberList"
"			,t.patientCount + case when t.patientNumberList not like '%' + pd.patientPrimaryNumber + '%' then 1 else 0 end patientCount"
"		from Patient.PatientDim pd"
"		join tempPatientList t on t.clientId = pd.clientId"
"							  and t.currBirthDate = pd.patientBirthDate"
"							  and left(t.currLastName, @firstNameLen) = left(pd.patientFirstName, @firstNameLen)"
"							  and left(t.currFirstName, @lastNameLen) = left(pd.patientLastName, @lastNameLen)"
"							  and t.currPatientId <> pd.patientId"
"							  and t.patientNumberList not like '%' + pd.patientPrimaryNumber + '%'"
"							  and pd.clientId = 38"
"							  --and pd.recordTypeId = 28 -- eligibility file"
"							  and pd.patientActiveFlag = 1)"
insert into ##temp_MD_members_src_3 
select lvl                            
"	  ,clientId"
"	  ,tempPatientId"
"	  ,tempPatientPrimaryNumber"
"	  ,tempBirthDate"
"	  ,tempSsn"
"	  ,tempFirstName"
"	  ,tempLastName"
"	  ,tempPatientIdList"
"	  ,tempPatientIdCount"
"	  ,currPatientId"
"	  ,currPatientPrimaryNumber"
"	  ,currBirthDate"
"	  ,currSsn"
"	  ,currFirstName"
"	  ,currLastName"
"	  ,patientIdList"
"	  ,patientNumberList"
"	  ,patientCount"
"	  ,row_number() over(partition by tempPatientId order by lvl desc) rnk"
  from tempPatientList 
option (maxdop 1) ; 

insert into EdmStage.MD_TempMemberStage
select 3 matchTypeId
      ,'dob|firstName' + convert(varchar(2), @firstNameLen) + '=lastName' + convert(varchar(2), @firstNameLen) + '|lastName' + convert(varchar(2), @lastNameLen) + '=firstName' + convert(varchar(2), @lastNameLen) matchTypeName
      ,clientId
      ,tempPatientPrimaryNumber
"	  ,tempPatientIdCount"
"	  ,tempPatientIdList"
      ,patientIdList
"	  ,patientNumberList"
"	  ,patientCount"
  from ##temp_MD_members_src_3
 where rnk = 1 
   and tempPatientPrimaryNumber <> patientNumberList
 group by clientId
         ,tempPatientPrimaryNumber
         ,tempPatientIdCount
"		 ,tempPatientIdList"
"		 ,patientIdList"
"		 ,patientNumberList"
"		 ,patientCount"
option (maxdop 1) ; 

insert into EdmStage.MD_TempMemberStage
select 4 matchTypeId
      ,'ssn|gender|firstName' + convert(varchar(2), @firstNameLen) + '|lastName' + convert(varchar(2), @lastNameLen) matchTypeName
      ,clientId
      ,min(case when patientPrimaryNumber like 'TEMP%' and recordTypeId in (11, 13, 36) then patientPrimaryNumber end) tempPatientId
"	  ,count(distinct case when patientPrimaryNumber like 'TEMP%' and recordTypeId in (11, 13, 36) then patientPrimaryNumber end) tempPatientIdCount"
      ,string_agg(case when patientPrimaryNumber like 'TEMP%' and recordTypeId in (11, 13, 36) then patientPrimaryNumber end, ',') within group (order by patientId) tempPatientIdList
"	  ,string_agg(patientId, ',') within group (order by patientId) patientIdList"
"	  ,string_agg(patientPrimaryNumber, ',') within group (order by patientId)  patientNumberList"
"	  ,count(distinct patientPrimaryNumber) patientCount"
  from Patient.PatientDim
 where clientId = 38
   and patientActiveFlag = 1
   and patientSsn is not null
   and patientPrimaryNumber <> 'TEMP'
   and patientGenderCode in ('M', 'F')
 group by clientId
         ,patientSsn
         ,patientGenderCode
         ,left(patientFirstName, @firstNameLen)
         ,left(patientLastName, @lastnameLen)
having count(*) > 1
   and sum(case when patientPrimaryNumber like 'TEMP%' and recordTypeId in (11, 13, 36) then 1 else 0 end) > 0
option (maxdop 1) ; 
   
drop table if exists ##temp_MD_members_src_5 ;

create table ##temp_MD_members_src_5 
(lvl int
,clientId int
,tempPatientId bigint
,tempPatientPrimaryNumber nvarchar(255)
,tempBirthDate datetime2
,tempSsn nvarchar(255)
,tempFirstName nvarchar(255)
,tempLastName nvarchar(255)
,tempPatientIdList nvarchar(max)
,tempPatientIdCount int
,currPatientId bigint
,currPatientPrimaryNumber nvarchar(255)
,currBirthDate datetime2
,currSsn nvarchar(255)
,currFirstName nvarchar(255)
,currLastName nvarchar(255)
,patientIdList nvarchar(max)
,patientNumberList nvarchar(max)
,patientCount int
,rnk int) ;

with tempPatientList as
"	 (select 0 lvl"
"			,clientId"
"			,patientId tempPatientId"
"			,patientPrimaryNumber tempPatientPrimaryNumber"
"			,patientBirthDate tempBirthDate"
"			,patientSsn tempSsn"
"			,patientFirstName tempFirstName"
"			,patientLastName tempLastName"
"			,convert(nvarchar(max), patientPrimaryNumber) tempPatientIdList"
"			,1 tempPatientIdCount"
"			,patientId currPatientId"
"			,patientPrimaryNumber currPatientPrimaryNumber"
"			,patientBirthDate currBirthDate"
"			,patientSsn currSsn"
"			,patientGenderCode currGender"
"			,patientFirstName currFirstName"
"			,patientLastName currLastName"
"			,patientId"
"			,patientPrimaryNumber"
"			,patientBirthDate"
"			,patientSsn"
"			,patientFirstName"
"			,patientLastName"
"			,convert(nvarchar(max), patientId) patientIdList"
"			,convert(nvarchar(max), patientPrimaryNumber) patientNumberList"
"			,1 patientCount"
"		from Patient.PatientDim"
"	   where clientId = 38"
"		 and recordTypeId in (11, 13, 36) -- manually added"
"		 and patientPrimaryNumber like 'TEMP%'"
"		 and patientPrimaryNumber <> 'TEMP'"
"		 and patientActiveFlag = 1"
"	   union all"
"	  select t.lvl + 1 lvl"
"			,t.clientId"
"			,t.tempPatientId"
"			,t.tempPatientPrimaryNumber"
"			,t.tempBirthDate"
"			,t.tempSsn"
"			,t.tempFirstName"
"			,t.tempLastName"
"			,convert(nvarchar(max), t.tempPatientIdList + case when pd.patientPrimaryNumber like 'TEMP%' then ',' + pd.patientPrimaryNumber else '' end) tempPatientIdList"
"			,t.tempPatientIdCount + case when pd.patientPrimaryNumber like 'TEMP%' then 1 else 0 end tempPatientIdCount"
"			,pd.patientId currPatientId"
"			,pd.patientPrimaryNumber currPatientPrimaryNumber"
"			,pd.patientBirthDate currBirthDate"
"			,pd.patientSsn currentSsn"
"			,pd.patientGenderCode currGender"
"			,pd.patientFirstName currFirstName"
"			,pd.patientLastName currLastName"
"			,pd.patientId"
"			,pd.patientPrimaryNumber"
"			,pd.patientBirthDate"
"			,pd.patientSsn"
"			,pd.patientFirstName"
"			,pd.patientLastName"
"			,convert(nvarchar(max), t.patientIdList + ',' + convert(nvarchar(255), pd.patientId)) patientIdList"
"			,convert(nvarchar(max), t.patientNumberList + ',' + pd.patientPrimaryNumber) patientNumberList"
"			,t.patientCount + case when t.patientNumberList not like '%' + pd.patientPrimaryNumber + '%' then 1 else 0 end patientCount"
"		from Patient.PatientDim pd"
"		join tempPatientList t on t.clientId = pd.clientId"
"							  and t.currSsn = pd.patientSsn"
"							  and t.currGender = pd.patientGenderCode"
"							  and left(t.currLastName, @firstNameLen) = left(pd.patientFirstName, @firstNameLen)"
"							  and left(t.currFirstName, @lastNameLen) = left(pd.patientLastName, @lastNameLen)"
"							  and t.currPatientId <> pd.patientId"
"							  and t.patientNumberList not like '%' + pd.patientPrimaryNumber + '%'"
"							  and pd.clientId = 38"
"							  --and pd.recordTypeId = 28 -- eligibility file"
"							  and pd.patientActiveFlag = 1)"
insert into ##temp_MD_members_src_5 
select lvl                            
"	  ,clientId"
"	  ,tempPatientId"
"	  ,tempPatientPrimaryNumber"
"	  ,tempBirthDate"
"	  ,tempSsn"
"	  ,tempFirstName"
"	  ,tempLastName"
"	  ,tempPatientIdList"
"	  ,tempPatientIdCount"
"	  ,currPatientId"
"	  ,currPatientPrimaryNumber"
"	  ,currBirthDate"
"	  ,currSsn"
"	  ,currFirstName"
"	  ,currLastName"
"	  ,patientIdList"
"	  ,patientNumberList"
"	  ,patientCount"
"	  ,row_number() over(partition by tempPatientId order by lvl desc) rnk"
  from tempPatientList 
option (maxdop 1) ; 

insert into EdmStage.MD_TempMemberStage
select 5 matchTypeId
      ,'ssn|gender|firstName' + convert(varchar(2), @firstNameLen) + '=lastName' + convert(varchar(2), @firstNameLen) + '|lastName' + convert(varchar(2), @lastNameLen) + '=firstName' + convert(varchar(2), @lastNameLen) matchTypeName
      ,clientId
      ,tempPatientPrimaryNumber
"	  ,tempPatientIdCount"
"	  ,tempPatientIdList"
      ,patientIdList
"	  ,patientNumberList"
"	  ,patientCount"
  from ##temp_MD_members_src_5
 where rnk = 1 
   and tempPatientPrimaryNumber <> patientNumberList
 group by clientId
         ,tempPatientPrimaryNumber
"	     ,tempPatientIdCount"
"	     ,tempPatientIdList"
"		 ,patientIdList"
"	     ,patientNumberList"
"		 ,patientCount "
option (maxdop 1) ; 
 
insert into EdmStage.MD_TempMemberStage
select 6 matchTypeId
      ,'dob|gender|lastName' matchTypeName
      ,clientId
      ,min(case when patientPrimaryNumber like 'TEMP%' and recordTypeId in (11, 13, 36) then patientPrimaryNumber end) tempPatientId
"	  ,count(distinct case when patientPrimaryNumber like 'TEMP%' and recordTypeId in (11, 13, 36) then patientPrimaryNumber end) tempPatientIdCount"
      ,string_agg(case when patientPrimaryNumber like 'TEMP%' and recordTypeId in (11, 13, 36) then patientPrimaryNumber end, ',') within group (order by patientId) tempPatientIdList
"	  ,string_agg(patientId, ',') within group (order by patientId) patientIdList"
"	  ,string_agg(patientPrimaryNumber, ',') within group (order by patientId)  patientNumberList"
"	  ,count(distinct patientPrimaryNumber) patientCount"
  from Patient.PatientDim
 where clientId = 38
   and patientActiveFlag = 1
   and patientPrimaryNumber <> 'TEMP'
 group by clientId
         ,patientLastName
         ,patientBirthDate
"		 ,patientGenderCode"
having count(*) > 1
   and sum(case when patientPrimaryNumber like 'TEMP%' and recordTypeId in (11, 13, 36) then 1 else 0 end) > 0 
option (maxdop 1) ; 

#NAME?
declare @validationCount int ;
declare @message  varchar(1000) ;

select @validationCount = count(*)
  from EdmStage.MD_TempMemberStage
 where tempPatientIdCount > 10
    or patientCount > 10 ;

set @message = 'patient count > 10';
if @validationCount > 0
"	select convert(int, @message) ;"

select @validationCount = count(*)
  from EdmStage.MD_TempMemberStage 
 where try_convert(bigint, tempPatientId) is not null;

set @message = 'tempPatientId must a string: e.g. T0001';
if @validationCount > 0
"	select convert(int, @message) ;"

select @validationCount = count(*)
  from EdmStage.MD_TempMemberStage
 where (tempPatientIdCount = 10 and tempPatientIdList not like '%,%,%,%,%,%,%,%,%')
   and (tempPatientIdCount = 9  and tempPatientIdList not like '%,%,%,%,%,%,%,%,%')
   and (tempPatientIdCount = 8  and tempPatientIdList not like '%,%,%,%,%,%,%,%')
   and (tempPatientIdCount = 7  and tempPatientIdList not like '%,%,%,%,%,%,%')
   and (tempPatientIdCount = 6  and tempPatientIdList not like '%,%,%,%,%,%')
   and (tempPatientIdCount = 5  and tempPatientIdList not like '%,%,%,%,%')
   and (tempPatientIdCount = 4  and tempPatientIdList not like '%,%,%,%')
   and (tempPatientIdCount = 3  and tempPatientIdList not like '%,%,%')
   and (tempPatientIdCount = 2  and tempPatientIdList not like '%,%')
   and (tempPatientIdCount = 1  and tempPatientIdList like '%,%')
option (maxdop 1) ; 

set @message = 'tempPatientIdCount mismatch';
if @validationCount > 0
"	select convert(int, @message) ;"

select @validationCount = count(*)
  from EdmStage.MD_TempMemberStage
 where (patientCount = 10 and patientNumberList not like '%,%,%,%,%,%,%,%,%')
   and (patientCount = 9  and patientNumberList not like '%,%,%,%,%,%,%,%,%')
   and (patientCount = 8  and patientNumberList not like '%,%,%,%,%,%,%,%')
   and (patientCount = 7  and patientNumberList not like '%,%,%,%,%,%,%')
   and (patientCount = 6  and patientNumberList not like '%,%,%,%,%,%')
   and (patientCount = 5  and patientNumberList not like '%,%,%,%,%')
   and (patientCount = 4  and patientNumberList not like '%,%,%,%')
   and (patientCount = 3  and patientNumberList not like '%,%,%')
   and (patientCount = 2  and patientNumberList not like '%,%')
   and (patientCount = 1  and patientNumberList like '%,%')
option (maxdop 1) ; 
  
set @message = 'patientCount mismatch';
if @validationCount > 0
"	select convert(int, @message) ;"

#NAME?
drop table if exists EdmStage.MD_TempMemberStage2 ;

select s.*
      ,convert(nvarchar(255), x.value) patientNumber
  into EdmStage.MD_TempMemberStage2
  from EdmStage.MD_TempMemberStage s
 cross apply string_split(patientNumberList, ',') x 
option (maxdop 1) ; 

drop table if exists EdmStage.MD_TempMemberStage3 ;

select clientId
      ,min(tempPatientId) origTempPatientId
      ,patientNumber
"	  ,string_agg(matchTypeId, ',') matchTypeIdList"
"	  ,string_agg(matchTypeName, ',') matchTypeNameList"
  into EdmStage.MD_TempMemberStage3
  from EdmStage.MD_TempMemberStage2 
 group by clientId
         ,patientNumber 
option (maxdop 1) ; 

drop table if exists EdmStage.MD_TempMemberStage4 ;

select clientId
"      ,origTempPatientId	  "
      ,string_agg(patientNumber, ',') patientNumberList
"	  ,count(distinct patientNumber) patientCount"
      ,string_agg(case when patientNumber not like 'TEMP%' then patientNumber end, ',') medicaidIdList
      ,count(distinct case when patientNumber not like 'TEMP%' then patientNumber end) medicaidIdCount
"	  ,matchTypeIdList"
"	  ,matchTypeNameList"
  into EdmStage.MD_TempMemberStage4
  from EdmStage.MD_TempMemberStage3 
 group by clientId
         ,origTempPatientId
"	     ,matchTypeIdList"
"	     ,matchTypeNameList "
option (maxdop 1) ; 

drop table if exists EdmStage.MD_TempMemberFinal ;

select s.clientId
      ,s.origTempPatientId
      ,s.patientNumberList
"	  ,s.patientCount"
"	  ,s.medicaidIdList"
"	  ,s.medicaidIdCount"
"	  ,convert(nvarchar(255), x.value) patientNumber"
"	  ,matchTypeIdList"
"	  ,matchTypeNameList"
  into EdmStage.MD_TempMemberFinal
  from EdmStage.MD_TempMemberStage4 s
 cross apply string_split(s.patientNumberList, ',') x 
option (maxdop 1) ; 

--select *
#NAME?
-- --order by patientCount desc ;
-- where patientNumberList like'%T00000003828%' -- '%T00000085731%' ; --00210462000
 
--select *
#NAME?
-- where origTempPatientId = 'T00000003828' -- ;'T00000085731';
/* 
select f.*
      ,pd.enterprisePatientId
      ,pd.patientLastName
"	  ,pd.patientFirstName"
"	  ,pd.patientBirthDate"
"	  ,pd.patientSsn"
"	  ,pd.patientGenderCode"
  from EdmStage.MD_TempMemberFinal f
  join Patient.PatientDim pd on f.clientId = pd.clientId
                            and f.patientNumber = pd.patientPrimaryNumber 
 order by 1, 2 ;
*/
 
drop table if exists EdmStage.MD_TempMemberResults ;

select f.origTempPatientId
      ,case when min(upper(pd.patientFirstName)) <> max(upper(pd.patientFirstName)) then 1 else 0 end isDiff_firstName
      ,case when min(upper(pd.patientFirstName)) <> max(upper(pd.patientFirstName)) then string_agg(pd.patientFirstName, ',') end firstNameList
      ,case when min(upper(pd.patientLastName)) <> max(upper(pd.patientLastName)) then 1 else 0 end isDiff_lastName
      ,case when min(upper(pd.patientLastName)) <> max(upper(pd.patientLastName)) then string_agg(pd.patientLastName, ',') end lastNameList
      ,case when min(pd.patientGenderCode) <> max(pd.patientGenderCode) then 1 else 0 end isDiff_gender
      ,case when min(pd.patientGenderCode) <> max(pd.patientGenderCode) then string_agg(pd.patientGenderCode, ',') end genderList
"	  ,case when min(pd.patientBirthDate) <> max(pd.patientBirthDate) or sum(case when pd.patientBirthDate is null then 1 else 0 end)>0 then 1 else 0 end isDiff_dob"
"	  ,case when min(pd.patientSsn) <> max(pd.patientSsn) or sum(case when pd.patientSsn is null then 1 else 0 end)>0 then 1 else 0 end isDiff_ssn"
"	  ,count(*) memberCount"
  into EdmStage.MD_TempMemberResults
  from EdmStage.MD_TempMemberFinal f
  join Patient.PatientDim pd on f.clientId = pd.clientId
                            and f.patientNumber = pd.patientPrimaryNumber 
"							and pd.patientPrimaryNumber <> 'TEMP'"
 group by f.origTempPatientId 
option (maxdop 1) ; 

--select *
#NAME?
-- where not (isDiff_firstName = 0
#NAME?
#NAME?
--   and isDiff_dob = 0)
--   and isDiff_gender = 1;

drop table if exists EdmStage.MD_MPI_Stage ;

select row_number() over(partition by 1 order by origTempPatientId, patientId) stageId
      ,@fileRequestId fileRequestId
      ,x.*
  into EdmStage.MD_MPI_Stage
  from (select f.origTempPatientId
"	          ,convert(nvarchar(4000), f.matchTypeIdList) matchTypeIdList"
              ,pd.patientId
              ,pd.enterprisePatientId originalPatientIdentifier
"	          ,pd.patientPrimaryNumber currentPatientIdentifier"
              ,pd.patientLastName
"	          ,pd.patientMiddleName"
"	          ,pd.patientFirstName"
"	          ,pd.patientBirthDate"
"	          ,pd.patientSsn"
"	          ,pd.patientGenderCode"
"	          ,ad.addressLine1"
"	          ,ad.addressLine2"
"	          ,ad.city"
"	          ,ad.state"
"	          ,ad.zip"
"	          ,ad.patientAddressId"
"			  ,convert(nvarchar(255), null) mpiId"
"	          ,dense_rank() over(partition by pd.clientId, pd.patientId order by ad.createDateTime desc, ad.patientAddressId desc) rnk"
"			  ,pd.recordTypeId"
"			  ,pd.patientRaceCode"
"			  ,pd.patientMedicareNumber"
"			  ,pd.patientDeathDate"
"			  ,pd.patientMedicareIndicatorCode"
"			  ,case when pd.recordTypeId in (11, 13, 36) then 1 else 0 end isTemporaryMember"
          from EdmStage.MD_TempMemberFinal f
          join Patient.PatientDim pd on f.clientId = pd.clientId
                                    and f.patientNumber = pd.patientPrimaryNumber 
"							        and pd.patientActiveFlag = 1"
"									and pd.patientPrimaryNumber <> 'TEMP'"
          left join Patient.AddressDim ad on pd.clientId = ad.clientId
                                         and pd.patientId = ad.patientId
                                         and ad.addressTypeId = 12 
                                         and ad.activeFlag = 1) x
 where x.rnk = 1 
option (maxdop 1) ; 

#NAME?
#NAME?
"--	  ,matchTypeName"
--  from EdmStage.MD_TempMemberStage2 ;

/*
declare @firstName varchar(100) = 'Makins' ;
declare @lastName varchar(100) = 'Abraham' ;
declare @dob datetime2 = '1950-06-15 00:00:00.0000000' ;
declare @ssn varchar(15) = '212564334' ;
declare @gender varchar(1) = 'M' ;

-- 
declare @firstNameLen2 int = 2 ;
declare @lastNameLen2 int = 4 ;
-- 

select enterprisePatientId
      ,patientLastName
"	  ,left(patientLastName, @lastNameLen2)"
"	  ,patientFirstName"
"	  ,left(patientFirstName, @firstNameLen2)"
"	  ,patientBirthDate"
"	  ,patientSsn"
"	  ,patientGenderCode   "
"	  ,recordTypeId"
      ,case when (patientBirthDate = @dob and patientSsn = @ssn) then 1 else 0 end isMatchType1
      ,case when (patientBirthDate = @dob and left(patientFirstName, @firstNameLen2) = left(@firstName, @firstNameLen2) and left(patientLastName, @lastNameLen2) = left(@lastName, @lastNameLen2)) then 1 else 0 end isMatchType2
      ,case when (patientBirthDate = @dob and left(patientFirstName, @firstNameLen2) = left(@lastName, @firstNameLen2) and left(patientLastName, @lastNameLen2) = left(@firstName, @lastNameLen2)) then 1 else 0 end isMatchType3
"	  ,case when (patientSsn = @ssn and patientGenderCode = @gender and left(patientFirstName, @firstNameLen2) = left(@firstName, @firstNameLen2) and left(patientLastName, @lastNameLen2) = left(@lastName, @lastNameLen2)) then 1 else 0 end isMatchType4"
      ,case when (patientSsn = @ssn and patientGenderCode = @gender and left(patientFirstName, @firstNameLen2) = left(@lastName, @firstNameLen2) and left(patientLastName, @lastNameLen2) = left(@firstName, @lastNameLen2)) then 1 else 0 end isMatchType5
      ,case when (patientBirthDate = @dob and patientGenderCode = @gender and patientLastName = @lastName) then 1 else 0 end isMatchType6
  from Patient.PatientDim 
 where clientId = 38
    -- 1 
   and ((patientBirthDate = @dob and patientSsn = @ssn)
    -- 2
    or (patientBirthDate = @dob and left(patientFirstName, @firstNameLen2) = left(@firstName, @firstNameLen2) and left(patientLastName, @lastNameLen2) = left(@lastName, @lastNameLen2)) 
    -- 3
    or (patientBirthDate = @dob and left(patientFirstName, @firstNameLen2) = left(@lastName, @firstNameLen2) and left(patientLastName, @lastNameLen2) = left(@firstName, @lastNameLen2)) 
"	-- 4"
    or (patientSsn = @ssn and patientGenderCode = @gender and left(patientFirstName, @firstNameLen2) = left(@firstName, @firstNameLen2) and left(patientLastName, @lastNameLen2) = left(@lastName, @lastNameLen2)) 
    -- 
    or (patientSsn = @ssn and patientGenderCode = @gender and left(patientFirstName, @firstNameLen2) = left(@lastName, @firstNameLen2) and left(patientLastName, @lastNameLen2) = left(@firstName, @lastNameLen2)) 
    -- 6
    or (patientBirthDate = @dob and patientGenderCode = @gender and patientLastName = @lastName)
"	) "
"*/ 	1	2020-02-28 12:34:21.1766667	mssql"
"166	38	MPI-ADD_NEW_GROUP_POLICIES	-- deactivated for client	0	2020-03-03 11:11:11.0500000	mssql"
"167	38	MPI-ADD_NEW_PLANS	-- deactivated for client	0	2020-03-03 11:12:22.0766667	mssql"
"168	38	MPI-MISSING_MPI_COUNT	select count(*) from <tableSchema>.<tableName> where mpiId is null	1	2020-03-03 11:43:42.7600000	mssql"
"169	38	MPI-MERGE_BULK_REQUEST_STAGE_DEDUP	merge into <tableSchema>.<tableName> m"
using (select mc.fileRequestId
             ,mc.stageId
"       	     ,d.MPIID"
         from <tableSchema>.<tableName> mc
         join MPI.BulkRequestStageDedup d on mc.stageId = d.BulkRequestStageId
                                         and d.MPIID is not null
        where mc.mpiId is null
          and mc.fileRequestId = :fileRequestId) u
   on m.fileRequestId = u.fileRequestId
  and m.stageId = u.stageId
" when matched then update set m.mpiId = u.MPIID; 	1	2020-03-03 11:45:55.4466667	mssql"
"170	38	MPI-INSERT_BULK_REQUEST_STAGE	insert into MPI.BulkRequestStage "
       (BulkRequestStageId 
       ,ClientIdentifier 
       ,OriginalPatientIdentifier 
       ,CurrentPatientIdentifier 
       ,PolicyNumber 
       ,FirstName 
       ,MiddleName 
       ,LastName 
       ,SSN 
       ,DOB 
       ,Gender 
       ,AddressLine1 
       ,AddressLine2 
       ,City 
       ,State 
       ,ZIP 
       ,Telephone)
select m.stageId BulkRequestStageId
"	  ,c.clientCode ClientIdentifier "
      ,m.OriginalPatientIdentifier 
"	  ,m.CurrentPatientIdentifier "
"	  ,null PolicyNumber "
"	  ,upper(isnull(m.patientFirstName, 'UNKNOWN')) FirstName "
"	  ,null MiddleName "
"	  ,upper(isnull(m.patientLastName, 'UNKNOWN')) LastName "
"	  ,case when m.patientSsn = '000000000' then null else m.patientSsn end SSN"
"	  ,convert(varchar(10), m.patientBirthDate, 121) + ' 00:00:00' DOB "
"	  ,isnull(m.patientGenderCode, 'U') Gender "
"	  ,m.addressLine1 AddressLine1 "
"	  ,m.addressLine2 AddressLine2 "
"	  ,m.city City "
"	  ,m.state State "
"	  ,m.zip ZIP "
"	  ,null Telephone"
  from EdmStage.MD_MPI_Stage m
  join EdmLib.FileRequest fr on fr.fileRequestId = :fileRequestId
  join Reference.Client c on fr.clientId = c.clientId
" where m.fileRequestId = :fileRequestId ; 	1	2020-03-03 12:28:54.3400000	mssql"
"171	38	MPI-DUPLICATE_MPI_COUNT	set nocount on"

insert into EdmStage.MD_MPI_History
select *
      ,sysdatetime() createDateTime
  from EdmStage.MD_MPI_Stage m ;

--declare @fileRequestId bigint ;

#NAME?
--  from EdmStage.MD_MPI_Stage ;

--if exists (
--select origTempPatientId, string_agg(fileRequestId, ',')
#NAME?
#NAME?
#NAME?
--having count(distinct mpiId) > 1
--)
"--	throw 51000, 'Invalid MPI links!', 16;"

"select 0 recordCount ;	1	2020-03-03 13:29:25.1966667	mssql"
"172	61	VALIDATE	declare @fileRequestId bigint =:fileRequestId ;"
declare @clientId int = :clientId ;

select count(*)
  from <stageTableName> m
  join Patient.PatientDim p on p.clientId = 61
                           and 'L711' + m.patientPrimaryNumber <> p.enterprisePatientId
                           and m.idNumber + m.memberCount = p.patientPrimaryNumber
                           and p.patientActiveFlag = 1 
  left join EdmStage.Local711_Member_InvalidException ex on m.idNumber = ex.idNumber
                                                        and m.memberCount = ex.memberCount
"														and m.patientPrimaryNumber = ex.patientPrimaryNumber"
" where ex.fileRequestId is null ; 	1	2020-03-26 09:35:57.9566667	mssql"
"173	61	ADD_INVALID_EXCEPTIONS	declare @fileRequestId bigint = :fileRequestId ;"
declare @clientId int = :clientId ;

insert into EdmStage.Local711_Member_InvalidException
select m.stageId
"	  ,m.fileRequestId"
"	  ,m.idNumber"
"	  ,m.memberCount"
      ,m.patientPrimaryNumber
"	  ,'L711' + m.patientPrimaryNumber newEnterprisePatientId"
"	  ,p.enterprisePatientId origEnterprisePatientId"
"	  ,sysdatetime() createDateTime"
  from <stageTableName> m
  join Patient.PatientDim p on p.clientId = 61
                           and 'L711' + m.patientPrimaryNumber <> p.enterprisePatientId
"						   and m.idNumber +  m.memberCount = p.patientPrimaryNumber"
"                           and p.patientActiveFlag = 1 ;	1	2020-03-26 09:40:20.1933333	mssql"
"174	38	INSERT_MPI_EligibilityStage	declare @fileRequestId bigint = :fileRequestId ;  "

#NAME?
declare @maxLenMemberId int ;
declare @maxLenMemberIdFixed int ;

select @maxLenMemberId = max(len(currentPatientIdentifier))
  from EdmStage.MD_MPI_History
 where currentPatientIdentifier not like '%-%' 
   and recordTypeId = 36 ;

if @maxLenMemberId > 12
"	select convert(int, case when @maxLenMemberId>12 then 'Invalid memberId length' else 1 end) ;  "

#NAME?
truncate table EdmStage.MD_EligibilityStage ;

alter table EdmStage.MD_EligibilityStage alter column demo_recipientOriginalId nvarchar(17) ;
alter table EdmStage.MD_EligibilityStage alter column demo_recipientCurrentId nvarchar(17) ;
alter table EdmStage.MD_EligibilityStage alter column idlk_recipientOriginalId nvarchar(17) ;
alter table EdmStage.MD_EligibilityStage alter column idlk_recipientCurrentId nvarchar(17) ;

/*
drop table if exists ##md_temp_originalAndCurrent ;

select *
  into ##md_temp_originalAndCurrent
  from (select origTempPatientId
              ,mpiId
              ,originalPatientIdentifier
"			  ,addressLine1"
"			  ,addressLine2"
"			  ,city"
"			  ,state"
"			  ,zip"
"			  ,patientBirthDate"
"			  ,patientGenderCode"
"			  ,patientSsn"
"			  ,patientRaceCode"
"			  ,patientMedicareNumber"
"			  ,patientDeathDate"
"			  ,patientMedicareIndicatorCode"
"			   -- use the last member record that we received on the file"
"			   -- or the 1st temporary member manually created"
"        	  ,rank() over(partition by origTempPatientId, mpiId order by case when currentPatientIdentifier not like 'T%' then -1 else 1 end * patientId) rnk"
          from EdmStage.MD_MPI_Stage) x
 where rnk = 1 
option (maxdop 1) ;

-- print @@rowcount ;

insert into EdmStage.MD_EligibilityStage
      (stageId
"	  ,fileRequestId"
"	  ,demo_stageId"
"	  ,demo_updateCode"
"	  ,demo_recipientOriginalId"
"	  ,demo_recipientSsn"
"	  ,demo_recipientLastName"
"	  ,demo_recipientFirstName"
"	  ,demo_recipientMiddleInitial"
"	  ,demo_recipientDob"
"	  ,demo_recipientDod"
"	  ,demo_recipientAddress1"
"	  ,demo_recipientAddress2"
"	  ,demo_recipientCity"
"	  ,demo_recipientState"
"	  ,demo_recipientZipCode"
"	  ,demo_recipientSexCode"
"	  ,demo_recipientRaceCode"
      ,demo_buyInIndicator
"	  ,demo_recipientCurrentId"
"	  ,demo_recipientMedicareIdNumber"
"	  ,idlk_stageId"
"	  ,idlk_updateCode"
"	  ,idlk_recipientOriginalId"
"	  ,idlk_recipientCurrentId"
"	  ,tempEnterprisePatientId"
"	  ,isTemporaryMember)"
select s.stageId
"	  ,s.fileRequestId"
"	  ,s.stageId demo_stageId"
"	  ,'U' demo_updateCode"
"	  ,left(replace(oc.originalPatientIdentifier, 'MD', ''), 17) demo_recipientOriginalId"
"	  ,left(oc.patientSsn, 9) demo_recipientSsn"
"	  ,left(s.patientLastName, 20) demo_recipientLastName"
"	  ,left(s.patientFirstName, 15) demo_recipientFirstName"
"	  ,left(s.patientMiddleName, 1) demo_recipientMiddleInitial"
"	  ,convert(varchar(10), s.patientBirthDate, 101) demo_recipientDob"
"	  ,convert(varchar(10), oc.patientDeathDate, 101) demo_recipientDod"
"	  ,left(oc.addressLine1, 22) demo_recipientAddress1"
"	  ,left(oc.addressLine2, 22) demo_recipientAddress2"
"	  ,left(oc.city, 18) demo_recipientCity"
"	  ,left(oc.state, 2) demo_recipientState"
"	  ,left(replace(oc.zip, '-', ''), 9) demo_recipientZipCode"
"	  ,case oc.patientGenderCode when 'M' then 'M' when 'F' then 'F' end demo_recipientSexCode"
"	  ,left(isnull(rc.inValue, replace(oc.patientRaceCode, '~', '')), 1) demo_recipientRaceCode"
"	  ,left(oc.patientMedicareIndicatorCode, 10) demo_buyInIndicator"
"	  ,left(replace(s.currentPatientIdentifier, 'MD', ''), 17) demo_recipientCurrentId"
"	  ,left(oc.patientMedicareNumber, 12) demo_recipientMedicareIdNumber"
"	  ,s.stageId idlk_stageId"
"	  ,'U' idlk_updateCode"
"	  ,left(replace(oc.originalPatientIdentifier, 'MD', ''), 17) idlk_recipientOriginalId"
"	  ,left(replace(s.currentPatientIdentifier, 'MD', ''), 17) idlk_recipientCurrentId"
"	  ,case when s.currentPatientIdentifier like 'T%' then 'MD'+ s.currentPatientIdentifier else 'MD'+ s.origTempPatientId end tempEnterprisePatientId"
"	  ,s.isTemporaryMember"
  from EdmStage.MD_MPI_Stage s
  join ##md_temp_originalAndCurrent oc on s.origTempPatientId = oc.origTempPatientId 
                                      and s.mpiId = oc.mpiId
  left join EdmLib.Mapping rc on oc.patientRaceCode = rc.outValue
                             and rc.name = 'MD_RACE_CODE'
option (maxdop 1) ;
*/

#NAME?
#NAME?
"	drop table if exists ##md_temp_hist_originalAndCurrent ;"

"	select *"
"	  into ##md_temp_hist_originalAndCurrent"
"	  from (select origTempPatientId"
"				  ,mpiId"
"				  ,originalPatientIdentifier"
"			      ,addressLine1"
"			      ,addressLine2"
"			      ,city"
"			      ,state"
"			      ,zip"
"			      ,patientBirthDate"
"			      ,patientGenderCode"
"			      ,patientSsn"
"				  ,patientRaceCode"
"			      ,patientMedicareNumber"
"			      ,patientDeathDate"
"			      ,patientMedicareIndicatorCode"
"				   -- use the last member record that we received on the file"
"				   -- or the 1st temporary member manually created"
"        		  ,rank() over(partition by origTempPatientId, mpiId order by case when currentPatientIdentifier not like 'T%' then -1 else 1 end * patientId, createDateTime desc) rnk"
"			  from EdmStage.MD_MPI_History"
"			 where fileRequestId = @fileRequestId) x"
"	 where rnk = 1 "
    option (maxdop 1) ;

"	"
"		drop table if exists EdmStage.MD_EligibilityStage_1 ;"

"		  select x.stageId"
"          	    ,x.fileRequestId"
"          	    ,x.stageId demo_stageId"
"          	    ,x.demo_updateCode"
"          	    ,x.demo_recipientOriginalId"
"          	    ,x.demo_recipientSsn"
"          	    ,x.demo_recipientLastName"
"          	    ,x.demo_recipientFirstName"
"          	    ,x.demo_recipientMiddleInitial"
"          	    ,x.demo_recipientDob"
"          	    ,x.demo_recipientDod"
"          	    ,x.demo_recipientAddress1"
"          	    ,x.demo_recipientAddress2"
"          	    ,x.demo_recipientCity"
"          	    ,x.demo_recipientState"
"          	    ,x.demo_recipientZipCode"
"          	    ,x.demo_recipientSexCode"
"	            ,x.demo_recipientRaceCode"
"				,x.demo_buyInIndicator"
"          	    ,x.demo_recipientCurrentId"
"	            ,x.demo_recipientMedicareIdNumber"
"          	    ,x.idlk_stageId"
"          	    ,x.idlk_updateCode"
"          	    ,x.idlk_recipientOriginalId"
"          	    ,x.idlk_recipientCurrentId"
"				,x.isTemporaryMember"
"				,x.currentPatientIdentifier"
"				,x.origTempPatientId"
"				,x.mpiId"
"				,dense_rank() over(partition by origTempPatientId order by mpiId)"
                   + dense_rank() over(partition by origTempPatientId order by mpiId desc)
                   - 1 mpiCount
"				into EdmStage.MD_EligibilityStage_1 "
"			from (select s.stageId"
                        ,s.fileRequestId
                        ,s.stageId demo_stageId
                        ,'U' demo_updateCode
                        ,left(replace(oc.originalPatientIdentifier, 'MD', ''), 17) demo_recipientOriginalId
                        ,left(oc.patientSsn, 9) demo_recipientSsn
                        ,left(s.patientLastName, 20) demo_recipientLastName
                        ,left(s.patientFirstName, 15) demo_recipientFirstName
                        ,left(s.patientMiddleName, 1) demo_recipientMiddleInitial
                        ,convert(varchar(10), s.patientBirthDate, 101) demo_recipientDob
                        ,convert(varchar(10), oc.patientDeathDate, 101) demo_recipientDod
                        ,left(oc.addressLine1, 22) demo_recipientAddress1
                        ,left(oc.addressLine2, 22) demo_recipientAddress2
                        ,left(oc.city, 18) demo_recipientCity
                        ,left(oc.state, 2) demo_recipientState
                        ,left(replace(oc.zip, '-', ''), 9) demo_recipientZipCode
                        ,case oc.patientGenderCode when 'M' then 'M' when 'F' then 'F' end demo_recipientSexCode
                        ,left(isnull(rc.inValue, replace(oc.patientRaceCode, '~', '')), 1) demo_recipientRaceCode
                        ,left(oc.patientMedicareIndicatorCode, 10) demo_buyInIndicator
                        ,left(replace(s.currentPatientIdentifier, 'MD', ''), 17) demo_recipientCurrentId
                        ,left(oc.patientMedicareNumber, 12) demo_recipientMedicareIdNumber
                        ,s.stageId idlk_stageId
                        ,'U' idlk_updateCode
                        ,left(replace(oc.originalPatientIdentifier, 'MD', ''), 17) idlk_recipientOriginalId
"                        ,left(replace(s.currentPatientIdentifier, 'MD', ''), 17) idlk_recipientCurrentId			"
                        ,isnull(case when s.currentPatientIdentifier like 'T%' then 1 else s.isTemporaryMember end,  0) isTemporaryMember
                        ,rank() over(partition by s.stageId order by s.createDateTime desc) rnk
"						,s.currentPatientIdentifier"
"						,s.origTempPatientId"
"						,s.mpiId"
                    from EdmStage.MD_MPI_History s
                    join ##md_temp_hist_originalAndCurrent oc on s.origTempPatientId = oc.origTempPatientId 
                                                             and s.mpiId = oc.mpiId 
                    left join EdmLib.Mapping rc on oc.patientRaceCode = rc.outValue
                                               and rc.name = 'MD_RACE_CODE'
                   where s.fileRequestId = @fileRequestId
"				   ) x "
           where x.rnk = 1
   option (maxdop 1) ;


"	 insert into EdmStage.MD_EligibilityStage"
                (stageId
"          	    ,fileRequestId"
"          	    ,demo_stageId"
"          	    ,demo_updateCode"
"          	    ,demo_recipientOriginalId"
"          	    ,demo_recipientSsn"
"          	    ,demo_recipientLastName"
"          	    ,demo_recipientFirstName"
"          	    ,demo_recipientMiddleInitial"
"          	    ,demo_recipientDob"
"          	    ,demo_recipientDod"
"          	    ,demo_recipientAddress1"
"          	    ,demo_recipientAddress2"
"          	    ,demo_recipientCity"
"          	    ,demo_recipientState"
"          	    ,demo_recipientZipCode"
"          	    ,demo_recipientSexCode"
"	            ,demo_recipientRaceCode"
"				,demo_buyInIndicator"
"          	    ,demo_recipientCurrentId"
"	            ,demo_recipientMedicareIdNumber"
"          	    ,idlk_stageId"
"          	    ,idlk_updateCode"
"          	    ,idlk_recipientOriginalId"
"          	    ,idlk_recipientCurrentId"
"				,tempEnterprisePatientId"
"				,isTemporaryMember)"
"		  select x.stageId"
"          	    ,x.fileRequestId"
"          	    ,x.stageId demo_stageId"
"          	    ,x.demo_updateCode"
"          	    ,x.demo_recipientOriginalId"
"          	    ,x.demo_recipientSsn"
"          	    ,x.demo_recipientLastName"
"          	    ,x.demo_recipientFirstName"
"          	    ,x.demo_recipientMiddleInitial"
"          	    ,x.demo_recipientDob"
"          	    ,x.demo_recipientDod"
"          	    ,x.demo_recipientAddress1"
"          	    ,x.demo_recipientAddress2"
"          	    ,x.demo_recipientCity"
"          	    ,x.demo_recipientState"
"          	    ,x.demo_recipientZipCode"
"          	    ,x.demo_recipientSexCode"
"	            ,x.demo_recipientRaceCode"
"				,x.demo_buyInIndicator"
"          	    ,x.demo_recipientCurrentId"
"	            ,x.demo_recipientMedicareIdNumber"
"          	    ,x.idlk_stageId"
"          	    ,x.idlk_updateCode"
"          	    ,x.idlk_recipientOriginalId"
"          	    ,x.idlk_recipientCurrentId				"
"				,case when x.mpiCount > 1 or (x.currentPatientIdentifier like 'T%' and x.mpiCount=1) then 'MD'+ x.currentPatientIdentifier else 'MD'+ x.origTempPatientId end tempEnterprisePatientId"
"				,x.isTemporaryMember"
"			from EdmStage.MD_EligibilityStage_1 x ;"

"--end ; 	1	2020-03-30 12:57:04.8666667	mssql"
"175	42	MERGE_OPTUM-ICD10CM-BASE	declare @fileRequestId bigint = :fileRequestId ;"

if object_id('Reference.Icd_History') is null
create table Reference.Icd_History
"(icdId	bigint"
",icdPreviousIcdId	bigint"
",icdCode	nvarchar(255)"
",icdCodeStd	nvarchar(255)"
",icdVersionType	nvarchar(255)"
",icdCodeType	nvarchar(255)"
",icdDxSg	nvarchar(255)"
",icdShortDesc	nvarchar(255)"
",icdLongDesc	nvarchar(255)"
",icdFullDesc	nvarchar(255)"
",icdBillableInd	int"
",icdStatus	nvarchar(255)"
",icdCodeValidity	nvarchar(255)"
",icdCodeValidityChangeDate	datetime2"
",icdOrderNumber	int"
",icdReuseDate	datetime2"
",icdEffectiveDate	datetime2"
",icdDeactivationDate	datetime2"
",icdActiveFlag	int"
",icdCreateDate	datetime2"
",icdUpdateDate	datetime2"
",icdNocFlag	int"
",icdCategoryId	int"
,triggeringFileRequestId bigint) ;

if (select count(*) from sys.default_constraints where name = 'Reference_Icd_icdId_DF') = 0
"	alter table Reference.Icd add constraint Reference_Icd_icd_DF default next value for Reference.IcdSeq for icdId ;"

merge into Reference.Icd m
using (select x0.*
         from (select i.icdId
                     ,x.*
"       			     ,c.fileRequestId changeFileRequestId"
"       			     ,c.changeType"
"					 ,try_convert(datetime2, c.originalStart, 101) originalStart"
"					 ,try_convert(datetime2, c.versionEnd, 101) versionEnd"
"					 ,try_convert(datetime2, c.revisedStart, 101) revisedStart"
"					 ,try_convert(datetime2, c.dateTerminated, 101) dateTerminated"
"       			     ,c.statusIndicator"
"       			     ,c.oldDesc"
"       			     ,c.newDesc"
"       			     ,try_convert(datetime2, c.releaseDate, 101) releaseDate"
"       			     ,try_convert(datetime2, c.effectiveDate, 101) effectiveDate"
                     ,row_number() over(partition by x.codeType, x.code, i.icdVersionType order by x.fileRequestId desc, i.icdActiveFlag desc, case when x.validity = 'C' then 1 else 2 end, x.validity,  i.icdId desc) rn
                 from EdmStage.Optum_ICD10CMBaseHistory x 
                 left join Reference.Icd i on x.codeType = i.icdCodeType
                                     and x.code = i.icdCode
                                     and i.icdVersionType = '10'
"									 and i.icdDxSg = 'DX'"
                 left join EdmStage.Optum_ICD10CMChangeHistory c on x.code = c.code
"       		                                                    and x.codeType = c.codeType"
                                                                and x.fileRequestId <= c.fileRequestId 
                where (i.icdId is null 
                    or x.shortDescription <> i.IcdShortDesc
                    or x.longDescription <> i.IcdLongDesc
                    or x.fullDescription <> i.IcdFullDesc)
                  and x.code not like '%[_]%'
"       		   and x.fileRequestId = :fileRequestId ) x0"
         where x0.rn = 1 ) u
   on m.icdId = u.icdId
 when matched then update set m.icdShortDesc = u.shortDescription
                             ,m.icdLongDesc = u.longDescription
                             ,m.icdFullDesc = u.fullDescription
                             ,m.icdBillableInd = case when m.icdBillableInd = 1 then 1 
                                                      when u.validity = 'C' then 1 
"                             						 else 0 end"
                             ,m.icdStatus  = u.status
                             ,m.icdCodeValidity = u.validity
                             ,m.icdCodeValidityChangeDate = case when m.icdCodeValidityChangeDate is not null then m.icdCodeValidityChangeDate
                                                                 when m.icdCodeValidity is null and u.validity is not null then sysdatetime()
                                                                 when m.icdCodeValidity <> u.validity then sysdatetime()
"                             							  end"
                             ,m.icdReuseDate = case when m.icdActiveFlag = 0 then sysdatetime() end 
                             ,m.icdActiveFlag = 1
                             ,m.icdEffectiveDate = case when m.icdEffectiveDate is not null then m.icdEffectiveDate 
"							                            else u.effectiveDate"
"												   end"
                             ,m.icdUpdateDate = sysdatetime()
                             ,m.icdNocFlag = case when m.icdNocFlag = 1 then 1 
"							                      when upper(u.fullDescription) like '%NOT OTHERWISE SPECIFIED%' then 1"
                                                  when upper(u.fullDescription) like '%NOT OTHERWISE CLASSIFIED%' then 1
"                             	                  when upper(u.fullDescription) like '%NOT ELSEWHERE CLASSIFIED%' then 1"
"                             	                  when upper(u.fullDescription) like '%NOT ELSEWHERE SPECIFIED%' then 1"
"                             	                  when upper(u.fullDescription) like '%UNSPECIFIED%' then 1"
"                             	                  when upper(u.fullDescription) like '%^UNLISTED%' then 1"
"                             				 else 0 end"
 when not matched then insert (icdCode
                              ,icdCodeStd
"							  ,icdVersionType"
"							  ,icdCodeType"
"							  ,icdDxSg"
"							  ,icdShortDesc"
"							  ,icdLongDesc"
"							  ,icdFullDesc"
"							  ,icdBillableInd"
"							  ,icdStatus"
"							  ,icdCodeValidity"
"							  ,icdEffectiveDate"
"							  ,icdActiveFlag"
"							  ,icdCreateDate"
"							  ,icdNocFlag)"
                       values (u.code
                              ,replace(u.code, '.', '')
"							  ,'10'"
"							  ,u.codeType"
"							  ,'DX'"
"							  ,u.shortDescription"
"							  ,u.longDescription"
"							  ,u.fullDescription"
"							  ,case when u.validity = 'C' then 1 else 0 end"
"							  ,u.status"
"							  ,u.validity"
"							  ,u.effectiveDate"
"							  ,1"
"							  ,sysdatetime()"
"							  ,case when upper(u.fullDescription) like '%NOT OTHERWISE SPECIFIED%' then 1"
                                    when upper(u.fullDescription) like '%NOT OTHERWISE CLASSIFIED%' then 1
"                             	    when upper(u.fullDescription) like '%NOT ELSEWHERE CLASSIFIED%' then 1"
"                             	    when upper(u.fullDescription) like '%NOT ELSEWHERE SPECIFIED%' then 1"
"                             	    when upper(u.fullDescription) like '%UNSPECIFIED%' then 1"
"                             	    when upper(u.fullDescription) like '%^UNLISTED%' then 1"
                               else 0 end)
"	output deleted.icdId"
          ,deleted.icdPreviousIcdId
          ,deleted.icdCode
          ,deleted.icdCodeStd
          ,deleted.icdVersionType
          ,deleted.icdCodeType
          ,deleted.icdDxSg
          ,deleted.icdShortDesc
          ,deleted.icdLongDesc
          ,deleted.icdFullDesc
          ,deleted.icdBillableInd
          ,deleted.icdStatus
          ,deleted.icdCodeValidity
          ,deleted.icdCodeValidityChangeDate
          ,deleted.icdOrderNumber
          ,deleted.icdReuseDate
          ,deleted.icdEffectiveDate
          ,deleted.icdDeactivationDate
          ,deleted.icdActiveFlag
          ,deleted.icdCreateDate
          ,deleted.icdUpdateDate
          ,deleted.icdNocFlag
          ,deleted.icdCategoryId
"	      ,@fileRequestId"
"	into Reference.Icd_History ;  	1	2020-03-31 14:53:20.6300000	mssql"
"176	42	MERGE_OPTUM-ICD10PCS-BASE	declare @fileRequestId bigint = :fileRequestId ;"

if (select count(*) from sys.default_constraints where name = 'Reference_Icd_icdId_DF') = 0
"	alter table Reference.Icd add constraint Reference_Icd_icd_DF default next value for Reference.IcdSeq for icdId ;"

merge into Reference.Icd m
using (select x0.*
         from (select i.icdId
                     ,x.*
"       			     ,c.fileRequestId changeFileRequestId"
"       			     ,c.changeType"
"					 ,try_convert(datetime2, c.originalStart, 101) originalStart"
"					 ,try_convert(datetime2, c.versionEnd, 101) versionEnd"
"					 ,try_convert(datetime2, c.revisedStart, 101) revisedStart"
"					 ,try_convert(datetime2, c.dateTerminated, 101) dateTerminated"
"       			     ,c.statusIndicator"
"       			     ,c.oldDesc"
"       			     ,c.newDesc"
"       			     ,try_convert(datetime2, c.releaseDate, 101) releaseDate"
"       			     ,try_convert(datetime2, c.effectiveDate, 101) effectiveDate"
                     ,row_number() over(partition by x.codeType, x.code, i.icdVersionType order by x.fileRequestId desc, i.icdActiveFlag desc, case when x.validity = 'C' then 1 else 2 end, x.validity, i.icdId desc) rn
                 from EdmStage.Optum_ICD10PCSBaseHistory x 
                 left join Reference.Icd i on x.codeType = i.icdCodeType
                                     and x.code = i.icdCode
                                     and i.icdVersionType = '10'
"									 and i.icdDxSg = 'SG'"
                 left join EdmStage.Optum_ICD10PCSChangeHistory c on x.code = c.code
"       		                                                    and x.codeType = c.codeType"
                                                                and x.fileRequestId <= c.fileRequestId 
                where (i.icdId is null 
                    or x.shortDescription <> i.IcdShortDesc
                    or x.longDescription <> i.IcdLongDesc
                    or x.fullDescription <> i.IcdFullDesc)
                  and x.code not like '%[_]%'
"       		   and x.fileRequestId = :fileRequestId ) x0"
         where x0.rn = 1 ) u
   on m.icdId = u.icdId
 when matched then update set m.icdShortDesc = u.shortDescription
                             ,m.icdLongDesc = u.longDescription
                             ,m.icdFullDesc = u.fullDescription
                             ,m.icdBillableInd = case when m.icdBillableInd = 1 then 1 
                                                      when u.validity = 'C' then 1 
"                             						 else 0 end"
                             ,m.icdStatus  = u.status
                             ,m.icdCodeValidity = u.validity
                             ,m.icdCodeValidityChangeDate = case when m.icdCodeValidityChangeDate is not null then m.icdCodeValidityChangeDate
                                                                 when m.icdCodeValidity is null and u.validity is not null then sysdatetime()
                                                                 when m.icdCodeValidity <> u.validity then sysdatetime()
"                             							  end"
                             ,m.icdReuseDate = case when m.icdActiveFlag = 0 then sysdatetime() end 
                             ,m.icdActiveFlag = 1
                             ,m.icdEffectiveDate = case when m.icdEffectiveDate is not null then m.icdEffectiveDate 
"							                            else u.effectiveDate"
"												   end"
                             ,m.icdUpdateDate = sysdatetime()
                             ,m.icdNocFlag = case when m.icdNocFlag = 1 then 1 
"							                      when upper(u.fullDescription) like '%NOT OTHERWISE SPECIFIED%' then 1"
                                                  when upper(u.fullDescription) like '%NOT OTHERWISE CLASSIFIED%' then 1
"                             	                  when upper(u.fullDescription) like '%NOT ELSEWHERE CLASSIFIED%' then 1"
"                             	                  when upper(u.fullDescription) like '%NOT ELSEWHERE SPECIFIED%' then 1"
"                             	                  when upper(u.fullDescription) like '%UNSPECIFIED%' then 1"
"                             	                  when upper(u.fullDescription) like '%^UNLISTED%' then 1"
"                             				 else 0 end"
 when not matched then insert (icdCode
                              ,icdCodeStd
"							  ,icdVersionType"
"							  ,icdCodeType"
"							  ,icdDxSg"
"							  ,icdShortDesc"
"							  ,icdLongDesc"
"							  ,icdFullDesc"
"							  ,icdBillableInd"
"							  ,icdStatus"
"							  ,icdCodeValidity"
"							  ,icdEffectiveDate"
"							  ,icdActiveFlag"
"							  ,icdCreateDate"
"							  ,icdNocFlag)"
                       values (u.code
                              ,replace(u.code, '.', '')
"							  ,'10'"
"							  ,u.codeType"
"							  ,'SG'"
"							  ,u.shortDescription"
"							  ,u.longDescription"
"							  ,u.fullDescription"
"							  ,case when u.validity = 'C' then 1 else 0 end"
"							  ,u.status"
"							  ,u.validity"
"							  ,u.effectiveDate"
"							  ,1"
"							  ,sysdatetime()"
"							  ,case when upper(u.fullDescription) like '%NOT OTHERWISE SPECIFIED%' then 1"
                                    when upper(u.fullDescription) like '%NOT OTHERWISE CLASSIFIED%' then 1
"                             	    when upper(u.fullDescription) like '%NOT ELSEWHERE CLASSIFIED%' then 1"
"                             	    when upper(u.fullDescription) like '%NOT ELSEWHERE SPECIFIED%' then 1"
"                             	    when upper(u.fullDescription) like '%UNSPECIFIED%' then 1"
"                             	    when upper(u.fullDescription) like '%^UNLISTED%' then 1"
                               else 0 end)  
"	output deleted.icdId"
          ,deleted.icdPreviousIcdId
          ,deleted.icdCode
          ,deleted.icdCodeStd
          ,deleted.icdVersionType
          ,deleted.icdCodeType
          ,deleted.icdDxSg
          ,deleted.icdShortDesc
          ,deleted.icdLongDesc
          ,deleted.icdFullDesc
          ,deleted.icdBillableInd
          ,deleted.icdStatus
          ,deleted.icdCodeValidity
          ,deleted.icdCodeValidityChangeDate
          ,deleted.icdOrderNumber
          ,deleted.icdReuseDate
          ,deleted.icdEffectiveDate
          ,deleted.icdDeactivationDate
          ,deleted.icdActiveFlag
          ,deleted.icdCreateDate
          ,deleted.icdUpdateDate
          ,deleted.icdNocFlag
          ,deleted.icdCategoryId
"	      ,@fileRequestId"
"	into Reference.Icd_History ;   	1	2020-03-31 15:00:43.0733333	mssql"
"177	42	MERGE_OPTUM-ICD10CM-CHANGE	declare @fileRequestId bigint = :fileRequestId ;"

if (select count(*) from sys.default_constraints where name = 'Reference_Icd_icdId_DF') = 0
        alter table Reference.Icd add constraint Reference_Icd_icd_DF default next value for Reference.IcdSeq for icdId ;

merge into Reference.Icd m
using (select i.icdId
                     ,x.fileRequestId changeFileRequestId
                                         ,x.code
                                         ,x.codeType
                             ,x.changeType
                                         ,try_convert(datetime2, x.originalStart, 101) originalStart
                                         ,try_convert(datetime2, x.versionEnd, 101) versionEnd
                                         ,try_convert(datetime2, x.revisedStart, 101) revisedStart
                                         ,try_convert(datetime2, x.dateTerminated, 101) dateTerminated
                             ,x.statusIndicator
                             ,x.oldDesc
                             ,x.newDesc
                                         ,upper(x.newDesc) shortDescription
                                         ,upper(x.newDesc) longDescription
                                         ,x.newDesc fullDescription
                             ,try_convert(datetime2, x.releaseDate, 101) releaseDate
                             ,try_convert(datetime2, x.effectiveDate, 101) effectiveDate
                     ,row_number() over(partition by x.codeType, x.code, i.icdVersionType order by x.fileRequestId desc, i.icdActiveFlag desc,i.icdId desc) rn
                 from EdmStage.Optum_ICD10CMChangeHistory x
                 left join Reference.Icd i on x.codeType = i.icdCodeType
                                     and x.code = i.icdCode
                                     and i.icdVersionType = '10'
                                                                         and i.icdDxSg = 'DX'
                where (i.icdId is null
                    or x.newDesc <> i.IcdFullDesc)
                  and x.code not like '%[_]%'
                   and x.fileRequestId = @fileRequestId
                           ) u
   on m.icdId = u.icdId
 when matched then update set m.icdShortDesc = u.shortDescription
                             ,m.icdLongDesc = u.longDescription
                             ,m.icdFullDesc = u.fullDescription
                             ,m.icdReuseDate = case when m.icdActiveFlag = 0 then sysdatetime() end
                             ,m.icdActiveFlag = 1
                             ,m.icdEffectiveDate = case when m.icdEffectiveDate is not null then m.icdEffectiveDate
                                                                                    else u.effectiveDate
                                                                                                   end
                             ,m.icdUpdateDate = sysdatetime()
                             ,m.icdNocFlag = case when m.icdNocFlag = 1 then 1
                                                                              when upper(u.fullDescription) like '%NOT OTHERWISE SPECIFIED%' then 1
                                                  when upper(u.fullDescription) like '%NOT OTHERWISE CLASSIFIED%' then 1
                                                  when upper(u.fullDescription) like '%NOT ELSEWHERE CLASSIFIED%' then 1
                                                  when upper(u.fullDescription) like '%NOT ELSEWHERE SPECIFIED%' then 1
                                                  when upper(u.fullDescription) like '%UNSPECIFIED%' then 1
                                                  when upper(u.fullDescription) like '%^UNLISTED%' then 1
                                                         else 0 end
 when not matched then insert (icdCode
                              ,icdCodeStd
                                                          ,icdVersionType
                                                          ,icdCodeType
                                                          ,icdDxSg
                                                          ,icdShortDesc
                                                          ,icdLongDesc
                                                          ,icdFullDesc
                                                          ,icdEffectiveDate
                                                          ,icdActiveFlag
                                                          ,icdCreateDate
                                                          ,icdNocFlag)
                       values (u.code
                              ,replace(u.code, '.', '')
                                                          ,'10'
                                                          ,u.codeType
                                                          ,'DX'
                                                          ,u.shortDescription
                                                          ,u.longDescription
                                                          ,u.fullDescription
                                                          ,u.effectiveDate
                                                          ,1
                                                          ,sysdatetime()
                                                          ,case when upper(u.fullDescription) like '%NOT OTHERWISE SPECIFIED%' then 1
                                    when upper(u.fullDescription) like '%NOT OTHERWISE CLASSIFIED%' then 1
                                    when upper(u.fullDescription) like '%NOT ELSEWHERE CLASSIFIED%' then 1
                                    when upper(u.fullDescription) like '%NOT ELSEWHERE SPECIFIED%' then 1
                                    when upper(u.fullDescription) like '%UNSPECIFIED%' then 1
                                    when upper(u.fullDescription) like '%^UNLISTED%' then 1
                               else 0 end)
        output deleted.icdId
          ,deleted.icdPreviousIcdId
          ,deleted.icdCode
          ,deleted.icdCodeStd
          ,deleted.icdVersionType
          ,deleted.icdCodeType
          ,deleted.icdDxSg
          ,deleted.icdShortDesc
          ,deleted.icdLongDesc
          ,deleted.icdFullDesc
          ,deleted.icdBillableInd
          ,deleted.icdStatus
          ,deleted.icdCodeValidity
          ,deleted.icdCodeValidityChangeDate
          ,deleted.icdOrderNumber
          ,deleted.icdReuseDate
          ,deleted.icdEffectiveDate
          ,deleted.icdDeactivationDate
          ,deleted.icdActiveFlag
          ,deleted.icdCreateDate
          ,deleted.icdUpdateDate
          ,deleted.icdNocFlag
          ,deleted.icdCategoryId
              ,@fileRequestId
"        into Reference.Icd_History ;	1	2020-04-03 11:06:18.7833333	mssql"
"178	42	MERGE_OPTUM-ICD10PCS-CHANGE	declare @fileRequestId bigint = :fileRequestId ;"

if (select count(*) from sys.default_constraints where name = 'Reference_Icd_icdId_DF') = 0
"	alter table Reference.Icd add constraint Reference_Icd_icd_DF default next value for Reference.IcdSeq for icdId ;"

merge into Reference.Icd m
using (select i.icdId
                     ,x.fileRequestId changeFileRequestId
"					 ,x.code"
"					 ,x.codeType"
"       			     ,x.changeType"
"					 ,try_convert(datetime2, x.originalStart, 101) originalStart"
"					 ,try_convert(datetime2, x.versionEnd, 101) versionEnd"
"					 ,try_convert(datetime2, x.revisedStart, 101) revisedStart"
"					 ,try_convert(datetime2, x.dateTerminated, 101) dateTerminated"
"       			     ,x.statusIndicator"
"       			     ,x.oldDesc"
"       			     ,x.newDesc"
"					 ,upper(x.newDesc) shortDescription"
"					 ,upper(x.newDesc) longDescription"
"					 ,x.newDesc fullDescription"
"       			     ,try_convert(datetime2, x.releaseDate, 101) releaseDate"
"       			     ,try_convert(datetime2, x.effectiveDate, 101) effectiveDate"
                     ,row_number() over(partition by x.codeType, x.code, i.icdVersionType order by x.fileRequestId desc, i.icdActiveFlag desc,i.icdId desc) rn
                 from EdmStage.Optum_ICD10PCSChangeHistory x 
                 left join Reference.Icd i on x.codeType = i.icdCodeType
                                     and x.code = i.icdCode
                                     and i.icdVersionType = '10'
"									 and i.icdDxSg = 'SG'"
                where (i.icdId is null 
                    or x.newDesc <> i.IcdFullDesc)
                  and x.code not like '%[_]%'
"       		   and x.fileRequestId = @fileRequestId "
"			   ) u"
   on m.icdId = u.icdId
 when matched then update set m.icdShortDesc = u.shortDescription
                             ,m.icdLongDesc = u.longDescription
                             ,m.icdFullDesc = u.fullDescription
                             ,m.icdReuseDate = case when m.icdActiveFlag = 0 then sysdatetime() end 
                             ,m.icdActiveFlag = 1
                             ,m.icdEffectiveDate = case when m.icdEffectiveDate is not null then m.icdEffectiveDate 
"							                            else u.effectiveDate"
"												   end"
                             ,m.icdUpdateDate = sysdatetime()
                             ,m.icdNocFlag = case when m.icdNocFlag = 1 then 1 
"							                      when upper(u.fullDescription) like '%NOT OTHERWISE SPECIFIED%' then 1"
                                                  when upper(u.fullDescription) like '%NOT OTHERWISE CLASSIFIED%' then 1
"                             	                  when upper(u.fullDescription) like '%NOT ELSEWHERE CLASSIFIED%' then 1"
"                             	                  when upper(u.fullDescription) like '%NOT ELSEWHERE SPECIFIED%' then 1"
"                             	                  when upper(u.fullDescription) like '%UNSPECIFIED%' then 1"
"                             	                  when upper(u.fullDescription) like '%^UNLISTED%' then 1"
"                             				 else 0 end"
 when not matched then insert (icdCode
                              ,icdCodeStd
"							  ,icdVersionType"
"							  ,icdCodeType"
"							  ,icdDxSg"
"							  ,icdShortDesc"
"							  ,icdLongDesc"
"							  ,icdFullDesc"
"							  ,icdEffectiveDate"
"							  ,icdActiveFlag"
"							  ,icdCreateDate"
"							  ,icdNocFlag)"
                       values (u.code
                              ,replace(u.code, '.', '')
"							  ,'10'"
"							  ,u.codeType"
"							  ,'SG'"
"							  ,u.shortDescription"
"							  ,u.longDescription"
"							  ,u.fullDescription"
"							  ,u.effectiveDate"
"							  ,1"
"							  ,sysdatetime()"
"							  ,case when upper(u.fullDescription) like '%NOT OTHERWISE SPECIFIED%' then 1"
                                    when upper(u.fullDescription) like '%NOT OTHERWISE CLASSIFIED%' then 1
"                             	    when upper(u.fullDescription) like '%NOT ELSEWHERE CLASSIFIED%' then 1"
"                             	    when upper(u.fullDescription) like '%NOT ELSEWHERE SPECIFIED%' then 1"
"                             	    when upper(u.fullDescription) like '%UNSPECIFIED%' then 1"
"                             	    when upper(u.fullDescription) like '%^UNLISTED%' then 1"
                               else 0 end) 
"	output deleted.icdId"
          ,deleted.icdPreviousIcdId
          ,deleted.icdCode
          ,deleted.icdCodeStd
          ,deleted.icdVersionType
          ,deleted.icdCodeType
          ,deleted.icdDxSg
          ,deleted.icdShortDesc
          ,deleted.icdLongDesc
          ,deleted.icdFullDesc
          ,deleted.icdBillableInd
          ,deleted.icdStatus
          ,deleted.icdCodeValidity
          ,deleted.icdCodeValidityChangeDate
          ,deleted.icdOrderNumber
          ,deleted.icdReuseDate
          ,deleted.icdEffectiveDate
          ,deleted.icdDeactivationDate
          ,deleted.icdActiveFlag
          ,deleted.icdCreateDate
          ,deleted.icdUpdateDate
          ,deleted.icdNocFlag
          ,deleted.icdCategoryId
"	      ,@fileRequestId"
"	into Reference.Icd_History ;  	1	2020-04-03 11:08:13.7633333	mssql"
"179	34	UPDATE_PSM_EVENT_DATE	merge into EdmStage.COC_BiometricsPSM m"
using (select stageId
             ,convert(varchar(10), dateadd(day, convert(int, eventDate)-2, '1900-01-01'), 121) eventDate
         from EdmStage.COC_BiometricsPSM
        where try_convert(int, eventDate) is not null) u
  on m.stageId = u.stageId
" when matched then update set m.eventDate = u.eventDate ;	1	2020-04-14 11:08:13.7633333	mssql"
"180	34	UPDATE_PSM_DATE_OF_BIRTH	merge into EdmStage.COC_BiometricsPSM m"
using (select stageId
      ,convert(varchar(10), dateadd(day, convert(int, dateOfBirth)-2, '1900-01-01'), 121) dateOfBirth
  from EdmStage.COC_BiometricsPSM
  where try_convert(int, dateOfBirth) is not null) u
  on m.stageId = u.stageId
" when matched then update set m.dateOfBirth = u.dateOfBirth ;	1	2020-04-14 11:08:13.7633333	mssql"
"181	0	CARE_ANALYZER-PHARMACY-STANDARD	set nocount on"

declare @fileRequestId bigint = :fileRequestId ;
declare @prep bit = 1;
declare @finalAction bit = 1;
declare @clientId int ;

select @clientId = clientId
  from EdmLib.FileRequest
 where fileRequestId = @fileRequestId ;

if @prep = 1
"begin	"
    drop table if exists EdmStage.CareAnalyzerRxControlNumberList;

"	if object_id('EdmStage.CareAnalyzerRxControlNumberList') is null"
"		create table EdmStage.CareAnalyzerRxControlNumberList"
"		(clientId int not null"
"		,payerClaimControlNumber nvarchar(255)"
"		,adjustedClaimControlNumber nvarchar(255)"
"		,fileRequestId bigint"
"		,lineCount int);"

"	declare fileRequestCur cursor for"
"	 select fileRequestId"
"	   from EdmLib.FileRequest"
"	  where processType= 'PHARMACY_CLAIM'"
"		and clientId = @clientId"
"		and isnull(purged, 0) = 0"
"		and completeFlag = 1"
"		and hasError = 0"
"		and fileRequestId <= @fileRequestId"
"	  order by 1;"

"	open fileRequestCur;"
"	fetch fileRequestCur into @fileRequestId;"

"	while @@fetch_status = 0"
"	begin"
"		insert into EdmStage.CareAnalyzerRxControlNumberList"
"		select clientId, payerClaimControlNumber, adjustedClaimControlNumber, @fileRequestId, count(*) lineCount"
"		  from EdmStandard.PharmacyClaimReference r"
"		 where r.fileRequestId = @fileRequestId"
"		 group by clientId, payerClaimControlNumber, adjustedClaimControlNumber"
"		option (maxdop 4);"

"		declare @rowCount int = @@rowcount;"

"		print ''"
"		print '=============Prep==============='"
"		print 'FileRequestId = '"
"		print @fileRequestId"
"		print 'RowCount = '"
"		print @rowCount"
"		fetch fileRequestCur into @fileRequestId;"
"	end;"

"	close fileRequestCur;"
"	deallocate fileRequestCur;"
end;

if (select count(*) from sys.indexes where object_id = object_id('EdmStage.CareAnalyzerRxControlNumberList') and name = 'PharmacyClaimControlNumberListIdx1') = 0
"	create index PharmacyClaimControlNumberListIdx1"
"	on EdmStage.CareAnalyzerRxControlNumberList (adjustedClaimControlNumber, payerClaimControlNumber)"
"	include (fileRequestId, lineCount)"
"	with (data_compression=page);"

if @finalAction = 1
begin

"	drop table if exists EdmStage.CareAnalyzerRxControlNumberListFinal;"

"	with final as "
"		 (select 0 lvl, clientId, payerClaimControlNumber, adjustedClaimControlNumber, payerClaimControlNumber originalClaimNumber, lineCount, fileRequestId"
"			from EdmStage.CareAnalyzerRxControlNumberList"
"		   where adjustedClaimControlNumber is null"
"		  union all "
"		  select lvl + 1, r.clientId, r.payerClaimControlNumber, r.adjustedClaimControlNumber, f.payerClaimControlNumber, r.lineCount, r.fileRequestId"
"			from EdmStage.CareAnalyzerRxControlNumberList r"
"			join final f on f.payerClaimControlNumber = r.adjustedClaimControlNumber"
"			            and f.clientId = r.clientId)"
"	select f.*"
"		  ,case when f.lvl = max(f.lvl) over(partition by originalClaimnumber) then 1 else 0 end isFinal"
"	  into EdmStage.CareAnalyzerRxControlNumberListFinal"
"	  from final f;	 "
end;

if (select count(*) from sys.indexes where name = 'PharmacyClaimControlNumberListFinalIdx1' and object_id = object_id('EdmStage.CareAnalyzerRxControlNumberListFinal')) = 0
"	create index PharmacyClaimControlNumberListFinalIdx1 "
"	on EdmStage.CareAnalyzerRxControlNumberListFinal (isFinal) "
    include (fileRequestId)
"	with(data_compression=page);"

if (select count(*) from sys.indexes where name = 'PharmacyClaimControlNumberListFinalIdx2' and object_id = object_id('EdmStage.CareAnalyzerRxControlNumberListFinal')) = 0
"	create index PharmacyClaimControlNumberListFinalIdx2"
"	on EdmStage.CareAnalyzerRxControlNumberListFinal (isFinal, payerClaimControlNumber, fileRequestId) "
    include (lineCount)
"	with(data_compression=page);"

if object_id('EdmStage.CareAnalyzerRx') is null
begin
"	create sequence EdmStage.CareAnalyzerRxSEQ start with 1;"
"	create table EdmStage.CareAnalyzerRx"
    (careAnalyzerRxId bigint NOT NULL default next value for EdmStage.CareAnalyzerRxSEQ
    ,clientId int not null
    ,payerClaimControlNumber nvarchar(255)
    ,claimStatusId int
    ,claimStatusCode nvarchar(255)
    ,adjustedClaimControlNumber nvarchar(255)
    ,slAssignedNumber nvarchar(255)
    ,pharmacyFacilityPrimaryNumber nvarchar(255)
    ,pharmacyFacilityLocationNumber nvarchar(255)
    ,patientPrimaryNumber nvarchar(255)
    ,cost numeric(10, 2)
    ,NDC nvarchar(255)
"	,NdcId bigint"
    ,daysSupply smallint
    ,firstDateOfService datetime2(7)
"	,prescribingPhysicianNPI nvarchar(10)"
"	,metricQuantity decimal(10, 2)"
    ,fileRequestId bigint NOT NULL
"	,constraint CareAnalyzerRxPK primary key clustered (careAnalyzerRxId, clientId))"
"	on ClientPscheme(clientId)"
"	with (data_compression = page);"
end;
else
"	truncate table EdmStage.CareAnalyzerRx with (partitions($Partition.ClientPfnc(@clientId))) ;"

-- 
set @fileRequestId = null;
--declare @fileRequestId bigint = null;

declare fileRequestCur2 cursor for
 select distinct fileRequestId 
   from EdmStage.CareAnalyzerRxControlNumberListFinal
  where isFinal = 1
  order by 1 desc

open fileRequestCur2;
fetch fileRequestCur2 into @fileRequestId;

while @@fetch_status = 0
begin
    insert
"	  into EdmStage.CareAnalyzerRx"
"	      (clientId"
"		  ,payerClaimControlNumber"
"		  ,claimStatusId"
"		  ,claimStatusCode"
"		  ,adjustedClaimControlNumber"
"		  ,slAssignedNumber"
"		  ,pharmacyFacilityPrimaryNumber"
"		  ,pharmacyFacilityLocationNumber"
"		  ,patientPrimaryNumber "
"		  ,cost"
"		  ,NDC"
"		  ,NdcId"
"		  ,daysSupply"
"		  ,firstDateOfService"
"		  ,prescribingPhysicianNPI"
"		  ,metricQuantity"
"		  ,fileRequestId)"
"	select r.clientId"
"		  ,r.payerClaimControlNumber"
"		  ,r.claimStatusId"
"		  ,r.claimStatusCode"
"		  ,r.adjustedClaimControlNumber"
"		  ,r.slAssignedNumber"
"		  ,r.pharmacyFacilityPrimaryNumber"
"		  ,r.pharmacyFacilityLocationNumber"
"		  ,r.patientPrimaryNumber		 "
"		  ,cast(try_cast(r.totalPaidAmount as money) / f.lineCount as numeric(10, 2)) cost   -- either divide cost evenly or only set 1st line?"
"		  ,r.slProductServiceCode NDC "
"		  ,r.slProductServiceNdcId NdcId"
"		  ,try_cast(r.slPrescriptionDaysSupply as smallint) daysSupply"
"		  ,try_convert(datetime2, r.firstDateOfService, 121) firstDateOfService"
"		  ,r.slPrescriberProviderNpi prescribingPhysicianNPI"
"		  ,convert(decimal(10,2), left(r.slPrescriptionDispensedQuantity, 10) + '.' + right(r.slPrescriptionDispensedQuantity, 2)) metricQuantity"
"		  ,r.fileRequestId"
"	  from EdmStandard.PharmacyClaimReference r"
"	  join EdmStage.CareAnalyzerRxControlNumberListFinal f on /*r.fileRequestId = f.fileRequestId"
"											and*/ r.payerClaimControlNumber = f.payerClaimControlNumber"
"											and f.isFinal = 1"
"	  left join EdmStage.CareAnalyzerRx pcs on r.payerClaimControlNumber = pcs.payerClaimControlNumber"
"	 where r.fileRequestId = @fileRequestId"
"	   and pcs.careAnalyzerRxId is null;"

"	--declare @rowCount int = @@rowcount;"
"	set @rowCount = @@rowCount;"

"	print ''"
"	print '============Final==============='"
"	print 'FileRequestId = '"
"	print @fileRequestId"
"	print 'RowCount = '"
"	print @rowCount"
"	"
"	fetch fileRequestCur2 into @fileRequestId;"
end;

close fileRequestCur2
"deallocate fileRequestCur2;	1	2020-04-30 13:11:35.8166667	mssql"
"182	32	CARE_ANALYZER-PHARMACY-CLIENT_SPECIFIC	/*"
--create schema HMP;
-- drop table if exists HMP.PharmacyClaimControlNumberList;
-- drop table if exists HMP.PharmacyClaim;
-- drop sequence if exists HMP.PharmacyClaimSEQ;
*/

#NAME?
set nocount on

declare @fileRequestId bigint = :fileRequestId ;
declare @prep bit = 1;
declare @finalAction bit = 1;

if @prep = 1
"begin	"
    drop table if exists HMP.PharmacyClaimControlNumberList;

"	if object_id('HMP.PharmacyClaimControlNumberList') is null"
"		create table HMP.PharmacyClaimControlNumberList"
"		(payerClaimControlNumber nvarchar(255)"
"		,adjustedClaimControlNumber nvarchar(255)"
"		,fileRequestId bigint"
"		,lineCount int);"

"	declare fileRequestCur cursor for"
"	 select fileRequestId"
"	   from EdmLib.FileRequest"
"	  where processType= 'PHARMACY_CLAIM'"
"		and clientId = 32"
"		and isnull(purged, 0) = 0"
"		and completeFlag = 1"
"		and hasError = 0"
"		--and fileRequestId > 489"
"	  order by 1;"

"	open fileRequestCur;"
"	fetch fileRequestCur into @fileRequestId;"

"	while @@fetch_status = 0"
"	begin"
"		insert into HMP.PharmacyClaimControlNumberList"
"		select payerClaimControlNumber, adjustedClaimControlNumber, @fileRequestId, count(*) lineCount"
"		  from EdmStandard.PharmacyClaim r"
"		 where r.fileRequestId = @fileRequestId"
"		 group by payerClaimControlNumber, adjustedClaimControlNumber"
"		option (maxdop 4);"

"		declare @rowCount int = @@rowcount;"

"		print ''"
"		print '=============Prep==============='"
"		print 'FileRequestId = '"
"		print @fileRequestId"
"		print 'RowCount = '"
"		print @rowCount"
"		fetch fileRequestCur into @fileRequestId;"
"	end;"

"	close fileRequestCur;"
"	deallocate fileRequestCur;"
end;

if (select count(*) from sys.indexes where object_id = object_id('HMP.PharmacyClaimControlNumberList') and name = 'PharmacyClaimControlNumberListIdx1') = 0
"	create index PharmacyClaimControlNumberListIdx1"
"	on HMP.PharmacyClaimControlNumberList (adjustedClaimControlNumber, payerClaimControlNumber)"
"	include (fileRequestId, lineCount)"
"	with (data_compression=page);"

if @finalAction = 1
begin

"	drop table if exists HMP.PharmacyClaimControlNumberListFinal;"

"	with final as "
"		 (select 0 lvl, payerClaimControlNumber, adjustedClaimControlNumber, payerClaimControlNumber originalClaimNumber, lineCount, fileRequestId"
"			from HMP.PharmacyClaimControlNumberList"
"		   where adjustedClaimControlNumber is null"
"		  union all "
"		  select lvl + 1, r.payerClaimControlNumber, r.adjustedClaimControlNumber, f.payerClaimControlNumber, r.lineCount, r.fileRequestId"
"			from HMP.PharmacyClaimControlNumberList r"
"			join final f on f.payerClaimControlNumber = r.adjustedClaimControlNumber)"
"	select f.*"
"		  ,case when f.lvl = max(f.lvl) over(partition by originalClaimnumber) then 1 else 0 end isFinal"
"	  into HMP.PharmacyClaimControlNumberListFinal"
"	  from final f;	 "
end;

if (select count(*) from sys.indexes where name = 'PharmacyClaimControlNumberListFinalIdx1' and object_id = object_id('HMP.PharmacyClaimControlNumberListFinal')) = 0
"	create index PharmacyClaimControlNumberListFinalIdx1 "
"	on HMP.PharmacyClaimControlNumberListFinal (isFinal) "
    include (fileRequestId)
"	with(data_compression=page);"

if (select count(*) from sys.indexes where name = 'PharmacyClaimControlNumberListFinalIdx2' and object_id = object_id('HMP.PharmacyClaimControlNumberListFinal')) = 0
"	create index PharmacyClaimControlNumberListFinalIdx2"
"	on HMP.PharmacyClaimControlNumberListFinal (isFinal, payerClaimControlNumber, fileRequestId) "
    include (lineCount)
"	with(data_compression=page);"

drop table if exists HMP.PharmacyClaim;
drop sequence if exists HMP.PharmacyClaimSEQ;

if object_id('HMP.PharmacyClaim') is null
begin
"	create sequence HMP.PharmacyClaimSEQ start with 1;"

"	create table HMP.PharmacyClaim"
    (pharmacyClaimId bigint NOT NULL default next value for HMP.PharmacyClaimSEQ
    ,clientId int
    ,payerClaimControlNumber nvarchar(255)
    ,claimStatusId int
    ,claimStatusCode nvarchar(255)
    ,adjustedClaimControlNumber nvarchar(255)
    ,slAssignedNumber nvarchar(255)
    ,pharmacyFacilityPrimaryNumber nvarchar(255)
    ,pharmacyFacilityLocationNumber nvarchar(255)
    ,patientPrimaryNumber nvarchar(255)
    ,cost numeric(10, 2)
    ,NDC nvarchar(255)
"	,NdcId bigint"
    ,daysSupply smallint
    ,firstDateOfService datetime2(7)
"	,prescribingPhysicianNPI nvarchar(10)"
"	,metricQuantity decimal(10, 2)"
    ,fileRequestId bigint NOT NULL
"	,constraint PharmacyClaimPK primary key clustered (pharmacyClaimId))"
"	with (data_compression = page);"
end;

-- 
set @fileRequestId = null;
--dclr @fileRequestId bigint = null;

declare fileRequestCur2 cursor for
 select distinct fileRequestId 
   from HMP.PharmacyClaimControlNumberListFinal
  where isFinal = 1
    and fileRequestId >= 161
  order by 1 desc

open fileRequestCur2;
fetch fileRequestCur2 into @fileRequestId;

while @@fetch_status = 0
begin
    insert
"	  into HMP.PharmacyClaim"
"	      (clientId"
"		  ,payerClaimControlNumber"
"		  ,claimStatusId"
"		  ,claimStatusCode"
"		  ,adjustedClaimControlNumber"
"		  ,slAssignedNumber"
"		  ,pharmacyFacilityPrimaryNumber"
"		  ,pharmacyFacilityLocationNumber"
"		  ,patientPrimaryNumber "
"		  ,cost"
"		  ,NDC"
"		  ,NdcId"
"		  ,daysSupply"
"		  ,firstDateOfService"
"		  ,prescribingPhysicianNPI"
"		  ,metricQuantity"
"		  ,fileRequestId)"
"	select r.clientId"
"		  ,r.payerClaimControlNumber"
"		  ,r.claimStatusId"
"		  ,r.claimStatusCode"
"		  ,r.adjustedClaimControlNumber"
"		  ,r.slAssignedNumber"
"		  ,r.pharmacyFacilityPrimaryNumber"
"		  ,r.pharmacyFacilityLocationNumber"
"		  ,r.patientPrimaryNumber		 "
"		  ,cast(try_cast(r.totalPaidAmount as money) / f.lineCount as numeric(10, 2)) cost   -- either divide cost evenly or only set 1st line?"
"		  ,r.slProductServiceCode NDC "
"		  ,r.slProductServiceNdcId NdcId"
"		  ,try_cast(r.slPrescriptionDaysSupply as smallint) daysSupply"
"		  ,try_convert(datetime2, r.firstDateOfService, 121) firstDateOfService"
"		  ,r.slPrescriberProviderNpi prescribingPhysicianNPI"
"		  ,convert(decimal(10,2), left(r.slPrescriptionDispensedQuantity, 10) + '.' + right(r.slPrescriptionDispensedQuantity, 2)) metricQuantity"
"		  ,r.fileRequestId"
"	  from EdmStandard.PharmacyClaimReference r"
"	  join HMP.PharmacyClaimControlNumberListFinal f on /*r.fileRequestId = f.fileRequestId"
"											and*/ r.payerClaimControlNumber = f.payerClaimControlNumber"
"											and f.isFinal = 1"
"	  left join HMP.PharmacyClaim pcs on r.payerClaimControlNumber = pcs.payerClaimControlNumber"
"	 where r.fileRequestId = @fileRequestId"
"	   and pcs.pharmacyClaimId is null;"

"	--dclr @rowCount int = @@rowcount;"
"	set @rowCount = @@rowCount;"

"	print ''"
"	print '============Final==============='"
"	print 'FileRequestId = '"
"	print @fileRequestId"
"	print 'RowCount = '"
"	print @rowCount"
"	"
"	fetch fileRequestCur2 into @fileRequestId;"
end;

close fileRequestCur2
deallocate fileRequestCur2; 

#NAME?
drop table if exists ##ndc_dedup ;
if object_id('tempdb.dbo.##ndc_dedup') is null
select *
  into ##ndc_dedup
  from (select *
              ,rank() over(partition by ndc_upc_hri order by fileRequestId desc) rn
          from EdmStage.MediSpan_NDC_History) x
 where x.rn = 1 ;

drop table if exists ##ndc_name_dedup ;
if object_id('tempdb.dbo.##ndc_name_dedup') is null
select *
  into ##ndc_name_dedup
  from (select *
              ,rank() over(partition by drugDescriptorIdentifier, genericProductIdentifier, knowledgeBaseDrugCode order by fileRequestId desc) rn
          from EdmStage.MediSpan_NDC_Name_History) x
 where x.rn = 1 ;

drop table if exists ##ndc_tcgpi_dedup ;
if object_id('tempdb.dbo.##ndc_tcgpi_dedup') is null
select *
  into ##ndc_tcgpi_dedup
  from (select *
              ,rank() over(partition by tcGpiKey, recordType, tcLevelCode order by fileRequestId desc) rn
          from EdmStage.MediSpan_NDC_TCGPI_History) x
 where x.rn = 1;

drop table if exists ##ndc_final ;
if object_id('tempdb.dbo.##ndc_final') is null
select g2.tcGpiName drugGroupName
"	  ,g2.tranCode drugGroupTransactionCode"
"	  ,left(g.TcGpiKey, 4) drugClassCode"
"	  ,g4.tcGpiName drugClassName"
"	  ,g4.tranCode drugClassTransactionCode"
"	  ,left(g.TcGpiKey, 6) drugSubClassCode"
"	  ,g6.tcGpiName drugSubClassName"
"	  ,g6.tranCode drugSubClassTransactionCode"
"	  ,g.tcGpiKey"
"	  ,g.tcGpiName"
"	  ,g.recordType"
"	  ,g.tcLevelCode"
"	  ,g.tranCode tcGpiTransactionCode"
"	  ,n.drugDescriptorIdentifier"
"	  ,n.drugName"
"	  ,n.routeAdmin routeOfAdministration"
"	  ,n.dosageForm"
"	  ,n.strength"
"	  ,n.strengthUnitOfMeasure"
"	  ,case n.bioequ "
"	  	    when 'A' then 'Products in same GPI are equivalent'"
"	  	    when 'B' then 'Products in same GPI are not equivalent'"
"	  	    when 'C' then 'Products may or may not be equivalent'"
"	  	    when 'N' then 'Equivalency determination not available'"
"	  	    when 'U' then 'Undeterminable (obsolete)' "
"	   end bioequivalence"
"	  ,n.brandCode brandNameCode"
"	  ,n.nameSr nameSourceCode"
"	  ,n.tranCode drugNameTransactionCode"
"	  --"
"	  ,ndc.ndc_upc_hri ndcUpcHri "
"	  ,case ndc.idNoCode --IdNumberFormatCode "
"	  	    when 1 then '4-4-2'"
"	  	    when 2 then '5-3-2'"
"	  	    when 3 then '5-4-1'"
"	  	    when 4 then '4-6'"
"	  	    when 5 then '5-5'"
"	  	    when 6 then '5-4-2' "
"	   end idNumberFormat"
"	  ,case ndc.idNoCode --IdNumberFormatCode"
"	  	    when 4 then 'HRI'"
"	  	    when 5 then 'UPC or HRI'"
"	  	else 'NDC'"
"	   end idType"
"	  ,ndc.old_ndc_upc_hri oldNdcUpcHri"
"	  ,ndc.new_ndc_upc_hri newNdcUpcHri"
"	  ,ndc.mediSpanLabelerIdentifier"
"	  ,case ndc.nameCode -- NameTypeCode"
"	  	    when 'G' then 'Generic Name'"
"	  	    when 'T' then 'Trademarked Name'"
"	  	    when 'B' then 'Branded Generic Name' "
"	   end nameType"
"	  ,ndc.oldEffectiveDate"
"	  ,ndc.newEffectiveDate"
"	  ,ndc.nextSmNDCName nextSmallerNdcSuffixNumber"
"	  ,ndc.nextLgNDCName nextLargerNdcSuffixNumber"
"	  ,case ndc.itemSt --ItemStatusFlag"
"	  	    when 'A' then 'Active'"
"	  	    when 'I' then 'Inactive'"
"	  	    when 'O' then 'Override'"
"	  	    when 'Z' then 'Inactive Greater than 48 Months'"
"	   end itemStatus"
"	  ,ndc.tranCode ndcTransactionCode"
  into ##ndc_final
  from ##ndc_dedup ndc
  join ##ndc_name_dedup n on ndc.drugDescriptorIdentifier = n.drugDescriptorIdentifier
  join ##ndc_tcgpi_dedup g on n.genericProductIdentifier = g.TcGpiKey
  join ##ndc_tcgpi_dedup g2 on g2.tcLevelCode = '02' and left(g.tcGpiKey, 2) = g2.tcGpiKey
  join ##ndc_tcgpi_dedup g4 on g4.tcLevelCode = '04' and left(g.tcGpiKey, 4) = g4.tcGpiKey
  join ##ndc_tcgpi_dedup g6 on g6.tcLevelCode = '06' and left(g.tcGpiKey, 6) = g6.tcGpiKey ;

drop table if exists ##ndc_high_prescriber_lookup ;
if object_id('tempdb.dbo.##ndc_high_prescriber_lookup') is null
select 'Opioid' src
      ,*
  into ##ndc_high_prescriber_lookup
  from ##ndc_final
    -- Opioids
 where drugGroupName = '*ANALGESICS - OPIOID*' 
   and drugName in
('Abstral'
,'Acetaminophen-Codeine'
,'Acetaminophen-Codeine #2'
,'Acetaminophen-Codeine #3'
,'Acetaminophen-Codeine #4'
,'Actiq'
,'Apadaz'
,'APAP-Caff-Dihydrocodeine'
,'Arymo ER'
,'Ascomp-Codeine'
,'Aspirin-Caff-Dihydrocodeine'
,'AVINza'
,'Benzhydrocodone-Acetaminophen'
,'Buprenorphine'
,'Butalbital Compound/Codeine'
,'Butalbital-APAP-Caff-Cod'
,'Butalbital-ASA-Caff-Codeine'
,'Butorphanol Tartrate'
,'Butrans'
,'Capital/Codeine'
,'Codeine Sulfate'
,'Co-Gesic'
,'ConZip'
,'Demerol'
,'Dilaudid'
,'Dolophine'
,'Dsuvia'
,'Duragesic-100'
,'Duragesic-12'
,'Duragesic-25'
,'Duragesic-50'
,'Duragesic-75'
,'Dvorah'
,'Embeda'
,'Endocet'
,'Endodan'
,'Exalgo'
,'fentaNYL'
,'fentaNYL Citrate'
,'Fentora'
,'Fioricet/Codeine'
,'Fiorinal/Codeine #3'
,'Hycet'
,'HYDROcodone Bitartrate ER'
,'HYDROcodone-Acetaminophen'
,'Hydrocodone-Ibuprofen'
,'Hydrogesic'
,'HYDROmorphone HCl'
,'HYDROmorphone HCl ER'
,'Hysingla ER'
,'Ibudone'
,'Ionsys'
,'Kadian'
,'Lazanda'
,'Levorphanol Tartrate'
,'Liquicet'
,'Lorcet'
,'Lorcet HD'
,'Lorcet Plus'
,'Lortab'
,'Magnacet'
,'Meperidine HCl'
,'Meperidine-Promethazine'
,'Methadone HCl'
,'Methadone HCl Intensol'
,'Methadose'
,'Methadose Sugar-Free'
,'MorphaBond ER'
,'Morphine Sulfate'
,'Morphine Sulfate (Concentrate)'
,'Morphine Sulfate ER'
,'Morphine Sulfate ER Beads'
,'MS Contin'
,'Nalocet'
,'Norco'
,'Nucynta'
,'Nucynta ER'
,'Opana'
,'Opana ER'
,'Oxaydo'
,'oxyCODONE HCl'
,'oxyCODONE HCl ER'
,'Oxycodone-Acetaminophen'
,'oxyCODONE-Aspirin'
,'oxyCODONE-Ibuprofen'
,'OxyCONTIN'
,'oxyMORphone HCl'
,'oxyMORphone HCl ER'
,'Panlor'
,'Pentazocine-Acetaminophen'
,'Pentazocine-Naloxone HCl'
,'Percocet'
,'Primlev'
,'Reprexain'
,'Roxicet'
,'Roxicodone'
,'RoxyBond'
,'Stagesic'
,'Subsys'
,'Synalgos-DC'
,'Synapryn FusePaq'
,'Theracodeine-300'
,'Theracodophen-325'
,'Theracodophen-650'
,'Theracodophen-750'
,'Theracodophen-Low-90'
,'Theratramadol-60'
,'Theratramadol-90'
,'traMADol HCl'
,'traMADol HCl ER'
,'traMADol HCl ER (Biphasic)'
,'traMADol-Acetaminophen'
,'Trezix'
,'Tylenol with Codeine #3'
,'Tylenol with Codeine #4'
,'Ultracet'
,'Ultram'
,'Ultram ER'
,'Verdrocet'
,'Vicodin'
,'Vicodin ES'
,'Vicodin HP'
,'Vicoprofen'
,'Xartemis XR'
,'Xodol'
,'Xolox'
,'Xtampza ER'
,'Xylon'
,'Zamicet'
,'Zohydro ER'
,'Zydone')
union all
select 'Gapepentin & Pregabalin' src
      ,*
  from ##ndc_final
 where drugGroupName in ('*ANTICONVULSANTS*', '*PSYCHOTHERAPEUTIC AND NEUROLOGICAL AGENTS - MISC.*')
   and (tcGpiName like '%Gabapentin%' or tcGpiName like '%Pregabalin%')
union all
select 'Benzodiazepine Hypnotic' src
      ,*
  from ##ndc_final
 where drugGroupName in ('*ANTIANXIETY AGENTS*', '*ANTICONVULSANTS*', '*HYPNOTICS/SEDATIVES/SLEEP DISORDER AGENTS*')
   and (drugSubClassName like '%Benzodiazepine%' or drugSubClassName = '*Hypnotic Combinations***')
   and drugName in 
('ALPRAZolam'
,'ALPRAZolam ER'
,'ALPRAZolam Intensol'
,'ALPRAZolam XR'
,'Ativan'
,'chlordiazePOXIDE HCl'
,'cloBAZam'
,'clonazePAM'
,'Clorazepate Dipotassium'
,'Diastat AcuDial'
,'Diastat Pediatric'
,'diazePAM'
,'diazePAM Intensol'
,'Doral'
,'Estazolam'
,'Flurazepam HCl'
,'Gabavale-5'
,'Gabazolamine'
,'Gabazolamine-0.5'
,'Halcion'
,'KlonoPIN'
,'LORazepam'
,'LORazepam Intensol'
,'Midazolam HCl'
,'Midazolam HCl (PF)'
,'Midazolam+SyrSpend SF'
,'Midazolam-Ketamine-Ondansetron'
,'MKO Melt Dose Pack'
,'Nayzilam'
,'Onfi'
,'Oxazepam'
,'Quazepam'
,'Restoril'
,'Sentrazolam AM 0.25'
,'Strazepam'
,'Sympazan'
,'Temazepam'
,'Tranxene-T'
,'Triazolam'
,'Valium'
,'Xanax'
,'Xanax XR') ;

drop table if exists ##pcp ;
if object_id('tempdb.dbo.##pcp') is null
select clientId
      ,npi
      ,count(distinct patientId) memberCount
  into ##pcp
  from QTIP.Patient.PatientProvider
 where clientid = 32
   and patientProviderActiveFlag = 1
   and /*entityTypeQualifierId = 10
   and*/ providerTypeId = 10 
 group by clientId
         ,npi ;

#NAME?
#NAME?
-- 
-- ? what if an NPI is no longer active in NPPES? Indicate inactive NPIs with an asterisk following the NPI, e.g. 123456789*
-- ! flag inactive NPIs put an asterisk after the NPI to indicate inactive!

drop table if exists HMP.Prescription;
if object_id('HMP.Prescription') is null
select pc.clientId
      ,pc.prescribingPhysicianNPI + case when pn.entityTypeQualifier is null then '*' else '' end npi
"	  ,n.providerLastName physicianLastName"
"	  ,n.providerFirstName physicianFirstName"
"	  ,n.providerOrganizationName"
"	  ,l.src"
"	  ,l.tcGpiName"
"	  ,l.drugName"
"	  ,l.itemStatus"
"	  ,pc.ndc"
"	  ,pc.patientPrimaryNumber"
"	  ,pc.firstDateOfService prescribedDate"
"	  ,pc.metricQuantity"
"	  ,pc.daysSupply"
"	  ,pc.payerClaimControlNumber"
"	  ,pc.adjustedClaimControlNumber"
"	  ,pc.claimStatusId"
"	  ,pc.claimStatusCode"
  into HMP.Prescription
  from ##ndc_high_prescriber_lookup l
  join HMP.PharmacyClaim pc on l.ndcUpcHri = pc.NDC
"						   and pc.claimStatusId not in (14)"
  left join QTIP.Reference.Nppes n on pc.prescribingPhysicianNPI = n.npi 
  left join PAW.Reference.Nppes pn on pc.prescribingPhysicianNPI = pn.npi 
option (maxdop 4) ;

-- stage all prescribers and flag which ones are "high prescribers"
-- ? how do we care if the NDCs are now inactive? we don't

drop table if exists HMP.Prescriber ;
if object_id('HMP.Prescriber') is null
begin
"	select p.clientId"
"	      ,p.npi"
"		  ,p.physicianFirstName"
"		  ,p.physicianLastName"
"		  ,p.providerOrganizationName"
"		  ,pcp.memberCount memberPcpCount"
"		  ,convert(date, convert(varchar(4), datepart(year, p.prescribedDate)) + '-' + right('0'+convert(varchar(2), datepart(month, p.prescribedDate)), 2) + '-01') prescribedMonth"
"		  ,p.src"
"		  ,count(*) prescribedCount"
"		  ,count(distinct p.patientPrimaryNumber) memberPrescribedCount"
"		  ,case when count(*) > 10 then 1 else 0 end isHighPrescriber"
"		  ,max(case when pcp.npi is not null then 1 else 0 end) isPCP"
"	  into HMP.Prescriber"
"	  from HMP.Prescription p"
"	  left join ##pcp pcp on case when right(p.npi, 1) = '*' then left(p.npi, 10) else p.npi end = pcp.Npi -- in case the npi is inactive"
"	                     and p.clientId = pcp.clientId"
"		-- still count metricQuantity or daysSupply = 0 because there could be an issue on the claims side"
"	 group by p.clientId"
"	         ,p.npi"
"			 ,p.physicianFirstName"
"			 ,p.physicianLastName"
"			 ,p.providerOrganizationName"
"			 ,pcp.memberCount"
"			 ,convert(varchar(4), datepart(year, p.prescribedDate))"
"			 ,right('0'+convert(varchar(2), datepart(month, p.prescribedDate)), 2)"
"			 ,p.src ;"
 
    -- drop index prescriber_temp_idx1 on HMP.Prescriber ;
"	create clustered index Prescriber_Idx1 on HMP.Prescriber(clientId, npi, prescribedMonth, isPCP) ;"
"end; 	0	2020-04-30 13:13:19.2700000	mssql"
"183	0	CARE_ANALYZER-PHARMACY-MERGE_CLAIM	set nocount on"

declare @fileRequestId bigint = :fileRequestId ;
declare @prep bit = 1;
declare @finalAction bit = 1;
declare @clientId int ;

select @clientId = clientId
  from EdmLib.FileRequest
 where fileRequestId = @fileRequestId ;

if @prep = 1
"begin	"
    drop table if exists EdmStage.CareAnalyzerRxControlNumberList;

"	if object_id('EdmStage.CareAnalyzerRxControlNumberList') is null"
"		create table EdmStage.CareAnalyzerRxControlNumberList"
"		(clientId int not null"
"		,payerClaimControlNumber nvarchar(255)"
"		,adjustedClaimControlNumber nvarchar(255)"
"		,fileRequestId bigint"
"		,lineCount int);"

"	declare fileRequestCur cursor for"
"	 select fileRequestId"
"	   from EdmLib.FileRequest"
"	  where processType= 'PHARMACY_CLAIM'"
"		and clientId = @clientId"
"		and isnull(purged, 0) = 0"
"		and completeFlag = 1"
"		and hasError = 0"
"		and fileRequestId <= @fileRequestId"
"	  order by 1;"

"	open fileRequestCur;"
"	fetch fileRequestCur into @fileRequestId;"

"	while @@fetch_status = 0"
"	begin"
"		insert into EdmStage.CareAnalyzerRxControlNumberList"
"		select clientId, claimNumber, adjustedClaimNumber, @fileRequestId, count(*) lineCount"
"		  from EdmStandard.CareAnanlyzerPharmacyClaimReference r"
"		 where r.fileRequestId = @fileRequestId"
"		 group by clientId, claimNumber, adjustedClaimNumber"
"		option (maxdop 4);"

"		declare @rowCount int = @@rowcount;"

"		print ''"
"		print '=============Prep==============='"
"		print 'FileRequestId = '"
"		print @fileRequestId"
"		print 'RowCount = '"
"		print @rowCount"
"		fetch fileRequestCur into @fileRequestId;"
"	end;"

"	close fileRequestCur;"
"	deallocate fileRequestCur;"
end;

if (select count(*) from sys.indexes where object_id = object_id('EdmStage.CareAnalyzerRxControlNumberList') and name = 'PharmacyClaimControlNumberListIdx1') = 0
"	create index PharmacyClaimControlNumberListIdx1"
"	on EdmStage.CareAnalyzerRxControlNumberList (adjustedClaimControlNumber, payerClaimControlNumber)"
"	include (fileRequestId, lineCount)"
"	with (data_compression=page);"

if @finalAction = 1
begin

"	drop table if exists EdmStage.CareAnalyzerRxControlNumberListFinal;"

"	with final as "
"		 (select 0 lvl, clientId, payerClaimControlNumber, adjustedClaimControlNumber, payerClaimControlNumber originalClaimNumber, lineCount, fileRequestId"
"			from EdmStage.CareAnalyzerRxControlNumberList"
"		   where adjustedClaimControlNumber is null"
"		  union all "
"		  select lvl + 1, r.clientId, r.payerClaimControlNumber, r.adjustedClaimControlNumber, f.payerClaimControlNumber, r.lineCount, r.fileRequestId"
"			from EdmStage.CareAnalyzerRxControlNumberList r"
"			join final f on f.payerClaimControlNumber = r.adjustedClaimControlNumber"
"			            and f.clientId = r.clientId)"
"	select f.*"
"		  ,case when f.lvl = max(f.lvl) over(partition by originalClaimnumber) then 1 else 0 end isFinal"
"	  into EdmStage.CareAnalyzerRxControlNumberListFinal"
"	  from final f;	 "
end;

if (select count(*) from sys.indexes where name = 'PharmacyClaimControlNumberListFinalIdx1' and object_id = object_id('EdmStage.CareAnalyzerRxControlNumberListFinal')) = 0
"	create index PharmacyClaimControlNumberListFinalIdx1 "
"	on EdmStage.CareAnalyzerRxControlNumberListFinal (isFinal) "
    include (fileRequestId)
"	with(data_compression=page);"

if (select count(*) from sys.indexes where name = 'PharmacyClaimControlNumberListFinalIdx2' and object_id = object_id('EdmStage.CareAnalyzerRxControlNumberListFinal')) = 0
"	create index PharmacyClaimControlNumberListFinalIdx2"
"	on EdmStage.CareAnalyzerRxControlNumberListFinal (isFinal, payerClaimControlNumber, fileRequestId) "
    include (lineCount)
"	with(data_compression=page);"

if object_id('EdmStage.CareAnalyzerRx') is null
begin
"	create sequence EdmStage.CareAnalyzerRxSEQ start with 1;"
"	create table EdmStage.CareAnalyzerRx"
    (careAnalyzerRxId bigint NOT NULL default next value for EdmStage.CareAnalyzerRxSEQ
    ,clientId int not null
    ,payerClaimControlNumber nvarchar(255)
    ,claimStatusId int
    ,claimStatusCode nvarchar(255)
    ,adjustedClaimControlNumber nvarchar(255)
    ,slAssignedNumber nvarchar(255)
    ,pharmacyFacilityPrimaryNumber nvarchar(255)
    ,pharmacyFacilityLocationNumber nvarchar(255)
    ,patientPrimaryNumber nvarchar(255)
    ,cost numeric(10, 2)
    ,NDC nvarchar(255)
"	,NdcId bigint"
    ,daysSupply smallint
    ,firstDateOfService datetime2(7)
"	,prescribingPhysicianNPI nvarchar(10)"
"	,metricQuantity decimal(10, 2)"
    ,fileRequestId bigint NOT NULL
"	,constraint CareAnalyzerRxPK primary key clustered (careAnalyzerRxId, clientId))"
"	on ClientPscheme(clientId)"
"	with (data_compression = page);"
end;
else
"	truncate table EdmStage.CareAnalyzerRx with (partitions($Partition.ClientPfnc(@clientId))) ;"

-- 
set @fileRequestId = null;
--declare @fileRequestId bigint = null;

declare fileRequestCur2 cursor for
 select distinct fileRequestId 
   from EdmStage.CareAnalyzerRxControlNumberListFinal
  where isFinal = 1
  order by 1 desc

open fileRequestCur2;
fetch fileRequestCur2 into @fileRequestId;

while @@fetch_status = 0
begin
    insert
"	  into EdmStage.CareAnalyzerRx"
"	      (clientId"
"		  ,payerClaimControlNumber"
"		  ,claimStatusId"
"		  ,claimStatusCode"
"		  ,adjustedClaimControlNumber"
"		  ,slAssignedNumber"
"		  ,pharmacyFacilityPrimaryNumber"
"		  ,pharmacyFacilityLocationNumber"
"		  ,patientPrimaryNumber "
"		  ,cost"
"		  ,NDC"
"		  ,NdcId"
"		  ,daysSupply"
"		  ,firstDateOfService"
"		  ,prescribingPhysicianNPI"
"		  ,metricQuantity"
"		  ,fileRequestId)"
"	select r.clientId"
"		  ,r.payerClaimControlNumber"
"		  ,r.claimStatusId"
"		  ,r.claimStatusCode"
"		  ,r.adjustedClaimControlNumber"
"		  ,r.slAssignedNumber"
"		  ,r.pharmacyFacilityPrimaryNumber"
"		  ,r.pharmacyFacilityLocationNumber"
"		  ,r.patientPrimaryNumber		 "
"		  ,cast(try_cast(r.totalPaidAmount as money) / f.lineCount as numeric(10, 2)) cost   -- either divide cost evenly or only set 1st line?"
"		  ,r.slProductServiceCode NDC "
"		  ,r.slProductServiceNdcId NdcId"
"		  ,try_cast(r.slPrescriptionDaysSupply as smallint) daysSupply"
"		  ,try_convert(datetime2, r.firstDateOfService, 121) firstDateOfService"
"		  ,r.slPrescriberProviderNpi prescribingPhysicianNPI"
"		  ,convert(decimal(10,2), left(r.slPrescriptionDispensedQuantity, 10) + '.' + right(r.slPrescriptionDispensedQuantity, 2)) metricQuantity"
"		  ,r.fileRequestId"
"	  from EdmStandard.CareAnanlyzerPharmacyClaimReference r"
"	  join EdmStage.CareAnalyzerRxControlNumberListFinal f on /*r.fileRequestId = f.fileRequestId"
"											and*/ r.payerClaimControlNumber = f.payerClaimControlNumber"
"											and f.isFinal = 1"
"	  left join EdmStage.CareAnalyzerRx pcs on r.payerClaimControlNumber = pcs.payerClaimControlNumber"
"	 where r.fileRequestId = @fileRequestId"
"	   and pcs.careAnalyzerRxId is null;"

"	--declare @rowCount int = @@rowcount;"
"	set @rowCount = @@rowCount;"

"	print ''"
"	print '============Final==============='"
"	print 'FileRequestId = '"
"	print @fileRequestId"
"	print 'RowCount = '"
"	print @rowCount"
"	"
"	fetch fileRequestCur2 into @fileRequestId;"
end;

close fileRequestCur2
"deallocate fileRequestCur2;	1	2020-04-30 14:14:15.0666667	mssql"
"184	34	GET_PSM_FINAL_RECORD_COUNT	select count(*) from EdmStage.COC_BiometricsPSM 	1	2020-05-12 09:36:11.4133333	mssql"
"185	72	MPI-INSERT_BULK_REQUEST_STAGE	declare @fileRequestId bigint = :fileRequestId ;"

insert into MPI.BulkRequestStage
       (BulkRequestStageId
       ,ClientIdentifier
       ,OriginalPatientIdentifier
       ,CurrentPatientIdentifier
       ,PolicyNumber
       ,FirstName
       ,MiddleName
       ,LastName
       ,SSN
       ,DOB
       ,Gender
       ,AddressLine1
       ,AddressLine2
       ,City
       ,State
       ,ZIP
       ,Telephone)
select m.stageId BulkRequestStageId
          ,c.clientCode ClientIdentifier
      ,m.memberAlternateId + right('0'+m.dependentNumber, 2) OriginalPatientIdentifier
          ,null CurrentPatientIdentifier
          ,m.memberAlternateId PolicyNumber
          ,isnull(m.dependentFirstName, 'UNKNOWN') FirstName
          ,null MiddleName
          ,isnull(case when ascii(trim(upper(m.dependentLastName))) between 65 and 90 then m.dependentLastName end, 'UNKNOWN') LastName
          ,case when m.dependentNumber = '0' and m.subscriberSSN <> '000000000' then m.subscriberSSN end SSN
          ,case when year(try_convert(datetime2, m.dob)) > 1800 then left(m.dob, 4) +'-'+ right(left(m.dob, 7), 2) +'-'+ right(m.dob, 2) + ' 00:00:00' end  DOB
          ,isnull(m.gender, 'U') Gender
          ,m.address2 AddressLine1
          ,m.address1 AddressLine2
          ,m.city City
          ,m.state State
          ,m.zipCode ZIP
          ,null Telephone
  from EdmStage.Nasi_MemberCSV m
  join EdmLib.FileRequest fr on fr.fileRequestId = @fileRequestId
  join Reference.Client c on fr.clientId = c.clientId
" where m.fileRequestId = @fileRequestId ; 	1	2020-05-12 13:33:29.1000000	mssql"
"186	72	MPI-DUPLICATE_MPI_COUNT	select count(*)"
  from (select m.memberAlternateId+right('00'+isnull(convert(varchar(2), m.dependentNumber), '00'), 2) patientPrimaryNumber
              ,count(*) recordCount
              ,string_agg(m.memberAlternateId+right('00'+isnull(convert(varchar(2), m.dependentNumber), '00'), 2), ', ') within group (order by m.stageId) patientSsnList
              ,count(distinct m.memberAlternateId+right('00'+isnull(convert(varchar(2), m.dependentNumber), '00'), 2)) patientSsnCount
              ,string_agg(m.dob, ', ') within group (order by m.stageId) birthDateList
              ,count(distinct m.dob) birthDateCount
              ,string_agg(m.gender, ', ') within group (order by m.stageId) genderList
              ,count(distinct m.gender) genderCount
              ,max(fileRequestId) fileRequestId
              ,string_agg(m.stageId, ', ') within group (order by m.stageId) stageIdList
"			  ,string_agg(m.dependentLastName, ',') within group (order by m.stageId) memberLastNameList"
"			  ,string_agg(m.dependentFirstName, ',') within group (order by m.stageId) memberFirstNameList"
          from EdmStage.Nasi_MemberCSV m
"		 where enterprisePatientId is not null"
         group by m.memberAlternateId+right('00'+isnull(convert(varchar(2), m.dependentNumber), '00'), 2)
        having count(distinct m.memberAlternateId+right('00'+isnull(convert(varchar(2), m.dependentNumber), '00'), 2)) > 1
            or count(distinct m.dob) > 1
            or count(distinct m.gender) > 1
"			or count(distinct enterprisePatientId) > 1"
"			) x	1	2020-05-18 16:54:00.2233333	mssql"
"187	72	RETIRE_MEMBERS	declare @fileRequestId bigint = :fileRequestId ;"
declare @clientId int ;

select @clientId = clientId
  from EdmLib.FileRequest
 where fileRequestId = :fileRequestId ;

with maximums as (select max(stageId) stageId, max(fileRequestId) fileRequestId from EdmStage.Nasi_MemberCSV)
insert into EdmStage.Nasi_MemberCSV
"	  (stageId"
"	  ,fileRequestId"
"	  ,locationNumber"
"	  ,memberAlternateId"
"	  ,subscriberSSN"
"	  ,subscriberLastName"
"	  ,subscriberFirstName"
"	  ,dependentNumber"
"	  ,dependentLastName"
"	  ,dependentFirstName"
"	  ,relationshipCode"
      ,dob
"	  ,gender"
"	  ,eligibilityBeginDate"
"	  ,eligibilityEndDate"
"	  ,fund"
"	  ,subGrp"
"	  ,subGrpName"
"	  ,planNumber"
"	  ,planType"
"	  ,coverageCd"
"	  ,address1"
"	  ,address2"
"	  ,city"
"	  ,state"
"	  ,zipCode"
"	  ,enterprisePatientId"
"	  ,enterpriseSubscriberId)"
select row_number() over(partition by 1 order by p.patientId) + m.stageId stageId
"	  ,m.fileRequestId"
"	  ,p.location"
"	  ,left(p.patientPrimaryNumber, 9) memberAlternateId"
"	  ,null subscriberSSN"
"	  ,null subscriberLastName"
"	  ,null subscriberFirstName"
"	  ,case when p.relationshipCode = '18' then '0' end dependentNumber"
"	  ,p.patientLastName dependentLastName"
"	  ,p.patientFirstName dependentFirstName"
"	  ,case when p.relationshipCode = '18' then p.patientGenderCode"
"	        when p.relationshipCode = '01' and p.patientGenderCode = 'M' then 'H'"
"			when p.relationshipCode = '01' and p.patientGenderCode = 'F' then 'W'"
"			when p.relationshipCode = '19' and p.patientGenderCode = 'M' then 'S'"
"			when p.relationshipCode = '19' and p.patientGenderCode = 'F' then 'D'"
"			when p.relationshipCode = '17' and p.patientGenderCode = 'M' then 'T'"
"			when p.relationshipCode = '17' and p.patientGenderCode = 'F' then 'E'"
"			when p.relationshipCode = '25' then 'EX'"
"	   end relationshipCode"
      ,p.patientBirthDate dob
"	  ,p.patientGenderCode gender"
"	  ,convert(varchar(10), e.benefitPlanStartDate, 121) eligibilityBeginDate"
"	  ,convert(varchar(10), dateadd(day, -1, cast(year(sysdatetime()) as varchar(4)) + '-'+ cast(month(sysdatetime()) as varchar(2)) + '-01'), 121)  eligibilityEndDate"
"	  ,'NASI' fund"
"	  ,null subGrp"
"	  ,null subGrpName"
"	  ,null planNumber"
"	  ,null planType"
"	  ,null coverageCd"
"	  ,null address1"
"	  ,null address2"
"	  ,null city"
"	  ,null state"
"	  ,null zipCode"
"	  ,p.enterprisePatientId"
"	  ,p.enterpriseSubscriberId"
from Patient.PatientDim p
cross apply maximums m
left join Patient.PatientDim sub on p.clientId = sub.clientId
"								and p.enterpriseSubscriberId = sub.enterprisePatientId"
"								and p.recordTypeId = 28"
left join Patient.EmailDim em on p.clientId = em.clientId
"								and p.patientId = em.patientId"
"								and em.activeFlag = 1"
left join Patient.AddressDim ad on p.clientId = ad.clientId
"								and p.patientId = ad.patientId"
"								and ad.activeFlag = 1"
left join EdmStage.Nasi_MemberCSV s on p.enterprisePatientId = s.enterprisePatientId
join Patient.EligibilityFact e on p.clientId = e.clientId
"								and p.patientId = e.patientId"
"								and e.eligibilityFactActiveFlag = 1"
"								and (e.benefitPlanEndDate is null"
"									or e.benefitPlanEndDate > sysdatetime())"
join Reference.GroupPolicy gp on e.groupPolicyId = gp.groupPolicyId
join Reference.Plans pl on e.benefitPlanId = pl.plansId
where p.clientId = @clientId
"	and p.patientActiveFlag = 1"
"	and s.stageId is null ; 	1	2020-05-20 18:35:01.0600000	mssql"
"188	51	RETIRE_MISSING_MEMBERS	declare @fileRequestId bigint = :fileRequestId ;"

with maxId as
    (select max(stageId) maxStageId from EdmStage.LasVegas_Member)
insert into EdmStage.LasVegas_Member
--(stageId
--,fileRequestId
--,clientId
--,clientName
--,policyNumber
--,memberId
--,ssn
--,lastName
--,firstName
--,birthDate
--,gender
--,phone
--,relation
--,addressLine1
--,addressLine2
--,city
--,state
--,zip
--,countyId
--,policyType
--,policyGroup
--,policyPlan
--,medicarePrime
--,medicareStart
--,cobra
--,eligibilityStartDate
--,eligibilityEndDate
--,medicareId
--,stateOfEnrollment
--,pcpTin
--,pcpStartDate
--,region
--,ppoNetworkId
--,secondaryNetworkId
--,tpa
--,filler
--,enterprisePatientId
--,layoutName
--,employeeCertificationNumber
--,employeeCertificationSubNumber
--,memberSequenceNumber
--,crossReferenceEmployeeCertificationNumber
--,crossReferenceEmployeeCertificationSubNumber
--,dependentSsn
--,groupNumber
--,memberLastName
--,memberFirstName
--,memberMiddleInitial
--,nameQualifier
--,stateOfResidence
--,zipcode
--,country
--,phoneNumber
--,emailAddress
--,groupLocationCode
--,startWorkDate
--,medicareHicNumber
--,hoursWorkedPerWeek
--,workStatusCode
--,memberDateOfBirth
--,memberGender
--,maritalStatus
--,dependentStatusCode
--,filler1
--,groupEmployeeNumber
--,workSiteCode
--,workState
--,originalEffectiveDateOfEmployee
--,employeeDateOfBirth
--,employeeGender
--,customerReportingField1
--,customerReportingField2
--,customerReportingField3
--,customerReportingField4
--,customerReportingField5
--,customerReportingField6
--,customerReportingField7
--,coverageTier
--,umrPlanContractNumber
--,lineOfCoverage
--,classCode
--,onlyAppliesToSupplementalLife
--,effectiveDate
--,terminationEndDate
--,blockDate
--,benefitPlan
--,opi
--,filler2
--,effectiveStatusCode
--,expirationStatusCode
--,umrAssignedEmployeeNumber
--,employeeSsn
--,umrIdCardNumber
--,umrIdCardType
--,dependentStatusCodeChangeDate
--,filler3
--,tpaRoutingCode
--,internalNetworkRoutingCode
--,medicarePrimeIndicator
--,medicarePrimeBeginDate
--,medicarePrimeEndDate
--,filler4)
(stageId
,fileRequestId
,clientId
,clientName
,policyNumber
,memberId
,ssn
,lastName
,firstName
,birthDate
,memberGender
,phone
,relation
,addressLine1
,addressLine2
,city
,state
,zip
,countyId
,policyType
,policyGroup
,policyPlan
,medicarePrime
,medicareStart
,cobra
,eligibilityStartDate
,eligibilityEndDate
,medicareId
,stateOfEnrollment
,pcpStartDate
,region
,ppoNetworkId
,secondaryNetworkId
,tpa
,filler
,enterprisePatientId)
select mx.maxStageId + row_number() over(partition by 1 order by pd.patientPrimaryNumber) stageId
      ,@fileRequestId fileRequestId
          ,null clientId
          ,null clientName
          ,left(pd.patientPrimaryNumber, 9) policyNumber
          ,'000' + right(pd.patientPrimaryNumber, 2) memberId
          ,isnull(pd.patientSsn, case when right(pd.patientPrimaryNumber, 2) = '00' then left(pd.patientPrimaryNumber, 9) end) ssn
          ,pd.patientLastName lastName
          ,pd.patientFirstName firstName
          ,convert(varchar(10), pd.patientBirthDate, 112) birthDate
          ,pd.patientGenderCode
          ,null phone
          --,pd.relationshipCode
          ,rel.inValue relation
          ,null addressLine1
          ,null addressLine2
          ,null city
          ,null state
          ,null zip
          ,null countyId
          ,substring(gp.groupPolicyNumber, 1, charindex('-', gp.groupPolicyNumber)-1) policyType
          ,substring(gp.groupPolicyNumber, charindex('-', gp.groupPolicyNumber)+1, charindex('-', gp.groupPolicyNumber, charindex('-', gp.groupPolicyNumber)-charindex('-', gp.groupPolicyNumber)+1)) policyGroup
          ,substring(gp.groupPolicyNumber, charindex('-', gp.groupPolicyNumber, charindex('-', gp.groupPolicyNumber, charindex('-', gp.groupPolicyNumber)+1))+1, len(gp.groupPolicyNumber)) policyPlan
          ,null medicarePrime
          ,null medicareStart
          ,case when pl.planNumber =  'CWC' then '0001' else '0000' end cobra
          ,convert(varchar(10), ef.benefitPlanStartDate, 112) eligibilityStartDate
          ,convert(varchar(10), dateadd(day, -1, convert(varchar(4), year(sysdatetime())) +'-'+ convert(varchar(2), datepart(month, sysdatetime())) + '-01'), 112) eligibilityEndDate
          ,null medicareId
          ,null stateOfEnrollment
          ,null pcpStartDate
          ,null region
          ,null ppoNetworkId
          ,null secondaryNetworkId
          ,null tpa
          ,null filler
          ,pd.enterprisePatientId
  from Patient.EligibilityFact ef
 cross apply maxId mx
  join Patient.PatientDim pd on ef.clientId = pd.clientId
                            and ef.patientId = pd.patientId
"						    and pd.patientActiveFlag = 1 "
  left join EdmLib.Mapping rel on pd.relationshipCode = rel.outValue
                              and rel.name = 'LAS_VEGAS_RELATION_CODE'
  left join Reference.GroupPolicy gp on ef.groupPolicyId = gp.groupPolicyId
  left join Reference.Plans pl on ef.benefitPlanId = pl.plansId
  left join EdmStage.LasVegas_Member s on pd.patientPrimaryNumber = s.policyNumber + right(s.memberId, 2)
 where ef.clientId = 51
   and ef.benefitPlanEndDate > dateadd(month, 6, sysdatetime())
   and ef.eligibilityFactActiveFlag = 1 
   and ef.recordTypeId = 28 
"   and s.stageId is null; 	1	2020-06-01 10:07:11.0666667	mssql"
"189	32	INSERT_INTO_HMP_MemberEnterpriseTemp	truncate table EdmStage.HMP_MemberEnterpriseTemp ;"
 insert into EdmStage.HMP_MemberEnterpriseTemp 
      (stageId
      ,patientPrimaryNumber
      ,enterprisePatientId
      ,activeInd)
select max(stageId) stageId
      ,isnull(activeRecipId,recipId) patientPrimaryNumber
      ,recipId enterprisePatientId
      ,activeInd
  from <tableName> t
 group by recipId
         ,activeRecipId
"		 ,activeInd ; "
"truncate table EdmStage.HMP_MemberEnterpriseFinal ;	1	2020-06-03 00:00:00.0000000	mssql"
"190	32	INSERT_INTO_HMP_MemberEnterpriseFinal	truncate table EdmStage.HMP_MemberEnterpriseFinal ;"

with memberLinkList as
    (select 0 lvl
"	       ,stageId parentStageId"
"		   ,stageId"
           ,enterprisePatientId origEnterprisePatientId
"		   ,enterprisePatientId currEnterprisePatientId"
           ,patientPrimaryNumber
"		   ,activeInd"
       from EdmStage.HMP_MemberEnterpriseTemp
      where activeInd = 'N'
      union all
     select p.lvl + 1 lvl
"	       ,p.stageId parentStageId"
"	       ,c.stageId"
"		   ,p.origEnterprisePatientId"
           ,c.enterprisePatientId
           ,c.patientPrimaryNumber
"		   ,c.activeInd"
       from EdmStage.HMP_MemberEnterpriseTemp c
       join memberLinkList p on p.origEnterprisePatientId = c.patientPrimaryNumber
"	                        and p.patientPrimaryNumber <> c.patientPrimaryNumber)"
insert into EdmStage.HMP_MemberEnterpriseFinal 
      (stageId
"	  ,parentStageId"
"	  ,lvl"
"	  ,origEnterprisePatientId"
"	  ,currEnterprisePatientId"
"	  ,origPatientPrimaryNumber"
"	  ,currPatientPrimaryNumber"
"	  ,activeInd)"
select stageId
      ,parentStageId
      ,lvl
      ,origEnterprisePatientId
"	  ,currEnterprisePatientId"
      ,case activeInd when 'Y' then patientPrimaryNumber
"	        else currEnterprisePatientId"
"	   end origPatientPrimaryNumber"
"	  ,patientPrimaryNumber currPatientPrimaryNumber"
"	  ,activeInd"
"  from memberLinkList ; 	1	2020-06-03 00:00:00.0000000	mssql"
"191	32	MERGE_INTO_HMP_Member	if exists (select origPatientPrimaryNumber, count(distinct currEnterprisePatientId)"
             from EdmStage.HMP_MemberEnterpriseFinal
            group by origPatientPrimaryNumber 
            having count(distinct currEnterprisePatientId) > 1)
"	select convert(int, 'EdmStage.HMP_MemberEnterpriseFinal has bad data');"

merge into <tableName> m 
using (select distinct origPatientPrimaryNumber, currEnterprisePatientId from EdmStage.HMP_MemberEnterpriseFinal) u 
on m.recipId = u.origPatientPrimaryNumber 
"when matched then update set m.enterprisePatientId = 'HMP' + u.currEnterprisePatientId ; 	1	2020-06-03 00:00:00.0000000	mssql"
"192	32	UPDATE_HMP_Member	update <tableName>"
set enterprisePatientId = 'HMP' + isnull(case when activeInd = 'N' then activeRecipId end, recipId) 
"where enterprisePatientId is null ; 	1	2020-06-03 00:00:00.0000000	mssql"
"193	32	MERGE_HMP_End_Deceased_Member_Plans	with deceasedPlanList as"
     (select h.stageId
            ,p.patientId
            ,e.fileRequestId
            ,e.benefitPlanId
            ,pl.planNumber benefitPlanNumber
            ,convert(varchar(10), e.benefitPlanStartDate, 112) benefitPlanStartDate
            ,convert(varchar(10), convert(datetime2, deathDate, 111), 112) benefitPlanEndDate
            ,e.fileRequestId currFileRequestId
            ,max(e.fileRequestId) over(partition by p.patientId) lastFileRequestId
            ,rank() over(partition by p.patientId, e.benefitPlanId, e.benefitPlanStartDate order by e.fileRequestId desc, e.headerStandardRowNumber, e.detailStandardRowNumber) rnk
        from <tableName> h
        join Patient.PatientDim p on h.enterprisePatientId = p.enterprisePatientId
                                 and p.clientId = 32
                                 and p.patientActiveFlag = 1
        join Patient.EligibilityFact e on p.clientId = e.clientId
                                      and p.patientId = e.patientId
                                      and e.eligibilityFactActiveFlag = 1
                                      and e.groupPolicyId > 1
                                      and e.benefitPlanId > 1
"									  and e.benefitPlanId not in (7194, 7193, 4920) -- ignore the indicators that are loaded as plans"
                                      and (e.benefitPlanEndDate is null
                                        or try_convert(datetime2, deathDate, 111) < e.benefitPlanEndDate)
        join Reference.Plans pl on e.benefitPlanId = pl.plansId
       where isDate(deathDate) = 1),
        deceasedPlanListDenormalized as
        (select stageId
               ,patientId
               ,fileRequestId
               ,lead(benefitPlanNumber, 0) over(partition by stageId, patientId order by benefitPlanId) benefit1
               ,lead(benefitPlanStartDate, 0) over(partition by stageId, patientId order by benefitPlanId) startDate1
               ,lead(benefitPlanEndDate, 0) over(partition by stageId, patientId order by benefitPlanId) stopDate1
               ,lead(benefitPlanNumber, 1) over(partition by stageId, patientId order by benefitPlanId) benefit2
               ,lead(benefitPlanStartDate, 1) over(partition by stageId, patientId order by benefitPlanId) startDate2
               ,lead(benefitPlanEndDate, 1) over(partition by stageId, patientId order by benefitPlanId) stopDate2
               ,lead(benefitPlanNumber, 2) over(partition by stageId, patientId order by benefitPlanId) benefit3
               ,lead(benefitPlanStartDate, 2) over(partition by stageId, patientId order by benefitPlanId) startDate3
               ,lead(benefitPlanEndDate, 2) over(partition by stageId, patientId order by benefitPlanId) stopDate3
               ,lead(benefitPlanNumber, 3) over(partition by stageId, patientId order by benefitPlanId) benefit4
               ,lead(benefitPlanStartDate, 3) over(partition by stageId, patientId order by benefitPlanId) startDate4
               ,lead(benefitPlanEndDate, 3) over(partition by stageId, patientId order by benefitPlanId) stopDate4
               ,lead(benefitPlanNumber, 4) over(partition by stageId, patientId order by benefitPlanId) benefit5
               ,lead(benefitPlanStartDate, 4) over(partition by stageId, patientId order by benefitPlanId) startDate5
               ,lead(benefitPlanEndDate, 4) over(partition by stageId, patientId order by benefitPlanId) stopDate5
               ,lead(benefitPlanNumber, 5) over(partition by stageId, patientId order by benefitPlanId) benefit6
               ,lead(benefitPlanStartDate, 5) over(partition by stageId, patientId order by benefitPlanId) startDate6
               ,lead(benefitPlanEndDate, 5) over(partition by stageId, patientId order by benefitPlanId) stopDate6
               ,lead(benefitPlanNumber, 6) over(partition by stageId, patientId order by benefitPlanId) benefit7
               ,lead(benefitPlanStartDate, 6) over(partition by stageId, patientId order by benefitPlanId) startDate7
               ,lead(benefitPlanEndDate, 6) over(partition by stageId, patientId order by benefitPlanId) stopDate7
               ,lead(benefitPlanNumber, 7) over(partition by stageId, patientId order by benefitPlanId) benefit8
               ,lead(benefitPlanStartDate, 7) over(partition by stageId, patientId order by benefitPlanId) startDate8
               ,lead(benefitPlanEndDate, 7) over(partition by stageId, patientId order by benefitPlanId) stopDate8
               ,lead(benefitPlanNumber, 8) over(partition by stageId, patientId order by benefitPlanId) benefit9
               ,lead(benefitPlanStartDate, 8) over(partition by stageId, patientId order by benefitPlanId) startDate9
               ,lead(benefitPlanEndDate, 8) over(partition by stageId, patientId order by benefitPlanId) stopDate9
               ,lead(benefitPlanNumber, 9) over(partition by stageId, patientId order by benefitPlanId) benefit10
               ,lead(benefitPlanStartDate, 9) over(partition by stageId, patientId order by benefitPlanId) startDate10
               ,lead(benefitPlanEndDate, 9) over(partition by stageId, patientId order by benefitPlanId) stopDate10
               ,row_number() over(partition by stageId, patientId order by benefitPlanId) rn
       from deceasedPlanList
      where rnk = 1
        and currFileRequestId = lastFileRequestId)
merge into <tableName> m
using (
select *
         from deceasedPlanListDenormalized
        where rn = 1
"		) u"
   on m.stageId = u.stageId
 when matched then update set m.benefit1  = u.benefit1
                             ,m.benefit2  = u.benefit2
                             ,m.benefit3  = u.benefit3
                             ,m.benefit4  = u.benefit4
                             ,m.benefit5  = u.benefit5
                             ,m.benefit6  = u.benefit6
                             ,m.benefit7  = u.benefit7
                             ,m.benefit8  = u.benefit8
                             ,m.benefit9  = u.benefit9
                             ,m.benefit10 = u.benefit10
                             ,m.startDate1  = u.startDate1
                             ,m.startDate2  = u.startDate2
                             ,m.startDate3  = u.startDate3
                             ,m.startDate4  = u.startDate4
                             ,m.startDate5  = u.startDate5
                             ,m.startDate6  = u.startDate6
                             ,m.startDate7  = u.startDate7
                             ,m.startDate8  = u.startDate8
                             ,m.startDate9  = u.startDate9
                             ,m.startDate10 = u.startDate10
                             ,m.stopDate1  = u.stopDate1
                             ,m.stopDate2  = u.stopDate2
                             ,m.stopDate3  = u.stopDate3
                             ,m.stopDate4  = u.stopDate4
                             ,m.stopDate5  = u.stopDate5
                             ,m.stopDate6  = u.stopDate6
                             ,m.stopDate7  = u.stopDate7
                             ,m.stopDate8  = u.stopDate8
                             ,m.stopDate9  = u.stopDate9
"                             ,m.stopDate10 = u.stopDate10 ;	1	2020-06-03 00:00:00.0000000	mssql"
"194	32	MERGE_Monthly_Member	declare @fileRequestId bigint = :fileRequestId ;"

declare @partitionMapping
 table (clientModelName nvarchar(100)
       ,partitionSchemeName nvarchar(100)
       ,partitionFunctionName nvarchar(100)
       ,sourceTableName nvarchar(200)
       ,targetTableName nvarchar(200))

insert into @partitionMapping
values
 ('com.telligen.edm.web.client.hmp.model.HMPMember',  'HMPMemberMonthlyPscheme',  'HMPMemberMonthlyPfnc' , 'EdmStage.HMP_Member', 'EdmStage.HMP_MemberMonthly')
,('com.telligen.edm.web.client.hmp.model.HMPMember2', 'HMPMemberMonthly2Pscheme', 'HMPMemberMonthly2Pfnc', 'EdmStage.HMP_Member2', 'EdmStage.HMP_MemberMonthly2')
,('com.telligen.edm.web.client.hmp.model.HMPMember3', 'HMPMemberMonthly3Pscheme', 'HMPMemberMonthly3Pfnc', 'EdmStage.HMP_Member3', 'EdmStage.HMP_MemberMonthly3') ;

declare @partitionSchemeName nvarchar(100) ;
declare @partitionFunctionName nvarchar(100) ;
declare @sourceTableName nvarchar(200) ;
declare @targetTableName nvarchar(200) ;

select @partitionSchemeName = p.partitionSchemeName
      ,@partitionFunctionName = p.partitionFunctionName
          ,@sourceTableName = p.sourceTableName
          ,@targetTableName = p.targetTableName
  from EdmLib.FileRequest f
  join @partitionMapping p on f.clientModelName = p.clientModelName
 where fileRequestId = @fileRequestId ;

declare @partitionFunctionId bigint ;
declare @partitionValueCount int ;
select @partitionFunctionId = function_id
  from sys.partition_functions
 where name = @partitionFunctionName ;

select @partitionValueCount = count(*)
  from sys.partition_range_values
 where function_id = @partitionFunctionId
   and value = @fileRequestId ;

if @partitionFunctionId is null
        throw 51000, 'Partition function/scheme does not exist.', 16 ;

if @partitionValueCount = 0
begin

        declare @alterScheme nvarchar(4000) = 'alter partition scheme [' + @partitionSchemeName + '] next used [PRIMARY] ' ;
        declare @alterFunction nvarchar(4000) = 'alter partition function ' + @partitionFunctionName + '() split range(' + convert(nvarchar(32), @fileRequestId) + ')' ;

        exec sp_sqlexec @alterScheme ;
        exec sp_sqlexec @alterFunction ;

end ;

declare @partitionNumber int ;
declare @getPartitionNumber nvarchar(500) = 'select @out_partitionNumber = $partition.'+ @partitionFunctionName + '(' + convert(varchar(32), @fileRequestId) + ')' ;
exec sp_executesql @getPartitionNumber, N'@out_partitionNumber int OUTPUT', @out_partitionNumber = @partitionNumber OUTPUT ;


declare @truncateSQL nvarchar(4000) = 'truncate table ' + @targetTableName + ' with (partitions (' + convert(varchar(32), @partitionNumber)  + '))'
declare @archiveSQL nvarchar(4000) = 'insert into ' + @targetTableName + ' select * from ' + @sourceTableName ;

exec sp_sqlexec @truncateSQL ;
"exec sp_sqlexec @archiveSQL ;	1	2020-06-08 21:53:46.4520234	mssql"
"195	0	BULK_MPI-INSERT_STAGE_DEDUP_SQL	-- issues will arise when similar members are adjacent"
#NAME?
insert into MPI.BulkRequestStageDedup
select BulkRequestStageId 
"	  ,ClientIdentifier "
"	  ,OriginalPatientIdentifier "
"	  ,CurrentPatientIdentifier "
"	  ,PolicyNumber "
"	  ,FirstName "
"	  ,MiddleName "
"	  ,LastName "
"	  ,SSN "
"	  ,DOB "
"	  ,Gender "
"	  ,AddressLine1 "
"	  ,AddressLine2 "
"	  ,City "
"	  ,State "
"	  ,ZIP "
"	  ,Telephone "
"	  ,MPIID "
"	  ,RN"
      ,orderRN + case when orderRN - lag(orderRN, 1) over(partition by LastName order by ssn, dob, AddressLine1, BulkRequestStageId) < 20
"	   then case when bulkRequestStageId < 100 then bulkRequestStageId * 10 else bulkRequestStageId * 2 end else 0 end orderRN"
      --,orderRN - lag(orderRN, 1) over(partition by LastName order by ssn, dob, AddressLine1, BulkRequestStageId) orderRN_diff
"	  --,case when orderRN - lag(orderRN, 1) over(partition by LastName order by ssn, dob, AddressLine1, BulkRequestStageId)  < 20 then 1 else 0 end isTooClose"
"	  --,case when orderRN - lag(orderRN, 1) over(partition by LastName order by ssn, dob, AddressLine1, BulkRequestStageId) < 20"
"	  -- then case when bulkRequestStageId < 100 then bulkRequestStageId * 10 else bulkRequestStageId * 2 end else 0 end orderRN_relocation"
  from (
select x.* 
      ,rank() over(partition by left(LastName, 1) order by ssn, dob, AddressLine1, BulkRequestStageId) OrderRN 
  from (select BulkRequestStageId 
"	          ,ClientIdentifier "
"	          ,OriginalPatientIdentifier "
"	          ,CurrentPatientIdentifier "
"	          ,PolicyNumber "
"	          ,FirstName "
"	          ,MiddleName "
"	          ,LastName "
"	          ,SSN "
"	          ,DOB "
"	          ,Gender "
"	          ,AddressLine1 "
"	          ,AddressLine2 "
"	          ,City "
"	          ,State "
"	          ,ZIP "
"	          ,Telephone "
"			  ,null MPIID "
"	          ,rank() over(partition by ClientIdentifier "
"	                                   ,OriginalPatientIdentifier "
"	                                   ,CurrentPatientIdentifier "
"	                                   ,PolicyNumber"
"	                                   ,FirstName "
"	                                   ,MiddleName "
"	                                   ,LastName "
"	                                   ,SSN "
"	                                   ,DOB "
"	                                   ,Gender "
"	                                   ,AddressLine1 "
"	                                   ,AddressLine2 "
"	                                   ,City "
"	                                   ,State "
"	                                   ,ZIP "
"	                                   ,Telephone "
"	          			   order by BulkRequestStageId) RN "
"          from MPI.BulkRequestStage ) x) x0	1	2020-06-12 15:03:31.0380171	mssql"
"196	38	MPI-UPDATE_MANUAL_MEMBERS	declare @fileRequestId bigint = :fileRequestId ;"

merge into Patient.PatientDim m
using EdmStage.MD_MPI_Stage u
   on m.clientId = 38
  and m.patientId = u.patientId
  and u.recordTypeId in (11, 13, 36)
" when matched then update set m.recordTypeId = 28 ; 	1	2020-06-16 10:23:58.2427783	mssql"
"197	39	PROVIDER_HISTORY_FILE_COUNT	declare @fileRequestId bigint = :fileRequestId ;"
declare @fileNamePart nvarchar(100) = :fileNamePart ;

select count(*)
  from EdmLib.FileRequest
 where clientId = 39
   and fileName like '%' + @fileNamePart + '%'
   and fileType = 'PROVIDER-HISTORY'
   and completeFlag = 1
"   and purged is null	1	2020-06-26 11:22:41.5656060	mssql"
"198	34	RETIRE_MEMBER_EXCLUSION	declare @fileRequestId bigint = :fileRequestId ;"
declare @memberExclusionTypeId int = :memberExclusionTypeId ;

declare @deactivateDate date = convert(varchar(4), year(sysdatetime())-1) + '-12-31' ;

-- select @deactivateDate ;

declare @maxStageId bigint ;

select @maxStageId = max(stageId)
  from EdmStage.COC_MemberExclusion_TCOYH ;

merge into Reference.MemberExclusion m
using (select me.*
         from Reference.MemberExclusion me
         join EdmLib.FileRequest fr on fr.fileRequestId = @fileRequestId
                                   and me.clientId = fr.clientId
         join Patient.PatientDim pd on me.clientId = pd.clientId
                                   and me.patientId = pd.patientId
"   	    						and pd.patientActiveFlag = 1"
         left join EdmStage.COC_MemberExclusion_TCOYH t on pd.enterprisePatientId = t.enterprisePatientId
        where fr.fileRequestId = @fileRequestId
          and t.stageId is null) u
   on m.clientId = u.clientId
  and m.memberExclusionId = u.memberExclusionId 
 when matched then update set m.deactivateDate = case when m.effectiveDate > @deactivateDate then convert(date, sysdatetime()) else @deactivateDate end
                             ,m.updateDateTime = sysdatetime()
"							 ,m.fileRequestId = @fileRequestId;"
"	1	2020-07-13 14:10:17.6566667	mssql"
"199	34	INSERT_MEMBER_EXCLUSION_HISTORY	declare @fileRequestId bigint = :fileRequestId ;"
declare @memberExclusionTypeId int = :memberExclusionTypeId ;

insert into EdmStage.COC_MemberExclusion_TCOYH_History
select *
"  from EdmStage.COC_MemberExclusion_TCOYH ; 	1	2020-07-13 14:18:15.5966667	mssql"
"200	34	MERGE_HWB_MEMBER_EXCLUSION	declare @fileRequestId bigint = :fileRequestId ;"
declare @memberExclusionTypeId int = :memberExclusionTypeId ;

insert into EdmStage.HWB_MemberExclusion
select row_number() over(partition by 1 order by memberExclusionId) stageId
      ,@fileRequestId fileRequestId
"	  ,pd.clientId"
"	  ,pd.patientPrimaryNumber"
"	  ,pd.enterprisePatientId"
"	  ,me.memberExclusionTypeId"
"	  ,met.memberExclusionTypeCode"
"	  ,me.effectiveDate"
"	  ,me.deactivateDate"
"	  ,me.activeFlag"
"	  ,me.createDateTime"
"	  ,me.updateDateTime"
  from Reference.MemberExclusion me
  join Patient.PatientDim pd on me.clientId = pd.clientId
                            and me.patientId = pd.patientId
  join Reference.MemberExclusionType met on me.memberExclusionTypeId = met.memberExclusionTypeId
 where me.fileRequestId = @fileRequestId
   and me.memberExclusionTypeId = @memberExclusionTypeId ;
"	1	2020-07-14 11:52:38.5005531	mssql"
"201	34	MERGE_MEMBER_EXCLUSION	declare @fileRequestId bigint = :fileRequestId ;"
declare @memberExclusionTypeId int = :memberExclusionTypeId ;

declare @totalRecordCount int ;

merge into EdmStage.COC_MemberExclusion_TCOYH m
using (select t.stageId
             ,t.fileRequestId
"       	     ,pd.patientPrimaryNumber"
"       	     ,pd.subscriberPrimaryNumber"
"       	     ,pd.enterpriseSubscriberId"
         from EdmStage.COC_MemberExclusion_TCOYH t
         left join Patient.PatientDim pd on t.enterprisePatientId = pd.enterprisePatientId
                                        and pd.clientId = 34
"       							        and pd.patientActiveFlag = 1) u"
   on m.stageId = u.stageId
  and m.fileRequestId = u.fileRequestId
 when matched then update set m.patientPrimaryNumber = u.patientPrimaryNumber
                             ,m.subscriberPrimaryNumber = u.subscriberPrimaryNumber
"							 ,m.enterpriseSubscriberId = u.enterpriseSubscriberId ; "

set @totalRecordCount = @@rowcount ;

drop table if exists ##coc_tcoyh_memberExclusionTemp ;

select t.*
      ,pd.clientId
      ,pd.patientId
"	  ,me.memberExclusionId"
"	  ,me.effectiveDate"
"	  ,me.deactivateDate"
"	  ,me.fileRequestId origFileRequestId"
  into ##coc_tcoyh_memberExclusionTemp
  from EdmStage.COC_MemberExclusion_TCOYH t
  join Patient.PatientDim pd on t.enterprisePatientId = pd.enterprisePatientId
                            and pd.clientId = 34
" 						    and pd.patientActiveFlag = 1"
  left join Reference.MemberExclusion me on pd.clientId = me.clientId
                                        and pd.patientId = me.patientId
"										and me.memberExclusionTypeId = @memberExclusionTypeId"
                                        and me.activeFlag = 1 ;

if @totalRecordCount <> @@rowcount
"	select convert(int, 'Merge mismatch.') ;"

declare @effectiveDate date = convert(varchar(4), year(sysdatetime())) + '-01-01' ;

merge into Reference.MemberExclusion m
using ##coc_tcoyh_memberExclusionTemp u
   on m.clientId = u.clientId
  and m.memberExclusionId = u.memberExclusionId
 when matched then update set m.fileRequestId = u.fileRequestId
                             ,m.effectiveDate = coalesce(u.effectiveDate, @effectiveDate)
 when not matched then insert (clientId
                              ,patientId
"							  ,patientPrimaryNumber"
"							  ,memberExclusionTypeId"
"							  ,activeFlag"
"							  ,effectiveDate"
"							  ,createDateTime"
"							  ,fileRequestId)"
                       values (u.clientId
                              ,u.patientId
"							  ,u.patientPrimaryNumber"
"							  ,@memberExclusionTypeId"
"							  ,1"
"							  ,@effectiveDate"
"							  ,sysdatetime()"
"							  ,u.fileRequestId) ;"
"	1	2020-07-13 17:16:36.0733333	mssql"
"202	34	MEMBER_EXCLUSION-MPI-LOAD	insert into MPI.BulkRequestStage "
       (BulkRequestStageId 
       ,ClientIdentifier 
       ,OriginalPatientIdentifier 
       ,CurrentPatientIdentifier 
       ,PolicyNumber 
       ,FirstName 
       ,MiddleName 
       ,LastName 
       ,SSN 
       ,DOB 
       ,Gender 
       ,AddressLine1 
       ,AddressLine2 
       ,City 
       ,State 
       ,ZIP 
       ,Telephone)
select m.stageId BulkRequestStageId
"	  ,c.clientCode ClientIdentifier "
      ,m.memberUniqueIdentifier OriginalPatientIdentifier 
"	  ,null CurrentPatientIdentifier "
"	  ,m.memberUniqueIdentifier PolicyNumber "
"	  ,isnull(m.individualFirstName, 'UNKNOWN') FirstName "
"	  ,null MiddleName "
"	  ,isnull(m.individualLastName, 'UNKNOWN') LastName "
"	  ,null SSN"
"	  ,case when year(try_convert(datetime2, m.dateOfBirth)) > 1800 then right(m.dateOfBirth, 4) +'-'+ left(m.dateOfBirth, 2) +'-' + left(right(m.dateOfBirth, 7), 2) + ' 00:00:00' end  DOB "
"	  ,isnull(left(m.gender, 1), 'U') Gender "
"	  ,m.addressLine1 AddressLine1 "
"	  ,m.addressLine2 AddressLine2 "
"	  ,m.city City "
"	  ,m.state State "
"	  ,m.zipCode ZIP "
"	  ,null Telephone"
  from EdmStage.COC_MemberExclusion_TCOYH m
  join EdmLib.FileRequest fr on fr.fileRequestId = :fileRequestId
  join Reference.Client c on fr.clientId = c.clientId
" where m.fileRequestId = :fileRequestId ;  	1	2020-07-13 16:05:57.6200000	mssql"
"203	34	MEMBER_EXCLUSION-MPI-MERGE	merge into <tableSchema>.<tableName> m"
using (select mc.fileRequestId
             ,mc.stageId
"       	     ,d.MPIID"
         from <tableSchema>.<tableName> mc
         join MPI.BulkRequestStageDedup d on mc.stageId = d.BulkRequestStageId
                                         and d.MPIID is not null
        where mc.enterprisePatientId is null
          and mc.fileRequestId = :fileRequestId) u
   on m.fileRequestId = u.fileRequestId
  and m.stageId = u.stageId
" when matched then update set m.enterprisePatientId = u.MPIID;  	1	2020-07-13 16:08:56.2566667	mssql"
"204	34	MEMBER_EXCLUSION-MPI-MISSING_MPI_COUNT	select count(*) from EdmStage.COC_MemberExclusion_TCOYH where enterprisePatientId is null  	1	2020-07-13 16:10:37.2766667	mssql"
"205	34	MEMBER_EXCLUSION-MPI-TOTAL_MPI_COUNT	select count(*) from EdmStage.COC_MemberExclusion_TCOYH   	1	2020-07-13 16:10:48.4900000	mssql"
"206	34	MEMBER_EXCLUSION-MPI-DUPLICATE_MPI_COUNT	select count(*) from EdmStage.COC_MemberExclusion_TCOYH where 1 = 2 	1	2020-07-13 16:11:00.0200000	mssql"
"207	32	CARE_ANALYZER-PHARMACY-CLIENT_SPECIFIC-FINAL_ACTION-STAGE_PREP-BY_FILE_REQUEST_ASC	declare @fileRequestId bigint = :fileRequestId ;"

insert into HMP.PharmacyClaimControlNumberList
"		select payerClaimControlNumber, adjustedClaimControlNumber, @fileRequestId, count(*) lineCount"
"		  from EdmStandard.PharmacyClaim r"
"		 where r.fileRequestId = @fileRequestId"
"		 group by payerClaimControlNumber, adjustedClaimControlNumber"
"		option (maxdop 4);	1	2020-08-03 12:27:53.4066667	mssql"
"208	32	CARE_ANALYZER-PHARMACY-CLIENT_SPECIFIC-FINAL_ACTION-STAGE_CREATE_INDEX	declare @fileRequestId bigint = :fileRequestId ;"

if (select count(*) from sys.indexes where object_id = object_id('HMP.PharmacyClaimControlNumberList') and name = 'PharmacyClaimControlNumberListIdx1') = 0
"	create index PharmacyClaimControlNumberListIdx1"
"		on HMP.PharmacyClaimControlNumberList (adjustedClaimControlNumber, payerClaimControlNumber)"
"		include (fileRequestId, lineCount)"
"		with (data_compression=page); 	1	2020-08-03 12:29:28.0366667	mssql"
"209	32	CARE_ANALYZER-PHARMACY-CLIENT_SPECIFIC-FINAL_ACTION-RUN_LOAD	declare @fileRequestId bigint = :fileRequestId ;"

drop table if exists HMP.PharmacyClaimControlNumberListFinal;

"	with final as "
"		 (select 0 lvl, payerClaimControlNumber, adjustedClaimControlNumber, payerClaimControlNumber originalClaimNumber, lineCount, fileRequestId"
"			from HMP.PharmacyClaimControlNumberList"
"		   where adjustedClaimControlNumber is null"
"		  union all "
"		  select lvl + 1, r.payerClaimControlNumber, r.adjustedClaimControlNumber, f.payerClaimControlNumber, r.lineCount, r.fileRequestId"
"			from HMP.PharmacyClaimControlNumberList r"
"			join final f on f.payerClaimControlNumber = r.adjustedClaimControlNumber)"
"	select f.*"
"		  ,case when f.lvl = max(f.lvl) over(partition by originalClaimnumber) then 1 else 0 end isFinal"
"	  into HMP.PharmacyClaimControlNumberListFinal"
"	  from final f;	 	1	2020-08-03 12:30:40.5466667	mssql"
"210	32	CARE_ANALYZER-PHARMACY-CLIENT_SPECIFIC-FINAL_ACTION-CREATE_INDEX_1	declare @fileRequestId bigint = :fileRequestId ;"

if (select count(*) from sys.indexes where name = 'PharmacyClaimControlNumberListFinalIdx1' and object_id = object_id('HMP.PharmacyClaimControlNumberListFinal')) = 0
"	create index PharmacyClaimControlNumberListFinalIdx1 "
"	on HMP.PharmacyClaimControlNumberListFinal (isFinal) "
    include (fileRequestId)
"	with(data_compression=page);	1	2020-08-03 12:33:33.4166667	mssql"
"211	32	CARE_ANALYZER-PHARMACY-CLIENT_SPECIFIC-FINAL_ACTION-CREATE_INDEX_2	declare @fileRequestId bigint = :fileRequestId ;"

if (select count(*) from sys.indexes where name = 'PharmacyClaimControlNumberListFinalIdx2' and object_id = object_id('HMP.PharmacyClaimControlNumberListFinal')) = 0
"	create index PharmacyClaimControlNumberListFinalIdx2"
"	on HMP.PharmacyClaimControlNumberListFinal (isFinal, payerClaimControlNumber, fileRequestId) "
    include (lineCount)
"	with(data_compression=page);	1	2020-08-03 12:33:43.4300000	mssql"
"212	32	CARE_ANALYZER-PHARMACY-CLIENT_SPECIFIC-FINAL_ACTION-CREATE_FINAL_TABLE	declare @fileRequestId bigint = :fileRequestId ;"

drop table if exists HMP.PharmacyClaim;
drop sequence if exists HMP.PharmacyClaimSEQ;

if object_id('HMP.PharmacyClaim') is null
begin
"	create sequence HMP.PharmacyClaimSEQ start with 1;"

"	create table HMP.PharmacyClaim"
    (pharmacyClaimId bigint NOT NULL default next value for HMP.PharmacyClaimSEQ
    ,clientId int
    ,payerClaimControlNumber nvarchar(255)
    ,claimStatusId int
    ,claimStatusCode nvarchar(255)
    ,adjustedClaimControlNumber nvarchar(255)
    ,slAssignedNumber nvarchar(255)
    ,pharmacyFacilityPrimaryNumber nvarchar(255)
    ,pharmacyFacilityLocationNumber nvarchar(255)
    ,patientPrimaryNumber nvarchar(255)
    ,cost numeric(10, 2)
    ,NDC nvarchar(255)
"	,NdcId bigint"
    ,daysSupply smallint
    ,firstDateOfService datetime2(7)
"	,prescribingPhysicianNPI nvarchar(10)"
"	,metricQuantity decimal(10, 2)"
    ,fileRequestId bigint NOT NULL
"	,constraint PharmacyClaimPK primary key clustered (pharmacyClaimId))"
"	with (data_compression = page);"
"end; 	1	2020-08-03 12:36:18.6233333	mssql"
"213	32	CARE_ANALYZER-PHARMACY-CLIENT_SPECIFIC-FINAL_ACTION-RUN_FINAL-BY_FILE_REQUEST_ID_DESC	declare @fileRequestId bigint = :fileRequestId ;"

insert
"	  into HMP.PharmacyClaim"
"	      (clientId"
"		  ,payerClaimControlNumber"
"		  ,claimStatusId"
"		  ,claimStatusCode"
"		  ,adjustedClaimControlNumber"
"		  ,slAssignedNumber"
"		  ,pharmacyFacilityPrimaryNumber"
"		  ,pharmacyFacilityLocationNumber"
"		  ,patientPrimaryNumber "
"		  ,cost"
"		  ,NDC"
"		  ,NdcId"
"		  ,daysSupply"
"		  ,firstDateOfService"
"		  ,prescribingPhysicianNPI"
"		  ,metricQuantity"
"		  ,fileRequestId)"
"	select r.clientId"
"		  ,r.payerClaimControlNumber"
"		  ,r.claimStatusId"
"		  ,r.claimStatusCode"
"		  ,r.adjustedClaimControlNumber"
"		  ,r.slAssignedNumber"
"		  ,r.pharmacyFacilityPrimaryNumber"
"		  ,r.pharmacyFacilityLocationNumber"
"		  ,r.patientPrimaryNumber		 "
"		  ,cast(try_cast(r.totalPaidAmount as money) / f.lineCount as numeric(10, 2)) cost   -- either divide cost evenly or only set 1st line?"
"		  ,r.slProductServiceCode NDC "
"		  ,r.slProductServiceNdcId NdcId"
"		  ,try_cast(r.slPrescriptionDaysSupply as smallint) daysSupply"
"		  ,try_convert(datetime2, r.firstDateOfService, 121) firstDateOfService"
"		  ,r.slPrescriberProviderNpi prescribingPhysicianNPI"
"		  ,convert(decimal(10,2), left(r.slPrescriptionDispensedQuantity, 10) + '.' + right(r.slPrescriptionDispensedQuantity, 2)) metricQuantity"
"		  ,r.fileRequestId"
"	  from EdmStandard.PharmacyClaimReference r"
"	  join HMP.PharmacyClaimControlNumberListFinal f on /*r.fileRequestId = f.fileRequestId"
"											and*/ r.payerClaimControlNumber = f.payerClaimControlNumber"
"											and f.isFinal = 1"
"	  left join HMP.PharmacyClaim pcs on r.payerClaimControlNumber = pcs.payerClaimControlNumber"
"	 where r.fileRequestId = @fileRequestId"
"	   and pcs.pharmacyClaimId is null; 	1	2020-08-03 12:38:23.6866667	mssql"
"214	32	CARE_ANALYZER-PHARMACY-CLIENT_SPECIFIC-FINAL_ACTION-POST_PROCESS-01-STAGE_NDC	declare @fileRequestId bigint = :fileRequestId ;"

drop table if exists ##ndc_dedup ;
if object_id('tempdb.dbo.##ndc_dedup') is null
select *
  into ##ndc_dedup
  from (select *
              ,rank() over(partition by ndc_upc_hri order by fileRequestId desc) rn
          from EdmStage.MediSpan_NDC_History) x
 where x.rn = 1 ;

drop table if exists ##ndc_name_dedup ;
if object_id('tempdb.dbo.##ndc_name_dedup') is null
select *
  into ##ndc_name_dedup
  from (select *
              ,rank() over(partition by drugDescriptorIdentifier, genericProductIdentifier, knowledgeBaseDrugCode order by fileRequestId desc) rn
          from EdmStage.MediSpan_NDC_Name_History) x
 where x.rn = 1 ;

drop table if exists ##ndc_tcgpi_dedup ;
if object_id('tempdb.dbo.##ndc_tcgpi_dedup') is null
select *
  into ##ndc_tcgpi_dedup
  from (select *
              ,rank() over(partition by tcGpiKey, recordType, tcLevelCode order by fileRequestId desc) rn
          from EdmStage.MediSpan_NDC_TCGPI_History) x
 where x.rn = 1;

drop table if exists ##ndc_final ;
if object_id('##ndc_final') is null
select g2.tcGpiName drugGroupName
"	  ,g2.tranCode drugGroupTransactionCode"
"	  ,left(g.TcGpiKey, 4) drugClassCode"
"	  ,g4.tcGpiName drugClassName"
"	  ,g4.tranCode drugClassTransactionCode"
"	  ,left(g.TcGpiKey, 6) drugSubClassCode"
"	  ,g6.tcGpiName drugSubClassName"
"	  ,g6.tranCode drugSubClassTransactionCode"
"	  ,g.tcGpiKey"
"	  ,g.tcGpiName"
"	  ,g.recordType"
"	  ,g.tcLevelCode"
"	  ,g.tranCode tcGpiTransactionCode"
"	  ,n.drugDescriptorIdentifier"
"	  ,n.drugName"
"	  ,n.routeAdmin routeOfAdministration"
"	  ,n.dosageForm"
"	  ,n.strength"
"	  ,n.strengthUnitOfMeasure"
"	  ,case n.bioequ "
"	  	    when 'A' then 'Products in same GPI are equivalent'"
"	  	    when 'B' then 'Products in same GPI are not equivalent'"
"	  	    when 'C' then 'Products may or may not be equivalent'"
"	  	    when 'N' then 'Equivalency determination not available'"
"	  	    when 'U' then 'Undeterminable (obsolete)' "
"	   end bioequivalence"
"	  ,n.brandCode brandNameCode"
"	  ,n.nameSr nameSourceCode"
"	  ,n.tranCode drugNameTransactionCode"
"	  --"
"	  ,ndc.ndc_upc_hri ndcUpcHri "
"	  ,case ndc.idNoCode --IdNumberFormatCode "
"	  	    when 1 then '4-4-2'"
"	  	    when 2 then '5-3-2'"
"	  	    when 3 then '5-4-1'"
"	  	    when 4 then '4-6'"
"	  	    when 5 then '5-5'"
"	  	    when 6 then '5-4-2' "
"	   end idNumberFormat"
"	  ,case ndc.idNoCode --IdNumberFormatCode"
"	  	    when 4 then 'HRI'"
"	  	    when 5 then 'UPC or HRI'"
"	  	else 'NDC'"
"	   end idType"
"	  ,ndc.old_ndc_upc_hri oldNdcUpcHri"
"	  ,ndc.new_ndc_upc_hri newNdcUpcHri"
"	  ,ndc.mediSpanLabelerIdentifier"
"	  ,case ndc.nameCode -- NameTypeCode"
"	  	    when 'G' then 'Generic Name'"
"	  	    when 'T' then 'Trademarked Name'"
"	  	    when 'B' then 'Branded Generic Name' "
"	   end nameType"
"	  ,ndc.oldEffectiveDate"
"	  ,ndc.newEffectiveDate"
"	  ,ndc.nextSmNDCName nextSmallerNdcSuffixNumber"
"	  ,ndc.nextLgNDCName nextLargerNdcSuffixNumber"
"	  ,case ndc.itemSt --ItemStatusFlag"
"	  	    when 'A' then 'Active'"
"	  	    when 'I' then 'Inactive'"
"	  	    when 'O' then 'Override'"
"	  	    when 'Z' then 'Inactive Greater than 48 Months'"
"	   end itemStatus"
"	  ,ndc.tranCode ndcTransactionCode"
  into ##ndc_final
  from ##ndc_dedup ndc
  join ##ndc_name_dedup n on ndc.drugDescriptorIdentifier = n.drugDescriptorIdentifier
  join ##ndc_tcgpi_dedup g on n.genericProductIdentifier = g.TcGpiKey
  join ##ndc_tcgpi_dedup g2 on g2.tcLevelCode = '02' and left(g.tcGpiKey, 2) = g2.tcGpiKey
  join ##ndc_tcgpi_dedup g4 on g4.tcLevelCode = '04' and left(g.tcGpiKey, 4) = g4.tcGpiKey
  join ##ndc_tcgpi_dedup g6 on g6.tcLevelCode = '06' and left(g.tcGpiKey, 6) = g6.tcGpiKey ; 
  
 drop table if exists HMP.NDC_High_PrescriberLookup ;

if object_id('HMP.NDC_High_PrescriberLookup') is null
select 'Opioid' src
      ,*
  into HMP.NDC_High_PrescriberLookup
  from ##ndc_final
    -- Opioids
 where drugGroupName = '*ANALGESICS - OPIOID*' 
   and drugName in
('Abstral'
,'Acetaminophen-Codeine'
,'Acetaminophen-Codeine #2'
,'Acetaminophen-Codeine #3'
,'Acetaminophen-Codeine #4'
,'Actiq'
,'Apadaz'
,'APAP-Caff-Dihydrocodeine'
,'Arymo ER'
,'Ascomp-Codeine'
,'Aspirin-Caff-Dihydrocodeine'
,'AVINza'
,'Benzhydrocodone-Acetaminophen'
,'Buprenorphine'
,'Butalbital Compound/Codeine'
,'Butalbital-APAP-Caff-Cod'
,'Butalbital-ASA-Caff-Codeine'
,'Butorphanol Tartrate'
,'Butrans'
,'Capital/Codeine'
,'Codeine Sulfate'
,'Co-Gesic'
,'ConZip'
,'Demerol'
,'Dilaudid'
,'Dolophine'
,'Dsuvia'
,'Duragesic-100'
,'Duragesic-12'
,'Duragesic-25'
,'Duragesic-50'
,'Duragesic-75'
,'Dvorah'
,'Embeda'
,'Endocet'
,'Endodan'
,'Exalgo'
,'fentaNYL'
,'fentaNYL Citrate'
,'Fentora'
,'Fioricet/Codeine'
,'Fiorinal/Codeine #3'
,'Hycet'
,'HYDROcodone Bitartrate ER'
,'HYDROcodone-Acetaminophen'
,'Hydrocodone-Ibuprofen'
,'Hydrogesic'
,'HYDROmorphone HCl'
,'HYDROmorphone HCl ER'
,'Hysingla ER'
,'Ibudone'
,'Ionsys'
,'Kadian'
,'Lazanda'
,'Levorphanol Tartrate'
,'Liquicet'
,'Lorcet'
,'Lorcet HD'
,'Lorcet Plus'
,'Lortab'
,'Magnacet'
,'Meperidine HCl'
,'Meperidine-Promethazine'
,'Methadone HCl'
,'Methadone HCl Intensol'
,'Methadose'
,'Methadose Sugar-Free'
,'MorphaBond ER'
,'Morphine Sulfate'
,'Morphine Sulfate (Concentrate)'
,'Morphine Sulfate ER'
,'Morphine Sulfate ER Beads'
,'MS Contin'
,'Nalocet'
,'Norco'
,'Nucynta'
,'Nucynta ER'
,'Opana'
,'Opana ER'
,'Oxaydo'
,'oxyCODONE HCl'
,'oxyCODONE HCl ER'
,'Oxycodone-Acetaminophen'
,'oxyCODONE-Aspirin'
,'oxyCODONE-Ibuprofen'
,'OxyCONTIN'
,'oxyMORphone HCl'
,'oxyMORphone HCl ER'
,'Panlor'
,'Pentazocine-Acetaminophen'
,'Pentazocine-Naloxone HCl'
,'Percocet'
,'Primlev'
,'Reprexain'
,'Roxicet'
,'Roxicodone'
,'RoxyBond'
,'Stagesic'
,'Subsys'
,'Synalgos-DC'
,'Synapryn FusePaq'
,'Theracodeine-300'
,'Theracodophen-325'
,'Theracodophen-650'
,'Theracodophen-750'
,'Theracodophen-Low-90'
,'Theratramadol-60'
,'Theratramadol-90'
,'traMADol HCl'
,'traMADol HCl ER'
,'traMADol HCl ER (Biphasic)'
,'traMADol-Acetaminophen'
,'Trezix'
,'Tylenol with Codeine #3'
,'Tylenol with Codeine #4'
,'Ultracet'
,'Ultram'
,'Ultram ER'
,'Verdrocet'
,'Vicodin'
,'Vicodin ES'
,'Vicodin HP'
,'Vicoprofen'
,'Xartemis XR'
,'Xodol'
,'Xolox'
,'Xtampza ER'
,'Xylon'
,'Zamicet'
,'Zohydro ER'
,'Zydone')
union all
select 'Gapepentin & Pregabalin' src
      ,*
  from ##ndc_final
 where drugGroupName in ('*ANTICONVULSANTS*', '*PSYCHOTHERAPEUTIC AND NEUROLOGICAL AGENTS - MISC.*')
   and (tcGpiName like '%Gabapentin%' or tcGpiName like '%Pregabalin%')
union all
select 'Benzodiazepine Hypnotic' src
      ,*
  from ##ndc_final
 where drugGroupName in ('*ANTIANXIETY AGENTS*', '*ANTICONVULSANTS*', '*HYPNOTICS/SEDATIVES/SLEEP DISORDER AGENTS*')
   and (drugSubClassName like '%Benzodiazepine%' or drugSubClassName = '*Hypnotic Combinations***')
   and drugName in 
('ALPRAZolam'
,'ALPRAZolam ER'
,'ALPRAZolam Intensol'
,'ALPRAZolam XR'
,'Ativan'
,'chlordiazePOXIDE HCl'
,'cloBAZam'
,'clonazePAM'
,'Clorazepate Dipotassium'
,'Diastat AcuDial'
,'Diastat Pediatric'
,'diazePAM'
,'diazePAM Intensol'
,'Doral'
,'Estazolam'
,'Flurazepam HCl'
,'Gabavale-5'
,'Gabazolamine'
,'Gabazolamine-0.5'
,'Halcion'
,'KlonoPIN'
,'LORazepam'
,'LORazepam Intensol'
,'Midazolam HCl'
,'Midazolam HCl (PF)'
,'Midazolam+SyrSpend SF'
,'Midazolam-Ketamine-Ondansetron'
,'MKO Melt Dose Pack'
,'Nayzilam'
,'Onfi'
,'Oxazepam'
,'Quazepam'
,'Restoril'
,'Sentrazolam AM 0.25'
,'Strazepam'
,'Sympazan'
,'Temazepam'
,'Tranxene-T'
,'Triazolam'
,'Valium'
,'Xanax'
",'Xanax XR') ; 	1	2020-08-03 12:45:48.0200000	mssql"
"215	32	CARE_ANALYZER-PHARMACY-CLIENT_SPECIFIC-FINAL_ACTION-POST_PROCESS-02-STAGE_PCP	declare @fileRequestId bigint = :fileRequestId ;"

drop table if exists HMP.PCP ;
if object_id('HMP.PCP') is null
select clientId
      ,npi
      ,count(distinct patientId) memberCount
  into HMP.PCP
  from QTIP.Patient.PatientProvider
 where clientid = 32
   and patientProviderActiveFlag = 1
   and /*entityTypeQualifierId = 10
   and*/ providerTypeId = 10 
 group by clientId
"         ,npi ; 	1	2020-08-03 12:58:03.3266667	mssql"
"216	32	CARE_ANALYZER-PHARMACY-CLIENT_SPECIFIC-FINAL_ACTION-POST_PROCESS-03-STAGE_PRESCRIPTION	declare @fileRequestId bigint = :fileRequestId ;"

drop table if exists HMP.Prescription;
if object_id('HMP.Prescription') is null
select pc.clientId
      ,pc.prescribingPhysicianNPI + case when pn.entityTypeQualifier is null then '*' else '' end npi
"	  ,n.providerLastName physicianLastName"
"	  ,n.providerFirstName physicianFirstName"
"	  ,n.providerOrganizationName"
"	  ,l.src"
"	  ,l.tcGpiName"
"	  ,l.drugName"
"	  ,l.itemStatus"
"	  ,pc.ndc"
"	  ,pc.patientPrimaryNumber"
"	  ,pc.firstDateOfService prescribedDate"
"	  ,pc.metricQuantity"
"	  ,pc.daysSupply"
"	  ,pc.payerClaimControlNumber"
"	  ,pc.adjustedClaimControlNumber"
"	  ,pc.claimStatusId"
"	  ,pc.claimStatusCode"
  into HMP.Prescription
  from HMP.NDC_High_PrescriberLookup l
  join HMP.PharmacyClaim pc on l.ndcUpcHri = pc.NDC
"						   and pc.claimStatusId not in (14)"
  left join QTIP.Reference.Nppes n on pc.prescribingPhysicianNPI = n.npi 
  left join PAW.Reference.Nppes pn on pc.prescribingPhysicianNPI = pn.npi 
option (maxdop 4) ;
"	1	2020-08-03 12:59:54.8366667	mssql"
"217	32	CARE_ANALYZER-PHARMACY-CLIENT_SPECIFIC-FINAL_ACTION-POST_PROCESS-04-STAGE_PRESCRIBER	declare @fileRequestId bigint = :fileRequestId ;"

drop table if exists HMP.Prescriber ;
if object_id('HMP.Prescriber') is null
begin
"	select p.clientId"
"	      ,p.npi"
"		  ,p.physicianFirstName"
"		  ,p.physicianLastName"
"		  ,p.providerOrganizationName"
"		  ,pcp.memberCount memberPcpCount"
"		  ,convert(date, convert(varchar(4), datepart(year, p.prescribedDate)) + '-' + right('0'+convert(varchar(2), datepart(month, p.prescribedDate)), 2) + '-01') prescribedMonth"
"		  ,p.src"
"		  ,count(*) prescribedCount"
"		  ,count(distinct p.patientPrimaryNumber) memberPrescribedCount"
"		  ,case when count(*) > 10 then 1 else 0 end isHighPrescriber"
"		  ,max(case when pcp.npi is not null then 1 else 0 end) isPCP"
"	  into HMP.Prescriber"
"	  from HMP.Prescription p"
"	  left join HMP.PCP pcp on case when right(p.npi, 1) = '*' then left(p.npi, 10) else p.npi end = pcp.Npi -- in case the npi is inactive"
"	                       and p.clientId = pcp.clientId"
"		-- still count metricQuantity or daysSupply = 0 because there could be an issue on the claims side"
"	 group by p.clientId"
"	         ,p.npi"
"			 ,p.physicianFirstName"
"			 ,p.physicianLastName"
"			 ,p.providerOrganizationName"
"			 ,pcp.memberCount"
"			 ,convert(varchar(4), datepart(year, p.prescribedDate))"
"			 ,right('0'+convert(varchar(2), datepart(month, p.prescribedDate)), 2)"
"			 ,p.src ;"
 
    -- drop index prescriber_temp_idx1 on HMP.Prescriber ;
"	create clustered index Prescriber_Idx1 on HMP.Prescriber(clientId, npi, prescribedMonth, isPCP) ; "
"end ; 	1	2020-08-03 13:01:33.5433333	mssql"
"218	32	CARE_ANALYZER-PHARMACY-CLIENT_SPECIFIC-FINAL_ACTION-POST_PROCESS-50-PREP_EXPORT	declare @fileRequestId bigint = :fileRequestId ;"
declare @clientId int = 32 ;

drop table if exists HMP.Pharmacy_export;

select 0 recordId
      ,'claimNumber' + '|' + 
"	   'claimStatus' + '|' + "
"	   'billingPharmacyId' + '|' + "
"	   'billingProviderSpecialty' + '|' + "
"	   'memberId' + '|' + "
"	   'totalPrescriptionCost' + '|' + "
"	   'drugNDC' + '|' + "
"	   'refillDays' + '|' + "
"	   'firstDateOfService' + '|' + "
"	   'serviceCategory' + '|' + "
"	   'metricQuantity' + '|' + "
"	   'dispensedQuatity' + '|' + "
"	   'allowedAmount' + '|' + "
"	   'prescibingProviderDEAmber' + '|' + "
"	   'ingredientCostBilled' + '|' + "
"	   'submittedDispenseAsWritten' + '|' + "
"	   'formularyIndicator' + '|' + "
"	   'genericPriceIndicatr' + '|' + "
"	   'therapeuticClassCode' + '|' + "
"	   'fillerValue1' + '|' + "
"	   'fillerValue2' + '|' + "
"	   'fillerValue3' + '|' + "
"	   'fillerValue4' + '|' + "
"	   'fillerValue5' + '|' + "
"	   'resctrictClaim' + '|' + "
"	   'supplementalDataFlag' + '|' + "
"	   'supplementalDataSource' + '|' + "
"	   'supplementalApprovalDate' + '|' + "
"	   'prescribingProviderNPI' + '|' + "
"	   'postedDate' + '|' +"
"	   'averageWholesalePrice' record"
  into HMP.Pharmacy_export
 union all
select 1 recordId
"     ,isnull(PayerClaimControlNumber, '') + '|' +                                           				"
"      'Paid' + '|' + 																						"
"      isnull(pharmacyFacilityPrimaryNumber + isnull(pharmacyFacilityLocationNumber, ''), '') + '|' +		"
"      '' + '|' +																							"
"      isnull(patientPrimaryNumber, '') + '|' + 																"
"      isnull(convert(varchar(13), cost), '') + '|' +														"
"      isnull(NDC, '') + '|' + 																				"
"      isnull(convert(varchar(13), daysSupply), '') + '|' +													"
      isnull(convert(varchar(10), firstDateOfService, 121) + ' 00:00:00.000000', '')  + '|' +                
"      'RX' + '|' +                      																	"
"      isnull(convert(varchar(13), metricQuantity), '')  + '|' +                     						"
"      '' + '|' +                     																		"
"      '' + '|' +                        																	"
"      '' + '|' +            																				"
"      '' + '|' +                 																			"
"      '' + '|' +           																					"
"      '' + '|' +                   																			"
"      '' + '|' +                 																			"
"      '' + '|' +                 																			"
"      '' + '|' +                         																	"
"      '' + '|' +                         																	"
"      '' + '|' +                         																	"
"      '' + '|' +                         																	"
"      '' + '|' +                         																	"
"      '' + '|' +                       																		"
"      '' + '|' +                 																			"
"      '' + '|' +               																				"
"      '' + '|' +             																				"
"      isnull(prescribingPhysicianNPI, '') + '|' +               											"
"      '' + '|' +                           																	"
"      ''																									"
  from HMP.PharmacyClaim
 where clientId = @clientId
   and payerClaimControlNumber is not null
   and patientPrimaryNumber is not null
   and claimStatusId in (11, 16, 18) -- paid claims
   and (ndcId > 9 -- valid ndc 
     or len(ndc)>10)
   and firstDateOfService > dateadd(year, -3, sysdatetime()) -- valid date of service
   and cost is not null
   and daysSupply is not null
 union all
select 2 recordId
      ,'A'+right('00000000000'+convert(varchar(11), m.medicationFactId), 11) /*payerClaimControlNumber*/  + '|' +    
"	   'Paid' /*claimStatus*/ + '|' +    "
"	   isnull(pr.ProviderPrimaryNumber+isnull(pra.ProviderAddressLocationNumber,''), '') /*pharmacyFacilityPrimaryNumber*/ + '|' +    "
"       '' + '|' +	"
"       isnull(p.patientPrimaryNumber, '') + '|' +	"
"	   convert(varchar(13), coalesce(rxh.TotalIngredientDrugCostPaidAmount, rxh.TotalIngredientDrugCostAmount, 0)) /*cost*/  + '|' +	"
"       isnull(ndc.ndcCode, '')  + '|' +	"
"	   isnull(convert(varchar(13), m.prescriptionDaysSupply),'') + '|' +	"
"	   isnull(convert(varchar(10), m.prescriptionWrittenDate, 121) + ' 00:00:00.000000', '') + '|' +    /*prescriptionWrittenDate*/  + '|' +	"
"	   'RX' /*claimType*/ + '|' +"
"	   convert(varchar(13), isnull(coalesce(m.prescribedQuantity, m.DispensedQuantity, m.ConsumptionQuantity), 0.0)) /*quantity*/  + '|' +                						"
"      '' + '|' +                     																		"
"      '' + '|' +                        																	"
"      '' + '|' +            																				"
"      '' + '|' +                 																			"
"      '' + '|' +           																					"
"      '' + '|' +                   																			"
"      '' + '|' +                 																			"
"      '' + '|' +                 																			"
"      '' + '|' +                         																	"
"      '' + '|' +                         																	"
"      '' + '|' +                         																	"
"      '' + '|' +                         																	"
"      '' + '|' +                         																	"
"      '' + '|' +                       																		"
"      '' + '|' +                 																			"
"      '' + '|' +               																				"
"      '' + '|' +             							"
"	  isnull(mph.Npi, '') /*physicianNpi*/ + '|' +               											"
"      '' + '|' +                           																	"
"      ''								"
 from QTIP.Clinical.MedicationFact m
 join QTIP.Patient.Patient p on m.clientId = p.clientId
                       and m.patientId = p.patientId
                       and p.patientActiveFlag = 1
 join QTIP.Reference.Client c on c.clientId = m.clientId
 join QTIP.Reference.Ndc ndc on m.ndcId = ndc.ndcId
 left join QTIP.ClaimRX.RxHeader rxh on m.clientId = rxh.clientId
                               and m.rxHeaderId = rxh.rxHeaderId
"							   and rxh.RxHeaderActiveFlag = 1"
 left join QTIP.Clinical.MedicationProviders mp on m.clientId = mp.clientId
                                          and m.medicationFactId = mp.medicationFactId
"										  and mp.medicationProvidersActiveFlag = 1"
"										  and mp.providerTypeId = 21 -- Pharmacy"
 left join QTIP.Provider.ProviderAddress pra on mp.clientId = pra.clientId
                                       and mp.providerAddressId = pra.providerAddressId
 left join QTIP.Provider.Provider pr on pra.clientId = pr.clientId
                               and pra.providerId = pr.providerId
 left join QTIP.Clinical.MedicationProviders mph on m.clientId = mph.clientId
                                           and m.medicationFactId = mph.medicationFactId
"										   and mph.medicationProvidersActiveFlag = 1"
"										   and mph.providerTypeId = 22 -- Pharmacist"
where m.clientId = 32 
  and m.recordSourceId =10 
  and m.recordTypeId = 41 
  and m.medicationFactActiveFlag = 1
   -- cause an error if the claim number won't generate properly
"  and case when len(m.medicationFactId)<12 then 1 else 'A' end = 1; 	1	2020-08-04 13:39:35.2833333	mssql"
"219	32	CARE_ANALYZER-PHARMACY-CLIENT_SPECIFIC-FINAL_ACTION-POST_PROCESS-51-EXPORT	"
set nocount on

declare @fileRequestId bigint = :fileRequestId ;
declare @directory varchar(100) = 'E:\IMPORTS' ; --'E:\IMPORTS\CLAIMS\HMP';

declare @today varchar(10) =right('0'+ cast(month(sysdatetime()) as varchar(2)), 2) + right('0'+ cast(datepart(day, sysdatetime()) as varchar(2)), 2) + cast(year(sysdatetime()) as varchar(4));
declare @fileName varchar(100) = 'OKL_Pharmacy_' + @today + '.txt'

-- select @directory + '\' + @fileName

declare @cmd varchar(4000);

set @cmd = 'bcp "select record from PAW.HMP.Pharmacy_export order by recordId" QUERYOUT "'+@directory+'\'+@fileName+'" -S'+'ueqt3pmsq01'+' -T -c';
if object_id('HMP.ExportResults') is null
"	create table HMP.ExportResults "
"	(exportDateTime datetime2 default sysdatetime()"
"	,outputText varchar(4000)) ;"

#NAME?
insert HMP.ExportResults
      (outputText)
"exec xp_cmdshell @cmd ; 	1	2020-08-04 13:41:33.3533333	mssql"
"220	39	RETIRE_MISSING_PROVIDERS	--declare @fileRequestId bigint = :fileRequestId ;"
--declare @maxStageId bigint = :maxStageId ;

-- don't terminate providers that were loaded from history 
#NAME?
#NAME?
-- a file (and there's a clientProviderTypeCode for it now)

drop table if exists ##id_active_providers ;

select distinct
       p.providerPrimaryNumber
      ,p.entityTypeQualifier
"	  ,p.providerFirstName"
"	  ,p.providerLastOrOrgName"
"	  ,n.networkEffectiveDate"
"	  ,n.networkTerminationDate"
  into ##id_active_providers
  from Provider.ProviderDim p
  join Provider.NetworkFact n on p.clientId = n.clientId
                             and p.providerId = n.providerId
"							 and n.networkFactActiveFlag = 1"
"							 and (n.networkTerminationDate is null"
"							   or n.networkTerminationDate > sysdatetime())"
 where p.clientId = 39
   and p.providerActiveFlag = 1
   and p.clientProviderTypeCode is not null ;

select *
  from ##id_active_providers a
  left join EdmStage.ID_Provider s on a.providerPrimaryNumber = s.providerId
" where s.stageId is null ; 	0	2020-09-02 12:13:41.6900000	mssql"
"221	39	MERGE_NETWORK_DATES	declare @fileRequestId bigint = :fileRequestId ;"
declare @networkEffectiveDate date = :networkEffectiveDate ;

drop table if exists ##id_provider_network_dates ;

select *
  into ##id_provider_network_dates
  from (select s.stageId
              ,s.providerId
"			  ,n.networkId"
              ,n.networkEffectiveDate
"        	  ,n.networkTerminationDate"
"			  ,p.entityTypeQualifier"
"			  ,p.transactionSetCreationDateTime"
              ,rank() over(partition by s.providerId, n.networkId order by isnull(n.networkTerminationDate, '9999-12-31') desc, n.networkEffectiveDate, n.networkFactId desc) networkRank
          from EdmStage.ID_Provider s
          join Provider.ProviderDim p on s.providerId = p.providerPrimaryNumber 
                                     and p.clientId = 39
"        							 and p.providerActiveFlag = 1"
          join Provider.NetworkFact n on p.clientId = n.clientId
                                     and p.providerId = n.providerId
"        							 and n.networkFactActiveFlag = 1"
"									 and n.networkEffectiveDate is not null"
"		 where s.networkEffectiveDate is null) x"
 where x.networkRank = 1 ;

merge into EdmStage.ID_Provider m
using ##id_provider_network_dates u 
   on m.stageId = u.stageId
 when matched then update set m.entityTypeQualifier = u.entityTypeQualifier
                             ,m.networkEffectiveDate = convert(date, u.networkEffectiveDate)
"							 ,m.networkTerminationDate = convert(date, u.networkTerminationDate)"
"							 ,m.transactionSetCreationDateTime = u.transactionSetCreationDateTime ;"

update EdmStage.ID_Provider
   set networkEffectiveDate = convert(date, @networkEffectiveDate)
"	  ,entityTypeQualifier = case when firstName is null then 2 else 1 end "
  from EdmStage.ID_Provider
" where networkEffectiveDate is null ;	1	2020-09-02 12:17:16.5666667	mssql"
"222	42	MERGE_OPTUM-HCPCS-BASE	declare @fileRequestId bigint = :fileRequestId ;"

declare @hcpcsLevel varchar(1) = '2' ;
declare @hcpcsLevelType varchar(10) = 'HCPCS' ;

#NAME?
#NAME?
drop table if exists #hcpcs ;

select h.hcpcsId
      ,o.fileRequestId
      ,o.code
      ,o.shortDescription
      ,o.longDescription
      ,o.fullDescription
      --,o.nonFacilityTotalRVU
      --,o.facilityTotalRVU
          ,case when upper(o.fullDescription) like '%UNSPECIFIED%' then 1
                    when upper(o.fullDescription) like '%UNCLASSIFIED%' then 1
                    when upper(o.fullDescription) like '%UNLISTED %' then 1
                when upper(o.fullDescription) like '%NOT OTHERWISE SPECIFIED%' then 1
                when upper(o.fullDescription) like '%NOT OTHERWISE CLASSIFIED%' then 1
                when upper(o.fullDescription) like '%NOT ELSEWHERE SPECIFIED%' then 1
                else 0 end nocFlag
          ,case when h.hcpcsEffectiveDate is not null
                then h.hcpcsEffectiveDate
                when h.hcpcsId is null
                 and isnull(o.status, '~') <> 'D'
"				then case when patindex('%[0-9][0-9][0-9][0-9][_][0-9][0-9]%', fr.originalFileName) > 0"
                          then dateadd(day, 0, replace(substring(fr.originalFileName, patindex('%[0-9][0-9][0-9][0-9][_][0-9][0-9]%', fr.originalFileName), 7), '_', '-') + '-01') 
"						  when patindex('%[0-9][0-9][0-9][0-9]%', fr.originalFileName) > 0"
                          then dateadd(day, 0, replace(substring(fr.originalFileName, patindex('%[0-9][0-9][0-9][0-9]%', fr.originalFileName), 4), '_', '-') + '-01-01') 
"				     end "
"				 end effectiveDate"
          ,case when o.status = 'D' 
"		        then case when patindex('%[0-9][0-9][0-9][0-9][_][0-9][0-9]%', fr.originalFileName) > 0"
"		                  then dateadd(day, -1, replace(substring(fr.originalFileName, patindex('%[0-9][0-9][0-9][0-9][_][0-9][0-9]%', fr.originalFileName), 7), '_', '-') + '-01')"
"						  when patindex('%[0-9][0-9][0-9][0-9]%', fr.originalFileName) > 0"
                          then dateadd(day, -1, replace(substring(fr.originalFileName, patindex('%[0-9][0-9][0-9][0-9]%', fr.originalFileName), 4), '_', '-') + '-01-01') 
"					  end "
"				 end terminationDate"
      ,h.hcpcsNocFlag
          ,h.hcpcsEffectiveDate
      ,h.hcpcsTerminationDate
          ,case when h.hcpcsId is null
              or o.shortDescription <> h.hcpcsShortDesc
              or o.longDescription <> h.hcpcsLongDesc
              or o.fullDescription <> h.hcpcsFullDesc
"			  or (o.status = 'D' and h.hcpcsTerminationDate is null)"
              --or isnull(o.facilityTotalRVU, -1) <> isnull(h.hcpcsTotalFacilityPractiveExpenseRvu, -1)
              --or isnull(o.nonFacilityTotalRVU, -1) <> isnull(h.hcpcsTotalNonFacilityPracticeExpenseRvu, -1)
                   then 1
                   else 0
            end hasDiff
   into #hcpcs
        ------------------------
   from EdmStage.Optum_HCPCSBase o
        ------------------------
   join EdmLib.FileRequest fr on o.fileRequestId = fr.fileRequestId
   left join Reference.Hcpcs h on o.code = h.hcpcsCode
                                                      and hcpcsLevel = @hcpcsLevel
"													  and hcpcsActiveFlag = 1"

#NAME?
drop table if exists #hcpcs_diff ;

select *
  into #hcpcs_diff
  from #hcpcs
 where hasDiff = 1
    or nocFlag <> hcpcsNocFlag
    or isnull(terminationDate, '9999-12-31') <> isnull(hcpcsTerminationDate, '9999-12-31') ;

--select *
--  from #hcpcs_diff ;

-- truncate table Reference.HcpcsHistory ;

#NAME?
#NAME?
insert into Reference.HcpcsHistory
select h.*, sysdatetime() historyDateTime, @fileRequestId triggeringFileRequestId
  from #hcpcs_diff d
  join Reference.Hcpcs h on d.hcpcsId = h.hcpcsId;

declare @maxHcpcsId bigint ;
select @maxHcpcsId = max(hcpcsId)
  from Reference.Hcpcs ;

declare @currentHcpcsId bigint ;
select @currentHcpcsId = convert(bigint, current_value)
  from sys.sequences
 where object_id = object_id('Reference.HcpcsSeq') ;

if @maxHcpcsId > @currentHcpcsId
begin
        print 'Re-sequencing ...'
        declare @reSequenceDDL varchar(500) = 'alter sequence Reference.HcpcsSeq restart with ' + convert(varchar(10), @maxHcpcsId + 1) ;
        exec sp_sqlexec @reSequenceDDL ;
end ;

#NAME?

merge into Reference.Hcpcs m
using #hcpcs_diff u
   on m.hcpcsId = u.hcpcsId
 when matched then update
          set m.hcpcsShortDesc = u.shortDescription
                 ,m.hcpcsLongDesc = u.longDescription
                 ,m.hcpcsFullDesc = u.fullDescription
                 --,m.hcpcsTotalNonFacilityPracticeExpenseRvu = u.nonFacilityTotalRVU
                 --,m.hcpcsTotalFacilityPractiveExpenseRvu = u.facilityTotalRVU
                 ,m.hcpcsNocFlag = u.nocFlag
                 ,m.hcpcsEffectiveDate = u.effectiveDate
                 ,m.hcpcsTerminationDate = u.terminationDate
                 ,m.hcpcsUpdateDate = sysdatetime()
 when not matched then insert
                 (hcpcsCode
                 ,hcpcsLevel
                 ,hcpcsShortDesc
                 ,hcpcsLongDesc
                 ,hcpcsFullDesc
                 ,hcpcsEffectiveDate
                 ,hcpcsTerminationDate
                 --,hcpcsTotalNonFacilityPracticeExpenseRvu
                 --,hcpcsTotalFacilityPractiveExpenseRvu
                 ,hcpcsNocFlag
                 ,hcpcsLevelType
                                 ,hcpcsActiveFlag
                 ,hcpcsCreateDate)
                 values
                 (u.code
                 ,@hcpcsLevel
                 ,u.shortDescription
                 ,u.longDescription
                 ,u.fullDescription
                 ,u.effectiveDate
                 ,u.terminationDate
                 --,u.nonFacilityTotalRVU
                 --,u.facilityTotalRVU
                 ,u.nocFlag
                 ,@hcpcsLevelType
                                 ,1
                 ,sysdatetime());

#NAME?
merge into Reference.Hcpcs m
using (select *
         from Reference.HcpcsOverride
        where hcpcsLevel = @hcpcsLevel
          and hcpcsActiveFlag = 1) u
   on m.hcpcsId = u.hcpcsId
  and m.hcpcsCode = u.hcpcsCode
  and m.hcpcsLevel = u.hcpcsLevel
 when matched then update set m.hcpcsCategoryId                                                 = u.hcpcsCategoryId
                             ,m.hcpcsShortDesc                                                  = u.hcpcsShortDesc
                             ,m.hcpcsLongDesc                                                   = u.hcpcsLongDesc
                             ,m.hcpcsFullDesc                                                   = u.hcpcsFullDesc
                             ,m.hcpcsEffectiveDate                                              = u.hcpcsEffectiveDate
                             ,m.hcpcsTerminationDate                                    = u.hcpcsTerminationDate
                             ,m.hcpcsTotalNonFacilityPracticeExpenseRvu = u.hcpcsTotalNonFacilityPracticeExpenseRvu
                             ,m.hcpcsTotalFacilityPractiveExpenseRvu    = u.hcpcsTotalFacilityPractiveExpenseRvu
                             ,m.hcpcsReuseDate                                                  = u.hcpcsReuseDate
                             ,m.hcpcsPreviousId                                                 = u.hcpcsPreviousId
                             ,m.hcpcsStatus                                                             = u.hcpcsStatus
                             ,m.hcpcsActiveFlag                                                 = u.hcpcsActiveFlag
                             ,m.hcpcsCreateDate                                                 = u.hcpcsCreateDate
                             ,m.hcpcsUpdateDate                                                 = u.hcpcsUpdateDate
                             ,m.hcpcsNocInd                                                             = u.hcpcsNocInd
                             ,m.hcpcsNocFlag                                                    = u.hcpcsNocFlag
"                             ,m.hcpcsLevelType                                                  = u.hcpcsLevelType ;	1	2020-09-11 13:19:50.6600000	mssql"
"223	42	MERGE_OPTUM-CPT-BASE-COVERAGE	declare @fileRequestId bigint = :fileRequestId ;"

declare @hcpcsLevel varchar(1) = '1' ;
declare @hcpcsLevelType varchar(10) = 'CPT' ;

#NAME?
#NAME?
drop table if exists #hcpcs ;

select h.hcpcsId
      ,o.fileRequestId
      ,o.code
      ,o.shortDescription
      ,o.longDescription
      ,o.fullDescription
      ,o.nonFacilityTotalRVU
      ,o.facilityTotalRVU
"	  ,case when upper(o.fullDescription) like '%UNSPECIFIED%' then 1 "
"	  	    when upper(o.fullDescription) like '%UNCLASSIFIED%' then 1"
"	  	    when upper(o.fullDescription) like '%UNLISTED %' then 1"
"	        when upper(o.fullDescription) like '%NOT OTHERWISE SPECIFIED%' then 1 "
"	        when upper(o.fullDescription) like '%NOT OTHERWISE CLASSIFIED%' then 1 "
"	        when upper(o.fullDescription) like '%NOT ELSEWHERE SPECIFIED%' then 1 "
"	        else 0 end nocFlag"
"	  ,case when h.hcpcsEffectiveDate is not null "
"	        then h.hcpcsEffectiveDate"
"	        when h.hcpcsId is null"
"	         and isnull(o.status, '~') <> 'D' "
"	  	  then dateadd(day, 0, replace(substring(fr.originalFileName, patindex('%[0-9][0-9][0-9][0-9][_][0-9][0-9]%', fr.originalFileName), 7), '_', '-') + '-01') end effectiveDate"
"	  ,case when o.status = 'D' then dateadd(day, -1, replace(substring(fr.originalFileName, patindex('%[0-9][0-9][0-9][0-9][_][0-9][0-9]%', fr.originalFileName), 7), '_', '-') + '-01') end terminationDate"
      ,h.hcpcsNocFlag
"	  ,h.hcpcsEffectiveDate"
      ,h.hcpcsTerminationDate
"	  ,case when h.hcpcsId is null"
              or o.shortDescription <> h.hcpcsShortDesc
              or o.longDescription <> h.hcpcsLongDesc
              or o.fullDescription <> h.hcpcsFullDesc
              or isnull(o.facilityTotalRVU, -1) <> isnull(h.hcpcsTotalFacilityPractiveExpenseRvu, -1)
              or isnull(o.nonFacilityTotalRVU, -1) <> isnull(h.hcpcsTotalNonFacilityPracticeExpenseRvu, -1) 
"	 	   then 1 "
"	 	   else 0 "
"	    end hasDiff"
   into #hcpcs
        --------------------------------
   from EdmStage.Optum_CPTBaseCoverage o 
        --------------------------------
   join EdmLib.FileRequest fr on o.fileRequestId = fr.fileRequestId
   left join Reference.Hcpcs h on o.code = h.hcpcsCode
"   						      and hcpcsLevel = @hcpcsLevel"

#NAME?
drop table if exists #hcpcs_diff ;

select *
  into #hcpcs_diff 
  from #hcpcs
 where hasDiff = 1
    or nocFlag <> hcpcsNocFlag
    or isnull(terminationDate, '9999-12-31') <> isnull(hcpcsTerminationDate, '9999-12-31') ;

-- truncate table Reference.HcpcsHistory ;
 
#NAME?
#NAME?
insert into Reference.HcpcsHistory
select h.*, sysdatetime() historyDateTime, @fileRequestId triggeringFileRequestId
  from #hcpcs_diff d
  join Reference.Hcpcs h on d.hcpcsId = h.hcpcsId;

declare @maxHcpcsId bigint ;
select @maxHcpcsId = max(hcpcsId)
  from Reference.Hcpcs ;

declare @currentHcpcsId bigint ;
select @currentHcpcsId = convert(bigint, current_value)
  from sys.sequences
 where object_id = object_id('Reference.HcpcsSeq') ;

if @maxHcpcsId > @currentHcpcsId
begin
"	print 'Re-sequencing ...'"
"	declare @reSequenceDDL varchar(500) = 'alter sequence Reference.HcpcsSeq restart with ' + convert(varchar(10), @maxHcpcsId + 1) ;"
"	exec sp_sqlexec @reSequenceDDL ;"
end ;

merge into Reference.Hcpcs m
using #hcpcs_diff u
   on m.hcpcsId = u.hcpcsId
 when matched then update
"	  set m.hcpcsShortDesc = u.shortDescription"
"		 ,m.hcpcsLongDesc = u.longDescription"
"		 ,m.hcpcsFullDesc = u.fullDescription"
"		 ,m.hcpcsTotalNonFacilityPracticeExpenseRvu = u.nonFacilityTotalRVU"
"		 ,m.hcpcsTotalFacilityPractiveExpenseRvu = u.facilityTotalRVU"
"		 ,m.hcpcsNocFlag = u.nocFlag"
"		 ,m.hcpcsEffectiveDate = u.effectiveDate"
"		 ,m.hcpcsTerminationDate = u.terminationDate"
"		 ,m.hcpcsUpdateDate = sysdatetime()"
 when not matched then insert
"		 (hcpcsCode"
"		 ,hcpcsLevel"
"		 ,hcpcsShortDesc"
"		 ,hcpcsLongDesc"
"		 ,hcpcsFullDesc"
"		 ,hcpcsEffectiveDate"
"		 ,hcpcsTerminationDate"
"		 ,hcpcsTotalNonFacilityPracticeExpenseRvu"
"		 ,hcpcsTotalFacilityPractiveExpenseRvu"
"		 ,hcpcsNocFlag"
"		 ,hcpcsLevelType"
"		 ,hcpcsActiveFlag"
"		 ,hcpcsCreateDate)"
"		 values"
"		 (u.code"
"		 ,@hcpcsLevel"
"		 ,u.shortDescription"
"		 ,u.longDescription"
"		 ,u.fullDescription"
"		 ,u.effectiveDate"
"		 ,u.terminationDate"
"		 ,u.nonFacilityTotalRVU"
"		 ,u.facilityTotalRVU"
"		 ,u.nocFlag"
"		 ,@hcpcsLevelType"
"		 ,1"
"		 ,sysdatetime()); "
"		 "
#NAME?
merge into Reference.Hcpcs m
using (select *
         from Reference.HcpcsOverride
        where hcpcsLevel = @hcpcsLevel
          and hcpcsActiveFlag = 1) u
   on m.hcpcsId = u.hcpcsId
  and m.hcpcsCode = u.hcpcsCode
  and m.hcpcsLevel = u.hcpcsLevel
" when matched then update set m.hcpcsCategoryId							= u.hcpcsCategoryId"
"                             ,m.hcpcsShortDesc							= u.hcpcsShortDesc"
"                             ,m.hcpcsLongDesc							= u.hcpcsLongDesc"
"                             ,m.hcpcsFullDesc							= u.hcpcsFullDesc"
"                             ,m.hcpcsEffectiveDate						= u.hcpcsEffectiveDate"
"                             ,m.hcpcsTerminationDate					= u.hcpcsTerminationDate"
"                             ,m.hcpcsTotalNonFacilityPracticeExpenseRvu	= u.hcpcsTotalNonFacilityPracticeExpenseRvu"
"                             ,m.hcpcsTotalFacilityPractiveExpenseRvu	= u.hcpcsTotalFacilityPractiveExpenseRvu"
"                             ,m.hcpcsReuseDate							= u.hcpcsReuseDate"
"                             ,m.hcpcsPreviousId							= u.hcpcsPreviousId"
"                             ,m.hcpcsStatus								= u.hcpcsStatus"
"                             ,m.hcpcsActiveFlag							= u.hcpcsActiveFlag"
"                             ,m.hcpcsCreateDate							= u.hcpcsCreateDate"
"                             ,m.hcpcsUpdateDate							= u.hcpcsUpdateDate"
"                             ,m.hcpcsNocInd								= u.hcpcsNocInd"
"                             ,m.hcpcsNocFlag							= u.hcpcsNocFlag"
"                             ,m.hcpcsLevelType							= u.hcpcsLevelType ; 	1	2020-09-11 14:31:28.3833333	mssql"
"224	42	MERGE_OPTUM-CPT-MODIFIER-XWALK	declare @fileRequestId bigint = :fileRequestId ;"

declare @hcpcsLevel varchar(1) = '1' ;

declare @modifierType varchar(20) ;

select @modifierType = case when originalFileName like '%OPTUM_%_MODIFIER_XWALK_FACILITY%' then 'Facility'
                            when originalFileName like '%OPTUM_%_MODIFIER_XWALK_PHYSICIAN%' then 'Physician'
                            when originalFileName like '%OPTUM_%_MODIFIER_XWALK_MEDICARE%' then 'Medicare'
                            when originalFileName like '%OPTUM_%_MODIFIER_XWALK_AMBULANCE%' then 'Ambulance'
                            when originalFileName like '%OPTUM_%_MODIFIER_XWALK_DME%' then 'DME'
                           end
  from EdmLib.FileRequest
 where fileRequestId = @fileRequestId ;

#NAME?
insert into Reference.HcpcsModifier 
select qt3.hcpcsModifierId
      ,qt3.hcpcsId
      ,qt3.modifierId
      ,'TELLIGEN' hcpcsModifierType
      ,qt3.hcpcsModifierAmbulanceFlag
      ,qt3.hcpcsModifierDmeFlag
      ,qt3.hcpcsModifierProcFlag
      ,0 hcpcsModifierAddOnFlag
      ,qt3.hcpcsModifierActiveFlag
      ,qt3.hcpcsModifierCreateDate
      ,qt3.hcpcsModifierUpdateDate
  from QTIP.Reference.HcpcsModifier qt3
  left join Reference.HcpcsModifier paw
         on qt3.hcpcsModifierId = paw.hcpcsModifierId
  where paw.hcpcsModifierId is null
"	and qt3.hcpcsModifierId >= 10"
 order by 1 desc ;

#NAME?
drop table if exists #hcpcs_modifier ;

select distinct modifier, description
  into #hcpcs_modifier
  from EdmStage.Optum_CptModifierXwalk ;

merge into Reference.Modifier m
using #hcpcs_modifier u
   on m.modifierCode = u.modifier
  and m.modifierDesc = u.description
  and m.modifieractiveflag = 1
 when matched then update set m.modifierUpdateDate = case when m.modifierActiveFlag = 0 or m.modifierDesc <> u.description then sysdatetime() else m.modifierUpdateDate end
                             ,m.modifierActiveFlag = 1
                             ,m.modifierAmbulanceFlag = case when @modifierType = 'Ambulance' then 1 else m.modifierAmbulanceFlag end
                             ,m.modifierDesc = u.description
 when not matched then insert (modifierCode
                              ,modifierDesc
                              ,modifierAmbulanceFlag
                              ,modifierCreateDate
                              ,modifierActiveFlag)
                       values (u.modifier
                              ,u.description
                              ,case when @modifierType = 'Ambulance' then 1 else 0 end
                              ,sysdatetime()
                              ,1) ;

#NAME?
merge into Reference.Modifier m
using Reference.ModifierOverride u
   on m.modifierId = u.modifierId
  and m.modifierCode = u.modifierCode
 when matched then update set m.hcpcsLevel                        = u.hcpcsLevel
                             ,m.modifierName              = u.modifierName
                             ,m.modifierDesc              = u.modifierDesc
                             ,m.modifierAmbulanceFlag = u.modifierAmbulanceFlag
                             ,m.modifierCreateDate        = u.modifierCreateDate
                             ,m.modifierActiveFlag        = u.modifierActiveFlag
                             ,m.modifierUpdateDate        = u.modifierUpdateDate ;

#NAME?
#NAME?
#NAME?
#NAME?
drop table if exists #hcpcs_modifier_xwalk_hcpcs ;

select distinct code
  into #hcpcs_modifier_xwalk_hcpcs
  from EdmStage.Optum_CptModifierXwalk ;

declare @missingHcpcsCount int ;
select @missingHcpcsCount = count(*)
  from #hcpcs_modifier_xwalk_hcpcs x
  left join Reference.Hcpcs h on x.code = h.hcpcsCode
                             and h.hcpcsLevel = @hcpcsLevel
 where h.hcpcsId is null ;

if @missingHcpcsCount > 0
        throw 51000, 'HCPCS-Modifier-Xwalk: Missing CPT.  Be sure to load the CPT file first', 16 ;


#NAME?
#NAME?
#NAME?
drop table if exists #hcpcs_modifier_update ;

select x.*
      ,h.hcpcsId
          ,m.modifierId
          ,hm.hcpcsModifierId
          ,case when hm.hcpcsModifierId is null then 'New'
                when hm.hcpcsModifierActiveFlag = 0 then 'Reactivate'
                when hm.hcpcsModifierType not like '%'+ @modifierType + '%'
                  or (hm.hcpcsModifierType is null and @modifierType is NOT null) then 'New-Modifier-Type'
           end updateStatus
  into #hcpcs_modifier_update
  from EdmStage.Optum_CptModifierXwalk x
  join Reference.Hcpcs h on x.code = h.hcpcsCode
                        and h.hcpcsLevel = @hcpcsLevel
  join Reference.Modifier m on x.modifier = m.modifierCode
  left join Reference.HcpcsModifier hm on h.hcpcsId = hm.hcpcsId
                                      and m.modifierId = hm.modifierId
 where hm.hcpcsModifierId is null
    or hm.hcpcsModifierActiveFlag = 0
        or (hm.hcpcsModifierType not like '%'+ @modifierType + '%'
         or (hm.hcpcsModifierType is null and @modifierType is NOT null));

insert
  into Reference.HcpcsModifierHistory
select hm.*
      ,sysdatetime() historyDateTime
          ,@fileRequestId triggeringFileRequestId
  from #hcpcs_modifier_update u
  join Reference.HcpcsModifier hm on u.hcpcsModifierId = hm.hcpcsModifierId ;

merge into Reference.HcpcsModifier m
using #hcpcs_modifier_update u
   on m.hcpcsModifierId = u.hcpcsModifierId
 when matched then update set m.hcpcsModifierType = case when m.hcpcsModifierType is null then @modifierType
                                                         when m.hcpcsModifierType not like '%' + @modifierType + '%' then m.hcpcsModifierType +','+ @modifierType
                                                                                                                 else m.hcpcsModifierType
                                                                                                        end
                             ,m.hcpcsModifierAmbulanceFlag = case when @modifierType = 'Ambulance' then 1 else m.hcpcsModifierAmbulanceFlag end
                             ,m.hcpcsModifierDmeFlag = case when @modifierType = 'DME' then 1 else m.hcpcsModifierDmeFlag end
"							 ,m.hcpcsModifierProcFlag = case when @modifierType = 'Facility' then 1"
"															 when @modifierType = 'Physician' then 1"
"															 when @modifierType = 'Medicare' then 1 "
"															else m.hcpcsModifierProcFlag end"
                             ,m.hcpcsModifierAddOnFlag = 0
                             ,m.hcpcsModifierActiveFlag = 1
                             ,m.hcpcsModifierUpdateDate = sysdatetime()
 when not matched then insert (hcpcsId
                              ,modifierId
                              ,hcpcsModifierType
                              ,hcpcsModifierAmbulanceFlag
                              ,hcpcsModifierDmeFlag
                              ,hcpcsModifierProcFlag
                              ,hcpcsModifierAddOnFlag
                              ,hcpcsModifierActiveFlag
                              ,hcpcsModifierCreateDate)
                       values (u.hcpcsId
                              ,u.modifierId
                              ,@modifierType
                              ,case when @modifierType = 'Ambulance' then 1 else 0 end
                              ,case when @modifierType = 'DME' then 1 else 0 end
                              ,case when @modifierType = 'Facility' then 1
"									when @modifierType = 'Physician' then 1"
"								    when @modifierType = 'Medicare' then 1 "
"										else 0 end"
                              ,0
                              ,1
"                              ,sysdatetime()) ;	1	2020-09-15 11:49:05.0366667	mssql"
"225	42	MERGE_OPTUM-CPT-MODIFIER-XWALK-FACILITY	-- ACTIVE CODE, but do NOT use EdmStage.Optum_CPTModifierXWalkFacility.level, use @hcpcsLevel instead"
declare @fileRequestId bigint = :fileRequestId ;

declare @hcpcsLevel varchar(1) = '1' ;

declare @modifierType varchar(20) ;

select @modifierType = case when originalFileName like '%OPTUM_%_MODIFIER_XWALK_FACILITY%' then 'Facility'
                            when originalFileName like '%OPTUM_%_MODIFIER_XWALK_PHYSICIAN%' then 'Physician'
                            when originalFileName like '%OPTUM_%_MODIFIER_XWALK_MEDICARE%' then 'Medicare'
                            when originalFileName like '%OPTUM_%_MODIFIER_XWALK_AMBULANCE%' then 'Ambulance'
                            when originalFileName like '%OPTUM_%_MODIFIER_XWALK_DME%' then 'DME'
"	                   end        "
  from EdmLib.FileRequest
 where fileRequestId = @fileRequestId ;

#NAME?
drop table if exists #hcpcs_modifier ;

select distinct modifier, description, ambulanceFlag
  into #hcpcs_modifier
  from EdmStage.Optum_CPTModifierXWalkFacility ;

merge into Reference.Modifier m
using #hcpcs_modifier u
   on m.modifierCode = u.modifier 
  and m.modifierDesc = u.description
  and m.modifieractiveflag = 1
 when matched then update set m.modifierUpdateDate = case when m.modifierActiveFlag = 0 or (m.modifierAmbulanceFlag = 0 and  u.ambulanceFlag = 1) then sysdatetime() else m.modifierUpdateDate end
                             ,m.modifierActiveFlag = 1
"							 ,m.modifierAmbulanceFlag = case when u.ambulanceFlag = 1 then 1 else m.modifierAmbulanceFlag end"
 when not matched then insert (modifierCode
                              ,modifierDesc
"							  ,modifierAmbulanceFlag"
"							  ,modifierCreateDate"
"							  ,modifierActiveFlag)"
                       values (u.modifier
"					          ,u.description"
"							  ,case when u.ambulanceFlag = 1 then 1 else 0 end"
"							  ,sysdatetime()"
"							  ,1) ;"

#NAME?
merge into Reference.Modifier m
using Reference.ModifierOverride u
   on m.modifierId = u.modifierId
  and m.modifierCode = u.modifierCode
" when matched then update set m.hcpcsLevel			  = u.hcpcsLevel"
"                             ,m.modifierName		  = u.modifierName"
"                             ,m.modifierDesc		  = u.modifierDesc"
                             ,m.modifierAmbulanceFlag = u.modifierAmbulanceFlag
"                             ,m.modifierCreateDate	  = u.modifierCreateDate"
"                             ,m.modifierActiveFlag	  = u.modifierActiveFlag"
"                             ,m.modifierUpdateDate	  = u.modifierUpdateDate ;"

#NAME?
#NAME?
#NAME?
#NAME?
drop table if exists #hcpcs_modifier_xwalk_hcpcs ;

select distinct code
  into #hcpcs_modifier_xwalk_hcpcs
  from EdmStage.Optum_CPTModifierXWalkFacility ;

declare @missingHcpcsCount int ;
select @missingHcpcsCount = count(*)
  from #hcpcs_modifier_xwalk_hcpcs x
  left join Reference.Hcpcs h on x.code = h.hcpcsCode
                             and h.hcpcsLevel = @hcpcsLevel 
 where h.hcpcsId is null ;

if @missingHcpcsCount > 0
"	throw 51000, 'HCPCS-Modifier-Xwalk-Facility: Missing CPT.  Be sure to load the CPT file first', 16 ;"

#NAME?
#NAME?
#NAME?
drop table if exists #hcpcs_modifier_update ;

select x.*
      ,h.hcpcsId
"	  ,m.modifierId"
"	  ,hm.hcpcsModifierId"
"	  ,case when hm.hcpcsModifierId is null then 'New'"
"	        when hm.hcpcsModifierActiveFlag = 0 then 'Reactivate'"
"			when hm.hcpcsModifierType not like '%'+ @modifierType + '%' "
"	          or (hm.hcpcsModifierType is null and @modifierType is NOT null) then 'New-Modifier-Type'"
"	   end updateStatus"
  into #hcpcs_modifier_update
  from EdmStage.Optum_CPTModifierXWalkFacility x
  join Reference.Hcpcs h on x.code = h.hcpcsCode
                        and h.hcpcsLevel = @hcpcsLevel
  join Reference.Modifier m on x.modifier = m.modifierCode
  left join Reference.HcpcsModifier hm on h.hcpcsId = hm.hcpcsId
                                      and m.modifierId = hm.modifierId
 where hm.hcpcsModifierId is null 
    or hm.hcpcsModifierActiveFlag = 0
"	or (hm.hcpcsModifierType not like '%'+ @modifierType + '%' "
"	 or (hm.hcpcsModifierType is null and @modifierType is NOT null));"

insert
  into Reference.HcpcsModifierHistory 
select hm.*
      ,sysdatetime() historyDateTime
"	  ,@fileRequestId triggeringFileRequestId"
  from #hcpcs_modifier_update u
  join Reference.HcpcsModifier hm on u.hcpcsModifierId = hm.hcpcsModifierId ;

merge into Reference.HcpcsModifier m
using #hcpcs_modifier_update u
   on m.hcpcsModifierId = u.hcpcsModifierId
 when matched then update set m.hcpcsModifierType = case when m.hcpcsModifierType is null then @modifierType
                                                         when m.hcpcsModifierType not like '%' + @modifierType + '%' then m.hcpcsModifierType +','+ @modifierType
"														else m.hcpcsModifierType"
                                                    end
                             ,m.hcpcsModifierAmbulanceFlag = case when @modifierType = 'Ambulance' then 1 else m.hcpcsModifierAmbulanceFlag end
                             ,m.hcpcsModifierDmeFlag = case when @modifierType = 'DME' then 1 else m.hcpcsModifierDmeFlag end
"							 ,m.hcpcsModifierProcFlag = case when @modifierType = 'Facility' then 1"
"															 when @modifierType = 'Physician' then 1"
"															 when @modifierType = 'Medicare' then 1 "
"															else m.hcpcsModifierProcFlag end"
                             ,m.hcpcsModifierAddOnFlag = 0
                             ,m.hcpcsModifierActiveFlag = 1
                             ,m.hcpcsModifierUpdateDate = sysdatetime()
 when not matched then insert (hcpcsId
                              ,modifierId
                              ,hcpcsModifierType
                              ,hcpcsModifierAmbulanceFlag
                              ,hcpcsModifierDmeFlag
                              ,hcpcsModifierProcFlag
                              ,hcpcsModifierAddOnFlag
                              ,hcpcsModifierActiveFlag
                              ,hcpcsModifierCreateDate)
                       values (u.hcpcsId
                              ,u.modifierId
                              ,@modifierType
                              ,case when @modifierType = 'Ambulance' then 1 else 0 end
                              ,case when @modifierType = 'DME' then 1 else 0 end
                              ,case when @modifierType = 'Facility' then 1
"									when @modifierType = 'Physician' then 1"
"								    when @modifierType = 'Medicare' then 1 "
"										else 0 end"
                              ,0
                              ,1
                              ,sysdatetime()) ;
"	1	2020-09-17 08:36:02.7433333	mssql"
"226	42	MERGE_OPTUM-HCPCS-BASE-COVERAGE	declare @fileRequestId bigint = :fileRequestId ;"

declare @hcpcsLevel varchar(1) = '2' ;
declare @hcpcsLevelType varchar(10) = 'HCPCS' ;

#NAME?
#NAME?
drop table if exists #hcpcs ;

select h.hcpcsId
      ,o.fileRequestId
      ,o.code
      ,o.shortDescription
      ,o.longDescription
      ,o.fullDescription
      --,o.nonFacilityTotalRVU
      --,o.facilityTotalRVU
"	  ,case when upper(o.fullDescription) like '%UNSPECIFIED%' then 1 "
"	  	    when upper(o.fullDescription) like '%UNCLASSIFIED%' then 1"
"	  	    when upper(o.fullDescription) like '%UNLISTED %' then 1"
"	        when upper(o.fullDescription) like '%NOT OTHERWISE SPECIFIED%' then 1 "
"	        when upper(o.fullDescription) like '%NOT OTHERWISE CLASSIFIED%' then 1 "
"	        when upper(o.fullDescription) like '%NOT ELSEWHERE SPECIFIED%' then 1 "
"	        else 0 end nocFlag"
"	  ,case when h.hcpcsEffectiveDate is not null "
"	        then h.hcpcsEffectiveDate"
"	        when h.hcpcsId is null"
"	         and isnull(o.status, '~') <> 'D' "
"	  	  then dateadd(day, 0, replace(substring(fr.originalFileName, patindex('%[0-9][0-9][0-9][0-9][_][0-9][0-9]%', fr.originalFileName), 7), '_', '-') + '-01') end effectiveDate"
"	  ,case when o.status = 'D' then dateadd(day, -1, replace(substring(fr.originalFileName, patindex('%[0-9][0-9][0-9][0-9][_][0-9][0-9]%', fr.originalFileName), 7), '_', '-') + '-01') end terminationDate"
      ,h.hcpcsNocFlag
"	  ,h.hcpcsEffectiveDate"
      ,h.hcpcsTerminationDate
"	  ,case when h.hcpcsId is null"
              or o.shortDescription <> h.hcpcsShortDesc
              or o.longDescription <> h.hcpcsLongDesc
              or o.fullDescription <> h.hcpcsFullDesc
              --or isnull(o.facilityTotalRVU, -1) <> isnull(h.hcpcsTotalFacilityPractiveExpenseRvu, -1)
              --or isnull(o.nonFacilityTotalRVU, -1) <> isnull(h.hcpcsTotalNonFacilityPracticeExpenseRvu, -1) 
"	 	   then 1 "
"	 	   else 0 "
"	    end hasDiff"
   into #hcpcs
        --------------------------------
   from EdmStage.Optum_HCPCSBaseCoverage o 
        --------------------------------
   join EdmLib.FileRequest fr on o.fileRequestId = fr.fileRequestId
   left join Reference.Hcpcs h on o.code = h.hcpcsCode
"   						      and hcpcsLevel = @hcpcsLevel"

#NAME?
drop table if exists #hcpcs_diff ;

select *
  into #hcpcs_diff 
  from #hcpcs
 where hasDiff = 1
    or nocFlag <> hcpcsNocFlag
    or isnull(terminationDate, '9999-12-31') <> isnull(hcpcsTerminationDate, '9999-12-31') ;

-- truncate table Reference.HcpcsHistory ;
 
#NAME?
#NAME?
insert into Reference.HcpcsHistory
select h.*, sysdatetime() historyDateTime, @fileRequestId triggeringFileRequestId
  from #hcpcs_diff d
  join Reference.Hcpcs h on d.hcpcsId = h.hcpcsId;

declare @maxHcpcsId bigint ;
select @maxHcpcsId = max(hcpcsId)
  from Reference.Hcpcs ;

declare @currentHcpcsId bigint ;
select @currentHcpcsId = convert(bigint, current_value)
  from sys.sequences
 where object_id = object_id('Reference.HcpcsSeq') ;

if @maxHcpcsId > @currentHcpcsId
begin
"	print 'Re-sequencing ...'"
"	declare @reSequenceDDL varchar(500) = 'alter sequence Reference.HcpcsSeq restart with ' + convert(varchar(10), @maxHcpcsId + 1) ;"
"	exec sp_sqlexec @reSequenceDDL ;"
end ;

merge into Reference.Hcpcs m
using #hcpcs_diff u
   on m.hcpcsId = u.hcpcsId
 when matched then update
"	  set m.hcpcsShortDesc = u.shortDescription"
"		 ,m.hcpcsLongDesc = u.longDescription"
"		 ,m.hcpcsFullDesc = u.fullDescription"
"		 --,m.hcpcsTotalNonFacilityPracticeExpenseRvu = u.nonFacilityTotalRVU"
"		 --,m.hcpcsTotalFacilityPractiveExpenseRvu = u.facilityTotalRVU"
"		 ,m.hcpcsNocFlag = u.nocFlag"
"		 ,m.hcpcsEffectiveDate = u.effectiveDate"
"		 ,m.hcpcsTerminationDate = u.terminationDate"
"		 ,m.hcpcsUpdateDate = sysdatetime()"
 when not matched then insert
"		 (hcpcsCode"
"		 ,hcpcsLevel"
"		 ,hcpcsShortDesc"
"		 ,hcpcsLongDesc"
"		 ,hcpcsFullDesc"
"		 ,hcpcsEffectiveDate"
"		 ,hcpcsTerminationDate"
"		 --,hcpcsTotalNonFacilityPracticeExpenseRvu"
"		 --,hcpcsTotalFacilityPractiveExpenseRvu"
"		 ,hcpcsNocFlag"
"		 ,hcpcsLevelType"
"		 ,hcpcsActiveFlag"
"		 ,hcpcsCreateDate)"
"		 values"
"		 (u.code"
"		 ,@hcpcsLevel"
"		 ,u.shortDescription"
"		 ,u.longDescription"
"		 ,u.fullDescription"
"		 ,u.effectiveDate"
"		 ,u.terminationDate"
"		 --,u.nonFacilityTotalRVU"
"		 --,u.facilityTotalRVU"
"		 ,u.nocFlag"
"		 ,@hcpcsLevelType"
"		 ,1"
"		 ,sysdatetime()); "
"		 "
#NAME?
merge into Reference.Hcpcs m
using (select *
         from Reference.HcpcsOverride
        where hcpcsLevel = @hcpcsLevel
          and hcpcsActiveFlag = 1) u
   on m.hcpcsId = u.hcpcsId
  and m.hcpcsCode = u.hcpcsCode
  and m.hcpcsLevel = u.hcpcsLevel
" when matched then update set m.hcpcsCategoryId							= u.hcpcsCategoryId"
"                             ,m.hcpcsShortDesc							= u.hcpcsShortDesc"
"                             ,m.hcpcsLongDesc							= u.hcpcsLongDesc"
"                             ,m.hcpcsFullDesc							= u.hcpcsFullDesc"
"                             ,m.hcpcsEffectiveDate						= u.hcpcsEffectiveDate"
"                             ,m.hcpcsTerminationDate					= u.hcpcsTerminationDate"
"                             ,m.hcpcsTotalNonFacilityPracticeExpenseRvu	= u.hcpcsTotalNonFacilityPracticeExpenseRvu"
"                             ,m.hcpcsTotalFacilityPractiveExpenseRvu	= u.hcpcsTotalFacilityPractiveExpenseRvu"
"                             ,m.hcpcsReuseDate							= u.hcpcsReuseDate"
"                             ,m.hcpcsPreviousId							= u.hcpcsPreviousId"
"                             ,m.hcpcsStatus								= u.hcpcsStatus"
"                             ,m.hcpcsActiveFlag							= u.hcpcsActiveFlag"
"                             ,m.hcpcsCreateDate							= u.hcpcsCreateDate"
"                             ,m.hcpcsUpdateDate							= u.hcpcsUpdateDate"
"                             ,m.hcpcsNocInd								= u.hcpcsNocInd"
"                             ,m.hcpcsNocFlag							= u.hcpcsNocFlag"
"                             ,m.hcpcsLevelType							= u.hcpcsLevelType ; 	1	2020-09-17 14:26:08.2800000	mssql"
"227	42	MERGE_OPTUM-HCPCS-MODIFIER-XWALK	declare @fileRequestId bigint = :fileRequestId ;"

declare @hcpcsLevel varchar(1) = '2' ;

declare @modifierType varchar(20) ;

select @modifierType = case when originalFileName like '%OPTUM_%_MODIFIER_XWALK_FACILITY%' then 'Facility'
                            when originalFileName like '%OPTUM_%_MODIFIER_XWALK_PHYSICIAN%' then 'Physician'
                            when originalFileName like '%OPTUM_%_MODIFIER_XWALK_MEDICARE%' then 'Medicare'
                            when originalFileName like '%OPTUM_%_MODIFIER_XWALK_AMBULANCE%' then 'Ambulance'
                            when originalFileName like '%OPTUM_%_MODIFIER_XWALK_DME%' then 'DME'
                           end
  from EdmLib.FileRequest
 where fileRequestId = @fileRequestId ;
 
#NAME?
insert into Reference.HcpcsModifier 
select qt3.hcpcsModifierId
      ,qt3.hcpcsId
      ,qt3.modifierId
      ,'TELLIGEN' hcpcsModifierType
      ,qt3.hcpcsModifierAmbulanceFlag
      ,qt3.hcpcsModifierDmeFlag
      ,qt3.hcpcsModifierProcFlag
      ,0 hcpcsModifierAddOnFlag
      ,qt3.hcpcsModifierActiveFlag
      ,qt3.hcpcsModifierCreateDate
      ,qt3.hcpcsModifierUpdateDate
  from QTIP.Reference.HcpcsModifier qt3
  left join Reference.HcpcsModifier paw
         on qt3.hcpcsModifierId = paw.hcpcsModifierId
  where paw.hcpcsModifierId is null
"	and qt3.hcpcsModifierId >= 10"
 order by 1 desc ;


#NAME?
drop table if exists #hcpcs_modifier ;

select distinct modifier, description
  into #hcpcs_modifier
  from EdmStage.Optum_HcpcsModifierXwalk ;

merge into Reference.Modifier m
using #hcpcs_modifier u
   on m.modifierCode = u.modifier
  and m.modifierDesc = u.description
  and m.modifieractiveflag = 1
 when matched then update set m.modifierUpdateDate = case when m.modifierActiveFlag = 0 or m.modifierDesc <> u.description then sysdatetime() else m.modifierUpdateDate end
                             ,m.modifierActiveFlag = 1
                             ,m.modifierAmbulanceFlag = case when @modifierType = 'Ambulance' then 1 else m.modifierAmbulanceFlag end
                             ,m.modifierDesc = u.description
 when not matched then insert (modifierCode
                              ,modifierDesc
                              ,modifierAmbulanceFlag
                              ,modifierCreateDate
                              ,modifierActiveFlag)
                       values (u.modifier
                              ,u.description
                              ,case when @modifierType = 'Ambulance' then 1 else 0 end
                              ,sysdatetime()
                              ,1) ;

#NAME?
merge into Reference.Modifier m
using Reference.ModifierOverride u
   on m.modifierId = u.modifierId
  and m.modifierCode = u.modifierCode
 when matched then update set m.hcpcsLevel                        = u.hcpcsLevel
                             ,m.modifierName              = u.modifierName
                             ,m.modifierDesc              = u.modifierDesc
                             ,m.modifierAmbulanceFlag = u.modifierAmbulanceFlag
                             ,m.modifierCreateDate        = u.modifierCreateDate
                             ,m.modifierActiveFlag        = u.modifierActiveFlag
                             ,m.modifierUpdateDate        = u.modifierUpdateDate ;

#NAME?
#NAME?
#NAME?
#NAME?
drop table if exists #hcpcs_modifier_xwalk_hcpcs ;

select distinct code
  into #hcpcs_modifier_xwalk_hcpcs
  from EdmStage.Optum_HcpcsModifierXwalk ;

declare @missingHcpcsCount int ;
select @missingHcpcsCount = count(*)
  from #hcpcs_modifier_xwalk_hcpcs x
  left join Reference.Hcpcs h on x.code = h.hcpcsCode
                             and h.hcpcsLevel = @hcpcsLevel
 where h.hcpcsId is null ;

if @missingHcpcsCount > 0
        throw 51000, 'HCPCS-Modifier-Xwalk: Missing HCPCS.  Be sure to load the Hcpcs file first', 16 ;


#NAME?
#NAME?
#NAME?
drop table if exists #hcpcs_modifier_update ;

select x.*
      ,h.hcpcsId
          ,m.modifierId
          ,hm.hcpcsModifierId
          ,case when hm.hcpcsModifierId is null then 'New'
                when hm.hcpcsModifierActiveFlag = 0 then 'Reactivate'
                when hm.hcpcsModifierType not like '%'+ @modifierType + '%'
                  or (hm.hcpcsModifierType is null and @modifierType is NOT null) then 'New-Modifier-Type'
           end updateStatus
  into #hcpcs_modifier_update
  from EdmStage.Optum_HcpcsModifierXwalk x
  join Reference.Hcpcs h on x.code = h.hcpcsCode
                        and h.hcpcsLevel = @hcpcsLevel
  join Reference.Modifier m on x.modifier = m.modifierCode
  left join Reference.HcpcsModifier hm on h.hcpcsId = hm.hcpcsId
                                      and m.modifierId = hm.modifierId
 where hm.hcpcsModifierId is null
    or hm.hcpcsModifierActiveFlag = 0
        or (hm.hcpcsModifierType not like '%'+ @modifierType + '%'
         or (hm.hcpcsModifierType is null and @modifierType is NOT null));

insert
  into Reference.HcpcsModifierHistory
select hm.*
      ,sysdatetime() historyDateTime
          ,@fileRequestId triggeringFileRequestId
  from #hcpcs_modifier_update u
  join Reference.HcpcsModifier hm on u.hcpcsModifierId = hm.hcpcsModifierId ;

merge into Reference.HcpcsModifier m
using #hcpcs_modifier_update u
   on m.hcpcsModifierId = u.hcpcsModifierId
 when matched then update set m.hcpcsModifierType = case when m.hcpcsModifierType is null then @modifierType
                                                         when m.hcpcsModifierType not like '%' + @modifierType + '%' then m.hcpcsModifierType +','+ @modifierType
                                                                                                                 else m.hcpcsModifierType
                                                                                                        end
                             ,m.hcpcsModifierAmbulanceFlag = case when @modifierType = 'Ambulance' then 1 else m.hcpcsModifierAmbulanceFlag end
                             ,m.hcpcsModifierDmeFlag = case when @modifierType = 'DME' then 1 else m.hcpcsModifierDmeFlag end
"							 ,m.hcpcsModifierProcFlag = case when @modifierType = 'Facility' then 1"
"															 when @modifierType = 'Physician' then 1"
"															 when @modifierType = 'Medicare' then 1 "
"															else m.hcpcsModifierProcFlag end"
                             ,m.hcpcsModifierAddOnFlag = 0
                             ,m.hcpcsModifierActiveFlag = 1
                             ,m.hcpcsModifierUpdateDate = sysdatetime()
 when not matched then insert (hcpcsId
                              ,modifierId
                              ,hcpcsModifierType
                              ,hcpcsModifierAmbulanceFlag
                              ,hcpcsModifierDmeFlag
                              ,hcpcsModifierProcFlag
                              ,hcpcsModifierAddOnFlag
                              ,hcpcsModifierActiveFlag
                              ,hcpcsModifierCreateDate)
                       values (u.hcpcsId
                              ,u.modifierId
                              ,@modifierType
                              ,case when @modifierType = 'Ambulance' then 1 else 0 end
                              ,case when @modifierType = 'DME' then 1 else 0 end
                              ,case when @modifierType = 'Facility' then 1
"									when @modifierType = 'Physician' then 1"
"								    when @modifierType = 'Medicare' then 1 "
"										else 0 end"
                              ,0
                              ,1
"                              ,sysdatetime()) ; 	1	2020-09-17 14:30:25.7966667	mssql"
"228	42	MERGE_OPTUM-HCPCS-MODIFIER-XWALK-FACILITY	-- ACTIVE CODE, but do NOT use EdmStage.Optum_HCPCSModifierXWalkFacility.level, use @hcpcsLevel instead"

declare @fileRequestId bigint = :fileRequestId ;

declare @hcpcsLevel varchar(1) = '2' ;

declare @modifierType varchar(20) ;

select @modifierType = case when originalFileName like '%OPTUM_%_MODIFIER_XWALK_FACILITY%' then 'Facility'
                            when originalFileName like '%OPTUM_%_MODIFIER_XWALK_PHYSICIAN%' then 'Physician'
                            when originalFileName like '%OPTUM_%_MODIFIER_XWALK_MEDICARE%' then 'Medicare'
                            when originalFileName like '%OPTUM_%_MODIFIER_XWALK_AMBULANCE%' then 'Ambulance'
                            when originalFileName like '%OPTUM_%_MODIFIER_XWALK_DME%' then 'DME'
"	                   end        "
  from EdmLib.FileRequest
 where fileRequestId = @fileRequestId ;

#NAME?
drop table if exists #hcpcs_modifier ;

select distinct modifier, description, ambulanceFlag
  into #hcpcs_modifier
  from EdmStage.Optum_HCPCSModifierXWalkFacility
 where code not like 'D%' ;

merge into Reference.Modifier m
using #hcpcs_modifier u
   on m.modifierCode = u.modifier 
  and m.modifierDesc = u.description
  and m.modifieractiveflag = 1
 when matched then update set m.modifierUpdateDate = case when m.modifierActiveFlag = 0 or (m.modifierAmbulanceFlag = 0 and  u.ambulanceFlag = 1) then sysdatetime() else m.modifierUpdateDate end
                             ,m.modifierActiveFlag = 1
"							 ,m.modifierAmbulanceFlag = case when u.ambulanceFlag = 1 then 1 else m.modifierAmbulanceFlag end"
 when not matched then insert (modifierCode
                              ,modifierDesc
"							  ,modifierAmbulanceFlag"
"							  ,modifierCreateDate"
"							  ,modifierActiveFlag)"
                       values (u.modifier
"					          ,u.description"
"							  ,case when u.ambulanceFlag = 1 then 1 else 0 end"
"							  ,sysdatetime()"
"							  ,1) ;"

#NAME?
merge into Reference.Modifier m
using Reference.ModifierOverride u
   on m.modifierId = u.modifierId
  and m.modifierCode = u.modifierCode
" when matched then update set m.hcpcsLevel			  = u.hcpcsLevel"
"                             ,m.modifierName		  = u.modifierName"
"                             ,m.modifierDesc		  = u.modifierDesc"
                             ,m.modifierAmbulanceFlag = u.modifierAmbulanceFlag
"                             ,m.modifierCreateDate	  = u.modifierCreateDate"
"                             ,m.modifierActiveFlag	  = u.modifierActiveFlag"
"                             ,m.modifierUpdateDate	  = u.modifierUpdateDate ;"

#NAME?
#NAME?
#NAME?
#NAME?
drop table if exists #hcpcs_modifier_xwalk_hcpcs ;

select distinct code
  into #hcpcs_modifier_xwalk_hcpcs
  from EdmStage.Optum_HCPCSModifierXWalkFacility 
 where code not like 'D%' ;

declare @missingHcpcsCount int ;
select @missingHcpcsCount = count(*)
  from #hcpcs_modifier_xwalk_hcpcs x
  left join Reference.Hcpcs h on x.code = h.hcpcsCode
                             and h.hcpcsLevel = @hcpcsLevel 
 where h.hcpcsId is null ;

if @missingHcpcsCount > 0
"	throw 51000, 'HCPCS-Modifier-Xwalk-Facility: Missing HCPCS.  Be sure to load the HCPCS file first', 16 ;"

#NAME?
#NAME?
#NAME?
drop table if exists #hcpcs_modifier_update ;

select x.*
      ,h.hcpcsId
"	  ,m.modifierId"
"	  ,hm.hcpcsModifierId"
"	  ,case when hm.hcpcsModifierId is null then 'New'"
"	        when hm.hcpcsModifierActiveFlag = 0 then 'Reactivate'"
"			when hm.hcpcsModifierType not like '%'+ @modifierType + '%' "
"	          or (hm.hcpcsModifierType is null and @modifierType is NOT null) then 'New-Modifier-Type'"
"	   end updateStatus"
  into #hcpcs_modifier_update
  from EdmStage.Optum_HCPCSModifierXWalkFacility x
  join Reference.Hcpcs h on x.code = h.hcpcsCode
                        and h.hcpcsLevel = @hcpcsLevel
  join Reference.Modifier m on x.modifier = m.modifierCode
  left join Reference.HcpcsModifier hm on h.hcpcsId = hm.hcpcsId
                                      and m.modifierId = hm.modifierId
 where hm.hcpcsModifierId is null 
    or hm.hcpcsModifierActiveFlag = 0
"	or (hm.hcpcsModifierType not like '%'+ @modifierType + '%' "
"	 or (hm.hcpcsModifierType is null and @modifierType is NOT null));"

insert
  into Reference.HcpcsModifierHistory 
select hm.*
      ,sysdatetime() historyDateTime
"	  ,@fileRequestId triggeringFileRequestId"
  from #hcpcs_modifier_update u
  join Reference.HcpcsModifier hm on u.hcpcsModifierId = hm.hcpcsModifierId ;

merge into Reference.HcpcsModifier m
using #hcpcs_modifier_update u
   on m.hcpcsModifierId = u.hcpcsModifierId
 when matched then update set m.hcpcsModifierType = case when m.hcpcsModifierType is null then @modifierType
                                                         when m.hcpcsModifierType not like '%' + @modifierType + '%' then m.hcpcsModifierType +','+ @modifierType
"														else m.hcpcsModifierType"
                                                    end
                             ,m.hcpcsModifierAmbulanceFlag = case when @modifierType = 'Ambulance' then 1 else m.hcpcsModifierAmbulanceFlag end
                             ,m.hcpcsModifierDmeFlag = case when @modifierType = 'DME' then 1 else m.hcpcsModifierDmeFlag end
"							 ,m.hcpcsModifierProcFlag = case when @modifierType = 'Facility' then 1"
"															 when @modifierType = 'Physician' then 1"
"															 when @modifierType = 'Medicare' then 1 "
"															else m.hcpcsModifierProcFlag end"
                             ,m.hcpcsModifierAddOnFlag = 0
                             ,m.hcpcsModifierActiveFlag = 1
                             ,m.hcpcsModifierUpdateDate = sysdatetime()
 when not matched then insert (hcpcsId
                              ,modifierId
                              ,hcpcsModifierType
                              ,hcpcsModifierAmbulanceFlag
                              ,hcpcsModifierDmeFlag
                              ,hcpcsModifierProcFlag
                              ,hcpcsModifierAddOnFlag
                              ,hcpcsModifierActiveFlag
                              ,hcpcsModifierCreateDate)
                       values (u.hcpcsId
                              ,u.modifierId
                              ,@modifierType
                              ,case when @modifierType = 'Ambulance' then 1 else 0 end
                              ,case when @modifierType = 'DME' then 1 else 0 end
                              ,case when @modifierType = 'Facility' then 1
"									when @modifierType = 'Physician' then 1"
"								    when @modifierType = 'Medicare' then 1 "
"										else 0 end"
                              ,0
                              ,1
"                              ,sysdatetime()) ;	1	2020-09-17 14:49:10.6533333	mssql"
"229	43	MERGE_MEDISPAN_NDC-01-STAGE	-- SqlData - Medispan NDC.sql"

declare @fileRequestId bigint = :fileRequestId;

drop table if exists ##medispan_ndc_dedup;

select *
into ##medispan_ndc_dedup
from (
"	select *, rank() over(partition by ndc_upc_hri order by fileRequestId desc) rn"
"	from EdmStage.MediSpan_NDC_History"
"	where fileRequestId <= @fileRequestId"
) x
where x.rn = 1
;

drop table if exists EdmReference.Medispan_NDC;

select *
into EdmReference.Medispan_NDC
from ##medispan_ndc_dedup
;

drop table if exists ##medispan_ndc_name_dedup;

select *
into ##medispan_ndc_name_dedup
from (
"	select *"
"	--, rank() over(partition by drugDescriptorIdentifier, genericProductIdentifier, knowledgeBaseDrugCode order by fileRequestId desc) rn"
"	, rank() over(partition by drugDescriptorIdentifier, genericProductIdentifier order by fileRequestId desc) rn"
"	from EdmStage.MediSpan_NDC_Name_History"
"	where fileRequestId <= @fileRequestId"
) x
where x.rn = 1
;

drop table if exists EdmReference.Medispan_NDC_TCGPI;

select *
into EdmReference.Medispan_NDC_TCGPI 
from (
"	select *, rank() over(partition by tcGpiKey, recordType, tcLevelCode order by fileRequestId desc) rn"
"	from EdmStage.MediSpan_NDC_TCGPI_History"
"	where fileRequestId <= @fileRequestId"
) x
where x.rn = 1
;

drop table if exists ##medispan_ndc_labeler_dedup;

select *
into ##medispan_ndc_labeler_dedup
from (
"	select *, rank() over(partition by medispanLabelerIdentifier order by fileRequestId desc) rn"
"	from EdmStage.MediSpan_NDC_Labeler_History"
"	where fileRequestId <= @fileRequestId"
) x
where x.rn = 1
;

declare @labelerDuplicateCount int;
select @labelerDuplicateCount = count(*)
from (
"	select medispanLabelerIdentifier"
"	from ##medispan_ndc_labeler_dedup"
"	group by medispanLabelerIdentifier"
"	having count(*) > 1"
) x
;

declare @errorMessage varchar(500) = 'There exists ' +convert(varchar(10), @labelerDuplicateCount) + ' duplicate labeler identifier(s).';

if @labelerDuplicateCount > 0
"	throw 51000, @errorMessage, 16;"

drop table if exists ##medispan_ndc_generic_product_identifier_dedup;

select *
into ##medispan_ndc_generic_product_identifier_dedup
from (
"	select *,rank() over(partition by genericProductIdentifier order by fileRequestId desc) rn"
"	from EdmStage.MediSpan_NDC_GenericProductPackaging_History"
"	where fileRequestId <= @fileRequestId"
) x
where x.rn = 1
;

drop table if exists EdmReference.Medispan_NDC_GenericProductIdentifier ;

select
"	gpi.stageId"
"	, gpi.genericProductIdentifier"
"	, gpi.genericProductPackagingCode"
"	, gpi.packageDescriptionCode"
"	, case gpi.packageDescriptionCode "
"		when 'AMP' then 'Ampule'"
"		when 'BG' then 'Bag'"
"		when 'BL' then 'Blister'"
"		when 'BO' then 'Bottle'"
"		when 'BX' then 'Box'"
"		when 'CN' then 'Can'"
"		when 'CP' then 'Cup'"
"		when 'CR' then 'Cartridge'"
"		when 'CT' then 'Cartridge'"
"		when 'DP' then 'Disp Pack'"
"		when 'DR' then 'Drum'"
"		when 'FC' then 'Flex Cont'"
"		when 'GC' then 'Glass Cont'"
"		when 'IH' then 'Inhaler'"
"		when 'JR' then 'Jar'"
"		when 'PB' then 'Pump Btl'"
"		when 'PC' then 'Plas Cont'"
"		when 'PD' then 'Punchcard'"
"		when 'PG' then 'Package'"
"		when 'PK' then 'Packet'"
"		when 'PN' then 'Pen'"
"		when 'RL' then 'Roll'"
"		when 'SB' then 'Spray Btl'"
"		when 'SH' then 'Sachet'"
"		when 'SK' then 'Stick'"
"		when 'SR' then 'Syringe'"
"		when 'TB' then 'Tube'"
"		when 'VL' then 'Vial'"
"	end packageName"
"	, try_convert(varchar(10), try_convert(int, gpi.packageSize)) packageSize"
"	, gpi.packageSizeUOM"
"	--, gpi.*"
into EdmReference.Medispan_NDC_GenericProductIdentifier
from ##medispan_ndc_generic_product_identifier_dedup gpi
;

drop table if exists ##medispan_ndc_final;

select
"	ndc.ndc_upc_hri ndcCode"
"	, ndc.stageId ndcStageId"
"	, g.stageId tcGpiStageId"
"	, gpi.stageId gpiStageId"
"	, g2.tcGpiName drugGroupName"
"	, g2.tranCode drugGroupTransactionCode"
"	, n.genericProductIdentifier"
"	, ndc.genericProductPackagingCode"
"	, gpi.packageSize"
"	, gpi.packageSizeUOM"
"	, gpi.packageDescriptionCode"
"	, gpi.packageName"
"	, g.TcGpiKey drugClassCodeFull"
"	, left(g.TcGpiKey, 4) drugClassCode"
"	, g4.tcGpiName drugClassName"
"	, g4.tranCode drugClassTransactionCode"
"	, left(g.TcGpiKey, 6) drugSubClassCode"
"	, g6.tcGpiName drugSubClassName"
"	, g6.tranCode drugSubClassTransactionCode"
"	, g.tcGpiKey"
"	, g.tcGpiName"
"	, g.recordType"
"	, g.tcLevelCode"
"	, g.tranCode tcGpiTransactionCode"
"	, n.drugDescriptorIdentifier"
"	, n.drugName"
"	, n.routeAdmin routeOfAdministration"
"	, n.dosageForm dosageFormCode"
"	, case n.dosageForm "
"		when 'AEPB' then 'Aero Pow Br Act'"
"		when 'AERB' then 'Aero Breath Act'"
"		when 'AERO' then 'Aerosol'"
"		when 'AERP' then 'Aerosol Powder'"
"		when 'AERS' then 'Aerosol Soln'"
"		when 'AJKT' then '[AJKT]'"
"		when 'AUIJ' then 'Auto-injector'"
"		when 'BAR' then 'Bar'"
"		when 'BEAD' then 'Beads'"
"		when 'C12A' then 'Cap 12HR Deter'"
"		when 'C4PK' then 'CP24 Ther Pack'"
"		when 'CAPS' then 'Capsule'"
"		when 'CART' then 'Cartridge'"
"		when 'CHER' then '[CHER]'"
"		when 'CHEW' then 'Tablet Chewable'"
"		when 'CONC' then 'Concentrate'"
"		when 'CP12' then 'Capsule ER 12HR'"
"		when 'CP24' then 'Capsule ER 24HR'"
"		when 'CPCR' then 'Capsule ER'"
"		when 'CPDR' then 'Capsule DR'"
"		when 'CPEP' then 'Capsule DR Part'"
"		when 'CPPK' then 'Cap Ther Pack'"
"		when 'CPSP' then 'Cap Sprinkle'"
"		when 'CREA' then 'Cream'"
"		when 'CRYS' then 'Crystals'"
"		when 'CS24' then 'CP24 Sprinkle'"
"		when 'CSDR' then '[CSDR]'"
"		when 'DEVI' then 'Device'"
"		when 'DISK' then 'Disk'"
"		when 'DPRH' then 'Diaphragm'"
"		when 'ELIX' then 'Elixir'"
"		when 'EMUL' then 'Emulsion'"
"		when 'ENEM' then 'Enema'"
"		when 'EXHP' then '[EXHP]'"
"		when 'EXTR' then 'Fl Extract'"
"		when 'FILM' then 'Film'"
"		when 'FLAK' then 'Flakes'"
"		when 'FOAM' then 'Foam'"
"		when 'GAS' then 'Gas'"
"		when 'GEL' then 'Gel'"
"		when 'GRAN' then 'Granules'"
"		when 'GREF' then 'Granules Effer'"
"		when 'GUM' then 'Gum'"
"		when 'IMPL' then 'Implant'"
"		when 'INHA' then 'Inhaler'"
"		when 'INJ' then 'Injectable'"
"		when 'INST' then 'Insert'"
"		when 'IUD' then 'IUD'"
"		when 'JTAJ' then 'Jet-injector'"
"		when 'KIT' then 'Kit'"
"		when 'LEAV' then 'Leaves'"
"		when 'LIQD' then 'Liquid'"
"		when 'LOTN' then 'Lotion'"
"		when 'LOZG' then 'Lozenge'"
"		when 'LPOP' then 'Lollipop'"
"		when 'LQCR' then 'Liquid ER'"
"		when 'LQPK' then 'Liqd Ther Pack'"
"		when 'MISC' then 'Misc'"
"		when 'NEBU' then 'Nebu Soln'"
"		when 'OIL' then 'Oil'"
"		when 'OINT' then 'Ointment'"
"		when 'PACK' then 'Packet'"
"		when 'PADS' then 'Pad'"
"		when 'PDEF' then 'Powder Effer'"
"		when 'PEN' then 'Pen-injector'"
"		when 'PLLT' then 'Pellet'"
"		when 'PNKT' then '[PNKT]'"
"		when 'POWD' then 'Powder'"
"		when 'PRSY' then 'Prefilled Syr'"
"		when 'PSKT' then '[PSKT]'"
"		when 'PSTE' then 'Paste'"
"		when 'PT24' then 'Patch 24HR'"
"		when 'PT72' then 'Patch 72HR'"
"		when 'PTCH' then 'Patch'"
"		when 'PTTW' then 'Patch Biweekly'"
"		when 'PTWK' then 'Patch Weekly'"
"		when 'PUDG' then 'Pudding'"
"		when 'RING' then 'Ring'"
"		when 'SHAM' then 'Shampoo'"
"		when 'SHEE' then 'Sheet'"
"		when 'SOAJ' then 'Soln Auto-inj'"
"		when 'SOCT' then 'Soln Cartridge'"
"		when 'SOLG' then 'Gel Form Soln'"
"		when 'SOLN' then 'Solution'"
"		when 'SOLR' then 'For Solution'"
"		when 'SOPK' then 'Soln Ther Pack'"
"		when 'SOPN' then 'Soln Pen-inj'"
"		when 'SOSY' then 'Soln Pref Syr'"
"		when 'SOTJ' then 'Soln Jet-inj'"
"		when 'SPRT' then 'Spirit'"
"		when 'SRER' then 'For Suspension'"
"		when 'STCK' then 'Stick'"
"		when 'STRP' then 'Strip'"
"		when 'SUBL' then 'Tab Sublingual'"
"		when 'SUER' then '[SUER]'"
"		when 'SUPN' then 'Susp-Pen-inj'"
"		when 'SUPP' then 'Suppository'"
"		when 'SUSP' then 'Suspension'"
"		when 'SUSR' then 'For Suspension'"
"		when 'SUSY' then 'Susp Pref Syr'"
"		when 'SWAB' then 'Swab'"
"		when 'SYRP' then 'Syrup'"
"		when 'T12A' then 'Tab 12HR Deter'"
"		when 'T24A' then 'Tab 24HR Deter'"
"		when 'TABA' then 'Tab Abuse Deter'"
"		when 'TABS' then 'Tablet'"
"		when 'TAMP' then 'Tampon'"
"		when 'TAPE' then 'Tape'"
"		when 'TAR' then 'Tar'"
"		when 'TB12' then 'Tablet ER 12HR'"
"		when 'TB24' then 'Tablet ER 24HR'"
"		when 'TB3D' then '[TB3D]'"
"		when 'TBCR' then 'Tablet ER'"
"		when 'TBDD' then 'Tablet Disperse'"
"		when 'TBDP' then 'Tablet Disperse'"
"		when 'TBEA' then 'Tab ER Deter'"
"		when 'TBEC' then 'Tablet DR'"
"		when 'TBED' then '[TBED]'"
"		when 'TBEF' then 'Tablet Effer'"
"		when 'TBPK' then 'Tab Ther Pack'"
"		when 'TBSO' then 'Tablet Soluble'"
"		when 'TEST' then 'Test'"
"		when 'THPK' then 'Therapy Pack'"
"		when 'TINC' then 'Tincture'"
"		when 'TROC' then 'Troche'"
"		when 'WAFR' then 'Wafer'"
"		when 'WAX' then 'Wax'"
"		end dosageFormName"
"	, case n.dosageForm"
"		when 'AEPB' then 'Aerosol Powder, Breath Activated'"
"		when 'AERB' then 'Aerosol, Breath Activated'"
"		when 'AERO' then 'Aerosol'"
"		when 'AERP' then 'Aerosol, Powder'"
"		when 'AERS' then 'Aerosol, Solution'"
"		when 'AUIJ' then 'Auto-injector'"
"		when 'BEAD' then 'Beads'"
"		when 'C12A' then 'Capsule ER 12 Hour Abuse-Deterrent'"
"		when 'C4PK' then 'Capsule ER 24 Hour Therapy Pack'"
"		when 'CAPS' then 'Capsule'"
"		when 'CART' then 'Cartridge'"
"		when 'CHEW' then 'Tablet Chewable'"
"		when 'CONC' then 'Concetrate'"
"		when 'CP12' then 'Capsule Extended Release 12 Hour'"
"		when 'CP24' then 'Capsule Extended Release 24 Hour'"
"		when 'CPCR' then 'Capsule Extended Release'"
"		when 'CPDR' then 'Capsule Delayed Release'"
"		when 'CPEP' then 'Capsule Delayed Release Particles'"
"		when 'CPPK' then 'Capsule TherapyPack'"
"		when 'CPSP' then 'Capsule Sprinkle'"
"		when 'CREA' then 'Cream'"
"		when 'CRYS' then 'Crystals'"
"		when 'CS24' then 'Capsule ER 24 Hour Sprinkle'"
"		when 'DEVI' then 'Device'"
"		when 'DPRH' then 'Diaphragm'"
"		when 'ELIX' then 'Elixir'"
"		when 'EMUL' then 'Emulsion'"
"		when 'ENEM' then 'Enema'"
"		when 'EXTR' then 'Fluid Extract'"
"		when 'FLAK' then 'Flakes'"
"		when 'GEL' then 'Gel'"
"		when 'GRAN' then 'Granules'"
"		when 'GREF' then 'Granules Effervescent'"
"		when 'IMPL' then 'Implant'"
"		when 'INHA' then 'Inhaler'"
"		when 'INJ' then 'Injectable'"
"		when 'INST' then 'Insert'"
"		when 'IUD' then 'Intrauterine Device'"
"		when 'JTAJ' then 'Jet-injector (Needleless)'"
"		when 'LEAV' then 'Leaves'"
"		when 'LIQD' then 'Liquid'"
"		when 'LOTN' then 'Lotion'"
"		when 'LOZG' then 'Lozenge'"
"		when 'LPOP' then 'Lollipops'"
"		when 'LQCR' then 'Liquid Extended-Release'"
"		when 'LQPK' then 'Liquid Therapy Pack'"
"		when 'MISC' then 'Miscellaneous'"
"		when 'NEBU' then 'Nebulization Solution'"
"		when 'OINT' then 'Ointment'"
"		when 'PACK' then 'Packet'"
"		when 'PDEF' then 'Powder Effervescent'"
"		when 'PEN' then 'Pen-injector'"
"		when 'PLLT' then 'Pellet'"
"		when 'POWD' then 'Powder'"
"		when 'PRSY' then 'Prefilled Syringe'"
"		when 'PSTE' then 'Paste'"
"		when 'PT24' then 'Patch 24 HR'"
"		when 'PT72' then 'Patch 72 HR'"
"		when 'PTCH' then 'Patch'"
"		when 'PTTW' then 'Patch Biweekly'"
"		when 'PTWK' then 'Patch Weekly'"
"		when 'PUDG' then 'Pudding'"
"		when 'SHAM' then 'Shampoo'"
"		when 'SHEE' then 'Sheet'"
"		when 'SOAJ' then 'Solution Autoinjector'"
"		when 'SOCT' then 'Solution Cartridge'"
"		when 'SOLG' then 'Gel Foaming Solution'"
"		when 'SOLN' then 'Solution'"
"		when 'SOLR' then 'Solution Reconstituted'"
"		when 'SOPK' then 'Solution Therapy Pack'"
"		when 'SOPN' then 'Solution Peninjector'"
"		when 'SOSY' then 'Solution Prefilled Syringe'"
"		when 'SOTJ' then 'Solution Jetinjector'"
"		when 'SPRT' then 'Spirit'"
"		when 'SRER' then 'Suspension Reconstituted'"
"		when 'STCK' then 'Stick'"
"		when 'STRP' then 'Strip'"
"		when 'SUBL' then 'Tablet Sublingual'"
"		when 'SUPN' then 'Suspension Peninjector'"
"		when 'SUPP' then 'Suppository'"
"		when 'SUSP' then 'Suspension'"
"		when 'SUSR' then 'Suspension Reconstituted'"
"		when 'SUSY' then 'Suspension Prefilled Syringe'"
"		when 'SYRP' then 'Syrup'"
"		when 'T12A' then 'Tablet ER 12 Hour Abuse-Deterrent'"
"		when 'T24A' then 'Tablet ER 24 Hour Abuse-Deterrent'"
"		when 'TABA' then 'Tablet Abuse-Deterrent'"
"		when 'TABS' then 'Tablet'"
"		when 'TAMP' then 'Tampon'"
"		when 'TB12' then 'Tablet Extended Release 12 HR'"
"		when 'TB24' then 'Tablet Extended Release 24 HR'"
"		when 'TBCR' then 'Tablet Extended-Release'"
"		when 'TBDP' then 'Tablet Dispersible'"
"		when 'TBEA' then 'Tablet Extended Release Abuse-Deterrent'"
"		when 'TBEC' then 'Tablet Delayed Release'"
"		when 'TBEF' then 'Tablet Effervescent'"
"		when 'TBPK' then 'Tablet Therapy Pack'"
"		when 'TBSO' then 'Tablet Soluble'"
"		when 'TEST' then 'Diagnostic Test'"
"		when 'THPK' then 'Therapy Pack'"
"		when 'TINC' then 'Tincture'"
"		when 'TROC' then 'Troche'"
"		when 'WAFR' then 'Wafer'"
"		end dosageFormDesc"
"	, n.strength"
"	, n.strengthUnitOfMeasure"
"	, case n.bioequ "
"		when 'A' then 'Products in same GPI are equivalent'"
"		when 'B' then 'Products in same GPI are not equivalent'"
"		when 'C' then 'Products may or may not be equivalent'"
"		when 'N' then 'Equivalency determination not available'"
"		when 'U' then 'Undeterminable (obsolete)' "
"		end bioequivalence"
"	, n.brandCode brandNameCode"
"	, n.nameSr nameSourceCode"
"	, n.tranCode drugNameTransactionCode"
"	--"
"	, ndc.ndc_upc_hri ndcUpcHri "
"	, case ndc.idNoCode --IdNumberFormatCode "
"		when 1 then '4-4-2'"
"		when 2 then '5-3-2'"
"		when 3 then '5-4-1'"
"		when 4 then '4-6'"
"		when 5 then '5-5'"
"		when 6 then '5-4-2' "
"		end idNumberFormat"
"	, case ndc.idNoCode --IdNumberFormatCode"
"		when 4 then 'HRI'"
"		when 5 then 'UPC or HRI'"
"		else 'NDC'"
"		end idType"
"	, ndc.old_ndc_upc_hri oldNdcUpcHri"
"	, ndc.new_ndc_upc_hri newNdcUpcHri"
"	, ndc.mediSpanLabelerIdentifier"
"	, l.manufacturerLabelerName"
"	, ndc.nameCode nameTypeCode"
"	, case ndc.nameCode -- NameTypeCode "
"		when 'G' then 'Generic Name'"
"		when 'T' then 'Trademarked Name'"
"		when 'B' then 'Branded Generic Name' "
"		end nameType"
"	, ndc.oldEffectiveDate"
"	, ndc.newEffectiveDate"
"	, ndc.nextSmNDCName nextSmallerNdcSuffixNumber"
"	, ndc.nextLgNDCName nextLargerNdcSuffixNumber"
"	, case ndc.itemSt --ItemStatusFlag"
"		when 'A' then 'Active'"
"		when 'I' then 'Inactive'"
"		when 'O' then 'Override'"
"		when 'Z' then 'Inactive Greater than 48 Months'"
"		end itemStatus"
"	, ndc.rxOTCin otcStatus"
"	, ndc.tranCode ndcTransactionCode"
"	, @fileRequestId triggeringFileRequestId"
"	, sysdatetime() refreshDateTime"
into ##medispan_ndc_final
from ##medispan_ndc_dedup ndc
join ##medispan_ndc_name_dedup n on ndc.drugDescriptorIdentifier = n.drugDescriptorIdentifier
join EdmReference.Medispan_NDC_TCGPI g on n.genericProductIdentifier = g.TcGpiKey
join EdmReference.Medispan_NDC_TCGPI g2 on g2.tcLevelCode = '02' and left(g.tcGpiKey, 2) = g2.tcGpiKey
join EdmReference.Medispan_NDC_TCGPI g4 on g4.tcLevelCode = '04' and left(g.tcGpiKey, 4) = g4.tcGpiKey
join EdmReference.Medispan_NDC_TCGPI g6 on g6.tcLevelCode = '06' and left(g.tcGpiKey, 6) = g6.tcGpiKey
left join EdmReference.Medispan_NDC_GenericProductIdentifier gpi
"	on n.genericProductIdentifier = gpi.genericProductIdentifier"
"	and ndc.genericProductPackagingCode = gpi.genericProductPackagingCode"
left join ##medispan_ndc_labeler_dedup l on ndc.medispanLabelerIdentifier = l.medispanLabelerIdentifier
;

drop table if exists EdmReference.Medispan_NDC_All;
 
select row_number() over(partition by 1 order by ndcCode) medispanId, *
into EdmReference.Medispan_NDC_All
from ##medispan_ndc_final
;
"	1	2020-09-17 15:42:33.0766667	mssql"
"230	42	MERGE_OPTUM-HCPCS-CATEGORY	declare @fileRequestId bigint = :fileRequestId ;"

declare @hcpcsLevel varchar(1) = '2' ;
declare @hcpcsLevelType varchar(10) = 'HCPCS' ;

drop table if exists #hcpcs_category_temp0 ;

select x.stageId
      ,x.fileRequestId
"	  ,x.code"
"	  ,x.codeDescription"
"	  --,x.nonFacilityTotalRVU"
"	  --,x.facilityTotalRVU"
"	  ,x.section rawSection"
"	  ,x.category rawCategory"
"	  ,x.subCategory rawSubCategory"
"	  ,x.subSection rawSubSection"
      ,case when patindex('[0-9A-Z][0-9][0-9A-Z][0-9A-Z][0-9A-Z][-][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][ ]%', replace(replace(section, '[', ''), ']', '')) = 1
"	        then trim(right(replace(replace(section, '[', ''), ']', ''), len(replace(replace(section, '[', ''), ']', ''))-11))"
"			when patindex('[0-9A-Z][0-9][0-9A-Z][0-9A-Z][0-9A-Z][-][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z]', replace(replace(section, '[', ''), ']', '')) = 1"
"	        then null"
"			when patindex('[0-9A-Z][0-9][0-9A-Z][0-9A-Z][0-9A-Z][ ]%', replace(replace(section, '[', ''), ']', '')) = 1"
"	        then trim(right(replace(replace(section, '[', ''), ']', ''), len(replace(replace(section, '[', ''), ']', ''))-6))"
"			when patindex('[0-9A-Z][0-9][0-9A-Z][0-9A-Z][0-9A-Z]', replace(replace(section, '[', ''), ']', '')) = 1"
"	        then null"
"			when patindex('[0-9A-Z][0-9][0-9A-Z][0-9A-Z][0-9A-Z][-][0-9A-Z][0-9][0-9A-Z][0-9A-Z][0-9A-Z][-][0-9A-Z][0-9][0-9A-Z][0-9A-Z][0-9A-Z]', replace(section, ', ', '-')) = 1"
"	        then null"
"			else section"
"	   end section"
"	  ,case when patindex('[0-9A-Z][0-9][0-9A-Z][0-9A-Z][0-9A-Z][-][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][ ]%', replace(replace(category, '[', ''), ']', '')) = 1"
"	        then trim(right(replace(replace(category, '[', ''), ']', ''), len(replace(replace(category, '[', ''), ']', ''))-11))"
"			when patindex('[0-9A-Z][0-9][0-9A-Z][0-9A-Z][0-9A-Z][-][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z]', replace(replace(category, '[', ''), ']', '')) = 1"
"	        then null"
"			when patindex('[0-9A-Z][0-9][0-9A-Z][0-9A-Z][0-9A-Z][ ]%', replace(replace(category, '[', ''), ']', '')) = 1"
"	        then trim(right(replace(replace(category, '[', ''), ']', ''), len(replace(replace(category, '[', ''), ']', ''))-6))"
"			when patindex('[0-9A-Z][0-9][0-9A-Z][0-9A-Z][0-9A-Z]', replace(replace(category, '[', ''), ']', '')) = 1"
"	        then null"
"			when patindex('[0-9A-Z][0-9][0-9A-Z][0-9A-Z][0-9A-Z][-][0-9A-Z][0-9][0-9A-Z][0-9A-Z][0-9A-Z][-][0-9A-Z][0-9][0-9A-Z][0-9A-Z][0-9A-Z]', replace(category, ', ', '-')) = 1"
"	        then null"
"			else category"
"	   end category"
"	  ,case when patindex('[0-9A-Z][0-9][0-9A-Z][0-9A-Z][0-9A-Z][-][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][ ]%', replace(replace(subCategory, '[', ''), ']', '')) = 1"
"	        then trim(right(replace(replace(subCategory, '[', ''), ']', ''), len(replace(replace(subCategory, '[', ''), ']', ''))-11))"
"			when patindex('[0-9A-Z][0-9][0-9A-Z][0-9A-Z][0-9A-Z][-][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z]', replace(replace(subCategory, '[', ''), ']', '')) = 1"
"	        then null"
"			when patindex('[0-9A-Z][0-9][0-9A-Z][0-9A-Z][0-9A-Z][ ]%', replace(replace(subCategory, '[', ''), ']', '')) = 1"
"	        then trim(right(replace(replace(subCategory, '[', ''), ']', ''), len(replace(replace(subCategory, '[', ''), ']', ''))-6))"
"			when patindex('[0-9A-Z][0-9][0-9A-Z][0-9A-Z][0-9A-Z]', replace(replace(subCategory, '[', ''), ']', '')) = 1"
"	        then null"
"			when patindex('[0-9A-Z][0-9][0-9A-Z][0-9A-Z][0-9A-Z][-][0-9A-Z][0-9][0-9A-Z][0-9A-Z][0-9A-Z][-][0-9A-Z][0-9][0-9A-Z][0-9A-Z][0-9A-Z]', replace(subCategory, ', ', '-')) = 1"
"	        then null"
"			else subCategory"
"	   end subCategory"
"	  ,case when patindex('[0-9A-Z][0-9][0-9A-Z][0-9A-Z][0-9A-Z][-][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][ ]%', replace(replace(subSection, '[', ''), ']', '')) = 1"
"	        then trim(right(replace(replace(subSection, '[', ''), ']', ''), len(replace(replace(subSection, '[', ''), ']', ''))-11))"
"			when patindex('[0-9A-Z][0-9][0-9A-Z][0-9A-Z][0-9A-Z][-][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z]', replace(replace(subSection, '[', ''), ']', '')) = 1"
"	        then null"
"			when patindex('[0-9A-Z][0-9][0-9A-Z][0-9A-Z][0-9A-Z][ ]%', replace(replace(subSection, '[', ''), ']', '')) = 1"
"	        then trim(right(replace(replace(subSection, '[', ''), ']', ''), len(replace(replace(subSection, '[', ''), ']', ''))-6))"
"			when patindex('[0-9A-Z][0-9][0-9A-Z][0-9A-Z][0-9A-Z]', replace(replace(subSection, '[', ''), ']', '')) = 1"
"	        then null"
"			when patindex('[0-9A-Z][0-9][0-9A-Z][0-9A-Z][0-9A-Z][-][0-9A-Z][0-9][0-9A-Z][0-9A-Z][0-9A-Z][-][0-9A-Z][0-9][0-9A-Z][0-9A-Z][0-9A-Z]', replace(subSection, ', ', '-')) = 1"
"	        then null"
"			else subSection"
"	   end subSection"
"	  ,createDateTime"
  into #hcpcs_category_temp0
  from EdmStage.Optum_HCPCSCategory x ;

drop table if exists #hcpcs_category_temp1 ;

select stageId
      ,fileRequestId
"	  ,code"
"	  ,codeDescription"
"	  --,nonFacilityTotalRVU"
"	  --,facilityTotalRVU"
"	  ,rawSection"
"	  ,rawCategory"
"	  ,rawSubCategory"
"	  ,rawSubSection"
"	  ,section"
"	  ,case when section = category then null"
"	        else category"
"	   end category"
"	  ,case when category = subCategory then null"
"	        else subCategory"
"	   end subCategory "
"	  ,case when category = subSection or subCategory = subSection then null"
"	        else subSection"
"	   end subSection "
"	  ,createDateTime"
  into #hcpcs_category_temp1
  from #hcpcs_category_temp0 ; 

drop table if exists #hcpcs_category_temp2 ;

select stageId
      ,fileRequestId
"	  ,code"
"	  ,codeDescription"
"	  --,nonFacilityTotalRVU"
"	  --,facilityTotalRVU"
"	  ,rawSection"
"	  ,rawCategory"
"	  ,rawSubCategory"
"	  ,rawSubSection"
"	  ,section"
"	  ,coalesce(category, subcategory, subsection) category"
"	  ,case when category <> subcategory then subCategory end subCategory"
"	  ,case when category <> subsection and subcategory <> subsection then subSection end subSection"
"	  ,category category2"
"	  ,subCategory subCategory2"
"	  ,subSection subSection2"
"	  ,createDateTime"
  into #hcpcs_category_temp2
  from #hcpcs_category_temp1 ;

drop table if exists #hcpcs_category_temp ;

select stageId
      ,fileRequestId
"	  ,code"
"	  ,codeDescription"
"	  --,nonFacilityTotalRVU"
"	  --,facilityTotalRVU"
"	  ,rawSection"
"	  ,rawCategory"
"	  ,rawSubCategory"
"	  ,rawSubSection"
"	  ,section"
"	  ,isnull(category, section) category"
"	  ,isnull(subCategory, case when category <> subSection2 then subSection2 end) subCategory "
"	  ,subSection"
"	  ,category2"
"	  ,subCategory2"
"	  ,subSection2"
"	  ,createDateTime"
  into #hcpcs_category_temp
  from #hcpcs_category_temp2 ; 

drop table if exists #hcpcs_category_stage ;

select hc.hcpcsCategoryId
      ,h.hcpcsId
"	  ,h.hcpcsCategoryId currentHcpcsCategoryId"
      ,c.section
      ,c.category
      ,c.subCategory
      ,c.subSection
      ,c.category2
      ,c.subCategory2
      ,c.subSection2
"	  ,c.rawSection"
"	  ,c.rawCategory"
"	  ,c.rawSubCategory"
"	  ,c.rawSubSection"
  into #hcpcs_category_stage
  from #hcpcs_category_temp c
  join Reference.Hcpcs h on c.code = h.hcpcsCode
  left join Reference.HcpcsCategory hc on c.section = hc.hcpcsSection
"  					                  and isnull(c.category, '~') = isnull(hc.hcpcsCategory, '~')"
"  					                  and isnull(c.subCategory, '~') = isnull(hc.hcpcsSubCategory, '~')"
"  					                  and isnull(c.subSection, '~') = isnull(hc.hcpcsSubSection, '~')"
"  					                  and h.hcpcsLevel = @hcpcsLevel "
"  					                  and h.hcpcsLevelType = @hcpcsLevelType ;"

declare @badHcpcsCategoryCount int ;
select @badHcpcsCategoryCount = count(distinct isnull(section, '')+','+isnull(category, '')+','+isnull(subCategory,'')+','+isnull(subSection,''))
  from #hcpcs_category_stage 
 where hcpcsCategoryId is null
   and currentHcpcsCategoryId is not null 
   and (patindex('[0-9A-Z][0-9][0-9A-Z][0-9A-Z][0-9A-Z]%', replace(replace(section, '[', ''), ']', '')) = 1 
     or patindex('[0-9A-Z][0-9][0-9A-Z][0-9A-Z][0-9A-Z]%', replace(replace(category, '[', ''), ']', '')) = 1 
     or patindex('[0-9A-Z][0-9][0-9A-Z][0-9A-Z][0-9A-Z]%', replace(replace(subCategory, '[', ''), ']', '')) = 1 
     or patindex('[0-9A-Z][0-9][0-9A-Z][0-9A-Z][0-9A-Z]%', replace(replace(subSection, '[', ''), ']', '')) = 1
"	 or (subCategory is null and subSection is not null)) ;"

declare @errorMessage varchar(1000) = convert(varchar(10), @badHcpcsCategoryCount) + ' HCPCS Categories contain an invalid description.  The purpose of this load is to normalize the descriptions so they no longer contain references to specific codes or ranges and colesce category/subcategory/subsection.'

if @badHcpcsCategoryCount > 0
"	throw 51000, @errorMessage, 16 ;"

declare @missingSectionOrCategoryCount int ;
select @missingSectionOrCategoryCount = count(distinct isnull(section, '')+','+isnull(category, '')+','+isnull(subCategory,'')+','+isnull(subSection,''))
  from #hcpcs_category_stage 
 where section is null
    or category is null ;

set @errorMessage = convert(varchar(10), @missingSectionOrCategoryCount) + ' HCPCS Category records do not have a section or category.' ;

if @missingSectionOrCategoryCount > 0
"	throw 51000, @errorMessage, 16 ;"

merge into Reference.HcpcsCategory m
using (select distinct 
              section
"       	     ,category"
"       	     ,subCategory"
"       	     ,subSection"
         from #hcpcs_category_stage x
        where hcpcsCategoryId is null) u
   on u.section = m.hcpcsSection 
  and isnull(u.category, '~') = isnull(m.hcpcsCategory, '~')
  and isnull(u.subCategory, '~') = isnull(m.hcpcsSubCategory, '~')
  and isnull(u.subSection, '~') = isnull(m.hcpcsSubSection, '~')
  and m.hcpcsLevel = @hcpcsLevel 
  and m.hcpcsLevelType = @hcpcsLevelType
 when not matched then insert (hcpcsSection
"		                      ,hcpcsCategory"
"		                      ,hcpcsSubCategory"
"		                      ,hcpcsSubSection"
"		                      ,hcpcsLevel"
"		                      ,hcpcsLevelType)"
                       values (u.section
                              ,u.category
                              ,u.subCategory
                              ,u.subSection
                              ,@hcpcsLevel
                              ,@hcpcsLevelType) ;

drop table if exists #hcpcs_category_stage_2 ;

select h.hcpcsCategoryId
      ,h.hcpcsId
"	  ,h.hcpcsCategoryId currentHcpcsCategoryId"
"	  ,c.code"
      ,c.section
      ,c.category
      ,c.subCategory
      ,c.subSection
"	  ,c.rawSection"
"	  ,c.rawCategory"
"	  ,c.rawSubCategory"
"	  ,c.rawSubSection"
  into #hcpcs_category_stage_2
  from #hcpcs_category_temp c
  join Reference.Hcpcs h on c.code = h.hcpcsCode
  left join Reference.HcpcsCategory hc on c.section = hc.hcpcsSection
"  					                  and isnull(c.category, '~') = isnull(hc.hcpcsCategory, '~')"
"  					                  and isnull(c.subCategory, '~') = isnull(hc.hcpcsSubCategory, '~')"
"  					                  and isnull(c.subSection, '~') = isnull(hc.hcpcsSubSection, '~')"
"  					                  and h.hcpcsLevel = @hcpcsLevel "
"  					                  and h.hcpcsLevelType = @hcpcsLevelType ;"

merge into Reference.HcpcsCategory m
using (select distinct
"	          c.hcpcsCategoryId"
"	         --,c.currentHcpcsCategoryId"
"	         ,c.section"
"	         ,c.category"
"	         ,c.subCategory"
"	         ,c.subSection"
"	         --,c.rawSection"
"	         --,c.rawCategory"
"	         --,c.rawSubCategory"
"	         --,c.rawSubSection"
"	     from #hcpcs_category_stage c"
"	    where hcpcsCategoryId is null "
"	      and currentHcpcsCategoryId is null) u"
   on m.hcpcsCategoryId = u.hcpcsCategoryId
 when not matched
 then insert(
"		 hcpcsSection"
"		,hcpcsCategory"
"		,hcpcsSubCategory"
"		,hcpcsSubSection"
"		,hcpcsLevel"
"		,hcpcsLevelType)"
"	  values("
"		 u.section"
"		,u.subCategory"
"		,u.subCategory"
"		,u.subSection"
"		,@hcpcsLevel"
"		,@hcpcsLevelType) ;"
"		"
drop table if exists #hcpcs_category_stage_3 ;

select hc.hcpcsCategoryId
      ,h.hcpcsId
"	  ,h.hcpcsCategoryId currentHcpcsCategoryId"
"	  ,c.code"
      ,c.section
      ,c.category
      ,c.subCategory
      ,c.subSection
"	  ,c.rawSection"
"	  ,c.rawCategory"
"	  ,c.rawSubCategory"
"	  ,c.rawSubSection"
"	  ,rank() over(partition by c.code, c.section,isnull(c.category, '~'), isnull(c.subCategory, '~'), isnull(c.subSection, '~') order by hc.hcpcsCategoryId) rnk"
  into #hcpcs_category_stage_3
  from #hcpcs_category_temp c
  join Reference.Hcpcs h on c.code = h.hcpcsCode
  join Reference.HcpcsCategory hc on c.section = hc.hcpcsSection
"  					             and isnull(c.category, '~') = isnull(hc.hcpcsCategory, '~')"
"  					             and isnull(c.subCategory, '~') = isnull(hc.hcpcsSubCategory, '~')"
"  					             and isnull(c.subSection, '~') = isnull(hc.hcpcsSubSection, '~')"
"  					             and h.hcpcsLevel = @hcpcsLevel "
"  					             and h.hcpcsLevelType = @hcpcsLevelType ;"

merge into Reference.Hcpcs m
using (select distinct hcpcsId, hcpcsCategoryId from #hcpcs_category_stage_3 where rnk = 1) u
   on m.hcpcsId = u.hcpcsId
 when matched then update set m.hcpcsCategoryId = u.hcpcsCategoryId
                             ,m.hcpcsUpdateDate = sysdatetime() ;


if (select count(*) from Reference.HcpcsCategory where hcpcsCategoryId = 99999) = 0
insert into Reference.HcpcsCategory 
(hcpcsCategoryId
,hcpcsSection
,hcpcsLevel
,hcpcsLevelType)
values
(99999
,'Dental'
,'2'
,'HCPCS');

update Reference.Hcpcs 
   set hcpcsCategoryId = 99999
 where hcpcsCategoryId is null 
"   and hcpcsCode like 'D%' ;	1	2020-09-24 14:42:45.1333333	mssql"
"231	43	MERGE_MEDISPAN_NDC-02-FINAL	declare @fileRequestId bigint = :fileRequestId ;"

drop table if exists ##ndc_temp0 ;

select medispan.triggeringFileRequestId
      ,ndc.ndcId
          ,medispan.ndcStageId
          ,medispan.tcGpiStageId
          ,medispan.gpiStageId
      ,medispan.ndcCode
      ,medispan.drugName
      ,isnull(medispan.manufacturerLabelerName, ndc.labelerName) labelerName
      ,medispan.genericProductIdentifier
      ,medispan.genericProductPackagingCode
      ,isnull(medispan.packageSize, ndc.packageSize) packageSize
      ,isnull(medispan.packageSizeUOM, ndc.packageSizeUnit) packageSizeUnit
      ,medispan.packageDescriptionCode
      ,coalesce(medispan.packageName, ndc.packageName, '['+medispan.packageDescriptionCode+']') packageName
      ,isnull(medispan.packageSize + ' ' + medispan.packageSizeUOM, ndc.packageType) packageType
      ,isnull(medispan.dosageFormName, ndc.dosageFormName) dosageFormName
      ,isnull(medispan.dosageFormDesc, ndc.dosageFormDesc)  dosageFormDesc
      ,isnull(medispan.strengthUnitOfMeasure, ndc.unitName) unitName
      ,isnull(medispan.strength + ' ' + medispan.strengthUnitOfMeasure, ndc.strengthForm) strengthForm
      ,isnull(medispan.tcGpiName, ndc.strengthFull) strengthFull
      ,isnull(medispan.tcGpiName, ndc.strengthName) strengthName
      ,isnull(medispan.otcStatus, ndc.octStatus) octStatus
      ,isnull(medispan.nameTypeCode, ndc.genericStatus) genericStatus
      ,isnull(dateadd(day, 0, medispan.oldEffectiveDate), ndc.ndcEffectiveDate) ndcEffectiveDate
      ,isnull(dateadd(day, -1, medispan.newEffectiveDate), ndc.ndcDeactivationDate) ndcDeactivationDate
          ,medispan.itemStatus
      ,case when medispan.itemStatus like 'Inactive%' then 0 else 1 end ndcActiveFlag
           ----
          ,case when ndc.ndcId is null then 1 else 0 end isNew
          ,case when medispan.drugName <> ndc.drugName or (medispan.drugName is null and ndc.drugName is not null) then 1 else 0 end isDiff_drugName
          ,case when medispan.manufacturerLabelerName <> ndc.labelerName then 1 else 0 end isDiff_labelerName
      ,case when medispan.packageSize <> ndc.packageSize then 1 else 0 end isDiff_packageSize
          ,case when medispan.packageSizeUOM <> ndc.packageSizeUnit then 1 else 0 end isDiff_packageSizeUnit
          ,case when medispan.packageName <> ndc.packageName then 1 else 0 end isDiff_packageName
          ,case when medispan.packageSize + ' ' + medispan.packageSizeUOM <> ndc.packageType then 1 else 0 end isDiff_packageType
          ,case when medispan.dosageFormName <> ndc.dosageFormName then 1 else 0 end isDiff_dosageFormName
          ,case when medispan.dosageFormDesc <> ndc.dosageFormDesc then 1 else 0 end isDiff_dosageFormDesc
          ,case when medispan.strengthUnitOfMeasure <> ndc.unitName then 1 else 0 end isDiff_unitName
          ,case when medispan.strength + ' ' + medispan.strengthUnitOfMeasure <> ndc.strengthForm then 1 else 0 end isDiff_strengthForm
          ,case when medispan.tcGpiName <> ndc.strengthFull then 1 else 0 end isDiff_strengthFull
          ,case when medispan.tcGpiName <> ndc.strengthName then 1 else 0 end isDiff_strengthName
          ,case when medispan.otcStatus <> ndc.octStatus then 1 else 0 end isDiff_octStatus
          ,case when medispan.nameTypeCode <> ndc.genericStatus then 1 else 0 end isDiff_genericStatus
          ,case when dateadd(day, 0, medispan.oldEffectiveDate) <> ndc.ndcEffectiveDate then 1 else 0 end isDiff_ndcEffectiveDate
          ,case when dateadd(day, -1, medispan.newEffectiveDate)<> ndc.ndcDeactivationDate then 1 else 0 end isDiff_ndcDeactivationDate
          ,case when (medispan.itemStatus not like 'Inactive%' and ndc.ndcActiveFlag = 0) or (medispan.itemStatus not in ('Active', 'Override') and ndc.ndcActiveFlag = 1) then 1 else 0 end isDiff_ndcActiveFlag
          ,rank() over(partition by medispan.ndcCode order by medispan.gpiStageId desc, medispan.tcGpiStageId desc, medispan.ndcStageId desc) rn
  into ##ndc_temp0
  from EdmReference.Medispan_NDC_All medispan
  left join Reference.Ndc ndc on medispan.ndcCode = ndc.ndcCode ;

declare @duplicateCount int ;

select @duplicateCount = count(*)
  from (select ndcCode
              ,genericProductIdentifier
                  ,genericProductPackagingCode
              ,count(*) recordCount
          from ##ndc_temp0
         group by ndcCode
                 ,genericProductIdentifier
                     ,genericProductPackagingCode
        having count(*) > 1) x ;

declare @errorMessageDuplicateCount varchar(500) = 'There exist(s) ' + convert(varchar(10), @duplicateCount) + ' duplicate NDC record(s).' ;

if @duplicateCount > 0
        throw 51000, @errorMessageDuplicateCount, 16 ;

drop table if exists ##ndc_stage_diff ;

select t0.triggeringFileRequestId
      ,sysdatetime() currentDateTime
          ,t0.ndcId
          ,t0.ndcStageId
          ,t0.tcGpiStageId
          ,t0.gpiStageId
      ,t0.ndcCode
          ,t0.isNew
          ,t0.isDiff_drugName
          ,t0.drugName drugName_new
      ,ndc.drugName drugName_curr
          ,t0.isDiff_labelerName
          ,t0.labelerName labelerName_new
          ,ndc.labelerName labelerName_curr
          ,t0.isDiff_packageSize
          ,t0.packageSize packageSize_new
          ,ndc.packageSize packageSize_curr
          ,t0.isDiff_packageSizeUnit
          ,t0.packageSizeUnit packageSizeUnit_new
          ,ndc.packageSizeUnit packageSizeUnit_curr
          ,t0.isDiff_packageName
          ,t0.packageName packageName_new
          ,ndc.packageName packageName_curr
          ,t0.isDiff_packageType
          ,t0.packageType packageType_new
          ,ndc.packageType packageType_curr
          ,t0.isDiff_dosageFormName
          ,t0.dosageFormName dosageFormName_new
          ,ndc.dosageFormName dosageFormName_curr
          ,t0.isDiff_dosageFormDesc
          ,t0.dosageFormDesc dosageFormDesc_new
          ,ndc.dosageFormDesc dosageFormDesc_curr
          ,t0.isDiff_unitName
          ,t0.unitName unitName_new
          ,ndc.unitName unitName_curr
          ,t0.isDiff_strengthForm
          ,t0.strengthForm strengthForm_new
          ,ndc.strengthForm strengthForm_curr
          ,t0.isDiff_strengthFull
          ,t0.strengthFull strengthFull_new
          ,ndc.strengthFull strengthFull_curr
          ,t0.isDiff_strengthName
          ,t0.strengthName strengthName_new
          ,ndc.strengthName strengthName_curr
          ,t0.isDiff_octStatus
          ,t0.octStatus octStatus_new
          ,ndc.octStatus octStatus_curr
          ,t0.isDiff_genericStatus
          ,t0.genericStatus genericStatus_new
          ,ndc.genericStatus genericStatus_curr
          ,t0.isDiff_ndcEffectiveDate
          ,t0.ndcEffectiveDate ndcEffectiveDate_new
          ,ndc.ndcEffectiveDate ndcEffectiveDate_curr
          ,t0.isDiff_ndcDeactivationDate
          ,t0.ndcDeactivationDate ndcDeactivationDate_new
          ,ndc.ndcDeactivationDate ndcDeactivationDate_curr
          ,t0.isDiff_ndcActiveFlag
          ,t0.itemStatus
          ,t0.ndcActiveFlag ndcActiveFlag_new
          ,ndc.ndcActiveFlag ndcActiveFlag_curr
                  ,t0.rn
  into ##ndc_stage_diff
  from ##ndc_temp0 t0
  left join Reference.Ndc ndc on t0.ndcId = ndc.ndcId
 where t0.rn = 1
   and (t0.isNew = 1
     or t0.isDiff_drugName = 1
     or t0.isDiff_labelerName = 1
         or t0.isDiff_packageSize = 1
         or t0.isDiff_packageSizeUnit = 1
         or t0.isDiff_packageName = 1
         or t0.isDiff_packageType = 1
         or t0.isDiff_dosageFormName = 1
         or t0.isDiff_dosageFormDesc = 1
         or t0.isDiff_unitName = 1
         or t0.isDiff_strengthForm = 1
         or t0.isDiff_strengthName = 1
         -- or t0.isDiff_octStatus = 1
         -- or t0.isDiff_genericStatus = 1
         or t0.isDiff_ndcEffectiveDate = 1
         or t0.isDiff_ndcDeactivationDate = 1
         or t0.isDiff_ndcActiveFlag = 1)
        ;

--drop table if exists EdmReference.NDC_diff;

insert into EdmReference.NDC_diff
select *
  from ##ndc_stage_diff ;

merge into Reference.Ndc m
using ##ndc_stage_diff u
   on m.ndcId = u.ndcId
 when matched then update set m.drugName                        = u.drugName_new
                             ,m.labelerName                     = u.labelerName_new
                                 ,m.packageSize                 = u.packageSize_new
                                 ,m.packageSizeUnit     = u.packageSizeUnit_new
                                 ,m.packageName                 = u.packageName_new
                                 ,m.packageType                 = u.packageType_new
                                 ,m.dosageFormName              = u.dosageFormName_new
                                 ,m.dosageFormDesc              = u.dosageFormDesc_new
                                 ,m.unitName                    = u.unitName_new
                                 ,m.strengthForm                = u.strengthForm_new
                                 ,m.strengthName                = u.strengthName_new
                                 ,m.ndcEffectiveDate    = u.ndcEffectiveDate_new
                                 ,m.ndcDeactivationDate = u.ndcDeactivationDate_new
                             ,m.ndcActiveFlag           = u.ndcActiveFlag_new
 when not matched then insert (ndcCode
                              ,drugName
                                                          ,labelerName
                                                          ,packageSize
                                                          ,packageSizeUnit
                                                          ,packageName
                                                          ,packageType
                                                          ,dosageFormName
                                                          ,dosageFormDesc
                                                          ,unitName
                                                          ,strengthForm
                                                          ,strengthName
                                                          ,octStatus
                                                          ,genericStatus
                                                          ,ndcEffectiveDate
                                                          ,ndcDeactivationDate
                                                          ,ndcActiveFlag)
                       values (u.ndcCode
                              ,u.drugName_new
                                                          ,u.labelerName_new
                                                          ,u.packageSize_new
                                                          ,u.packageSizeUnit_new
                                                          ,u.packageName_new
                                                          ,u.packageType_new
                                                          ,u.dosageFormName_new
                                                          ,u.dosageFormDesc_new
                                                          ,u.unitName_new
                                                          ,u.strengthForm_new
                                                          ,u.strengthName_new
                                                          ,u.octStatus_new
                                                          ,u.genericStatus_new
                                                          ,u.ndcEffectiveDate_new
                                                          ,u.ndcDeactivationDate_new
"                                                          ,u.ndcActiveFlag_new) ; 	1	2020-09-30 08:59:27.9266667	mssql"
"232	43	MEDISPAN_TOTAL_RECCORD_COUNT	declare @fileRequestId bigint = :fileRequestId ;"

select count(*) from EdmReference.Medispan_NDC_All ;
"	1	2020-10-02 09:11:13.4066667	mssql"
"233	0	EDM_STANDARD_MPI-MISSING_MPI_COUNT	select count(*) from <tableSchema>.<tableName> where enterprisePatientId is null	1	2020-10-22 17:00:50.2100000	mssql"
"234	0	EDM_STANDARD_MPI-INSERT_BULK_REQUEST_STAGE	declare @fileRequestId bigint = :fileRequestId ;"

insert into MPI.BulkRequestStage 
       (BulkRequestStageId 
       ,ClientIdentifier 
       ,OriginalPatientIdentifier 
       ,CurrentPatientIdentifier 
       ,PolicyNumber 
       ,FirstName 
       ,MiddleName 
       ,LastName 
       ,SSN 
       ,DOB 
       ,Gender 
       ,AddressLine1 
       ,AddressLine2 
       ,City 
       ,State 
       ,ZIP 
       ,Telephone)
select m.stageId BulkRequestStageId
"	  ,c.clientCode ClientIdentifier "
      ,isnull(m.memberPrimaryId, 'NOT_SUPPLIED') OriginalPatientIdentifier 
"	  ,case when m.memberSupplementalIdQualifier = 'MI' then m.memberSupplementalId end CurrentPatientIdentifier "
"	  ,case when m.memberSupplementalIdQualifier = '38' then m.memberSupplementalId else memberPrimaryId end PolicyNumber "
"	  ,isnull(m.memberFirstname, 'UNKNOWN') FirstName "
"	  ,null MiddleName "
"	  ,isnull(m.memberLastName, 'UNKNOWN') LastName "
"	  ,case when m.memberSupplementalIdQualifier = 'SY' and m.memberSupplementalId <> '000000000' then m.memberSupplementalId end SSN"
"	  ,case when year(try_convert(datetime2, memberBirthDate)) > 1800 then left(m.memberBirthDate, 4) +'-'+ right(left(memberBirthDate, 6), 2) +'-'+ right(memberBirthDate, 2) + ' 00:00:00' end  DOB "
"	  ,isnull(m.memberGenderCode, 'U') Gender "
"	  ,m.memberAddressLine1 AddressLine1 "
"	  ,m.memberAddressLine2 AddressLine2 "
"	  ,m.memberCityName City "
"	  ,m.memberStateCode State "
"	  ,m.memberPostalZoneCode ZIP "
"	  ,case when len(m.memberPrimaryTelephoneNumber) > 6 then m.memberPrimaryTelephoneNumber end Telephone"
  from <tableSchema>.<tableName> m
  join EdmLib.FileRequest fr on fr.fileRequestId = @fileRequestId
  join Reference.Client c on fr.clientId = c.clientId
" where m.fileRequestId = @fileRequestId ; 	1	2020-10-22 17:02:51.5266667	mssql"
"235	0	EDM_STANDARD_MPI-MERGE_BULK_REQUEST_STAGE_DEDUP	merge into <tableSchema>.<tableName> m"
using (select mc.fileRequestId
             ,mc.stageId
"       	     ,d.MPIID"
         from <tableSchema>.<tableName> mc
         join MPI.BulkRequestStageDedup d on mc.stageId = d.BulkRequestStageId
                                         and d.MPIID is not null
        where mc.enterprisePatientId is null
          and mc.fileRequestId = :fileRequestId) u
   on m.fileRequestId = u.fileRequestId
  and m.stageId = u.stageId
" when matched then update set m.enterprisePatientId = u.MPIID; 	1	2020-10-22 17:14:13.0166667	mssql"
"236	0	EDM_STANDARD_MPI-DUPLICATE_MPI_COUNT	select count(*)"
  from (select enterprisePatientId
              ,count(*) recordCount
"	          ,string_agg(m.memberBirthDate, ', ') within group (order by m.memberPrimaryId) birthDateList"
"	          ,count(distinct memberBirthDate) birthDateCount"
"	          ,string_agg(m.memberGenderCode, ', ')  within group (order by m.memberPrimaryId) genderList"
"	          ,count(distinct memberGenderCode) genderCount"
"	          ,max(fileRequestId) fileRequestId"
"	          ,string_agg(m.stageId, ', ') within group (order by m.memberPrimaryId) stageIdList"
          from <tableSchema>.<tableName> m
         group by m.enterprisePatientId
        having count(distinct m.memberPrimaryId) > 1
            or count(distinct m.memberBirthDate) > 1
"            or count(distinct m.memberGenderCode) > 1) x 	1	2020-10-22 17:17:08.3566667	mssql"
"237	0	EDM_STANDARD_MPI-TOTAL_RECORD_COUNT	select count(*) from <tableSchema>.<tableName>	1	2020-10-22 17:21:15.9466667	mssql"
"238	0	EDM_STANDARD_MPI-SET_SUBSCRIBER	declare @fileRequestId bigint = :fileRequestId ;"

drop table if exists ##edm_standard_member_relationship ;

#NAME?
select d.stageId, s.enterprisePatientId enterpriseSubscriberId
  into ##edm_standard_member_relationship
  from <tableSchema>.<tableName> d
  left join <tableSchema>.<tableName> s on s.memberRelationshipCode in ('18', '20' )
                                      and d.subscriberPrimaryId = s.memberPrimaryId
 where d.memberRelationshipCode not in ('18', '20') ;

#NAME?
insert into ##edm_standard_member_relationship
select stageId, enterprisePatientId enterpriseSubscriberId
  from <tableSchema>.<tableName>
 where memberRelationshipCode in ('18', '20') ;

declare @multipleSubscriberCount int ;

select @multipleSubscriberCount = count(*)
  from (select stageId, count(distinct enterpriseSubscriberId) subscriberRowCount
          from ##edm_standard_member_relationship
         group by stageId
        having count(distinct enterpriseSubscriberId) > 1) x

if @multipleSubscriberCount > 0
begin
"	declare @errorMessage varchar(1000) = convert(varchar(10), @multipleSubscriberCount) + ' dependent(s) have more than 1 subscriber.' ;"
"	throw 51000, @errorMessage, 16 ;"
end ;

merge into <tableSchema>.<tableName> m
using ##edm_standard_member_relationship u
   on m.stageId = u.stageId
" when matched then update set m.enterpriseSubscriberId = u.enterpriseSubscriberId ; 	1	2020-10-23 08:44:20.1366667	mssql"
"239	0	QT3_MONITOR_15MIN_FAILED_TRANSMISSION_JOB	with jobHistory as"
     (select try_convert(datetime2, cast(jh.run_date as varchar(8)) + ' ' +
             case when len(jh.run_time) = 5 then '0' + left(jh.run_time, 1) + ':' + substring(cast(run_time as varchar(5)), 2, 2) + ':' + right(run_time, 2)
"      	          when len(jh.run_time) = 4 then '00' + ':' + left(jh.run_time, 2) + ':' + right(run_time, 2)"
"      	          when len(jh.run_time) = 3 then '00' + ':0' + left(jh.run_time, 1) + ':' + right(run_time, 2)"
"      	          when len(jh.run_time) = 2 then '00:00' + right(run_time, 2)"
"      	          when len(jh.run_time) = 1 then '00:00:0' + right(run_time, 1)"
"      	  	      else left(jh.run_time, 2) + ':' + substring(cast(run_time as varchar(6)), 3, 2) + ':' + right(run_time, 2) end"
"      	    , 121) run_date_time"
"      	    ,j.name"
"      	    ,js.step_name"
            ,sql_severity
"			,jh.message"
       from msdb.dbo.sysjobs AS j
        join msdb.dbo.sysjobsteps AS js ON js.job_id = j.job_id
        join msdb.dbo.sysjobhistory AS jh ON jh.job_id = j.job_id
"	  where j.name in ('jobTransmissionSpMain')"
"	   ),"
"	jobHistoryRank as"
    (select jh.* 
           ,row_number() over(partition by jh.name, jh.step_name order by jh.run_date_time desc, jh.sql_severity desc) rnk
       from jobHistory jh)
select '[' + try_convert(varchar(19), run_date_time, 121) +'] ' + name + ' (' + step_name + ') :' + message
  from jobHistoryRank
 where rnk = 1
   and sql_severity > 0
   and run_date_time >= dateadd(minute, -60, sysdatetime()) 
"   and message not like '%Transaction%was deadlocked on lock resources with another process%' ;	1	2020-10-28 13:37:02.7033333	mssql"
"240	75	UPDATE_MISSING_PLAN_INFO	declare @fileRequest bigint = :fileRequestId ;"

if exists (
select d.stageId
  from EdmStage.EWTF_Member d
  join EdmStage.EWTF_Member s on d.subscriberPrimaryNumber = s.patientPrimaryNumber
                             and s.relationshipCode = '18'
  where d.planNumber is null
 group by d.stageId
 having count(distinct d.planNumber) > 1)
"	throw 51000, 'Invalid subscriber-member relationship(s).', 16 ;"

merge into EdmStage.EWTF_Member m
using (
select d.stageId
      ,s.planNumber
  from EdmStage.EWTF_Member d
  join EdmStage.EWTF_Member s on d.subscriberPrimaryNumber = s.patientPrimaryNumber
                             and s.relationshipCode = '18'
 where d.planNumber is null) u
 on m.stageId = u.stageId
" when matched then update set m.planNumber = u.planNumber ; 	1	2020-10-30 10:39:08.5266667	mssql"
"241	75	UPDATE_SUBSCRIBER_INFO	declare @fileRequestId bigint = :fileRequestId ;"

drop table if exists ##ewtf_subscriber_info ;

select d.stageId
      ,s.enterprisePatientId enterpriseSubscriberId
  into ##ewtf_subscriber_info
  from EdmStage.EWTF_Member d
  join EdmStage.EWTF_Member s on d.subscriberPrimaryNumber = s.patientPrimaryNumber
                             and s.relationshipCode = '18'
 where d.relationshipCode <> '18' ;
 
insert into ##ewtf_subscriber_info
select stageId
      ,enterprisePatientId enterpriseSubscriberId
  from EdmStage.EWTF_Member
 where relationshipCode = '18' ;

drop table if exists ##ewtf_subscriber_info_d ;

select stageId
      ,max(enterpriseSubscriberId) enterpriseSubscriberId
"	  ,count(distinct enterpriseSubscriberId) enterpriseSubscriberIdCount"
  into ##ewtf_subscriber_info_d
  from ##ewtf_subscriber_info
 group by stageId ;

if exists (select * from ##ewtf_subscriber_info_d where enterpriseSubscriberIdCount > 1)
"	throw 51000, 'Invalid dependent/subscriber relationship(s).', 16 ; "

merge into EdmStage.EWTF_Member m
using ##ewtf_subscriber_info_d u on m.stageId = u.stageId
 when matched then update set m.enterpriseSubscriberId = u.enterpriseSubscriberId 
 -- output inserted.stageId, inserted.enterpriseSubscriberId 
" ; 	1	2020-11-02 11:28:10.7333333	mssql"
"242	67	LOAD-INSTITUTIONAL_CLAIM	 "

declare @fileRequestId bigint = :fileRequestId ;

-- make sure there aren't any overlapping claims
declare @overlappingClaimCount int ;
select @overlappingClaimCount = count(*)
  from (-- institutional
        select claimNumber
          from EdmStage.MAL_MedicalClaim
         group by claimNumber
        having (sum(case when procedureCodeType = 'R' then 1 else 0 end) > 0
            or sum(case when drgCode is not null then 1 else 0 end) > 0)
        intersect
        -- professional
        select claimNumber
          from EdmStage.MAL_MedicalClaim
         group by claimNumber
        having not (sum(case when procedureCodeType = 'R' then 1 else 0 end) > 0
            or sum(case when drgCode is not null then 1 else 0 end) > 0)) x

declare @overlappingClaimCountMessage varchar(100) = 'This file contains ' + convert(varchar(10), @overlappingClaimCount) + ' overlapping claim(s).' ;
if @overlappingClaimCount > 0
"	throw 51000, @overlappingClaimCountMessage, 16 ;"
"	"
#NAME?
truncate table EdmStage.MAL_InstitutionalClaim ;

#NAME?
with institutionalClaimList as (
select claimNumber
  from EdmStage.MAL_MedicalClaim
 group by claimNumber
having (sum(case when procedureCodeType = 'R' then 1 else 0 end) > 0
     or sum(case when drgCode is not null then 1 else 0 end) > 0))
insert into EdmStage.MAL_InstitutionalClaim
select m.stageId rowNumber
      ,m.fileRequestId parentFileRequestId
"	  ,@fileRequestId currentFileRequestId"
"	  ,min(m.serviceStartDate) over(partition by m.claimNumber) firstDateOfService"
"	  ,max(m.serviceStartDate) over(partition by m.claimNumber) lastDateOfService"
"	  ,case when lead(m.claimStatus, 1) over(partition by m.claimNumber, m.lineNumber order by m.stageId) = 'R' then 1 else 0 end isReversed"
"	  ,case when lead(m.claimStatus, 1) over(partition by m.claimNumber, m.lineNumber order by m.stageId) = 'R' then lead(m.billedAmount, 1) over(partition by m.claimNumber, m.lineNumber order by m.stageId) end     billedAmount_reversed"
"	  ,case when lead(m.claimStatus, 1) over(partition by m.claimNumber, m.lineNumber order by m.stageId) = 'R' then lead(m.allowedAmount, 1) over(partition by m.claimNumber, m.lineNumber order by m.stageId)  end   allowedAmount_reversed"
"	  ,case when lead(m.claimStatus, 1) over(partition by m.claimNumber, m.lineNumber order by m.stageId) = 'R' then lead(m.notCoveredAmount, 1) over(partition by m.claimNumber, m.lineNumber order by m.stageId) end notCoveredAmount_reversed"
"	  ,case when lead(m.claimStatus, 1) over(partition by m.claimNumber, m.lineNumber order by m.stageId) = 'R' then lead(m.copayment, 1) over(partition by m.claimNumber, m.lineNumber order by m.stageId) end        copayment_reversed"
"	  ,case when lead(m.claimStatus, 1) over(partition by m.claimNumber, m.lineNumber order by m.stageId) = 'R' then lead(m.deductible, 1) over(partition by m.claimNumber, m.lineNumber order by m.stageId) end       deductible_reversed"
"	  ,case when lead(m.claimStatus, 1) over(partition by m.claimNumber, m.lineNumber order by m.stageId) = 'R' then lead(m.ppoSavings, 1) over(partition by m.claimNumber, m.lineNumber order by m.stageId) end       ppoSavings_reversed"
"	  ,case when lead(m.coinsurance, 1) over(partition by m.claimNumber, m.lineNumber order by m.stageId) = 'R' then lead(m.coinsurance, 1) over(partition by m.claimNumber, m.lineNumber order by m.stageId) end      coinsurnace_reversed"
"	  ,case when lead(m.claimStatus, 1) over(partition by m.claimNumber, m.lineNumber order by m.stageId) = 'R' then lead(m.cobAmount, 1) over(partition by m.claimNumber, m.lineNumber order by m.stageId) end        cobAmount_reversed"
"	  ,case when lead(m.claimStatus, 1) over(partition by m.claimNumber, m.lineNumber order by m.stageId) = 'R' then lead(m.paidAmount, 1) over(partition by m.claimNumber, m.lineNumber order by m.stageId)  end      paidAmount_reversed"
"	  ,case when lead(m.claimStatus, 1) over(partition by m.claimNumber, m.lineNumber order by m.stageId) = 'R' then lead(m.serviceUnits, 1) over(partition by m.claimNumber, m.lineNumber order by m.stageId) end     serviceUnits_reversed"
"	  ,m.*"
  from EdmStage.MAL_MedicalClaim m
  join institutionalClaimList cl on m.claimNumber = cl.claimNumber ;

#NAME?
#NAME?
#NAME?
#NAME?
merge into EdmStage.MAL_InstitutionalClaim m
using (select currentFileRequestId
             ,rowNumber
             ,row_number() over(partition by 1 order by stageId) stageId -- resequence stageId so jms queues won't puke
"	    from EdmStage.MAL_InstitutionalClaim) u"
   on m.rowNumber = u.rowNumber
  when matched then update set m.fileRequestId = u.currentFileRequestId
"                              ,m.stageId = u.stageId ; 	1	2020-11-30 15:58:14.5866667	mssql"
"243	67	LOAD-PROFESSIONAL_CLAIM	declare @fileRequestId bigint = :fileRequestId ;"

-- make sure there aren't any overlapping claims
declare @overlappingClaimCount int ;
select @overlappingClaimCount = count(*)
  from (-- institutional
        select claimNumber
          from EdmStage.MAL_MedicalClaim
         group by claimNumber
        having (sum(case when procedureCodeType = 'R' then 1 else 0 end) > 0
            or sum(case when drgCode is not null then 1 else 0 end) > 0)
        intersect
        -- professional
        select claimNumber
          from EdmStage.MAL_MedicalClaim
         group by claimNumber
        having NOT (sum(case when procedureCodeType = 'R' then 1 else 0 end) > 0
            or sum(case when drgCode is not null then 1 else 0 end) > 0)) x

declare @overlappingClaimCountMessage varchar(100) = 'This file contains ' + convert(varchar(10), @overlappingClaimCount) + ' overlapping claim(s).' ;
if @overlappingClaimCount > 0
"	throw 51000, @overlappingClaimCountMessage, 16 ;"
"	"
#NAME?
truncate table EdmStage.MAL_ProfessionalClaim ;

#NAME?
with professionalClaimList as (
select claimNumber
  from EdmStage.MAL_MedicalClaim
 group by claimNumber
having NOT (sum(case when procedureCodeType = 'R' then 1 else 0 end) > 0
     or sum(case when drgCode is not null then 1 else 0 end) > 0))
insert into EdmStage.MAL_ProfessionalClaim
select m.stageId rowNumber
      ,m.fileRequestId parentFileRequestId
"	  ,@fileRequestId currentFileRequestId"
"	  ,min(m.serviceStartDate) over(partition by m.claimNumber) firstDateOfService"
"	  ,max(m.serviceStartDate) over(partition by m.claimNumber) lastDateOfService"
"	  ,case when lead(m.claimStatus, 1) over(partition by m.claimNumber, m.lineNumber order by m.stageId) = 'R' then 1 else 0 end isReversed"
"	  ,case when lead(m.claimStatus, 1) over(partition by m.claimNumber, m.lineNumber order by m.stageId) = 'R' then lead(m.billedAmount, 1) over(partition by m.claimNumber, m.lineNumber order by m.stageId) end     billedAmount_reversed"
"	  ,case when lead(m.claimStatus, 1) over(partition by m.claimNumber, m.lineNumber order by m.stageId) = 'R' then lead(m.allowedAmount, 1) over(partition by m.claimNumber, m.lineNumber order by m.stageId)  end   allowedAmount_reversed"
"	  ,case when lead(m.claimStatus, 1) over(partition by m.claimNumber, m.lineNumber order by m.stageId) = 'R' then lead(m.notCoveredAmount, 1) over(partition by m.claimNumber, m.lineNumber order by m.stageId) end notCoveredAmount_reversed"
"	  ,case when lead(m.claimStatus, 1) over(partition by m.claimNumber, m.lineNumber order by m.stageId) = 'R' then lead(m.copayment, 1) over(partition by m.claimNumber, m.lineNumber order by m.stageId) end        copayment_reversed"
"	  ,case when lead(m.claimStatus, 1) over(partition by m.claimNumber, m.lineNumber order by m.stageId) = 'R' then lead(m.deductible, 1) over(partition by m.claimNumber, m.lineNumber order by m.stageId) end       deductible_reversed"
"	  ,case when lead(m.claimStatus, 1) over(partition by m.claimNumber, m.lineNumber order by m.stageId) = 'R' then lead(m.ppoSavings, 1) over(partition by m.claimNumber, m.lineNumber order by m.stageId) end       ppoSavings_reversed"
"	  ,case when lead(m.coinsurance, 1) over(partition by m.claimNumber, m.lineNumber order by m.stageId) = 'R' then lead(m.coinsurance, 1) over(partition by m.claimNumber, m.lineNumber order by m.stageId) end      coinsurnace_reversed"
"	  ,case when lead(m.claimStatus, 1) over(partition by m.claimNumber, m.lineNumber order by m.stageId) = 'R' then lead(m.cobAmount, 1) over(partition by m.claimNumber, m.lineNumber order by m.stageId) end        cobAmount_reversed"
"	  ,case when lead(m.claimStatus, 1) over(partition by m.claimNumber, m.lineNumber order by m.stageId) = 'R' then lead(m.paidAmount, 1) over(partition by m.claimNumber, m.lineNumber order by m.stageId)  end      paidAmount_reversed"
"	  ,case when lead(m.claimStatus, 1) over(partition by m.claimNumber, m.lineNumber order by m.stageId) = 'R' then lead(m.serviceUnits, 1) over(partition by m.claimNumber, m.lineNumber order by m.stageId) end     serviceUnits_reversed"
"	  ,m.*"
  from EdmStage.MAL_MedicalClaim m
  join professionalClaimList cl on m.claimNumber = cl.claimNumber ;

#NAME?
#NAME?
#NAME?
#NAME?
merge into EdmStage.MAL_ProfessionalClaim m
using (select currentFileRequestId
             ,rowNumber
             ,row_number() over(partition by 1 order by stageId) stageId -- resequence stageId so jms queues won't puke
"	    from EdmStage.MAL_ProfessionalClaim) u"
   on m.rowNumber = u.rowNumber
  when matched then update set m.fileRequestId = u.currentFileRequestId
"                              ,m.stageId = u.stageId ; 	1	2020-12-07 09:00:28.3433333	mssql"
"244	42	MERGE_OPTUM-HCPCS-CHANGE	declare @fileRequestId bigint = :fileRequestId ;"

merge into Reference.Hcpcs m
using (select h.hcpcsId
             ,convert(datetime2, c.originalStart, 101) hcpcsEffectiveDate
         from EdmStage.Optum_HCPCSChangeHistory c
         join Reference.Hcpcs h on c.code = h.hcpcsCode
        where c.changeType = 'D' 
          and h.hcpcsEffectiveDate is null) u
  on m.hcpcsId = u.hcpcsId
" when matched then update set m.hcpcsEffectiveDate = u.hcpcsEffectiveDate ; 	1	2020-12-18 14:52:55.9400000	mssql"
"245	75	MPI-INSERT_BULK_REQUEST_STAGE	declare @fileRequestId bigint = :fileRequestId ;"

insert into MPI.BulkRequestStage
       (BulkRequestStageId
       ,ClientIdentifier
       ,OriginalPatientIdentifier
       ,CurrentPatientIdentifier
       ,PolicyNumber
       ,FirstName
       ,MiddleName
       ,LastName
       ,SSN
       ,DOB
       ,Gender
       ,AddressLine1
       ,AddressLine2
       ,City
       ,State
       ,ZIP
       ,Telephone)
select m.stageId BulkRequestStageId
      ,c.clientCode ClientIdentifier
      ,left(m.dependentID, 9) + '0'+ right(m.dependentID, 1) OriginalPatientIdentifier
      ,right('000000000' + m.idNumber, 9) CurrentPatientIdentifier
      ,left(m.dependentID, 9) PolicyNumber
      ,isnull(m.employeeFirstName, 'UNKNOWN') FirstName
      ,null MiddleName
      ,isnull(case when m.employeeLastName = '@' then null else m.employeeLastName end, 'UNKNOWN') LastName
      ,case when isnull(m.depSSN, m.employeeSSN) = '000000000' then null else right('000000000' + isnull(m.depSSN, m.employeeSSN), 9) end SSN
      ,case when year(try_convert(datetime2, replace(m.dateOfBirth, 'T', ' '))) > 1800 then left(m.dateOfBirth, 4) +'-'+ right(left(m.dateOfBirth, 7), 2) +'-'+ right(left(m.dateOfBirth, 10), 2) + ' 00:00:00' end  DOB
      ,isnull(m.employeeGender, 'U') Gender
      ,m.employeeAddress1 AddressLine1
      ,m.employeeAddress2 AddressLine2
      ,m.employeeCity City
      ,m.employeeState State
      ,case when len(m.employeeZip) > 10 then left(m.employeeZip, 5) else m.employeeZip end ZIP
      ,case when m.employeePhoneNumberHome not like '%@%' and len(m.employeePhoneNumberHome) < 12 then m.employeePhoneNumberHome end Telephone
  from EdmStage.EWTF_MemberCSV m
  join EdmLib.FileRequest fr on fr.fileRequestId = @fileRequestId
  join Reference.Client c on fr.clientId = c.clientId
 where m.fileRequestId = @fileRequestId
   and (m.employeeFirstName is NOT null
     or m.employeeLastName is NOT null
"     or m.dateOfBirth is NOT null)	1	2020-12-22 11:06:38.6533333	mssql"
"246	75	MPI-MISSING_MPI_COUNT	select count(*) from EdmStage.EWTF_MemberCSV where enterprisePatientId is null"
and (employeeFirstName is NOT null
     or employeeLastName is NOT null
"     or dateOfBirth is NOT null) 	1	2020-12-29 09:17:19.6433333	mssql"
"247	75	MPI-DUPLICATE_MPI_COUNT	select count(*)"
  from (select enterprisePatientId
              ,count(*) recordCount
                  ,string_agg(m.depSSN, ', ') within group (order by m.depSSN) patientSsnList
                  ,count(distinct depSSN) patientSsnCount
                  ,string_agg(m.dateOfBirth, ', ') within group (order by m.depSSN) birthDateList
                  ,count(distinct dateOfBirth) birthDateCount
                  ,string_agg(m.employeeGender, ', ')  within group (order by m.depSSN) genderList
                  ,count(distinct employeeGender) genderCount
                  ,max(fileRequestId) fileRequestId
                  ,string_agg(m.stageId, ', ') within group (order by m.depSSN) stageIdList
          from EdmStage.EWTF_MemberCSV m
"		  where 1 = 2 -- make this always return 0"
         group by m.enterprisePatientId
        having count(distinct case when m.depSSN = '000000000' then null else m.depSSN end) > 1
            or count(distinct m.dateOfBirth) > 1
"            or count(distinct m.employeeGender) > 1) x ;	1	2020-12-29 11:25:38.6300000	mssql"
"248	75	CSV-UPDATE_SUBSCRIBER_INFO	declare @fileRequestId bigint = :fileRequestId ;"

update EdmStage.EWTF_MemberCSV    
   set subscriberPrimaryNumberQualifier = null
 where subscriberPrimaryNumberQualifier is not null
   and enterpriseSubscriberId is null ;

update EdmStage.EWTF_MemberCSV 
   set enterpriseSubscriberId = enterprisePatientId
      ,subscriberPrimaryNumberQualifier = 'MI'
 where dependentID like '%*0' 
   and enterprisePatientId is not null;

drop table if exists ##ewtf_member_csv_dependent_list ;

with subscriberList as
     (select distinct 
"	         dependentID"
"	        ,enterprisePatientId"
"	    from EdmStage.EWTF_MemberCSV "
"	   where dependentID like '%*0'"
"	     and enterprisePatientId is not null)"
select d.stageId
      ,s.enterprisePatientId enterpriseSubscriberId
  into ##ewtf_member_csv_dependent_list 
  from EdmStage.EWTF_MemberCSV d
  join subscriberList s on left(d.dependentID, 10)+'0' = s.dependentID
    -- dependent
 where d.dependentID not like '%*0' ;

merge into EdmStage.EWTF_MemberCSV m
using ##ewtf_member_csv_dependent_list u
   on m.stageId = u.stageId
  and m.fileRequestId = @fileRequestId
 when matched then update set m.enterpriseSubscriberId = u.enterpriseSubscriberId 
"                             ,m.subscriberPrimaryNumberQualifier = 'MI'; 	1	2020-12-29 11:43:32.0566667	mssql"
"249	75	CSV-PREPROCESS-STEP_02_PURGE_MISSING_INFO	declare @fileRequestId bigint = :fileRequestId ;"

drop table if exists ##ewtf_member_csv_all ;

select *
  into ##ewtf_member_csv_all
  from Edmstage.EWTF_MemberCSV ;

declare @firstCoverageThruDate datetime2 = '2018-01-01' ;

if (@firstCoverageThruDate < dateadd(year, -3, convert(date, sysdatetime())))
"	set @firstCoverageThruDate = dateadd(year, -3, convert(date, sysdatetime())) ;"

-- select @firstCoverageThruDate ;

-- if there isn't any "bad" data to supress then don't run this
if (select count(*) 
      from ##ewtf_member_csv_all
     where not (fromDateOfCoverage is not null
            and (thruDateOfCoverage is null or try_convert(datetime2,replace(thruDateOfCoverage, 'T', ' ')) >= @firstCoverageThruDate))) > 0
begin
"	truncate table EdmStage.EWTF_MemberCSV ;"

"	insert into EdmStage.EWTF_MemberCSV"
"		  (stageId"
"		  ,fileRequestId"
"		  ,employerCode"
"		  ,employerCodeName"
"		  ,employeeSSN"
"		  ,hrIdNumber"
"		  ,employeeFirstName"
"		  ,employeeMiddleName"
"		  ,employeeLastName"
"		  ,employeeGender"
"		  ,employeeAddress1"
"		  ,employeeAddress2"
"		  ,employeeCity"
"		  ,employeeState"
"		  ,employeeZip"
"		  ,employeePhoneNumberHome"
"		  ,hireDate"
"		  ,termDate"
"		  ,subgroup"
"		  ,fromDateofCoverage"
"		  ,thruDateofCoverage"
"		  ,level1Id21"
"		  ,coverageLevel"
"		  ,coveragecodesInfoDescription"
"		  ,dependentID"
"		  ,relationshiptoEmployee"
"		  ,dateOfBirth"
"		  ,depSSN"
"		  ,idNumber"
"		  ,enterprisePatientId"
"		  ,patientPrimaryNumber"
"		  ,patientPrimaryNumberQualifier"
"		  ,enterpriseSubscriberId"
"		  ,subscriberPrimaryNumber"
"		  ,subscriberPrimaryNumberQualifier"
"		  ,rowNumber)"
"	select row_number() over(partition by 1 order by stageId) stageId"
"		  ,fileRequestId"
"		  ,employerCode"
"		  ,employerCodeName"
"		  ,employeeSSN"
"		  ,hrIdNumber"
"		  ,employeeFirstName"
"		  ,employeeMiddleName"
"		  ,employeeLastName"
"		  ,employeeGender"
"		  ,employeeAddress1"
"		  ,employeeAddress2"
"		  ,employeeCity"
"		  ,employeeState"
"		  ,employeeZip"
"		  ,employeePhoneNumberHome"
"		  ,hireDate"
"		  ,termDate"
"		  ,subgroup"
"		  ,fromDateofCoverage"
"		  ,thruDateofCoverage"
"		  ,level1Id21"
"		  ,coverageLevel"
"		  ,coveragecodesInfoDescription"
"		  ,dependentID"
"		  ,relationshiptoEmployee"
"		  ,dateOfBirth"
"		  ,depSSN"
"		  ,idNumber"
"		  ,enterprisePatientId"
"		  ,patientPrimaryNumber"
"		  ,patientPrimaryNumberQualifier"
"		  ,enterpriseSubscriberId"
"		  ,subscriberPrimaryNumber"
"		  ,subscriberPrimaryNumberQualifier"
"		  ,stageId rowNumber"
"	  from ##ewtf_member_csv_all"
"	 where fromDateOfCoverage is not null"
"	   and (thruDateOfCoverage is null or try_convert(datetime2,replace(thruDateOfCoverage, 'T', ' ')) >= @firstCoverageThruDate) ; "

"end ; 	1	2020-12-30 09:42:33.3233333	mssql"
"250	75	CSV-PREPROCESS-STEP_01_LINK_COVERAGE	declare @fileRequestId bigint = :fileRequestId ;"

#NAME?
merge into EdmStage.EWTF_MemberCSV m
using (
select stageId
      ,try_convert(date, dateOfBirth, 101) newDateOfBirth
"	  ,try_convert(date, hireDate, 101) newHireDate"
"	  ,try_convert(date, termDate, 101) newTermDate"
"	  ,try_convert(date, fromDateofCoverage, 101) newFromDateOfCoverage"
"	  ,try_convert(date, thruDateofCoverage, 101) newThruDateOfCoverage"
  from EdmStage.EWTF_MemberCSV
 where try_convert(date, dateOfBirth, 101) is not null
    or try_convert(date, hireDate, 101) is not null
"	or try_convert(date, termDate, 101) is not null"
"	or try_convert(date, fromDateofCoverage, 101) is not null"
"	or try_convert(date, thruDateofCoverage, 101) is not null"
) u
on m.stageId = u.stageId
when matched then update set m.dateOfBirth = isnull(u.newDateOfBirth, m.dateOfBirth)
                            ,m.hireDate = isnull(u.newHireDate, m.hireDate)
                            ,m.termDate = isnull(u.newTermDate, m.termDate)
                            ,m.fromDateofCoverage = isnull(u.newFromDateOfCoverage, m.fromDateofCoverage)
                            ,m.thruDateofCoverage = isnull(u.newThruDateOfCoverage, m.thruDateofCoverage) ;

if (select count(*)
      from EdmStage.EWTF_MemberCSV m 
"	 where m.subgroup is null"
       and m.fromDateofCoverage is null) > 0
begin

"	if (select count(*) "
"		  from sys.indexes "
"		 where name = 'EWTF_MemberCSV_PreprocessIdx'"
"		   and object_id = object_id('EdmStage.EWTF_MemberCSV')) = 1"
"		drop index EWTF_MemberCSV_PreprocessIdx  on EdmStage.EWTF_MemberCSV ;"

"	create nonclustered index EWTF_MemberCSV_PreprocessIdx "
"						   on EdmStage.EWTF_MemberCSV ([stageId]) ;"

"	drop table if exists ##ewtf_coverage_link_temp ;"

"	-- link all dependents to their subscribers"
"	-- where the records are adjacent to one another"
"	-- in the file"
"	with memberList as "
"		 (select 0 lvl"
"				,fileRequestId"
"				,left(dependentID, charindex('*', dependentID)) + '0' subscriberID"
"      			,dependentID memberID"
"				,stageId subscriberStageId"
"				,stageId currentStageId"
"				,stageId previousStageId"
"			from EdmStage.EWTF_MemberCSV"
"		   where right(dependentID, 2) = '*0'"
"		   union all"
"		  select s.lvl + 1"
"				,s.fileRequestId"
"				,s.subscriberID"
"				,m.dependentID"
"				,s.subscriberStageId"
"				,m.stageId"
"				,s.currentStageId"
"			from EdmStage.EWTF_MemberCSV m"
"			join memberList s on s.subscriberID = left(m.dependentID, charindex('*', m.dependentID)) + '0' -- member has the same subscriber"
"							 and s.subscriberID <> m.dependentID                                           -- member is not the subscriber"
"							 and m.stageId = s.previousStageId + 1                                         -- records are adjacent in the file (1) "
"							 and s.subscriberStageId < m.stageId                                           -- records are adjacent in the file (2) "
"							 and m.fileRequestId = s.fileRequestId)"
"	select distinct "
"		   subscriberStageId"
"		  ,currentStageId memberStageId"
"	  into ##ewtf_coverage_link_temp"
"	  from memberList "
"	option (maxdop 4) ;"

"	merge into EdmStage.EWTF_MemberCSV m"
"	using (select s.dependentID"
"				 ,s.subgroup"
"				 ,s.fromDateofCoverage"
"				 ,s.thruDateofCoverage"
"       		  ,m.stageId"
"			 from ##ewtf_coverage_link_temp x"
"			 join EdmStage.EWTF_MemberCSV s on x.subscriberStageId = s.stageId"
"													 and s.subgroup is not null"
"													 and s.fromDateofCoverage is not null"
"			 join EdmStage.EWTF_MemberCSV m on x.memberStageId = m.stageId "
"													 and m.subgroup is null"
"													 and m.fromDateofCoverage is null "
"			where s.dependentID = left(m.dependentID, charindex('*', m.dependentID)) + '0') u"
"			on m.stageId = u.stageId"
"	 when matched then update set m.subgroup = u.subgroup"
"								 ,m.fromDateofCoverage = u.fromDateofCoverage"
" 								 ,m.thruDateofCoverage = u.thruDateofCoverage ;"
"							 "

"	if (select count(*) "
"		  from sys.indexes "
"		 where name = 'EWTF_MemberCSV_PreprocessIdx'"
"		   and object_id = object_id('EdmStage.EWTF_MemberCSV')) = 1"
"		drop index EWTF_MemberCSV_PreprocessIdx  on EdmStage.EWTF_MemberCSV ;"

"end ;	1	2021-01-12 16:49:33.4900000	mssql"
"251	75	CSV-GET_TOTAL_RECORD_COUNT	declare @fileRequestId bigint = :fileRequestId ;"

"select count(*) from EdmStage.EWTF_MemberCSV where fileRequestId = @fileRequestId ;	1	2021-01-12 17:02:39.7066667	mssql"
"252	75	HWB_LOAD_HISTORY-CLAIM_EXTRACT	declare @fileRequestId bigint = :fileRequestId ;"

insert into EdmStage.EWTF_Claim_UHCDailyExtractHistory
select *
"  from EdmStage.EWTF_Claim_UHCDailyExtract ;	1	2021-01-22 09:18:22.5933333	mssql"
"253	75	VALIDATE_UHC_DX_LIST_LOAD	declare @fileRequestId bigint = :fileRequestId ;"

if (select count(*)
      from EdmLib.FileRequest
     where fileRequestId = @fileRequestId 
       and totalLineCount <> clientModelRecordCount) > 0
"	throw 51000, 'File failed to load every record.', 16 ; "
"	"
"select 1	1	2021-01-22 13:22:07.4900000	mssql"
"254	75	HWB_VALIDATE_REFERRAL-CLAIM_EXTRACT	declare @fileRequestId bigint = :fileRequestId ;"
declare @runId bigint = :runId ;

declare @clientId int ;
declare @clientCode nvarchar(20) ;

select @clientId = c.clientId
      ,@clientCode = c.clientCode
  from EdmLib.FileRequest f
  join Reference.Client c on f.clientId = c.clientId
 where f.fileRequestId = @fileRequestId ;

insert into EdmStage.HWB_ReferralFeedback
(runId
,stageId
,fileRequestId
,configuredRuleId
,feedbackMessage
,feedbackType
,fieldName
,originalFieldValue
,createDateTime
,recordCount)
select @runId
      ,r.stageId
      ,r.fileRequestId
"	  ,0 configuredRuleId"
"	  ,case when r.moduleCode is null then '[moduleCode] is required.'"
"	        when m.moduleId is null and r.moduleCode is not null then '[moduleCode] is invalid.'"
       end feedbackMessage
"	  ,case when r.moduleCode is null or m.moduleId is null then 'E' end feedbackType"
"	  ,'[moduleCode]' fieldName"
"	  ,r.moduleCode originalFieldValue"
"	  ,sysdatetime() createDateTime"
"	  ,1 recordCount"
  from EdmStage.EWTF_CaseManagement_DX_list r
  left join ProgramModule.Module m on r.moduleCode = m.moduleCode
 where m.moduleId is null ;

insert into EdmStage.HWB_ReferralFeedback
(runId
,stageId
,fileRequestId
,configuredRuleId
,feedbackMessage
,feedbackType
,fieldName
,originalFieldValue
,createDateTime
,recordCount)
select @runId
      ,r.stageId
      ,r.fileRequestId
"	  ,0 configuredRuleId"
"	  ,case when s.servicesId is null and r.servicesCode is not null then '[servicesCode] is invalid.'"
       end feedbackMessage
"	  ,case when s.servicesId is null and r.servicesCode is not null then 'E' end feedbackType"
"	  ,'[servicesCode]' fieldName"
"	  ,r.servicesCode originalFieldValue"
"	  ,sysdatetime() createDateTime"
"	  ,1 recordCount"
  from EdmStage.EWTF_CaseManagement_DX_list r
  left join ProgramModule.Services s on r.servicesCode = s.servicesCode
 where s.servicesId is null ;

insert into EdmStage.HWB_ReferralFeedback
(runId
,stageId
,fileRequestId
,configuredRuleId
,feedbackMessage
,feedbackType
,fieldName
,originalFieldValue
,createDateTime
,recordCount)
select @runId
"	  ,x.stageId"
      ,x.fileRequestId
      ,0 configuredRuleId
"	  ,'Ineligible member.' feedbackMessage"
"	  ,'W' feedbackType"
"	  ,null fieldName"
"	  ,null originalFieldValue"
"	  ,sysdatetime()"
"	  ,1 recordCount"
  from (select x0.*
"              ,pl0.MPIID			  "
"	          ,case x0.patient_rel"
"	                when 'EE' then '18'"
"	                when 'CH' then '19'"
"	                when 'SP' then '01' end patient_rel_t"
"        	  ,row_number() over(partition by x0.stageId, x0.fileRequestId order by pl0.MPIID, pd0.detailId desc) rn"
          from EdmStage.EWTF_Claim_UHCDailyExtractHistory x0
          left join MPI.PatientDetail pd0 on x0.patient_last_name = pd0.lastName
                                         and x0.patient_first_name = pd0.firstName
"        						         and x0.patient_dob = pd0.DOBNormalized"
"        								 and pd0.activeFlag = 1"
"        								 and pd0.clientIdentifier = @clientCode"
          left join MPI.PatientLink pl0 on pd0.detailId = pl0.detailId
                                       and pd0.ClientIdentifier = pl0.clientIdentifier
"        							   and pl0.ActiveFlag = 1) x"
  left join Patient.PatientDim pd on x.MPIID = pd.enterprisePatientId
                                 and pd.clientId = @clientId
"								 and x.patient_last_name = pd.patientLastName"
                                 and x.patient_first_name = pd.patientFirstName
"        						 and x.patient_dob = pd.patientBirthDate"
  left join Patient.EligibilityFact ef on pd.clientId = ef.clientId
                                      and pd.patientId = ef.patientId
"									  and ef.eligibilityFactActiveFlag = 1"
"									  and ef.benefitPlanStartDate <= convert(date, sysdatetime())"
"									  and (ef.benefitPlanEndDate > convert(date, sysdatetime()) or ef.benefitPlanEndDate is null)"
  left join Reference.GroupPolicy gp on ef.groupPolicyId = gp.groupPolicyId
 where x.rn = 1 
   and (pd.patientId is null
     or isnull(gp.groupPolicyName, 'NE') = 'NE');  
"	 "
merge into EdmStage.EWTF_Claim_UHCDailyExtractHistory m
using (select r.stageId
             ,max(case when f.feedbackType = 'E' then 1 else 0 end) hasError
         from EdmStage.EWTF_Claim_UHCDailyExtractHistory r 
         left join EdmStage.HWB_ReferralFeedback f on r.fileRequestId = f.fileRequestId
                                                  and f.runId = @runId
"										          and r.stageId = f.stageId"
        where r.fileRequestId = @fileRequestId
"		group by r.stageId) u"
  on m.stageId = u.stageId
when matched then update set m.hasError = u.hasError;
"	 	1	2021-01-22 13:34:41.6433333	mssql"
"255	75	HWB_GET_REFERRAL_WARNING_COUNT-CLAIM_EXTRACT	declare @fileRequestId bigint = :fileRequestId ;"
declare @runId bigint = :runId ;

select count(*)
  from EdmStage.HWB_ReferralFeedback
 where fileRequestId = @fileRequestId 
   and runId = @runId 
"   and feedbackType = 'W' ;	1	2021-01-22 13:36:33.1600000	mssql"
"256	75	HWB_GET_REFERRAL_ERROR_COUNT-CLAIM_EXTRACT	declare @fileRequestId bigint = :fileRequestId ;"
declare @runId bigint = :runId ;

select count(*)
  from EdmStage.HWB_ReferralFeedback
 where fileRequestId = @fileRequestId 
   and runId = @runId 
"   and feedbackType = 'E' ;	1	2021-01-22 13:38:53.5333333	mssql"
"257	75	HWB_LOAD_REFERRAL_HISTORY-CLAIM_EXTRACT	declare @fileRequestId bigint = :fileRequestId ;"

declare @cptSurgeryList 
  table (surgeryGroup nvarchar(100)
        ,cpt nvarchar(10)) ;

insert into @cptSurgeryList 
(surgeryGroup, cpt)
values 
 ('Knee', '27441')
,('Knee', '27442')
,('Knee', '27443')
,('Knee', '27445')
,('Knee', '27446')
,('Knee', '27447')
,('Knee', '27489') 
,('Knee', '27487')
,('Knee', '27488')
,('Hip', '27120')
,('Hip', '27125')
,('Hip', '27130')
,('Hip', '27132')
,('Hip', '27134')
,('Hip', '27137')
,('Hip', '27138')
,('Hip', '27090')
,('Hip', '27091')
,('Spine', '22551')
,('Spine', '22552')
,('Spine', '22853')
,('Spine', '22845')
,('Spine', '22846')
,('Spine', '22847') 
,('Spine', '20930')
,('Spine', '20931')
,('Spine', '20936')
,('Spine', '20937')
,('Spine', '20938')
,('Spine', '22554') 
,('Spine', '22856') 
,('Spine', '22858') 
,('Spine', '22590') 
,('Spine', '2260') 
,('Spine', '22614')
,('Spine', '22840')
,('Spine', '22841')
,('Spine', '22842')
,('Spine', '22843')
,('Spine', '22844')
,('Spine', '63050')
,('Spine', '63051')
,('Spine', '22558')
,('Spine', '22612')
,('Spine', '22614')
,('Spine', '63030')
,('Spine', '63035')
,('Spine', '63047')
,('Spine', '63048')
,('Spine', '22853')
,('Spine', '63005')
,('Spine', '63017')
,('Spine', '63012')
,('Spine', '63042')
,('Spine', '63044')
,('Spine', '22867')
,('Spine', '22868')
,('Spine', '22869')
,('Spine', '22870')
,('Bariatric', '43631') 
,('Bariatric', '43632') 
,('Bariatric', '43633') 
,('Bariatric', '43644') 
,('Bariatric', '43645') 
,('Bariatric', '43659')
,('Bariatric', '43770')
,('Bariatric', '43771')
,('Bariatric', '43772')
,('Bariatric', '43773')
,('Bariatric', '43774')
,('Bariatric', '43775')
,('Bariatric', '43842')
,('Bariatric', '43843')
,('Bariatric', '43845')
,('Bariatric', '43846')
,('Bariatric', '43847')
,('Bariatric', '43848') ;

--select l.*
--      ,h.hcpcsId
"--	  ,h.hcpcsLevel"
"--	  ,h.hcpcsLevelType"
#NAME?
#NAME?
#NAME?
--    or h.hcpcsLevelType <> 'CPT' ;

declare @clientId int ;
declare @clientCode nvarchar(20) ;
select @clientId = c.clientId
      ,@clientCode = c.clientcode 
  from EdmLib.FileRequest f
  join Reference.Client c on f.clientId = c.clientId
 where f.fileRequestId = @fileRequestId ;

drop table if exists ##ewtf_uhc_member_link ;

select distinct 
       pd.enterprisePatientId
      ,pd.patientPrimaryNumber
      ,x.fileRequestId
"	  ,x.stageId"
  into ##ewtf_uhc_member_link
  from (select x0.*
"              ,pl0.MPIID	"
"	            ,case x0.patient_rel"
"	                  when 'EE' then '18'"
"	                  when 'CH' then '19'"
"	                  when 'SP' then '01' end patient_rel_t"
"        	    ,row_number() over(partition by x0.stageId, x0.fileRequestId order by pl0.MPIID, pd0.detailId desc) rn"
          from EdmStage.EWTF_Claim_UHCDailyExtractHistory x0
          left join MPI.PatientDetail pd0 on x0.patient_last_name = pd0.lastName
                                         and x0.patient_first_name = pd0.firstName
"        						         and x0.patient_dob = pd0.DOBNormalized"
"        								 and pd0.activeFlag = 1"
"        								 and pd0.clientIdentifier = @clientCode"
          left join MPI.PatientLink pl0 on pd0.detailId = pl0.detailId
                                       and pd0.ClientIdentifier = pl0.clientIdentifier
"        							     and pl0.ActiveFlag = 1"
          where x0.fileRequestId = @fileRequestId
            and x0.enterprisePatientId is null) x
  left join Patient.PatientDim pd on x.MPIID = pd.enterprisePatientId
                                 and pd.clientId = @clientId
"								   and x.patient_last_name = pd.patientLastName"
                                 and x.patient_first_name = pd.patientFirstName
"        						   and x.patient_dob = pd.patientBirthDate"
                                 and pd.patientActiveFlag = 1
  left join Patient.EligibilityFact ef on pd.clientId = ef.clientId
                                      and pd.patientId = ef.patientId
"									    and ef.eligibilityFactActiveFlag = 1"
"									    and ef.benefitPlanStartDate <= convert(date, sysdatetime())"
"									    and (ef.benefitPlanEndDate > convert(date, sysdatetime()) or ef.benefitPlanEndDate is null)"
  left join Reference.GroupPolicy gp on ef.groupPolicyId = gp.groupPolicyId
 where x.rn = 1 ;

merge into EdmStage.EWTF_Claim_UHCDailyExtractHistory m
 using ##ewtf_uhc_member_link u
   on m.fileRequestId = u.fileRequestId
  and m.stageId = u.stageId
 when matched then update set m.enterprisePatientId = u.enterprisePatientId
                             ,m.patientPrimaryNumber = u.patientPrimaryNumber ;


drop table if exists ##hwb_ewtf_referral ;

-- admission greater than 4 days
select h.fileRequestId
      ,h.stageId
"	  ,@clientId clientId"
"	  ,@clientCode clientCode"
"	  ,h.enterprisePatientId"
"	  ,h.patientPrimaryNumber"
"	  ,h.hasError"
"	  ,isnull(dx.programName, 'Non-Catastrophic') programName"
"	  ,isnull(dx.moduleCode, 'CM') moduleCode"
"	  ,isnull(dx.servicesCode, 'NC') serviceCode"
  into ##hwb_ewtf_referral 
  from EdmStage.EWTF_Claim_UHCDailyExtractHistory h
  left join EdmStage.EWTF_CaseManagement_DX_list dx on dx.dxCode = h.diag_code1
 where h.fileRequestId = @fileRequestId 
   and h.enterprisePatientId is not null
   and datediff(day, h.expected_admit_date, h.expected_discharge_date) > 4 
 union all 
-- prospective admission (defined as having an admit date greater than 2 days out from the notification date)
select h.fileRequestId
      ,h.stageId
"	  ,@clientId clientId"
"	  ,@clientCode clientCode"
"	  ,h.enterprisePatientId"
"	  ,h.patientPrimaryNumber"
"	  ,h.hasError"
"	  ,isnull(dx.programName, 'Non-Catastrophic') programName"
"	  ,isnull(dx.moduleCode, 'CM') moduleCode"
"	  ,isnull(dx.servicesCode, 'NC') serviceCode"
  from EdmStage.EWTF_Claim_UHCDailyExtractHistory h
  left join EdmStage.EWTF_CaseManagement_DX_list dx on dx.dxCode = h.diag_code1
 where h.fileRequestId = @fileRequestId 
   and h.enterprisePatientId is not null
   and datediff(day, h.notification_date, h.expected_admit_date) > 2  
 union all 
#NAME?
select h.fileRequestId
      ,h.stageId
"	  ,@clientId clientId"
"	  ,@clientCode clientCode"
"	  ,h.enterprisePatientId"
"	  ,h.patientPrimaryNumber"
"	  ,h.hasError"
"	  ,isnull(dx.programName, 'Non-Catastrophic') programName"
"	  ,isnull(dx.moduleCode, 'CM') moduleCode"
"	  ,isnull(dx.servicesCode, 'NC') serviceCode"
  from EdmStage.EWTF_Claim_UHCDailyExtractHistory h
  left join EdmStage.EWTF_CaseManagement_DX_list dx on dx.dxCode = h.diag_code1
  join @cptSurgeryList c on c.cpt in (h.proc_cd1, h.proc_cd2, h.proc_cd3, h.proc_cd4, h.proc_cd5, h.proc_cd6, h.proc_cd7, h.proc_cd8)
 where h.fileRequestId = @fileRequestId 
   and h.enterprisePatientId is not null 
 union all
-- admission greater than 1 day AND any DX on the list
select h.fileRequestId
      ,h.stageId
"	  ,@clientId clientId"
"	  ,@clientCode clientCode"
"	  ,h.enterprisePatientId"
"	  ,h.patientPrimaryNumber"
"	  ,h.hasError"
"	  ,isnull(dx.programName, 'Non-Catastrophic') programName"
"	  ,isnull(dx.moduleCode, 'CM') moduleCode"
"	  ,isnull(dx.servicesCode, 'NC') serviceCode"
  from EdmStage.EWTF_Claim_UHCDailyExtractHistory h
  left join EdmStage.EWTF_CaseManagement_DX_list dx on dx.dxCode = h.diag_code1
  join EdmStage.EWTF_CaseManagement_DX_list cm on cm.dxCode in (h.diag_code1, h.diag_code2, h.diag_code3, h.diag_code4, h.diag_code5)
 where h.fileRequestId = @fileRequestId 
   and h.enterprisePatientId is not null
   and datediff(day, h.expected_admit_date, h.expected_discharge_date) > 1  ;

drop table if exists ##hwb_ewtf_referral_rnk ;

select *
      ,row_number() over(partition by fileRequestId, enterprisePatientId order by case when serviceCode <> 'NC' then 1 else 2 end, serviceCode) rnk
  into ##hwb_ewtf_referral_rnk
  from ##hwb_ewtf_referral ; 

delete from EdmStage.HWB_ReferralHistory 
 where fileRequestId = @fileRequestId ;

insert into EdmStage.HWB_ReferralHistory
      (stageId
      ,fileRequestId
      ,clientId
      ,clientCode
      ,enterprisePatientId
      ,patientPrimaryNumber
      ,moduleCode
      ,moduleName
      ,servicesCodeList
      ,servicesNameList
      ,prinDX
      ,otherDxCodeList
      ,otherDxDateList
      ,referralDate
      ,forceRefer
      ,rationale
      ,firstName
      ,lastName
      ,birthDate
      ,ssn
      ,hasError
      ,addressLine1
      ,addressLine2
      ,city
      ,state
      ,zip)
select stageId
      ,fileRequestId
"	  ,clientId"
"	  ,clientcode"
"	  ,enterprisePatientId"
"	  ,patientPrimaryNumber"
"	  ,moduleCode"
"	  ,null moduleName"
"	  ,serviceCode servicesCodeList"
"	  ,null servicesNameList"
"	  ,null prinDX"
"	  ,null otherDxCodeList"
"	  ,null otherDxDateList"
"	  ,null referralDate"
"	  ,'FALSE' forceRefer"
"	  ,null rationale"
"	  ,null firstName"
"	  ,null lastName"
"	  ,null birthDate"
"	  ,null ssn"
"	  ,isnull(hasError, 0) hasError"
"	  ,null addressLine1"
"	  ,null addressLine2"
"	  ,null city"
"	  ,null state"
"	  ,null zip"
  from ##hwb_ewtf_referral_rnk 
" where rnk = 1 ; 	1	2021-01-22 13:41:10.1400000	mssql"
"258	77	MPI-INSERT_BULK_REQUEST_STAGE	declare @fileRequestId bigint = :fileRequestId ;"

 insert into MPI.BulkRequestStage
       (BulkRequestStageId
       ,ClientIdentifier
       ,OriginalPatientIdentifier
       ,CurrentPatientIdentifier
       ,PolicyNumber
       ,FirstName
       ,MiddleName
       ,LastName
       ,SSN
       ,DOB
       ,Gender
       ,AddressLine1
       ,AddressLine2
       ,City
       ,State
       ,ZIP
       ,Telephone)
select m.stageId BulkRequestStageId
      ,c.clientCode ClientIdentifier
      ,m.claimKey OriginalPatientIdentifier
      ,m.claimKey CurrentPatientIdentifier
      ,m.mbrId PolicyNumber
      ,isnull(m.firstName, 'UNKNOWN') FirstName
      ,null MiddleName
      ,isnull(m.lastName, 'UNKNOWN') LastName
      ,case when m.depSsn = '000000000' then null else  m.depSsn end SSN
      ,case when year(try_convert(datetime2, replace(m.dateOfBirth, 'T', ' '))) > 1800 then left(m.dateOfBirth, 4) +'-'+ right(left(m.dateOfBirth, 6), 2) +'-'+ right(left(m.dateOfBirth, 10), 2) + ' 00:00:00' end  DOB
      ,isnull(m.gender, 'U') Gender
      ,m.address1 AddressLine1
      ,m.address2 AddressLine2
      ,m.city City
      ,m.state State
      ,m.zipCode + isnull(m.zip4, '') ZIP
      ,m.phoneNumber Telephone
  from EdmStage.Local90_Member m
  join EdmLib.FileRequest fr on fr.fileRequestId = @fileRequestId
  join Reference.Client c on fr.clientId = c.clientId
 where m.fileRequestId = @fileRequestId
   and (m.firstName is NOT null
     or m.lastName is NOT null
"     or m.dateOfBirth is NOT null) ; 	1	2021-01-28 10:06:38.6866667	mssql"
"259	77	MPI-DUPLICATE_MPI_COUNT	select count(*)"
  from (select enterprisePatientId
              ,count(*) recordCount
                  ,string_agg(m.depSsn, ', ') within group (order by m.depSsn) patientSsnList
                  ,count(distinct depSsn) patientSsnCount
                  ,string_agg(m.dateOfBirth, ', ') within group (order by m.depSsn) birthDateList
                  ,count(distinct dateOfBirth) birthDateCount
                  ,string_agg(m.gender, ', ')  within group (order by m.depSsn) genderList
                  ,count(distinct gender) genderCount
                  ,max(fileRequestId) fileRequestId
                  ,string_agg(m.stageId, ', ') within group (order by m.depSsn) stageIdList
          from EdmStage.Local90_Member m
         group by m.enterprisePatientId
        having count(distinct case when m.depSsn = '000000000' then null else m.depSsn end) > 1
            or count(distinct m.dateOfBirth) > 1
"            or count(distinct m.gender) > 1) x	1	2021-01-29 09:25:21.8866667	mssql"
"260	77	PREPROCESS-POST_MPI	declare @fileRequestId bigint = :fileRequestId ;"

update EdmStage.Local90_Member
   set patientPrimaryNumber = claimKey
      ,patientPrimaryNumberQualifier = 'MI'
 where patientPrimaryNumber is null ; 

with dependentAndSubscriberList as
     (select mbrId
            ,max(case when covType = 'EMP' then enterprisePatientId end) enterpriseSubscriberId
            ,max(case when covType = 'EMP' then patientPrimaryNumber end) subscriberPrimaryNumber
"     	    ,count(*) coveredCount"
"     	    ,count(distinct case when covType = 'EMP' then enterprisePatientId end) enterpriseSubscriberIdCount"
"     	    ,string_agg(stageId, ',') stageIdList"
        from EdmStage.Local90_Member
       group by mbrId 
       having count(distinct case when covType = 'EMP' then enterprisePatientId end) = 1)
merge into EdmStage.Local90_Member m
using (select x.value stageId
             ,l.enterpriseSubscriberId
"			 ,l.subscriberPrimaryNumber"
         from dependentAndSubscriberList l
         cross apply string_split(l.stageIdList, ',') x) u
  on m.stageId = u.stageId
  when matched then update set m.enterpriseSubscriberId = u.enterpriseSubscriberId
                              ,m.subscriberPrimaryNumber = u.subscriberPrimaryNumber
"							  ,m.subscriberPrimaryNumberQualifier = 'MI'"
"							  ,m.patientPrimaryNumberQualifier = 'MI' ;	1	2021-01-29 12:29:46.8300000	mssql"
"261	77	GET_TOTAL_RECORD_COUNT	declare @fileRequestId bigint = :fileRequestId ;"
"select count(*) from EdmStage.Local90_Member ;	1	2021-01-29 12:32:43.3266667	mssql"
"262	77	MPI-INSERT_MANUAL_MEMBERS	declare @fileRequestId bigint = :fileRequestId ;"

declare @maxId bigint ;
select @maxId = max(stageId)
  from EdmStage.Local90_Member ;

insert into EdmStage.Local90_Member 
      (stageId 
      ,fileRequestId
"	  ,claimKey"
"	  ,corp"
"	  ,div"
"	  ,corpName"
"	  ,divName"
"	  ,empSsn"
"	  ,depSsn"
"	  ,mbrId"
"	  ,lastName"
"	  ,firstName"
"	  ,gender"
"	  ,dateOfBirth"
"	  ,covType"
"	  ,address1"
"	  ,address2"
"	  ,city"
"	  ,state"
"	  ,zipCode"
"	  ,zip4"
"	  ,phoneNumber"
"	  ,effDate"
"	  ,termDate)"
select @maxId + row_number() over(partition by 1 order by p.patientId, e.eligibilityFactId) stageId 
      ,@fileRequestId fileRequestId
"	  ,convert(varchar(17), enterprisePatientId) claimKey"
"	  ,null corp"
"	  ,null div"
"	  ,null corpName"
"	  ,null divName"
"	  ,null empSsn"
"	  ,convert(varchar(9), patientSsn) depSsn"
"	  ,convert(varchar(10), patientPrimaryNumber) mbrId"
"	  ,left(patientLastName, 15) lastName"
"	  ,left(patientFirstName, 12) firstName"
"	  ,patientGenderCode gender"
"	  ,try_convert(varchar(8), patientBirthDate, 112) dateOfBirth"
"	  ,rel.inValue covType"
"	  ,null address1"
"	  ,null address2"
"	  ,null city"
"	  ,null state"
"	  ,null zipCode"
"	  ,null zip4"
"	  ,null phoneNumber"
"	  ,null effDate"
"	  ,null termDate"
  from Patient.PatientDim p
  left join Patient.EligibilityFact e on p.clientId = e.clientId
                                     and p.patientId = e.patientId
"									 and e.eligibilityFactActiveFlag = 1"
  left join EdmLib.Mapping rel on p.relationshipCode = rel.outValue
                              and rel.name = 'L90-RELATIONSHIP_CODE'
 where p.clientId = 77
   and p.patientActiveFlag = 1
   and p.createDateTime > dateadd(day, -30, sysdatetime())
"   and p.recordTypeId = 13 ; 	1	2021-01-29 14:14:36.1233333	mssql"
"263	77	MPI-UPDATE_MANUAL_MEMBERS	declare @fileRequestId bigint = :fileRequestId ;"

merge into EdmStage.Local90_Member m
using (select t.stageId
             ,t.fileRequestId
             ,m.claimKey
             ,m.corp
             ,m.div
             ,m.corpName
             ,m.divName
             ,m.empSsn
             ,m.depSsn
             ,m.mbrId
             ,m.lastName
             ,m.firstName
             ,m.gender
             ,m.dateOfBirth
             ,m.covType
             ,m.address1
             ,m.address2
             ,m.city
             ,m.state
             ,m.zipCode
             ,m.zip4
             ,m.phoneNumber
             ,m.effDate
             ,m.termDate
             ,t.claimKey tempEnterprisePatientId 
         from EdmStage.Local90_Member t
         join EdmStage.Local90_Member m on t.enterprisePatientId = m.enterprisePatientId
                                       and not (m.claimKey like 'L90EWU%'
                                             or m.claimKey like 'TEMP%')
        where (t.claimKey like 'L90EWU%'
            or t.claimKey like 'TEMP%')) u
  on m.stageId = u.stageId
" when matched then update set m.claimKey				= u.claimKey"
"                             ,m.corp					= u.corp"
"                             ,m.div						= u.div"
"                             ,m.corpName				= u.corpName"
"                             ,m.divName					= u.divName"
"                             ,m.empSsn					= u.empSsn"
"                             ,m.depSsn					= u.depSsn"
"                             ,m.mbrId					= u.mbrId"
"                             ,m.lastName				= u.lastName"
"                             ,m.firstName				= u.firstName"
"                             ,m.gender					= u.gender"
"                             ,m.dateOfBirth				= u.dateOfBirth"
"                             ,m.covType					= u.covType"
"                             ,m.address1				= u.address1"
"                             ,m.address2				= u.address2"
"                             ,m.city					= u.city"
"                             ,m.state					= u.state"
"                             ,m.zipCode					= u.zipCode"
"                             ,m.zip4					= u.zip4"
"                             ,m.phoneNumber				= u.phoneNumber"
"                             ,m.effDate					= u.effDate"
"                             ,m.termDate				= u.termDate"
"                             ,m.tempEnterprisePatientId = u.tempEnterprisePatientId ;	1	2021-01-29 14:14:57.3366667	mssql"
"264	78	PROVIDER-PRE_PROCESS-VALIDATE	declare @fileRequestId bigint = :fileRequestId ;"

declare @misMatchNpiCount int ;

select @misMatchNpiCount = count(*)
  from EdmStage.Colorado_ProviderCMA c
  join EdmStage.Colorado_ProviderCMA_History h on c.providerLastOrOrganizationLegalName = h.providerLastOrOrganizationLegalName
                                              and h.fileRequestId < @fileRequestId
  join EdmLib.FileRequest f on h.fileRequestId = f.fileRequestId
                           and isnull(f.purged, 0) = 0
 where isnull(c.providerNPIID, '~') <> h.providerNPIID ;
 
declare @missingProviderCount int ;
select @missingProviderCount = count(*)
  from EdmStage.Colorado_ProviderCMA_History h
  join EdmLib.FileRequest f on h.fileRequestId = f.fileRequestId
                           and isnull(f.purged, 0) = 0
  left join EdmStage.Colorado_ProviderCMA c on c.providerLastOrOrganizationLegalName = h.providerLastOrOrganizationLegalName
 where h.fileRequestId < @fileRequestId
   and c.stageId is null ;

declare @errorMessage nvarchar(4000) = '' ;
if @misMatchNpiCount > 0
"	set @errorMessage = @errorMessage + 'This file contains ' + convert(varchar(10), @misMatchNpiCount) + ' mismatched NPI(s).  ';"

if @missingProviderCount > 0
"	set @errorMessage = @errorMessage + 'This file contains ' + convert(varchar(10), @missingProviderCount) + ' missing provider(s).';"

if len(@errorMessage) > 1
"	throw 51000, @errorMessage, 16 ;	1	2021-02-12 12:57:26.2600000	mssql"
"265	78	PROVIDER-PRE_PROCESS-LOAD_HISTORY	declare @fileRequestId bigint = :fileRequestId ;"

insert into EdmStage.Colorado_ProviderCMA_History
select *
"  from EdmStage.Colorado_ProviderCMA ;	1	2021-02-12 14:44:19.8866667	mssql"
"266	78	PROVIDER-PRE_PROCESS-TOTAL_RECORD_COUNT	declare @fileRequestId bigint = :fileRequestId ;"

"select count(*) from EdmStage.Colorado_ProviderCMA ;	1	2021-02-12 14:47:01.4366667	mssql"
"267	0	QT3_MONITOR_2HR_BAD_REQUEST_INFO	select string_agg('ClientiId = ' + clientId + ' has ' + caseCount + ' case(s) for ' + requestCount + ' request(s) with either a bad admissionDate or requestServiceStartDateTime', char(10)) out_put"
  from (
select convert(varchar(32), r.clientId) clientId
      ,convert(varchar(32), count(distinct r.requestId)) requestCount
"	  ,convert(varchar(32), count(distinct c.caseReferenceId)) caseCount"
  from UtilmgmtPgm.Request r
  join UtilMgmtPgm.UMPCase c on r.clientId = c.clientId
                            and r.requestId = c.requestId
 where r.requestActiveFlag = 1
   and (datediff(day, r.AdmissionDate,r.RequestReceivedDateTime) > 32000
   or datediff(day, r.RequestedServiceStartDateTime, RequestReceivedDateTime) > 32000
  -- or r.requestId between 2403012 and 2405014 -- testing
   )
   and r.clientId in 
(51 
,34
,52
,55
,64
,61
,34)
 group by r.clientId) x 
" having count(*) > 0 ;	1	2021-02-26 09:57:01.5066667	mssql"
"268	67	ARHICVE-ALL_CLAIM	declare @fileRequestId bigint = :fileRequestId ;"

declare @tableName nvarchar(100) = 'MAL_MedicalClaim' ;
declare @schemaName nvarchar(100) = 'EdmStage' ;

#NAME?
begin
"	declare @partitionFunctionName nvarchar(100) = 'MALMedicalClaimFileRequestPfnc' ;"
"	declare @partitionSchemeName nvarchar(100)   = 'MALMedicalClaimFileRequestPScheme' ;"

"	declare @createPartitionFunctionDDL nvarchar(500) = 'create partition function ' + @partitionFunctionName + ' (bigint) as range left for values (0) ;';"
"	declare @createPartitionSchemeDDL nvarchar(500) = 'create partition scheme ' + @partitionSchemeName + ' as partition ' + @partitionFunctionName + ' all to ([PRIMARY]) ; ';"

"	--print @createPartitionFunctionDDL"
"	--print @createPartitionSchemeDDL"

"	if not exists (select * from sys.partition_functions where name = @partitionFunctionName) "
"		exec sp_sqlexec @createPartitionFunctionDDL ;"

"	if not exists (select * from sys.partition_schemes where name = @partitionSchemeName)"
"		exec sp_sqlexec @createPartitionSchemeDDL ;"

"	if object_id('EdmStage.MAL_MedicalClaim_History') is null"
"	begin"

"		declare @createTableDDL varchar(max) = '' ;"

"		--print '-- create history table '"
"		select @createTableDDL = @createTableDDL + case when ordinal_position > 1 then char(10) + ',' else 'create table ' + @schemaName + '.' + @tableName + '_History ' + char(10) + '(' end + column_name + ' ' + data_type + case when data_type like '%char%' then '(' + convert(varchar(32), character_maximum_length) + ')' else '' end +"
"		       + case when column_name = 'fileRequestId' then ' not null' else '' end"
"			   + case when ordinal_position = max(ordinal_position) over(partition by table_schema, table_name) then ') ' + char(10) + ' on ' + @partitionSchemeName + '(fileRequestId)' else '' end"
"			   --, *"
"		  from information_schema.columns "
"		 where table_name = @tableName"
"		   and table_schema = @schemaName"
"		 order by ordinal_position ;"

"		print @createTableDDL ;"
"		exec sp_sqlexec @createTableDDL ;"

"		set @createTableDDL = '' ;"

"		--print '-- create final table '"
"		select @createTableDDL = @createTableDDL + case when ordinal_position > 1 then char(10) + ',' else 'create table ' + @schemaName + '.' + @tableName + '_Final ' + char(10) + '(' end + column_name + ' ' + data_type + case when data_type like '%char%' then '(' + convert(varchar(32), character_maximum_length) + ')' else '' end +"
"		       + case when column_name = 'fileRequestId' then ' not null' else '' end"
"			   + case when ordinal_position = max(ordinal_position) over(partition by table_schema, table_name) then ',rnk int) ' else '' end"
"			   --, *"
"		  from information_schema.columns "
"		 where table_name = @tableName"
"		   and table_schema = @schemaName"
"		 order by ordinal_position ;"

"		print @createTableDDL ;"
"		exec sp_sqlexec @createTableDDL ;"

"	end ;"

"	if not exists (select *"
"	                 from sys.indexes "
                    where is_primary_key = 1
"					  and object_id = object_id(@schemaName +'.'+ @tableName +'_History'))"
"	begin"
"		alter table EdmStage.MAL_MedicalClaim_History alter column stageId bigint not null ;"
"		alter table EdmStage.MAL_MedicalClaim_History add constraint MAL_MedicalClaim_History_PK primary key (fileRequestId, stageId) ;"
"	end ;"

"	if not exists (select *"
"					 from sys.partition_functions f"
"					 join sys.partition_range_values rv on f.function_id = rv.function_id"
"													   and rv.value = @fileRequestId"
"					where f.name = @partitionFunctionName)"
"	begin"
"		print 'split partition function ';"

"		declare @alterPartitionSchemeDDL nvarchar(4000) = 'alter partition scheme [' + @partitionSchemeName + '] next used [PRIMARY]' ;"
"		exec sp_sqlexec @alterPartitionSchemeDDL ;"
"		declare @alterPartitionFunctionDDL nvarchar(4000) = 'alter partition function ' + @partitionFunctionName + '() split range (' + convert(varchar(32), @fileRequestId) + ')';"
"		exec sp_sqlexec @alterPartitionFunctionDDL ;	"
"	end ;"

"	declare @truncatePartition nvarchar(500) = 'truncate table ' + @schemaName + '.' + @tableName +'_History with (partitions ($PARTITION.' + @partitionFunctionName + '(' + convert(varchar(32), @fileRequestId) + ')))';"
"	exec sp_sqlexec @truncatePartition ;"

end ;

insert into EdmStage.MAL_MedicalClaim_History
select *
  from EdmStage.MAL_MedicalClaim
" where fileRequestId = @fileRequestId ; 	1	2021-04-28 12:07:24.0833333	mssql"
"269	75	ARCHIVE-ALL_CLAIM	declare @fileRequestId bigint = :fileRequestId ;"

declare @tableName nvarchar(100) = 'EWTF_MedicalClaim' ;
declare @schemaName nvarchar(100) = 'EdmStage' ;

#NAME?
begin
"	declare @partitionFunctionName nvarchar(100) = 'EWTF_MedicalClaimHistoryPfunc' ;"
"	declare @partitionSchemeName nvarchar(100)   = 'EWTF_MedicalClaimHistoryPscheme' ;"

"	if not exists (select *"
"					 from sys.partition_functions f"
"					 join sys.partition_range_values rv on f.function_id = rv.function_id"
"													   and rv.value = @fileRequestId"
"					where f.name = @partitionFunctionName)"
"	begin"
"		print 'split partition function ';"

"		declare @alterPartitionSchemeDDL nvarchar(4000) = 'alter partition scheme [' + @partitionSchemeName + '] next used [PRIMARY]' ;"
"		exec sp_sqlexec @alterPartitionSchemeDDL ;"
"		declare @alterPartitionFunctionDDL nvarchar(4000) = 'alter partition function ' + @partitionFunctionName + '() split range (' + convert(varchar(32), @fileRequestId) + ')';"
"		exec sp_sqlexec @alterPartitionFunctionDDL ;	"
"	end ;"

"	declare @truncatePartition nvarchar(500) = 'truncate table ' + @schemaName + '.' + @tableName +'History with (partitions ($PARTITION.' + @partitionFunctionName + '(' + convert(varchar(32), @fileRequestId) + ')))';"
"	exec sp_sqlexec @truncatePartition ;"

end ;

insert into EdmStage.EWTF_MedicalClaimHistory
select *
  from EdmStage.EWTF_MedicalClaim
" where fileRequestId = @fileRequestId ; 	1	2021-05-06 09:15:50.9100000	mssql"
"270	75	ARCHIVE-PHARMACY_CLAIM	declare @fileRequestId bigint = :fileRequestId ;"

declare @clientId int ;

#NAME?
select @clientId = fr.clientId
  from EdmLib.FileRequest fr
 where fr.fileRequestId = @fileRequestId ;
 
insert into EdmStage.EWTF_PharmacyClaimHistory
select row_number() over(partition by 1 order by x.rowNumber) stageId
      ,x.*
  from (
select distinct 
       c.[fileRequestId]
      ,c.[record_type]
      ,c.[record_indicator]
      ,c.[final_plan_qualifier]
      ,isnull(m.dependentID, c.[cardholder_id]) [cardholder_id]
      ,c.[last_name]
      ,c.[first_name]
      ,c.[middle_initial]
      ,c.[cardholder_date_of_birth]
      ,c.[patient_last_name]
      ,c.[patient_first_name]
      ,c.[patient_middle_initial]
      ,c.[patient_date_of_birth]
      ,c.[patient_gender_code]
      ,c.[eligibility_or_patient_relationship_code]
      ,c.[patient_age]
      ,c.[group_id]
      ,c.[carrier_number]
      ,c.[other_coverage_code]
      ,c.[service_provider_id_qualifier]
      ,c.[service_provider_id]
      ,c.[pharmacy_name]
      ,c.[pharmacy_address_line_1]
      ,c.[pharmacy_address_line_2]
      ,c.[city]
      ,c.[state]
      ,c.[zip]
      ,c.[pharmacy_telephone_number]
      ,c.[pharmacy_dispenser_type]
      ,c.[network_reimbursement_id]
      ,c.[prescriber_id_qualifier]
      ,c.[prescriber_id]
      ,c.[prescriber_last_name]
      ,c.[prescriber_first_name]
      ,c.[record_status_code]
      ,c.[claim_media_type]
      ,c.[product_or_service_id_qualifier]
      ,c.[product_or_service_id]
      ,c.[date_of_service]
      ,c.[adjudication_date]
      ,c.[cycle_end_date]
      ,c.[d0_rx_number]
      ,c.[rx_number_qualifier]
      ,c.[quantity_dispensed]
      ,c.[fill_number]
      ,c.[days_supply]
      ,c.[date_prescription_written]
      ,c.[dispense_as_written_or_product_selection_code]
      ,c.[number_of_refills_authorized]
      ,c.[unit_of_measure]
      ,c.[original_quantity]
      ,c.[original_day_supply]
      ,c.[compound_code]
      ,c.[diagnosis_code_qualifier]
      ,c.[diagnosis_code]
      ,c.[reject_code_1]
      ,c.[reject_code_2]
      ,c.[reject_code_3]
      ,c.[database_indicator]
      ,c.[product_or_service_name]
      ,c.[generic_name]
      ,c.[product_strength]
      ,c.[dosage_form_code]
      ,c.[drug_type]
      ,c.[maintenance_drug_indicator]
      ,c.[drug_category_code]
      ,c.[submission_clarification_code]
      ,c.[gcn_number]
      ,c.[generic_product_identifier]
      ,c.[med_bd_indicator]
      ,c.[therapeutic_class_code_minus_ahfs]
      ,c.[formulary_status]
      ,c.[ingredient_cost_paid]
      ,c.[dispensing_fee_paid]
      ,c.[total_amount_paid_by_all_sources]
      ,c.[amount_attributed_to_sales_tax]
      ,c.[patient_pay_amount]
      ,c.[amount_of_copay]
      ,c.[amount_of_coinsurance]
      ,c.[amount_attributed_to_product_selection]
      ,c.[amount_applied_to_periodic_deductible]
      ,c.[mac_reduced_indicator]
      ,c.[client_pricing_basis_of_cost]
      ,c.[generic_indicator]
      ,c.[out_of_pocket_apply_amount]
      ,c.[awp_type_indicator]
      ,c.[average_wholesale_unit_price]
      ,c.[average_wholesale_unit_price_full]
      ,c.[ingredient_cost_submitted]
      ,c.[usual_and_customary_charge]
      ,c.[flat_sales_tax_amount_paid]
      ,c.[percentage_sales_tax_amount_paid]
      ,c.[net_amount_due]
      ,c.[basis_of_reimbursement_determination]
      ,c.[accumulated_deductible_amount]
      ,c.[amount_exceeding_periodic_benefit_maximum]
      ,c.[basis_of_calculation_minus_copay]
      ,c.[adjustment_issue_id]
      ,c.[processor_defined_prior_authorization_certification_code]
      ,c.[adjustment_reason_code]
      ,c.[eligibility_cob_indicator]
      ,c.[cob_primary_payer_amount_paid]
      ,c.[opar_amount]
      ,c.[cob_primary_payer_copay]
      ,c.[transaction_id]
      ,c.[account_id]
      ,c.[care_facility]
      ,c.[specialty_rx_claim]
      ,c.[alternate_id]
      ,c.[vaccine_administration_fee_paid]
      ,c.[drug_admin_fee_type_code]
      ,c.[maintenance_choice_indicator]
      ,c.[applied_hra_amount]
      ,c.[cb5_qualifier_1]
      ,c.[cb5_oth_amount_1]
      ,c.[cb5_qualifier_2]
      ,c.[cb5_oth_amount_2]
      ,c.[cb5_qualifier_3]
      ,c.[cb5_oth_amount_3]
      ,c.[pd6_client_total_other_amount]
      ,c.[pd6_buy_total_other_amount]
      ,p.enterprisePatientId
      ,p.patientPrimaryNumber
      ,p.patientPrimaryNumberQualifier
      ,p.enterpriseSubscriberId
      ,p.subscriberPrimaryNumber
      ,p.subscriberPrimaryNumberQualifier
      ,c.stageId rowNumber
      ,0 hasError
  from EdmStage.EWTF_PharmacyClaim c
  left join EdmStage.EWTF_MemberCSV m on m.dependentID like substring(c.cardholder_id, 1, len(c.cardholder_id)-2)+ '*%'
                                     and convert(date, c.patient_date_of_birth) = convert(date, left(m.dateofBirth, 10))
"								     and c.patient_first_name = m.employeeFirstName								   "
  left join Patient.PatientDim p on m.enterprisePatientId = p.enterprisePatientId
                                and p.clientId = @clientId
                                and p.patientActiveFlag = 1
" where c.fileRequestId = @fileRequestId) x ; 	1	2021-05-06 09:18:30.3566667	mssql"
"271	75	EWTF_CLAIM_REFERRAL_PROCESS_PREP-STEP-01-MEDICAL-01-Transpose	declare @fileRequestId bigint = :fileRequestId ; -- 91792"

declare @clientId int ;
declare @clientCode nvarchar(20) ;
declare @fileRequestDate date ;

#NAME?
select @clientId = fr.clientId
      ,@clientCode = c.clientCode
      ,@fileRequestDate = convert(date, fr.fileRequestDateTime)
  from EdmLib.FileRequest fr
  join Reference.Client c on fr.clientId = c.clientId
 where fr.fileRequestId = @fileRequestId ;

-- drop table if exists EdmStage.EWTF_MedicalClaimHistory_stage_temp ;
truncate table EdmStage.EWTF_MedicalClaimHistory_stage_temp ;

insert into EdmStage.EWTF_MedicalClaimHistory_stage_temp
select @clientId clientId
      ,@clientCode clientCode
"   	  ,@fileRequestId fileRequestId"
"   	  ,h.fileRequestId originalFileRequestId"
"   	  ,h.stageId originalStageId"
"   	  ,h.group_number groupNumber"
"   	  ,h.claim_number claimNumber"
"   	  ,h.line_number lineNumber"
"   	  ,h.from_date fromDate"
"   	  ,h.thru_date thruDate"
"   	  ,h.issued_date issuedDate"
"   	  ,h.subscriber_ssn subscriberSSN"
"   	  ,h.alternate_id alternateId"
"   	  ,h.patient_name patientFullName"
" 	  ,m.employeeFirstName patientFirstName"
" 	  ,m.employeeLastName patientLastName"
"   	  ,h.patient_gender patientGender"
"   	  ,h.patient_dob patientDOB"
"   	  ,h.patient_ssn patientSSN"
"   	  ,h.dep_id dependentId"
"   	  ,h.revenue_code revenueCode"
"   	  ,h.primary_diag diagnosisCodePrimary"
"   	  ,h.secondary_diag diagnosisCode2"
"   	  ,h.tertiary_diag diagnosisCode3"
"   	  ,h.quantinary_diag diagnosisCode4"
"   	  ,h.billed_amount			billedAmount"
"   	  ,h.allowed_amount_tot		totalAllowedAmount"
"   	  ,h.deductible_annl_tot	totalDeductibleAnnual"
"   	  ,h.coinsurance_rt_sv		coinsurance"
"   	  ,h.deductible_copay_tot	totalDeductibleCopay"
"   	  ,h.paid_amount			paidAmount"
"   	  ,h.cob_save_tot			totalCobSave"
"   	  ,h.place_of_service		placeOfServiceCode"
"   	  ,h.type_of_service		typeOfService"
"   	  ,h.paid_thru_date			paidThruDate"
"   	  ,h.service_provider_npi	serviceProviderNpi"
"   	  ,h.svc_prov_name			serviceProviderName"
"   	  ,h.provider				provider"
"   	  ,h.provider_address_1		providerAddress1"
"   	  ,h.provider_address_2		providerAddress2"
"   	  ,h.provider_address_3		providerAddress3"
"   	  ,h.provider_city			providerCity"
"   	  ,h.provider_state			providerState"
"   	  ,h.provider_zip_code		providerZipCode"
"   	  ,h.paid_date				paidDate"
"   	  ,h.claim_type				claimType"
"	  ,substring(h.procedure_id,1,5) procedureValue1"
      ,row_number() over(partition by h.stageId, h.fileRequestId order by h.stageId) procedureNumber
"      ,x0.value procedureValue																			   "
"   	  ,h.ppo_code						  ppoCode"
"   	  ,h.quantity						  quantity															   "
"   	  ,m.enterprisePatientId			  enterprisePatientId															   "
"   	  ,p.patientPrimaryNumber			  patientPrimaryNumber															   "
"   	  ,p.patientPrimaryNumberQualifier	  patientPrimaryNumberQualifier															   "
"   	  ,p.enterpriseSubscriberId			  enterpriseSubscriberId															   "
"   	  ,p.subscriberPrimaryNumber		  subscriberPrimaryNumber															   "
"   	  ,p.subscriberPrimaryNumberQualifier subscriberPrimaryNumberQualifier															   "
"   	  ,h.hasError						  hasError															   "
"--  into EdmStage.EWTF_MedicalClaimHistory_stage_temp																	   "
  from EdmStage.EWTF_MedicalClaimHistory h
"  left join EdmStage.EWTF_MemberCSV m on h.dep_id = m.dependentId									   "
  left join Patient.PatientDim p on m.enterprisePatientId = p.enterprisePatientId
                                and p.clientId = @clientId
                                and p.patientActiveFlag = 1
 cross apply string_split(h.procedure_id, '-') x0
" where try_convert(date, thru_date) between dateadd(month,-12, @fileRequestDate) and @fileRequestDate ;	1	2021-06-04 17:20:57.4666667	mssql"
"272	75	EWTF_CLAIM_REFERRAL_PROCESS_PREP-STEP-02-PHARMACY	declare @fileRequestId bigint = :fileRequestId ;"

declare @clientId int ;
declare @clientCode nvarchar(20) ;
declare @fileRequestDate date ;

#NAME?
select @clientId = fr.clientId
      ,@clientCode = c.clientCode
      ,@fileRequestDate = convert(date, fr.fileRequestDateTime)
  from EdmLib.FileRequest fr
  join Reference.Client c on fr.clientId = c.clientId
 where fr.fileRequestId = @fileRequestId ;

insert into EdmReferral.PharmacyClaim_RawHistory
      (clientId
      ,fileRequestId
      ,originalFileRequestId
      ,originalStageId
      ,subscriberSSN
      ,dependentId
      ,patientLastName
      ,patientFirstName
      ,patientMiddleName
      ,patientDOB
      ,patientGenderCode
      ,patientRelationshipCode
"	  ,claimNumber"
      ,dateOfService
"	  ,dateRxWritten"
"	  ,dxCode"
"	  ,quantity"
"	  ,unitOfMeasure"
"	  ,daysSupply"
"	  ,serviceProviderNPI"
"	  ,serviceProviderNumber"
      ,paidAmount
      ,enterprisePatientId
      ,patientPrimaryNumber
      ,hasError)
select @clientId clientId
      ,@fileRequestId fileRequestId
      ,fileRequestId originalFileRequestId
      ,stageId originalStageId
      ,left(h.cardholder_Id, 9) subscriberSSN
      ,h.cardholder_Id dependentId
      ,h.patient_last_name patientLastName
      ,h.patient_first_name patientFirstName
      ,h.patient_middle_initial patientMiddleName
      ,try_convert(date, h.patient_date_of_birth) patientDOB
      ,h.patient_gender_code patientGenderCode
      ,h.eligibility_or_patient_relationship_code patientRelationshipCode
"	  ,h.d0_rx_number claimNumber"
      ,try_convert(date, date_of_service) dateOfService
"	  ,try_convert(date, date_prescription_written) dateRxWritten"
"	  ,diagnosis_code dxCode"
"	  ,quantity_dispensed quantity"
"	  ,unit_of_measure unitOfMeasure"
"	  ,days_supply daysSupply"
"	  ,case when service_provider_id_qualifier = '01' then service_provider_id end serviceProviderNPI"
"	  ,service_provider_id serviceProviderNumber"
      ,case when x.numericSign = 'N' then -1 else 1 end * convert(decimal(10,3), substring(h.total_amount_paid_by_all_sources, 1, len(h.total_amount_paid_by_all_sources)-2) + '.' + left(right(h.total_amount_paid_by_all_sources, 2), 1) + x.XWalkValue) paidAmount
      ,h.enterprisePatientId
      ,h.patientPrimaryNumber
      ,h.hasError
  from EdmStage.EWTF_PharmacyClaimHistory h
  join EdmStage.EWTF_PharmacyAmountXwalk x on right(h.total_amount_paid_by_all_sources, 1) = x.fileValue
 where try_convert(date, date_of_service) between dateadd(year,-1, @fileRequestDate) and @fileRequestDate
"   and h.record_type = 'DE' ; 	1	2021-06-04 17:21:07.2900000	mssql"
"273	0	EDM_CLAIM_REFERRAL_PROCESS-CM-STEP-0001-CRITERIA_1-MEDICAL	declare @fileRequestId bigint = :fileRequestId ;"

declare @clientId int ;

select @clientId = clientId
  from EdmLib.FileRequest
 where fileRequestId = @fileRequestId ;

if (select count(*)
  from (select x0.*
              ,lag(x0.thruDate, 1) over(partition by x0.dependentId order by x0.parentThruDate) prevThruDate
          from EdmReferral.InpatientClaimStay x0) x
 where prevThruDate < fromDate
   and datediff(day, prevThruDate, parentFromDate) < 0) > 0
   throw 51000, 'At least 1 overlapping inpatient stay record exists.', 16 ;

insert into EdmReferral.InpatientClaimStage
      (fileRequestId
      ,originalFileRequestId
      ,originalStageId
      ,clientId
      ,clientCode
      ,claimRowId
      ,claimNumber
      ,parentFromDate
      ,parentThruDate
      ,fromDate
      ,thruDate
      ,patientPrimaryNumber
      ,enterprisePatientId
      ,subscriberSSN
      ,dependentId
      ,patientSSN
      ,patientDOB
      ,patientFullName
      ,patientFirstName
      ,patientLastName
      ,patientGenderCode
      ,serviceProviderNPI
      ,serviceProviderName
      ,placeOfService
      ,primaryDiagnosis
      ,procedureCode
      ,modifierCode1
      ,modifierCode2
      ,modifierCode3
      ,modifierCode4
      ,allowedAmount
      ,paidAmount
      ,criteriaMet
      ,selectionReason
      ,moduleCode
      ,serviceCode
      ,inpatientStayCount)
select h.fileRequestId
      ,h.originalFileRequestId
      ,h.stageId originalStageId
      ,h.clientId
      ,h.clientCode
      ,convert(int, h.claimRowId) claimRowId
      ,h.claimNumber
      ,h.parentFromDate
      ,h.parentThruDate
      ,h.fromDate
      ,h.thruDate
      ,h.patientPrimaryNumber
      ,h.enterprisePatientId
      ,h.subscriberSSN
      ,h.dependentId
      ,h.patientSSN
      ,h.patientDOB
      ,h.patientFullName
      ,h.patientFirstName
      ,h.patientLastName
      ,h.patientGenderCode patientGender
      ,h.serviceProviderNPI
      ,h.serviceProviderName
      ,h.placeOfServiceCode
      ,h.diagnosisCodePrimary
      ,h.procedureCode
      ,h.modifierCode1
      ,h.modifierCode2
      ,h.modifierCode3
      ,h.modifierCode4
      ,try_convert(numeric(20, 3), h.allowedAmount) allowedAmount
      ,try_convert(numeric(20, 3), h.paidAmount   ) paidAmount
      ,'1' criteriaMet
      ,'>=2_INPATIENT_ADMISSIONS' selectionReason
      ,'CM' moduleCode
      ,'NC' serviceCode
      ,inpatientStayCount
  from EdmReferral.InpatientClaimStay h
 where h.clientId = @clientId
"   and h.inpatientStayCount > 1 ;	1	2021-06-04 18:05:44.2966667	mssql"
"274	0	EDM_CLAIM_REFERRAL_PROCESS-CM-STEP-0002-CRITERIA_2-MEDICAL	declare @fileRequestId bigint = :fileRequestId ;"

declare @clientId int ;

select @clientId = clientId
  from EdmLib.FileRequest
 where fileRequestId = @fileRequestId ;

insert into EdmReferral.InpatientClaimStage
      (fileRequestId
      ,originalFileRequestId
      ,originalStageId
      ,clientId
      ,clientCode
      ,claimNumber
      ,parentFromDate
      ,parentThruDate
      ,fromDate
      ,thruDate
      ,patientPrimaryNumber
      ,enterprisePatientId
      ,subscriberSSN
      ,dependentId
      ,patientSSN
      ,patientDOB
      ,patientFullName
      ,patientFirstName
      ,patientLastName
      ,patientGenderCode
      ,serviceProviderNPI
      ,serviceProviderName
      ,placeOfService
      ,primaryDiagnosis
      ,procedureCode
      ,modifierCode1
      ,modifierCode2
      ,modifierCode3
      ,modifierCode4
      ,allowedAmount
      ,paidAmount
      ,criteriaMet
      ,selectionReason
"	  ,moduleCode"
      ,serviceCode
      ,inpatientStayDayDiff)
select x.*
  from (select x0.fileRequestId
              ,x0.originalFileRequestId
              ,x0.originalStageId
              ,x0.clientId
              ,x0.clientCode
              ,x0.claimNumber
              ,x0.parentFromDate
              ,x0.parentThruDate
              ,x0.fromDate
              ,x0.thruDate
              ,x0.patientPrimaryNumber
              ,x0.enterprisePatientId
              ,x0.subscriberSSN
              ,x0.dependentId
              ,x0.patientSSN
              ,x0.patientDOB
              ,x0.patientFullName
              ,x0.patientFirstName
              ,x0.patientLastName
              ,x0.patientGenderCode
              ,x0.serviceProviderNPI
              ,x0.serviceProviderName
              ,x0.placeOfServiceCode placeOfService
              ,x0.diagnosisCodePrimary primaryDiagnosis
              ,x0.procedureCode
              ,x0.modifierCode1
              ,x0.modifierCode2
              ,x0.modifierCode3
              ,x0.modifierCode4
              ,try_convert(numeric(12,3), x0.allowedAmount) allowedAmount
              ,try_convert(numeric(12,3), x0.paidAmount) paidAmount
              ,'2' criteriaMet
              ,'>=2_INPATIENT_ADMISSIONS_WITHIN_30DAYS' selectionReason
"			  ,'CM' moduleCode"
              ,'NC' serviceCode
              ,datediff(day, lag(x0.thruDate, 1) over(partition by x0.dependentId order by x0.parentThruDate), parentFromDate) inpatientStayDayDiff
          from EdmReferral.InpatientClaimStay x0
         where clientId = @clientId ) x
" where inpatientStayDayDiff <= 30  ;	1	2021-06-04 18:07:02.7333333	mssql"
"275	0	EDM_CLAIM_REFERRAL_PROCESS-CM-STEP-0003-CRITERIA_3-MEDICAL	declare @fileRequestId bigint = :fileRequestId ;"

declare @clientId int ;

select @clientId = clientId
  from EdmLib.FileRequest
 where fileRequestId = @fileRequestId ;

insert into EdmReferral.InpatientClaimStage
      (fileRequestId
      ,originalFileRequestId
      ,originalStageId
      ,clientId
      ,clientCode
      ,claimNumber
      ,parentFromDate
      ,parentThruDate
      ,fromDate
      ,thruDate
      ,patientPrimaryNumber
      ,enterprisePatientId
      ,subscriberSSN
      ,dependentId
      ,patientSSN
      ,patientDOB
      ,patientFullName
      ,patientFirstName
      ,patientLastName
      ,patientGenderCode
      ,serviceProviderNPI
      ,serviceProviderName
      ,placeOfService
      ,primaryDiagnosis
      ,procedureCode
      ,modifierCode1
      ,modifierCode2
      ,modifierCode3
      ,modifierCode4
      ,allowedAmount
      ,paidAmount
      ,criteriaMet
      ,selectionReason
      ,moduleCode
      ,serviceCode
      ,erVisitCount)
select x.*
  from (select x1.*
              ,dense_rank() over(partition by dependentId order by fromDate)
               + dense_rank() over(partition by dependentId order by fromDate desc)
               - 1 erVisitCount
          from (select x0.fileRequestId
                      ,x0.originalFileRequestId
                      ,x0.stageId
                      ,x0.clientId
                      ,x0.clientCode
                      ,x0.claimNumber
                      ,lag(x0.fromDate, 1) over(partition by x0.dependentId order by x0.fromDate) prevFromDate
                      ,lag(x0.thruDate, 1) over(partition by x0.dependentId order by x0.fromDate) prevThruDate
                      ,x0.fromDate
                      ,x0.thruDate
                      ,x0.patientPrimaryNumber
                      ,x0.enterprisePatientId
                      ,x0.subscriberSSN
                      ,x0.dependentId
                      ,x0.patientSSN
                      ,x0.patientDOB
                      ,x0.patientFullName
                      ,x0.patientFirstName
                      ,x0.patientLastName
                      ,x0.patientGender
                      ,x0.serviceProviderNPI
                      ,x0.serviceProviderName
                      ,x0.placeOfServiceCode
                      ,x0.diagnosisCodePrimary
                      ,x0.procedureCode
                      ,x0.modifierCode1
                      ,x0.modifierCode2
                      ,x0.modifierCode3
                      ,x0.modifierCode4
                      ,x0.allowedAmount
                      ,x0.paidAmount
                      ,x0.criteriaMet
                      ,x0.selectionReason
                      ,x0.moduleCode
                      ,x0.serviceCode
                  from (select h.fileRequestId
                              ,h.originalFileRequestId
                              ,h.stageId
                              ,h.clientId
                              ,c.clientCode
                              ,h.claimNumber
                              ,h.fromDate
                              ,h.thruDate
                              ,h.patientPrimaryNumber
                              ,h.enterprisePatientId
                              ,h.subscriberSSN
                              ,h.dependentId
                              ,h.patientSSN
                              ,try_convert(date, h.patientDOB) patientDOB
                              ,h.patientFullName
                              ,h.patientFirstName
                              ,h.patientLastName
                              ,h.patientGender
                              ,h.serviceProviderNPI
                              ,h.serviceProviderName
                              ,h.placeOfServiceCode
                              ,h.diagnosisCodePrimary
                              ,h.procedureCode
                              ,h.modifierCode1
                              ,h.modifierCode2
                              ,h.modifierCode3
                              ,h.modifierCode4
                              ,try_convert(numeric(11,2), replace(allowedAmount, ',', '')) allowedAmount
                              ,try_convert(numeric(11,2), replace(paidAmount, ',', ''))    paidAmount
                              ,'3' criteriaMet
                              ,'>=3_ER_VISITS' selectionReason
                              ,'CM' moduleCode
                              ,'NC' serviceCode
                              ,row_number() over(partition by dependentId, fromDate order by originalFileRequestId, originalStageId) rnk
                          from EdmReferral.MedicalClaim_RawHistory h
                          join Reference.Client c on h.clientId = c.clientId
                         where h.clientId = @clientId
"						   and (h.placeOfServiceCode = '23'"
                             or h.procedureCode in ('99281','99282','99283','99284','99285'))) x0
                 where x0.rnk = 1) x1
         where datediff(day, isnull(x1.prevFromDate, '1900-01-01'), x1.fromDate) > 1) x
" where x.erVisitCount > 2 ;	1	2021-06-04 18:09:59.0466667	mssql"
"276	0	EDM_CLAIM_REFERRAL_PROCESS-CM-STEP-0004-CRITERIA_4-MEDICAL	declare @fileRequestId bigint = :fileRequestId ;"

declare @clientId int ;

select @clientId = clientId
  from EdmLib.FileRequest
 where fileRequestId = @fileRequestId ;

/*
drop table if exists ##medical_claim_outpatient_pos_code ;

select *
  into ##medical_claim_outpatient_pos_code
  from (values ('02') ,('2')
              ,('04') ,('4')
              ,('05') ,('5')
              ,('06') ,('6')
              ,('07') ,('7')
              ,('08') ,('8')
              ,('11')
              ,('12')
              ,('13')
              ,('14')
              ,('15')
              ,('16')
              ,('17')
              ,('18')
              ,('19')
              ,('20')
              ,('22')
              ,('24')
              ,('33')
              ,('49')
              ,('52')
              ,('53')
              ,('57')
              ,('58')
              ,('62')
              ,('65')
              ,('71')
              ,('72')) t(placeOfServiceCode) ;
*/

insert into EdmReferral.OutpatientClaimStage
          (clientId
          ,clientCode
          ,fileRequestId
          ,originalFileRequestId
          ,originalStageId
          ,patientPrimaryNumber
          ,enterprisePatientId
          ,claimNumber
          ,fromDate
          ,thruDate
          ,subscriberSSN
          ,dependentId
          ,patientSSN
          ,patientDOB
          ,patientFullName
          ,patientFirstName
          ,patientLastName
          ,patientGenderCode
          ,serviceProviderNPI
          ,serviceProviderName
          ,placeOfService
          ,primaryDiagnosis
          ,procedureCode
          ,modifierCode1
          ,modifierCode2
          ,modifierCode3
          ,modifierCode4
          ,allowedAmount
          ,paidAmount
          ,criteriaMet
          ,selectionReason
          ,moduleCode
          ,serviceCode)
select *
  from (select h.clientId                  
              ,c.clientCode
              ,h.fileRequestId
              ,h.originalFileRequestId
              ,h.originalStageId
              ,h.patientPrimaryNumber
              ,h.enterprisePatientId
              ,h.claimNumber
              ,h.fromDate
              ,h.thruDate
              ,h.subscriberSSN
              ,h.dependentId
              ,h.patientSSN
              ,h.patientDOB
              ,h.patientFullName
              ,h.patientFirstName
              ,h.patientLastName
              ,h.patientGender
              ,h.serviceProviderNPI
              ,h.serviceProviderName
              ,h.placeOfServiceCode
              ,h.diagnosisCodePrimary
              ,h.procedureCode
              ,h.modifierCode1
              ,h.modifierCode2
              ,h.modifierCode3
              ,h.modifierCode4
              ,sum(convert(numeric(11,2), replace(allowedAmount, ',', ''))) over(partition by h.dependentId) allowedAmount
              ,sum(convert(numeric(11,2), replace(paidAmount, ',', '')))    over(partition by h.dependentId) paidAmount
              ,'4' criteriaMet
              ,'OUTPATIENT_SERVICES_EXCEED_AMOUNT' selectionReason
              ,'CM' moduleCode
              ,'NC' serviceCode
           from EdmReferral.MedicalClaim_RawHistory h
           join Reference.Client c on h.clientId = c.clientId
           --join ##medical_claim_outpatient_pos_code x on h.placeOfServiceCode = x.placeOfServiceCode
          where h.clientId = @clientId
"		    and (h.inOutInd = 'O'"
"			  or h.placeOfServiceCode = '23'"
"			  or h.procedureCode in ('99281','99282','99283','99284','99285'))"
"		  ) x"
" where x.allowedAmount >= 50000 ;	1	2021-06-04 18:10:06.2866667	mssql"
"277	0	EDM_CLAIM_REFERRAL_PROCESS-CM-STEP-0005-CRITERIA_5-PHARMACY	declare @fileRequestId bigint = :fileRequestId ;"

declare @clientId int ;

select @clientId = clientId
  from EdmLib.FileRequest
 where fileRequestId = @fileRequestId ;

with paidAmountList as
    (select c.clientCode
           ,min(s.fileRequestId) over(partition by dependentId) fileRequestId
           ,min(s.stageId)  over(partition by dependentId) stageId
           ,sum(try_convert(decimal(11,2), allowedAmount)) over(partition by dependentId) allowedAmount
           ,sum(try_convert(decimal(11,2), paidAmount)) over(partition by dependentId) paidAmount
           ,row_number()  over(partition by dependentId order by fileRequestId, stageId) rn
       from EdmReferral.PharmacyClaim_RawHistory s
       join Reference.Client c on s.clientId = c.clientId
      where s.clientId = @clientId)
insert into EdmReferral.PharmacyClaimStage
      (clientId
      ,clientCode
      ,fileRequestId
      ,originalFileRequestId
      ,originalStageId
      ,patientPrimaryNumber
      ,enterprisePatientId
      ,subscriberSSN
      ,dependentId
      ,patientDOB
      ,patientFirstName
      ,patientMiddleName
      ,patientLastName
      ,patientGenderCode
      ,patientRelationshipCode
      ,claimNumber
      ,dateOfService
      ,dateRxWritten
      ,dxCode
      ,ndcCode
      ,quantity
      ,unitOfMeasure
      ,daysSupply
      ,serviceProviderNPI
      ,serviceProviderName
      ,serviceProviderNumber
      ,allowedAmount
      ,paidAmount
      ,criteriaMet
      ,selectionReason
      ,moduleCode
      ,serviceCode)
select s.clientId
      ,m.clientCode
      ,s.fileRequestId
      ,s.originalFileRequestId
      ,s.originalStageId
      ,s.patientPrimaryNumber
      ,s.enterprisePatientId
      ,s.subscriberSSN
      ,s.dependentId
      ,s.patientDOB
      ,s.patientFirstName
      ,s.patientMiddleName
      ,s.patientLastName
      ,s.patientGenderCode
      ,s.patientRelationshipCode
      ,s.claimNumber
      ,s.dateOfService
      ,s.dateRxWritten
      ,s.dxCode
      ,s.ndcCode
      ,s.quantity
      ,s.unitOfMeasure
      ,s.daysSupply
      ,s.serviceProviderNPI
      ,s.serviceProviderName
      ,s.serviceProviderNumber
      ,m.allowedAmount
      ,m.paidAmount
      ,'5' criteriaMet
      ,'PHARMACY_EXCEED_AMT' selectionReason
      ,'CM' moduleCode
      ,'NC' serviceCode
  from paidAmountList m
  join EdmReferral.PharmacyClaim_RawHistory s on m.fileRequestId = s.fileRequestId
                                             and m.stageId = s.stageId
 where m.rn = 1
"   and m.paidAmount >= 50000 ;	1	2021-06-04 18:10:13.8333333	mssql"
"278	0	EDM_CLAIM_REFERRAL_PROCESS-CM-STEP-0006-CRITERIA_6-MEDICAL	declare @fileRequestId bigint = :fileRequestId ;"

declare @clientId int ;

select @clientId = clientId
  from EdmLib.FileRequest
 where fileRequestId = @fileRequestId ;

insert into EdmReferral.InpatientClaimStage
      (fileRequestId
"	  ,originalFileRequestId"
      ,originalStageId
"	  ,clientId"
"	  ,clientCode"
      ,patientPrimaryNumber
"	  ,enterprisePatientId"
"	  ,claimNumber"
"	  ,fromDate"
"	  ,thruDate"
"	  ,subscriberSSN"
"	  ,dependentId"
"	  ,patientSSN"
"	  ,patientDOB"
"	  ,patientFullName"
"	  ,patientFirstName"
"	  ,patientLastName"
"	  ,patientGenderCode"
"	  ,serviceProviderNPI"
"	  ,serviceProviderName"
"	  ,placeOfService"
"	  ,primaryDiagnosis"
"	  ,procedureCode"
"	  ,modifierCode1"
"	  ,modifierCode2"
"	  ,modifierCode3"
"	  ,modifierCode4"
"	  ,allowedAmount"
"	  ,paidAmount"
"	  ,criteriaMet"
"	  ,selectionReason"
"	  ,moduleCode"
"	  ,serviceCode)"
select h.fileRequestId
      ,h.originalFileRequestId
      ,h.stageId
"	  ,h.clientId"
"	  ,c.clientCode"
      ,h.patientPrimaryNumber
"	  ,h.enterprisePatientId"
"	  ,h.claimNumber"
"	  ,h.fromDate"
"	  ,h.thruDate"
"	  ,h.subscriberSSN"
"	  ,h.dependentId"
"	  ,h.patientSSN"
"	  ,try_convert(date, h.patientDOB) patientDOB"
"	  ,h.patientFullName"
"	  ,h.patientFirstName"
"	  ,h.patientLastName"
"	  ,h.patientGender"
"	  ,h.serviceProviderNPI"
"	  ,h.serviceProviderName"
"	  ,h.placeOfServiceCode"
"	  ,h.diagnosisCodePrimary"
"	  ,h.procedureCode"
"	  ,h.modifierCode1"
"	  ,h.modifierCode2"
"	  ,h.modifierCode3"
"	  ,h.modifierCode4"
"	  ,convert(numeric(11,2), replace(allowedAmount, ',', '')) allowedAmount"
"	  ,convert(numeric(11,2), replace(paidAmount, ',', ''))    paidAmount"
"	  ,'6' criteriaMet"
"	  ,'PRIMARY_DX' selectionReason"
"	  ,'CM' moduleCode"
"	  ,isnull(case l.servicesCode when 'N' then 'NC' else l.servicesCode end, 'NC') serviceCode"
  from EdmReferral.MedicalClaim_RawHistory h 
  join Reference.Client c on h.clientId = c.clientId
  join EdmReference.CaseManagement_Claims_DXCPT_list l on h.diagnosisCodePrimary = l.code 
                                                      and l.moduleCode = 'CM'
" where h.clientId = @clientId ;	1	2021-06-04 18:10:19.4500000	mssql"
"279	0	EDM_CLAIM_REFERRAL_PROCESS-CM-STEP-0007-CRITERIA_7-MEDICAL	declare @fileRequestId bigint = :fileRequestId ;"

declare @clientId int ;

select @clientId = clientId
  from EdmLib.FileRequest
 where fileRequestId = @fileRequestId ;


insert into EdmReferral.InpatientClaimStage
      (fileRequestId
"	  ,originalFileRequestId"
      ,originalStageId
"	  ,clientId"
"	  ,clientCode"
      ,patientPrimaryNumber
"	  ,enterprisePatientId"
"	  ,claimNumber"
"	  ,fromDate"
"	  ,thruDate"
"	  ,subscriberSSN"
"	  ,dependentId"
"	  ,patientSSN"
"	  ,patientDOB"
"	  ,patientFullName"
"	  ,patientFirstName"
"	  ,patientLastName"
"	  ,patientGenderCode"
"	  ,serviceProviderNPI"
"	  ,serviceProviderName"
"	  ,placeOfService"
"	  ,primaryDiagnosis"
"	  ,procedureCode"
"	  ,modifierCode1"
"	  ,modifierCode2"
"	  ,modifierCode3"
"	  ,modifierCode4"
"	  ,allowedAmount"
"	  ,paidAmount"
"	  ,criteriaMet"
"	  ,selectionReason"
"	  ,moduleCode"
"	  ,serviceCode)"
select h.fileRequestId
      ,h.originalFileRequestId
      ,h.stageId
"	  ,h.clientId"
"	  ,c.clientCode"
      ,h.patientPrimaryNumber
"	  ,h.enterprisePatientId"
"	  ,h.claimNumber"
"	  ,h.fromDate"
"	  ,h.thruDate"
"	  ,h.subscriberSSN"
"	  ,h.dependentId"
"	  ,h.patientSSN"
"	  ,try_convert(date, h.patientDOB) patientDOB"
"	  ,h.patientFullName"
"	  ,h.patientFirstName"
"	  ,h.patientLastName"
"	  ,h.patientGender"
"	  ,h.serviceProviderNPI"
"	  ,h.serviceProviderName"
"	  ,h.placeOfServiceCode"
"	  ,h.diagnosisCodePrimary"
"	  ,h.procedureCode"
"	  ,h.modifierCode1"
"	  ,h.modifierCode2"
"	  ,h.modifierCode3"
"	  ,h.modifierCode4"
"	  ,convert(numeric(11,2), replace(allowedAmount, ',', '')) allowedAmount"
"	  ,convert(numeric(11,2), replace(paidAmount, ',', ''))    paidAmount"
"	  ,'7' criteriaMet"
"	  ,'CPT' selectionReason"
"	  ,'CM' moduleCode"
"	  ,isnull(case l.servicesCode when 'N' then 'NC' else l.servicesCode end, 'NC') serviceCode"
  from EdmReferral.MedicalClaim_RawHistory h 
  join Reference.Client c on h.clientId = c.clientId
  join EdmReference.CaseManagement_Claims_DXCPT_list l on h.procedureCode = l.code 
                                                      and l.moduleCode = 'CM'
" where h.clientId = @clientId ;	1	2021-06-04 18:10:26.8466667	mssql"
"280	0	EDM_CLAIM_REFERRAL_PROCESS-CM-STEP-0000-PREP-01-GENERIC	declare @fileRequestId bigint = :fileRequestId ;"

declare @clientId int ;

#NAME?
select @clientId = fr.clientId
  from EdmLib.FileRequest fr
  join Reference.Client c on fr.clientId = c.clientId
 where fr.fileRequestId = @fileRequestId ;

alter sequence EdmReferral.InpatientClaimStageSeq restart with 10 ;
alter sequence EdmReferral.OutpatientClaimStageSeq restart with 10 ;
alter sequence EdmReferral.PharmacyClaimStageSeq restart with 10 ;

alter sequence EdmReferral.InpatientClaimFinalSEQ restart with 10 ;
alter sequence EdmReferral.OutpatientClaimFinalSEQ restart with 10 ;
"alter sequence EdmReferral.PharmacyClaimFinalSEQ restart with 10 ;	1	2021-06-04 18:11:16.4366667	mssql"
"281	0	EDM_CLAIM_REFERRAL_PROCESS-CM-STEP-9001-FINALIZE_CRITERIA	declare @fileRequestId bigint = :fileRequestId ;"

declare @clientId int ;

select @clientId = clientId
  from EdmLib.FileRequest
 where fileRequestId = @fileRequestId ;

declare @servicesCodeList table
(servicesCode nvarchar(20)
,servicesCodeRank int) ;

insert into @servicesCodeList 
values ('NC', 5) 
      ,('C',  4)
"	  ,('BH', 3)"
"	  ,('T',  2)"
"	  ,('O',  1);"

if (select count(*)
      from EdmReferral.InpatientClaimStage s
      left join @servicesCodeList sv on s.serviceCode = sv.servicesCode
     where s.clientId = @clientId
       and s.moduleCode = 'CM'
       and sv.servicesCode is null) > 0
"	throw 51000, 'Invalid configuration or data.', 16 ;"

if (select count(*)
      from EdmReferral.OutpatientClaimStage s
      left join @servicesCodeList sv on s.serviceCode = sv.servicesCode
     where s.clientId = @clientId
       and s.moduleCode = 'CM'
       and sv.servicesCode is null) > 0
"	throw 51000, 'Invalid configuration or data.', 16 ;"

if (select count(*)
      from EdmReferral.PharmacyClaimStage s
      left join @servicesCodeList sv on s.serviceCode = sv.servicesCode
     where s.clientId = @clientId
       and s.moduleCode = 'CM'
       and sv.servicesCode is null) > 0
"	throw 51000, 'Invalid configuration or data.', 16 ;"

insert into EdmReferral.InpatientClaimFinal
      (fileRequestId
      ,clientId
      ,clientCode
      ,originalFileRequestId
      ,originalStageId
      ,claimRowId
      ,claimNumber
      ,parentFromDate
      ,parentThruDate
      ,fromDate
      ,thruDate
      ,patientPrimaryNumber
      ,enterprisePatientId
      ,subscriberSSN
      ,dependentId
      ,patientSSN
      ,patientDOB
      ,patientFullName
      ,patientFirstName
      ,patientMiddleName
      ,patientLastName
      ,patientGenderCode
      ,patientRelationshipCode
      ,serviceProviderNPI
      ,serviceProviderName
      ,placeOfService
      ,primaryDiagnosis
      ,procedureCode
      ,modifierCode1
      ,modifierCode2
      ,modifierCode3
      ,modifierCode4
      ,allowedAmount
      ,paidAmount
      ,inpatientStayCount
      ,inpatientStayDayDiff
      ,erVisitCount
"	  ,criteriaMet"
"	  ,selectionReason"
"	  ,moduleCode"
"	  ,serviceCode"
      ,serviceCodeRank
      ,createDateTime)
select x.fileRequestId
      ,x.clientId
      ,x.clientCode
      ,x.originalFileRequestId
      ,x.originalStageId
      ,x.claimRowId
      ,x.claimNumber
      ,x.parentFromDate
      ,x.parentThruDate
      ,x.fromDate
      ,x.thruDate
      ,x.patientPrimaryNumber
      ,x.enterprisePatientId
      ,x.subscriberSSN
      ,x.dependentId
      ,x.patientSSN
      ,x.patientDOB
      ,x.patientFullName
      ,x.patientFirstName
      ,x.patientMiddleName
      ,x.patientLastName
      ,x.patientGenderCode
      ,x.patientRelationshipCode
      ,x.serviceProviderNPI
      ,x.serviceProviderName
      ,x.placeOfService
      ,x.primaryDiagnosis
      ,x.procedureCode
      ,x.modifierCode1
      ,x.modifierCode2
      ,x.modifierCode3
      ,x.modifierCode4
      ,x.allowedAmount
      ,x.paidAmount
      ,x.inpatientStayCount
      ,x.inpatientStayDayDiff
      ,x.erVisitCount
"	  ,x.criteriaMet"
"	  ,x.selectionReason"
"	  ,x.moduleCode"
"	  ,x.serviceCode"
      ,x.serviceCodeRank
      ,x.createDateTime
  from (select s.fileRequestId
              ,s.clientId
              ,s.clientCode
              ,s.originalFileRequestId
              ,s.originalStageId
              ,s.claimRowId
              ,s.claimNumber
              ,s.parentFromDate
              ,s.parentThruDate
              ,s.fromDate
              ,s.thruDate
              ,s.patientPrimaryNumber
              ,s.enterprisePatientId
              ,s.subscriberSSN
              ,s.dependentId
"			  ,s.patientSSN"
"			  ,s.patientDOB"
"			  ,s.patientFullName"
"			  ,s.patientFirstName"
"			  ,s.patientMiddleName"
"			  ,s.patientLastName"
"			  ,s.patientGenderCode"
"			  ,s.patientRelationshipCode"
"			  ,s.serviceProviderNPI"
"			  ,s.serviceProviderName"
"			  ,s.placeOfService"
"			  ,s.primaryDiagnosis"
"			  ,s.procedureCode"
"			  ,s.modifierCode1"
"			  ,s.modifierCode2"
"			  ,s.modifierCode3"
"			  ,s.modifierCode4"
"			  ,s.allowedAmount"
"			  ,s.paidAmount"
"			  ,s.inpatientStayCount"
"			  ,s.inpatientStayDayDiff"
"			  ,s.erVisitCount"
"			  ,s.criteriaMet"
"			  ,s.selectionReason"
"			  ,s.moduleCode"
"			  ,s.serviceCode"
              ,sv.servicesCodeRank serviceCodeRank
"			  ,sysdatetime() createDateTime"
              ,row_number() over(partition by s.dependentId, s.criteriaMet order by sv.servicesCodeRank, s.fileRequestId, s.stageId) rn
          from EdmReferral.InpatientClaimStage s
          join @servicesCodeList sv on s.serviceCode = sv.servicesCode
         where s.clientId = @clientId
           and s.moduleCode = 'CM') x
  where x.rn = 1 ;

insert into EdmReferral.OutpatientClaimFinal
      (fileRequestId
      ,clientId
      ,clientCode
      ,originalFileRequestId
      ,originalStageId
      ,claimRowId
      ,claimNumber
      ,fromDate
      ,thruDate
      ,patientPrimaryNumber
      ,enterprisePatientId
      ,subscriberSSN
      ,dependentId
      ,patientSSN
      ,patientDOB
      ,patientFullName
      ,patientFirstName
      ,patientMiddleName
      ,patientLastName
      ,patientGenderCode
      ,patientRelationshipCode
      ,serviceProviderNPI
      ,serviceProviderName
      ,placeOfService
      ,primaryDiagnosis
      ,procedureCode
      ,modifierCode1
      ,modifierCode2
      ,modifierCode3
      ,modifierCode4
      ,allowedAmount
      ,paidAmount
"	  ,criteriaMet"
"	  ,selectionReason"
"	  ,moduleCode"
"	  ,serviceCode"
      ,serviceCodeRank
      ,createDateTime)
select x.fileRequestId
      ,x.clientId
      ,x.clientCode
      ,x.originalFileRequestId
      ,x.originalStageId
      ,x.claimRowId
      ,x.claimNumber
      ,x.fromDate
      ,x.thruDate
      ,x.patientPrimaryNumber
      ,x.enterprisePatientId
      ,x.subscriberSSN
      ,x.dependentId
      ,x.patientSSN
      ,x.patientDOB
      ,x.patientFullName
      ,x.patientFirstName
      ,x.patientMiddleName
      ,x.patientLastName
      ,x.patientGenderCode
      ,x.patientRelationshipCode
      ,x.serviceProviderNPI
      ,x.serviceProviderName
      ,x.placeOfService
      ,x.primaryDiagnosis
      ,x.procedureCode
      ,x.modifierCode1
      ,x.modifierCode2
      ,x.modifierCode3
      ,x.modifierCode4
      ,x.allowedAmount
      ,x.paidAmount
"	  ,x.criteriaMet"
"	  ,x.selectionReason"
"	  ,x.moduleCode"
"	  ,x.serviceCode"
      ,x.serviceCodeRank
      ,x.createDateTime
  from (select s.fileRequestId
              ,s.clientId
              ,s.clientCode
              ,s.originalFileRequestId
              ,s.originalStageId
              ,s.claimRowId
              ,s.claimNumber
              ,s.fromDate
              ,s.thruDate
              ,s.patientPrimaryNumber
              ,s.enterprisePatientId
              ,s.subscriberSSN
              ,s.dependentId
"			  ,s.patientSSN"
"			  ,s.patientDOB"
"			  ,s.patientFullName"
"			  ,s.patientFirstName"
"			  ,s.patientMiddleName"
"			  ,s.patientLastName"
"			  ,s.patientGenderCode"
"			  ,s.patientRelationshipCode"
"			  ,s.serviceProviderNPI"
"			  ,s.serviceProviderName"
"			  ,s.placeOfService"
"			  ,s.primaryDiagnosis"
"			  ,s.procedureCode"
"			  ,s.modifierCode1"
"			  ,s.modifierCode2"
"			  ,s.modifierCode3"
"			  ,s.modifierCode4"
"			  ,s.allowedAmount"
"			  ,s.paidAmount"
"			  ,sysdatetime() createDateTime"
"			  ,s.criteriaMet"
"			  ,s.selectionReason"
"			  ,s.moduleCode"
"			  ,s.serviceCode"
"			  ,sv.servicesCodeRank serviceCodeRank"
              ,row_number() over(partition by s.dependentId, s.criteriaMet order by sv.servicesCodeRank, s.fileRequestId, s.stageId) rn
          from EdmReferral.OutpatientClaimStage s
          join @servicesCodeList sv on s.serviceCode = sv.servicesCode
         where s.clientId = @clientId
           and s.moduleCode = 'CM') x
 where x.rn = 1 ;

insert into EdmReferral.PharmacyClaimFinal
      (fileRequestId
      ,clientId
      ,clientCode
      ,originalFileRequestId
      ,originalStageId
      ,patientPrimaryNumber
      ,enterprisePatientId
      ,subscriberSSN
      ,dependentId
      ,patientSSN
      ,patientDOB
      ,patientFullName
      ,patientFirstName
      ,patientMiddleName
      ,patientLastName
      ,patientGenderCode
      ,patientRelationshipCode
      ,claimNumber
      ,dateOfService
      ,dateRxWritten
      ,dxCode
      ,ndcCode
      ,quantity
      ,unitOfMeasure
      ,daysSupply
      ,serviceProviderNPI
      ,serviceProviderName
      ,serviceProviderNumber
      ,allowedAmount
      ,paidAmount
      ,createDateTime
      ,criteriaMet
      ,selectionReason
      ,moduleCode
      ,serviceCode
      ,serviceCodeRank)
select x.fileRequestId
      ,x.clientId
      ,x.clientCode
      ,x.originalFileRequestId
      ,x.originalStageId
      ,x.patientPrimaryNumber
      ,x.enterprisePatientId
      ,x.subscriberSSN
      ,x.dependentId
      ,x.patientSSN
      ,x.patientDOB
      ,x.patientFullName
      ,x.patientFirstName
      ,x.patientMiddleName
      ,x.patientLastName
      ,x.patientGenderCode
      ,x.patientRelationshipCode
      ,x.claimNumber
      ,x.dateOfService
      ,x.dateRxWritten
      ,x.dxCode
      ,x.ndcCode
      ,x.quantity
      ,x.unitOfMeasure
      ,x.daysSupply
      ,x.serviceProviderNPI
      ,x.serviceProviderName
      ,x.serviceProviderNumber
      ,x.allowedAmount
      ,x.paidAmount
      ,x.createDateTime
      ,x.criteriaMet
      ,x.selectionReason
      ,x.moduleCode
      ,x.serviceCode
      ,x.serviceCodeRank
 from (select s.fileRequestId
             ,s.clientId
             ,s.clientCode
             ,s.originalFileRequestId
             ,s.originalStageId
"			 ,s.patientPrimaryNumber"
             ,s.enterprisePatientId
             ,s.subscriberSSN
             ,s.dependentId
"			 ,s.patientSSN"
"			 ,s.patientDOB"
"			 ,s.patientFullName"
"			 ,s.patientFirstName"
"			 ,s.patientMiddleName"
"			 ,s.patientLastName"
"			 ,s.patientGenderCode"
"			 ,s.patientRelationshipCode"
"			 ,s.claimNumber"
"			 ,s.dateOfService"
"			 ,s.dateRxWritten"
"			 ,s.dxCode"
"			 ,s.ndcCode"
"			 ,s.quantity"
"			 ,s.unitOfMeasure"
"			 ,s.daysSupply"
"			 ,s.serviceProviderNPI"
"			 ,s.serviceProviderName"
"			 ,s.serviceProviderNumber"
"			 ,s.allowedAmount"
"			 ,s.paidAmount"
"			 ,sysdatetime() createDateTime"
"			 ,s.criteriaMet"
"			 ,s.selectionReason"
"			 ,s.moduleCode"
"			 ,s.serviceCode"
"			 ,sv.servicesCodeRank serviceCodeRank"
             ,row_number() over(partition by s.dependentId, s.criteriaMet order by sv.servicesCodeRank, s.fileRequestId, s.stageId) rn
         from EdmReferral.PharmacyClaimStage s
         join @servicesCodeList sv on s.serviceCode = sv.servicesCode
        where s.clientId = @clientId
          and s.moduleCode = 'CM') x
"  where x.rn = 1 ;	1	2021-06-04 18:49:15.6133333	mssql"
"287	0	EDM_CLAIM_REFERRAL_PROCESS-CM-STEP-9901-FINALIZE_STAGE	declare @fileRequestId bigint = :fileRequestId ;"

declare @clientId int ;
select @clientId = clientId
  from EdmLib.FileRequest 
 where fileRequestId = @fileRequestId ;

with memberList as
(select fileRequestId
       ,stageId
       ,clientId
       ,clientCode
       ,criteriaMet
       ,selectionReason
       ,moduleCode
       ,serviceCode
       ,serviceCodeRank
       ,patientPrimaryNumber
       ,enterprisePatientId
       ,subscriberSSN
       ,dependentId
       ,patientSSN
       ,patientDOB
       ,patientFullName
       ,patientFirstName
       ,patientMiddleName
       ,patientLastName
       ,patientGenderCode
       ,patientRelationshipCode
   from EdmReferral.InpatientClaimFinal 
  where fileRequestId = @fileRequestId
  union all
 select fileRequestId
       ,stageId
       ,clientId
       ,clientCode
       ,criteriaMet
       ,selectionReason
       ,moduleCode
       ,serviceCode
       ,serviceCodeRank
       ,patientPrimaryNumber
       ,enterprisePatientId
       ,subscriberSSN
       ,dependentId
       ,patientSSN
       ,patientDOB
       ,patientFullName
       ,patientFirstName
       ,patientMiddleName
       ,patientLastName
       ,patientGenderCode
       ,patientRelationshipCode
   from EdmReferral.OutpatientClaimFinal
  where fileRequestId = @fileRequestId
  union all
 select fileRequestId
       ,stageId
       ,clientId
       ,clientCode
       ,criteriaMet
       ,selectionReason
       ,moduleCode
       ,serviceCode
       ,serviceCodeRank
       ,patientPrimaryNumber
       ,enterprisePatientId
       ,subscriberSSN
       ,dependentId
       ,patientSSN
       ,patientDOB
       ,patientFullName
       ,patientFirstName
       ,patientMiddleName
       ,patientLastName
       ,patientGenderCode
       ,patientRelationshipCode
   from EdmReferral.PharmacyClaimFinal
  where fileRequestId = @fileRequestId),
   memberListRank as 
(select l.*
       ,row_number() over(partition by dependentId, criteriaMet order by serviceCodeRank, fileRequestId, stageId) rn
   from memberList l),
   memberListRankFinal as 
(select l.*
       ,count(*) over(partition by dependentId) criteriaMetCount
   from memberListRank l
  where rn = 1)
insert into EdmReferral.ClaimReferralStage
      (fileRequestId
      ,clientId
      ,clientCode
      ,criteriaMet
      ,selectionReason
      ,moduleCode
      ,serviceCode
      ,serviceCodeRank
"	  ,criteriaMetCount"
      ,patientPrimaryNumber
      ,enterprisePatientId
      ,subscriberSSN
      ,dependentId
      ,patientSSN
      ,patientDOB
      ,patientFullName
      ,patientFirstName
      ,patientMiddleName
      ,patientLastName
      ,patientGenderCode
      ,patientRelationshipCode)
select fileRequestId
      ,clientId
      ,clientCode
      ,criteriaMet
      ,selectionReason
      ,moduleCode
      ,serviceCode
      ,serviceCodeRank
"	  ,criteriaMetCount"
      ,patientPrimaryNumber
      ,enterprisePatientId
      ,subscriberSSN
      ,dependentId
      ,patientSSN
      ,patientDOB
      ,patientFullName
      ,patientFirstName
      ,patientMiddleName
      ,patientLastName
      ,patientGenderCode
      ,patientRelationshipCode
  from memberListRankFinal
" where rn = 1  ;	1	2021-06-04 18:50:16.8266667	mssql"
"288	0	HWB_VALIDATE_REFERRAL-REFERRAL_CLAIM	declare @fileRequestId bigint = :fileRequestId ;"
declare @runId bigint = :runId ;

insert into EdmStage.HWB_ReferralFeedback
(runId
,stageId
,fileRequestId
,configuredRuleId
,feedbackMessage
,feedbackType
,fieldName
,originalFieldValue
,createDateTime
,recordCount)
select @runId
      ,r.stageId
      ,r.fileRequestId
"	  ,0 configuredRuleId"
"	  ,case when r.patientPrimaryNumber is null then '[patientPrimaryNumber] is required.'"
"	        when pd.patientId is null and r.patientPrimaryNumber is not null then '[patientPrimaryNumber] is invalid.'"
       end feedbackMessage
"	  ,case when r.patientPrimaryNumber is null or pd.patientId is null then 'W' end feedbackType"
"	  ,'[patientPrimaryNumber]' fieldName"
"	  ,r.patientPrimaryNumber originalFieldValue"
"	  ,sysdatetime() createDateTime"
"	  ,1 recordCount"
  from EdmStage.HWB_Referral r
  left join Patient.PatientDim pd on r.patientPrimaryNumber = pd.patientPrimaryNumber
                                 and r.clientId = pd.clientId
 where pd.patientId is null

insert into EdmStage.HWB_ReferralFeedback
(runId
,stageId
,fileRequestId
,configuredRuleId
,feedbackMessage
,feedbackType
,fieldName
,originalFieldValue
,createDateTime
,recordCount)
select @runId
      ,r.stageId
      ,r.fileRequestId
"	  ,0 configuredRuleId"
"	  ,case when r.moduleCode is null then '[moduleCode] is required.'"
"	        when m.moduleId is null and r.moduleCode is not null then '[moduleCode] is invalid.'"
       end feedbackMessage
"	  ,case when r.moduleCode is null or m.moduleId is null then 'E' end feedbackType"
"	  ,'[moduleCode]' fieldName"
"	  ,r.moduleCode originalFieldValue"
"	  ,sysdatetime() createDateTime"
"	  ,1 recordCount"
  from EdmStage.HWB_Referral r
  left join ProgramModule.Module m on r.moduleCode = m.moduleCode
 where m.moduleId is null

insert into EdmStage.HWB_ReferralFeedback
(runId
,stageId
,fileRequestId
,configuredRuleId
,feedbackMessage
,feedbackType
,fieldName
,originalFieldValue
,createDateTime
,recordCount)
select @runId
      ,r.stageId
      ,r.fileRequestId
"	  ,0 configuredRuleId"
"	  ,case when x.value is null then '[servicesCode] is required.'"
"	        when s.servicesId is null and x.value is not null then '[servicesCode] is invalid.'"
       end feedbackMessage
"	  ,case when x.value is null or s.servicesId is null then 'E' end feedbackType"
"	  ,'[servicesCode]' fieldName"
"	  ,x.value originalFieldValue"
"	  ,sysdatetime() createDateTime"
"	  ,1 recordCount"
  from EdmStage.HWB_Referral r
  cross apply string_split(r.servicesCodeList, ',') x 
  left join ProgramModule.Services s on x.value = s.servicesCode
 where s.servicesId is null

insert into EdmStage.HWB_ReferralFeedback
(runId
,stageId
,fileRequestId
,configuredRuleId
,feedbackMessage
,feedbackType
,fieldName
,originalFieldValue
,createDateTime
,recordCount)
select @runId
      ,r.stageId
      ,r.fileRequestId
"	  ,0 configuredRuleId"
"	  ,case when i.icdId is null and r.prinDX is not null then '[prinDX] is invalid.'"
       end feedbackMessage
"	  ,case when i.icdId is null and r.prinDX is not null then 'W' end feedbackType"
"	  ,'[prinDX]' fieldName"
"	  ,r.prinDX originalFieldValue"
"	  ,sysdatetime() createDateTime"
"	  ,1 recordCount"
  from EdmStage.HWB_Referral r
  left join Reference.Icd i on replace(r.prinDX, '.', '') = i.icdCodeStd
 where r.prinDX is not null
   and i.icdId is null

insert into EdmStage.HWB_ReferralFeedback
(runId
,stageId
,fileRequestId
,configuredRuleId
,feedbackMessage
,feedbackType
,fieldName
,originalFieldValue
,createDateTime
,recordCount)
select @runId
      ,r.stageId
      ,r.fileRequestId
"	  ,0 configuredRuleId"
"	  ,case when i.icdId is null and x.value is not null then '[otherDxCode] is invalid.'"
       end feedbackMessage
"	  ,case when x.value is null or i.icdId is null then 'W' end feedbackType"
"	  ,'[otherDxCode]' fieldName"
"	  ,x.value originalFieldValue"
"	  ,sysdatetime() createDateTime"
"	  ,1 recordCount"
  from EdmStage.HWB_Referral r
  cross apply string_split(r.otherDxCodeList, ',') x 
  left join Reference.Icd i on replace(x.value, '.', '') = i.icdCodeStd
 where i.icdId is null
   and x.value is not null; 

merge into EdmStage.HWB_Referral m
using (select r.stageId
             ,max(case when f.feedbackType = 'E' then 1 else 0 end) hasError
         from EdmStage.HWB_Referral r 
         left join EdmStage.HWB_ReferralFeedback f on r.fileRequestId = f.fileRequestId
                                                  and f.runId = @runId
"										          and r.stageId = f.stageId"
"		group by r.stageId) u"
  on m.stageId = u.stageId
"when matched then update set m.hasError = u.hasError;	1	2021-06-06 18:35:53.7133333	mssql"
"289	0	HWB_GET_REFERRAL_WARNING_COUNT-REFERRAL_CLAIM	select count(distinct stageId)"
  from EdmStage.HWB_ReferralFeedback
 where feedbackType = 'W'
   and fileRequestId = :fileRequestId
"   and runId = :runId	1	2021-06-06 18:39:58.8900000	mssql"
"290	0	HWB_GET_REFERRAL_ERROR_COUNT-REFERRAL_CLAIM	select count(distinct stageId)"
  from EdmStage.HWB_ReferralFeedback
 where feedbackType = 'E'
   and fileRequestId = :fileRequestId
"   and runId = :runId	1	2021-06-06 18:41:29.7700000	mssql"
"291	0	QT3_MONITOR_2HR_LONG_RUNNING_ROLLBACK	set nocount on "

DECLARE @Time AS bigint = 450000; -- 7.5 min ms

insert into PAW.DBMan.TempdbSessionInfo 
select DB_NAME(req.database_id) AS [DB_NAME]
"	  ,req.session_id"
"	  ,s.login_name, s.nt_user_name"
"	  ,req.start_time"
"	  ,req.status"
"	  ,CASE t.transaction_state"
"			   WHEN '0' THEN 'Not initialized yet.'"
"			   WHEN '1' THEN 'Initialized but not started.'"
"			   WHEN '2' THEN 'Active'"
"			   WHEN '3' THEN 'Ended'"
"			   WHEN '4' THEN 'Commit process has been initiated.'"
"			   WHEN '5' THEN 'In a prepared state and waiting resolution.'"
"			   WHEN '6' THEN 'Committed'"
"			   WHEN '7' THEN 'Being rolled back.'"
"			   WHEN '8' THEN 'Completed rolled back.' END transaction_state"
"	  ,req.command"
"	  ,req.blocking_session_id"
"	  ,wait_type"
"	  ,wait_time"
"	  ,wait_resource"
"	  ,CONVERT(TIME,DATEADD (ms,req.cpu_time, 0)) AS cpu_time"
"	  ,CONVERT(TIME,DATEADD (ms,req.total_elapsed_time, 0)) AS total_elapsed_time"
"	  ,CASE t.transaction_type WHEN '1' THEN 'Read/Write' WHEN '2' THEN 'Read-Only' WHEN '3' THEN 'System' WHEN '4' THEN 'Distributed' END transaction_type"
"	  ,req.reads"
"	  ,req.writes"
"	  ,req.logical_reads"
"	  ,req.dop AS DOP"
"	  ,sqltext.text"
"	  ,req.sql_handle"
FROM tempdb.sys.dm_exec_requests req
outer APPLY tempdb.sys.dm_exec_sql_text(sql_handle) as sqltext
LEFT JOIN tempdb.sys.dm_exec_sessions s
"	 ON req.session_id = s.session_id"
LEFT JOIN tempdb.sys.dm_tran_active_transactions t
"	 ON req.transaction_id = t.transaction_id"
WHERE (req.command LIKE '%kill%'
"	   OR req.command LIKE '%roll%'"
"	   OR t.transaction_state = '7')"
AND req.total_elapsed_time > @Time 
ORDER BY req.start_time DESC;

if @@rowcount > 0
select 'At least 1 long running killed/rollback session has been deteced on tempdb!' out_put ;
else 
"select DB_Name out_put from PAW.DBMan.TempdbSessionInfo where 1 = 2 ;	1	2021-06-10 10:44:01.4366667	mssql"
"292	0	ASSESSMENT-MERGE_INTO_PatientDim	declare @fileRequestId bigint = :fileRequestId ;"
insert into Patient.PatientDim
(clientId
,patientPrimaryNumber
,enterprisePatientId
,patientPrimaryNumberQualifier
,relationshipCode
,patientSsn
,patientMedicareNumber
,patientFirstName
,patientLastName
,patientBirthDate
,patientGenderCode
,patientLanguageCode
,transactionSetCreationDateTime
,headerStandardRowNumber
,detailStandardRowNumber
,fileRequestId)
select a.clientId
      ,max(a.patientPrimaryNumber) patientPrimaryNumber
"	  ,a.enterprisePatientId"
"	  ,'1D' patientPrimaryNumberQualifier"
"	  ,18 relationshipCode"
"	  ,max(a.memberSSN) patientSsn"
"	  ,max(a.memberMedicaidNumber) patientMedicareNumber"
"	  ,max(a.memberFirstName) patientFirstName"
"	  ,max(a.memberLastName) patientLastName"
"	  ,max(a.memberDOB) patientBirthDate"
"	  ,max(gc.genderCode) patientGenderCode "
"	  ,max(case when plc.languageId is not null then a.memberPrimaryLanguage else a.memberLanguageCode end) patientLanguageCode	  "
"	  ,sysdatetime() transactionSetCreationDateTime"
"	  ,0 headerStandardRowNumber"
"	  ,0 detailStandardRowNumber"
      ,a.fileRequestId
  from EdmStandard.AssessmentReferral a
  left join Patient.PatientDim p on a.clientId = p.clientId
                                and a.enterprisePatientId = p.enterprisePatientId
  left join Reference.GenderCode gc on a.memberGender = gc.genderCode
  left join Reference.LanguageCode plc on a.memberPrimaryLanguage = plc.languageCodeIso6392
  left join Reference.LanguageCode lc on a.memberLanguageCode = lc.languageCodeIso6392
  left join Reference.LivingArrangementCode lac on a.memberLivingArrangementCode = lac.livingArrangementCode
 where a.fileRequestId = 44 
   and ascii(trim(a.enterprisePatientId)) is not null 
   and ascii(trim(a.patientPrimaryNumber)) is not null 
   and a.addMemberFlag = 1 
   and p.patientId is null
 group by a.clientId
         ,a.enterprisePatientId
"		 ,a.fileRequestId ;	1	2021-07-19 17:26:25.7523882	mssql"
"293	0	ASSESSMENT-MERGE_INTO_PatientAddressDim	declare @fileRequestId bigint = :fileRequestId ;"
insert into Patient.AddressDim
(clientId
,patientId
,addressTypeId
,addressTypeCode
,addressGeoId
,addressLine1
,addressLine2
,city
,state
,zip
,fileRequestId
,stageId
,addressCount
,createDateTime
,activeFlag
,recordTypeId)
select p.clientId
      ,p.patientId
"	  ,12 addressTypeId"
"	  ,'M' addressTypeCode"
"	  ,g.geographyId"
"	  ,a.memberAddressLine1 addressLine1"
"	  ,a.memberAddressLine2 addressLine2"
"	  ,a.memberAddressCityName city"
"	  ,a.memberAddressStateCode state"
"	  ,a.memberAddressZIP zip"
"	  ,a.fileRequestId"
"	  ,max(a.stageId) stageId"
"	  ,1"
"	  ,sysdatetime()"
"	  ,1"
"	  ,11"
  from EdmStandard.AssessmentReferral a
  join Patient.PatientDim p on a.clientId = p.clientId
                           and a.enterprisePatientId = p.enterprisePatientId
  left join Patient.AddressDim ad on p.clientId = ad.clientId
                                 and p.patientId = ad.patientId
"								 and a.memberAddressLine1 = ad.addressLine1"
"								 and isnull(a.memberAddressLine2, '~') = isnull(ad.addressLine2, '~')"
"								 and a.memberAddressStateCode = ad.state"
"								 and a.memberAddressCityName = ad.city"
"								 and a.memberAddressZIP = ad.zip"
  left join Reference.Geography g on left(a.memberAddressZIP, 5) = g.geographyZipCode
                                 and g.geographyDistinctLevel = 'ZIP'
 where ascii(trim(a.memberAddressLine1)) is not null
   and ascii(trim(a.memberAddressStateCode)) is not null
   and ascii(trim(a.memberAddressCityName)) is not null
   and ascii(trim(a.memberAddressZIP)) is not null
   and a.fileRequestId = @fileRequestId 
   and ad.patientAddressId is null
 group by p.clientId
         ,p.patientId
"	     ,g.geographyId"
"	     ,a.memberAddressLine1"
"	     ,a.memberAddressLine2"
"	     ,a.memberAddressCityName"
"	     ,a.memberAddressStateCode"
"	     ,a.memberAddressZIP"
"	     ,a.fileRequestId ;	1	2021-07-19 17:26:25.7848295	mssql"
"294	39	MPI-ADD_NEW_GROUP_POLICIES	-- deactivated for client	0	2021-08-06 10:45:07.3000000	mssql"
"295	39	MPI-ADD_NEW_PLANS	-- deactivated for client	0	2021-08-06 10:45:35.3166667	mssql"
"296	39	MPI-INSERT_MANUAL_MEMBERS	/*"
"	Purpose: associate manually added temporary members to other temporary members or members on file."
*/
set nocount on ;

declare @fileRequestId bigint = :fileRequestId ;

declare @clientId int = 39 ;
declare @firstNameLen int  ;
declare @lastNameLen int ;
declare @onlyIncludeTempID bit = 0 ;

select @firstNameLen = isnull(try_convert(int, outValue), 2)
  from EdmLib.Mapping
 where name = 'ID_MEMBER_PREPROCESS'
   and inValue = 'FIRST_NAME_LEN' ;

select @lastNameLen = isnull(try_convert(int, outValue), 4)
  from EdmLib.Mapping
 where name = 'ID_MEMBER_PREPROCESS'
   and inValue = 'LAST_NAME_LEN' ;

if exists (select *
             from EdmLib.Mapping
            where name = 'ID_MEMBER_PREPROCESS'
              and inValue = 'ONLY_INCLUDE_TEMP_ID'
              and upper(outValue) = 'TRUE')
   set @onlyIncludeTempID = 1;

if @firstNameLen is null or
   @lastNameLen is null
"	throw 51000, 'Invalid request.', 16 ;"

drop table if exists EdmStage.ID_TempMemberStage ;

create table EdmStage.ID_TempMemberStage
(matchTypeId int 
,matchTypeName nvarchar(255)
,clientId int
,tempPatientId nvarchar(255)
,tempPatientIdCount int
,tempPatientIdList nvarchar(max)
,patientIdList nvarchar(max)
,patientNumberList nvarchar(max)
,patientCount int) ;

insert into EdmStage.ID_TempMemberStage
select 1 matchTypeId
      ,'dob|ssn' matchTypeName
      ,clientId
      ,min(case when recordTypeId in (11, 13) then patientPrimaryNumber end) tempPatientId
"	  ,count(distinct case when recordTypeId in (11, 13) then patientPrimaryNumber end) tempPatientIdCount"
      ,string_agg(case when recordTypeId in (11, 13) then patientPrimaryNumber end, ',') within group (order by patientId) tempPatientIdList
"	  ,string_agg(patientId, ',') within group (order by patientId)  patientIdList"
"	  ,string_agg(patientPrimaryNumber, ',') within group (order by patientId)  patientNumberList"
"	  ,count(distinct patientPrimaryNumber) patientCount"
  from Patient.PatientDim
 where clientId = @clientId
   and patientActiveFlag = 1
   and patientSsn is not null
 group by clientId
         ,patientBirthDate
         ,patientSsn
having count(*) > 1
   and sum(case when recordTypeId in (11, 13) then 1 else 0 end) > 0 
   and ((sum(case when patientPrimaryNumber like 'TEMP%' then 1 else 0 end) > 0
     and @onlyIncludeTempID = 1)
"	  or @onlyIncludeTempID = 0)"
option (maxdop 1) ; 
 
insert into EdmStage.ID_TempMemberStage
select 2 matchTypeId
      ,'dob|firstName' + convert(varchar(2), @firstNameLen) + '|lastName' + convert(varchar(2), @lastNameLen) matchTypeName
      ,clientId
      ,min(case when recordTypeId in (11, 13) then patientPrimaryNumber end) tempPatientId
"	  ,count(distinct case when recordTypeId in (11, 13) then patientPrimaryNumber end) tempPatientIdCount"
      ,string_agg(case when recordTypeId in (11, 13) then patientPrimaryNumber end, ',') within group (order by patientId) tempPatientIdList
"	  ,string_agg(patientId, ',') within group (order by patientId)  patientIdList"
"	  ,string_agg(patientPrimaryNumber, ',') within group (order by patientId)  patientNumberList"
"	  ,count(distinct patientPrimaryNumber) patientCount"
  from Patient.PatientDim
 where clientId = @clientId
   and patientActiveFlag = 1
 group by clientId
         ,patientBirthDate
         ,left(patientFirstName, @firstNameLen)
         ,left(patientLastName, @lastNameLen)
having count(*) > 1
   and sum(case when recordTypeId in (11, 13) then 1 else 0 end) > 0 
   and ((sum(case when patientPrimaryNumber like 'TEMP%' then 1 else 0 end) > 0
     and @onlyIncludeTempID = 1)
"	  or @onlyIncludeTempID = 0)"
option (maxdop 1) ; 

drop table if exists ##temp_ID_members_src_3 ;

create table ##temp_ID_members_src_3 
(lvl int
,clientId int
,tempPatientId bigint
,tempPatientPrimaryNumber nvarchar(255)
,tempBirthDate datetime2
,tempSsn nvarchar(255)
,tempFirstName nvarchar(255)
,tempLastName nvarchar(255)
,tempPatientIdList nvarchar(max)
,tempPatientIdCount int
,currPatientId bigint
,currPatientPrimaryNumber nvarchar(255)
,currBirthDate datetime2
,currSsn nvarchar(255)
,currFirstName nvarchar(255)
,currLastName nvarchar(255)
,patientIdList nvarchar(max)
,patientNumberList nvarchar(max)
,patientCount int
,rnk int) ;

with tempPatientList as
"	 (select 0 lvl"
"			,clientId"
"			,patientId tempPatientId"
"			,patientPrimaryNumber tempPatientPrimaryNumber"
"			,patientBirthDate tempBirthDate"
"			,patientSsn tempSsn"
"			,patientFirstName tempFirstName"
"			,patientLastName tempLastName"
"			,convert(nvarchar(max), patientPrimaryNumber) tempPatientIdList"
"			,1 tempPatientIdCount"
"			,patientId currPatientId"
"			,patientPrimaryNumber currPatientPrimaryNumber"
"			,patientBirthDate currBirthDate"
"			,patientSsn currSsn"
"			,patientFirstName currFirstName"
"			,patientLastName currLastName"
"			,patientId"
"			,patientPrimaryNumber"
"			,patientBirthDate"
"			,patientSsn"
"			,patientFirstName"
"			,patientLastName"
"			,convert(nvarchar(max), patientId) patientIdList"
"			,convert(nvarchar(max), patientPrimaryNumber) patientNumberList"
"			,1 patientCount"
"		from Patient.PatientDim"
"	   where clientId = @clientId"
"		 and recordTypeId in (11, 13) -- manually added"
"		 and patientPrimaryNumber like 'TEMP%'"
"		 and patientActiveFlag = 1"
"	   union all"
"	  select t.lvl + 1 lvl"
"			,t.clientId"
"			,t.tempPatientId"
"			,t.tempPatientPrimaryNumber"
"			,t.tempBirthDate"
"			,t.tempSsn"
"			,t.tempFirstName"
"			,t.tempLastName"
"			,convert(nvarchar(max), t.tempPatientIdList + case when pd.patientPrimaryNumber like 'TEMP%' then ',' + pd.patientPrimaryNumber else '' end) tempPatientIdList"
"			,t.tempPatientIdCount + case when pd.patientPrimaryNumber like 'TEMP%' then 1 else 0 end tempPatientIdCount"
"			,pd.patientId currPatientId"
"			,pd.patientPrimaryNumber currPatientPrimaryNumber"
"			,pd.patientBirthDate currBirthDate"
"			,pd.patientSsn currentSsn"
"			,pd.patientFirstName currFirstName"
"			,pd.patientLastName currLastName"
"			,pd.patientId"
"			,pd.patientPrimaryNumber"
"			,pd.patientBirthDate"
"			,pd.patientSsn"
"			,pd.patientFirstName"
"			,pd.patientLastName"
"			,convert(nvarchar(max), t.patientIdList + ',' + convert(nvarchar(255), pd.patientId)) patientIdList"
"			,convert(nvarchar(max), t.patientNumberList + ',' + pd.patientPrimaryNumber) patientNumberList"
"			,t.patientCount + case when t.patientNumberList not like '%' + pd.patientPrimaryNumber + '%' then 1 else 0 end patientCount"
"		from Patient.PatientDim pd"
"		join tempPatientList t on t.clientId = pd.clientId"
"							  and t.currBirthDate = pd.patientBirthDate"
"							  and left(t.currLastName, @firstNameLen) = left(pd.patientFirstName, @firstNameLen)"
"							  and left(t.currFirstName, @lastNameLen) = left(pd.patientLastName, @lastNameLen)"
"							  and t.currPatientId <> pd.patientId"
"							  and t.patientNumberList not like '%' + pd.patientPrimaryNumber + '%'"
"							  and pd.clientId = @clientId"
"							  --and pd.recordTypeId = 28 -- eligibility file"
"							  and pd.patientActiveFlag = 1)"
insert into ##temp_ID_members_src_3 
select lvl                            
"	  ,clientId"
"	  ,tempPatientId"
"	  ,tempPatientPrimaryNumber"
"	  ,tempBirthDate"
"	  ,tempSsn"
"	  ,tempFirstName"
"	  ,tempLastName"
"	  ,tempPatientIdList"
"	  ,tempPatientIdCount"
"	  ,currPatientId"
"	  ,currPatientPrimaryNumber"
"	  ,currBirthDate"
"	  ,currSsn"
"	  ,currFirstName"
"	  ,currLastName"
"	  ,patientIdList"
"	  ,patientNumberList"
"	  ,patientCount"
"	  ,row_number() over(partition by tempPatientId order by lvl desc) rnk"
  from tempPatientList 
option (maxdop 1) ; 

insert into EdmStage.ID_TempMemberStage
select 3 matchTypeId
      ,'dob|firstName' + convert(varchar(2), @firstNameLen) + '=lastName' + convert(varchar(2), @firstNameLen) + '|lastName' + convert(varchar(2), @lastNameLen) + '=firstName' + convert(varchar(2), @lastNameLen) matchTypeName
      ,clientId
      ,tempPatientPrimaryNumber
"	  ,tempPatientIdCount"
"	  ,tempPatientIdList"
      ,patientIdList
"	  ,patientNumberList"
"	  ,patientCount"
  from ##temp_ID_members_src_3
 where rnk = 1 
   and tempPatientPrimaryNumber <> patientNumberList
 group by clientId
         ,tempPatientPrimaryNumber
         ,tempPatientIdCount
"		 ,tempPatientIdList"
"		 ,patientIdList"
"		 ,patientNumberList"
"		 ,patientCount"
option (maxdop 1) ; 

insert into EdmStage.ID_TempMemberStage
select 4 matchTypeId
      ,'ssn|gender|firstName' + convert(varchar(2), @firstNameLen) + '|lastName' + convert(varchar(2), @lastNameLen) matchTypeName
      ,clientId
      ,min(case when recordTypeId in (11, 13) then patientPrimaryNumber end) tempPatientId
"	  ,count(distinct case when recordTypeId in (11, 13) then patientPrimaryNumber end) tempPatientIdCount"
      ,string_agg(case when recordTypeId in (11, 13) then patientPrimaryNumber end, ',') within group (order by patientId) tempPatientIdList
"	  ,string_agg(patientId, ',') within group (order by patientId) patientIdList"
"	  ,string_agg(patientPrimaryNumber, ',') within group (order by patientId)  patientNumberList"
"	  ,count(distinct patientPrimaryNumber) patientCount"
  from Patient.PatientDim
 where clientId = @clientId
   and patientActiveFlag = 1
   and patientSsn is not null
   and patientGenderCode in ('M', 'F')
 group by clientId
         ,patientSsn
         ,patientGenderCode
         ,left(patientFirstName, @firstNameLen)
         ,left(patientLastName, @lastnameLen)
having count(*) > 1
   and sum(case when recordTypeId in (11, 13) then 1 else 0 end) > 0
   and ((sum(case when patientPrimaryNumber like 'TEMP%' then 1 else 0 end) > 0
     and @onlyIncludeTempID = 1)
"	  or @onlyIncludeTempID = 0)"
option (maxdop 1) ; 
   
drop table if exists ##temp_ID_members_src_5 ;

create table ##temp_ID_members_src_5 
(lvl int
,clientId int
,tempPatientId bigint
,tempPatientPrimaryNumber nvarchar(255)
,tempBirthDate datetime2
,tempSsn nvarchar(255)
,tempFirstName nvarchar(255)
,tempLastName nvarchar(255)
,tempPatientIdList nvarchar(max)
,tempPatientIdCount int
,currPatientId bigint
,currPatientPrimaryNumber nvarchar(255)
,currBirthDate datetime2
,currSsn nvarchar(255)
,currFirstName nvarchar(255)
,currLastName nvarchar(255)
,patientIdList nvarchar(max)
,patientNumberList nvarchar(max)
,patientCount int
,rnk int) ;

with tempPatientList as
"	 (select 0 lvl"
"			,clientId"
"			,patientId tempPatientId"
"			,patientPrimaryNumber tempPatientPrimaryNumber"
"			,patientBirthDate tempBirthDate"
"			,patientSsn tempSsn"
"			,patientFirstName tempFirstName"
"			,patientLastName tempLastName"
"			,convert(nvarchar(max), patientPrimaryNumber) tempPatientIdList"
"			,1 tempPatientIdCount"
"			,patientId currPatientId"
"			,patientPrimaryNumber currPatientPrimaryNumber"
"			,patientBirthDate currBirthDate"
"			,patientSsn currSsn"
"			,patientGenderCode currGender"
"			,patientFirstName currFirstName"
"			,patientLastName currLastName"
"			,patientId"
"			,patientPrimaryNumber"
"			,patientBirthDate"
"			,patientSsn"
"			,patientFirstName"
"			,patientLastName"
"			,convert(nvarchar(max), patientId) patientIdList"
"			,convert(nvarchar(max), patientPrimaryNumber) patientNumberList"
"			,1 patientCount"
"		from Patient.PatientDim"
"	   where clientId = @clientId"
"		 and recordTypeId in (11, 13) -- manually added"
"		 and patientPrimaryNumber like 'TEMP%'"
"		 and patientActiveFlag = 1"
"	   union all"
"	  select t.lvl + 1 lvl"
"			,t.clientId"
"			,t.tempPatientId"
"			,t.tempPatientPrimaryNumber"
"			,t.tempBirthDate"
"			,t.tempSsn"
"			,t.tempFirstName"
"			,t.tempLastName"
"			,convert(nvarchar(max), t.tempPatientIdList + case when pd.patientPrimaryNumber like 'TEMP%' then ',' + pd.patientPrimaryNumber else '' end) tempPatientIdList"
"			,t.tempPatientIdCount + case when pd.patientPrimaryNumber like 'TEMP%' then 1 else 0 end tempPatientIdCount"
"			,pd.patientId currPatientId"
"			,pd.patientPrimaryNumber currPatientPrimaryNumber"
"			,pd.patientBirthDate currBirthDate"
"			,pd.patientSsn currentSsn"
"			,pd.patientGenderCode currGender"
"			,pd.patientFirstName currFirstName"
"			,pd.patientLastName currLastName"
"			,pd.patientId"
"			,pd.patientPrimaryNumber"
"			,pd.patientBirthDate"
"			,pd.patientSsn"
"			,pd.patientFirstName"
"			,pd.patientLastName"
"			,convert(nvarchar(max), t.patientIdList + ',' + convert(nvarchar(255), pd.patientId)) patientIdList"
"			,convert(nvarchar(max), t.patientNumberList + ',' + pd.patientPrimaryNumber) patientNumberList"
"			,t.patientCount + case when t.patientNumberList not like '%' + pd.patientPrimaryNumber + '%' then 1 else 0 end patientCount"
"		from Patient.PatientDim pd"
"		join tempPatientList t on t.clientId = pd.clientId"
"							  and t.currSsn = pd.patientSsn"
"							  and t.currGender = pd.patientGenderCode"
"							  and left(t.currLastName, @firstNameLen) = left(pd.patientFirstName, @firstNameLen)"
"							  and left(t.currFirstName, @lastNameLen) = left(pd.patientLastName, @lastNameLen)"
"							  and t.currPatientId <> pd.patientId"
"							  and t.patientNumberList not like '%' + pd.patientPrimaryNumber + '%'"
"							  and pd.clientId = @clientId"
"							  --and pd.recordTypeId = 28 -- eligibility file"
"							  and pd.patientActiveFlag = 1)"
insert into ##temp_ID_members_src_5 
select lvl                            
"	  ,clientId"
"	  ,tempPatientId"
"	  ,tempPatientPrimaryNumber"
"	  ,tempBirthDate"
"	  ,tempSsn"
"	  ,tempFirstName"
"	  ,tempLastName"
"	  ,tempPatientIdList"
"	  ,tempPatientIdCount"
"	  ,currPatientId"
"	  ,currPatientPrimaryNumber"
"	  ,currBirthDate"
"	  ,currSsn"
"	  ,currFirstName"
"	  ,currLastName"
"	  ,patientIdList"
"	  ,patientNumberList"
"	  ,patientCount"
"	  ,row_number() over(partition by tempPatientId order by lvl desc) rnk"
  from tempPatientList 
option (maxdop 1) ; 

insert into EdmStage.ID_TempMemberStage
select 5 matchTypeId
      ,'ssn|gender|firstName' + convert(varchar(2), @firstNameLen) + '=lastName' + convert(varchar(2), @firstNameLen) + '|lastName' + convert(varchar(2), @lastNameLen) + '=firstName' + convert(varchar(2), @lastNameLen) matchTypeName
      ,clientId
      ,tempPatientPrimaryNumber
"	  ,tempPatientIdCount"
"	  ,tempPatientIdList"
      ,patientIdList
"	  ,patientNumberList"
"	  ,patientCount"
  from ##temp_ID_members_src_5
 where rnk = 1 
   and tempPatientPrimaryNumber <> patientNumberList
 group by clientId
         ,tempPatientPrimaryNumber
"	     ,tempPatientIdCount"
"	     ,tempPatientIdList"
"		 ,patientIdList"
"	     ,patientNumberList"
"		 ,patientCount "
option (maxdop 1) ; 
 
insert into EdmStage.ID_TempMemberStage
select 6 matchTypeId
      ,'dob|gender|lastName' matchTypeName
      ,clientId
      ,min(case when recordTypeId in (11, 13) then patientPrimaryNumber end) tempPatientId
"	  ,count(distinct case when recordTypeId in (11, 13) then patientPrimaryNumber end) tempPatientIdCount"
      ,string_agg(case when recordTypeId in (11, 13) then patientPrimaryNumber end, ',') within group (order by patientId) tempPatientIdList
"	  ,string_agg(patientId, ',') within group (order by patientId) patientIdList"
"	  ,string_agg(patientPrimaryNumber, ',') within group (order by patientId)  patientNumberList"
"	  ,count(distinct patientPrimaryNumber) patientCount"
  from Patient.PatientDim
 where clientId = @clientId
   and patientActiveFlag = 1
 group by clientId
         ,patientLastName
         ,patientBirthDate
"		 ,patientGenderCode"
having count(*) > 1
   and sum(case when recordTypeId in (11, 13) then 1 else 0 end) > 0 
   and ((sum(case when patientPrimaryNumber like 'TEMP%' then 1 else 0 end) > 0
     and @onlyIncludeTempID = 1)
"	  or @onlyIncludeTempID = 0)"
option (maxdop 1) ; 

#NAME?
declare @validationCount int ;
declare @message  varchar(1000) ;

select @validationCount = count(*)
  from EdmStage.ID_TempMemberStage
 where tempPatientIdCount > 10
    or patientCount > 10 ;

set @message = 'patient count > 10';
if @validationCount > 0
"	select convert(int, @message) ;"

--select @validationCount = count(*)
#NAME?
-- where try_convert(bigint, tempPatientId) is not null;

set @message = 'tempPatientId must a string: e.g. T0001';
if @validationCount > 0
"	select convert(int, @message) ;"

select @validationCount = count(*)
  from EdmStage.ID_TempMemberStage
 where (tempPatientIdCount = 10 and tempPatientIdList not like '%,%,%,%,%,%,%,%,%')
   and (tempPatientIdCount = 9  and tempPatientIdList not like '%,%,%,%,%,%,%,%,%')
   and (tempPatientIdCount = 8  and tempPatientIdList not like '%,%,%,%,%,%,%,%')
   and (tempPatientIdCount = 7  and tempPatientIdList not like '%,%,%,%,%,%,%')
   and (tempPatientIdCount = 6  and tempPatientIdList not like '%,%,%,%,%,%')
   and (tempPatientIdCount = 5  and tempPatientIdList not like '%,%,%,%,%')
   and (tempPatientIdCount = 4  and tempPatientIdList not like '%,%,%,%')
   and (tempPatientIdCount = 3  and tempPatientIdList not like '%,%,%')
   and (tempPatientIdCount = 2  and tempPatientIdList not like '%,%')
   and (tempPatientIdCount = 1  and tempPatientIdList like '%,%')
option (maxdop 1) ; 

set @message = 'tempPatientIdCount mismatch';
if @validationCount > 0
"	select convert(int, @message) ;"

select @validationCount = count(*)
  from EdmStage.ID_TempMemberStage
 where (patientCount = 10 and patientNumberList not like '%,%,%,%,%,%,%,%,%')
   and (patientCount = 9  and patientNumberList not like '%,%,%,%,%,%,%,%,%')
   and (patientCount = 8  and patientNumberList not like '%,%,%,%,%,%,%,%')
   and (patientCount = 7  and patientNumberList not like '%,%,%,%,%,%,%')
   and (patientCount = 6  and patientNumberList not like '%,%,%,%,%,%')
   and (patientCount = 5  and patientNumberList not like '%,%,%,%,%')
   and (patientCount = 4  and patientNumberList not like '%,%,%,%')
   and (patientCount = 3  and patientNumberList not like '%,%,%')
   and (patientCount = 2  and patientNumberList not like '%,%')
   and (patientCount = 1  and patientNumberList like '%,%')
option (maxdop 1) ; 
  
set @message = 'patientCount mismatch';
if @validationCount > 0
"	select convert(int, @message) ;"

#NAME?
drop table if exists EdmStage.ID_TempMemberStage2 ;

select s.*
      ,convert(nvarchar(255), x.value) patientNumber
  into EdmStage.ID_TempMemberStage2
  from EdmStage.ID_TempMemberStage s
 cross apply string_split(patientNumberList, ',') x 
option (maxdop 1) ; 

drop table if exists EdmStage.ID_TempMemberStage3 ;

select clientId
      ,min(tempPatientId) origTempPatientId
      ,patientNumber
"	  ,string_agg(matchTypeId, ',') matchTypeIdList"
"	  ,string_agg(matchTypeName, ',') matchTypeNameList"
  into EdmStage.ID_TempMemberStage3
  from EdmStage.ID_TempMemberStage2 
 group by clientId
         ,patientNumber 
option (maxdop 1) ; 

drop table if exists EdmStage.ID_TempMemberStage4 ;

select clientId
"      ,origTempPatientId	  "
      ,string_agg(patientNumber, ',') patientNumberList
"	  ,count(distinct patientNumber) patientCount"
      ,string_agg(case when patientNumber not like 'TEMP%' then patientNumber end, ',') medicaidIdList
      ,count(distinct case when patientNumber not like 'TEMP%' then patientNumber end) medicaidIdCount
"	  ,matchTypeIdList"
"	  ,matchTypeNameList"
  into EdmStage.ID_TempMemberStage4
  from EdmStage.ID_TempMemberStage3 
 group by clientId
         ,origTempPatientId
"	     ,matchTypeIdList"
"	     ,matchTypeNameList "
option (maxdop 1) ; 

drop table if exists EdmStage.ID_TempMemberFinal ;

select s.clientId
      ,s.origTempPatientId
      ,s.patientNumberList
"	  ,s.patientCount"
"	  ,s.medicaidIdList"
"	  ,s.medicaidIdCount"
"	  ,convert(nvarchar(255), x.value) patientNumber"
"	  ,matchTypeIdList"
"	  ,matchTypeNameList"
  into EdmStage.ID_TempMemberFinal
  from EdmStage.ID_TempMemberStage4 s
 cross apply string_split(s.patientNumberList, ',') x 
option (maxdop 1) ; 

--select *
#NAME?
-- --order by patientCount desc ;
-- where patientNumberList like'%T00000003828%' -- '%T00000085731%' ; --00210462000
 
--select *
#NAME?
-- where origTempPatientId = 'T00000003828' -- ;'T00000085731';
/* 
select f.*
      ,pd.enterprisePatientId
      ,pd.patientLastName
"	  ,pd.patientFirstName"
"	  ,pd.patientBirthDate"
"	  ,pd.patientSsn"
"	  ,pd.patientGenderCode"
  from EdmStage.ID_TempMemberFinal f
  join Patient.PatientDim pd on f.clientId = pd.clientId
                            and f.patientNumber = pd.patientPrimaryNumber 
 order by 1, 2 ;
*/
 
drop table if exists EdmStage.ID_TempMemberResults ;

select f.origTempPatientId
      ,case when min(upper(pd.patientFirstName)) <> max(upper(pd.patientFirstName)) then 1 else 0 end isDiff_firstName
      ,case when min(upper(pd.patientFirstName)) <> max(upper(pd.patientFirstName)) then string_agg(pd.patientFirstName, ',') end firstNameList
      ,case when min(upper(pd.patientLastName)) <> max(upper(pd.patientLastName)) then 1 else 0 end isDiff_lastName
      ,case when min(upper(pd.patientLastName)) <> max(upper(pd.patientLastName)) then string_agg(pd.patientLastName, ',') end lastNameList
      ,case when min(pd.patientGenderCode) <> max(pd.patientGenderCode) then 1 else 0 end isDiff_gender
      ,case when min(pd.patientGenderCode) <> max(pd.patientGenderCode) then string_agg(pd.patientGenderCode, ',') end genderList
"	  ,case when min(pd.patientBirthDate) <> max(pd.patientBirthDate) or sum(case when pd.patientBirthDate is null then 1 else 0 end)>0 then 1 else 0 end isDiff_dob"
"	  ,case when min(pd.patientSsn) <> max(pd.patientSsn) or sum(case when pd.patientSsn is null then 1 else 0 end)>0 then 1 else 0 end isDiff_ssn"
"	  ,count(*) memberCount"
  into EdmStage.ID_TempMemberResults
  from EdmStage.ID_TempMemberFinal f
  join Patient.PatientDim pd on f.clientId = pd.clientId
                            and f.patientNumber = pd.patientPrimaryNumber 
 group by f.origTempPatientId 
option (maxdop 1) ; 

--select *
#NAME?
-- where not (isDiff_firstName = 0
#NAME?
#NAME?
--   and isDiff_dob = 0)
--   and isDiff_gender = 1;

drop table if exists EdmStage.ID_MPI_Stage ;

select row_number() over(partition by 1 order by origTempPatientId, patientId) stageId
      ,@fileRequestId fileRequestId
      ,x.*
  into EdmStage.ID_MPI_Stage
  from (select f.origTempPatientId
"	          ,convert(nvarchar(4000), f.matchTypeIdList) matchTypeIdList"
              ,pd.patientId
              ,pd.enterprisePatientId originalPatientIdentifier
"	          ,pd.patientPrimaryNumber currentPatientIdentifier"
              ,pd.patientLastName
"	          ,pd.patientMiddleName"
"	          ,pd.patientFirstName"
"	          ,pd.patientBirthDate"
"	          ,pd.patientSsn"
"	          ,pd.patientGenderCode"
"	          ,ad.addressLine1"
"	          ,ad.addressLine2"
"	          ,ad.city"
"	          ,ad.state"
"	          ,ad.zip"
"	          ,ad.patientAddressId"
"			  ,convert(nvarchar(255), null) mpiId"
"	          ,dense_rank() over(partition by pd.clientId, pd.patientId order by ad.createDateTime desc, ad.patientAddressId desc) rnk"
"			  ,pd.recordTypeId"
"			  ,pd.patientRaceCode"
"			  ,pd.patientMedicareNumber"
"			  ,pd.patientDeathDate"
"			  ,pd.patientMedicareIndicatorCode"
"			  ,case when pd.recordTypeId in (11, 13) then 1 else 0 end isTemporaryMember"
          from EdmStage.ID_TempMemberFinal f
          join Patient.PatientDim pd on f.clientId = pd.clientId
                                    and f.patientNumber = pd.patientPrimaryNumber 
"							        and pd.patientActiveFlag = 1"
          left join Patient.AddressDim ad on pd.clientId = ad.clientId
                                         and pd.patientId = ad.patientId
                                         and ad.addressTypeId = 12 
                                         and ad.activeFlag = 1) x
 where x.rnk = 1 
option (maxdop 1) ; 

#NAME?
#NAME?
"--	  ,matchTypeName"
--  from EdmStage.ID_TempMemberStage2 ;

/*
declare @firstName varchar(100) = 'Makins' ;
declare @lastName varchar(100) = 'Abraham' ;
declare @dob datetime2 = '1950-06-15 00:00:00.0000000' ;
declare @ssn varchar(15) = '212564334' ;
declare @gender varchar(1) = 'M' ;

-- 
declare @firstNameLen2 int = 2 ;
declare @lastNameLen2 int = 4 ;
-- 

select enterprisePatientId
      ,patientLastName
"	  ,left(patientLastName, @lastNameLen2)"
"	  ,patientFirstName"
"	  ,left(patientFirstName, @firstNameLen2)"
"	  ,patientBirthDate"
"	  ,patientSsn"
"	  ,patientGenderCode   "
"	  ,recordTypeId"
      ,case when (patientBirthDate = @dob and patientSsn = @ssn) then 1 else 0 end isMatchType1
      ,case when (patientBirthDate = @dob and left(patientFirstName, @firstNameLen2) = left(@firstName, @firstNameLen2) and left(patientLastName, @lastNameLen2) = left(@lastName, @lastNameLen2)) then 1 else 0 end isMatchType2
      ,case when (patientBirthDate = @dob and left(patientFirstName, @firstNameLen2) = left(@lastName, @firstNameLen2) and left(patientLastName, @lastNameLen2) = left(@firstName, @lastNameLen2)) then 1 else 0 end isMatchType3
"	  ,case when (patientSsn = @ssn and patientGenderCode = @gender and left(patientFirstName, @firstNameLen2) = left(@firstName, @firstNameLen2) and left(patientLastName, @lastNameLen2) = left(@lastName, @lastNameLen2)) then 1 else 0 end isMatchType4"
      ,case when (patientSsn = @ssn and patientGenderCode = @gender and left(patientFirstName, @firstNameLen2) = left(@lastName, @firstNameLen2) and left(patientLastName, @lastNameLen2) = left(@firstName, @lastNameLen2)) then 1 else 0 end isMatchType5
      ,case when (patientBirthDate = @dob and patientGenderCode = @gender and patientLastName = @lastName) then 1 else 0 end isMatchType6
  from Patient.PatientDim 
 where clientId = @clientId
    -- 1 
   and ((patientBirthDate = @dob and patientSsn = @ssn)
    -- 2
    or (patientBirthDate = @dob and left(patientFirstName, @firstNameLen2) = left(@firstName, @firstNameLen2) and left(patientLastName, @lastNameLen2) = left(@lastName, @lastNameLen2)) 
    -- 3
    or (patientBirthDate = @dob and left(patientFirstName, @firstNameLen2) = left(@lastName, @firstNameLen2) and left(patientLastName, @lastNameLen2) = left(@firstName, @lastNameLen2)) 
"	-- 4"
    or (patientSsn = @ssn and patientGenderCode = @gender and left(patientFirstName, @firstNameLen2) = left(@firstName, @firstNameLen2) and left(patientLastName, @lastNameLen2) = left(@lastName, @lastNameLen2)) 
    -- 
    or (patientSsn = @ssn and patientGenderCode = @gender and left(patientFirstName, @firstNameLen2) = left(@lastName, @firstNameLen2) and left(patientLastName, @lastNameLen2) = left(@firstName, @lastNameLen2)) 
    -- 6
    or (patientBirthDate = @dob and patientGenderCode = @gender and patientLastName = @lastName)
"	) "
"*/ 	1	2021-08-06 10:47:01.7200000	mssql"
"297	39	MPI-MISSING_MPI_COUNT	select count(*) from <tableSchema>.<tableName> where mpiId is null	1	2021-08-06 10:50:16.9166667	mssql"
"298	39	MPI-MERGE_BULK_REQUEST_STAGE_DEDUP	merge into <tableSchema>.<tableName> m"
using (select mc.fileRequestId
             ,mc.stageId
"       	     ,d.MPIID"
         from <tableSchema>.<tableName> mc
         join MPI.BulkRequestStageDedup d on mc.stageId = d.BulkRequestStageId
                                         and d.MPIID is not null
        where mc.mpiId is null
          and mc.fileRequestId = :fileRequestId) u
   on m.fileRequestId = u.fileRequestId
  and m.stageId = u.stageId
" when matched then update set m.mpiId = u.MPIID; 	1	2021-08-06 10:51:09.1300000	mssql"
"299	39	MPI-INSERT_BULK_REQUEST_STAGE	insert into MPI.BulkRequestStage "
       (BulkRequestStageId 
       ,ClientIdentifier 
       ,OriginalPatientIdentifier 
       ,CurrentPatientIdentifier 
       ,PolicyNumber 
       ,FirstName 
       ,MiddleName 
       ,LastName 
       ,SSN 
       ,DOB 
       ,Gender 
       ,AddressLine1 
       ,AddressLine2 
       ,City 
       ,State 
       ,ZIP 
       ,Telephone)
select m.stageId BulkRequestStageId
"	  ,c.clientCode ClientIdentifier "
      ,m.OriginalPatientIdentifier 
"	  ,m.CurrentPatientIdentifier "
"	  ,null PolicyNumber "
"	  ,upper(isnull(m.patientFirstName, 'UNKNOWN')) FirstName "
"	  ,null MiddleName "
"	  ,upper(isnull(m.patientLastName, 'UNKNOWN')) LastName "
"	  ,case when m.patientSsn = '000000000' then null else m.patientSsn end SSN"
"	  ,convert(varchar(10), m.patientBirthDate, 121) + ' 00:00:00' DOB "
"	  ,isnull(m.patientGenderCode, 'U') Gender "
"	  ,m.addressLine1 AddressLine1 "
"	  ,m.addressLine2 AddressLine2 "
"	  ,m.city City "
"	  ,m.state State "
"	  ,m.zip ZIP "
"	  ,null Telephone"
  from EdmStage.ID_MPI_Stage m
  join EdmLib.FileRequest fr on fr.fileRequestId = :fileRequestId
  join Reference.Client c on fr.clientId = c.clientId
" where m.fileRequestId = :fileRequestId ; 	1	2021-08-06 10:54:06.6366667	mssql"
"300	39	MPI-UPDATE_MANUAL_MEMBERS	declare @fileRequestId bigint = :fileRequestId ;"

merge into Patient.PatientDim m
using EdmStage.ID_MPI_Stage u
   on m.clientId = 38
  and m.patientId = u.patientId
  and u.recordTypeId in (11, 13)
" when matched then update set m.recordTypeId = 28 ; 	1	2021-08-06 10:55:03.2566667	mssql"
"301	39	MPI-DUPLICATE_MPI_COUNT	set nocount on"

insert into EdmStage.ID_MPI_History
select *
      ,sysdatetime() createDateTime
  from EdmStage.ID_MPI_Stage m ;

"select 0 recordCount ;	1	2021-08-06 10:57:11.7700000	mssql"
"302	39	INSERT_MPI_Stage	declare @fileRequestId bigint = :fileRequestId ;  "

#NAME?
declare @maxLenMemberId int ;
declare @maxLenMemberIdFixed int ;

select @maxLenMemberId = max(len(currentPatientIdentifier))
  from EdmStage.ID_MPI_History
 where currentPatientIdentifier not like 'TEMP%'  ;

if @maxLenMemberId > 12
"	select convert(int, case when @maxLenMemberId>12 then 'InvalID memberId length' else 1 end) ;  "

#NAME?
truncate table EdmStage.ID_Member ;

/*
drop table if exists ##ID_temp_originalAndCurrent ;

select *
  into ##ID_temp_originalAndCurrent
  from (select origTempPatientId
              ,mpiId
              ,originalPatientIdentifier
"			  ,addressLine1"
"			  ,addressLine2"
"			  ,city"
"			  ,state"
"			  ,zip"
"			  ,patientBirthDate"
"			  ,patientGenderCode"
"			  ,patientSsn"
"			  ,patientRaceCode"
"			  ,patientMedicareNumber"
"			  ,patientDeathDate"
"			  ,patientMedicareIndicatorCode"
"			   -- use the last member record that we received on the file"
"			   -- or the 1st temporary member manually created"
"        	  ,rank() over(partition by origTempPatientId, mpiId order by case when currentPatientIdentifier not like 'T%' then -1 else 1 end * patientId) rnk"
          from EdmStage.ID_MPI_Stage) x
 where rnk = 1 
option (maxdop 1) ;

-- print @@rowcount ;

insert into EdmStage.ID_Member
       (stageId 
"	   ,fileRequestId  "
"	   ,headerId  "
"	   ,detailId  "
"	   ,enterprisePatientId"
"	   ,enterpriseSubscriberId"
"	   ,patientPrimaryNumber  "
"	   ,patientPrimaryNumberQualifier  "
"	   ,originalMemberIdentifier "
"	   ,memberSsn  "
"	   ,relationshipCode  "
"	   ,memberLastName  "
"	   ,memberFirstname  "
"	   ,memberMiddleName  "
"	   ,memberBirthDate  "
"	   ,memberDeathDate  "
"	   ,memberGenderCode  "
"	   ,memberRaceCode  "
"	   ,memberPrimaryAddressLine1  "
"	   ,memberPrimaryAddressLine2  "
"	   ,memberPrimaryAddressCityName  "
"	   ,memberPrimaryAddressStateCode  "
"	   ,memberPrimaryAddressZipCode "
"	   ,tempEnterprisePatientId"
"	   ,maintenanceReasonCode"
"	   ,maintenanceTypeCode"
"	   ,isTemporary"
"	   ,handicapIndicator"
"	   ,transactionSetCreationDateTime) "
"select s.stageId																																			"
"	  ,s.fileRequestId																																		"
"	  ,0 headerId																																			"
"	  ,0 detailId																																			"
"	  ,oc.originalPatientIdentifier enterprisePatientId																										"
"	  ,oc.originalPatientIdentifier enterpriseSubscriberId																									"
"	  ,replace(s.currentPatientIdentifier, 'ID', '') patientPrimaryNumber																					"
"	  ,'1D' patientPrimaryNumberQualifier																									                "
"	  ,oc.originalPatientIdentifier																														    "
"	  ,left(oc.patientSsn, 9) memberSsn																														"
"	  ,'18' relationshipCode																																"
"	  ,s.patientLastName  memberLastName																													"
"	  ,s.patientFirstName memberFirstName																													"
"	  ,s.patientMiddleName memberMiddleInitial																												"
"	  ,replace(convert(varchar(10), s.patientBirthDate, 112) , '-', '') memberBirthDate																						"
"	  ,replace(convert(varchar(10), oc.patientDeathDate, 112), '-', '')  memberDeathDate																						"
"	  ,case oc.patientGenderCode when 'M' then 'M' when 'F' then 'F' end memberGenderCode																	"
"	  ,left(isnull(rc.inValue, replace(oc.patientRaceCode, '~', '')), 1) memberRaceCode																		"
"	  ,oc.addressLine1 memberPrimaryAddressLine1																											"
"	  ,oc.addressLine2 memberPrimaryAddressLine2																											"
"	  ,oc.city memberPrimaryAddressCityName																													"
"	  ,oc.state memberPrimaryAddressStateCode																												"
"	  ,left(replace(oc.zip, '-', ''), 9) memberPrimaryAddressZipCode																						"
"	  ,case when s.currentPatientIdentifier like 'T%' then 'ID'+ s.currentPatientIdentifier else 'ID'+ s.origTempPatientId end tempEnterprisePatientId		"
"	  ,'AI' maintenanceReasonCode"
"	  ,'030' maintenanceTypeCode																															"
"	  ,s.isTemporaryMember"
"	  ,0 handicapIndicator"
"	  ,sysdatetime() transactionSetCreationDateTime"
  from EdmStage.ID_MPI_Stage s
  join ##ID_temp_originalAndCurrent oc on s.origTempPatientId = oc.origTempPatientId 
                                      and s.mpiId = oc.mpiId
  left join EdmLib.Mapping rc on oc.patientRaceCode = rc.outValue
                             and rc.name = 'ID_RACE_CODE'
 --where 1 = 2
option (maxdop 1) ;
*/

#NAME?
#NAME?
"	drop table if exists ##ID_temp_hist_originalAndCurrent ;"

"	select *"
"	  into ##ID_temp_hist_originalAndCurrent"
"	  from (select origTempPatientId"
"				  ,mpiId"
"				  ,originalPatientIdentifier"
"			      ,addressLine1"
"			      ,addressLine2"
"			      ,city"
"			      ,state"
"			      ,zip"
"			      ,patientBirthDate"
"			      ,patientGenderCode"
"			      ,patientSsn"
"				  ,patientRaceCode"
"			      ,patientMedicareNumber"
"			      ,patientDeathDate"
"			      ,patientMedicareIndicatorCode"
"				   -- use the last member record that we received on the file"
"				   -- or the 1st temporary member manually created"
"        		  ,rank() over(partition by origTempPatientId, mpiId order by case when currentPatientIdentifier not like 'T%' then -1 else 1 end * patientId, createDateTime desc) rnk"
"			  from EdmStage.ID_MPI_History"
"			 where fileRequestId = @fileRequestId) x"
"	 where rnk = 1 "
option (maxdop 1) ;

"	drop table if exists EdmStage.ID_Member_1 ;"
"	"
"	  select x.stageId"
            ,x.fileRequestId
"			,x.headerId"
"			,x.detailId"
            ,x.enterprisePatientId
"			,x.enterprisePatientId enterpriseSubscriberId"
            ,x.patientPrimaryNumber
"			,'1D' patientPrimaryNumberQualifier"
"			,x.originalPatientIdentifier"
            ,x.memberSsn
"			,'18' relationshipCode"
            ,x.memberLastName
            ,x.memberFirstName
            ,x.memberMiddleInitial
            ,x.memberBirthDate
            ,x.memberDeathDate
            ,x.memberPrimaryAddressLine1
            ,x.memberPrimaryAddressLine2
            ,x.memberPrimaryAddressCityName
            ,x.memberPrimaryAddressStateCode
            ,x.memberPrimaryAddressZipCode
            ,x.memberGenderCode
            ,x. memberRaceCode
"	        ,x.maintenanceReasonCode"
"	        ,x.maintenanceTypeCode"
            ,x.isTemporaryMember
"			,0 handicapIndicator"
            ,sysdatetime() transactionSetCreationDateTime
"			,x.originalPatientIdentifier originalMemberIdentifier"
"			,x.origTempPatientId"
"			,x.mpiCount"
"	    into EdmStage.ID_Member_1"
"		from (select s.stageId"
                    ,s.fileRequestId
"					,0 headerId"
"					,0 detailId"
                    ,oc.originalPatientIdentifier enterprisePatientId
                    ,replace(s.currentPatientIdentifier, 'ID', '') patientPrimaryNumber
"					,oc.originalPatientIdentifier"
                    ,left(oc.patientSsn, 9) memberSsn
                    ,s.patientLastName  memberLastName
                    ,s.patientFirstName memberFirstName
                    ,s.patientMiddleName memberMiddleInitial
                    ,replace(convert(varchar(10), s.patientBirthDate, 112) , '-', '') memberBirthDate
                    ,replace(convert(varchar(10), oc.patientDeathDate, 112), '-', '')  memberDeathDate
                    ,oc.addressLine1 memberPrimaryAddressLine1
                    ,oc.addressLine2 memberPrimaryAddressLine2
                    ,oc.city memberPrimaryAddressCityName
                    ,oc.state memberPrimaryAddressStateCode
                    ,left(replace(oc.zip, '-', ''), 9) memberPrimaryAddressZipCode
                    ,case oc.patientGenderCode when 'M' then 'M' when 'F' then 'F' end memberGenderCode
                    ,left(isnull(rc.inValue, replace(oc.patientRaceCode, '~', '')), 1) memberRaceCode
                    --,case when s.currentPatientIdentifier like 'T%' then 'ID'+ s.currentPatientIdentifier else 'ID'+ s.origTempPatientId end tempEnterprisePatientId
"	                ,'AI' maintenanceReasonCode"
"	                ,'030' maintenanceTypeCode"
                    ,isnull(case when s.currentPatientIdentifier like 'T%' then 1 else s.isTemporaryMember end,  0) isTemporaryMember
"                    ,rank() over(partition by s.stageId order by s.createDateTime desc) rnk	"
"				    ,s.currentPatientIdentifier"
"					,s.origTempPatientId"
"				    ,s.mpiId"
"			        ,dense_rank() over(partition by s.origTempPatientId order by s.mpiId) +"
                     dense_rank() over(partition by s.origTempPatientId order by s.mpiId desc)
                     - 1 mpiCount
                from EdmStage.ID_MPI_History s
                join ##ID_temp_hist_originalAndCurrent oc on s.origTempPatientId = oc.origTempPatientId 
                                                         and s.mpiId = oc.mpiId 
                left join EdmLib.Mapping rc on oc.patientRaceCode = rc.outValue
                                           and rc.name = 'ID_RACE_CODE'
               where s.fileRequestId = @fileRequestId) x 
       where x.rnk = 1
      option (maxdop 1) ;

"	 insert into EdmStage.ID_Member     "
           (stageId 
"	       ,fileRequestId  "
"	       ,headerId  "
"	       ,detailId  "
"	       ,enterprisePatientId"
"	       ,enterpriseSubscriberId"
"	       ,patientPrimaryNumber  "
"	       ,patientPrimaryNumberQualifier  "
"	       ,originalMemberIdentifier "
"	       ,memberSsn  "
"	       ,relationshipCode  "
"	       ,memberLastName  "
"	       ,memberFirstname  "
"	       ,memberMiddleName  "
"	       ,memberBirthDate  "
"	       ,memberDeathDate  "
"	       ,memberGenderCode  "
"	       ,memberRaceCode  "
"	       ,memberPrimaryAddressLine1  "
"	       ,memberPrimaryAddressLine2  "
"	       ,memberPrimaryAddressCityName  "
"	       ,memberPrimaryAddressStateCode  "
"	       ,memberPrimaryAddressZipCode "
"	       ,maintenanceReasonCode"
"	       ,maintenanceTypeCode"
"	       ,isTemporary"
"		   ,handicapIndicator		   "
"           ,transactionSetCreationDateTime		   "
"	       ,tempEnterprisePatientId) "
"	 select stageId "
"	       ,fileRequestId  "
"	       ,headerId  "
"	       ,detailId  "
"	       ,enterprisePatientId"
"	       ,enterpriseSubscriberId"
"	       ,patientPrimaryNumber  "
"	       ,patientPrimaryNumberQualifier  "
"	       ,originalMemberIdentifier "
"	       ,memberSsn  "
"	       ,relationshipCode  "
"	       ,memberLastName  "
"	       ,memberFirstname  "
"	       ,null memberMiddleName  "
"	       ,memberBirthDate  "
"	       ,memberDeathDate  "
"	       ,memberGenderCode  "
"	       ,memberRaceCode  "
"	       ,memberPrimaryAddressLine1  "
"	       ,memberPrimaryAddressLine2  "
"	       ,memberPrimaryAddressCityName  "
"	       ,memberPrimaryAddressStateCode  "
"	       ,memberPrimaryAddressZipCode "
"	       ,maintenanceReasonCode"
"	       ,maintenanceTypeCode"
"	       ,isTemporaryMember"
"		   ,handicapIndicator		   "
"           ,transactionSetCreationDateTime					"
"		   ,case when x.mpiCount > 1 or (x.patientPrimaryNumber like 'T%' and x.mpiCount=1) then 'ID'+ x.patientPrimaryNumber else 'ID'+ x.origTempPatientId end tempEnterprisePatientId"
       from EdmStage.ID_Member_1 x;

"--end ; 	1	2021-08-06 16:32:35.5766667	mssql"
"303	78	MPI-ADD_NEW_GROUP_POLICIES	-- deactivated for client	0	2021-08-09 14:18:44.0900000	mssql"
"304	78	MPI-ADD_NEW_PLANS	-- deactivated for client	0	2021-08-09 14:18:44.1766667	mssql"
"305	78	MPI-INSERT_MANUAL_MEMBERS	/*"
"	Purpose: associate manually added temporary members to other temporary members or members on file."
*/
set nocount off ;

declare @fileRequestId bigint = :fileRequestId ;

declare @clientId int = 78 ;
declare @firstNameLen int  ;
declare @lastNameLen int ;
declare @onlyIncludeTempID bit = 0 ;

select @firstNameLen = isnull(try_convert(int, outValue), 2)
  from EdmLib.Mapping
 where name = 'CO_MEMBER_PREPROCESS'
   and inValue = 'FIRST_NAME_LEN' ;

select @lastNameLen = isnull(try_convert(int, outValue), 4)
  from EdmLib.Mapping
 where name = 'CO_MEMBER_PREPROCESS'
   and inValue = 'LAST_NAME_LEN' ;

if exists (select *
             from EdmLib.Mapping
            where name = 'CO_MEMBER_PREPROCESS'
              and inValue = 'ONLY_INCLUDE_TEMP_ID'
              and upper(outValue) = 'TRUE')
   set @onlyIncludeTempID = 1;

if @firstNameLen is null or
   @lastNameLen is null
"	throw 51000, 'Invalid request.', 16 ;"

drop table if exists EdmStage.CO_TempMemberStage ;

create table EdmStage.CO_TempMemberStage
(matchTypeId int 
,matchTypeName nvarchar(255)
,clientId int
,tempPatientId nvarchar(255)
,tempPatientIdCount int
,tempPatientIdList nvarchar(max)
,patientIdList nvarchar(max)
,patientNumberList nvarchar(max)
,patientCount int) ;

insert into EdmStage.CO_TempMemberStage
select 1 matchTypeId
      ,'dob|ssn' matchTypeName
      ,clientId
      ,min(case when recordTypeId in (11, 13) then patientPrimaryNumber end) tempPatientId
"	  ,count(distinct case when recordTypeId in (11, 13) then patientPrimaryNumber end) tempPatientIdCount"
      ,string_agg(case when recordTypeId in (11, 13) then patientPrimaryNumber end, ',') within group (order by patientId) tempPatientIdList
"	  ,string_agg(patientId, ',') within group (order by patientId)  patientIdList"
"	  ,string_agg(patientPrimaryNumber, ',') within group (order by patientId)  patientNumberList"
"	  ,count(distinct patientPrimaryNumber) patientCount"
  from Patient.PatientDim
 where clientId = @clientId
   and patientActiveFlag = 1
   and patientSsn is not null
 group by clientId
         ,patientBirthDate
         ,patientSsn
having count(*) > 1
   and sum(case when recordTypeId in (11, 13) then 1 else 0 end) > 0 
   and ((sum(case when patientPrimaryNumber like 'TEMP%' then 1 else 0 end) > 0
     and @onlyIncludeTempID = 1)
"	  or @onlyIncludeTempID = 0)"
option (maxdop 1) ; 
 
insert into EdmStage.CO_TempMemberStage
select 2 matchTypeId
      ,'dob|firstName' + convert(varchar(2), @firstNameLen) + '|lastName' + convert(varchar(2), @lastNameLen) matchTypeName
      ,clientId
      ,min(case when recordTypeId in (11, 13) then patientPrimaryNumber end) tempPatientId
"	  ,count(distinct case when recordTypeId in (11, 13) then patientPrimaryNumber end) tempPatientIdCount"
      ,string_agg(case when recordTypeId in (11, 13) then patientPrimaryNumber end, ',') within group (order by patientId) tempPatientIdList
"	  ,string_agg(patientId, ',') within group (order by patientId)  patientIdList"
"	  ,string_agg(patientPrimaryNumber, ',') within group (order by patientId)  patientNumberList"
"	  ,count(distinct patientPrimaryNumber) patientCount"
  from Patient.PatientDim
 where clientId = @clientId
   and patientActiveFlag = 1
 group by clientId
         ,patientBirthDate
         ,left(patientFirstName, @firstNameLen)
         ,left(patientLastName, @lastNameLen)
having count(*) > 1
   and sum(case when recordTypeId in (11, 13) then 1 else 0 end) > 0 
   and ((sum(case when patientPrimaryNumber like 'TEMP%' then 1 else 0 end) > 0
     and @onlyIncludeTempID = 1)
"	  or @onlyIncludeTempID = 0)"
option (maxdop 1) ; 

drop table if exists ##temp_CO_members_src_3 ;

create table ##temp_CO_members_src_3 
(lvl int
,clientId int
,tempPatientId bigint
,tempPatientPrimaryNumber nvarchar(255)
,tempBirthDate datetime2
,tempSsn nvarchar(255)
,tempFirstName nvarchar(255)
,tempLastName nvarchar(255)
,tempPatientIdList nvarchar(max)
,tempPatientIdCount int
,currPatientId bigint
,currPatientPrimaryNumber nvarchar(255)
,currBirthDate datetime2
,currSsn nvarchar(255)
,currFirstName nvarchar(255)
,currLastName nvarchar(255)
,patientIdList nvarchar(max)
,patientNumberList nvarchar(max)
,patientCount int
,rnk int) ;

with tempPatientList as
"	 (select 0 lvl"
"			,clientId"
"			,patientId tempPatientId"
"			,patientPrimaryNumber tempPatientPrimaryNumber"
"			,patientBirthDate tempBirthDate"
"			,patientSsn tempSsn"
"			,patientFirstName tempFirstName"
"			,patientLastName tempLastName"
"			,convert(nvarchar(max), patientPrimaryNumber) tempPatientIdList"
"			,1 tempPatientIdCount"
"			,patientId currPatientId"
"			,patientPrimaryNumber currPatientPrimaryNumber"
"			,patientBirthDate currBirthDate"
"			,patientSsn currSsn"
"			,patientFirstName currFirstName"
"			,patientLastName currLastName"
"			,patientId"
"			,patientPrimaryNumber"
"			,patientBirthDate"
"			,patientSsn"
"			,patientFirstName"
"			,patientLastName"
"			,convert(nvarchar(max), patientId) patientIdList"
"			,convert(nvarchar(max), patientPrimaryNumber) patientNumberList"
"			,1 patientCount"
"		from Patient.PatientDim"
"	   where clientId = @clientId"
"		 and recordTypeId in (11, 13) -- manually added"
"		 and patientPrimaryNumber like 'TEMP%'"
"		 and patientActiveFlag = 1"
"	   union all"
"	  select t.lvl + 1 lvl"
"			,t.clientId"
"			,t.tempPatientId"
"			,t.tempPatientPrimaryNumber"
"			,t.tempBirthDate"
"			,t.tempSsn"
"			,t.tempFirstName"
"			,t.tempLastName"
"			,convert(nvarchar(max), t.tempPatientIdList + case when pd.patientPrimaryNumber like 'TEMP%' then ',' + pd.patientPrimaryNumber else '' end) tempPatientIdList"
"			,t.tempPatientIdCount + case when pd.patientPrimaryNumber like 'TEMP%' then 1 else 0 end tempPatientIdCount"
"			,pd.patientId currPatientId"
"			,pd.patientPrimaryNumber currPatientPrimaryNumber"
"			,pd.patientBirthDate currBirthDate"
"			,pd.patientSsn currentSsn"
"			,pd.patientFirstName currFirstName"
"			,pd.patientLastName currLastName"
"			,pd.patientId"
"			,pd.patientPrimaryNumber"
"			,pd.patientBirthDate"
"			,pd.patientSsn"
"			,pd.patientFirstName"
"			,pd.patientLastName"
"			,convert(nvarchar(max), t.patientIdList + ',' + convert(nvarchar(255), pd.patientId)) patientIdList"
"			,convert(nvarchar(max), t.patientNumberList + ',' + pd.patientPrimaryNumber) patientNumberList"
"			,t.patientCount + case when t.patientNumberList not like 'TEMP%' + pd.patientPrimaryNumber + '%' then 1 else 0 end patientCount"
"		from Patient.PatientDim pd"
"		join tempPatientList t on t.clientId = pd.clientId"
"							  and t.currBirthDate = pd.patientBirthDate"
"							  and left(t.currLastName, @firstNameLen) = left(pd.patientFirstName, @firstNameLen)"
"							  and left(t.currFirstName, @lastNameLen) = left(pd.patientLastName, @lastNameLen)"
"							  and t.currPatientId <> pd.patientId"
"							  and t.patientNumberList not like '%' + pd.patientPrimaryNumber + '%'"
"							  and pd.clientId = @clientId"
"							  --and pd.recordTypeId = 28 -- eligibility file"
"							  and pd.patientActiveFlag = 1)"
insert into ##temp_CO_members_src_3 
select lvl                            
"	  ,clientId"
"	  ,tempPatientId"
"	  ,tempPatientPrimaryNumber"
"	  ,tempBirthDate"
"	  ,tempSsn"
"	  ,tempFirstName"
"	  ,tempLastName"
"	  ,tempPatientIdList"
"	  ,tempPatientIdCount"
"	  ,currPatientId"
"	  ,currPatientPrimaryNumber"
"	  ,currBirthDate"
"	  ,currSsn"
"	  ,currFirstName"
"	  ,currLastName"
"	  ,patientIdList"
"	  ,patientNumberList"
"	  ,patientCount"
"	  ,row_number() over(partition by tempPatientId order by lvl desc) rnk"
  from tempPatientList 
option (maxdop 1) ; 

insert into EdmStage.CO_TempMemberStage
select 3 matchTypeId
      ,'dob|firstName' + convert(varchar(2), @firstNameLen) + '=lastName' + convert(varchar(2), @firstNameLen) + '|lastName' + convert(varchar(2), @lastNameLen) + '=firstName' + convert(varchar(2), @lastNameLen) matchTypeName
      ,clientId
      ,tempPatientPrimaryNumber
"	  ,tempPatientIdCount"
"	  ,tempPatientIdList"
      ,patientIdList
"	  ,patientNumberList"
"	  ,patientCount"
  from ##temp_CO_members_src_3
 where rnk = 1 
   and tempPatientPrimaryNumber <> patientNumberList
 group by clientId
         ,tempPatientPrimaryNumber
         ,tempPatientIdCount
"		 ,tempPatientIdList"
"		 ,patientIdList"
"		 ,patientNumberList"
"		 ,patientCount"
option (maxdop 1) ; 

insert into EdmStage.CO_TempMemberStage
select 4 matchTypeId
      ,'ssn|gender|firstName' + convert(varchar(2), @firstNameLen) + '|lastName' + convert(varchar(2), @lastNameLen) matchTypeName
      ,clientId
      ,min(case when recordTypeId in (11, 13) then patientPrimaryNumber end) tempPatientId
"	  ,count(distinct case when recordTypeId in (11, 13) then patientPrimaryNumber end) tempPatientIdCount"
      ,string_agg(case when recordTypeId in (11, 13) then patientPrimaryNumber end, ',') within group (order by patientId) tempPatientIdList
"	  ,string_agg(patientId, ',') within group (order by patientId) patientIdList"
"	  ,string_agg(patientPrimaryNumber, ',') within group (order by patientId)  patientNumberList"
"	  ,count(distinct patientPrimaryNumber) patientCount"
  from Patient.PatientDim
 where clientId = @clientId
   and patientActiveFlag = 1
   and patientSsn is not null
   and patientGenderCode in ('M', 'F')
 group by clientId
         ,patientSsn
         ,patientGenderCode
         ,left(patientFirstName, @firstNameLen)
         ,left(patientLastName, @lastnameLen)
having count(*) > 1
   and sum(case when recordTypeId in (11, 13) then 1 else 0 end) > 0
   and ((sum(case when patientPrimaryNumber like 'TEMP%' then 1 else 0 end) > 0
     and @onlyIncludeTempID = 1)
"	  or @onlyIncludeTempID = 0)"
option (maxdop 1) ; 
   
drop table if exists ##temp_CO_members_src_5 ;

create table ##temp_CO_members_src_5 
(lvl int
,clientId int
,tempPatientId bigint
,tempPatientPrimaryNumber nvarchar(255)
,tempBirthDate datetime2
,tempSsn nvarchar(255)
,tempFirstName nvarchar(255)
,tempLastName nvarchar(255)
,tempPatientIdList nvarchar(max)
,tempPatientIdCount int
,currPatientId bigint
,currPatientPrimaryNumber nvarchar(255)
,currBirthDate datetime2
,currSsn nvarchar(255)
,currFirstName nvarchar(255)
,currLastName nvarchar(255)
,patientIdList nvarchar(max)
,patientNumberList nvarchar(max)
,patientCount int
,rnk int) ;

with tempPatientList as
"	 (select 0 lvl"
"			,clientId"
"			,patientId tempPatientId"
"			,patientPrimaryNumber tempPatientPrimaryNumber"
"			,patientBirthDate tempBirthDate"
"			,patientSsn tempSsn"
"			,patientFirstName tempFirstName"
"			,patientLastName tempLastName"
"			,convert(nvarchar(max), patientPrimaryNumber) tempPatientIdList"
"			,1 tempPatientIdCount"
"			,patientId currPatientId"
"			,patientPrimaryNumber currPatientPrimaryNumber"
"			,patientBirthDate currBirthDate"
"			,patientSsn currSsn"
"			,patientGenderCode currGender"
"			,patientFirstName currFirstName"
"			,patientLastName currLastName"
"			,patientId"
"			,patientPrimaryNumber"
"			,patientBirthDate"
"			,patientSsn"
"			,patientFirstName"
"			,patientLastName"
"			,convert(nvarchar(max), patientId) patientIdList"
"			,convert(nvarchar(max), patientPrimaryNumber) patientNumberList"
"			,1 patientCount"
"		from Patient.PatientDim"
"	   where clientId = @clientId"
"		 and recordTypeId in (11, 13) -- manually added"
"		 and patientPrimaryNumber like 'TEMP%'"
"		 and patientActiveFlag = 1"
"	   union all"
"	  select t.lvl + 1 lvl"
"			,t.clientId"
"			,t.tempPatientId"
"			,t.tempPatientPrimaryNumber"
"			,t.tempBirthDate"
"			,t.tempSsn"
"			,t.tempFirstName"
"			,t.tempLastName"
"			,convert(nvarchar(max), t.tempPatientIdList + case when pd.patientPrimaryNumber like 'TEMP%' then ',' + pd.patientPrimaryNumber else '' end) tempPatientIdList"
"			,t.tempPatientIdCount + case when pd.patientPrimaryNumber like 'TEMP%' then 1 else 0 end tempPatientIdCount"
"			,pd.patientId currPatientId"
"			,pd.patientPrimaryNumber currPatientPrimaryNumber"
"			,pd.patientBirthDate currBirthDate"
"			,pd.patientSsn currentSsn"
"			,pd.patientGenderCode currGender"
"			,pd.patientFirstName currFirstName"
"			,pd.patientLastName currLastName"
"			,pd.patientId"
"			,pd.patientPrimaryNumber"
"			,pd.patientBirthDate"
"			,pd.patientSsn"
"			,pd.patientFirstName"
"			,pd.patientLastName"
"			,convert(nvarchar(max), t.patientIdList + ',' + convert(nvarchar(255), pd.patientId)) patientIdList"
"			,convert(nvarchar(max), t.patientNumberList + ',' + pd.patientPrimaryNumber) patientNumberList"
"			,t.patientCount + case when t.patientNumberList not like '%' + pd.patientPrimaryNumber + '%' then 1 else 0 end patientCount"
"		from Patient.PatientDim pd"
"		join tempPatientList t on t.clientId = pd.clientId"
"							  and t.currSsn = pd.patientSsn"
"							  and t.currGender = pd.patientGenderCode"
"							  and left(t.currLastName, @firstNameLen) = left(pd.patientFirstName, @firstNameLen)"
"							  and left(t.currFirstName, @lastNameLen) = left(pd.patientLastName, @lastNameLen)"
"							  and t.currPatientId <> pd.patientId"
"							  and t.patientNumberList not like '%' + pd.patientPrimaryNumber + '%'"
"							  and pd.clientId = @clientId"
"							  --and pd.recordTypeId = 28 -- eligibility file"
"							  and pd.patientActiveFlag = 1)"
insert into ##temp_CO_members_src_5 
select lvl                            
"	  ,clientId"
"	  ,tempPatientId"
"	  ,tempPatientPrimaryNumber"
"	  ,tempBirthDate"
"	  ,tempSsn"
"	  ,tempFirstName"
"	  ,tempLastName"
"	  ,tempPatientIdList"
"	  ,tempPatientIdCount"
"	  ,currPatientId"
"	  ,currPatientPrimaryNumber"
"	  ,currBirthDate"
"	  ,currSsn"
"	  ,currFirstName"
"	  ,currLastName"
"	  ,patientIdList"
"	  ,patientNumberList"
"	  ,patientCount"
"	  ,row_number() over(partition by tempPatientId order by lvl desc) rnk"
  from tempPatientList 
option (maxdop 1) ; 

insert into EdmStage.CO_TempMemberStage
select 5 matchTypeId
      ,'ssn|gender|firstName' + convert(varchar(2), @firstNameLen) + '=lastName' + convert(varchar(2), @firstNameLen) + '|lastName' + convert(varchar(2), @lastNameLen) + '=firstName' + convert(varchar(2), @lastNameLen) matchTypeName
      ,clientId
      ,tempPatientPrimaryNumber
"	  ,tempPatientIdCount"
"	  ,tempPatientIdList"
      ,patientIdList
"	  ,patientNumberList"
"	  ,patientCount"
  from ##temp_CO_members_src_5
 where rnk = 1 
   and tempPatientPrimaryNumber <> patientNumberList
 group by clientId
         ,tempPatientPrimaryNumber
"	     ,tempPatientIdCount"
"	     ,tempPatientIdList"
"		 ,patientIdList"
"	     ,patientNumberList"
"		 ,patientCount "
option (maxdop 1) ; 
 
insert into EdmStage.CO_TempMemberStage
select 6 matchTypeId
      ,'dob|gender|lastName' matchTypeName
      ,clientId
      ,min(case when recordTypeId in (11, 13) then patientPrimaryNumber end) tempPatientId
"	  ,count(distinct case when recordTypeId in (11, 13) then patientPrimaryNumber end) tempPatientIdCount"
      ,string_agg(case when recordTypeId in (11, 13) then patientPrimaryNumber end, ',') within group (order by patientId) tempPatientIdList
"	  ,string_agg(patientId, ',') within group (order by patientId) patientIdList"
"	  ,string_agg(patientPrimaryNumber, ',') within group (order by patientId)  patientNumberList"
"	  ,count(distinct patientPrimaryNumber) patientCount"
  from Patient.PatientDim
 where clientId = @clientId
   and patientActiveFlag = 1
 group by clientId
         ,patientLastName
         ,patientBirthDate
"		 ,patientGenderCode"
having count(*) > 1
   and sum(case when recordTypeId in (11, 13) then 1 else 0 end) > 0 
   and ((sum(case when patientPrimaryNumber like 'TEMP%' then 1 else 0 end) > 0
     and @onlyIncludeTempID = 1)
"	  or @onlyIncludeTempID = 0)"
option (maxdop 1) ; 

#NAME?
declare @validationCount int ;
declare @message  varchar(1000) ;

select @validationCount = count(*)
  from EdmStage.CO_TempMemberStage
 where tempPatientIdCount > 10
    or patientCount > 10 ;

set @message = 'patient count > 10';
if @validationCount > 0
"	select convert(int, @message) ;"

--select @validationCount = count(*)
#NAME?
-- where try_convert(bigint, tempPatientId) is not null;

set @message = 'tempPatientId must a string: e.g. T0001';
if @validationCount > 0
"	select convert(int, @message) ;"

select @validationCount = count(*)
  from EdmStage.CO_TempMemberStage
 where (tempPatientIdCount = 10 and tempPatientIdList not like '%,%,%,%,%,%,%,%,%')
   and (tempPatientIdCount = 9  and tempPatientIdList not like '%,%,%,%,%,%,%,%,%')
   and (tempPatientIdCount = 8  and tempPatientIdList not like '%,%,%,%,%,%,%,%')
   and (tempPatientIdCount = 7  and tempPatientIdList not like '%,%,%,%,%,%,%')
   and (tempPatientIdCount = 6  and tempPatientIdList not like '%,%,%,%,%,%')
   and (tempPatientIdCount = 5  and tempPatientIdList not like '%,%,%,%,%')
   and (tempPatientIdCount = 4  and tempPatientIdList not like '%,%,%,%')
   and (tempPatientIdCount = 3  and tempPatientIdList not like '%,%,%')
   and (tempPatientIdCount = 2  and tempPatientIdList not like '%,%')
   and (tempPatientIdCount = 1  and tempPatientIdList like '%,%')
option (maxdop 1) ; 

set @message = 'tempPatientIdCount mismatch';
if @validationCount > 0
"	select convert(int, @message) ;"

select @validationCount = count(*)
  from EdmStage.CO_TempMemberStage
 where (patientCount = 10 and patientNumberList not like '%,%,%,%,%,%,%,%,%')
   and (patientCount = 9  and patientNumberList not like '%,%,%,%,%,%,%,%,%')
   and (patientCount = 8  and patientNumberList not like '%,%,%,%,%,%,%,%')
   and (patientCount = 7  and patientNumberList not like '%,%,%,%,%,%,%')
   and (patientCount = 6  and patientNumberList not like '%,%,%,%,%,%')
   and (patientCount = 5  and patientNumberList not like '%,%,%,%,%')
   and (patientCount = 4  and patientNumberList not like '%,%,%,%')
   and (patientCount = 3  and patientNumberList not like '%,%,%')
   and (patientCount = 2  and patientNumberList not like '%,%')
   and (patientCount = 1  and patientNumberList like '%,%')
option (maxdop 1) ; 
  
set @message = 'patientCount mismatch';
if @validationCount > 0
"	select convert(int, @message) ;"

#NAME?
drop table if exists EdmStage.CO_TempMemberStage2 ;

select s.*
      ,convert(nvarchar(255), x.value) patientNumber
  into EdmStage.CO_TempMemberStage2
  from EdmStage.CO_TempMemberStage s
 cross apply string_split(patientNumberList, ',') x 
option (maxdop 1) ; 

drop table if exists EdmStage.CO_TempMemberStage3 ;

select clientId
      ,min(tempPatientId) origTempPatientId
      ,patientNumber
"	  ,string_agg(matchTypeId, ',') matchTypeIdList"
"	  ,string_agg(matchTypeName, ',') matchTypeNameList"
  into EdmStage.CO_TempMemberStage3
  from EdmStage.CO_TempMemberStage2 
 group by clientId
         ,patientNumber 
option (maxdop 1) ; 

drop table if exists EdmStage.CO_TempMemberStage4 ;

select clientId
"      ,origTempPatientId	  "
      ,string_agg(patientNumber, ',') patientNumberList
"	  ,count(distinct patientNumber) patientCount"
      ,string_agg(case when patientNumber not like 'TEMP%' then patientNumber end, ',') medicaidIdList
      ,count(distinct case when patientNumber not like 'TEMP%' then patientNumber end) medicaidIdCount
"	  ,matchTypeIdList"
"	  ,matchTypeNameList"
  into EdmStage.CO_TempMemberStage4
  from EdmStage.CO_TempMemberStage3 
 group by clientId
         ,origTempPatientId
"	     ,matchTypeIdList"
"	     ,matchTypeNameList "
option (maxdop 1) ; 

drop table if exists EdmStage.CO_TempMemberFinal ;

select s.clientId
      ,s.origTempPatientId
      ,s.patientNumberList
"	  ,s.patientCount"
"	  ,s.medicaidIdList"
"	  ,s.medicaidIdCount"
"	  ,convert(nvarchar(255), x.value) patientNumber"
"	  ,matchTypeIdList"
"	  ,matchTypeNameList"
  into EdmStage.CO_TempMemberFinal
  from EdmStage.CO_TempMemberStage4 s
 cross apply string_split(s.patientNumberList, ',') x 
option (maxdop 1) ; 

--select *
#NAME?
-- --order by patientCount desc ;
-- where patientNumberList like'%T00000003828%' -- '%T00000085731%' ; --00210462000
 
--select *
#NAME?
-- where origTempPatientId = 'T00000003828' -- ;'T00000085731';
/* 
select f.*
      ,pd.enterprisePatientId
      ,pd.patientLastName
"	  ,pd.patientFirstName"
"	  ,pd.patientBirthDate"
"	  ,pd.patientSsn"
"	  ,pd.patientGenderCode"
  from EdmStage.CO_TempMemberFinal f
  join Patient.PatientDim pd on f.clientId = pd.clientId
                            and f.patientNumber = pd.patientPrimaryNumber 
 order by 1, 2 ;
*/
 
drop table if exists EdmStage.CO_TempMemberResults ;

select f.origTempPatientId
      ,case when min(upper(pd.patientFirstName)) <> max(upper(pd.patientFirstName)) then 1 else 0 end isDiff_firstName
      ,case when min(upper(pd.patientFirstName)) <> max(upper(pd.patientFirstName)) then string_agg(pd.patientFirstName, ',') end firstNameList
      ,case when min(upper(pd.patientLastName)) <> max(upper(pd.patientLastName)) then 1 else 0 end isDiff_lastName
      ,case when min(upper(pd.patientLastName)) <> max(upper(pd.patientLastName)) then string_agg(pd.patientLastName, ',') end lastNameList
      ,case when min(pd.patientGenderCode) <> max(pd.patientGenderCode) then 1 else 0 end isDiff_gender
      ,case when min(pd.patientGenderCode) <> max(pd.patientGenderCode) then string_agg(pd.patientGenderCode, ',') end genderList
"	  ,case when min(pd.patientBirthDate) <> max(pd.patientBirthDate) or sum(case when pd.patientBirthDate is null then 1 else 0 end)>0 then 1 else 0 end isDiff_dob"
"	  ,case when min(pd.patientSsn) <> max(pd.patientSsn) or sum(case when pd.patientSsn is null then 1 else 0 end)>0 then 1 else 0 end isDiff_ssn"
"	  ,count(*) memberCount"
  into EdmStage.CO_TempMemberResults
  from EdmStage.CO_TempMemberFinal f
  join Patient.PatientDim pd on f.clientId = pd.clientId
                            and f.patientNumber = pd.patientPrimaryNumber 
 group by f.origTempPatientId 
option (maxdop 1) ; 

--select *
#NAME?
-- where not (isDiff_firstName = 0
#NAME?
#NAME?
--   and isDiff_dob = 0)
--   and isDiff_gender = 1;

drop table if exists EdmStage.CO_MPI_Stage ;

select row_number() over(partition by 1 order by origTempPatientId, patientId) stageId
      ,@fileRequestId fileRequestId
      ,x.*
  into EdmStage.CO_MPI_Stage
  from (select f.origTempPatientId
"	          ,convert(nvarchar(4000), f.matchTypeIdList) matchTypeIdList"
              ,pd.patientId
              ,pd.enterprisePatientId originalPatientIdentifier
"	          ,pd.patientPrimaryNumber currentPatientIdentifier"
              ,pd.patientLastName
"	          ,pd.patientMiddleName"
"	          ,pd.patientFirstName"
"	          ,pd.patientBirthDate"
"	          ,pd.patientSsn"
"	          ,pd.patientGenderCode"
"	          ,ad.addressLine1"
"	          ,ad.addressLine2"
"	          ,ad.city"
"	          ,ad.state"
"	          ,ad.zip"
"	          ,ad.patientAddressId"
"			  ,convert(nvarchar(255), null) mpiId"
"	          ,dense_rank() over(partition by pd.clientId, pd.patientId order by ad.createDateTime desc, ad.patientAddressId desc) rnk"
"			  ,pd.recordTypeId"
"			  ,pd.patientRaceCode"
"			  ,pd.patientMedicareNumber"
"			  ,pd.patientDeathDate"
"			  ,pd.patientMedicareIndicatorCode"
"			  ,case when pd.recordTypeId in (11, 13) then 1 else 0 end isTemporaryMember"
          from EdmStage.CO_TempMemberFinal f
          join Patient.PatientDim pd on f.clientId = pd.clientId
                                    and f.patientNumber = pd.patientPrimaryNumber 
"							        and pd.patientActiveFlag = 1"
          left join Patient.AddressDim ad on pd.clientId = ad.clientId
                                         and pd.patientId = ad.patientId
                                         and ad.addressTypeId = 12 
                                         and ad.activeFlag = 1) x
 where x.rnk = 1 
option (maxdop 1) ; 

#NAME?
#NAME?
"--	  ,matchTypeName"
--  from EdmStage.CO_TempMemberStage2 ;

/*
declare @firstName varchar(100) = 'Makins' ;
declare @lastName varchar(100) = 'Abraham' ;
declare @dob datetime2 = '1950-06-15 00:00:00.0000000' ;
declare @ssn varchar(15) = '212564334' ;
declare @gender varchar(1) = 'M' ;

-- 
declare @firstNameLen2 int = 2 ;
declare @lastNameLen2 int = 4 ;
-- 

select enterprisePatientId
      ,patientLastName
"	  ,left(patientLastName, @lastNameLen2)"
"	  ,patientFirstName"
"	  ,left(patientFirstName, @firstNameLen2)"
"	  ,patientBirthDate"
"	  ,patientSsn"
"	  ,patientGenderCode   "
"	  ,recordTypeId"
      ,case when (patientBirthDate = @dob and patientSsn = @ssn) then 1 else 0 end isMatchType1
      ,case when (patientBirthDate = @dob and left(patientFirstName, @firstNameLen2) = left(@firstName, @firstNameLen2) and left(patientLastName, @lastNameLen2) = left(@lastName, @lastNameLen2)) then 1 else 0 end isMatchType2
      ,case when (patientBirthDate = @dob and left(patientFirstName, @firstNameLen2) = left(@lastName, @firstNameLen2) and left(patientLastName, @lastNameLen2) = left(@firstName, @lastNameLen2)) then 1 else 0 end isMatchType3
"	  ,case when (patientSsn = @ssn and patientGenderCode = @gender and left(patientFirstName, @firstNameLen2) = left(@firstName, @firstNameLen2) and left(patientLastName, @lastNameLen2) = left(@lastName, @lastNameLen2)) then 1 else 0 end isMatchType4"
      ,case when (patientSsn = @ssn and patientGenderCode = @gender and left(patientFirstName, @firstNameLen2) = left(@lastName, @firstNameLen2) and left(patientLastName, @lastNameLen2) = left(@firstName, @lastNameLen2)) then 1 else 0 end isMatchType5
      ,case when (patientBirthDate = @dob and patientGenderCode = @gender and patientLastName = @lastName) then 1 else 0 end isMatchType6
  from Patient.PatientDim 
 where clientId = @clientId
    -- 1 
   and ((patientBirthDate = @dob and patientSsn = @ssn)
    -- 2
    or (patientBirthDate = @dob and left(patientFirstName, @firstNameLen2) = left(@firstName, @firstNameLen2) and left(patientLastName, @lastNameLen2) = left(@lastName, @lastNameLen2)) 
    -- 3
    or (patientBirthDate = @dob and left(patientFirstName, @firstNameLen2) = left(@lastName, @firstNameLen2) and left(patientLastName, @lastNameLen2) = left(@firstName, @lastNameLen2)) 
"	-- 4"
    or (patientSsn = @ssn and patientGenderCode = @gender and left(patientFirstName, @firstNameLen2) = left(@firstName, @firstNameLen2) and left(patientLastName, @lastNameLen2) = left(@lastName, @lastNameLen2)) 
    -- 
    or (patientSsn = @ssn and patientGenderCode = @gender and left(patientFirstName, @firstNameLen2) = left(@lastName, @firstNameLen2) and left(patientLastName, @lastNameLen2) = left(@firstName, @lastNameLen2)) 
    -- 6
    or (patientBirthDate = @dob and patientGenderCode = @gender and patientLastName = @lastName)
"	) "
"*/ 	1	2021-08-09 14:18:45.3300000	mssql"
"306	78	MPI-MISSING_MPI_COUNT	select count(*) from <tableSchema>.<tableName> where mpiId is null	1	2021-08-09 14:49:01.7133333	mssql"
"307	78	MPI-INSERT_BULK_REQUEST_STAGE	declare @fileRequestId bigint = :fileRequestId ;"

insert into MPI.BulkRequestStage
       (BulkRequestStageId
       ,ClientIdentifier
       ,OriginalPatientIdentifier
       ,CurrentPatientIdentifier
       ,PolicyNumber
       ,FirstName
       ,MiddleName
       ,LastName
       ,SSN
       ,DOB
       ,Gender
       ,AddressLine1
       ,AddressLine2
       ,City
       ,State
       ,ZIP
       ,Telephone)
select m.stageId BulkRequestStageId
          ,c.clientCode ClientIdentifier
      ,m.OriginalPatientIdentifier
          ,m.currentPatientIdentifier
          ,m.originalPatientIdentifier PolicyNumber
          ,isnull(m.patientFirstName, 'UNKNOWN') FirstName
          ,null MiddleName
          ,isnull(m.patientLastName, 'UNKNOWN') LastName
          ,case when m.patientSsn = '000000000' then null else m.patientSsn end SSN
          ,case when year(try_convert(datetime2, patientBirthDate)) > 1800 then left(m.patientBirthDate, 4) +'-'+ right(left(patientBirthDate, 7), 2) +'-'+ right(left(patientBirthDate, 10), 2) + ' 00:00:00' end  DOB
          ,isnull(m.patientGenderCode, 'U') Gender
          ,m.addressLine1 AddressLine1
          ,m.addressLine2 AddressLine2
          ,m.city City
          ,m.state State
          ,m.zip ZIP
          ,null Telephone
  from EdmStage.CO_MPI_Stage m
  join EdmLib.FileRequest fr on fr.fileRequestId = @fileRequestId
  join Reference.Client c on fr.clientId = c.clientId
 where m.fileRequestId = @fileRequestId ;
" 	1	2021-08-09 14:54:42.4300000	mssql"
"308	78	MPI-MERGE_BULK_REQUEST_STAGE_DEDUP	merge into <tableSchema>.<tableName> m"
using (select mc.fileRequestId
             ,mc.stageId
"       	     ,d.MPIID"
         from <tableSchema>.<tableName> mc
         join MPI.BulkRequestStageDedup d on mc.stageId = d.BulkRequestStageId
                                         and d.MPIID is not null
        where mc.mpiId is null
          and mc.fileRequestId = :fileRequestId) u
   on m.fileRequestId = u.fileRequestId
  and m.stageId = u.stageId
" when matched then update set m.mpiId = u.MPIID; 	1	2021-08-09 14:59:42.1800000	mssql"
"309	78	MPI-DUPLICATE_MPI_COUNT	"
set nocount on

insert into EdmStage.CO_MPI_History
select *
      ,sysdatetime() createDateTime
  from EdmStage.CO_MPI_Stage m ;

"select 0 recordCount ;	1	2021-08-09 15:04:47.8900000	mssql"
"310	78	INSERT_MPI_Stage	declare @fileRequestId bigint = :fileRequestId ;  "

#NAME?
declare @maxLenMemberId int ;
declare @maxLenMemberIdFixed int ;

select @maxLenMemberId = max(len(currentPatientIdentifier))
  from EdmStage.CO_MPI_History
 where currentPatientIdentifier not like 'TEMP%'  ;

if @maxLenMemberId > 12
"	select convert(int, case when @maxLenMemberId>12 then 'Invalid memberId length' else 1 end) ;  "

#NAME?
truncate table EdmStage.Colorado_Member ;

/*
drop table if exists ##CO_temp_originalAndCurrent ;

select *
  into ##CO_temp_originalAndCurrent
  from (select origTempPatientId
              ,mpiId
              ,originalPatientIdentifier
"			  ,addressLine1"
"			  ,addressLine2"
"			  ,city"
"			  ,state"
"			  ,zip"
"			  ,patientBirthDate"
"			  ,patientGenderCode"
"			  ,patientSsn"
"			  ,patientRaceCode"
"			  ,patientMedicareNumber"
"			  ,patientDeathDate"
"			  ,patientMedicareIndicatorCode"
"			   -- use the last member record that we received on the file"
"			   -- or the 1st temporary member manually created"
"        	  ,rank() over(partition by origTempPatientId, mpiId order by case when currentPatientIdentifier not like 'TEMP%' then -1 else 1 end * patientId) rnk"
          from EdmStage.CO_MPI_Stage) x
 where rnk = 1 
option (maxdop 1) ;

-- print @@rowcount ;

insert into EdmStage.Colorado_Member
       (stageId 
"	   ,fileRequestId  "
"	   ,enterprisePatientId"
"	   ,enterpriseSubscriberId"
"	   ,memberPrimaryId  "
"	   ,memberPrimaryIdQualifier   "
"	   ,memberSupplementalId"
"	   ,memberSupplementalIdQualifier"
"	   ,memberRelationshipCode  "
"	   ,memberLastName  "
"	   ,memberFirstname  "
"	   ,memberMiddleName  "
"	   ,memberBirthDate  "
"	   ,memberDeathDate  "
"	   ,memberGenderCode  "
"	   ,memberRaceCode  "
"	   ,memberAddressLine1  "
"	   ,memberAddressLine2  "
"	   ,memberCityName  "
"	   ,memberStateCode  "
"	   ,memberPostalZoneCode "
"	   ,tempEnterprisePatientId"
"	   ,memberMaintenanceReasonCode"
"	   ,isTemporaryMember) "
"select s.stageId																																			"
"	  ,s.fileRequestId																																		"
"	  ,oc.originalPatientIdentifier enterprisePatientId																										"
"	  ,oc.originalPatientIdentifier enterpriseSubscriberId																									"
"	  ,replace(s.currentPatientIdentifier, 'CO', '') patientPrimaryNumber																					"
"	  ,'1D' patientPrimaryNumberQualifier																											    "
"	  ,left(oc.patientSsn, 9) memberSsn	"
"	  ,'SY' memberSupplementIdQualifier"
"	  ,'18' relationshipCode																																"
"	  ,s.patientLastName  memberLastName																													"
"	  ,s.patientFirstName memberFirstName																													"
"	  ,s.patientMiddleName memberMiddleInitial																												"
"	  ,convert(varchar(10), s.patientBirthDate, 121) memberBirthDate																						"
"	  ,convert(varchar(10), oc.patientDeathDate, 121)  memberDeathDate																						"
"	  ,case oc.patientGenderCode when 'M' then 'M' when 'F' then 'F' end memberGenderCode																	"
"	  ,left(isnull(rc.inValue, replace(oc.patientRaceCode, '~', '')), 1) memberRaceCode																		"
"	  ,oc.addressLine1 memberPrimaryAddressLine1																											"
"	  ,oc.addressLine2 memberPrimaryAddressLine2																											"
"	  ,oc.city memberPrimaryAddressCityName																													"
"	  ,oc.state memberPrimaryAddressStateCode																												"
"	  ,left(replace(oc.zip, '-', ''), 9) memberPrimaryAddressZipCode																						"
"	  ,case when s.currentPatientIdentifier like 'TEMP%' then 'CO'+ s.currentPatientIdentifier else 'CO'+ s.origTempPatientId end tempEnterprisePatientId		"
"	  ,'AI' maintenanceReasonCode																															"
"	  ,s.isTemporaryMember"
  from EdmStage.CO_MPI_Stage s
  join ##CO_temp_originalAndCurrent oc on s.origTempPatientId = oc.origTempPatientId 
                                      and s.mpiId = oc.mpiId
  left join EdmLib.Mapping rc on oc.patientRaceCode = rc.outValue
                             and rc.name = 'CO_RACE_CODE'
-- where 1 = 2
option (maxdop 1) ;
*/

#NAME?
#NAME?
"	drop table if exists ##CO_temp_hist_originalAndCurrent ;"

"	select *"
"	  into ##CO_temp_hist_originalAndCurrent"
"	  from (select origTempPatientId"
"				  ,mpiId"
"				  ,originalPatientIdentifier"
"			      ,addressLine1"
"			      ,addressLine2"
"			      ,city"
"			      ,state"
"			      ,zip"
"			      ,patientBirthDate"
"			      ,patientGenderCode"
"			      ,patientSsn"
"				  ,patientRaceCode"
"			      ,patientMedicareNumber"
"			      ,patientDeathDate"
"			      ,patientMedicareIndicatorCode"
"				   -- use the last member record that we received on the file"
"				   -- or the 1st temporary member manually created"
"        		  ,rank() over(partition by origTempPatientId, mpiId order by case when currentPatientIdentifier not like 'TEMP%' then -1 else 1 end * patientId, createDateTime desc) rnk"
"			  from EdmStage.CO_MPI_History"
"			 where fileRequestId = @fileRequestId) x"
"	 where rnk = 1 "
option (maxdop 1) ;

"	drop table if exists EdmStage.Colorado_Member_1  ;"
"	"
"	  select x.stageId"
            ,x.fileRequestId
            ,x.enterprisePatientId
"			,x.enterprisePatientId enterpriseSubscriberId"
            ,x.patientPrimaryNumber
"			,'1D' patientPrimaryNumberQualifier"
            ,x.memberSsn
"			,'SY' memberSupplementalIdQualifier4"
"			,'18' relationshipCode"
            ,x.memberLastName
            ,x.memberFirstName
            ,x.memberMiddleInitial
            ,x.memberBirthDate
            ,x.memberDeathDate
            ,x.memberGenderCode
            ,x. memberRaceCode
            ,x.memberPrimaryAddressLine1
            ,x.memberPrimaryAddressLine2
            ,x.memberPrimaryAddressCityName
            ,x.memberPrimaryAddressStateCode
            ,x.memberPrimaryAddressZipCode
            ,x.tempEnterprisePatientId
"	        ,x.maintenanceReasonCode"
            ,x.isTemporaryMember
"			,x.origTempPatientId"
"			,x.mpiCount"
"	    into EdmStage.Colorado_Member_1"
"		from (select s.stageId"
                    ,s.fileRequestId
"					,0 headerId"
"					,0 detailId"
                    ,oc.originalPatientIdentifier enterprisePatientId
                    ,replace(s.currentPatientIdentifier, 'CO', '') patientPrimaryNumber
"					,oc.originalPatientIdentifier"
                    ,left(oc.patientSsn, 9) memberSsn
                    ,s.patientLastName  memberLastName
                    ,s.patientFirstName memberFirstName
                    ,s.patientMiddleName memberMiddleInitial
                    ,convert(varchar(10), s.patientBirthDate, 121)  memberBirthDate
                    ,convert(varchar(10), oc.patientDeathDate, 121)  memberDeathDate
                    ,oc.addressLine1 memberPrimaryAddressLine1
                    ,oc.addressLine2 memberPrimaryAddressLine2
                    ,oc.city memberPrimaryAddressCityName
                    ,oc.state memberPrimaryAddressStateCode
                    ,left(replace(oc.zip, '-', ''), 9) memberPrimaryAddressZipCode
                    ,case oc.patientGenderCode when 'M' then 'M' when 'F' then 'F' end memberGenderCode
                    ,left(isnull(rc.inValue, replace(oc.patientRaceCode, '~', '')), 1) memberRaceCode
                    ,case when s.currentPatientIdentifier like 'TEMP%' then 'CO'+ s.currentPatientIdentifier else 'CO'+ s.origTempPatientId end tempEnterprisePatientId
"	                ,'AI' maintenanceReasonCode"
"	                ,'030' maintenanceTypeCode"
                    ,isnull(case when s.currentPatientIdentifier like 'TEMP%' then 1 else s.isTemporaryMember end,  0) isTemporaryMember
"                    ,rank() over(partition by s.stageId order by s.createDateTime desc) rnk					"
"				    ,s.currentPatientIdentifier"
"					,s.origTempPatientId"
"				    ,s.mpiId"
"			        ,dense_rank() over(partition by s.origTempPatientId order by s.mpiId) +"
                     dense_rank() over(partition by s.origTempPatientId order by s.mpiId desc)
                     - 1 mpiCount
                from EdmStage.CO_MPI_History s
                join ##CO_temp_hist_originalAndCurrent oc on s.origTempPatientId = oc.origTempPatientId 
                                                         and s.mpiId = oc.mpiId 
                left join EdmLib.Mapping rc on oc.patientRaceCode = rc.outValue
                                           and rc.name = 'CO_RACE_CODE'
               where s.fileRequestId = @fileRequestId) x 
       where x.rnk = 1
      option (maxdop 1) ;

"	 insert into EdmStage.Colorado_Member     "
            (stageId 
            ,fileRequestId  
            ,enterprisePatientId
            ,enterpriseSubscriberId
            ,memberPrimaryId  
            ,memberPrimaryIdQualifier   
            ,memberSupplementalId
            ,memberSupplementalIdQualifier
            ,memberRelationshipCode  
            ,memberLastName  
            ,memberFirstname  
            ,memberMiddleName  
            ,memberBirthDate  
            ,memberDeathDate  
            ,memberGenderCode  
            ,memberRaceCode  
            ,memberAddressLine1  
            ,memberAddressLine2  
            ,memberCityName  
            ,memberStateCode  
            ,memberPostalZoneCode 
            ,memberMaintenanceReasonCode
            ,isTemporaryMember
            ,tempEnterprisePatientId) 
"	  select x.stageId"
            ,x.fileRequestId
            ,x.enterprisePatientId
"			,x.enterpriseSubscriberId"
            ,x.patientPrimaryNumber
"			,x.patientPrimaryNumberQualifier"
            ,x.memberSsn
"			,x.memberSupplementalIdQualifier4"
"			,x.relationshipCode"
            ,x.memberLastName
            ,x.memberFirstName
            ,x.memberMiddleInitial
            ,x.memberBirthDate
            ,x.memberDeathDate
            ,x.memberGenderCode
            ,x. memberRaceCode
            ,x.memberPrimaryAddressLine1
            ,x.memberPrimaryAddressLine2
            ,x.memberPrimaryAddressCityName
            ,x.memberPrimaryAddressStateCode
            ,x.memberPrimaryAddressZipCode
"	        ,x.maintenanceReasonCode"
            ,x.isTemporaryMember
"		   ,case when x.mpiCount > 1 or (x.patientPrimaryNumber like 'T%' and x.mpiCount=1) then 'CO'+ x.patientPrimaryNumber else 'CO'+ x.origTempPatientId end tempEnterprisePatientId"
"		from EdmStage.Colorado_Member_1 x"
      option (maxdop 1) ;

"--end ; 	1	2021-08-09 15:08:38.0466667	mssql"
"311	83	MPI-INSERT_BULK_REQUEST_STAGE	insert into MPI.BulkRequestStage "
       (BulkRequestStageId 
       ,ClientIdentifier 
       ,OriginalPatientIdentifier 
       ,CurrentPatientIdentifier 
       ,PolicyNumber 
       ,FirstName 
       ,MiddleName 
       ,LastName 
       ,SSN 
       ,DOB 
       ,Gender 
       ,AddressLine1 
       ,AddressLine2 
       ,City 
       ,State 
       ,ZIP 
       ,Telephone)
select m.stageId BulkRequestStageId
"	  ,c.clientCode ClientIdentifier "
      ,m.memberPrimaryId OriginalPatientIdentifier 
"	  ,null CurrentPatientIdentifier "
"	  ,m.memberPrimaryId PolicyNumber "
"	  ,isnull(m.memberFirstname, 'UNKNOWN') FirstName "
"	  ,null MiddleName "
"	  ,isnull(m.memberLastName, 'UNKNOWN') LastName "
"	  ,case when m.memberPrimaryIdQualifier = 'SY' and m.memberRelationshipCode = '18' then left(m.memberPrimaryId, 9)"
"	        when m.memberSupplementalIdQualifier = 'SY' then left(m.memberSupplementalId, 9) "
"	   end SSN"
"	  ,case when year(try_convert(datetime2, memberBirthDate)) > 1800 then left(m.memberBirthDate, 4) +'-'+ right(left(memberBirthDate, 6), 2) +'-'+ right(memberBirthDate, 2) + ' 00:00:00' end  DOB "
"	  ,isnull(m.memberGenderCode, 'U') Gender "
"	  ,m.memberAddressLine1 AddressLine1 "
"	  ,m.memberAddressLine2 AddressLine2 "
"	  ,m.memberCityName City "
"	  ,m.memberStateCode State "
"	  ,m.memberPostalZoneCode ZIP "
"	  ,null Telephone"
  from <tableSchema>.<tableName> m
  join EdmLib.FileRequest fr on fr.fileRequestId = :fileRequestId
  join Reference.Client c on fr.clientId = c.clientId
 where m.fileRequestId = :fileRequestId 
" ; 	1	2021-12-20 09:06:17.5500000	mssql"
"312	83	MPI-INSERT_MANUAL_MEMBERS	declare @fileRequestId bigint = :fileRequestId ;"

declare @maxId bigint ;
select @maxId = max(stageId)
  from EdmStage.Neca145_Member ;

insert into EdmStage.Neca145_Member 
      (stageId
      ,fileRequestId
      ,transactionSetCreationDateTime
      ,recordTypeCode
      ,subscriberPrimaryIdQualifier
      ,subscriberPrimaryId
      ,subscriberPrimaryIdExt
      ,subscriberSupplementalIdQualifier
      ,subscriberSupplementalId
      ,memberRelationshipCode
      ,memberPrimaryIdQualifier
      ,memberPrimaryId
      ,memberPrimaryIdExt
      ,memberSupplementalIdQualifier
      ,memberSupplementalId
      ,memberLastName
      ,memberFirstName
      ,memberMiddleName
      ,memberAddressLine1
      ,memberAddressLine2
      ,memberCityName
      ,memberCountyCode
      ,memberStateCode
      ,memberPostalZoneCode
      ,memberSecondaryAddressLine1
      ,memberSecondaryAddressLine2
      ,memberSecondaryCityName
      ,memberSecondaryCountyCode
      ,memberSecondaryStateCode
      ,memberSecondaryPostalZoneCode
      ,memberCommunicationNumberQualifierCodePrimaryTelephone
      ,memberPrimaryTelephoneNumber
      ,memberCommunicationNumberQualifierCodePrimaryEmail
      ,memberPrimaryEmail
      ,memberCommunicationNumberQualifierCodeSecondaryTelephone
      ,memberSecondaryTelephoneNumber
      ,memberCommunicationNumberQualifierCodeSecondaryEmail
      ,memberSecondaryEmail
      ,memberBirthDate
      ,memberDeathDate
      ,memberGenderCode
      ,memberRaceCode
      ,memberLanguageCode
      ,memberMultipleBirthSequenceNumber
      ,groupPolicyNumber
      ,groupPolicyName
      ,groupPolicyEffectiveDate
      ,groupPolicyExpirationDate
      ,groupPolicySectionNumer
      ,groupPolicyStateCode
      ,groupGenericManagedCare1Ind
      ,groupMedicareInd
      ,groupPaceInd
      ,groupPhysicalHealth1Nd
      ,groupSpiInd
      ,groupPayeeInd
      ,groupCustomerManagedCareInd1
      ,groupCustomerManagedCareInd2
      ,groupCustomerManagedCareInd3
      ,plan1Number
      ,plan1Name
      ,plan1Type
      ,plan1Desc
      ,plan1BeginDate
      ,plan1EndDate
      ,plan2Number
      ,plan2Name
      ,plan2Type
      ,plan2Desc
      ,plan2BeginDate
      ,plan2EndDate
      ,plan3Number
      ,plan3Name
      ,plan3Type
      ,plan3Desc
      ,plan3BeginDate
      ,plan3EndDate
      ,memberMaintenanceReasonCode
      ,memberPriorIdQualifier
      ,memberPriorId
      ,enterprisePatientId
      ,enterpriseSubscriberId)
select @maxId + row_number() over(partition by 1 order by p.patientId, e.eligibilityFactId) stageId 
      ,@fileRequestId fileRequestId
      ,p.transactionSetCreationDateTime
      ,p.recordTypeCode
      ,p.subscriberPrimaryNumberQualifier subscriberPrimaryIdQualifier
      ,p.subscriberPrimaryNumber subscriberPrimaryId
      ,null subscriberPrimaryIdExt
      ,null subscriberSupplementalIdQualifier
      ,null subscriberSupplementalId
      ,p.relationshipCode memberRelationshipCode
      ,p.patientPrimaryNumberQualifier memberPrimaryIdQualifier
      ,p.patientPrimaryNumber memberPrimaryId
      ,null memberPrimaryIdExt
      ,null memberSupplementalIdQualifier
      ,null memberSupplementalId
      ,p.patientLastName memberLastName
      ,p.patientFirstName memberFirstName
      ,p.patientMiddleName memberMiddleName
      ,a.addressLine1 memberAddressLine1
      ,a.addressLine2 memberAddressLine2
      ,a.city memberCityName
      ,a.county memberCountyCode
      ,a.state memberStateCode
      ,a.zip memberPostalZoneCode
      ,null memberSecondaryAddressLine1
      ,null memberSecondaryAddressLine2
      ,null memberSecondaryCityName
      ,null memberSecondaryCountyCode
      ,null memberSecondaryStateCode
      ,null memberSecondaryPostalZoneCode
      ,ph.communicationQualifierCode memberCommunicationNumberQualifierCodePrimaryTelephone
      ,ph.phoneNumber memberPrimaryTelephoneNumber
      ,em.communicationQualifierCode memberCommunicationNumberQualifierCodePrimaryEmail
      ,em.emailAddress memberPrimaryEmail
      ,null memberCommunicationNumberQualifierCodeSecondaryTelephone
      ,null memberSecondaryTelephoneNumber
      ,null memberCommunicationNumberQualifierCodeSecondaryEmail
      ,null memberSecondaryEmail
      ,convert(varchar(8), p.patientBirthDate, 112) memberBirthDate
      ,p.patientDeathDate memberDeathDate
      ,p.patientGenderCode memberGenderCode
      ,p.patientRaceCode memberRaceCode
      ,p.patientLanguageCode memberLanguageCode
      ,p.patientMultipleBirthSequenceNumber memberMultipleBirthSequenceNumber
      ,gp.groupPolicyNumber
      ,gp.groupPolicyName
      ,e.groupPolicyEffectiveDate
      ,e.groupPolicyExpirationDate
      ,null groupPolicySectionNumer
      ,null groupPolicyStateCode
      ,null groupGenericManagedCare1Ind
      ,null groupMedicareInd
      ,null groupPaceInd
      ,null groupPhysicalHealth1Nd
      ,null groupSpiInd
      ,null groupPayeeInd
      ,null groupCustomerManagedCareInd1
      ,null groupCustomerManagedCareInd2
      ,null groupCustomerManagedCareInd3
      ,pl.planNumber plan1Number
      ,null plan1Name
      ,null plan1Type
      ,null plan1Desc
      ,e.benefitPlanStartDate plan1BeginDate
      ,e.benefitPlanEndDate plan1EndDate
      ,null plan2Number
      ,null plan2Name
      ,null plan2Type
      ,null plan2Desc
      ,null plan2BeginDate
      ,null plan2EndDate
      ,null plan3Number
      ,null plan3Name
      ,null plan3Type
      ,null plan3Desc
      ,null plan3BeginDate
      ,null plan3EndDate
      ,p.patientMaintenaceReasonCode memberMaintenanceReasonCode
      ,null memberPriorIdQualifier
      ,null memberPriorId
"	   -- insert enterprise IDs as null"
"	   -- so records will go thru the MPI"
      ,null enterprisePatientId 
      ,null enterpriseSubscriberId
  from Patient.PatientDim p
  left join Patient.EligibilityFact e on p.clientId = e.clientId
                                     and p.patientId = e.patientId
"									 and e.eligibilityFactActiveFlag = 1"
  left join Reference.GroupPolicy gp on e.groupPolicyId = gp.groupPolicyId
  left join Reference.Plans pl on e.benefitPlanId = pl.plansId
  left join Patient.AddressDim a on p.clientId = a.clientId
                                and p.patientId = a.patientId
"								and a.activeFlag = 1"
  left join Patient.PhoneDim ph on p.clientId = ph.clientId
                               and p.patientId = ph.patientId
"							   and ph.activeFlag = 1"
  left join Patient.EmailDim em on p.clientId = em.clientId
                               and p.patientId = em.patientId
"							   and em.activeFlag = 1"
  join Reference.RecordType rt on p.recordTypeId = rt.recordTypeId
                              and rt.recordSourceId = 10 -- manual
 where p.clientId = 83
   and p.patientActiveFlag = 1
"   and p.createDateTime > dateadd(day, -60, sysdatetime()) ;	1	2021-12-20 09:08:12.6433333	mssql"
"313	83	NECA145_MEMBER_PREPROCESS	declare @fileRequestId bigint = :fileRequestId ;"

update edmStage.Neca145_Member
   set memberSsn = left(memberPrimaryId, 9)
 where memberRelationshipCode = '18'
   and memberSsn is null ;
 
update edmStage.Neca145_Member
   set memberSsn = left(memberSupplementalId, 9)
 where memberSupplementalIdQualifier = 'SY'
   and memberSsn is null ; 

update edmStage.Neca145_Member
   set transactionSetCreationDateTime =  left(transactionSetCreationDateTime, 4) +'-'+ right(left(transactionSetCreationDateTime, 6), 2) +'-'+ right(left(transactionSetCreationDateTime, 8), 2) +' '+right(transactionSetCreationDateTime, 8)
 where transactionSetCreationDateTime not like '%-%'
   and transactionSetCreationDateTime is not null ;

update edmStage.Neca145_Member
   set transactionSetCreationDateTime = replace(transactionSetCreationDateTime, ' ', 'T')
 where transactionSetCreationDateTime not like '%T%'
"   and transactionSetCreationDateTime like '% %' ;	1	2021-12-20 10:43:56.6666667	mssql"
"314	83	NECA145_MEMBER_UPDATE_SUBSCRIBER_INFO	declare @fileRequestId bigint = :fileRequestId ;"

declare @recordCount bigint ;
select @recordCount = clientModelRecordCount 
  from edmLib.fileRequest
 where fileRequestId = @fileRequestId ;

if (
select count(*)
from edmStage.Neca145_Member
 where enterprisePatientId is null ) > 0
 throw 51000, 'Unable to set enterpriseSubscriberId. Missing at least 1 enterprisePatientId.', 16 ;

with subscriberLinkList as (
select stageId
      ,case when len(subscriberPrimaryId)=9 then subscriberPrimaryId +'00'
            when memberPrimaryId like 'NKL%' and len(memberPrimaryId)=14 then left(memberPrimaryId,12) +'00'
            else subscriberPrimaryId 
"	   end subscriberPrimaryNumber"
  from edmStage.Neca145_Member
 where enterpriseSubscriberId is null ),
     subscriberLinkList2 as (
select distinct l.*, m.enterprisePatientId
  from subscriberLinkList l
  join edmStage.Neca145_Member m on l.subscriberPrimaryNumber = m.memberPrimaryId)
merge into edmStage.Neca145_Member m
using subscriberLinkList2 u on m.stageId = u.stageId
when matched then update set m.enterpriseSubscriberId = u.enterprisePatientId ;

if (
select count(*)
from edmStage.Neca145_Member
 where enterpriseSubscriberId is null 
   and stageId <= @recordCount) > 0
" throw 51000, 'Failed to set enterpriseSubscriberId.', 16 ;	1	2021-12-20 12:52:14.9566667	mssql"
"315	84	MPI-INSERT_MANUAL_MEMBERS	declare @fileRequestId bigint = :fileRequestId ;"

declare @maxId bigint ;
select @maxId = max(stageId)
  from EdmStage.Landscapes_Member ;

insert into EdmStage.Landscapes_Member 
      (stageId
      ,fileRequestId
      ,layoutName
      ,employeeCertificationNumber
      ,employeeCertificationSubNumber
      ,memberSequenceNumber
      ,crossReferenceEmployeeCertificationNumber
      ,crossReferenceEmployeeCertificationSubNumber
      ,dependentSsn
      ,groupNumber
      ,memberLastName
      ,memberFirstName
      ,memberMiddleInitial
      ,nameQualifier
      ,addressLine1
      ,addressLine2
      ,city
      ,stateOfResidence
      ,zipcode
      ,country
      ,phoneNumber
      ,emailAddress
      ,groupLocationCode
      ,startWorkDate
      ,medicareHicNumber
      ,hoursWorkedPerWeek
      ,workStatusCode
      ,memberDateOfBirth
      ,memberGender
      ,maritalStatus
      ,dependentStatusCode
      ,filler1
      ,groupEmployeeNumber
      ,workSiteCode
      ,workState
      ,originalEffectiveDateOfEmployee
      ,employeeDateOfBirth
      ,employeeGender
      ,customerReportingField1
      ,customerReportingField2
      ,customerReportingField3
      ,customerReportingField4
      ,customerReportingField5
      ,customerReportingField6
      ,customerReportingField7
      ,coverageTier
      ,umrPlanContractNumber
      ,lineOfCoverage
      ,classCode
      ,onlyAppliesToSupplementalLife
      ,effectiveDate
      ,terminationEndDate
      ,blockDate
      ,benefitPlan
      ,opi
      ,filler2
      ,effectiveStatusCode
      ,expirationStatusCode
      ,umrAssignedEmployeeNumber
      ,employeeSsn
      ,umrIdCardNumber
      ,umrIdCardType
      ,dependentStatusCodeChangeDate
      ,filler3
      ,tpaRoutingCode
      ,internalNetworkRoutingCode
      ,medicarePrimeIndicator
      ,medicarePrimeBeginDate
      ,medicarePrimeEndDate
      ,filler4
      ,enterprisePatientId
      ,enterpriseSubscriberId)
select @maxId + row_number() over(partition by 1 order by p.patientId, e.eligibilityFactId) stageId 
      ,@fileRequestId fileRequestId
      ,null layoutName
      ,null employeeCertificationNumber
      ,null employeeCertificationSubNumber
      ,null memberSequenceNumber
      ,null crossReferenceEmployeeCertificationNumber
      ,null crossReferenceEmployeeCertificationSubNumber
      ,p.patientSsn dependentSsn
      ,null groupNumber
      ,p.patientLastName memberLastName
      ,p.patientFirstName memberFirstName
      ,p.patientMiddleName memberMiddleInitial
      ,null nameQualifier
      ,a.addressLine1
      ,a.addressLine2
      ,a.city
      ,a.state stateOfResidence
      ,a.zip zipcode
      ,null country
      ,ph.phoneNumber
      ,em.emailAddress
      ,null groupLocationCode
      ,null startWorkDate
      ,null medicareHicNumber
      ,null hoursWorkedPerWeek
      ,null workStatusCode
      ,convert(varchar(8), p.patientBirthDate, 112) memberDateOfBirth
      ,p.patientGenderCode memberGender
      ,null maritalStatus
      ,rel.inValue dependentStatusCode
      ,null filler1
      ,null groupEmployeeNumber
      ,null workSiteCode
      ,null workState
      ,null originalEffectiveDateOfEmployee
      ,null employeeDateOfBirth
      ,null employeeGender
      ,null customerReportingField1
      ,null customerReportingField2
      ,null customerReportingField3
      ,null customerReportingField4
      ,null customerReportingField5
      ,null customerReportingField6
      ,null customerReportingField7
      ,null coverageTier
      ,null umrPlanContractNumber
      ,null lineOfCoverage
      ,null classCode
      ,null onlyAppliesToSupplementalLife
      ,null effectiveDate
      ,null terminationEndDate
      ,null blockDate
      ,null benefitPlan
      ,null opi
      ,null filler2
      ,null effectiveStatusCode
      ,null expirationStatusCode
      ,null umrAssignedEmployeeNumber
      ,null employeeSsn
      ,p.patientPrimaryNumber umrIdCardNumber
      ,null umrIdCardType
      ,null dependentStatusCodeChangeDate
      ,null filler3
      ,null tpaRoutingCode
      ,null internalNetworkRoutingCode
      ,null medicarePrimeIndicator
      ,null medicarePrimeBeginDate
      ,null medicarePrimeEndDate
      ,null filler4
"	   -- insert enterprise IDs as null"
"	   -- so records will go thru the MPI"
      ,null enterprisePatientId 
      ,null enterpriseSubscriberId
  from Patient.PatientDim p
  left join Patient.EligibilityFact e on p.clientId = e.clientId
                                     and p.patientId = e.patientId
"									 and e.eligibilityFactActiveFlag = 1"
  left join Reference.GroupPolicy gp on e.groupPolicyId = gp.groupPolicyId
  left join Reference.Plans pl on e.benefitPlanId = pl.plansId
  left join Patient.AddressDim a on p.clientId = a.clientId
                                and p.patientId = a.patientId
"								and a.activeFlag = 1"
  left join Patient.PhoneDim ph on p.clientId = ph.clientId
                               and p.patientId = ph.patientId
"							   and ph.activeFlag = 1"
  left join Patient.EmailDim em on p.clientId = em.clientId
                               and p.patientId = em.patientId
"							   and em.activeFlag = 1"
  join Reference.RecordType rt on p.recordTypeId = rt.recordTypeId
                              and rt.recordSourceId = 10 -- manual
  left join EdmLib.Mapping rel on p.relationshipCode = rel.outValue
                              and rel.name = 'LANDSCAPES_RELATION_CODE'
 where p.clientId = 84
   and p.patientActiveFlag = 1
"   and p.createDateTime > dateadd(day, -60, sysdatetime()) ;	1	2021-12-20 13:22:32.6733333	mssql"
"316	84	MPI-INSERT_BULK_REQUEST_STAGE	insert into MPI.BulkRequestStage "
       (BulkRequestStageId 
       ,ClientIdentifier 
       ,OriginalPatientIdentifier 
       ,CurrentPatientIdentifier 
       ,PolicyNumber 
       ,FirstName 
       ,MiddleName 
       ,LastName 
       ,SSN 
       ,DOB 
       ,Gender 
       ,AddressLine1 
       ,AddressLine2 
       ,City 
       ,State 
       ,ZIP 
       ,Telephone)
select m.stageId BulkRequestStageId
"	  ,c.clientCode ClientIdentifier "
      ,m.umrIdCardNumber + isnull(m.memberSequenceNumber, '') OriginalPatientIdentifier 
"	  ,null CurrentPatientIdentifier "
"	  ,m.umrIdCardNumber + isnull(m.memberSequenceNumber, '') PolicyNumber "
"	  ,isnull(m.memberFirstname, 'UNKNOWN') FirstName "
"	  ,null MiddleName "
"	  ,isnull(m.memberLastName, 'UNKNOWN') LastName "
"	  ,isnull(m.dependentSsn, case when m.memberSequenceNumber ='00' then m.employeeSsn end) SSN"
"	  ,case when year(try_convert(datetime2, memberDateOfBirth)) > 1800 then left(m.memberDateOfBirth, 4) +'-'+ right(left(memberDateOfBirth, 6), 2) +'-'+ right(memberDateOfBirth, 2) + ' 00:00:00' end  DOB "
"	  ,isnull(m.memberGender, 'U') Gender "
"	  ,m.addressLine1 AddressLine1 "
"	  ,m.addressLine2 AddressLine2 "
"	  ,m.city City "
"	  ,m.stateOfResidence State "
"	  ,m.zipcode ZIP "
"	  ,null Telephone"
  from <tableSchema>.<tableName> m
  join EdmLib.FileRequest fr on fr.fileRequestId = :fileRequestId
  join Reference.Client c on fr.clientId = c.clientId
 where m.fileRequestId = :fileRequestId 
" ; 	1	2021-12-20 13:22:49.5166667	mssql"
"317	84	Landscapes_MEMBER_UPDATE_SUBSCRIBER_INFO	declare @fileRequestId bigint = :fileRequestId ;"

if (
select count(*)
from edmStage.Landscapes_Member
 where enterprisePatientId is null ) > 0
 throw 51000, 'Unable to set enterpriseSubscriberId. Missing at least 1 enterprisePatientId.', 16 ;

with subscriberLinkList as (
select stageId, umrIdCardNumber +'00' subscriberPrimaryNumber
  from edmStage.Landscapes_Member
 where enterpriseSubscriberId is null ),
     subscriberLinkList2 as (
select distinct l.*, m.enterprisePatientId
  from subscriberLinkList l
  join edmStage.Landscapes_Member m on l.subscriberPrimaryNumber = m.umrIdCardNumber + m.memberSequenceNumber)
merge into edmStage.Landscapes_Member m
using subscriberLinkList2 u on m.stageId = u.stageId
when matched then update set m.enterpriseSubscriberId = u.enterprisePatientId ; 

if (
select count(*)
from edmStage.Landscapes_Member
 where enterpriseSubscriberId is null ) > 0
" throw 51000, 'Failed to set enterpriseSubscriberId.', 16 ;	1	2021-12-20 13:23:12.5533333	mssql"
"318	84	MPI-DUPLICATE_MPI_COUNT	 select count(*)"
  from (select enterprisePatientId
              ,count(*) recordCount
                  ,string_agg(isnull(m.dependentSsn, case when m.memberSequenceNumber ='00' then m.employeeSsn end), ', ') within group (order by m.stageId) patientSsnList
                  ,count(distinct isnull(m.dependentSsn, case when m.memberSequenceNumber ='00' then m.employeeSsn end)) patientSsnCount
                  ,string_agg(m.memberDateOfBirth, ', ') within group (order by m.stageId) birthDateList
                  ,count(distinct memberDateOfBirth) birthDateCount
                  ,string_agg(m.memberGender, ', ')  within group (order by m.stageId) genderList
                  ,count(distinct memberGender) genderCount
                  ,max(fileRequestId) fileRequestId
                  ,string_agg(m.stageId, ', ') within group (order by m.stageId) stageIdList
          from EdmStage.Landscapes_Member m
         group by m.enterprisePatientId
        having count(distinct isnull(m.dependentSsn, case when m.memberSequenceNumber ='00' then m.employeeSsn end)) > 1
            or count(distinct m.memberDateOfBirth) > 1
"            or count(distinct m.memberGender) > 1) x	1	2021-12-20 14:23:53.1366667	mssql"
"319	75	EWTF_CLAIM_REFERRAL_PROCESS_PREP-STEP-01-MEDICAL-02-inOutInd	declare @fileRequestId bigint = :fileRequestId ; -- 89883"

declare @placeOfServiceCodeList_inpatient
  table (placeOfServiceCode nvarchar(10)) ;

insert into @placeOfServiceCodeList_inpatient
values ('21')
      ,('31')
"	  ,('32')"
"	  ,('51')"
"	  ,('54')"
"	  ,('55')"
"	  ,('56')"
"	  ,('61') ;"
"	"
declare @placeOfServiceCodeList_outpatient
  table (placeOfServiceCode nvarchar(10)) ;

insert into @placeOfServiceCodeList_outpatient
values ('02'), ('2')
"	  ,('03'), ('3')"
"	  ,('04'), ('4')"
"	  ,('05'), ('5')"
"	  ,('06'), ('6')"
"	  ,('07'), ('7')"
"	  ,('08'), ('8')"
"	  ,('11')"
"	  ,('12')"
"	  ,('13')"
"	  ,('14')"
"	  ,('15')"
"	  ,('16')"
"	  ,('17')"
"	  ,('18')"
"	  ,('19')"
"	  ,('20')"
"	  ,('22')"
"	  ,('24')"
"	  ,('33')"
"	  ,('49')"
"	  ,('52')"
"	  ,('53')"
"	  ,('57')"
"	  ,('58')"
"	  ,('62')"
"	  ,('65')"
"	  ,('71')"
"	  ,('72') ;"

/*
select case when t.placeOfServiceCode = x.placeOfServiceCode then 'I' end
      ,count(*)
  from EdmStage.EWTF_MedicalClaimHistory_stage_temp t 
  left join EdmReference.ClaimValueSet rev on isnull(t.revenueCode,' ') = rev.code 
                                           and rev.inOutInd = 'I' 
"										   and rev.codeSystem = 'UBREV' "
"										   and rev.activeFlag = 1"
  left join EdmReference.ClaimValueSet prc on t.procedureValue1  = prc.code
                                          and prc.InOutInd = 'I' 
"										  and prc.CodeSystem in ('CPT','HCPCS')"
"										  and prc.activeFlag = 1"
  left join @placeOfServiceCodeList_inpatient x on t.placeOfServiceCode = x.placeOfServiceCode
 where t.placeOfServiceCode <> '34' -- exclude Hospice
   and (rev.code is not null or prc.code is not null or x.placeOfServiceCode is not null) 
 group by case when t.placeOfServiceCode = x.placeOfServiceCode then 'I' end ;

select case when t.placeOfServiceCode = x.placeOfServiceCode then 'O' end
,count(*)
  from EdmStage.EWTF_MedicalClaimHistory_stage_temp t  
  left join EdmReference.ClaimValueSet rev on isnull(t.revenueCode,' ') = rev.code 
                                           and rev.inOutInd = 'O' 
"										   and rev.codeSystem = 'UBREV' "
"										   and rev.activeFlag = 1"
  left join EdmReference.ClaimValueSet prc on t.procedureValue1  = prc.code
                                          and prc.InOutInd = 'O' 
"										  and prc.CodeSystem in ('CPT','HCPCS')"
"										  and prc.activeFlag = 1"
  left join @placeOfServiceCodeList_outpatient x on t.placeOfServiceCode = x.placeOfServiceCode
 where t.placeOfServiceCode <> '34' -- exclude Hospice
   and (rev.code is not null or prc.code is not null or x.placeOfServiceCode is not null) 
 group by case when t.placeOfServiceCode = x.placeOfServiceCode then 'O' end ;
*/

-- drop table if exists EdmStage.EWTF_MedicalClaimHistory_stage ;
truncate table EdmStage.EWTF_MedicalClaimHistory_stage ;

insert into EdmStage.EWTF_MedicalClaimHistory_stage 
select t.*
      ,'I' inOutInd
"	  ,row_number() over(partition by t.originalFileRequestId, t.originalStageId, t.procedureNumber order by t.originalStageId) rnk"
#NAME?
  from EdmStage.EWTF_MedicalClaimHistory_stage_temp t 
  left join EdmReference.ClaimValueSet rev on isnull(t.revenueCode,' ') = rev.code 
                                           and rev.inOutInd = 'I' 
"										   and rev.codeSystem = 'UBREV' "
"										   and rev.activeFlag = 1"
  left join EdmReference.ClaimValueSet prc on t.procedureValue1  = prc.code
                                          and prc.InOutInd = 'I' 
"										  and prc.CodeSystem in ('CPT','HCPCS')"
"										  and prc.activeFlag = 1"
  left join @placeOfServiceCodeList_inpatient x on t.placeOfServiceCode = x.placeOfServiceCode
 where t.placeOfServiceCode <> '34' -- exclude Hospice
   and (rev.code is not null 
     or prc.code is not null 
"	 or x.placeOfServiceCode is not null) "
 union all 
select t.*
      ,'O' inOutInd
"	  ,row_number() over(partition by t.originalFileRequestId, t.originalStageId, t.procedureNumber order by t.originalStageId) rnk"
  from EdmStage.EWTF_MedicalClaimHistory_stage_temp t  
  left join EdmReference.ClaimValueSet rev on isnull(t.revenueCode,' ') = rev.code 
                                           and rev.inOutInd = 'O' 
"										   and rev.codeSystem = 'UBREV' "
"										   and rev.activeFlag = 1"
  left join EdmReference.ClaimValueSet prc on t.procedureValue1  = prc.code
                                          and prc.InOutInd = 'O' 
"										  and prc.CodeSystem in ('CPT','HCPCS')"
"										  and prc.activeFlag = 1"
  left join @placeOfServiceCodeList_outpatient x on t.placeOfServiceCode = x.placeOfServiceCode
 where t.placeOfServiceCode <> '34' -- exclude Hospice
   and (rev.code is not null 
     or prc.code is not null 
"	 or x.placeOfServiceCode is not null) ;"

insert into EdmStage.EWTF_MedicalClaimHistory_stage 
select t.*
      ,'U' inOutInd
"	  ,row_number() over(partition by t.originalFileRequestId, t.originalStageId, t.procedureNumber order by t.originalStageId) rnk"
  from EdmStage.EWTF_MedicalClaimHistory_stage_temp t  
  left join EdmStage.EWTF_MedicalClaimHistory_stage s on t.originalFileRequestId = s.originalFileRequestId
                                                     and t.originalStageId = s.originalStageId 
" where s.originalStageId is null ; 	1	2022-01-04 16:25:50.2033333	mssql"
"320	75	EWTF_CLAIM_REFERRAL_PROCESS_PREP-STEP-01-MEDICAL-03-Stage-Dedup	declare @fileRequestId bigint = :fileRequestId ; -- 89883"

--drop table if exists EdmStage.EWTF_MedicalClaimHistory_stage_dedup ;
truncate table EdmStage.EWTF_MedicalClaimHistory_stage_dedup ;

insert into EdmStage.EWTF_MedicalClaimHistory_stage_dedup
select *
#NAME?
  from EdmStage.EWTF_MedicalClaimHistory_stage
" where rnk = 1 ;	1	2022-01-04 16:26:00.4566667	mssql"
"321	75	EWTF_CLAIM_REFERRAL_PROCESS_PREP-STEP-01-MEDICAL-04-Dedup	declare @fileRequestId bigint = :fileRequestId ; -- 91792 ; "

alter sequence EdmReferral.MedicalClaim_RawHistorySeq restart with 10 ;

insert into EdmReferral.MedicalClaim_RawHistory
      (clientId
      ,fileRequestId
      ,originalFileRequestId
      ,originalStageId
      ,groupNumber
      ,claimNumber
      ,lineNumber
      ,fromDate
      ,thruDate
      ,issuedDate
      ,subscriberSSN
      ,alternateId
      ,patientFullName
      ,patientFirstName
      ,patientLastName
      ,patientGender
      ,patientDOB
      ,patientSSN
      ,dependentId
      ,revenueCode
      ,diagnosisCodePrimary
      ,diagnosisCode2
      ,diagnosisCode3
      ,diagnosisCode4
      ,billedAmount
      ,allowedAmount
      ,deductibleAnnual
      ,coinsurance
      ,deductibleCopay
      ,paidAmount
      ,cobSave
      ,placeOfServiceCode
      ,typeOfService
      ,paidThruDate
      ,serviceProviderNpi
      ,serviceProviderName
      ,provider
      ,providerAddress1
      ,providerAddress2
      ,providerAddress3
      ,providerCity
      ,providerState
      ,providerZipCode
      ,paidDate
      ,claimType
      ,procedureCode
      ,modifierCode1
      ,modifierCode2
      ,modifierCode3
      ,modifierCode4
      ,ppoCode
      ,quantity
      ,inOutInd
      ,enterprisePatientId
      ,patientPrimaryNumber
      ,patientPrimaryNumberQualifier
      ,enterpriseSubscriberId
      ,subscriberPrimaryNumber
      ,subscriberPrimaryNumberQualifier
      ,hasError)
select clientId
      ,fileRequestId
      ,originalFileRequestId
      ,originalStageId
      ,groupNumber
      ,claimNumber
      ,lineNumber
      ,fromDate
      ,thruDate
      ,issuedDate
      ,subscriberSSN
      ,alternateId
      ,patientFullName
      ,patientFirstName
      ,patientLastName
      ,patientGender
      ,patientDOB
      ,patientSSN
      ,dependentId
      ,revenueCode
      ,diagnosisCodePrimary
      ,diagnosisCode2
      ,diagnosisCode3
      ,diagnosisCode4
      ,billedAmount
      ,allowedAmount
      ,deductibleAnnual
      ,coinsurance
      ,deductibleCopay
      ,paidAmount
      ,cobSave
      ,placeOfServiceCode
      ,typeOfService
      ,paidThruDate
      ,serviceProviderNpi
      ,serviceProviderName
      ,provider
      ,providerAddress1
      ,providerAddress2
      ,providerAddress3
      ,providerCity
      ,providerState
      ,providerZipCode
      ,paidDate
      ,claimType
      ,procedureCode
      ,modifierCode1
      ,modifierCode2
      ,modifierCode3
      ,modifierCode4
      ,ppoCode
      ,quantity
      ,inOutInd
      ,enterprisePatientId
      ,patientPrimaryNumber
      ,patientPrimaryNumberQualifier
      ,enterpriseSubscriberId
      ,subscriberPrimaryNumber
      ,subscriberPrimaryNumberQualifier
      ,hasError
  from (select clientId
              ,clientCode
              ,fileRequestId
              ,originalFileRequestId
              ,originalStageId
              ,groupNumber
              ,claimNumber
              ,lineNumber
              ,case when patindex('%[0-9][/]%[0-9][/][0-9][0-9][0-9][0-9]%', fromDate) > 0 then convert(varchar(10), convert(date, fromDate), 23)
"			        else fromDate"
"			   end fromDate"
              ,case when patindex('%[0-9][/]%[0-9][/][0-9][0-9][0-9][0-9]%', thruDate) > 0 then convert(varchar(10), convert(date, thruDate), 23)
"			        else thruDate"
"			   end thruDate"
              ,case when patindex('%[0-9][/]%[0-9][/][0-9][0-9][0-9][0-9]%', issuedDate) > 0 then convert(varchar(10), convert(date, issuedDate), 23)
"			        else issuedDate"
"			   end issuedDate"
              ,subscriberSSN
              ,alternateId
              ,patientFullName
              ,patientFirstName
              ,patientLastName
"              ,patientGender			  "
              ,case when patindex('%[0-9][/]%[0-9][/][0-9][0-9][0-9][0-9]%', patientDOB) > 0 then convert(varchar(10), convert(date, patientDOB), 23)
"			        else patientDOB"
"			   end patientDOB"
              ,patientSSN
              ,dependentId
              ,revenueCode
              ,diagnosisCodePrimary
              ,diagnosisCode2
              ,diagnosisCode3
              ,diagnosisCode4
              ,billedAmount
              ,allowedAmount
              ,deductibleAnnual
              ,coinsurance
              ,deductibleCopay
              ,paidAmount
              ,cobSave
              ,placeOfServiceCode
"              ,typeOfService			  		  "
              ,case when patindex('%[0-9][/]%[0-9][/][0-9][0-9][0-9][0-9]%', paidThruDate) > 0 then convert(varchar(10), convert(date, paidThruDate), 23)
"			        else paidThruDate"
"			   end paidThruDate"
              ,serviceProviderNpi
              ,serviceProviderName
              ,provider
              ,providerAddress1
              ,providerAddress2
              ,providerAddress3
              ,providerCity
              ,providerState
"              ,providerZipCode			  			  		  "
              ,case when patindex('%[0-9][/]%[0-9][/][0-9][0-9][0-9][0-9]%', paidDate) > 0 then convert(varchar(10), convert(date, paidDate), 23)
"			        else paidDate"
"			   end paidDate"
              ,claimType
              ,max(case when procedureNumber = 1 then procedureValue end) over(partition by originalStageId, originalFileRequestId) procedureCode
              ,max(case when procedureNumber = 2 then procedureValue end) over(partition by originalStageId, originalFileRequestId) modifierCode1
              ,max(case when procedureNumber = 3 then procedureValue end) over(partition by originalStageId, originalFileRequestId) modifierCode2
              ,max(case when procedureNumber = 4 then procedureValue end) over(partition by originalStageId, originalFileRequestId) modifierCode3
              ,max(case when procedureNumber = 5 then procedureValue end) over(partition by originalStageId, originalFileRequestId) modifierCode4
              ,ppoCode
              ,quantity
              ,inOutInd
              ,enterprisePatientId
              ,patientPrimaryNumber
              ,patientPrimaryNumberQualifier
              ,enterpriseSubscriberId
              ,subscriberPrimaryNumber
              ,subscriberPrimaryNumberQualifier
              ,hasError
              ,row_number() over(partition by originalStageId, originalFileRequestId, inOutInd order by originalStageId) rnk 
          from EdmStage.EWTF_MedicalClaimHistory_stage_dedup) x0 
" where rnk = 1 ;	1	2022-01-04 16:26:07.9266667	mssql"
"322	0	EDM_CLAIM_REFERRAL_PROCESS-CM-STEP-0000-PREP-02-MEDICAL-INP-STAY-LIST	declare @fileRequestId bigint = :fileRequestId ;"

declare @clientId int ;
declare @clientCode nvarchar(20) ;

select @clientId = r.clientId
      ,@clientCode = c.clientCode
  from EdmLib.FileRequest r
  join Reference.Client c on r.clientId = c.clientId
 where fileRequestId = @fileRequestId ;

drop table if exists EdmReferral.InpatientClaimStay_stage ;

select clientId
      ,@clientCode clientCode
      ,fileRequestId
      ,originalFileRequestId
      ,originalStageId
      ,row_number() over(partition by dependentId order by fromDate, thruDate desc) claimRowId
      ,patientPrimaryNumber
      ,enterprisePatientId
      ,claimNumber
      ,fromDate
      ,thruDate
      ,subscriberSSN
      ,dependentId
      ,patientSSN
      ,patientDOB
      ,patientFullName
      ,patientFirstName
      ,patientLastName
      ,patientGender
      ,serviceProviderNpi
      ,serviceProviderName
      ,placeOfServiceCode
      ,diagnosisCodePrimary
      ,procedureCode
      ,modifierCode1
      ,modifierCode2
      ,modifierCode3
      ,modifierCode4
      ,allowedAmount
      ,paidAmount
  into EdmReferral.InpatientClaimStay_stage
  from EdmReferral.MedicalClaim_RawHistory
 where clientId = @clientId
   and inOutInd = 'I' ;

drop table if exists EdmReferral.InpatientClaimStay_stage_hiera ;

#NAME?
with inpatientStayList as
    (select clientId
           ,clientCode
           ,fileRequestId
           ,originalFileRequestId
           ,originalStageId
           ,claimRowId
           ,claimNumber
           ,fromDate parentFromDate
           ,thruDate parentThruDate
           ,fromDate
           ,thruDate
           ,try_convert(varchar(100), patientPrimaryNumber) patientPrimaryNumber
           ,try_convert(varchar(100), enterprisePatientId ) enterprisePatientId
           ,subscriberSSN
           ,dependentId
           ,patientSSN
           ,patientDOB
           ,patientFullName
           ,patientFirstName
           ,patientLastName
           ,patientGender
           ,try_convert(varchar(20),  serviceProviderNpi) serviceProviderNpi
           ,try_convert(varchar(100), serviceProviderName) serviceProviderName
           ,try_convert(varchar(10),  placeOfServiceCode) placeOfServiceCode
           ,try_convert(varchar(10),  diagnosisCodePrimary) diagnosisCodePrimary
           ,try_convert(varchar(10),  procedureCode) procedureCode
           ,try_convert(varchar(5),   modifierCode1) modifierCode1
           ,try_convert(varchar(5),   modifierCode2) modifierCode2
           ,try_convert(varchar(5),   modifierCode3) modifierCode3
           ,try_convert(varchar(5),   modifierCode4) modifierCode4
           ,try_convert(varchar(20),  allowedAmount) allowedAmount
           ,try_convert(varchar(20),  paidAmount) paidAmount
       from EdmReferral.InpatientClaimStay_stage
      where claimRowId = 1
      union all
     select c.clientId
           ,c.clientCode
           ,c.fileRequestId
           ,c.originalFileRequestId
           ,c.originalStageId
           ,c.claimRowId
           ,c.claimNumber
           ,case when p.thruDate = c.fromDate                         then p.parentFromDate
                 when p.fromDate = dateadd(day, -1, c.fromDate)       then p.parentFromDate
                 when p.thruDate = dateadd(day, -1, c.fromDate)       then p.parentFromDate
                 when p.thruDate = dateadd(day, 1, c.fromDate)        then p.parentFromDate
                 when p.parentThruDate = dateadd(day, 1, c.fromDate)  then p.parentFromDate
                 when p.parentThruDate = dateadd(day, -1, c.fromDate) then p.parentFromDate
                 when c.thruDate between dateadd(day, -1, p.parentFromDate) and dateadd(day, 2, p.parentThruDate) then p.parentFromDate
                 when c.fromDate between dateadd(day, -1, p.parentFromDate) and dateadd(day, 2, p.parentThruDate) then p.parentFromDate
                 else c.fromDate
            end parentFromDate
          ,case when p.parentThruDate >= c.fromDate and  p.parentThruDate < c.thruDate then c.thruDate
                when c.fromDate between p.parentFromDate AND p.parentThruDate then p.parentThruDate
                when c.thruDate between p.parentFromDate AND p.parentThruDate then p.parentThruDate
           else c.thruDate
           end parentThruDate
          ,c.fromDate
          ,c.thruDate
          ,p.patientPrimaryNumber
          ,p.enterprisePatientId
          ,c.subscriberSSN
          ,c.dependentId
          ,c.patientSSN
          ,c.patientDOB
          ,c.patientFullName
          ,c.patientFirstName
          ,c.patientLastName
          ,c.patientGender
          ,p.serviceProviderNpi
          ,p.serviceProviderName
          ,p.placeOfServiceCode
          ,p.diagnosisCodePrimary
          ,p.procedureCode
          ,p.modifierCode1
          ,p.modifierCode2
          ,p.modifierCode3
          ,p.modifierCode4
          ,p.allowedAmount
          ,p.paidAmount
      from EdmReferral.InpatientClaimStay_stage c
      join inpatientStayList p on c.dependentId = p.dependentId
                              and c.claimRowId = p.claimRowId + 1 )
select *
  into EdmReferral.InpatientClaimStay_stage_hiera
  from inpatientStayList
option (maxrecursion 32767)  ;

drop table if exists EdmReferral.InpatientClaimStay_stage_hiera_rnk ;

select t.*
      ,row_number() over(partition by t.dependentId, t.parentFromDate order by t.thruDate desc) rn
 into EdmReferral.InpatientClaimStay_stage_hiera_rnk
 from EdmReferral.InpatientClaimStay_stage_hiera t ;

/*
select *
  from EdmReferral.InpatientClaimStay_stage_hiera_rnk ;

truncate table EdmReferral.InpatientClaimStay ;
*/

insert into EdmReferral.InpatientClaimStay
(clientId
,clientCode
,stageId
,fileRequestId
,originalFileRequestId
,originalStageId
,claimRowId
,claimNumber
,parentFromDate
,parentThruDate
,fromDate
,thruDate
,patientPrimaryNumber
,enterprisePatientId
,subscriberSSN
,dependentId
,patientSSN
,patientDOB
,patientFullName
,patientFirstName
,patientLastName
,patientGenderCode
,serviceProviderNpi
,serviceProviderName
,placeOfServiceCode
,diagnosisCodePrimary
,procedureCode
,modifierCode1
,modifierCode2
,modifierCode3
,modifierCode4
,allowedAmount
,paidAmount
,inpatientStayCount)
select clientId
      ,clientCode
      ,row_number() over(partition by 1 order by originalStageId) stageId
      ,fileRequestId
      ,originalFileRequestId
      ,originalStageId
      ,claimRowId
      ,claimNumber
      ,parentFromDate
      ,parentThruDate
      ,fromDate
      ,thruDate
      ,patientPrimaryNumber
      ,enterprisePatientId
      ,subscriberSSN
      ,dependentId
      ,patientSSN
      ,patientDOB
      ,patientFullName
      ,patientFirstName
      ,patientLastName
      ,patientGender
      ,serviceProviderNpi
      ,serviceProviderName
      ,placeOfServiceCode
      ,diagnosisCodePrimary
      ,procedureCode
      ,modifierCode1
      ,modifierCode2
      ,modifierCode3
      ,modifierCode4
      ,allowedAmount
      ,paidAmount
      ,dense_rank() over(partition by dependentId order by parentFromDate)
       + dense_rank() over(partition by dependentId order by parentFromDate desc)
       - 1 inpatientStayCount
  from EdmReferral.InpatientClaimStay_stage_hiera_rnk
" where rn = 1 ;	1	2022-01-13 13:07:51.0366667	mssql"
"323	0	EDM_CLAIM_REFERRAL_PROCESS-CM-STEP-9999-FINALIZE_FINAL	declare @fileRequestId bigint = :fileRequestId ;"

declare @clientId int ;
select @clientId = clientId
  from EdmLib.FileRequest 
 where fileRequestId = @fileRequestId ;

insert into EdmReferral.ClaimReferralFinal
      (fileRequestId
      ,clientId
      ,clientCode
      ,criteriaMet
      ,selectionReason
      ,moduleCode
      ,serviceCode
      ,serviceCodeRank
"	  ,criteriaMetCount"
      ,patientPrimaryNumber
      ,enterprisePatientId
      ,subscriberSSN
      ,dependentId
      ,patientSSN
      ,patientDOB
      ,patientFullName
      ,patientFirstName
      ,patientMiddleName
      ,patientLastName
      ,patientGenderCode
      ,patientRelationshipCode
"	  ,error)"
select fileRequestId
      ,clientId
      ,clientCode
      ,criteriaMet
      ,selectionReason
      ,moduleCode
      ,serviceCode
      ,serviceCodeRank
"	  ,criteriaMetCount"
      ,patientPrimaryNumber
      ,enterprisePatientId
      ,subscriberSSN
      ,dependentId
      ,patientSSN
      ,patientDOB
      ,patientFullName
      ,patientFirstName
      ,patientMiddleName
      ,patientLastName
      ,patientGenderCode
      ,patientRelationshipCode
"	  ,0 error"
  from (select *
              ,row_number() over(partition by dependentId order by criteriaMetCount desc, serviceCodeRank) rn
          from EdmReferral.ClaimReferralStage
"		 where clientId = @clientId) x"
" where x.rn = 1 ; 	1	2022-01-31 09:15:39.5566667	mssql"
"324	84	ARCHIVE-ALL_CLAIM	declare @fileRequestId bigint = :fileRequestId ;"

insert into EdmStage.Landscapes_Medical_History
select *
  from EdmStage.Landscapes_Medical
" where fileRequestId = @fileRequestId ;	1	2022-01-31 15:33:55.0733333	mssql"
"325	84	ARCHIVE-PHARMACY_CLAIM	declare @fileRequestId bigint = :fileRequestId ;"

insert into EdmStage.Landscapes_RX_History
select *
  from EdmStage.Landscapes_RX
" where fileRequestId = @fileRequestId ;	1	2022-01-31 15:34:06.5566667	mssql"
"326	39	ARCHIVE-DRG	declare @fileRequestId bigint = :fileRequestId ;"

if (
SELECT count(*) 
  FROM sys.partition_range_values
 WHERE value = @fileRequestId
   AND function_id = (SELECT function_id as int FROM sys.partition_functions WHERE name = 'ID_ClaimsDrgHistoryPfunc') 
) = 0 and
@fileRequestId > 0
begin
"	ALTER PARTITION SCHEME ID_ClaimsDrgHistoryPscheme NEXT USED [PRIMARY]"
"	ALTER PARTITION FUNCTION ID_ClaimsDrgHistoryPfunc() SPLIT RANGE (@fileRequestId)"
end ;

truncate table EdmStage.ID_ClaimsDrgHistory with (partitions($partition.ID_ClaimsDrgHistoryPfunc(@fileRequestId))) ;

insert into EdmStage.ID_ClaimsDrgHistory
select *
"  from EdmStage.ID_ClaimsDrg ;	1	2022-03-10 14:21:25.5633333	mssql"
"327	76	EDM_STANDARD_MPI-DUPLICATE_MPI_COUNT	select count(*)"
  from (select enterprisePatientId
              ,count(*) recordCount
"	          ,string_agg(m.memberBirthDate, ', ') within group (order by m.memberPrimaryId) birthDateList"
"	          ,count(distinct memberBirthDate) birthDateCount"
"	          ,string_agg(m.memberGenderCode, ', ')  within group (order by m.memberPrimaryId) genderList"
"	          ,count(distinct memberGenderCode) genderCount"
"	          ,max(fileRequestId) fileRequestId"
"	          ,string_agg(m.stageId, ', ') within group (order by m.memberPrimaryId) stageIdList"
          from EdmStage.IronRoad_Member m
         group by m.enterprisePatientId
        having (count(distinct m.memberPrimaryId) > 1 and count(distinct m.memberLastName) > 1 and count(distinct m.memberFirstname) > 1)
            or count(distinct m.memberBirthDate) > 1
"            or count(distinct m.memberGenderCode) > 1) x ;	1	2022-07-01 11:43:52.4500000	mssql"
"328	34	MEMBER-EXCLUDE_MEMBERS	alter table EdmStage.COC_MemberExcluded alter column originalStageId bigint null ;"

insert into EdmStage.COC_MemberExcluded
select m.stageId
      ,m.fileRequestId
      ,m.policySource
      ,m.policyGroup
      ,m.section
      ,m.filler
      ,m.subscriberSsn
      ,m.lastName
      ,m.firstName
      ,m.relationship
      ,m.gender
      ,m.filler2
      ,m.patientSsn
      ,m.birthdate
      ,m.startDate
      ,m.endDate
      ,m.addressLine1
      ,m.addressLine2
      ,m.city
      ,m.state
      ,m.zip
      ,m.medicarePrimary
      ,m.student
      ,m.filler3
      ,m.special
      ,m.filler4
      ,m.policyNumber
      ,m.enterprisePatientId
      ,m.enterpriseSubscriberId
      ,m.subscriberPrimaryNumber
      ,m.tempEnterprisePatientId
      ,m.isTemporaryMember
      ,m.maintenanceTypeCode
      ,m.retireRuleNumber
"	  ,isnull(m.originalStageId, m.stageId)"
"	  ,sysdatetime()"
  from EdmStage.COC_Member m
  join EdmStage.COC_MemberExclusion e
"    on m.subscriberSsn	= e.subscriberSsn"
"   and m.lastName	 	= e.lastName	 "
"   and m.firstName	 	= e.firstName	 "
"   and m.relationship 	= e.relationship ;"

drop table if exists EdmStage.COC_Member_temp ;

select row_number() over(partition by 1 order by m.stageId) stageId
      ,m.fileRequestId
      ,m.policySource
      ,m.policyGroup
      ,m.section
      ,m.filler
      ,m.subscriberSsn
      ,m.lastName
      ,m.firstName
      ,m.relationship
      ,m.gender
      ,m.filler2
      ,m.patientSsn
      ,m.birthdate
      ,m.startDate
      ,m.endDate
      ,m.addressLine1
      ,m.addressLine2
      ,m.city
      ,m.state
      ,m.zip
      ,m.medicarePrimary
      ,m.student
      ,m.filler3
      ,m.special
      ,m.filler4
      ,m.policyNumber
      ,m.enterprisePatientId
      ,m.enterpriseSubscriberId
      ,m.subscriberPrimaryNumber
      ,m.tempEnterprisePatientId
      ,m.isTemporaryMember
      ,m.maintenanceTypeCode
      ,m.retireRuleNumber
"	  ,m.stageId originalStageId"
  into EdmStage.COC_Member_temp
  from EdmStage.COC_Member m
  left join EdmStage.COC_MemberExclusion e
"    on m.subscriberSsn	= e.subscriberSsn"
"   and m.lastName	 	= e.lastName	 "
"   and m.firstName	 	= e.firstName	 "
"   and m.relationship 	= e.relationship"
 where e.subscriberSsn is null ;

drop table if exists EdmStage.COC_Member ;

select *
  into EdmStage.COC_Member
  from EdmStage.COC_Member_temp ;
  
alter table EdmStage.COC_Member alter column originalStageId bigint null ;
alter table EdmStage.COC_MemberExcluded alter column originalStageId bigint null ;

"update statistics EdmStage.COC_Member ;	1	2022-07-20 07:20:27.4633333	mssql"
"329	67	MPI-MISSING_MPI_COUNT	select count(*) from EdmStage.MAL_Member2 where mpiid is null	1	2022-07-26 14:09:01.9466667	mssql"
"330	67	MPI-DUPLICATE_MPI_COUNT	select count(*)"
  from (select m.mpiid
              ,count(*) recordCount
"	          ,string_agg(m.memberId, ', ') within group (order by m.memberId) patientSsnList"
"	          ,count(distinct memberId) patientSsnCount"
"	          ,string_agg(m.memberDob, ', ') within group (order by m.memberId) birthDateList"
"	          ,count(distinct m.memberDob) birthDateCount"
"	          ,string_agg(m.memberGender, ', ')  within group (order by m.memberId) genderList"
"	          ,count(distinct m.memberGender) genderCount"
"	          ,max(fileRequestId) fileRequestId"
"	          ,string_agg(m.stageId, ', ') within group (order by m.memberId) stageIdList"
          from EdmStage.MAL_Member2 m --<tableSchema>.<tableName> m
"		  left join EdmStage.MAL_Member2_ignore_duplicates i"
"		    on m.memberFirstName = i.memberFirstName"
           and m.memberLastName  = i.memberLastName
"           and m.memberDOB 		 = i.memberDOB"
"		   and m.memberGender    = i.memberGender"
"           and m.mpiid			 = i.mpiid"
"		 where i.mpiid is null"
         group by m.mpiid
        having count(distinct case when m.memberId = '000000000' then null else m.memberId end) > 1
            or count(distinct m.memberDob) > 1
"            or count(distinct m.memberGender) > 1) x ;	1	2022-07-27 14:34:47.8900000	mssql"
"331	67	PREPROCESS_SQL	declare @fileRequestId bigint = :fileRequestId ;"

merge into edmStage.MAL_Member2 m
using (select d.fileRequestId
             ,d.stageId
             ,s.mpiid subscriberMPIID
"			 ,left(s.memberId, 9) + s.dependentNumber subscriberPrimaryNumber"
         from edmStage.MAL_Member2 d
         left join edmStage.MAL_Member2 s 
           on left(d.memberId, 9) + '00' = left(s.memberId, 9) + s.dependentNumber
        where d.fileRequestId = @fileRequestId) u
  on m.stageId = u.stageId
 and m.fileRequestId = u.fileRequestId
when matched then update set m.subscriberMPIID = u.subscriberMPIID
"                            ,m.subscriberPrimaryNumber = u.subscriberPrimaryNumber ;	1	2022-07-28 10:29:43.8133333	mssql"
"334	64	MPI-INSERT_BULK_REQUEST_STAGE	declare @fileRequestId bigint = :fileRequestId ;"

insert into MPI.BulkRequestStage 
       (BulkRequestStageId 
       ,ClientIdentifier 
       ,OriginalPatientIdentifier 
       ,CurrentPatientIdentifier 
       ,PolicyNumber 
       ,FirstName 
       ,MiddleName 
       ,LastName 
       ,SSN 
       ,DOB 
       ,Gender 
       ,AddressLine1 
       ,AddressLine2 
       ,City 
       ,State 
       ,ZIP 
       ,Telephone)
select m.stageId BulkRequestStageId
"	  ,c.clientCode ClientIdentifier "
      ,m.memberPrimaryId OriginalPatientIdentifier 
"	  ,null CurrentPatientIdentifier "
"	  ,m.memberPrimaryId PolicyNumber "
"	  ,isnull(m.memberFirstname, 'UNKNOWN') FirstName "
"	  ,null MiddleName "
"	  ,isnull(m.memberLastName, 'UNKNOWN') LastName "
"	  ,null SSN --,case when m.memberSsn = '000000000' then null else m.memberSsn end SSN -- ? TODO: anything about this"
"	  ,case when year(try_convert(datetime2, memberBirthDate)) > 1800 then left(m.memberBirthDate, 4) +'-'+ right(left(memberBirthDate, 6), 2) +'-'+ right(memberBirthDate, 2) + ' 00:00:00' end  DOB "
"	  ,isnull(m.memberGenderCode, 'U') Gender "
"	  ,m.memberAddressLine1 AddressLine1 "
"	  ,m.memberAddressLine2 AddressLine2 "
"	  ,m.memberCityName City "
"	  ,m.memberStateCode State "
"	  ,m.memberPostalZoneCode ZIP "
"	  ,memberPrimaryTelephoneNumber Telephone"
  from EdmStage.Local478_Member2 m
  join EdmLib.FileRequest fr on fr.fileRequestId = @fileRequestId
  join Reference.Client c on fr.clientId = c.clientId
" where m.fileRequestId = @fileRequestId  ;	1	2022-10-20 09:52:17.4466667	mssql"
"335	64	MERGE_SubscriberPrimaryNumber	declare @fileRequestId bigint = :fileRequestId ;"

with subscriber as 
     (select fileRequestId, stageId, subscriberPrimaryId, memberPrimaryId, enterprisePatientId enterpriseSubscriberId
        from edmStage.Local478_Member2 
       where memberRelationshipCode = '18'
"	     and fileRequestId = @fileRequestId),"
     dependnt as
"	 (select fileRequestId, stageId, subscriberPrimaryId, memberPrimaryId "
"	    from edmStage.Local478_Member2"
"	   where memberRelationshipCode <> '18'"
"	     and fileRequestId = @fileRequestId ),"
"	 linked as"
"	 (select d.fileRequestId, d.stageId, s.enterpriseSubscriberId"
       from dependnt d 
       join subscriber s
         on d.subscriberPrimaryId = s.subscriberPrimaryId
"		and d.fileRequestId = s.fileRequestId) "
merge into edmStage.Local478_Member2 m
using linked u 
   on m.stageId = u.stageId
  and m.fileRequestId = u.fileRequestId
" when matched then update set m.enterpriseSubscriberId = u.enterpriseSubscriberId ;	1	2022-10-26 10:49:20.9033333	mssql"
"336	64	UPDATE_SubscriberPrimaryNumber	declare @fileRequestId bigint = :fileRequestId ;"

update edmStage.Local478_Member2
   set enterpriseSubscriberId = enterprisePatientId
 where enterpriseSubscriberId is null
"   and fileRequestId = @fileRequestId ;	1	2022-10-26 10:49:37.1600000	mssql"
"337	64	SELECT_NullSubscriberPrimaryNumber	"

#NAME?
declare @fileRequestId bigint = :fileRequestId  ;



#NAME?
update edmStage.Local478_Member2
   set planBeginDate1 = coalesce(planBeginDate1, groupPolicyEffectiveDate)
      ,planEndDate1 = coalesce(planEndDate1, groupPolicyExpirationDate)
where fileRequestId = @fileRequestId ;

-- group policy plan number defaults go here;
update edmStage.Local478_Member2
   set groupPolicyNumber = 'L478-Default'
where fileRequestId = @fileRequestId
"	and groupPolicyEffectiveDate is not null;"
"	"
"		 "
update edmStage.Local478_Member2
   set planNumber1 = 'L478-Default'
where fileRequestId = @fileRequestId
"	and planBeginDate1 is not null;"
"	"
"	"
update edmStage.Local478_Member2
   set planNumber2 = 'L478-Default'
where fileRequestId = @fileRequestId
"	and planBeginDate2 is not null;"
"	"

update edmStage.Local478_Member2
   set planNumber3 = 'L478-Default'
where fileRequestId = @fileRequestId
"	and planBeginDate3 is not null;"
"	"
"	"
update edmStage.Local478_Member2
   set planNumber4 = 'L478-Default'
where fileRequestId = @fileRequestId
"	and planBeginDate4 is not null;"
"	"

update edmStage.Local478_Member2
   set planNumber5 = 'L478-Default'
where fileRequestId = @fileRequestId
"	and planBeginDate5 is not null;"
"	"


-- this does not really doing anything ...
#NAME?
#NAME?
#NAME?
update edmStage.Local478_Member2
   set enterpriseSubscriberId = enterpriseSubscriberId
where fileRequestId = @fileRequestId
   and enterpriseSubscriberId is null ;

"	1	2022-10-26 10:50:12.2400000	mssql"
"338	34	COC_BCBS_PREPROCESS-0001-DIFF	declare @fileRequestId bigint = :fileRequestId ;"

if object_id('EdmStage.COC_ProviderBCBS_' + convert(varchar(32), @fileRequestId)) is null
begin
"	declare @createTable varchar(max) = 'select * into ' + 'EdmStage.COC_ProviderBCBS_' + convert(varchar(32), @fileRequestId) + '"
"	from EdmStage.COC_ProviderBCBS where fileRequestId = ' + convert(varchar(32), @fileRequestId) ;"
"	execute (@createTable) ;"
end ;

declare @prevTableName varchar(100)  ;

with backupList as
    (select replace(TRANSLATE(table_name, 'abcdefghijklmnopqrstuvwxyz+()- ,#+_', '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'), '@', '') fileRequestId
           ,table_schema
            ,table_name
       from information_schema.tables t
      where table_schema = 'EdmStage'
        and table_name like 'COC_ProviderBCBS_%'
        and try_convert(bigint, replace(TRANSLATE(table_name, 'abcdefghijklmnopqrstuvwxyz+()- ,#+_', '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'), '@', '')) is not null)
select @prevTableName = l.table_name
  from backupList l
  join edmLib.FileRequest r
    on l.fileRequestId = r.fileRequestId
where l.fileRequestId < @fileRequestId ;

declare @columns nvarchar(4000) = '' ;

select @columns = @columns + ',' + column_name
  from information_schema.columns
where table_schema = 'EdmStage'
   and table_name in ('COC_ProviderBCBS_' + convert(varchar(32), @fileRequestId))
   and column_name not in ('stageId', 'fileRequestId', 'originalStageId', 'locationNumber') ;

drop table if exists EdmStage.COC_ProviderBCBS_diff ;


declare @sql nvarchar(4000) =
'select ' + right(@columns, len(@columns)-1) + '
   into EdmStage.COC_ProviderBCBS_diff
  from EdmStage.COC_ProviderBCBS_' + convert(varchar(32), @fileRequestId) + '
except
select ' + right(@columns, len(@columns)-1) + char(10) + ' from EdmStage.' + @prevTableName ;

-- print @sql ;
execute(@sql) ;


if object_id('EdmStage.COC_ProviderBCBS_diff') is not null
begin
    set @sql = 'drop table if exists EdmStage.COC_ProviderBCBS' ;

   execute(@sql) ;

   set @sql = replace(    
    'select <fileRequestId> fileRequestId
    , row_number() over(partition by 1 order by providerNumber) stageId
    , row_number() over(partition by 1 order by providerNumber) originalStageId
    , *
    , convert(nvarchar(255), null) locationNumber
      into EdmStage.COC_ProviderBCBS
      from EdmStage.COC_ProviderBCBS_diff ', '<fileRequestId>', @fileRequestId) ;

   execute(@sql) ;

"end ;	1	2022-11-01 08:20:31.5966667	mssql"
"340	56	EDM_STANDARD_MPI-INSERT_BULK_REQUEST_STAGE	declare @fileRequestId bigint = :fileRequestId ;"

insert into MPI.BulkRequestStage
       (BulkRequestStageId
       ,ClientIdentifier
       ,OriginalPatientIdentifier
       ,CurrentPatientIdentifier
       ,PolicyNumber
       ,FirstName
       ,MiddleName
       ,LastName
       ,SSN
       ,DOB
       ,Gender
       ,AddressLine1
       ,AddressLine2
       ,City
       ,State
       ,ZIP
       ,Telephone)
select m.stageId BulkRequestStageId
"	  ,c.clientCode ClientIdentifier"
      ,isnull(m.memberPrimaryId, 'NOT_SUPPLIED') OriginalPatientIdentifier
"	  ,case when m.memberSupplementalIdQualifier = 'MI' then m.memberSupplementalId end CurrentPatientIdentifier"
"	  ,case when m.memberSupplementalIdQualifier = '38' then m.memberSupplementalId else m.subscriberPrimaryId end PolicyNumber"
"	  ,isnull(m.memberFirstname, 'UNKNOWN') FirstName"
"	  ,m.memberMiddleName MiddleName"
"	  ,isnull(m.memberLastName, 'UNKNOWN') LastName"
"	  ,case when m.memberSupplementalIdQualifier = 'SY' and m.memberSupplementalId <> '000000000' then m.memberSupplementalId end SSN"
"	  ,case when year(try_convert(datetime2, memberBirthDate)) > 1800 then left(m.memberBirthDate, 4) +'-'+ right(left(memberBirthDate, 6), 2) +'-'+ right(memberBirthDate, 2) + ' 00:00:00' end  DOB"
"	  ,isnull(m.memberGenderCode, 'U') Gender"
"	  ,m.memberAddressLine1 AddressLine1"
"	  ,m.memberAddressLine2 AddressLine2"
"	  ,m.memberCityName City"
"	  ,m.memberStateCode State"
"	  ,m.memberPostalZoneCode ZIP"
"	  ,case when len(m.memberPrimaryTelephoneNumber) > 6 then m.memberPrimaryTelephoneNumber end Telephone"
  from edmStage.SheetMetal_Member m --<tableSchema>.<tableName> m
  join EdmLib.FileRequest fr on fr.fileRequestId = @fileRequestId
  join Reference.Client c on fr.clientId = c.clientId
 where m.fileRequestId = @fileRequestId;
"	1	2023-02-15 11:28:18.2441393	mssql"
