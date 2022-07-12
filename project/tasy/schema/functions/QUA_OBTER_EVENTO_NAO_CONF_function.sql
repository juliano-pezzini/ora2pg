-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION qua_obter_evento_nao_conf (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w 	varchar(80);


BEGIN

ds_retorno_w := '';

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then

	select	max(a.ds_tipo_evento)
	into STRICT	ds_retorno_w
	from	hd_tipo_evento a,
		qua_evento_paciente b,
		qua_nao_conformidade c
	where	b.nr_seq_tipo_evento = a.nr_sequencia
	and	c.nr_seq_evento = b.nr_sequencia
	and	c.nr_sequencia = nr_sequencia_p
	and	coalesce(b.ie_tipo_evento,'E') = 'E';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION qua_obter_evento_nao_conf (nr_sequencia_p bigint) FROM PUBLIC;

