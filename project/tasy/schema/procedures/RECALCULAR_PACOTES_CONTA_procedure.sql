-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE recalcular_pacotes_conta ( nr_interno_conta_p bigint, nm_usuario_p text, ie_atualizar_resumo_p text) AS $body$
DECLARE


ie_acomod_setor_proc_w		varchar(1);
ie_atualiza_w			varchar(1) := 'N';
cont_w				integer;

qt_filho_w			smallint;
vl_pr_filho_w			double precision;

cd_regra_honorario_w		varchar(5);
ie_conta_honorario_w		varchar(1);
ie_calcula_honorario_w		varchar(1);
cd_cgc_honorario_w		varchar(14);
cd_pessoa_honorario_w		varchar(10);
nr_seq_criterio_w		bigint;

vl_ch_honorarios_w		double precision	:= 0;
vl_ch_operacional_w		double precision	:= 0;
vl_filme_w			double precision	:= 0;
vl_procedimento_w		double precision	:= 0;
vl_procedimento_ww		double precision	:= 0;

nr_seq_atend_pacote_w		atendimento_pacote.nr_sequencia%type;
nr_seq_tipo_acomod_w		atendimento_pacote.nr_seq_tipo_acomod%type;
nr_sequencia_proc_origem_w	atendimento_pacote.nr_seq_proc_origem%type;
dt_inicio_pacote_w		atendimento_pacote.dt_inicio_pacote%type;

nr_atendimento_w		conta_paciente.nr_atendimento%type;
cd_convenio_parametro_w		conta_paciente.cd_convenio_parametro%type;
cd_categoria_parametro_w	conta_paciente.cd_categoria_parametro%type;
cd_estabelecimento_w		conta_paciente.cd_estabelecimento%type;
cd_estabelecimento_logado_w	conta_paciente.cd_estabelecimento%type;
ie_status_acerto_w		conta_paciente.ie_status_acerto%type;

nr_seq_regra_preco_w		procedimento_paciente.nr_sequencia%type;
nr_sequencia_proc_w		procedimento_paciente.nr_sequencia%type;
dt_procedimento_w		procedimento_paciente.dt_procedimento%type;
dt_entrada_unidade_w		procedimento_paciente.dt_entrada_unidade%type;
cd_setor_atendimento_w		procedimento_paciente.cd_setor_atendimento%type;
cd_medico_executor_w		procedimento_paciente.cd_medico_executor%type;
cd_procedimento_w		procedimento_paciente.cd_procedimento%type;
ie_origem_proced_w		procedimento_paciente.ie_origem_proced%type;
nr_seq_proc_int_pacote_w	procedimento_paciente.nr_seq_proc_interno%type;
nr_seq_atepacu_w		procedimento_paciente.nr_seq_atepacu%type;
cd_cgc_prestador_w		procedimento_paciente.cd_cgc_prestador%type;
cd_especialidade_medica_w	procedimento_paciente.cd_especialidade%type;
ie_doc_executor_w		procedimento_paciente.ie_doc_executor%type;
cd_cbo_w			procedimento_paciente.cd_cbo%type;
nr_seq_exame_w			procedimento_paciente.nr_seq_exame%type;
pr_faturar_w			procedimento_paciente.tx_procedimento%type;
vl_proc_original_w		procedimento_paciente.vl_procedimento%type;
qt_proc_original_w		procedimento_paciente.qt_procedimento%type;
vl_proc_calculo_w		procedimento_paciente.vl_procedimento%type;

ie_tipo_atendimento_w		atendimento_paciente.ie_tipo_atendimento%type;
ie_clinica_w			atendimento_paciente.ie_clinica%type;
ie_carater_inter_sus_w		atendimento_paciente.ie_carater_inter_sus%type;
nr_seq_classif_medico_w		atendimento_paciente.nr_seq_classif_medico%type;
cd_procedencia_w		atendimento_paciente.cd_procedencia%type;

