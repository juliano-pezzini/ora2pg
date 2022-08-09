-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_regra_outro_estab ( nr_sequencia_p bigint, cd_estabelecimento_p text, nm_usuario_p text, nr_sequencia_nova_p INOUT bigint) AS $body$
DECLARE


nr_seq_lanc_w			regra_lanc_aut_pac.nr_seq_lanc%type;
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
cd_material_w			integer;
qt_lancamento_w			double precision;
ie_medico_atendimento_w		varchar(1);
ie_local_estoque_w			varchar(1);
ie_quantidade_w			varchar(1);
ie_retorno_w			varchar(1);
nr_seq_exame_w			bigint;
ie_funcao_medico_w		smallint;
tx_procedimento_w			double precision;
ie_regra_guia_w			varchar(5);
ie_forma_func_medico_w		varchar(01);
ie_consiste_item_w			varchar(01);
ie_proc_princ_atend_w		varchar(01);
cd_categoria_w			varchar(10);
qt_categoria_conv_w		bigint:= 0;
ie_existe_categ_w			varchar(1):= 'S';
cd_convenio_w			integer;
cd_cnpj_prestador_w		varchar(14);
cd_cid_doenca_w			varchar(10);
ie_adic_orcamento_w		varchar(1);
qt_ano_min_w			bigint;
qt_ano_max_w			bigint;
nr_seq_proc_interno_w		bigint;
nr_min_duracao_w		bigint;
ie_acao_w			varchar(1);
cd_medico_w			varchar(10);


c01 CURSOR FOR
	SELECT	cd_procedimento,
		ie_origem_proced,
		cd_material,
		qt_lancamento,
		ie_medico_atendimento,
		ie_local_estoque,
		ie_quantidade,
		ie_retorno,
		nr_seq_exame,
		ie_funcao_medico,
		tx_procedimento,
		qt_ano_min,
		qt_ano_max,
		ie_regra_guia,	
		ie_forma_func_medico,
		nr_seq_proc_interno,
		ie_consiste_item,
		ie_proc_princ_atend,
		nr_min_duracao,
		cd_cnpj_prestador,
		cd_cid_doenca,
		ie_acao,
		coalesce(ie_adic_orcamento,'N'),
		cd_medico
	from	regra_lanc_aut_pac
	where	nr_seq_regra = nr_sequencia_p;


BEGIN


