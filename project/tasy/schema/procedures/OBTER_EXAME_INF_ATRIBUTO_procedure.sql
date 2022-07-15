-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_exame_inf_atributo ( cd_estabelecimento_p bigint, nm_tabela_p text, nm_atributo_p text, nr_seq_exame_p INOUT bigint) AS $body$
DECLARE





cd_empresa_w		bigint;
nr_seq_exame_w		bigint;


C01 CURSOR FOR
	SELECT	c.nr_seq_exame
	from	pep_inf_regra c,
		pep_informacao b,
		pep_dest_inf a
	where	a.nm_tabela		= nm_tabela_p
	and	a.nm_atributo		= nm_atributo_p
	and	c.cd_empresa		= cd_empresa_w
	and	coalesce(c.cd_estabelecimento,cd_estabelecimento_p)	= cd_estabelecimento_p
	and	a.nr_seq_inf		= b.nr_sequencia
	and	b.nr_sequencia		= c.nr_seq_inf
	and (a.nr_sequencia		= c.nr_seq_dest_inf or coalesce(c.nr_seq_dest_inf::text, '') = '')
	and	c.ie_informacao		= 'Usuario'
	order by coalesce(c.nr_seq_dest_inf,0);


BEGIN

select	cd_empresa
into STRICT	cd_empresa_w
from	estabelecimento
where	cd_estabelecimento	= cd_estabelecimento_p;

open C01;
loop
fetch C01 into
	nr_seq_exame_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
end loop;
close C01;

if (nr_seq_exame_w IS NOT NULL AND nr_seq_exame_w::text <> '') then

nr_seq_exame_p	:= nr_seq_exame_w;

else nr_seq_exame_p := 0;

end if;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_exame_inf_atributo ( cd_estabelecimento_p bigint, nm_tabela_p text, nm_atributo_p text, nr_seq_exame_p INOUT bigint) FROM PUBLIC;

