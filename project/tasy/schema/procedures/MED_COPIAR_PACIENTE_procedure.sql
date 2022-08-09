-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE med_copiar_paciente ( cd_medico_origem_p text, cd_medico_destino_p text, nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_teste		bigint;
nr_seq_cliente_w	bigint;
nr_seq_cliente_ant_w	bigint;
nr_seq_pedido_v_w	bigint;
nr_seq_pedido_n_w	bigint;
cd_pessoa_sist_orig_w	varchar(10);
dt_solicitacao_w	timestamp;
ds_solicitacao_w	text;
dt_atualizacao_w	timestamp;
nm_usuario_w		varchar(15);
ds_dados_clinicos_w	varchar(255);
cd_exame_w		varchar(255);
nr_atendimento_w	bigint;
ds_exame_ant_w		varchar(255);
ie_ficha_unimed_w	varchar(1);
ds_cid_w		varchar(4000);
ds_diagnostico_cid_w	varchar(4000);
ds_justificativa_w	varchar(255);
ie_carater_solic_w	varchar(1);
ie_data_w		varchar(1);
dt_texto_w		timestamp;
ds_texto_w		text;
dt_parecer_w		timestamp;
ds_parecer_w		text;
cd_medico_w		varchar(10);
dt_atualizacao_nrec_w	timestamp;
nm_usuario_nrec_w	varchar(15);
dt_evolucao_w		timestamp;
ds_evolucao_w		text;
qt_peso_w		double precision;
qt_imc_w		double precision;
qt_variacao_peso_w	double precision;
qt_altura_cm_w		double precision;
qt_superf_corporal_w	double precision;
cd_evol_tasy_w		bigint;
qt_pa_sistolica_w	bigint;
qt_pa_diastolica_w	bigint;
qt_temp_w		double precision;
qt_perimetro_cefalico_w	double precision;
qt_ca_w			double precision;
nr_seq_tipo_evolucao_w	bigint;
nr_seq_pac_ginec_w	bigint;
nr_seq_pac_pre_natal_w	bigint;
nr_seq_pac_pre_natal_evol_w bigint;
dt_receita_w		timestamp;
ds_receita_w		text;
nr_atendimento_hosp_w	bigint;
cd_pessoa_fisica_w	varchar(10);
dt_liberacao_w		timestamp;
ie_tipo_receita_w	varchar(15);
ie_situacao_w		varchar(1);
dt_inativacao_w		timestamp;
nm_usuario_inativacao_w	varchar(15);
cd_perfil_ativo_w	bigint;
nr_seq_tipo_exame_w	bigint;
dt_exame_w		timestamp;
ds_exame_w		text;
dt_atestado_w		timestamp;
ds_atestado_w		text;
qt_dia_w		bigint;
dt_final_w		timestamp;
cd_cid_atestado_w	varchar(10);
cd_especialidade_w	bigint;
cd_profissao_w		bigint;
cd_setor_w		bigint;
dt_primeira_consulta_w	timestamp;
dt_ultima_consulta_w	timestamp;
dt_ultima_atualiz_w	timestamp;
cd_usuario_convenio_w	varchar(30);
ds_encaminhamento_w	varchar(40);
dt_validade_carteira_w	timestamp;
ie_ficha_papel_w	varchar(1);
ie_exame_consultorio_w	varchar(1);
dt_ultima_visualiz_w	timestamp;
ie_exame_virtual_w	varchar(1);
nr_seq_plano_w		bigint;
ds_observacao_w		varchar(2000);
nr_seq_classif_w	bigint;
ie_gemelar_w		varchar(1);
ie_pais_separados_w	varchar(1);
ie_todos_w		varchar(1):= 'X';
dt_entrada_w		timestamp;
cd_convenio_w		bigint;
dt_saida_w		timestamp;
nr_atend_original_w	bigint;
nr_seq_agenda_w		bigint;
dt_inicio_consulta_w	timestamp;
ie_grau_satisfacao_w	varchar(1);
ie_tipo_consulta_w	bigint;
ie_tipo_saida_consulta_w	bigint;
ie_tipo_atend_tiss_w	varchar(15);
nr_atendimento_ant_w	bigint;
nr_seq_origem_w		bigint;
nr_seq_exame_w		bigint;
ds_valor_exame_w	varchar(255);
vl_exame_w		double precision;
nr_seq_laborat_w	bigint;
ie_tipo_resultado_w	varchar(1);
cd_item_result_w	varchar(3);
ie_realizou_w		varchar(3);
ie_valido_w		varchar(1);
nr_prescricao_w		bigint;
nr_seq_prescricao_w	bigint;
nr_seq_exame_lab_w	bigint;
nr_seq_med_evolucao_w	bigint;
nr_seq_med_texto_w	bigint;
nr_seq_med_receita_w	bigint;
nr_seq_med_exa_aval_w	bigint;
nr_seq_med_atestado_w   bigint;
nr_seq_med_parecer_medico_w bigint;
ie_possui_med_cliente_w	varchar(1);

C00 CURSOR FOR
	SELECT	nr_sequencia,
		cd_medico,
		cd_pessoa_fisica,
		nm_usuario,
		ie_situacao,
		dt_primeira_consulta,
		dt_ultima_consulta,
		dt_ultima_atualiz,
		cd_pessoa_sist_orig,
		cd_convenio,
		cd_usuario_convenio,
		ds_encaminhamento,
		dt_validade_carteira,
		ie_ficha_papel,
		ie_exame_consultorio,
		dt_ultima_visualiz,
		ie_exame_virtual,
		nr_seq_plano,
		ds_observacao,
		nr_seq_classif,
		ie_gemelar,
		ie_pais_separados,
		dt_atualizacao
	from	med_cliente
	where	(ie_todos_w = 'N' AND nr_sequencia = nr_sequencia_p)
	or	(ie_todos_w = 'S' AND cd_medico    =	cd_medico_origem_p)
	order by nr_sequencia;

C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.dt_solicitacao,
		a.ds_solicitacao,
		a.dt_atualizacao,
		a.nm_usuario,
		a.ds_dados_clinicos,
		a.cd_exame,
		a.ds_exame_ant,
		a.ie_ficha_unimed,
		a.ds_cid,
		a.ds_diagnostico_cid,
		a.ds_justificativa,
		a.ie_carater_solic,
		a.ie_data
	from 	med_pedido_exame a
	where	a.nr_seq_cliente = nr_seq_cliente_ant_w
	and	not exists (SELECT 1 from med_pedido_exame b where b.nr_seq_origem =  a.nr_sequencia);



C02 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.dt_atualizacao,
		a.nm_usuario,
		a.dt_texto,
		a.ds_texto
	from	med_texto_adicional a
	where	a.nr_seq_cliente = nr_seq_cliente_ant_w
	and	not exists (SELECT 1 from med_pedido_exame b where b.nr_seq_origem =  a.nr_sequencia);


C03 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.dt_atualizacao,
		a.nm_usuario,
		a.dt_parecer,
		a.ds_parecer,
		a.cd_medico,
		a.dt_atualizacao_nrec,
		a.nm_usuario_nrec
	from	med_parecer_medico a
	where	a.nr_seq_cliente = nr_seq_cliente_ant_w
	and	not exists (SELECT 1 from med_pedido_exame b where b.nr_seq_origem =  a.nr_sequencia);


C04 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.dt_atualizacao,
		a.nm_usuario,
		a.dt_evolucao,
		--a.ds_evolucao,
		a.qt_peso,
		a.qt_imc,
		a.qt_variacao_peso,
		a.qt_altura_cm,
		a.qt_superf_corporal,
		a.qt_pa_sistolica,
		a.qt_pa_diastolica,
		a.qt_temp,
		a.qt_perimetro_cefalico,
		a.qt_ca,
		a.nr_seq_tipo_evolucao,
		a.nr_seq_pac_ginec,
		a.nr_seq_pac_pre_natal,
		a.nr_seq_pac_pre_natal_evol
	from	med_evolucao a
	where	a.nr_seq_cliente = nr_seq_cliente_ant_w
	and	not exists (SELECT 1 from med_pedido_exame b where b.nr_seq_origem =  a.nr_sequencia);


C05 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.dt_atualizacao,
		a.nm_usuario,
		a.dt_receita,
		a.ds_receita,
		a.nr_atendimento_hosp,
		a.cd_pessoa_fisica,
		a.cd_medico,
		a.dt_liberacao,
		a.ie_tipo_receita,
		a.ie_situacao,
		a.dt_inativacao,
		a.nm_usuario_inativacao,
		a.ds_justificativa,
		a.cd_perfil_ativo
	from	med_receita a
	where	a.nr_seq_cliente = nr_seq_cliente_ant_w
	and	not exists (SELECT 1 from med_pedido_exame b where b.nr_seq_origem =  a.nr_sequencia);


C06 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.nr_seq_tipo_exame,
		a.dt_atualizacao,
		a.nm_usuario,
		a.dt_exame,
		a.ds_exame
	from	med_exame_avaliacao a
	where	a.nr_seq_cliente = nr_seq_cliente_ant_w
	and	not exists (SELECT 1 from med_pedido_exame b where b.nr_seq_origem =  a.nr_sequencia);


C07 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.dt_atestado,
		a.dt_atualizacao,
		a.nm_usuario,
		a.ds_atestado,
		a.qt_dia,
		a.dt_final,
		a.cd_cid_atestado,
		a.cd_especialidade,
		a.cd_profissao,
		a.cd_setor,
		a.dt_atualizacao_nrec,
		a.nm_usuario_nrec
	from	med_atestado a
	where	a.nr_seq_cliente = nr_seq_cliente_ant_w
	and	not exists (SELECT 1 from med_pedido_exame b where b.nr_seq_origem =  a.nr_sequencia);

C08 CURSOR FOR
	SELECT	nr_atendimento,
		dt_atualizacao,
		nm_usuario,
		dt_entrada,
		cd_convenio,
		dt_saida,
		nr_atend_original,
		cd_usuario_convenio,
		dt_validade_carteira,
		nr_seq_agenda,
		dt_inicio_consulta,
		ie_grau_satisfacao,
		nr_seq_plano,
		ie_tipo_consulta,
		ie_tipo_saida_consulta,
		ie_tipo_atend_tiss
	from	med_atendimento
	where	nr_seq_cliente = nr_seq_cliente_ant_w;

C09 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.nr_seq_exame,
		a.dt_exame,
		a.dt_atualizacao,
		a.nm_usuario,
		a.ds_valor_exame,
		a.vl_exame,
		a.nr_seq_laborat,
		a.ie_tipo_resultado,
		a.cd_item_result,
		a.ie_realizou,
		a.dt_atualizacao_nrec,
		a.nm_usuario_nrec,
		a.ie_valido,
		a.nr_prescricao,
		a.nr_seq_prescricao,
		a.nr_seq_exame_lab
	from	med_result_exame a
	where	a.nr_seq_cliente = nr_seq_cliente_ant_w
	and	not exists (SELECT 1 from med_pedido_exame b where b.nr_seq_origem =  a.nr_sequencia);






BEGIN
--begin
if (nr_sequencia_p > 0) and (cd_medico_destino_p > 0) then
	ie_todos_w := 'N';
elsif (cd_medico_origem_p > 0) and (cd_medico_destino_p > 0) then
	ie_todos_w := 'S';
end if;

open C00;
loop
fetch C00 into
	nr_seq_cliente_ant_w,
	cd_medico_w,
	cd_pessoa_fisica_w,
	nm_usuario_w,
	ie_situacao_w,
	dt_primeira_consulta_w,
	dt_ultima_consulta_w,
	dt_ultima_atualiz_w,
	cd_pessoa_sist_orig_w,
	cd_convenio_w,
	cd_usuario_convenio_w,
	ds_encaminhamento_w,
	dt_validade_carteira_w,
	ie_ficha_papel_w,
	ie_exame_consultorio_w,
	dt_ultima_visualiz_w,
	ie_exame_virtual_w,
	nr_seq_plano_w,
	ds_observacao_w,
	nr_seq_classif_w,
	ie_gemelar_w,
	ie_pais_separados_w,
	dt_atualizacao_w;
EXIT WHEN NOT FOUND; /* apply on C00 */
begin

	select coalesce(max('S'),'N')
	into STRICT	ie_possui_med_cliente_w
	from	med_cliente
	where	cd_pessoa_fisica = cd_pessoa_fisica_w
	and		cd_medico =	 cd_medico_destino_p;

	if (ie_possui_med_cliente_w = 'S') then

		select 	max(nr_sequencia)
		into STRICT	nr_seq_cliente_w
		from	med_cliente
		where	cd_pessoa_fisica = cd_pessoa_fisica_w
		and		cd_medico =	 cd_medico_destino_p;

	elsif (ie_possui_med_cliente_w = 'N') then

		select	nextval('med_cliente_seq')
		into STRICT	nr_seq_cliente_w
		;

		select	coalesce(max(coalesce(campo_numerico(cd_pessoa_sist_orig),0)),0) + 1
		into STRICT	cd_pessoa_sist_orig_w
		from 	med_cliente
		where 	cd_medico = cd_medico_destino_p;



		insert	into med_cliente(nr_sequencia,
			cd_medico,
			cd_pessoa_fisica,
			dt_atualizacao,
			nm_usuario,
			ie_situacao,
			dt_primeira_consulta,
			dt_ultima_consulta,
			dt_ultima_atualiz,
			cd_pessoa_sist_orig,
			cd_convenio,
			cd_usuario_convenio,
			ds_encaminhamento,
			dt_validade_carteira,
			ie_ficha_papel,
			ie_exame_consultorio,
			dt_ultima_visualiz,
			ie_exame_virtual,
			nr_seq_plano,
			ds_observacao,
			nr_seq_classif,
			ie_gemelar,
			ie_pais_separados)
			SELECT	nr_seq_cliente_w,
				cd_medico_destino_p,
				cd_pessoa_fisica_w,
				dt_atualizacao_w,
				nm_usuario_w,
				ie_situacao_w,
				dt_primeira_consulta_w,
				dt_ultima_consulta_w,
				dt_ultima_atualiz_w,
				cd_pessoa_sist_orig_w,
				cd_convenio_w,
				cd_usuario_convenio_w,
				ds_encaminhamento_w,
				dt_validade_carteira_w,
				ie_ficha_papel_w,
				ie_exame_consultorio_w,
				dt_ultima_visualiz_w,
				ie_exame_virtual_w,
				nr_seq_plano_w,
				ds_observacao_w,
				nr_seq_classif_w,
				ie_gemelar_w,
				ie_pais_separados_w
			from	med_cliente
			where	nr_sequencia = nr_seq_cliente_ant_w;
	 end if;
		open C08;
		loop
		fetch C08 into
			nr_atendimento_ant_w,
			dt_atualizacao_w,
			nm_usuario_w,
			dt_entrada_w,
			cd_convenio_w,
			dt_saida_w,
			nr_atend_original_w,
			cd_usuario_convenio_w,
			dt_validade_carteira_w,
			nr_seq_agenda_w,
			dt_inicio_consulta_w,
			ie_grau_satisfacao_w,
			nr_seq_plano_w,
			ie_tipo_consulta_w,
			ie_tipo_saida_consulta_w,
			ie_tipo_atend_tiss_w;
		EXIT WHEN NOT FOUND; /* apply on C08 */
		begin

		select 	nextval('med_atendimento_seq')
		into STRICT	nr_atendimento_w
		;



		insert	into med_atendimento(nr_atendimento,
			nr_seq_cliente,
			dt_atualizacao,
			nm_usuario,
			dt_entrada,
			cd_convenio,
			dt_saida,
			nr_atend_original,
			cd_usuario_convenio,
			dt_validade_carteira,
			nr_seq_agenda,
			dt_inicio_consulta,
			ie_grau_satisfacao,
			nr_seq_plano,
			ie_tipo_consulta,
			ie_tipo_saida_consulta,
			ie_tipo_atend_tiss)
		values (nr_atendimento_w,
			nr_seq_cliente_w,
			dt_atualizacao_w,
			nm_usuario_w,
			dt_entrada_w,
			cd_convenio_w,
			dt_saida_w,
			nr_atend_original_w,
			cd_usuario_convenio_w,
			dt_validade_carteira_w,
			null,
			dt_inicio_consulta_w,
			ie_grau_satisfacao_w,
			nr_seq_plano_w,
			ie_tipo_consulta_w,
			ie_tipo_saida_consulta_w,
			ie_tipo_atend_tiss_w);
		end;
		end loop;
		close C08;

		open C04;
		loop
		fetch C04 into
			nr_seq_origem_w,
			dt_atualizacao_w,
			nm_usuario_w,
			dt_evolucao_w,
			--ds_evolucao_w,
			qt_peso_w,
			qt_imc_w,
			qt_variacao_peso_w,
			qt_altura_cm_w,
			qt_superf_corporal_w,
			qt_pa_sistolica_w,
			qt_pa_diastolica_w,
			qt_temp_w,
			qt_perimetro_cefalico_w,
			qt_ca_w,
			nr_seq_tipo_evolucao_w,
			nr_seq_pac_ginec_w,
			nr_seq_pac_pre_natal_w,
			nr_seq_pac_pre_natal_evol_w;
		EXIT WHEN NOT FOUND; /* apply on C04 */
		begin

			select 	nextval('med_evolucao_seq')
			into STRICT	nr_seq_med_evolucao_w
			;

			insert	into med_evolucao(nr_sequencia,
				nr_atendimento,
				dt_atualizacao,
				nm_usuario,
				dt_evolucao,
				ds_evolucao,
				nr_seq_cliente,
				qt_peso,
				qt_imc,
				qt_variacao_peso,
				qt_altura_cm,
				qt_superf_corporal,
				qt_pa_sistolica,
				qt_pa_diastolica,
				qt_temp,
				qt_perimetro_cefalico,
				qt_ca,
				nr_seq_tipo_evolucao,
				nr_seq_pac_ginec,
				nr_seq_pac_pre_natal,
				nr_seq_pac_pre_natal_evol,
				nr_seq_origem)
				SELECT	nr_seq_med_evolucao_w,
					nr_atendimento_w,
					clock_timestamp(),
					nm_usuario_w,
					dt_evolucao_w,
					' ',--ds_evolucao_w,
					nr_seq_cliente_w,
					qt_peso_w,
					qt_imc_w,
					qt_variacao_peso_w,
					qt_altura_cm_w,
					qt_superf_corporal_w,
					qt_pa_sistolica_w,
					qt_pa_diastolica_w,
					qt_temp_w,
					qt_perimetro_cefalico_w,
					qt_ca_w,
					nr_seq_tipo_evolucao_w,
					nr_seq_pac_ginec_w,
					nr_seq_pac_pre_natal_w,
					nr_seq_pac_pre_natal_evol_w,
					nr_seq_origem_w
				;
				commit;

				copia_campo_long_de_para_Java(
								'MED_EVOLUCAO',
								'DS_EVOLUCAO',
								' where nr_sequencia = :nr_sequencia',
								'nr_sequencia='||nr_seq_origem_w,
								'MED_EVOLUCAO',
								'DS_EVOLUCAO',
								' where nr_sequencia = :nr_sequencia',
								'nr_sequencia='||nr_seq_med_evolucao_w,
								'L');

		end;
		end loop;
		close C04;


		open C05;
		loop
		fetch C05 into
			nr_seq_origem_w,
			dt_atualizacao_w,
			nm_usuario_w,
			dt_receita_w,
			ds_receita_w,
			nr_atendimento_hosp_w,
			cd_pessoa_fisica_w,
			cd_medico_w,
			dt_liberacao_w,
			ie_tipo_receita_w,
			ie_situacao_w,
			dt_inativacao_w,
			nm_usuario_inativacao_w,
			ds_justificativa_w,
			cd_perfil_ativo_w;
		EXIT WHEN NOT FOUND; /* apply on C05 */
		begin
			select	nextval('med_receita_seq')
			into STRICT	nr_seq_med_receita_w
			;

			insert	into med_receita(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				nr_atendimento,
				dt_receita,
				ds_receita,
				nr_atendimento_hosp,
				nr_seq_cliente,
				cd_pessoa_fisica,
				cd_medico,
				dt_liberacao,
				ie_tipo_receita,
				ie_situacao,
				dt_inativacao,
				nm_usuario_inativacao,
				ds_justificativa,
				cd_perfil_ativo,
				nr_seq_origem)
				SELECT	nr_seq_med_receita_w,
					dt_atualizacao_w,
					nm_usuario_w,
					nr_atendimento_w,
					dt_receita_w,
					' ',--ds_receita_w,
					nr_atendimento_hosp_w,
					nr_seq_cliente_w,
					cd_pessoa_fisica_w,
					cd_medico_w,
					dt_liberacao_w,
					ie_tipo_receita_w,
					ie_situacao_w,
					dt_inativacao_w,
					nm_usuario_inativacao_w,
					ds_justificativa_w,
					cd_perfil_ativo_w,
					nr_seq_origem_w
				;
				commit;

			copia_campo_long_de_para_Java(
							'MED_RECEITA',
							'DS_RECEITA',
							' where nr_sequencia = :nr_sequencia',
							'nr_sequencia='||nr_seq_origem_w,
							'MED_RECEITA',
							'DS_RECEITA',
							' where nr_sequencia = :nr_sequencia',
							'nr_sequencia='||nr_seq_med_receita_w,
							'L');
		end;
		end loop;
		close C05;


		open C01;
		loop
		fetch C01 into
			nr_seq_pedido_v_w,
			dt_solicitacao_w,
			ds_solicitacao_w,
			dt_atualizacao_w,
			nm_usuario_w,
			ds_dados_clinicos_w,
			cd_exame_w,
			ds_exame_ant_w,
			ie_ficha_unimed_w,
			ds_cid_w,
			ds_diagnostico_cid_w,
			ds_justificativa_w,
			ie_carater_solic_w,
			ie_data_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
			select	nextval('med_pedido_exame_seq')
			into STRICT	nr_seq_pedido_n_w
			;

			insert	into med_pedido_exame(nr_sequencia,
				dt_solicitacao,
				ds_solicitacao,
				dt_atualizacao,
				nm_usuario,
				ds_dados_clinicos,
				cd_exame,
				nr_atendimento,
				nr_seq_cliente,
				ds_exame_ant,
				ie_ficha_unimed,
				ds_cid,
				ds_diagnostico_cid,
				ds_justificativa,
				ie_carater_solic,
				ie_data,
				nr_seq_origem)
			values (nr_seq_pedido_n_w,
				dt_solicitacao_w,
				' ',--  ds_solicitacao_w,
				dt_atualizacao_w,
				nm_usuario_w,
				ds_dados_clinicos_w,
				cd_exame_w,
				nr_atendimento_w,
				nr_seq_cliente_w,
				ds_exame_ant_w,
				ie_ficha_unimed_w,
				ds_cid_w,
				ds_diagnostico_cid_w,
				ds_justificativa_w,
				ie_carater_solic_w,
				ie_data_w,
				nr_seq_pedido_v_w);

			insert	into med_ped_exame_cod(nr_sequencia,
				nr_seq_pedido,
				dt_atualizacao,
				nm_usuario,
				nr_seq_exame,
				qt_exame,
				nr_seq_apresent,
				ds_justificativa,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				ie_lado)
				SELECT	nextval('med_ped_exame_cod_seq'),
					nr_seq_pedido_n_w,
					dt_atualizacao,
					nm_usuario,
					nr_seq_exame,
					qt_exame,
					nr_seq_apresent,
					ds_justificativa,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					ie_lado
				from	med_ped_exame_cod
				where	nr_seq_pedido = nr_seq_pedido_v_w;
				commit;
				copia_campo_long_de_para_Java(
				'MED_PEDIDO_EXAME',
				'DS_SOLICITACAO',
				' where nr_sequencia = :nr_sequencia',
				'nr_sequencia='||nr_seq_pedido_v_w,
				'MED_PEDIDO_EXAME',
				'DS_SOLICITACAO',
				' where nr_sequencia = :nr_sequencia',
				'nr_sequencia='||nr_seq_pedido_n_w,
				'L');
		end;
		end loop;
		close C01;

		open C09;
		loop
		fetch c09 into
			nr_seq_origem_w,
			nr_seq_exame_w,
			dt_exame_w,
			dt_atualizacao_w,
			nm_usuario_w,
			ds_valor_exame_w,
			vl_exame_w,
			nr_seq_laborat_w,
			ie_tipo_resultado_w,
			cd_item_result_w,
			ie_realizou_w,
			dt_atualizacao_nrec_w,
			nm_usuario_nrec_w,
			ie_valido_w,
			nr_prescricao_w,
			nr_seq_prescricao_w,
			nr_seq_exame_lab_w;
		EXIT WHEN NOT FOUND; /* apply on C09 */
		begin
			insert	into med_result_exame(nr_sequencia,
				nr_atendimento,
				nr_seq_exame,
				dt_exame,
				dt_atualizacao,
				nm_usuario,
				ds_valor_exame,
				vl_exame,
				nr_seq_cliente,
				nr_seq_laborat,
				ie_tipo_resultado,
				nr_seq_aval,
				cd_item_result,
				ie_realizou,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				ie_valido,
				nr_prescricao,
				nr_seq_prescricao,
				nr_seq_exame_lab,
				nr_seq_origem)
				SELECT	nextval('med_result_exame_seq'),
					nr_atendimento_w,
					nr_seq_exame_w,
					dt_exame_w,
					dt_atualizacao_w,
					nm_usuario_w,
					ds_valor_exame_w,
					vl_exame_w,
					nr_seq_cliente_w,
					nr_seq_laborat_w,
					ie_tipo_resultado_w,
					null,
					cd_item_result_w,
					ie_realizou_w,
					dt_atualizacao_nrec_w,
					nm_usuario_nrec_w,
					ie_valido_w,
					nr_prescricao_w,
					nr_seq_prescricao_w,
					nr_seq_exame_lab_w,
					nr_seq_origem_w
				;
		end;
		end loop;
		close C09;

		open C02;
		loop
		fetch c02 into
			nr_seq_origem_w,
			dt_atualizacao_w,
			nm_usuario_w,
			dt_texto_w,
			ds_texto_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
			select	nextval('med_texto_adicional_seq')
			into STRICT	nr_seq_med_texto_w
			;

			insert	into med_texto_adicional(nr_sequencia,
				nr_atendimento,
				dt_atualizacao,
				nm_usuario,
				dt_texto,
				ds_texto,
				nr_seq_cliente,
				nr_seq_origem)
				SELECT	nr_seq_med_texto_w,
				nr_atendimento_w,
				dt_atualizacao_w,
				nm_usuario_w,
				dt_texto_w,
				' ', --ds_texto_w,
				nr_seq_cliente_w,
				nr_seq_origem_w
			;
			commit;
			copia_campo_long_de_para_Java(
				'MED_TEXTO_ADICIONAL',
				'DS_TEXTO',
				' where nr_sequencia = :nr_sequencia',
				'nr_sequencia='||nr_seq_origem_w,
				'MED_TEXTO_ADICIONAL',
				'DS_TEXTO',
				' where nr_sequencia = :nr_sequencia',
				'nr_sequencia='||nr_seq_med_texto_w,
				'L');
		end;
		end loop;
		close C02;

		open C03;
		loop
		fetch C03 into
			nr_seq_origem_w,
			dt_atualizacao_w,
			nm_usuario_w,
			dt_parecer_w,
			ds_parecer_w,
			cd_medico_w,
			dt_atualizacao_nrec_w,
			nm_usuario_nrec_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
		begin
			select	nextval('med_parecer_medico_seq')
			into STRICT	nr_seq_med_parecer_medico_w
			;

			insert	into med_parecer_medico(nr_sequencia,
				nr_atendimento,
				dt_atualizacao,
				nm_usuario,
				dt_parecer,
				ds_parecer,
				nr_seq_cliente,
				cd_medico,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_origem)
				SELECT	nr_seq_med_parecer_medico_w,
					nr_atendimento_w,
					dt_atualizacao_w,
					nm_usuario_w,
					dt_parecer_w,
					' ',--ds_parecer_w,
					nr_seq_cliente_w,
					cd_medico_w,
					dt_atualizacao_nrec_w,
					nm_usuario_nrec_w,
					nr_seq_origem_w
				;
				commit;

					copia_campo_long_de_para_Java(
				'MED_PARECER_MEDICO',
				'DS_PARECER',
				' where nr_sequencia = :nr_sequencia',
				'nr_sequencia='||nr_seq_origem_w,
				'MED_PARECER_MEDICO',
				'DS_PARECER',
				' where nr_sequencia = :nr_sequencia',
				'nr_sequencia='||nr_seq_med_parecer_medico_w,
				'L');
		end;
		end loop;
		close C03;

		open C06;
		loop
		fetch C06 into
			nr_seq_origem_w,
			nr_seq_tipo_exame_w,
			dt_atualizacao_w,
			nm_usuario_w,
			dt_exame_w,
			ds_exame_w;
		EXIT WHEN NOT FOUND; /* apply on C06 */
		begin

		select 	nextval('med_exame_avaliacao_seq')
		into STRICT	nr_seq_med_exa_aval_w
		;

			insert	into med_exame_avaliacao(nr_sequencia,
				nr_atendimento,
				nr_seq_tipo_exame,
				dt_atualizacao,
				nm_usuario,
				nr_seq_cliente,
				dt_exame,
				--ds_exame,
				nr_seq_origem)
				SELECT	nr_seq_med_exa_aval_w,
					nr_atendimento_w,
					nr_seq_tipo_exame_w,
					dt_atualizacao_w,
					nm_usuario_w,
					nr_seq_cliente_w,
					dt_exame_w,
					--ds_exame_w,
					nr_seq_origem_w
				;
				commit;

			copia_campo_long_de_para_Java(
				'MED_EXAME_AVALIACAO',
				'DS_EXAME',
				' where nr_sequencia = :nr_sequencia',
				'nr_sequencia='||nr_seq_origem_w,
				'MED_EXAME_AVALIACAO',
				'DS_EXAME',
				' where nr_sequencia = :nr_sequencia',
				'nr_sequencia='||nr_seq_med_exa_aval_w,
				'L');
		end;
		end loop;
		close C06;

		open C07;
		loop
		fetch C07 into
			nr_seq_origem_w,
			dt_atestado_w,
			dt_atualizacao_w,
			nm_usuario_w,
			ds_atestado_w,
			qt_dia_w,
			dt_final_w,
			cd_cid_atestado_w,
			cd_especialidade_w,
			cd_profissao_w,
			cd_setor_w,
			dt_atualizacao_nrec_w,
			nm_usuario_nrec_w;
		EXIT WHEN NOT FOUND; /* apply on C07 */
		begin

			select 	nextval('med_atestado_seq')
			into STRICT	nr_seq_med_atestado_w
			;

			insert	into med_atestado(nr_sequencia,
				dt_atestado,
				dt_atualizacao,
				nm_usuario,
				--ds_atestado,
				nr_atendimento,
				nr_seq_cliente,
				qt_dia,
				dt_final,
				cd_cid_atestado,
				cd_especialidade,
				cd_profissao,
				cd_setor,
				nm_usuario_nrec,
				dt_atualizacao_nrec,
				nr_seq_origem)
				SELECT	nr_seq_med_atestado_w,
					dt_atestado_w,
					dt_atualizacao_w,
					nm_usuario_w,
					--ds_atestado_w,
					nr_atendimento_w,
					nr_seq_cliente_w,
					qt_dia_w,
					dt_final_w,
					cd_cid_atestado_w,
					cd_especialidade_w,
					cd_profissao_w,
					cd_setor_w,
					nm_usuario_nrec_w,
					dt_atualizacao_nrec_w,
					nr_seq_origem_w
				;

				commit;
			copia_campo_long_de_para_Java(
				'MED_ATESTADO',
				'DS_ATESTADO',
				' where nr_sequencia = :nr_sequencia',
				'nr_sequencia='||nr_seq_origem_w,
				'MED_ATESTADO',
				'DS_ATESTADO',
				' where nr_sequencia = :nr_sequencia',
				'nr_sequencia='||nr_seq_med_atestado_w,
				'L');
		end;
		end loop;
		close C07;
end;
end loop;
close C00;
commit;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE med_copiar_paciente ( cd_medico_origem_p text, cd_medico_destino_p text, nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
