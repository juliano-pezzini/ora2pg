-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ple_duplicar_edicao ( nr_seq_edicao_origem_p bigint, nr_seq_edicao_destino_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_empresa_w			smallint;
cd_pf_resp_w			varchar(10);
ds_classificacao_w			varchar(80);
ds_titulo_w			varchar(255);
ds_tema_w			varchar(4000);
ds_objetivo_w			varchar(4000);
nr_seq_classif_w			bigint;
nr_seq_classif_ww			bigint;
nr_seq_edicao_classif_w		bigint;
nr_seq_estagio_w			bigint;
nr_seq_indicador_w			bigint;
nr_seq_objetivo_w			bigint;
nr_seq_objetivo_ww		bigint;
nr_seq_tema_w			bigint;
nr_seq_tema_ww			bigint;
nr_grupo_trabalho_w		bigint;
nr_grupo_planej_w			bigint;
nr_seq_apres_w			bigint;
nr_seq_apres_obj_w		bigint;
pr_partic_pe_w			double precision;
qt_registro_w			bigint;
qt_tema_w			bigint;


c01 CURSOR FOR
SELECT	a.nr_sequencia,
	a.cd_empresa,
	a.ds_classificacao,
	a.nr_seq_estagio,
	a.nr_grupo_trabalho,
	a.nr_grupo_planej,
	a.nr_seq_apres,
	a.nr_seq_edicao
from	ple_classificacao a
where	a.nr_seq_edicao		= nr_seq_edicao_origem_p;

C02 CURSOR FOR
SELECT	a.nr_sequencia,
	a.ds_titulo,
	a.ds_tema
from	bsc_tema_estrategico a
where	a.nr_seq_perspectiva	= nr_seq_classif_w;


C03 CURSOR FOR
SELECT	a.nr_sequencia,
	a.ds_objetivo,
	a.nr_seq_apres,
	a.pr_partic_pe,
	a.cd_pf_resp
from	ple_objetivo a
where	a.nr_seq_classif		= nr_seq_classif_w
and	a.ie_situacao		= 'A'
and	a.nr_seq_edicao		= nr_seq_edicao_origem_p
and	coalesce(a.nr_seq_tema, 0)	= coalesce(nr_seq_tema_w, coalesce(a.nr_seq_tema, 0));


C04 CURSOR FOR
SELECT	a.nr_seq_indicador
from	bsc_ind_obj a
where	a.nr_seq_objetivo		= nr_seq_objetivo_w;

C05 CURSOR FOR
SELECT	a.nr_sequencia,
	a.nr_seq_objetivo,
	a.ds_meta,
	a.qt_meta,
	a.dt_limite,
	a.cd_pf_resp,
	a.vl_custo,
	a.vl_meta,
	a.nr_seq_apres
from	ple_meta a
where	a.nr_seq_objetivo		= nr_seq_objetivo_w;

vet05	c05%rowtype;


BEGIN

select	count(*)
into STRICT	qt_registro_w
from	ple_objetivo
where	nr_seq_edicao		= nr_seq_edicao_destino_p;

if (qt_registro_w > 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(282226);
end if;

open C01;
loop
fetch C01 into
	nr_seq_classif_w,
	cd_empresa_w,
	ds_classificacao_w,
	nr_seq_estagio_w,
	nr_grupo_trabalho_w,
	nr_grupo_planej_w,
	nr_seq_apres_w,
	nr_seq_edicao_classif_w;
EXIT WHEN NOT FOUND; /* apply on C01 */

	select	nextval('ple_classificacao_seq')
	into STRICT	nr_seq_classif_ww
	;

	insert into ple_classificacao(
		nr_sequencia,
		cd_empresa,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ds_classificacao,
		ie_situacao,
		nr_seq_estagio,
		nr_grupo_trabalho,
		nr_grupo_planej,
		nr_seq_apres,
		nr_seq_edicao)
	values (	nr_seq_classif_ww,
		cd_empresa_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		ds_classificacao_w,
		'A',
		nr_seq_estagio_w,
		nr_grupo_trabalho_w,
		nr_grupo_planej_w,
		nr_seq_apres_w,
		nr_seq_edicao_destino_p);

	select	count(*)
	into STRICT	qt_tema_w
	from	bsc_tema_estrategico
	where	nr_seq_perspectiva	= nr_seq_classif_w;

	if (qt_tema_w > 0) then
		begin

		open C02;
		loop
		fetch C02 into
			nr_seq_tema_w,
			ds_titulo_w,
			ds_tema_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */

			select	nextval('bsc_tema_estrategico_seq')
			into STRICT	nr_seq_tema_ww
			;

			insert into bsc_tema_estrategico(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				ds_titulo,
				nr_seq_perspectiva,
				ds_tema)
			values (	nr_seq_tema_ww,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				ds_titulo_w,
				nr_seq_classif_ww,
				ds_tema_w);

			open C03;
			loop
			fetch C03 into
				nr_seq_objetivo_w,
				ds_objetivo_w,
				nr_seq_apres_obj_w,
				pr_partic_pe_w,
				cd_pf_resp_w;
			EXIT WHEN NOT FOUND; /* apply on C03 */

				select	nextval('ple_objetivo_seq')
				into STRICT	nr_seq_objetivo_ww
				;

				insert into ple_objetivo(
					nr_sequencia,
					nr_seq_edicao,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					ds_objetivo,
					nr_seq_apres,
					nr_seq_classif,
					nr_seq_tema,
					pr_partic_pe,
					cd_pf_resp,
					ie_situacao)
				values (	nr_seq_objetivo_ww,
					nr_seq_edicao_destino_p,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					ds_objetivo_w,
					nr_seq_apres_obj_w,
					nr_seq_classif_ww,
					nr_seq_tema_ww,
					pr_partic_pe_w,
					cd_pf_resp_w,
					'A');

				open C04;
				loop
				fetch C04 into
					nr_seq_indicador_w;
				EXIT WHEN NOT FOUND; /* apply on C04 */

					insert into bsc_ind_obj(
						nr_sequencia,
						nr_seq_objetivo,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_seq_indicador)
					values (	nextval('bsc_ind_obj_seq'),
						nr_seq_objetivo_ww,
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						nr_seq_indicador_w);

				end loop;
				close C04;
			end loop;
			close C03;


		end loop;
		close C02;

		end;
	else

	/*Porque nao é necessário possuir TEMA*/

	nr_seq_tema_w	:= null;
	open C03;
	loop
	fetch C03 into
		nr_seq_objetivo_w,
		ds_objetivo_w,
		nr_seq_apres_obj_w,
		pr_partic_pe_w,
		cd_pf_resp_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */

		select	nextval('ple_objetivo_seq')
		into STRICT	nr_seq_objetivo_ww
		;

		insert into ple_objetivo(
			nr_sequencia,
			nr_seq_edicao,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			ds_objetivo,
			nr_seq_apres,
			nr_seq_classif,
			nr_seq_tema,
			pr_partic_pe,
			cd_pf_resp,
			ie_situacao)
		values (	nr_seq_objetivo_ww,
			nr_seq_edicao_destino_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			ds_objetivo_w,
			nr_seq_apres_obj_w,
			nr_seq_classif_ww,
			nr_seq_tema_ww,
			pr_partic_pe_w,
			cd_pf_resp_w,
			'A');

		open C05;
		loop
		fetch C05 into
			vet05;
		EXIT WHEN NOT FOUND; /* apply on C05 */
			begin

			insert into ple_meta(
				nr_sequencia,
				nr_seq_objetivo,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				ds_meta,
				qt_meta,
				dt_limite,
				cd_pf_resp,
				vl_custo,
				vl_meta,
				nr_seq_apres)
			values (	nextval('ple_meta_seq'),
				nr_seq_objetivo_ww,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				vet05.ds_meta,
				vet05.qt_meta,
				vet05.dt_limite,
				vet05.cd_pf_resp,
				vet05.vl_custo,
				vet05.vl_meta,
				vet05.nr_seq_apres);


			end;
		end loop;
		close C05;
	end loop;
	close C03;

	end if;

end loop;
close C01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ple_duplicar_edicao ( nr_seq_edicao_origem_p bigint, nr_seq_edicao_destino_p bigint, nm_usuario_p text) FROM PUBLIC;

