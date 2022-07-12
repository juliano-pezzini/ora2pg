-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_grupo_acomod_ordem (nr_seq_ordem_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(250);


BEGIN

if (nr_seq_ordem_p IS NOT NULL AND nr_seq_ordem_p::text <> '') then
	select  max(substr(obter_qt_grupo_local(a.nr_seq_local),1,30))
	into STRICT	ds_retorno_w
	from    paciente_atendimento a,
		can_ordem_prod b
	where   a.nr_seq_atendimento = b.nr_seq_atendimento
	and	b.nr_sequencia = nr_seq_ordem_p;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_grupo_acomod_ordem (nr_seq_ordem_p bigint) FROM PUBLIC;
