-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_ordena_grupo_aud_fax ( nr_seq_ordem_p bigint, nr_seq_grupo_adcionado_p bigint, nr_seq_auditoria_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_ordem_w			bigint;
nr_seq_ordem_nova_w		bigint;
nr_seq_ordem_grupos_w		bigint;
nr_seq_grupo_aud_w		bigint;

C01 CURSOR FOR
	SELECT	nr_seq_ordem,
		nr_sequencia
	from	pls_auditoria_grupo
	where	nr_seq_auditoria	= nr_seq_auditoria_p
	and	nr_seq_ordem 		>= nr_seq_ordem_w
	and	nr_sequencia 		<> nr_seq_grupo_adcionado_p
	order by nr_seq_ordem desc;


BEGIN

nr_seq_ordem_w	:= nr_seq_ordem_p;

select	nr_seq_ordem,
	nr_sequencia
into STRICT	nr_seq_ordem_grupos_w,
	nr_seq_grupo_aud_w
from	pls_auditoria_grupo
where	nr_seq_auditoria	= nr_seq_auditoria_p
and	nr_seq_ordem 		= nr_seq_ordem_w
and	nr_sequencia 		<> nr_seq_grupo_adcionado_p;


while nr_seq_ordem_w	= nr_seq_ordem_grupos_w loop
	begin
	nr_seq_ordem_nova_w	:= nr_seq_ordem_grupos_w + 1;
	nr_seq_ordem_w		:= nr_seq_ordem_nova_w;

	update	pls_auditoria_grupo
	set	nr_seq_ordem 	= nr_seq_ordem_nova_w,
		dt_atualizacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p
	where	nr_sequencia 	= nr_seq_grupo_aud_w;

	begin
	select	nr_seq_ordem,
		nr_sequencia
	into STRICT	nr_seq_ordem_grupos_w,
		nr_seq_grupo_aud_w
	from	pls_auditoria_grupo
	where	nr_seq_auditoria	= nr_seq_auditoria_p
	and	nr_seq_ordem 		= nr_seq_ordem_w
	and	nr_sequencia 		<> nr_seq_grupo_aud_w;
	exception
	when others then
		nr_seq_ordem_grupos_w	:= 0;
		nr_seq_grupo_aud_w	:= 0;
	end;
	end;
end loop;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ordena_grupo_aud_fax ( nr_seq_ordem_p bigint, nr_seq_grupo_adcionado_p bigint, nr_seq_auditoria_p bigint, nm_usuario_p text) FROM PUBLIC;