nr_seq_pacote_w			pacote_tipo_acomodacao.nr_seq_pacote%type;
ie_tipo_acomod_w		pacote_tipo_acomodacao.ie_tipo_acomod%type;
cd_categoria_acomod_w		pacote_tipo_acomodacao.cd_categoria%type;
cd_plano_acomod_w		pacote_tipo_acomodacao.cd_plano%type;
ie_clinica_acomod_w		pacote_tipo_acomodacao.ie_clinica%type;
ie_atend_retorno_w		pacote_tipo_acomodacao.ie_atend_retorno%type;
ie_tipo_atend_acomod_w		pacote_tipo_acomodacao.ie_tipo_atendimento%type;
ie_tipo_atend_conta_w		pacote_tipo_acomodacao.ie_tipo_atend_conta%type;
cd_setor_acomod_w		pacote_tipo_acomodacao.cd_setor_atendimento%type;
ie_atend_alta_w			pacote_tipo_acomodacao.ie_atend_alta%type;
ie_data_consiste_idade_w	pacote_tipo_acomodacao.ie_data_consiste_idade%type;
ie_consiste_dias_inter_w	pacote_tipo_acomodacao.ie_consiste_dias_inter%type;
ie_tipo_anestesia_w		pacote_tipo_acomodacao.ie_tipo_anestesia%type;
ie_atend_acomp_w		pacote_tipo_acomodacao.ie_atend_acomp%type;
ie_sexo_w			pacote_tipo_acomodacao.ie_sexo%type;
ie_lado_w			pacote_tipo_acomodacao.ie_lado%type;
cd_centro_custo_w		pacote_tipo_acomodacao.cd_centro_custo%type;
ie_credenciado_w		pacote_tipo_acomodacao.ie_credenciado%type;
qt_idade_min_w			pacote_tipo_acomodacao.qt_idade_min%type;
qt_idade_max_w			pacote_tipo_acomodacao.qt_idade_max%type;
qt_dias_inter_inicio_w		pacote_tipo_acomodacao.qt_dias_inter_inicio%type;
qt_dias_inter_final_w		pacote_tipo_acomodacao.qt_dias_inter_final%type;

vl_pacote_w			pacote_tipo_acomodacao.vl_pacote%type;
vl_honorario_w			pacote_tipo_acomodacao.vl_honorario%type;
vl_anestesista_w		pacote_tipo_acomodacao.vl_anestesista%type;
qt_ponto_pacote_w		pacote_tipo_acomodacao.qt_ponto_pacote%type;
qt_ponto_honorario_w		pacote_tipo_acomodacao.qt_ponto_honorario%type;
pr_afaturar_w			pacote_tipo_acomodacao.pr_faturar_pacote%type;
vl_materiais_w			pacote_tipo_acomodacao.vl_materiais%type;
vl_auxiliares_w			pacote_tipo_acomodacao.vl_auxiliares%type;
pr_acrescimo_rn_w		pacote_tipo_acomodacao.pr_acrescimo_rn%type;
qt_procedimento_w		pacote_tipo_acomodacao.qt_procedimento%type;
nr_seq_acomod_w			pacote_tipo_acomodacao.nr_sequencia%type;
cd_proced_acomodacao_w		pacote_tipo_acomodacao.cd_procedimento%type;
ie_origem_proc_acomod_w		pacote_tipo_acomodacao.ie_origem_proced%type;
nr_seq_proc_int_acomod_w	pacote_tipo_acomodacao.nr_seq_proc_interno%type;
cd_estrut_acomod_w		pacote_tipo_acomodacao.cd_estrutura_conta%type;
ie_carater_acomod_w		pacote_tipo_acomodacao.ie_carater_inter_sus%type;

cd_tipo_acomodacao_w		atend_paciente_unidade.cd_tipo_acomodacao%type;

cd_moeda_pacote_w		pacote.cd_moeda%type;

vl_cotacao_w			cotacao_moeda.vl_cotacao%type;

cd_edicao_amb_w			convenio_amb.cd_edicao_amb%type;

cd_plano_w			atend_categoria_convenio.cd_plano_convenio%type;

ie_calculo_taxa_regra_w		parametro_faturamento.ie_calculo_taxa_regra%type;

c01 CURSOR FOR
SELECT	a.nr_sequencia,
	a.nr_seq_tipo_acomod,
	a.nr_seq_procedimento,
	a.nr_seq_proc_origem,
	b.cd_moeda,
	a.dt_inicio_pacote
from	atendimento_pacote	a,
	pacote			b
