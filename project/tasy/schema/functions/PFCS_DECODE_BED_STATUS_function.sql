-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pfcs_decode_bed_status ( cd_status_p valor_dominio.vl_dominio%type DEFAULT null) RETURNS VALOR_DOMINIO.DS_VALOR_DOMINIO%TYPE AS $body$
DECLARE


cd_status_w valor_dominio.vl_dominio%type := cd_status_p;
ds_bed_status valor_dominio.ds_valor_dominio%type;


BEGIN

cd_status_w := upper(cd_status_w);

if (cd_status_w = pfcs_pck_constants.CD_PATIENT) then
  ds_bed_status := obter_desc_expressao(pfcs_pck_constants.CD_EXPR_OCCUPIED);
else
  ds_bed_status := substr(obter_valor_dominio(pfcs_pck_constants.CD_DOMAIN_BED_STATUS, cd_status_w),1,255);
end if;
  return ds_bed_status;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 IMMUTABLE;
-- REVOKE ALL ON FUNCTION pfcs_decode_bed_status ( cd_status_p valor_dominio.vl_dominio%type DEFAULT null) FROM PUBLIC;