if (coalesce(nr_sequencia_p, 0) > 0) then

	select	coalesce(max(cd_convenio), 0)
	into STRICT	cd_convenio_w
	from	regra_lanc_automatico
	where	nr_sequencia = nr_sequencia_p;

	select	nextval('regra_lanc_automatico_seq')
	into STRICT	nr_sequencia_nova_p
	;

	select 	coalesce(max(cd_categoria),'X')
	into STRICT	cd_categoria_w
	from	regra_lanc_automatico
	where	nr_sequencia = nr_sequencia_p;

	if (cd_categoria_w <> 'X') then
		select 	count(*)
		into STRICT	qt_categoria_conv_w
		from 	categoria_convenio
		where 	cd_convenio = cd_convenio_w
		and 	cd_categoria = cd_categoria_w;
		
		if (qt_categoria_conv_w = 0) then
			ie_existe_categ_w:= 'N';
		end if;
	end if;


	insert into regra_lanc_automatico(
		nr_sequencia,
		cd_estabelecimento,
		ds_regra,
		dt_atualizacao,
		nm_usuario,
		cd_convenio,
		ie_tipo_atendimento,
		cd_medico,
		nr_seq_evento,
		cd_area_procedimento,
		cd_especialidade_proc,
		cd_grupo_proc,
		cd_procedimento,
		ie_origem_proced,
		cd_edicao_amb,
		nr_seq_exame,
		ie_tipo_convenio,
		ie_situacao,
		cd_categoria,
		nr_seq_proc_interno,
		qt_ano_min,
		qt_ano_max,
		ie_via_aplicacao,
		cd_material,
		cd_classe_material,
		cd_subgrupo_material,
		cd_grupo_material,
		cd_espec_medic_atend,
		hr_inicial,
		hr_final,
		ie_lado,
		ie_video,
		ds_observacao,
		ie_credenciado,
		ie_tipo_guia,
		cd_dieta,
		cd_material_exame,
		cd_procedencia,
		dt_inicio_vigencia,
		dt_final_vigencia,
		ie_paciente_isolado,
		cd_refeicao,
		qt_ano_min_mes,
		qt_ano_min_dia,
		qt_ano_max_mes,
		qt_ano_max_dia,
		ie_dieta_liberada,
		ie_porte,
		ie_destino_dieta,
		nr_seq_conjunto,
		ie_sexo,
		ie_acompanhante,
		ie_escala_pep,
		nr_seq_classif_medico,
		nr_seq_equipe,
		nr_seq_tipo_pg,
		qt_dias_inter_inicio,
		qt_dias_inter_final,
		ie_consignado,
		cd_unidade_basica,
		cd_unidade_compl,
		nr_seq_tipo_servico,
		nm_tabela,
		nm_atributo,
		cd_tipo_baixa,
		ds_dia_ciclo,
		ie_tipo_evolucao,
		ie_nivel,
		ie_classif_agenda,
		ie_funcionario,
		ie_conv_parametro,
		nr_seq_forma_org,
		nr_seq_subgrupo,
		nr_seq_grupo,
		ie_vincular_proc_princ,
		ie_carater_inter,
		ie_dispara_kit_mat,
		ie_duplicar_proc_regra,
		cd_tipo_recomendacao,
		cd_plano_convenio,
		ie_clinica,
		cd_motivo_alta,
		cd_tipo_acomodacao,
		cd_especialidade,
		cd_tipo_anestesia,
		cd_funcao,
		ie_evolucao_clinica,
		dt_dia_semana,
		ie_feriado)
	SELECT	nr_sequencia_nova_p,
		cd_estabelecimento_p,
		substr(Wheb_mensagem_pck.get_Texto(309622) || ds_regra,1,240),
		clock_timestamp(),
		nm_usuario_p,
		CASE WHEN cd_convenio_w='0' THEN  null  ELSE cd_convenio_w END ,
		ie_tipo_atendimento,
		cd_medico,
		nr_seq_evento,
		cd_area_procedimento,
		cd_especialidade_proc,
		cd_grupo_proc,
		cd_procedimento,
		ie_origem_proced,
		cd_edicao_amb,
		nr_seq_exame,
		ie_tipo_convenio,
		ie_situacao,
		CASE WHEN ie_existe_categ_w='S' THEN cd_categoria  ELSE null END ,
		nr_seq_proc_interno,
		qt_ano_min,
		qt_ano_max,
		ie_via_aplicacao,
		cd_material,
		cd_classe_material,
		cd_subgrupo_material,
		cd_grupo_material,
		cd_espec_medic_atend,
		hr_inicial,
		hr_final,
		ie_lado,
		ie_video,
		ds_observacao,
		ie_credenciado,
		ie_tipo_guia,
		cd_dieta,
		cd_material_exame,
		cd_procedencia,
		dt_inicio_vigencia,
		dt_final_vigencia,
		ie_paciente_isolado,
		cd_refeicao,
		qt_ano_min_mes,
		qt_ano_min_dia,
		qt_ano_max_mes,
		qt_ano_max_dia,
		ie_dieta_liberada,
		ie_porte,
		ie_destino_dieta,
		nr_seq_conjunto,
		ie_sexo,
		ie_acompanhante,
		ie_escala_pep,
		nr_seq_classif_medico,
		nr_seq_equipe,
		nr_seq_tipo_pg,
		qt_dias_inter_inicio,
		qt_dias_inter_final,
		ie_consignado,
		cd_unidade_basica,
		cd_unidade_compl,
		nr_seq_tipo_servico,
		nm_tabela,
		nm_atributo,
		cd_tipo_baixa,
		ds_dia_ciclo,
		ie_tipo_evolucao,
		ie_nivel,
		ie_classif_agenda,
		ie_funcionario,
		ie_conv_parametro,
		nr_seq_forma_org,
		nr_seq_subgrupo,
		nr_seq_grupo,
		ie_vincular_proc_princ,
		ie_carater_inter,       
		ie_dispara_kit_mat,
		coalesce(ie_duplicar_proc_regra,'N'),
		cd_tipo_recomendacao,
		cd_plano_convenio,
		ie_clinica,
		cd_motivo_alta,
		cd_tipo_acomodacao,
		cd_especialidade,
		cd_tipo_anestesia,
		cd_funcao,
		ie_evolucao_clinica,
		dt_dia_semana,
		ie_feriado
	from	regra_lanc_automatico
	where	nr_sequencia = nr_sequencia_p;

	open c01;
	loop
	fetch c01 into
		cd_procedimento_w,
		ie_origem_proced_w,
		cd_material_w,
		qt_lancamento_w,
		ie_medico_atendimento_w,
		ie_local_estoque_w,
		ie_quantidade_w,
		ie_retorno_w,
		nr_seq_exame_w,
		ie_funcao_medico_w,
		tx_procedimento_w,
		qt_ano_min_w,
		qt_ano_max_w,
		ie_regra_guia_w,
		ie_forma_func_medico_w,
		nr_seq_proc_interno_w,
		ie_consiste_item_w,
		ie_proc_princ_atend_w,
		nr_min_duracao_w,
		cd_cnpj_prestador_w,
		cd_cid_doenca_w,
		ie_acao_w,
		ie_adic_orcamento_w,
		cd_medico_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		select	coalesce(max(nr_seq_lanc),0) + 1
		into STRICT	nr_seq_lanc_w
		from	regra_lanc_aut_pac;

		if (coalesce(cd_procedimento_w::text, '') = '') then
			ie_origem_proced_w	:= null;
		end if;

		insert into regra_lanc_aut_pac(
			nr_seq_regra,
			nr_seq_lanc,
			dt_atualizacao,
			nm_usuario,
			cd_procedimento,
			ie_origem_proced,
			cd_material,
			qt_lancamento,
			ie_medico_atendimento,
			ie_local_estoque,
			ie_quantidade,
			ie_retorno,
			nr_seq_exame,
			ie_funcao_medico,
			tx_procedimento,
			qt_ano_min,
			qt_ano_max,
			ie_regra_guia,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			ie_forma_func_medico,
			nr_seq_proc_interno,
			ie_consiste_item,
			ie_proc_princ_atend,
			nr_min_duracao,
			cd_cnpj_prestador,
			cd_cid_doenca,
			ie_acao,
			ie_adic_orcamento,
			cd_medico)
		values (nr_sequencia_nova_p,
			nr_seq_lanc_w,
			clock_timestamp(),
			nm_usuario_p,
			cd_procedimento_w,
			ie_origem_proced_w,
			cd_material_w,
			qt_lancamento_w,
			ie_medico_atendimento_w,
			ie_local_estoque_w,
			ie_quantidade_w,
			ie_retorno_w,
			nr_seq_exame_w,
			ie_funcao_medico_w,
			tx_procedimento_w,
			qt_ano_min_w,
			qt_ano_max_w,
			ie_regra_guia_w,
			clock_timestamp(),
			nm_usuario_p,
			ie_forma_func_medico_w,
			nr_seq_proc_interno_w,
			ie_consiste_item_w,
			ie_proc_princ_atend_w,
			nr_min_duracao_w,
			cd_cnpj_prestador_w,
			cd_cid_doenca_w,
			ie_acao_w,
			coalesce(ie_adic_orcamento_w,'N'),
			cd_medico_w);
		end;
	end loop;
	close c01;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copiar_regra_outro_estab ( nr_sequencia_p bigint, cd_estabelecimento_p text, nm_usuario_p text, nr_sequencia_nova_p INOUT bigint) FROM PUBLIC;
