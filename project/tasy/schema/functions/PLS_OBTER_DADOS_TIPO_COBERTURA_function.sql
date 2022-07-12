-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_tipo_cobertura ( nr_seq_tipo_cobertura_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

/* ie_opcao_p
	D - Descrição da cobertura */
ds_retorno_w			varchar(255);
ds_cobertura_w			varchar(255);


BEGIN

select	ds_cobertura
into STRICT	ds_cobertura_w
from	pls_tipo_cobertura
where	nr_sequencia	= nr_seq_tipo_cobertura_p;

if (ie_opcao_p	= 'D') then
	ds_retorno_w	:= ds_cobertura_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_tipo_cobertura ( nr_seq_tipo_cobertura_p bigint, ie_opcao_p text) FROM PUBLIC;

