-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proj_gerar_funcao_equipe ( nr_seq_equipe_p bigint, nr_seq_equipe_funcao_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_funcao_w	bigint;
nr_seq_apres_w	bigint;
nr_sequencia_w	bigint;

c01 CURSOR FOR
	SELECT	nr_sequencia
	from	proj_funcao
	where	nr_seq_equipe_funcao = nr_seq_equipe_funcao_p;


BEGIN

open c01;
loop
Fetch c01 into
	nr_seq_funcao_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	select	nextval('proj_equipe_papel_seq')
	into STRICT	nr_sequencia_w
	;

	select	coalesce(max(nr_seq_apres),0) + 1
	into STRICT	nr_seq_apres_w
	from	proj_equipe_papel
	where	nr_seq_equipe = nr_seq_equipe_p;

	insert into proj_equipe_papel(
		nr_sequencia,
		nr_seq_equipe,
		dt_atualizacao,
		nm_usuario,
		nr_seq_apres,
		nr_seq_funcao,
		ie_situacao,
		IE_ALOCADO_ORIGINAL)
	values (nr_sequencia_w,
		nr_seq_equipe_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_apres_w,
		nr_seq_funcao_w,
		'A',
		'S');
	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE proj_gerar_funcao_equipe ( nr_seq_equipe_p bigint, nr_seq_equipe_funcao_p bigint, nm_usuario_p text) FROM PUBLIC;

