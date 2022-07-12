-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_lic_complemento ( nr_sequencia_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_utilizacao_w			lic_complemento.ds_utilizacao%type;


BEGIN

select ds_utilizacao
into STRICT   ds_utilizacao_w
from   lic_complemento
where  nr_sequencia = nr_sequencia_p;

if (ie_opcao_p = 'UTIL') then
	return ds_utilizacao_w;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_lic_complemento ( nr_sequencia_p bigint, ie_opcao_p text) FROM PUBLIC;

