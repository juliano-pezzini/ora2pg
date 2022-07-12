-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_result_escala_sist_nut ( ie_dietoterapia_p text, ie_fator_risco_p text ) RETURNS varchar AS $body$
DECLARE


  ds_retorno_w varchar(100);
  sql_w varchar(250);

BEGIN
  ds_retorno_w	:= '';
  begin
    sql_w := 'CALL OBTER_RESULT_ESC_SIST_NUT_MD(:1, :2) INTO :ds_retorno_w';
    EXECUTE sql_w
      USING IN ie_dietoterapia_p,
            IN ie_fator_risco_p,
            OUT ds_retorno_w;
  exception
    when others then
      ds_retorno_w := null;
    end;
  return ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_result_escala_sist_nut ( ie_dietoterapia_p text, ie_fator_risco_p text ) FROM PUBLIC;

