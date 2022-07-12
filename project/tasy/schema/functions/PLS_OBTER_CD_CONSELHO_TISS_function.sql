-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_cd_conselho_tiss (cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


sg_conselho_w	varchar(50);
				

BEGIN

select	obter_dados_medico(cd_pessoa_fisica_p ,'SGCRM')
into STRICT	sg_conselho_w
;

select  CASE WHEN sg_conselho_w='CRAS' THEN '01' WHEN sg_conselho_w='COREN' THEN '02' WHEN sg_conselho_w='CRF' THEN '03' WHEN sg_conselho_w='CRFA' THEN '04' WHEN sg_conselho_w='CREFITO' THEN '05' WHEN sg_conselho_w='CRM' THEN '06' WHEN sg_conselho_w='CRN' THEN '07' WHEN sg_conselho_w='CRO' THEN '08' WHEN sg_conselho_w='CRP' THEN '09'  ELSE '10' END
into STRICT	sg_conselho_w
;

return	sg_conselho_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_cd_conselho_tiss (cd_pessoa_fisica_p text) FROM PUBLIC;

