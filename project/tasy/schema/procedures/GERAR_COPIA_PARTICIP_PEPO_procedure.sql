-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_copia_particip_pepo ( nr_cirurgia_p bigint, nr_seq_cola_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w		bigint;
nr_seq_interno_w		bigint;
ie_funcao_w		varchar(10);
cd_pessoa_fisica_w	varchar(10);
dt_entrada_w		timestamp;
dt_saida_w		timestamp;

ie_igual_w   varchar(1);

C01 CURSOR FOR
	SELECT	ie_funcao, cd_pessoa_fisica, dt_entrada, dt_saida
	from	cirurgia_participante
	where	(cd_pessoa_fisica IS NOT NULL AND cd_pessoa_fisica::text <> '')
	and	nr_cirurgia = nr_cirurgia_p;


BEGIN


open C01;
loop
fetch C01 into
	ie_funcao_w,
	cd_pessoa_fisica_w,
	dt_entrada_w,
	dt_saida_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	coalesce(max(nr_sequencia),0) + 1
	into STRICT	nr_sequencia_w
	from 	cirurgia_participante;

	select 	nextval('cirurgia_participante_seq')
	into STRICT	nr_seq_interno_w
	;

	select	coalesce(max('S'),'N')
	into STRICT	ie_igual_w
	from 	cirurgia_participante
	where	nr_cirurgia = nr_seq_cola_p
	and	cd_pessoa_fisica = cd_pessoa_fisica_w;


	if (ie_igual_w = 'N') then

		insert 	into cirurgia_participante(nr_sequencia,
				nr_cirurgia,
				ie_funcao,
				nm_usuario,
				dt_atualizacao,
				nm_usuario_nrec,
				dt_atualizacao_nrec,
				dt_entrada,
				dt_saida,
				cd_pessoa_fisica,
				nr_seq_interno)
		values (nr_sequencia_w,
				nr_seq_cola_p,
				ie_funcao_w,
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				dt_entrada_w,
				dt_saida_w,
				cd_pessoa_fisica_w,
				nr_seq_interno_w);

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
-- REVOKE ALL ON PROCEDURE gerar_copia_particip_pepo ( nr_cirurgia_p bigint, nr_seq_cola_p bigint, nm_usuario_p text) FROM PUBLIC;

