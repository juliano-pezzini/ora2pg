-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_valor_nulo_igual (valor_p text, valor_base_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w  varchar(1);


BEGIN
  select CASE WHEN coalesce(valor_p::text, '') = '' THEN 'S'  ELSE CASE WHEN valor_p=valor_base_p THEN 'S'  ELSE 'N' END  END
  into STRICT ds_retorno_w
;

return  ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_valor_nulo_igual (valor_p text, valor_base_p text) FROM PUBLIC;

