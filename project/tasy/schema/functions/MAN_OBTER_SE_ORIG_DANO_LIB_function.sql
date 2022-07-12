-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_se_orig_dano_lib ( nr_sequencia_p bigint, nr_seq_grupo_trab_p bigint, nr_seq_grupo_planej_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w			varchar(1) := 'S';
qt_existe_w			bigint;


BEGIN
select	count(*)
into STRICT	qt_existe_w
from	man_origem_dano_planej
where	nr_seq_origem_dano = nr_sequencia_p;

if (qt_existe_w = 0) then
	select	count(*)
	into STRICT	qt_existe_w
	from	man_origem_dano_trab
	where	nr_seq_origem_dano = nr_sequencia_p;
end if;

if (qt_existe_w > 0) then
	begin

	begin
	select	'S'
	into STRICT	ie_retorno_w
	from	man_origem_dano_planej
	where	nr_seq_origem_dano = nr_sequencia_p
	and	nr_seq_grupo_planejamento = nr_seq_grupo_planej_p  LIMIT 1;
	exception
	when others then
		ie_retorno_w := 'N';
	end;

	if (ie_retorno_w = 'N') then
		begin
		select	'S'
		into STRICT	ie_retorno_w
		from	man_origem_dano_trab
		where	nr_seq_origem_dano = nr_sequencia_p
		and	nr_seq_grupo_trabalho = nr_seq_grupo_trab_p  LIMIT 1;
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
-- REVOKE ALL ON FUNCTION man_obter_se_orig_dano_lib ( nr_sequencia_p bigint, nr_seq_grupo_trab_p bigint, nr_seq_grupo_planej_p bigint) FROM PUBLIC;
