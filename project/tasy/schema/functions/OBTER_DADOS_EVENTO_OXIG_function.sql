-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_evento_oxig (nr_seq_oxigenio_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*
*** OPCOES ***
**************

DE - Data evento

*/
dt_evento_w	timestamp;
ds_retorno_w	varchar(19);


BEGIN
if (nr_seq_oxigenio_p IS NOT NULL AND nr_seq_oxigenio_p::text <> '') then
	select	dt_monitorizacao
	into STRICT	dt_evento_w
	from	atendimento_monit_resp
	where	nr_sequencia = nr_seq_oxigenio_p;

	if (coalesce(ie_opcao_p,'DE') = 'DE') then
		ds_retorno_w := to_char(dt_evento_w,'dd/mm/yyyy hh24:mi:ss');
	end if;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_evento_oxig (nr_seq_oxigenio_p bigint, ie_opcao_p text) FROM PUBLIC;
