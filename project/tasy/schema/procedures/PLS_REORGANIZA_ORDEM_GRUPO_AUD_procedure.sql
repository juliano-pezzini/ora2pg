-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_reorganiza_ordem_grupo_aud ( nr_seq_ordem_p bigint, nr_seq_grupo_adcionado_p bigint, nr_seq_auditoria_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_ordem_grupos_w		bigint;
nr_seq_ordem_grupo_w		bigint;
nr_seq_grupo_aud_w		bigint;
nr_contador_w			integer := 0;
nr_seq_ordem_max_w		bigint;

C01 CURSOR FOR
	SELECT	nr_seq_ordem,
		nr_sequencia
	from	pls_auditoria_grupo
	where	nr_seq_auditoria	= nr_seq_auditoria_p
	and	nr_seq_ordem 		> nr_seq_ordem_p
	and	nr_seq_ordem		< nr_seq_ordem_max_w
	and	nr_sequencia 		<> nr_seq_grupo_adcionado_p
	order by nr_seq_ordem desc;

C02 CURSOR FOR
	SELECT	nr_seq_ordem
	from	pls_auditoria_grupo
	where	nr_seq_auditoria	= nr_seq_auditoria_p
	and	nr_seq_ordem 		> nr_seq_ordem_p
	and	nr_sequencia 		<> nr_seq_grupo_adcionado_p
	order by nr_seq_ordem;


BEGIN

nr_contador_w := nr_seq_ordem_p;
open C02;
loop
fetch C02 into
	nr_seq_ordem_grupos_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin
	if (nr_seq_ordem_grupos_w <> nr_contador_w) then
		nr_seq_ordem_max_w :=  nr_seq_ordem_grupos_w;
		goto final;
	else
		nr_contador_w := nr_contador_w +1;
		nr_seq_ordem_max_w :=  nr_seq_ordem_grupos_w + 1;
	end if;
	end;
end loop;
close C02;
<<final>>

open C01;
loop
fetch C01 into
	nr_seq_ordem_grupos_w,
	nr_seq_grupo_aud_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	select	max(nr_seq_ordem)
	into STRICT	nr_seq_ordem_grupo_w
	from	pls_auditoria_grupo
	where	nr_seq_ordem < nr_seq_ordem_grupos_w
	and	nr_seq_auditoria = nr_seq_auditoria_p;

	if	(((coalesce(nr_seq_ordem_grupo_w,0) + 1) = nr_seq_ordem_grupos_w) or (coalesce(nr_seq_ordem_grupo_w::text, '') = '' and nr_seq_ordem_p = nr_seq_ordem_grupos_w)) then
		update	pls_auditoria_grupo
		set	nr_seq_ordem = nr_seq_ordem_grupos_w +1
		where	nr_sequencia = nr_seq_grupo_aud_w;
	end if;
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_reorganiza_ordem_grupo_aud ( nr_seq_ordem_p bigint, nr_seq_grupo_adcionado_p bigint, nr_seq_auditoria_p bigint, nm_usuario_p text) FROM PUBLIC;
