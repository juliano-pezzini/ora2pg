-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_episodio (nr_seq_episodio_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

/*
	E - Número Case
*/
ds_retorno_w	varchar(255);


BEGIN

if (ie_opcao_p = 'E') then
	select 	max(nr_episodio)
	into STRICT	ds_retorno_w
	from	episodio_paciente
	where 	nr_sequencia = nr_seq_episodio_p;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_episodio (nr_seq_episodio_p bigint, ie_opcao_p text) FROM PUBLIC;
