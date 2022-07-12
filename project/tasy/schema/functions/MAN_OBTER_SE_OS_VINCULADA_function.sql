-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_se_os_vinculada ( nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w		varchar(1) := 'N';


BEGIN

if (coalesce(nr_sequencia_p,0) > 0) then
	begin

	begin
	select	'S'
	into STRICT	ie_retorno_w
	from	man_ordem_serv_vinc b,
		man_ordem_servico a
	where	a.nr_sequencia		= b.nr_seq_os_vinculada
	and	b.nr_seq_ordem_servico	= nr_sequencia_p  LIMIT 1;
	exception
	when others then
		ie_retorno_w := 'N';
	end;

	if (ie_retorno_w = 'N') then
		begin
		select	'S'
		into STRICT	ie_retorno_w
		from	man_ordem_serv_vinc b,
			man_ordem_servico a
		where	a.nr_sequencia		= b.nr_seq_ordem_servico
		and	b.nr_seq_os_vinculada	= nr_sequencia_p  LIMIT 1;
		exception
		when others then
			ie_retorno_w := 'N';
		end;
	end if;
	end;
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_se_os_vinculada ( nr_sequencia_p bigint) FROM PUBLIC;
