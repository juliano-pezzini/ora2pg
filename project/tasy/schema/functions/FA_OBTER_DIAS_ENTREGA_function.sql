-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION fa_obter_dias_entrega (nr_seq_entrega_p bigint) RETURNS bigint AS $body$
DECLARE

nr_dias_w	bigint;

BEGIN
if (nr_seq_entrega_p IS NOT NULL AND nr_seq_entrega_p::text <> '') then
	select 	max(nr_dias_util)
	into STRICT	nr_dias_w
	from   	fa_entrega_medicacao
	where  	nr_seq_paciente_entrega = nr_seq_entrega_p;
end if;
return	nr_dias_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION fa_obter_dias_entrega (nr_seq_entrega_p bigint) FROM PUBLIC;

