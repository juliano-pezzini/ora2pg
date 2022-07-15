-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_perfis_grupo ( nm_usuario_p text, nr_seq_grupo_perfil_p bigint) AS $body$
DECLARE


cd_perfil_w	integer;
				
C01 CURSOR FOR
SELECT	a.cd_perfil
from	grupo_perfil_item a,
	grupo_perfil b
where	a.nr_seq_grupo_perfil =	b.nr_sequencia
and	b.nr_sequencia = nr_seq_grupo_perfil_p
and	not exists (	SELECT	1
			from	grupo_perfil_item c,
				grupo_perfil d,
				usuario_perfil e
			where	c.nr_seq_grupo_perfil =	d.nr_sequencia
			and	e.cd_perfil = c.cd_perfil
			and	d.nr_sequencia	= nr_seq_grupo_perfil_p
			and	e.cd_perfil = a.cd_perfil
			and 	e.nm_usuario	= nm_usuario_p);


BEGIN
open c01;
	loop
	fetch c01 into
		cd_perfil_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */


	insert into usuario_perfil(cd_perfil,
			ds_observacao, 
			dt_atualizacao, 
			dt_validade, 
			nm_usuario, 
			nm_usuario_atual, 
			nr_seq_apres)	
	values (	cd_perfil_w,
			'',
			clock_timestamp(),
			null,
			nm_usuario_p,
			wheb_usuario_pck.get_nm_usuario,
			null
		);
	end loop;
	close c01;

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_perfis_grupo ( nm_usuario_p text, nr_seq_grupo_perfil_p bigint) FROM PUBLIC;

