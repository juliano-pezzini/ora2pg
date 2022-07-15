-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE bsc_duplicar_ind_obj ( nr_sequencia_p bigint, qt_indicador_p bigint, cd_ano_p bigint, nr_seq_objetivo_p bigint, nm_usuario_p text, cd_empresa_p bigint, cd_estabelecimento_p bigint) AS $body$
DECLARE


qt_indicador_w			bigint;
nm_indicador_w			varchar(255);
ds_indicador_w			varchar(4000);
ds_formula_w			varchar(4000);
ie_tipo_w			varchar(15);
ie_periodo_w			varchar(15);
nr_seq_medida_w			bigint;
cd_classificacao_w		varchar(40);
ie_regra_result_w		varchar(15);
nr_seq_origem_w			bigint;
nr_seq_superior_w		bigint;
nr_seq_qualif_w			bigint;
cd_ano_limite_w			smallint;
nr_dia_liberacao_w		smallint;
ie_informacao_w			varchar(15);
ie_forma_consol_empresa_w	varchar(15);
cd_setor_atendimento_w		integer;
ie_visualizacao_w		varchar(1);
cd_estab_exclusivo_w		smallint;
ie_forma_calc_w			varchar(1);
vl_max_grafico_w		bigint;
vl_min_grafico_w		bigint;
nr_seq_risco_vinc_w		bigint;
ie_situacao_w			varchar(1);
nr_seq_ind_novo_w		bigint;
cd_pessoa_fisica_w		varchar(10);
dt_inicio_vigencia_w		timestamp;
dt_fim_vigencia_w		timestamp;
ie_receb_comunic_w		varchar(1);
ie_receb_comunic_inf_w		varchar(1);
ie_forma_calculo_w		varchar(15);
ie_operacao_w			varchar(15);
cd_setor_atend_w		integer;
cd_cargo_w			bigint;
cd_perfil_w			bigint;
nr_seq_grupo_usuario_w		bigint;
nm_usuario_lib_w		varchar(15);
ie_permite_w			varchar(1);

-- busca informações do responsável do indicador
c01 CURSOR FOR
SELECT	a.cd_pessoa_fisica,
	a.dt_inicio_vigencia,
	a.dt_fim_vigencia,
	a.ie_receb_comunic,
	a.ie_receb_comunic_inf
from	bsc_ind_resp a
where	a.nr_seq_indicador = nr_sequencia_p;

-- busca informações da regra de sumarização
c02 CURSOR FOR
SELECT	a.ie_forma_calculo,
	a.ie_operacao
from	bsc_ind_regra_inf a
where	a.nr_seq_indicador = nr_sequencia_p;

-- busca informações da regra de liberação
c03 CURSOR FOR
SELECT	a.cd_setor_atendimento,
	a.cd_cargo,
	a.cd_perfil,
	a.nr_seq_grupo_usuario,
	a.nm_usuario_lib,
	a.ie_permite
from	bsc_ind_liberacao a
where	a.nr_seq_indicador = nr_sequencia_p;


