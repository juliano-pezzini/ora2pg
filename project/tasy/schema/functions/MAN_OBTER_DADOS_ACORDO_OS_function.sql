-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_dados_acordo_os ( nr_seq_ordem_p bigint, ie_tipo_dado_p text) RETURNS varchar AS $body$
DECLARE


/*
NR - Numero do acordo;
DS - Descrição do acordo;
*/
ds_retorno_w	varchar(4000);


BEGIN

if (ie_tipo_dado_p = 'DS') then
	begin
		select	da.ds_titulo ds_acordo
		into STRICT	ds_retorno_w
		from	desenv_acordo da,
			desenv_acordo_os os
		where	os.nr_seq_ordem_servico = nr_seq_ordem_p
		and	os.nr_seq_acordo = da.nr_sequencia
		order by da.nr_sequencia LIMIT 1;
	end;
end if;

if (ie_tipo_dado_p = 'NR') then
	begin
		select	max(da.nr_sequencia) nr_seq_acordo
		into STRICT	ds_retorno_w
		from	desenv_acordo da,
			desenv_acordo_os os
		where	os.nr_seq_ordem_servico = nr_seq_ordem_p
		and	os.nr_seq_acordo = da.nr_sequencia
		order by da.nr_sequencia LIMIT 1;
	end;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_dados_acordo_os ( nr_seq_ordem_p bigint, ie_tipo_dado_p text) FROM PUBLIC;

