-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION fa_obter_data_inicial_receita (nr_seq_entrega_p bigint) RETURNS timestamp AS $body$
DECLARE

dt_retorno_w	timestamp;

BEGIN
if (nr_seq_entrega_p IS NOT NULL AND nr_seq_entrega_p::text <> '') then
	select 	max(trunc(dt_periodo_inicial))
	into STRICT	dt_retorno_w
	from   	fa_entrega_medicacao
	where  	nr_seq_paciente_entrega = nr_seq_entrega_p;
end if;
return	dt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION fa_obter_data_inicial_receita (nr_seq_entrega_p bigint) FROM PUBLIC;

