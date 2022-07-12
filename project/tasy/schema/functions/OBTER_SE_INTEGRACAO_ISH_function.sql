-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_integracao_ish ( nr_seq_projeto_xml_p intpd_eventos_sistema.nr_seq_projeto_xml%type) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1) := 'N';


BEGIN
if (nr_seq_projeto_xml_p in (
		102163,	/*ISH - PatientCancel - Request*/
		102164,	/*ISH - PatientChange - Request*/
		102129,	/*ISH - PatientCreate - Request*/
		102257,	/*ISH - PatientDequeue*/
		102256,	/*ISH - PatientEnqueue*/
		102126,	/*ISH - PatientGetDetail - Request*/
		103160, /*ISH - PatientMerge - Request*/
			
		102137,	/*ISH - PatcaseAddinpatadmiss - Request*/
		102161,	/*ISH - PatcaseCancelinpatadmiss - Request*/
		102165,	/*ISH - PatcaseChangeinpatadmiss - Request*/
		102133,	/*ISH - PatcaseGetinpatadmiss - Request*/
		102736, /*ISH - PatcaseGetdetail - Request*/
		102252, /*ISH - assignmentGet*/
		103171, /*ISH - assignment*/
		102258, /*ISH - PatcaseDequeue*/
		102259, /*ISH - PatcaseEnqueue*/
		102166,	/*ISH - PatcaseAddoutpatvisit - Request*/
		102148,	/*ISH - PatcaseAddoutpatvisitcas - Request*/
		102150,	/*ISH - PatcaseCanceloutpatvisit - Request*/
		102152,	/*ISH - PatcaseChangeoutpatvisit - Request*/
		102159,	/*ISH - PatcaseGetoutpatvisit - Request*/
		102169,	/*ISH - PatcaseAddtransfer - Request*/
		102175,	/*ISH - PatcaseCanceltransfer - Request*/
		102174,	/*ISH - PatcaseChangetransfer - Request*/
		102171,	/*ISH - PatcaseGetmovementlist - Request*/
		102172,	/*ISH - PatcaseGettransfer - Request*/
		102168,	/*ISH - PatcaseAdddischarge - Request*/
		102167,	/*ISH - PatcaseCanceldischarge - Request*/
		102176,	/*ISH - PatcaseChangedischarge - Request*/
		102158,	/*ISH - PatcaseGetdischarge - Request*/
		102106,	/*ISH - CasediagnosisChangemult - Request*/
		102108,	/*ISH - CasediagnosisCreatemult - Request*/
		102112,	/*ISH - CasediagnosisDeletemult - Request*/
		102101,	/*ISH - CasediagnosisGetlist - Request*/
		102195,	/*ISH - CaseprocedureCancelmult - Request*/
		102139,	/*ISH - CaseprocedureChangemult - Request*/
		102136,	/*ISH - CaseprocedureCreatemult - Request*/
		102191,	/*ISH - CaseprocedureGetlist - Request*/
		102154, /*ISH - CaseprocedureGetdetail - Request*/
		102144,	/*ISH - CaseserviceCancelmult - Request*/
		102147,	/*ISH - CaseserviceChangemult - Request*/
		102140,	/*ISH - CaseserviceCreatemult - Request*/
		102160,	/*ISH - CaseserviceGetlist - Request*/
		102162, /*ISH - CaseserviceGetdetail - Request*/
		
		102560, /*ISH - buspartnerGetDetail - Request*/
		
		
		102694,	/*ISH - caseModifyBirth - Request*/
		
		102693,	/*ISH - PatcaseGetabsence - Request*/
		102692,	/*ISH - PatcaseCancelabsence - Request*/
		102690,	/*ISH - PatcaseChangeabsence - Request*/
		102687,	/*ISH - PatcaseAddabsence - Request*/
		102685,	/*ISH - certificTreatmCancel - Request*/
		102683,	/*ISH - CertificTreatmCreate - Request*/
		103137,	/*ISH - CertificTreatmChange - Request*/
		102676,	/*ISH - CaseStatus Request*/
		
		102670,	/*ISH - eGKGet Request*/
		102669,	/*ISH - eGKCreate*/
		102151,	/*ISH - CaseserviceGetlist - Response*/
		102695,	/*ISH - casechangetypeCreate*/
		103138,	/*ISH - tableModify*/
		102271,	/*ISH - insuranceCancel*/
		102268,	/*ISH - insuranceChange*/
		102267,	/*ISH - insuranceCreate*/
		102251,	/*ISH - insuranceGet*/
		103139, /*ISH - insuranceSwap*/
		103146 /*ISH - recordCheckDelete (Paper File) - Request*/
)) then
	ds_retorno_w	:=	'S';
else	
	ds_retorno_w	:=	'N';
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_integracao_ish ( nr_seq_projeto_xml_p intpd_eventos_sistema.nr_seq_projeto_xml%type) FROM PUBLIC;

