-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consistir_lote_pessoa ( nr_seq_lote_p bigint, cd_pessoa_fisica_p text, cd_cgc_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

				 
cd_pessoa_fisica_w	varchar(10);
cd_cgc_w		varchar(14);
qt_registro_w		bigint;
nr_seq_inconsistencia_w	bigint;
cd_inconsistencia_w	varchar(255);

c01 CURSOR FOR 
SELECT	a.cd_pessoa_fisica, 
	a.cd_cgc, 
	a.nr_seq_inconsistencia 
from	pls_pessoa_inconsistente a 
where	coalesce(a.dt_consistente::text, '') = '' 
and	a.nr_seq_lote	= nr_seq_lote_p 
and (a.cd_pessoa_fisica = cd_pessoa_fisica_p or coalesce(cd_pessoa_fisica_p::text, '') = '') 
and (a.cd_cgc = cd_cgc_p or coalesce(cd_cgc_p::text, '') = '');
				

BEGIN 
 
if (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '') then 
	open c01;
	loop 
	fetch c01 into	 
		cd_pessoa_fisica_w, 
		cd_cgc_w, 
		nr_seq_inconsistencia_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin 
		 
		CALL pls_consistir_dados_pessoa(cd_pessoa_fisica_w,cd_cgc_w,nr_seq_lote_p,cd_estabelecimento_p,nm_usuario_p);
		 
		if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then 
			select	count(*) 
			into STRICT	qt_registro_w 
			from	pls_inconsistencia_pessoa 
			where	cd_pessoa_fisica	= cd_pessoa_fisica_w 
			and	nr_seq_inconsistencia	= nr_seq_inconsistencia_w;
		 
			if (qt_registro_w = 0) then 
				 
			 
				update	pls_pessoa_inconsistente 
				set	dt_consistente	= clock_timestamp(), 
					dt_atualizacao	= clock_timestamp(), 
					nm_usuario	= nm_usuario_p, 
					nm_usuario_correcao	= nm_usuario_p 
				where	nr_seq_lote	= nr_seq_lote_p 
				and	cd_pessoa_fisica	= cd_pessoa_fisica_w 
				and	nr_seq_inconsistencia	= nr_seq_inconsistencia_w;
			end if;
			 
		else 
			select	count(*) 
			into STRICT	qt_registro_w 
			from	pls_inconsistencia_pessoa 
			where	cd_cgc		= cd_cgc_w 
			and	nr_seq_inconsistencia	= nr_seq_inconsistencia_w;
		 
			if (qt_registro_w = 0) then 
				update	pls_pessoa_inconsistente 
				set	dt_consistente	= clock_timestamp(), 
					dt_atualizacao	= clock_timestamp(), 
					nm_usuario	= nm_usuario_p, 
					nm_usuario_correcao	= nm_usuario_p 
				where	nr_seq_lote	= nr_seq_lote_p 
				and	cd_cgc		= cd_cgc_w 
				and	nr_seq_inconsistencia	= nr_seq_inconsistencia_w;
			end if;
		end if;
		 
		end;
	end loop;
	close c01;
	 
	/* Verificar se todas as pessoas estão consistentes para deixar o lote como consistente */
 
	select	count(*) 
	into STRICT	qt_registro_w 
	from	pls_pessoa_inconsistente 
	where	nr_seq_lote	= nr_seq_lote_p 
	and	coalesce(dt_consistente::text, '') = '';
	 
	if (qt_registro_w = 0) then 
		update	pls_lote_pessoa_inconsist 
		set	dt_consistente	= clock_timestamp(), 
			dt_atualizacao	= clock_timestamp(), 
			nm_usuario	= nm_usuario_p 
		where	nr_sequencia	= nr_seq_lote_p;
	end if;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_lote_pessoa ( nr_seq_lote_p bigint, cd_pessoa_fisica_p text, cd_cgc_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