where	b.nr_seq_pacote		= a.nr_seq_pacote
and	a.nr_seq_proc_origem in (	select x.nr_sequencia
					from 	procedimento_paciente x
					where 	x.nr_interno_conta =  nr_interno_conta_p);

c02 CURSOR FOR
SELECT	coalesce(vl_pacote,0),
	coalesce(vl_honorario,0),
	coalesce(vl_anestesista,0),
	coalesce(qt_ponto_pacote,0),
	coalesce(qt_ponto_honorario,0),
	coalesce(pr_faturar_pacote,0),
	coalesce(vl_materiais,0),
	coalesce(vl_auxiliares,0),
	coalesce(pr_acrescimo_rn,0),
	qt_procedimento,
	nr_sequencia,
	cd_procedimento,
	ie_origem_proced,
	nr_seq_proc_interno,
	cd_estrutura_conta
from	pacote_tipo_acomodacao
where	nr_seq_pacote = nr_seq_pacote_w
and	ie_tipo_acomod = ie_tipo_acomod_w
and	coalesce(dt_inicio_pacote_w, dt_vigencia) between coalesce(dt_vigencia,dt_inicio_pacote_w) and coalesce(trunc(dt_vigencia_final, 'dd') + 86399/86400,clock_timestamp() + interval '360 days')
and	coalesce(cd_categoria,cd_categoria_acomod_w) = cd_categoria_acomod_w
and	coalesce(cd_plano,cd_plano_acomod_w) = cd_plano_acomod_w
and	coalesce(ie_clinica,ie_clinica_acomod_w) = ie_clinica_acomod_w
and	coalesce(ie_atend_retorno,ie_atend_retorno_w) = ie_atend_retorno_w
and	coalesce(ie_tipo_atendimento,ie_tipo_atend_acomod_w) =  ie_tipo_atend_acomod_w
and	coalesce(ie_tipo_atend_conta,ie_tipo_atend_conta_w) = ie_tipo_atend_conta_w
and	coalesce(cd_setor_atendimento,cd_setor_acomod_w) = cd_setor_acomod_w
and	coalesce(ie_atend_alta,ie_atend_alta_w) = ie_atend_alta_w
and	coalesce(ie_data_consiste_idade,ie_data_consiste_idade_w) = ie_data_consiste_idade_w
and	coalesce(ie_consiste_dias_inter,ie_consiste_dias_inter_w) = ie_consiste_dias_inter_w
and	coalesce(ie_tipo_anestesia,ie_tipo_anestesia_w) = ie_tipo_anestesia_w
and	coalesce(ie_atend_acomp,ie_atend_acomp_w) = ie_atend_acomp_w
and	coalesce(ie_sexo,ie_sexo_w) = ie_sexo_w
and	coalesce(ie_lado,ie_lado_w) = ie_lado_w
and	coalesce(cd_centro_custo,cd_centro_custo_w) = cd_centro_custo_w
and	coalesce(ie_credenciado,ie_credenciado_w) = ie_credenciado_w
and	coalesce(qt_idade_min,qt_idade_min_w) = qt_idade_min_w
and	coalesce(qt_idade_max,qt_idade_max_w) = qt_idade_max_w
and	coalesce(qt_dias_inter_inicio,qt_dias_inter_inicio_w) = qt_dias_inter_inicio_w
and	coalesce(qt_dias_inter_final,qt_dias_inter_final_w) = qt_dias_inter_final_w
and	coalesce(ie_carater_inter_sus, ie_carater_acomod_w) = ie_carater_acomod_w
and	ie_situacao = 'A'
order by	coalesce(dt_vigencia,dt_inicio_pacote_w),
	coalesce(cd_setor_atendimento, 0);
	


BEGIN

select	count(*)
into STRICT	cont_w
from	atendimento_pacote a
where	a.nr_seq_proc_origem in (SELECT x.nr_sequencia
	from 	procedimento_paciente x
	where 	x.nr_interno_conta =  nr_interno_conta_p);

