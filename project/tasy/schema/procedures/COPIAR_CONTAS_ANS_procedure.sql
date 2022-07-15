-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_contas_ans ( nr_seq_versao_ans_destino_p bigint, nm_usuario_p text, cd_empresa_p bigint) AS $body$
DECLARE


cd_conta_contabil_w		varchar(20);
cd_classificacao_w		varchar(40);
ds_conta_contabil_w		varchar(255);
ie_tipo_w			varchar(1);
cd_empresa_w  			smallint;
nr_seq_conta_ans_w		bigint;
nr_sequencia_w			bigint;
qt_registros_w			bigint;
contador_w			bigint := 0;

c01 CURSOR FOR
SELECT 	cd_conta_contabil,
	cd_classificacao,
	ds_conta_contabil,
	ie_tipo,
	cd_empresa
from	conta_contabil
where   cd_empresa = cd_empresa_p
and     ie_situacao = 'A';


BEGIN

open C01;
loop
fetch C01 into
	cd_conta_contabil_w,
	cd_classificacao_w,
	ds_conta_contabil_w,
	ie_tipo_w,
	cd_empresa_w;

EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	contador_w := contador_w + 1;

	select 	nextval('ctb_plano_ans_seq')
	into STRICT	nr_seq_conta_ans_w
	;

	select 	count(*)
	into STRICT	qt_registros_w
	from	ctb_plano_ans
	where 	cd_empresa		= cd_empresa_w
	and	cd_plano 		= somente_numero(substr(cd_conta_contabil_w, 1, 10))
	and	nr_seq_versao_plano 	= nr_seq_versao_ans_destino_p;

	if (qt_registros_w = 0) then
		begin
		insert into ctb_plano_ans(	nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						cd_plano,
						cd_classificacao,
						ds_conta,
						ie_tipo,
						cd_empresa,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_seq_versao_plano)
				values (	nr_seq_conta_ans_w,
						clock_timestamp(),
						nm_usuario_p,
						somente_numero(substr(cd_conta_contabil_w, 1, 10)),
						cd_classificacao_w,
						substr(ds_conta_contabil_w, 1, 255),
						CASE WHEN ie_tipo_w='A' THEN  1 WHEN ie_tipo_w='T' THEN  3 END ,
						cd_empresa_w,
						clock_timestamp(),
						nm_usuario_p,
						nr_seq_versao_ans_destino_p);

		select	count(*)
		into STRICT	qt_registros_w
		from	conta_contabil_ans c,
			ctb_plano_ans p
		where	c.nr_seq_conta_ans 	= p.nr_sequencia
		and	c.cd_empresa		= cd_empresa_p
		and	c.cd_plano 		= somente_numero(substr(cd_conta_contabil_w, 1, 10))
		and	p.nr_seq_versao_plano 	= nr_seq_versao_ans_destino_p;

		if (not qt_registros_w > 0) then

			insert into conta_contabil_ans(	nr_sequencia,
							dt_atualizacao,
							nm_usuario,
							dt_atualizacao_nrec,
							nm_usuario_nrec,
							cd_conta_contabil,
							cd_empresa,
							cd_plano,
							nr_seq_conta_ans)
					values (	nextval('conta_contabil_ans_seq'),
							clock_timestamp(),
							nm_usuario_p,
							clock_timestamp(),
							nm_usuario_p,
							cd_conta_contabil_w,
							cd_empresa_w,
							somente_numero(substr(cd_conta_contabil_w, 1, 10)),
							nr_seq_conta_ans_w);

		end if;
		end;

	end if;

	if (mod(contador_w,100) = 0) then
		commit;
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
-- REVOKE ALL ON PROCEDURE copiar_contas_ans ( nr_seq_versao_ans_destino_p bigint, nm_usuario_p text, cd_empresa_p bigint) FROM PUBLIC;