BEGIN
if (coalesce(qt_indicador_p,0) > 0) then
	begin
	qt_indicador_w := 0;
	while qt_indicador_w <> qt_indicador_p loop
		begin -- Buscando informações do indicador
		qt_indicador_w := qt_indicador_w + 1;
		select	max(a.nm_indicador),
			max(ds_indicador),
			max(ds_formula),
			max(ie_tipo),
			max(ie_periodo),
			max(nr_seq_medida),
			max(cd_classificacao),
			max(ie_regra_result),
			max(nr_seq_origem),
			max(nr_seq_superior),
			max(nr_seq_qualif),
			max(cd_ano_limite),
			max(nr_dia_liberacao),
			max(ie_informacao),
			max(ie_forma_consol_empresa),
			max(cd_setor_atendimento),
			max(ie_visualizacao),
			max(cd_estab_exclusivo),
			max(ie_forma_calc),
			max(vl_max_grafico),
			max(vl_min_grafico),
			max(nr_seq_risco_vinc),
			max(ie_situacao)
		into STRICT	nm_indicador_w,
			ds_indicador_w,
			ds_formula_w,
			ie_tipo_w,
			ie_periodo_w,
			nr_seq_medida_w,
			cd_classificacao_w,
			ie_regra_result_w,
			nr_seq_origem_w,
			nr_seq_superior_w,
			nr_seq_qualif_w,
			cd_ano_limite_w,
			nr_dia_liberacao_w,
			ie_informacao_w,
			ie_forma_consol_empresa_w,
			cd_setor_atendimento_w,
			ie_visualizacao_w,
			cd_estab_exclusivo_w,
			ie_forma_calc_w,
			vl_max_grafico_w,
			vl_min_grafico_w,
			nr_seq_risco_vinc_w,
			ie_situacao_w
		from	bsc_indicador a
		where	a.nr_sequencia = nr_sequencia_p;
		-- sequência do novo indicador
		select	nextval('bsc_indicador_seq')
		into STRICT	nr_seq_ind_novo_w
		;
		-- Inserindo valor para o novo indiacdor
		insert into bsc_indicador(	nm_indicador,
						ds_indicador,
						ds_formula,
						ie_tipo,
						ie_periodo,
						nr_seq_medida,
						cd_classificacao,
						ie_regra_result,
						nr_seq_origem,
						nr_seq_superior,
						nr_seq_qualif,
						cd_ano_limite,
						nr_dia_liberacao,
						ie_informacao,
						ie_forma_consol_empresa,
						cd_setor_atendimento,
						ie_visualizacao,
						cd_estab_exclusivo,
						ie_forma_calc,
						vl_max_grafico,
						vl_min_grafico,
						nr_seq_risco_vinc,
						ie_situacao,
						nr_sequencia,
						nm_usuario,
						nm_usuario_nrec,
						dt_atualizacao,
						dt_atualizacao_nrec)
					values (	nm_indicador_w,
						ds_indicador_w,
						ds_formula_w,
						ie_tipo_w,
						ie_periodo_w,
						nr_seq_medida_w,
						cd_classificacao_w,
						ie_regra_result_w,
						nr_seq_origem_w,
						nr_seq_superior_w,
						nr_seq_qualif_w,
						cd_ano_limite_w,
						nr_dia_liberacao_w,
						ie_informacao_w,
						ie_forma_consol_empresa_w,
						cd_setor_atendimento_w,
						ie_visualizacao_w,
						cd_estab_exclusivo_w,
						ie_forma_calc_w,
						vl_max_grafico_w,
						vl_min_grafico_w,
						nr_seq_risco_vinc_w,
						ie_situacao_w,
						nr_seq_ind_novo_w,
						nm_usuario_p,
						nm_usuario_p,
						clock_timestamp(),
						clock_timestamp());
		-- inserir Regra de responsável
		open C01;
		loop
		fetch C01 into
			cd_pessoa_fisica_w,
			dt_inicio_vigencia_w,
			dt_fim_vigencia_w,
			ie_receb_comunic_w,
			ie_receb_comunic_inf_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			insert into bsc_ind_resp(	cd_pessoa_fisica,
							dt_inicio_vigencia,
							dt_fim_vigencia,
							ie_receb_comunic,
							ie_receb_comunic_inf,
							nr_seq_indicador,
							nr_sequencia,
							nm_usuario,
							nm_usuario_nrec,
							dt_atualizacao,
							dt_atualizacao_nrec)
						values (	cd_pessoa_fisica_w,
							dt_inicio_vigencia_w,
							dt_fim_vigencia_w,
							ie_receb_comunic_w,
							ie_receb_comunic_inf_w,
							nr_seq_ind_novo_w,
							nextval('bsc_ind_resp_seq'),
							nm_usuario_p,
							nm_usuario_p,
							clock_timestamp(),
							clock_timestamp());
			end;
		end loop;
		close C01;
		-- inserir regra de sumarização
		open C02;
		loop
		fetch C02 into
			ie_forma_calculo_w,
			ie_operacao_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			insert into bsc_ind_regra_inf(	ie_forma_calculo,
							ie_operacao,
							nr_sequencia,
							nr_seq_indicador,
							nm_usuario,
							nm_usuario_nrec,
							dt_atualizacao,
							dt_atualizacao_nrec)
						values (	ie_forma_calculo_w,
							ie_operacao_w,
							nextval('bsc_ind_regra_inf_seq'),
							nr_seq_ind_novo_w,
							nm_usuario_p,
							nm_usuario_p,
							clock_timestamp(),
							clock_timestamp());
			end;
		end loop;
		close C02;
		-- inserir regra de liberação
		open C03;
		loop
		fetch C03 into
			cd_setor_atend_w,
			cd_cargo_w,
			cd_perfil_w,
			nr_seq_grupo_usuario_w,
			nm_usuario_lib_w,
			ie_permite_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin
			insert into bsc_ind_liberacao(	cd_setor_atendimento,
							cd_cargo,
							cd_perfil,
							nr_seq_grupo_usuario,
							nm_usuario_lib,
							ie_permite,
							nm_usuario,
							nm_usuario_nrec,
							dt_atualizacao,
							dt_atualizacao_nrec,
							nr_sequencia,
							nr_seq_indicador)
						values (	cd_setor_atend_w,
							cd_cargo_w,
							cd_perfil_w,
							nr_seq_grupo_usuario_w,
							nm_usuario_lib_w,
							ie_permite_w,
							nm_usuario_p,
							nm_usuario_p,
							clock_timestamp(),
							clock_timestamp(),
							nextval('bsc_ind_liberacao_seq'),
							nr_seq_ind_novo_w);
			end;
		end loop;
		close C03;
		-- gerar informação ano do indicador
		CALL bsc_gerar_inf_indicador(cd_empresa_p,cd_estabelecimento_p,nr_seq_ind_novo_w,0,cd_ano_p,nm_usuario_p);
		-- Vincular indicador ao objetivo (plano de ação)
		insert into bsc_ind_obj(	dt_atualizacao,
						dt_atualizacao_nrec,
						nm_usuario,
						nm_usuario_nrec,
						nr_seq_indicador,
						nr_seq_objetivo,
						nr_sequencia)
					values (	clock_timestamp(),
						clock_timestamp(),
						nm_usuario_p,
						nm_usuario_p,
						nr_seq_ind_novo_w,
						nr_seq_objetivo_p,
						nextval('bsc_ind_obj_seq'));
		end;
	end loop;
	commit;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE bsc_duplicar_ind_obj ( nr_sequencia_p bigint, qt_indicador_p bigint, cd_ano_p bigint, nr_seq_objetivo_p bigint, nm_usuario_p text, cd_empresa_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;

