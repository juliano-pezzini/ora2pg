-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE bl_gravar_codigo_frasco ( nr_seq_frasco_p bigint, ie_identificador_p text, nm_usuario_p text) AS $body$
DECLARE


/*
ie_identificador_p
0 - Coleta
1 - Agrupamento
2 - Fracionamento
*/
cd_frasco_w		varchar(20);
cd_pessoa_fisica_w	varchar(10);
nr_seq_coleta_w		bigint;
nr_seq_agrupamento_w	bigint;
qt_agrupamento_w	varchar(10);
qt_coleta_w		varchar(10);
qt_frascos_w		varchar(10);
ie_ja_existe_w		varchar(1);
cd_frasco_atual_w	varchar(20);
				

BEGIN
if (nr_seq_frasco_p IS NOT NULL AND nr_seq_frasco_p::text <> '') then

	select	max(cd_frasco)
	into STRICT	cd_frasco_atual_w
	from	bl_frasco
	where	nr_sequencia = nr_seq_frasco_p;

	if (coalesce(cd_frasco_atual_w::text, '') = '') then
		/*select	cd_pessoa_fisica,
			nr_seq_coleta,
			nr_seq_agrupamento
		into	cd_pessoa_fisica_w,
			nr_seq_coleta_w,
			nr_seq_agrupamento_w
		from	bl_frasco_v
		where	nr_sequencia = nr_seq_frasco_p;
		
		if	(ie_identificador_p = '1') then
			select	lpad(count(*),2,0)
			into	qt_agrupamento_w
			from	bl_agrupamento a
			where	a.cd_doadora = cd_pessoa_fisica_w
			and	a.ie_novo_frasco = 'S'
			and	dt_liberacao is not null;
			
			cd_frasco_w := ie_identificador_p||lpad(cd_pessoa_fisica_w,9,0)||qt_agrupamento_w||'0';	
		else
			select	lpad(count(*),2,0)
			into	qt_coleta_w
			from	bl_coleta a,
				bl_doacao b
			where	a.nr_seq_doacao = b.nr_sequencia
			and	b.cd_pessoa_fisica = cd_pessoa_fisica_w
			and	a.nr_sequencia <= nr_seq_coleta_w;
			
			select	lpad(count(*),1,0)
			into	qt_frascos_w
			from	bl_frasco
			where	nr_seq_coleta = nr_seq_coleta_w
			and	nr_sequencia <= nr_seq_frasco_p;
		
			cd_frasco_w := ie_identificador_p||lpad(cd_pessoa_fisica_w,9,0)||qt_coleta_w||qt_frascos_w;	
		end if;*/
		
		cd_frasco_w := ie_identificador_p||lpad(nr_seq_frasco_p,9,0);
		
		select	count(*)
		into STRICT	ie_ja_existe_w
		from	bl_frasco
		where	cd_frasco = cd_frasco_w;
		
		if (ie_ja_existe_w = 0) then
			update	bl_frasco
			set	cd_frasco 	= cd_frasco_w,
				dt_atualizacao	= clock_timestamp(),
				nm_usuario	= nm_usuario_p
			where	nr_sequencia 	= nr_seq_frasco_p;
		end if;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE bl_gravar_codigo_frasco ( nr_seq_frasco_p bigint, ie_identificador_p text, nm_usuario_p text) FROM PUBLIC;
