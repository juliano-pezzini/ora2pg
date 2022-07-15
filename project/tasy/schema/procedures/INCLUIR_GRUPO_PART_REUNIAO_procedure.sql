-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE incluir_grupo_part_reuniao ( nr_seq_reuniao_p bigint, nr_seq_grupo_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


cd_pessoa_fisica_w			varchar(10);

C01 CURSOR FOR
	SELECT	a.cd_pessoa_fisica
	from	usuario		a,
		usuario_grupo	b
	where	a.nm_usuario	= b.nm_usuario_grupo
	and	b.nr_seq_grupo	= nr_seq_grupo_p;

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ X]  Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
BEGIN
open C01;
loop
fetch C01 into
	cd_pessoa_fisica_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	insert into ata_participante(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_reuniao,
		cd_pessoa_participante,
		ie_faltou)
	values (nextval('ata_participante_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_reuniao_p,
		cd_pessoa_fisica_w,
		'N');
	end;
end loop;
close C01;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE incluir_grupo_part_reuniao ( nr_seq_reuniao_p bigint, nr_seq_grupo_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