if (cont_w > 0) then

	select  a.nr_atendimento,
		a.cd_convenio_parametro,
		a.cd_categoria_parametro,
		a.cd_estabelecimento,
		a.ie_status_acerto
	into STRICT	nr_atendimento_w,
		cd_convenio_parametro_w,
		cd_categoria_parametro_w,
		cd_estabelecimento_w,
		ie_status_acerto_w
	from  	conta_paciente a
	where 	a.nr_interno_conta = nr_interno_conta_p;

	select	coalesce(max(ie_tipo_atendimento),1),
		coalesce(max(ie_clinica),0),
		max(ie_carater_inter_sus),
		max(nr_seq_classif_medico),
		max(cd_procedencia)
	into STRICT	ie_tipo_atendimento_w,
		ie_clinica_w,
		ie_carater_inter_sus_w,
		nr_seq_classif_medico_w,
		cd_procedencia_w
	from	atendimento_paciente
	where	nr_atendimento	= nr_atendimento_w;

	select 	obter_dados_categ_conv(nr_atendimento_w, 'P')
	into STRICT	cd_plano_w
	;

	cd_estabelecimento_logado_w	:= coalesce(wheb_usuario_pck.get_cd_estabelecimento, cd_estabelecimento_w);
	ie_acomod_setor_proc_w		:= coalesce(obter_valor_param_usuario(67,467,obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_logado_w),'N');

	open c01;
	loop
	fetch c01 into
		nr_seq_atend_pacote_w,
		nr_seq_tipo_acomod_w,
		nr_sequencia_proc_w,
		nr_sequencia_proc_origem_w,
		cd_moeda_pacote_w,
		dt_inicio_pacote_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin

		-- Obtem os dados do procedimento a ser atualizado
		select	a.cd_procedimento,
			a.ie_origem_proced,
	 		a.dt_procedimento,
			a.dt_entrada_unidade,
			a.cd_setor_atendimento,
			a.cd_medico_executor,
			a.nr_seq_proc_interno,
			a.nr_seq_atepacu,
			a.cd_cgc_prestador,
			a.cd_especialidade,
			a.ie_doc_executor,
			a.cd_cbo,
			a.nr_seq_exame,
			coalesce(a.tx_procedimento,100)
		into STRICT	cd_procedimento_w,
			ie_origem_proced_w,
			dt_procedimento_w,
			dt_entrada_unidade_w,
			cd_setor_atendimento_w,
			cd_medico_executor_w,
			nr_seq_proc_int_pacote_w,
			nr_seq_atepacu_w,
			cd_cgc_prestador_w,
			cd_especialidade_medica_w,
			ie_doc_executor_w,
			cd_cbo_w,
			nr_seq_exame_w,
			pr_afaturar_w
		from	procedimento_paciente	a
		where	a.nr_sequencia		= nr_sequencia_proc_origem_w
		and	a.nr_interno_conta	= nr_interno_conta_p;
		
		select	max(nr_seq_pacote),
			max(ie_tipo_acomod),
			coalesce(max(cd_categoria),'0'),
			coalesce(max(cd_plano),'0'),
			coalesce(max(ie_clinica),'0'),
			coalesce(max(ie_tipo_atendimento),0),
			coalesce(max(ie_tipo_atend_conta),0),
			coalesce(max(cd_setor_atendimento),0),
			coalesce(max(ie_atend_retorno),'0'),
			coalesce(max(ie_atend_alta),'0'),
			coalesce(max(ie_data_consiste_idade),'0'),
			coalesce(max(ie_consiste_dias_inter),'0'),
			coalesce(max(ie_tipo_anestesia),'0'),
			coalesce(max(ie_atend_acomp),'0'),
			coalesce(max(ie_sexo),'0'),
			coalesce(max(ie_lado),'0'),
			coalesce(max(cd_centro_custo),0),
			coalesce(max(ie_credenciado),'0'),
			coalesce(max(qt_idade_min),0),
			coalesce(max(qt_idade_max),0),
			coalesce(max(qt_dias_inter_inicio),0),
			coalesce(max(qt_dias_inter_final),0),
			coalesce(max(ie_carater_inter_sus),'0')
		into STRICT	nr_seq_pacote_w,
			ie_tipo_acomod_w,
			cd_categoria_acomod_w,
			cd_plano_acomod_w,
			ie_clinica_acomod_w,
			ie_tipo_atend_acomod_w,
			ie_tipo_atend_conta_w,
			cd_setor_acomod_w,
			ie_atend_retorno_w,
			ie_atend_alta_w,
			ie_data_consiste_idade_w,
			ie_consiste_dias_inter_w,
			ie_tipo_anestesia_w,
			ie_atend_acomp_w,
			ie_sexo_w,
			ie_lado_w,
			cd_centro_custo_w,
			ie_credenciado_w,
			qt_idade_min_w,
			qt_idade_max_w,
			qt_dias_inter_inicio_w,
			qt_dias_inter_final_w,
			ie_carater_acomod_w
		from	pacote_tipo_acomodacao
		where	nr_sequencia = nr_seq_tipo_acomod_w;

		-- Obtem os registros de regra de acomodacao do pacote
		/*select 	nvl(vl_pacote,0),
			nvl(vl_honorario,0),
			nvl(vl_anestesista,0),
			nvl(qt_ponto_pacote,0),
			nvl(qt_ponto_honorario,0),
			nvl(pr_faturar_pacote,0),
			nvl(vl_materiais,0),
			nvl(vl_auxiliares,0),
			nvl(pr_acrescimo_rn,0),
			qt_procedimento
		into	vl_pacote_w,
			vl_honorario_w,
			vl_anestesista_w,
			qt_ponto_pacote_w,
			qt_ponto_honorario_w,
			pr_faturar_w,
			vl_materiais_w,
			vl_auxiliares_w,
			pr_acrescimo_rn_w,
			qt_procedimento_w
		from 	pacote_tipo_acomodacao a
		where	a.nr_sequencia		= nr_seq_tipo_acomod_w;	*/
		
		open c02;
		loop
		fetch c02 into
			vl_pacote_w,
			vl_honorario_w,
			vl_anestesista_w,
			qt_ponto_pacote_w,
			qt_ponto_honorario_w,
			pr_faturar_w,
			vl_materiais_w,
			vl_auxiliares_w,
			pr_acrescimo_rn_w,
			qt_procedimento_w,
			nr_seq_acomod_w,
			cd_proced_acomodacao_w,
			ie_origem_proc_acomod_w,
			nr_seq_proc_int_acomod_w,
			cd_estrut_acomod_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin
			vl_pacote_w	:= vl_pacote_w;
			end;
		end loop;
		close c02;

		if (coalesce(pr_faturar_w,0) <> 0) then
			pr_afaturar_w	:= pr_faturar_w;
		end if;
		
		select	max(obter_edicao_amb(cd_estabelecimento_w,
					cd_convenio_parametro_w,
					cd_categoria_parametro_w,
					dt_procedimento_w))
		into STRICT	cd_edicao_amb_w
		;

		/*CASO TENHA MOEDA INFORMADA NO PACOTE, O VALOR DO PACOTE SERA CONVERTIDO*/

		if (coalesce(cd_moeda_pacote_w,0) > 0) and (coalesce(nr_interno_conta_p,0) > 0) then
			vl_cotacao_w := obter_valor_convertido_cotacao(nr_interno_conta_p, cd_moeda_pacote_w);

			if (coalesce(vl_cotacao_w,0) > 0) and coalesce(vl_pacote_w,0) > 0 then
				vl_pacote_w	 := vl_pacote_w * vl_cotacao_w;
			end if;
		end if;

		if (vl_pacote_w	= 0) and (vl_honorario_w	= 0) then

			if (ie_acomod_setor_proc_w = 'S') then

				select 	coalesce(max(cd_tipo_acomodacao),-1)
				into STRICT	cd_tipo_acomodacao_w
				from 	atend_paciente_unidade
				where 	nr_atendimento = nr_atendimento_w
				and 	cd_setor_atendimento = cd_setor_atendimento_w
				and 	nr_seq_interno = nr_seq_atepacu_w
				and 	dt_entrada_unidade = dt_entrada_unidade_w;

			end if;

			SELECT * FROM obter_cotacao_moeda_convenio(cd_estabelecimento_w, cd_convenio_parametro_w, cd_categoria_parametro_w, cd_procedimento_w, 1, dt_procedimento_w, 'P', cd_setor_atendimento_w, ie_tipo_atendimento_w, cd_medico_executor_w, null, cd_plano_w, ie_clinica_w, 0, cd_edicao_amb_w, nr_seq_proc_int_pacote_w, null, cd_tipo_acomodacao_w, vl_ch_honorarios_w, vl_ch_operacional_w, vl_filme_w) INTO STRICT vl_ch_honorarios_w, vl_ch_operacional_w, vl_filme_w;

			if (coalesce(vl_ch_honorarios_w::text, '') = '') then
				vl_ch_honorarios_w	:= 1;
			end if;

			if (coalesce(vl_ch_operacional_w::text, '') = '') then
				vl_ch_operacional_w	:= 1;
			end if;

			vl_pacote_w	:= (qt_ponto_pacote_w * vl_ch_operacional_w);
			vl_honorario_w	:= (qt_ponto_honorario_w * vl_ch_honorarios_w);
		end if;

		SELECT * FROM obter_regra_honorario(cd_estabelecimento_w, cd_convenio_parametro_w, cd_categoria_parametro_w, cd_procedimento_w, ie_origem_proced_w, dt_procedimento_w, ie_tipo_atendimento_w, cd_setor_atendimento_w, null, null, cd_medico_executor_w, cd_cgc_prestador_w, 'S', ie_carater_inter_sus_w, cd_plano_w, cd_regra_honorario_w, ie_conta_honorario_w, ie_calcula_honorario_w, cd_cgc_honorario_w, cd_pessoa_honorario_w, nr_seq_criterio_w, cd_especialidade_medica_w, null, null, ie_clinica_w, null, nr_seq_classif_medico_w, cd_procedencia_w, ie_doc_executor_w, cd_cbo_w, nr_seq_proc_int_pacote_w, nr_seq_exame_w) INTO STRICT cd_regra_honorario_w, ie_conta_honorario_w, ie_calcula_honorario_w, cd_cgc_honorario_w, cd_pessoa_honorario_w, nr_seq_criterio_w;

		if (ie_calcula_honorario_w	= 'N') then
			vl_honorario_w		:= 0;
			vl_anestesista_w	:= 0;
			vl_auxiliares_w		:= 0;
		end if;

		if (ie_conta_honorario_w = 'S') then
			vl_procedimento_w	:= vl_pacote_w + vl_honorario_w + vl_anestesista_w + vl_auxiliares_w;
		else
			vl_procedimento_w	:= vl_pacote_w;
		end if;

		vl_procedimento_w	:= vl_procedimento_w / 100 * pr_afaturar_w;

		--Valor pacote RN
		if (pr_acrescimo_rn_w > 0) then
			qt_filho_w :=	coalesce(Obter_dados_parto(nr_atendimento_w,'1'),0) +  coalesce(Obter_dados_parto(nr_atendimento_w,'2'),0);

			if (coalesce(qt_filho_w,0) > 1) then
				vl_pr_filho_w	  	:= pr_acrescimo_rn_w * vl_procedimento_w / 100;
				vl_procedimento_w	:= vl_procedimento_w + (vl_pr_filho_w * (qt_filho_w-1));
			end if;
		end if;

		if (vl_procedimento_w	> 0) then
			vl_procedimento_ww	:= vl_procedimento_w;
		else
			vl_procedimento_ww	:= vl_pacote_w;
		end if;
		
		select	a.vl_procedimento,
			a.qt_procedimento
		into STRICT	vl_proc_original_w,
			qt_proc_original_w
		from	procedimento_paciente a	
		where	a.nr_sequencia	= nr_sequencia_proc_w;
		
		vl_proc_calculo_w	:= (coalesce(vl_procedimento_ww,0) + coalesce(vl_materiais_w,0)) * coalesce(qt_procedimento_w, qt_proc_original_w);
		
		if (vl_proc_original_w <> vl_proc_calculo_w) and (coalesce(vl_proc_calculo_w,0) <> 0) then
		
			update	procedimento_paciente
			set	tx_procedimento		= pr_afaturar_w,
				qt_procedimento		= coalesce(qt_procedimento_w, qt_procedimento),
				vl_medico		= coalesce(vl_honorario_w,0) * coalesce(qt_procedimento_w, qt_procedimento) * CASE WHEN pr_afaturar_w=100 THEN  100  ELSE pr_afaturar_w END /100,
				vl_anestesista		= coalesce(vl_anestesista_w, 0) * coalesce(qt_procedimento_w, qt_procedimento),
				vl_procedimento		= vl_proc_calculo_w,
				vl_custo_operacional	= coalesce(vl_pacote_w,0) * coalesce(qt_procedimento_w, qt_procedimento),
				vl_materiais		= coalesce(vl_materiais_w,0) * coalesce(qt_procedimento_w, qt_procedimento),
				vl_auxiliares		= coalesce(vl_auxiliares_w, 0) * coalesce(qt_procedimento_w, qt_procedimento),
				cd_procedimento		= cd_proced_acomodacao_w,
				ie_origem_proced	= ie_origem_proc_acomod_w,
				nr_seq_proc_interno	= nr_seq_proc_int_acomod_w,
				ie_emite_conta		= cd_estrut_acomod_w,
				nm_usuario		= nm_usuario_p
			where 	nr_sequencia		= nr_sequencia_proc_w;

			update	atendimento_pacote
			set	pr_afaturar		= pr_afaturar_w,
				vl_original		= vl_procedimento_ww,
				nr_seq_tipo_acomod	= nr_seq_acomod_w,
				nm_usuario		= nm_usuario_p
			where 	nr_sequencia		= nr_seq_atend_pacote_w
			and 	nr_atendimento		= nr_atendimento_w;
			
			ie_atualiza_w := 'S';
		end if;
		end;
	end loop;
	close c01;

	if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;	
	
	if (ie_atualiza_w = 'S') then

		CALL atualizar_perc_recalc_pacote(nr_atendimento_w, nr_interno_conta_p, cd_convenio_parametro_w, cd_estabelecimento_w, nm_usuario_p);

		CALL ajustar_valores_pacote(nr_atendimento_w, cd_convenio_parametro_w, nm_usuario_p);

		select	coalesce(max(ie_calculo_taxa_regra), 'C')
		into STRICT	ie_calculo_taxa_regra_w
		from	parametro_faturamento
		where	cd_estabelecimento	= cd_estabelecimento_w;

		CALL ratear_valores_pacote(nr_atendimento_w, 'S', cd_convenio_parametro_w, nm_usuario_p, nr_interno_conta_p);

		if (ie_calculo_taxa_regra_w	= 'L') then
			begin

			select  max(a.nr_sequencia)
			into STRICT	nr_seq_regra_preco_w
			from  	procedimento_paciente a,
				procedimento b,
				conta_paciente x
			where 	a.cd_procedimento  = b.cd_procedimento
			and 	a.ie_origem_proced = b.ie_origem_proced
			and 	x.nr_interno_conta = a.nr_interno_conta
			and	x.nr_interno_conta = nr_interno_conta_p
			and 	coalesce(a.nr_seq_proc_pacote::text, '') = ''
			and 	b.ie_classificacao <> '1'
			and	coalesce(a.ie_valor_informado,'N') = 'N'
			and 	coalesce(a.nr_seq_regra_preco,0) > 0;

			if (coalesce(nr_seq_regra_preco_w,0) > 0) then
				CALL calcular_regra_preco_taxa(nr_interno_conta_p, nr_seq_regra_preco_w, 1, nm_usuario_p);
			end if;

			end;
		end if;

		if (2 = philips_param_pck.get_cd_pais) and -- 2 = Mexico
			(nr_interno_conta_p IS NOT NULL AND nr_interno_conta_p::text <> '') then
			CALL gerar_tributo_conta_pac(nr_interno_conta_p, 0, 'P', nm_usuario_p);
		end if;

		/*ATUALIZA DADOS DA TABELA CONTA_PACIENTE_RESUMO, RESPONSAVEL PRINCIPALMENTE POR MOSTRAR DEVIDAMENTE
		O TOTAL DA CONTA ATUALIZADO QUANDO ELA ESTA FECHADA*/
		if (ie_atualizar_resumo_p = 'S') then
			CALL atualizar_resumo_conta(nr_interno_conta_p, ie_status_acerto_w);
		end if;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE recalcular_pacotes_conta ( nr_interno_conta_p bigint, nm_usuario_p text, ie_atualizar_resumo_p text) FROM PUBLIC;

