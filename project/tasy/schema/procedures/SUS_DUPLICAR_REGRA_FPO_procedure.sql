-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_duplicar_regra_fpo ( cd_estabelecimento_p bigint, cd_estabelecimento_destino_p bigint, dt_competencia_origem_p timestamp, dt_competencia_destino_p timestamp, nm_usuario_p text, ie_tipo_atendimento_p bigint) AS $body$
DECLARE


nr_seq_fpo_regra_dest_w		bigint;
nr_seq_fpo_regra_orig_w		bigint;

c01 CURSOR FOR
	SELECT	*
	from	sus_fpo_regra
	where	trunc(dt_competencia)	= trunc(dt_competencia_origem_p)
	and	cd_estabelecimento		= cd_estabelecimento_p
	and	((obter_se_contido(ie_tipo_atendimento_p,ie_tipo_atendimento) = 'S')
						or (coalesce(ie_tipo_atendimento_p,0) = 0))
	order by nr_sequencia;

c02 CURSOR FOR
	SELECT 	*
	from	sus_fpo_regra_desconsid
	where	nr_seq_fpo_regra 	= nr_seq_fpo_regra_orig_w
	order by nr_sequencia;

c03 CURSOR FOR
	SELECT	*
	from	sus_fpo_regra_cbo
	where	nr_seq_fpo_regra 	= nr_seq_fpo_regra_orig_w
	order by nr_sequencia;

c04 CURSOR FOR
	SELECT	*
	from	sus_fpo_regra_proc
	where	nr_seq_regra	= nr_seq_fpo_regra_orig_w
	order by nr_sequencia;

c05 CURSOR FOR
	SELECT	*
	from	sus_fpo_regra_setor
	where	nr_seq_regra	= nr_seq_fpo_regra_orig_w
	order by nr_sequencia;

c01_w	c01%rowtype;
c02_w	c02%rowtype;
c03_w	c03%rowtype;
c04_w	c04%rowtype;
c05_w	c05%rowtype;


BEGIN
open c01;
loop
fetch c01 into
	c01_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	select	nextval('sus_fpo_regra_seq')
	into STRICT	nr_seq_fpo_regra_dest_w
	;

	nr_seq_fpo_regra_orig_w	:= c01_w.nr_sequencia;

	insert into sus_fpo_regra( 	nr_sequencia,
				cd_estabelecimento,
				dt_competencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				cd_procedimento,
				ie_origem_proced,
				nr_seq_grupo,
				nr_seq_subgrupo,
				nr_seq_forma_org,
				qt_fisico,
				vl_orcamento,
				ie_tipo_atendimento,
				ie_tipo_financiamento,
				ie_complexidade,
				cd_carater_internacao,
				nm_usuario_resp,
				ds_observacao,
				cd_cbo,
				ie_situacao,
				nr_seq_estrutura_regra,
				cd_procedencia,
				nr_seq_forma_visual)
			values (	nr_seq_fpo_regra_dest_w,
				coalesce(cd_estabelecimento_destino_p,cd_estabelecimento_p),
				dt_competencia_destino_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				c01_w.cd_procedimento,
				c01_w.ie_origem_proced,
				c01_w.nr_seq_grupo,
				c01_w.nr_seq_subgrupo,
				c01_w.nr_seq_forma_org,
				c01_w.qt_fisico,
				c01_w.vl_orcamento,
				c01_w.ie_tipo_atendimento,
				c01_w.ie_tipo_financiamento,
				c01_w.ie_complexidade,
				c01_w.cd_carater_internacao,
				c01_w.nm_usuario_resp,
				c01_w.ds_observacao,
				c01_w.cd_cbo,
				coalesce(c01_w.ie_situacao,'A'),
				c01_w.nr_seq_estrutura_regra,
				c01_w.cd_procedencia,
				c01_w.nr_seq_forma_visual);

	open c02;
	loop
	fetch c02 into
		c02_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin

		insert into sus_fpo_regra_desconsid(		nr_sequencia,
							nr_seq_fpo_regra,
							dt_atualizacao,
							nm_usuario,
							dt_atualizacao_nrec,
							nm_usuario_nrec,
							nr_seq_grupo,
							nr_seq_subgrupo,
							nr_seq_forma_org,
							cd_cbo,
							cd_procedimento,
							ie_origem_proced)
						values (	nextval('sus_fpo_regra_desconsid_seq'),
							nr_seq_fpo_regra_dest_w,
							clock_timestamp(),
							nm_usuario_p,
							clock_timestamp(),
							nm_usuario_p,
							c02_w.nr_seq_grupo,
							c02_w.nr_seq_subgrupo,
							c02_w.nr_seq_forma_org,
							c02_w.cd_cbo,
							c02_w.cd_procedimento,
							c02_w.ie_origem_proced);

		end;
	end loop;
	close c02;

	open c03;
	loop
	fetch c03 into
		c03_w;
	EXIT WHEN NOT FOUND; /* apply on c03 */
		begin

		insert into sus_fpo_regra_cbo(	nr_sequencia,
						nr_seq_fpo_regra,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						cd_cbo)
					values (	nextval('sus_fpo_regra_cbo_seq'),
						nr_seq_fpo_regra_dest_w,
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						c03_w.cd_cbo);

		end;
	end loop;
	close c03;

	open c04;
	loop
	fetch c04 into
		c04_w;
	EXIT WHEN NOT FOUND; /* apply on c04 */
		begin

		insert into sus_fpo_regra_proc(	nr_sequencia,
						nr_seq_regra,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						cd_procedimento,
						ie_origem_proced,
						ie_situacao)
					values (	nextval('sus_fpo_regra_proc_seq'),
						nr_seq_fpo_regra_dest_w,
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						c04_w.cd_procedimento,
						c04_w.ie_origem_proced,
						coalesce(c04_w.ie_situacao,'A'));

		end;
	end loop;
	close c04;

	open c05;
	loop
	fetch c05 into
		c05_w;
	EXIT WHEN NOT FOUND; /* apply on c05 */
		begin

		insert into sus_fpo_regra_setor(	nr_sequencia,
						nr_seq_regra,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						cd_setor_atendimento,
						ie_situacao)
					values (	nextval('sus_fpo_regra_setor_seq'),
						nr_seq_fpo_regra_dest_w,
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						c05_w.cd_setor_atendimento,
						coalesce(c05_w.ie_situacao,'A'));

		end;
	end loop;
	close c05;

	end;
end loop;
close c01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_duplicar_regra_fpo ( cd_estabelecimento_p bigint, cd_estabelecimento_destino_p bigint, dt_competencia_origem_p timestamp, dt_competencia_destino_p timestamp, nm_usuario_p text, ie_tipo_atendimento_p bigint) FROM PUBLIC;

