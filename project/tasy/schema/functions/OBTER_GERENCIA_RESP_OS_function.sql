-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_gerencia_resp_os ( nr_seq_os_p bigint) RETURNS bigint AS $body$
DECLARE


nr_seq_gerencia_w	bigint;


BEGIN
if (nr_seq_os_p IS NOT NULL AND nr_seq_os_p::text <> '') then
	begin
	select	max(g.nr_seq_gerencia)
	into STRICT	nr_seq_gerencia_w
	from	grupo_desenvolvimento g,
		man_ordem_servico o
	where	g.nr_sequencia = o.nr_seq_grupo_des
	and	o.nr_sequencia = nr_seq_os_p;
	end;
end if;
return nr_seq_gerencia_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_gerencia_resp_os ( nr_seq_os_p bigint) FROM PUBLIC;

