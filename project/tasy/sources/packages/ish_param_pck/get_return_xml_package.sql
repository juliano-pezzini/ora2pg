-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ish_param_pck.get_return_xml () RETURNS varchar AS $body$
DECLARE

	
ds_retorno_w varchar(1);
	

BEGIN

begin
select CD_EXTERNO
into STRICT ds_retorno_w
from  CONVERSAO_MEIO_EXTERNO
where NM_TABELA = 'XML_PROJETO'
and NM_ATRIBUTO = 'ATTRIBUTE_TYPE';
exception
when others then
	ds_retorno_w := 'U';
end;

return ds_retorno_w;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 IMMUTABLE;
-- REVOKE ALL ON FUNCTION ish_param_pck.get_return_xml () FROM PUBLIC;
