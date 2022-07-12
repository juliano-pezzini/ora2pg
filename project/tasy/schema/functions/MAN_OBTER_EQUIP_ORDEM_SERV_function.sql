-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_equip_ordem_serv ( nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE


nr_seq_equip_w		bigint;


BEGIN

if (coalesce(nr_sequencia_p,0) > 0) then
	begin
	select	nr_seq_equipamento
	into STRICT	nr_seq_equip_w
	from	man_ordem_servico
	where	nr_sequencia = nr_sequencia_p;
	end;
end if;

return	nr_seq_equip_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_equip_ordem_serv ( nr_sequencia_p bigint) FROM PUBLIC;

