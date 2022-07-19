-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tre_duplicar_treinamento ( nr_seq_curso_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_curso_w			bigint;
nr_seq_modulo_w			bigint;
nr_seq_novo_w			bigint;
ds_modulo_w				varchar(80);
qt_carga_horaria_w		double precision;
ie_obrigatorio_w		varchar(01);
qt_min_carga_w			double precision;

C01 CURSOR FOR
	SELECT	nr_sequencia,
			ds_modulo,
			qt_carga_horaria,
			ie_obrigatorio,
			qt_min_carga
	from	tre_curso_modulo
	where	nr_seq_curso	= nr_seq_curso_p;


BEGIN

select	nextval('tre_curso_seq')
into STRICT	nr_seq_curso_w
;

insert 	into tre_curso(nr_sequencia,
	cd_empresa,
	nr_seq_tipo,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	ie_situacao,
	ds_curso,
	dt_liberacao,
	cd_estabelecimento)
(SELECT	nr_seq_curso_w,
	cd_empresa,
	nr_seq_tipo,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	'A',
	obter_desc_expressao(342086)/*'Cópia - '*/
 || ds_curso,
	null,
	coalesce(cd_estabelecimento,wheb_usuario_pck.get_cd_estabelecimento)
from	tre_curso
where	nr_sequencia	= nr_seq_curso_p);

insert	into tre_curso_regra(nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	cd_setor_atendimento,
	nr_seq_curso,
	cd_perfil,
	cd_cargo)
(SELECT	nextval('tre_curso_regra_seq'),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	cd_setor_atendimento,
	nr_seq_curso_w,
	cd_perfil,
	cd_cargo
from	tre_curso_regra
where	nr_seq_curso	= nr_seq_curso_p);

insert	into tre_curso_anexo(nr_sequencia,
	nr_seq_curso,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	ds_arquivo)
(SELECT	nextval('tre_curso_anexo_seq'),
	nr_seq_curso_w,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	ds_arquivo
from	tre_curso_anexo
where	nr_seq_curso	= nr_seq_curso_p);

open C01;
loop
fetch C01 into
	nr_seq_modulo_w,
	ds_modulo_w,
	qt_carga_horaria_w,
	ie_obrigatorio_w,
	qt_min_carga_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	nextval('tre_curso_modulo_seq')
	into STRICT	nr_seq_novo_w
	;

	insert	into tre_curso_modulo(nr_sequencia,
		nr_seq_curso,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ds_modulo,
		qt_carga_horaria,
		ie_obrigatorio,
		qt_min_carga)
	values (nr_seq_novo_w,
		nr_seq_curso_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		ds_modulo_w,
		qt_carga_horaria_w,
		ie_obrigatorio_w,
		qt_min_carga_w);

	insert	into tre_curso_conteudo(nr_sequencia,
		nr_seq_modulo,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_apres,
		ds_conteudo,
		ds_titulo)
	(SELECT	nextval('tre_curso_conteudo_seq'),
		nr_seq_novo_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_apres,
		ds_conteudo,
		ds_titulo
	from	tre_curso_conteudo
	where	nr_seq_modulo	= nr_seq_modulo_w);

	end;
end loop;
close C01;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tre_duplicar_treinamento ( nr_seq_curso_p bigint, nm_usuario_p text) FROM PUBLIC;

