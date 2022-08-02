-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE reverter_itens_glosados (cd_estabelecimento_p bigint, nr_seq_lote_audit_hist_p bigint, nr_interno_conta_p bigint, cd_convenio_partic_p bigint, cd_categoria_partic_p text, cd_plano_p text, ie_consiste_plano_p text, nm_usuario_p text) AS $body$
DECLARE


cd_convenio_partic_w		integer;
cd_categoria_partic_w		varchar(10);
dt_entrada_unidade_w		timestamp;
nr_sequencia_proc_w		bigint;
nr_seq_interno_w		bigint;
ds_erro_w			varchar(255);
nr_atendimento_w		bigint;
cd_setor_atendimento_w		bigint;
ie_via_acesso_w			varchar(20);
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
qt_procedimento_w		integer;
dt_prescricao_w			timestamp;
nr_prescricao_w			bigint;
nr_sequencia_prescricao_w	bigint;
cd_acao_w			varchar(1);
cd_cgc_prestador_w		varchar(14);
nr_doc_convenio_w		varchar(20);
nr_seq_proc_interno_w		bigint;
cd_medico_executor_w		varchar(10);
cd_senha_w			varchar(20);
nr_seq_exame_w			bigint;
ie_tecnica_utilizada_w		varchar(2);
cd_convenio_w			integer;
cd_categoria_w			varchar(10);
vl_adic_plant_w			double precision;
vl_anestesista_w		double precision;
vl_auxiliares_w			double precision;
vl_custo_operacional_w		double precision;
vl_materiais_w			double precision;
vl_medico_w			double precision;
vl_original_tabela_w		double precision;
vl_procedimento_w		double precision;
nr_sequencia_proc_neg_w		bigint;
nr_seq_mat_atend_w		bigint;
cd_material_w			bigint;
cd_unidade_medida_w		varchar(30);
qt_material_w			double precision;
nr_doc_convenio_mat_w		varchar(20);
ie_tipo_guia_mat_w		varchar(2);
dt_prescricao_mat_w		timestamp;
cd_material_prescricao_mat_w	integer;
cd_material_exec_mat_w		integer;
nr_prescricao_mat_w		bigint;
nr_sequencia_prescricao_mat_w	integer;
cd_acao_mat_w			varchar(1);
qt_executada_mat_w		double precision;
qt_ajuste_conta_mat_w		double precision;
ie_valor_informado_mat_w	varchar(1);
ie_guia_informada_mat_w		varchar(1);
ie_auditoria_mat_w		varchar(1);
cd_situacao_glosa_mat_w		smallint;
nr_seq_cor_exec_mat_w		bigint;
NR_SEQ_TIPO_BAIXA_mat_w		bigint;
cd_senha_mat_w			varchar(20);
vl_material_w			double precision;
vl_tabela_original_w		double precision;
vl_unitario_w			double precision;
CD_CONVENIO_mat_w		integer;
CD_CATEGORIA_mat_w		varchar(10);
nr_seq_mat_neg_w		bigint;
nr_interno_conta_neg_w		bigint;
nr_interno_conta_nova_w		bigint;
ie_valor_informado_w		varchar(1);
dt_acerto_conta_item_w		timestamp;
nr_seq_ret_conta_w		bigint;

nr_seq_ret_propaci_w		bigint;
nr_seq_ret_matpaci_w		bigint;
nr_seq_audit_hist_item_w	bigint;
qt_itens_conta_gerada_w		integer;
ie_funcao_medico_w		varchar(255);

dt_procedimento_w		timestamp;
dt_atendimento_w		timestamp;
dt_conta_w			timestamp;

DT_FIM_CONTA_w			timestamp;

ds_erro_autor_w			varchar(255)	:= null;
ie_regra_w			varchar(3)	:= null;
ie_tipo_atendimento_w		smallint;
nr_seq_regra_w			bigint;
cd_estabelecimento_w		smallint;
ie_bloqueia_agenda_w		varchar(3);
ds_procedimento_w		varchar(255);
ds_material_w			varchar(255);
cont_w				bigint;

ie_proc_edicao_w		varchar(1)	:= 'S';
vl_proc_obtido_w		double precision;

cd_convenio_ref_w		integer;
cd_categoria_ref_w		varchar(10);
ds_irrelevante_w		varchar(30);
ie_glosa_w			varchar(2);
vl_mat_ref_w			double precision;
ie_classificacao_w		varchar(1);
ie_pacote_convenio_w		varchar(1)	:= 'S';
nr_seq_proc_pacote_w		bigint;

qt_glosa_w			double precision;
vl_glosa_w			double precision;

qt_glosa_proced_w		double precision;
vl_glosa_proced_w		double precision;
ie_emite_conta_w		varchar(3);
cd_proc_conv_w			bigint;
ie_origem_conv_w		bigint;
ie_reverter_pacote_w		varchar(15) := 'N';
ie_valor_inf_reversao_w		varchar(15) := 'S';
ie_reverter_participante_w	varchar(15) := 'N';
ie_conta_definitivo_w		varchar(15) := 'N';

nr_seq_partic_w				procedimento_participante.nr_seq_partic%type;
ie_funcao_partic_w			procedimento_participante.ie_funcao%type;
cd_pessoa_fisica_partic_w		procedimento_participante.cd_pessoa_fisica%type;
cd_cgc_partic_w				procedimento_participante.cd_cgc%type;
ie_valor_informado_partic_w		procedimento_participante.ie_valor_informado%type;
ie_emite_conta_partic_w			procedimento_participante.ie_emite_conta%type;
nr_conta_medico_partic_w		procedimento_participante.nr_conta_medico%type;
ie_resp_credito_partic_w		procedimento_participante.ie_responsavel_credito%type;
cd_especialidade_partic_w		procedimento_participante.cd_especialidade%type;
cd_medico_convenio_partic_w		procedimento_participante.cd_medico_convenio%type;
nr_doc_honor_conv_partic_w		procedimento_participante.nr_doc_honor_conv%type;
nr_cirurgia_partic_w			procedimento_participante.nr_cirurgia%type;
cd_cbo_partic_w				procedimento_participante.cd_cbo%type;
ie_doc_executor_partic_w		procedimento_participante.ie_doc_executor%type;
cd_medico_exec_conta_partic_w		procedimento_participante.cd_medico_exec_conta%type;
vl_conta_partic_w			procedimento_participante.vl_conta%type;
vl_original_partic_w			procedimento_participante.vl_original%type;
vl_participante_partic_w		procedimento_participante.vl_participante%type;
ie_glosa_plano_w			regra_ajuste_proc.ie_glosa%type;
nr_seq_regra_preco_w			regra_ajuste_proc.nr_sequencia%type;
nr_seq_mat_simp_w			material_atend_paciente.nr_seq_mat_simp%type;

c01 CURSOR FOR
SELECT  a.nr_atendimento,
	a.cd_setor_atendimento,
	a.ie_via_acesso,
	a.cd_procedimento,
	a.ie_origem_proced,
	a.qt_procedimento,
	a.dt_prescricao,
	a.nr_prescricao,
	a.nr_sequencia_prescricao,
	a.cd_acao,
	a.cd_cgc_prestador,
	a.nr_doc_convenio,
	a.nr_seq_proc_interno,
	a.cd_medico_executor,
	a.cd_senha,
	a.nr_seq_exame,
	a.ie_via_acesso,
	a.ie_tecnica_utilizada,
	a.CD_CONVENIO,
	a.CD_CATEGORIA,
	a.vl_adic_plant,
	a.vl_anestesista,
	a.vl_auxiliares,
	a.vl_custo_operacional,
	a.vl_materiais,
	a.vl_medico,
	a.vl_original_tabela,
	a.vl_procedimento,
	a.ie_valor_informado,
	a.dt_acerto_conta  + (1 / 86400),
	a.nr_sequencia,
	b.nr_sequencia,
	a.dt_procedimento,
	a.dt_conta,
	a.ie_funcao_medico,
	a.nr_seq_proc_pacote,
	b.qt_item,
	b.vl_glosa,
	a.ie_emite_conta,
	a.nr_seq_atepacu,
	a.dt_entrada_unidade
from 	procedimento_paciente a,
	lote_audit_hist_item b
where	a.nr_sequencia = b.nr_seq_propaci
and (coalesce(ie_reverter_pacote_w,'N') = 'S' or (a.nr_sequencia	<> a.nr_seq_proc_pacote or coalesce(a.nr_seq_proc_pacote::text, '') = ''))
and	a.nr_sequencia	in (	SELECT	x.nr_seq_propaci
				from	w_item_reversao_glosa x
				where	x.nm_usuario	= nm_usuario_p)
and	b.nr_sequencia 	in (	select	x.nr_seq_item
				from	w_item_reversao_glosa x
				where	x.nm_usuario	= nm_usuario_p)
and	a.nr_interno_conta	= nr_interno_conta_p;

c02 CURSOR FOR
SELECT  a.nr_atendimento,
	a.cd_setor_atendimento,
	a.cd_material,
	a.cd_unidade_medida,
	a.qt_material,
	a.nr_doc_convenio,
	a.ie_tipo_guia,
	a.dt_prescricao,
	a.cd_material_prescricao,
	a.cd_material_exec,
	a.nr_prescricao,
	a.nr_sequencia_prescricao,
	a.cd_acao,
	a.qt_executada,
	a.qt_ajuste_conta,
	a.ie_valor_informado,
	a.ie_guia_informada,
	a.ie_auditoria,
	a.cd_situacao_glosa,
	a.nr_seq_cor_exec,
	a.NR_SEQ_TIPO_BAIXA,
	a.cd_senha,
	a.vl_material,
	a.vl_tabela_original,
	a.vl_unitario,
	a.cd_convenio,
	a.cd_categoria,
	a.dt_acerto_conta  + (1 / 86400),
	a.nr_sequencia,
	b.nr_sequencia,
	a.dt_atendimento,
	a.dt_conta,
	a.nr_seq_proc_pacote,
	b.qt_item,
	b.vl_glosa,
	a.ie_emite_conta,
	a.nr_seq_atepacu,
	a.dt_entrada_unidade,
	a.nr_seq_mat_simp
from 	material_atend_paciente a,
	lote_audit_hist_item b
where	a.nr_sequencia = b.nr_seq_matpaci
and	a.nr_sequencia	in (	SELECT	x.nr_seq_matpaci
				from	w_item_reversao_glosa x
				where	x.nm_usuario	= nm_usuario_p)
and	b.nr_sequencia 	in (	select	x.nr_seq_item
				from	w_item_reversao_glosa x
				where	x.nm_usuario	= nm_usuario_p)
and	a.nr_interno_conta	= nr_interno_conta_p;

c03 CURSOR FOR
SELECT	a.nr_seq_partic,
	a.ie_funcao,
	a.cd_pessoa_fisica,
	a.cd_cgc,
	a.ie_valor_informado,
	a.ie_emite_conta,
	a.nr_conta_medico,
	a.ie_responsavel_credito,
	a.cd_especialidade,
	a.cd_medico_convenio,
	a.nr_doc_honor_conv,
	a.nr_cirurgia,
	a.cd_cbo,
	a.ie_doc_executor,
	a.cd_medico_exec_conta,
	a.vl_conta,
	a.vl_original,
	a.vl_participante
from	procedimento_participante a,
	grg_proc_partic b
where	b.nr_seq_proc		= a.nr_sequencia
and	b.nr_seq_partic		= a.nr_seq_partic
and	b.nr_seq_hist_item	= nr_seq_audit_hist_item_w
and	a.nr_sequencia		= nr_seq_ret_propaci_w
and	coalesce(ie_reverter_participante_w,'N')	= 'S';


BEGIN

ie_reverter_pacote_w := obter_param_usuario(69, 47, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_reverter_pacote_w);
ie_reverter_participante_w := obter_param_usuario(69, 70, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_reverter_participante_w);
ie_conta_definitivo_w := obter_param_usuario(69, 71, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_conta_definitivo_w);

select 	count(*)
into STRICT   	qt_itens_conta_gerada_w
from 	lote_audit_hist_item a
where	a.nr_sequencia 	in (	SELECT	x.nr_seq_item
				from	w_item_reversao_glosa x
				where	x.nm_usuario	= nm_usuario_p)
and 	((NR_SEQ_PROPACI_PARTIC IS NOT NULL AND NR_SEQ_PROPACI_PARTIC::text <> '') or (NR_SEQ_MATPACI_PARTIC IS NOT NULL AND NR_SEQ_MATPACI_PARTIC::text <> ''));

if (qt_itens_conta_gerada_w > 0) then
	/* Ja foi gerado conta particular para os itens deste retorno */

	CALL wheb_mensagem_pck.exibir_mensagem_abort(190258);
end if;

select	count(*)
into STRICT	cont_w
from	w_item_reversao_glosa x
where	x.nm_usuario		= nm_usuario_p
and	((x.nr_seq_propaci IS NOT NULL AND x.nr_seq_propaci::text <> '') or (x.nr_seq_matpaci IS NOT NULL AND x.nr_seq_matpaci::text <> ''));

if (cont_w > 0) then
	nr_interno_conta_neg_w := Gerar_Contas_Glosa_partic(nr_interno_conta_p, nm_usuario_p, nr_interno_conta_neg_w);
end if;

select 	coalesce(cd_convenio_partic_p, coalesce(max(cd_convenio_partic),0)),
	coalesce(cd_categoria_partic_p, coalesce(max(cd_categoria_partic),0))
into STRICT	cd_convenio_partic_w,
	cd_categoria_partic_w
from 	parametro_faturamento
where 	cd_estabelecimento = cd_estabelecimento_p;

if	((cd_convenio_partic_w = 0) or (cd_categoria_partic_w = 0)) then
	/* Verifique se o convênio e/ou a categoria particular estão informados no Parâmetros do Faturamento */

	CALL wheb_mensagem_pck.exibir_mensagem_abort(190259);
end if;

/*Parametro aplicado para o convêno da conta particular*/

select	coalesce(max(ie_valor_inf_reversao),'S')
into STRICT	ie_valor_inf_reversao_w
from	convenio_estabelecimento
where	cd_convenio		= cd_convenio_partic_w
and	cd_estabelecimento	= cd_estabelecimento_p;


select	nextval('conta_paciente_seq')
into STRICT	nr_interno_conta_nova_w
;

insert into Conta_Paciente(
	nr_atendimento,
	dt_acerto_conta,
	ie_status_acerto,
	dt_periodo_inicial,
	dt_periodo_final,
	dt_atualizacao,
	nm_usuario,
	cd_convenio_parametro,
	nr_protocolo,
	dt_mesano_referencia,
	dt_mesano_contabil,
	cd_convenio_calculo,
	cd_categoria_calculo,
	nr_interno_conta,
	nr_seq_protocolo,
	cd_categoria_parametro,
	ds_inconsistencia,
	dt_recalculo,
	cd_estabelecimento,
	vl_desconto,
	vl_conta,
	cd_plano_retorno_conv)
SELECT	a.nr_atendimento,
	a.dt_acerto_conta + (1/86400),
	1,
	a.dt_periodo_inicial,
	a.dt_periodo_final,
	clock_timestamp(),
	nm_usuario_p,
	cd_convenio_partic_w,
	'0',
	trunc(b.dt_ref_valida,'dd'),
	a.dt_mesano_contabil,
	cd_convenio_partic_w,
	cd_categoria_partic_w,
	nr_interno_conta_nova_w,
	null,
	cd_categoria_partic_w,
	a.ds_inconsistencia,
	a.dt_recalculo,
	a.cd_estabelecimento,
	0,
	a.vl_conta,
	cd_plano_p
from	Convenio b,
	conta_paciente a
where	nr_interno_conta	= nr_interno_conta_p
and	b.cd_convenio		= a.cd_convenio_parametro;


dt_entrada_unidade_w	:= clock_timestamp();


OPEN c01;
LOOP
FETCH c01 into
	nr_atendimento_w,
	cd_setor_atendimento_w,
	ie_via_acesso_w,
	cd_procedimento_w,
	ie_origem_proced_w,
	qt_procedimento_w,
	dt_prescricao_w,
	nr_prescricao_w,
	nr_sequencia_prescricao_w,
	cd_acao_w,
	cd_cgc_prestador_w,
	nr_doc_convenio_w,
	nr_seq_proc_interno_w,
	cd_medico_executor_w,
	cd_senha_w,
	nr_seq_exame_w,
	ie_via_acesso_w,
	ie_tecnica_utilizada_w,
	CD_CONVENIO_w,
	CD_CATEGORIA_w,
	vl_adic_plant_w,
	vl_anestesista_w,
	vl_auxiliares_w,
	vl_custo_operacional_w,
	vl_materiais_w,
	vl_medico_w,
	vl_original_tabela_w,
	vl_procedimento_w,
	ie_valor_informado_w,
	dt_acerto_conta_item_w,
	nr_seq_ret_propaci_w,
	nr_seq_audit_hist_item_w,
	dt_procedimento_w,
	dt_conta_w,
	ie_funcao_medico_w,
	nr_seq_proc_pacote_w,
	qt_glosa_proced_w,
	vl_glosa_proced_w,
	ie_emite_conta_w,
	nr_seq_interno_w,
	dt_entrada_unidade_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	select	DT_FIM_CONTA,
		ie_tipo_atendimento,
		cd_estabelecimento
	into STRICT	DT_FIM_CONTA_w,
		ie_tipo_atendimento_w,
		cd_estabelecimento_w
	from	atendimento_paciente
	where	nr_atendimento	 = nr_atendimento_w;

	if (ie_consiste_plano_p = 'S') then
		SELECT * FROM consiste_plano_convenio(nr_atendimento_w, cd_convenio_partic_w, cd_procedimento_w, ie_origem_proced_w, dt_procedimento_w, qt_glosa_proced_w, ie_tipo_atendimento_w, cd_plano_p, null, ds_erro_autor_w, cd_setor_atendimento_w, nr_seq_exame_w, ie_regra_w, null, nr_seq_regra_w, nr_seq_proc_interno_w, cd_categoria_partic_w, cd_estabelecimento_w, null, cd_medico_executor_w, '', ie_glosa_plano_w, nr_seq_regra_preco_w) INTO STRICT ds_erro_autor_w, ie_regra_w, nr_seq_regra_w, ie_glosa_plano_w, nr_seq_regra_preco_w;

		ds_procedimento_w	:= obter_desc_propaci_int(nr_seq_ret_propaci_w);

		if (ie_regra_w in ('1','2','5')) then
			/* O procedimento ds_procedimento_w não é autorizado para este convênio/plano, por favor verifique. */

			CALL wheb_mensagem_pck.exibir_mensagem_abort(190260,'DS_PROCEDIMENTO_W=' || ds_procedimento_w);
		end if;

		select	coalesce(max(ie_classificacao),'1')
		into STRICT	ie_classificacao_w
		from	procedimento
		where	cd_procedimento		= cd_procedimento_w
		and	ie_origem_proced	= ie_origem_proced_w;

		if (ie_classificacao_w = '1') then
			ie_proc_edicao_w := 	Obter_Se_proc_Edicao(cd_estabelecimento_w,
							cd_convenio_partic_w,
							cd_categoria_partic_w,
							coalesce(dt_conta_w,clock_timestamp()),
							cd_procedimento_w,
							ie_tipo_atendimento_w);
		else
			ie_proc_edicao_w :=	obter_se_proc_tab_serv(cd_estabelecimento_w,
									cd_convenio_partic_w,
									cd_categoria_partic_w,
									coalesce(dt_conta_w,clock_timestamp()),
									cd_procedimento_w,
									ie_origem_proced_w,
									ie_tipo_atendimento_w,
									nr_atendimento_w);
		end if;

		/* Verifica se é de pacote */

		if (ie_proc_edicao_w = 'N') then
			ie_pacote_convenio_w	:= obter_se_pacote_convenio(cd_procedimento_w,
									ie_origem_proced_w,
									cd_convenio_partic_w,
									cd_estabelecimento_w);
		end if;

		if (ie_proc_edicao_w = 'N') and (ie_pacote_convenio_w = 'N') then
			/* O procedimento ds_procedimento_w será glosado pelo convênio. */

			CALL wheb_mensagem_pck.exibir_mensagem_abort(190262,'DS_PROCEDIMENTO_W=' || ds_procedimento_w);
		end if;

		vl_proc_obtido_w := 	obter_preco_procedimento(cd_estabelecimento_w,
						cd_convenio_partic_w,
						cd_categoria_partic_w,
						coalesce(dt_conta_w,clock_timestamp()),
						cd_procedimento_w,
						ie_origem_proced_w,
						0,
						coalesce(ie_tipo_atendimento_w,0),
						0,
						null,
						0,
						null,
						cd_plano_p,
						0,
						0,
						'P');

		if (vl_proc_obtido_w <= 0) and (coalesce(nr_seq_proc_pacote_w,0) = 0) then
			/* Não há preço para o procedimento ds_procedimento_w, ele poderá será glosado. */

			CALL wheb_mensagem_pck.exibir_mensagem_abort(190264,'DS_PROCEDIMENTO_W=' || ds_procedimento_w);
		end if;
	end if;

	if (DT_FIM_CONTA_w IS NOT NULL AND DT_FIM_CONTA_w::text <> '') then
		update 	atendimento_paciente
		set 	dt_fim_conta   	 = NULL,
			ie_fim_conta	= 'A',
			dt_alta_interno	= coalesce(dt_alta, to_date('30/12/2999','dd/mm/yyyy'))
		where 	nr_atendimento 	= nr_atendimento_w;
	end if;

	select nextval('procedimento_paciente_seq')
	into STRICT nr_sequencia_proc_w
	;

	SELECT * FROM Obter_Proc_Tab_Interno_Conv(	nr_seq_proc_interno_w, cd_estabelecimento_w, cd_convenio_partic_w, cd_categoria_partic_w, cd_plano_p, null, cd_proc_conv_w, ie_origem_conv_w, null, null, null, null, null, null, null, null, null, null) INTO STRICT cd_proc_conv_w, ie_origem_conv_w;
					
	insert into procedimento_paciente(
		nr_sequencia,
		nr_atendimento,
		dt_entrada_unidade,
		cd_procedimento,
		ie_origem_proced,
		dt_procedimento,
		qt_procedimento,
		dt_atualizacao,
		nm_usuario,
		cd_convenio,
		cd_categoria,
		dt_prescricao,
		cd_acao,
		cd_setor_atendimento,
		tx_procedimento,
		cd_cgc_prestador,
		nm_usuario_original,
		nr_doc_convenio,
		nr_seq_atepacu,
		ie_auditoria,
		nr_seq_proc_interno,
		cd_medico_executor,
		cd_senha,
		nr_seq_exame,
		ie_via_acesso,
		ie_tecnica_utilizada,
		nr_interno_conta,
		dt_acerto_conta,
		dt_conta,
		ie_funcao_medico,
		ie_emite_conta,
		nr_seq_conta_reversao)
	values (	nr_sequencia_proc_w,
		nr_atendimento_w,
		dt_entrada_unidade_w,
		coalesce(cd_proc_conv_w,cd_procedimento_w),
		coalesce(ie_origem_conv_w,ie_origem_proced_w),
		dt_procedimento_w,
		qt_glosa_proced_w,
		clock_timestamp(),
		nm_usuario_p,
		cd_convenio_partic_w,
		cd_categoria_partic_w,
		dt_prescricao_w,
		cd_acao_w,
		cd_setor_atendimento_w,
		100,
		cd_cgc_prestador_w,
		nm_usuario_p,
		nr_doc_convenio_w,
		nr_seq_interno_w,
		'N',
		nr_seq_proc_interno_w,
		cd_medico_executor_w,
		cd_senha_w,
		nr_seq_exame_w,
		ie_via_acesso_w,
		ie_tecnica_utilizada_w,
		nr_interno_conta_nova_w,
		dt_acerto_conta_item_w,
		dt_conta_w,
		ie_funcao_medico_w,
		ie_emite_conta_w,
		nr_interno_conta_p);

	open C03;
	loop
	fetch C03 into
		nr_seq_partic_w,
		ie_funcao_partic_w,
		cd_pessoa_fisica_partic_w,
		cd_cgc_partic_w,
		ie_valor_informado_partic_w,
		ie_emite_conta_partic_w,
		nr_conta_medico_partic_w,
		ie_resp_credito_partic_w,
		cd_especialidade_partic_w,
		cd_medico_convenio_partic_w,
		nr_doc_honor_conv_partic_w,
		nr_cirurgia_partic_w,
		cd_cbo_partic_w,
		ie_doc_executor_partic_w,
		cd_medico_exec_conta_partic_w,
		vl_conta_partic_w,
		vl_original_partic_w,
		vl_participante_partic_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin

		insert into procedimento_participante(nr_sequencia,
			nr_seq_partic,
			ie_funcao,
			dt_atualizacao,
			nm_usuario,
			cd_pessoa_fisica,
			cd_cgc,
			ie_valor_informado,
			ie_emite_conta,
			nr_conta_medico,
			ie_responsavel_credito,
			cd_especialidade,
			cd_medico_convenio,
			nr_doc_honor_conv,
			nr_cirurgia,
			cd_cbo,
			ie_doc_executor,
			cd_medico_exec_conta)
		values (nr_sequencia_proc_w,
			nr_seq_partic_w,
			ie_funcao_partic_w,
			clock_timestamp(),
			nm_usuario_p,
			cd_pessoa_fisica_partic_w,
			cd_cgc_partic_w,
			ie_valor_informado_partic_w,
			ie_emite_conta_partic_w,
			nr_conta_medico_partic_w,
			ie_resp_credito_partic_w,
			cd_especialidade_partic_w,
			cd_medico_convenio_partic_w,
			nr_doc_honor_conv_partic_w,
			nr_cirurgia_partic_w,
			cd_cbo_partic_w,
			ie_doc_executor_partic_w,
			cd_medico_exec_conta_partic_w);
		end;
	end loop;
	close C03;

	CALL atualiza_preco_procedimento(nr_sequencia_proc_w, cd_convenio_partic_w, nm_usuario_p);

	/*Gerar conta negativa*/

	select nextval('procedimento_paciente_seq')
	into STRICT nr_sequencia_proc_neg_w
	;


	insert into procedimento_paciente(
		nr_sequencia,
		nr_atendimento,
		dt_entrada_unidade,
		cd_procedimento,
		ie_origem_proced,
		dt_procedimento,
		qt_procedimento,
		dt_atualizacao,
		nm_usuario,
		cd_convenio,
		cd_categoria,
		dt_prescricao,
		cd_acao,
		cd_setor_atendimento,
		tx_procedimento,
		cd_cgc_prestador,
		nm_usuario_original,
		nr_doc_convenio,
		nr_seq_atepacu,
		ie_auditoria,
		nr_seq_proc_interno,
		cd_medico_executor,
		cd_senha,
		nr_seq_exame,
		ie_via_acesso,
		ie_tecnica_utilizada,
		vl_adic_plant,
		vl_anestesista,
		vl_auxiliares,
		vl_custo_operacional,
		vl_materiais,
		vl_medico,
		vl_original_tabela,
		vl_procedimento,
		nr_interno_conta,
		ie_valor_informado,
		dt_acerto_conta,
		dt_conta,
		ie_funcao_medico,
		ie_emite_conta,
		nr_seq_conta_reversao)
	values(	nr_sequencia_proc_neg_w,
		nr_atendimento_w,
		dt_entrada_unidade_w,
		cd_procedimento_w,
		ie_origem_proced_w,
		dt_procedimento_w,
		(qt_glosa_proced_w * -1),
		clock_timestamp(),
		nm_usuario_p,
		cd_convenio_w,
		cd_categoria_w,
		dt_prescricao_w,
		cd_acao_w,
		cd_setor_atendimento_w,
		100,
		cd_cgc_prestador_w,
		nm_usuario_p,
		nr_doc_convenio_w,
		nr_seq_interno_w,
		'N',
		nr_seq_proc_interno_w,
		cd_medico_executor_w,
		cd_senha_w,
		nr_seq_exame_w,
		ie_via_acesso_w,
		ie_tecnica_utilizada_w,
		(vl_adic_plant_w * -1),
		((qt_glosa_proced_w * dividir_sem_round(vl_anestesista_w,qt_procedimento_w))  * -1),--(vl_anestesista_w * -1),
		((qt_glosa_proced_w * dividir_sem_round(vl_auxiliares_w,qt_procedimento_w))  * -1),--(vl_auxiliares_w * -1),
		((qt_glosa_proced_w * dividir_sem_round(vl_custo_operacional_w,qt_procedimento_w))  * -1),--(vl_custo_operacional_w * -1),
		((qt_glosa_proced_w * dividir_sem_round(vl_materiais_w,qt_procedimento_w))  * -1),--(vl_materiais_w * -1),
		((qt_glosa_proced_w * dividir_sem_round(vl_medico_w,qt_procedimento_w))  * -1),--(vl_medico_w * -1),
		(vl_original_tabela_w * -1),
		((qt_glosa_proced_w * dividir_sem_round(vl_procedimento_w,qt_procedimento_w))  * -1), --(vl_procedimento_w * -1),
		nr_interno_conta_neg_w,
		ie_valor_informado_w,
		dt_acerto_conta_item_w,
		dt_conta_w,
		ie_funcao_medico_w,
		ie_emite_conta_w,
		nr_interno_conta_p);

	open C03;
	loop
	fetch C03 into
		nr_seq_partic_w,
		ie_funcao_partic_w,
		cd_pessoa_fisica_partic_w,
		cd_cgc_partic_w,
		ie_valor_informado_partic_w,
		ie_emite_conta_partic_w,
		nr_conta_medico_partic_w,
		ie_resp_credito_partic_w,
		cd_especialidade_partic_w,
		cd_medico_convenio_partic_w,
		nr_doc_honor_conv_partic_w,
		nr_cirurgia_partic_w,
		cd_cbo_partic_w,
		ie_doc_executor_partic_w,
		cd_medico_exec_conta_partic_w,
		vl_conta_partic_w,
		vl_original_partic_w,
		vl_participante_partic_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin

		insert into procedimento_participante(nr_sequencia,
			nr_seq_partic,
			ie_funcao,
			dt_atualizacao,
			nm_usuario,
			cd_pessoa_fisica,
			cd_cgc,
			ie_valor_informado,
			ie_emite_conta,
			nr_conta_medico,
			ie_responsavel_credito,
			cd_especialidade,
			cd_medico_convenio,
			nr_doc_honor_conv,
			nr_cirurgia,
			cd_cbo,
			ie_doc_executor,
			cd_medico_exec_conta,
			vl_conta,
			vl_original,
			vl_participante)
		values (nr_sequencia_proc_neg_w,
			nr_seq_partic_w,
			ie_funcao_partic_w,
			clock_timestamp(),
			nm_usuario_p,
			cd_pessoa_fisica_partic_w,
			cd_cgc_partic_w,
			ie_valor_informado_partic_w,
			ie_emite_conta_partic_w,
			nr_conta_medico_partic_w,
			ie_resp_credito_partic_w,
			cd_especialidade_partic_w,
			cd_medico_convenio_partic_w,
			nr_doc_honor_conv_partic_w,
			nr_cirurgia_partic_w,
			cd_cbo_partic_w,
			ie_doc_executor_partic_w,
			cd_medico_exec_conta_partic_w,
			vl_conta_partic_w * -1,
			vl_original_partic_w * -1,
			vl_participante_partic_w * -1);
		end;
	end loop;
	close C03;


	update	lote_audit_hist_item
	set 	NR_SEQ_PROPACI_PARTIC = nr_sequencia_proc_w
	where 	nr_sequencia = nr_seq_audit_hist_item_w;

	update	conta_paciente a
	set	a.nr_seq_conta_origem = nr_interno_conta_p
	where	a.nr_interno_conta = (	SELECT max(x.nr_interno_conta)
					from procedimento_paciente x
					where	x.nr_sequencia = nr_sequencia_proc_w);

END LOOP;
CLOSE c01;

OPEN c02;
LOOP
FETCH c02 into
	nr_atendimento_w,
	cd_setor_atendimento_w,
	cd_material_w,
	cd_unidade_medida_w,
	qt_material_w,
	nr_doc_convenio_mat_w,
	ie_tipo_guia_mat_w,
	dt_prescricao_mat_w,
	cd_material_prescricao_mat_w,
	cd_material_exec_mat_w,
	nr_prescricao_mat_w,
	nr_sequencia_prescricao_mat_w,
	cd_acao_mat_w,
	qt_executada_mat_w,
	qt_ajuste_conta_mat_w,
	ie_valor_informado_mat_w,
	ie_guia_informada_mat_w,
	ie_auditoria_mat_w,
	cd_situacao_glosa_mat_w,
	nr_seq_cor_exec_mat_w,
	NR_SEQ_TIPO_BAIXA_mat_w,
	cd_senha_mat_w,
	vl_material_w,
	vl_tabela_original_w,
	vl_unitario_w,
	CD_CONVENIO_mat_w,
	CD_CATEGORIA_mat_w,
	dt_acerto_conta_item_w,
	nr_seq_ret_matpaci_w,
	nr_seq_audit_hist_item_w,
	dt_atendimento_w,
	dt_conta_w,
	nr_seq_proc_pacote_w,
	qt_glosa_w,
	vl_glosa_w,
	ie_emite_conta_w,
	nr_seq_interno_w,
	dt_entrada_unidade_w,
	nr_seq_mat_simp_w;
EXIT WHEN NOT FOUND; /* apply on c02 */

	select	DT_FIM_CONTA,
		cd_estabelecimento
	into STRICT	DT_FIM_CONTA_w,
		cd_estabelecimento_w
	from	atendimento_paciente
	where	nr_atendimento	 = nr_atendimento_w;

	if (ie_consiste_plano_p = 'S') then
		SELECT * FROM consiste_mat_plano_convenio(cd_convenio_partic_p, cd_plano_p, cd_material_w, nr_atendimento_w, cd_setor_atendimento_w, ds_erro_autor_w, ie_bloqueia_agenda_w, ie_regra_w, nr_seq_regra_w, qt_glosa_w, clock_timestamp(), null, cd_estabelecimento_w, null, null, null, null, null, null, nr_seq_mat_simp_w) INTO STRICT ds_erro_autor_w, ie_bloqueia_agenda_w, ie_regra_w, nr_seq_regra_w;

		ds_material_w	:= obter_desc_matpaci(nr_seq_ret_matpaci_w);

		if (ie_regra_w in ('1','2','5','8')) then
			/* O material ds_material_w não é autorizado para este convênio/plano, por favor verifique. */

			CALL wheb_mensagem_pck.exibir_mensagem_abort(190267,'DS_MATERIAL_W=' || ds_material_w);
		end if;

		cd_convenio_ref_w	:= cd_convenio_partic_w;
		cd_categoria_ref_w	:= cd_categoria_partic_w;

		SELECT * FROM glosa_material(cd_estabelecimento_w, 		-- cd_estabelecimento_p
				nr_atendimento_w,                -- nr_atendimento_p
				coalesce(dt_conta_w,clock_timestamp()),         -- dt_atendimento_p
				cd_material_w,                   -- cd_material_p
				qt_glosa_w,                      -- qt_material_p
				0,                               -- cd_tipo_acomodacao_p
				coalesce(ie_tipo_atendimento_w,0),    -- ie_tipo_atendimento_p
				coalesce(cd_setor_atendimento_w,0),   -- cd_setor_atendimento_p
				0,                               -- qt_idade_p
				null,                            -- cd_proc_referencia_p
				null,                            -- ie_origem_proced_p
				null,                            -- nr_sequencia_p
				null,                            -- nr_seq_proc_interno_p
				cd_convenio_ref_w,               -- cd_convenio_p     	 in
				cd_categoria_ref_w,              -- cd_categoria_p    	 in
				ds_irrelevante_w,                -- ie_tipo_convenio_p	 out
				ds_irrelevante_w,                -- ie_classif_convenio_p out
				ds_irrelevante_w,                -- cd_autorizacao_p    	 out
				ds_irrelevante_w,                -- nr_seq_autorizacao_p  out
				ds_irrelevante_w,                -- qt_autorizada_p    	 out
				ds_irrelevante_w,                -- cd_senha_p    	 out
				ds_irrelevante_w,                -- nm_responsavel_p    	 out
				ie_glosa_w,                      -- ie_glosa_p		 out
				ds_irrelevante_w,                -- cd_situacao_glosa_p	 out
				ds_irrelevante_w,                -- pr_glosa_p		 out
				ds_irrelevante_w, 		-- vl_glosa_p		 out
				ds_irrelevante_w,                -- cd_motivo_exc_conta_p out
				ds_irrelevante_w,                -- ie_autor_particular_p out
				ds_irrelevante_w,                -- cd_convenio_glosa_p	 out
				ds_irrelevante_w,                -- cd_categoria_glosa_p	 out
				nr_seq_regra_w,                  -- nr_seq_regra_ajuste_p out
				0) INTO STRICT 
				cd_convenio_ref_w, 
				cd_categoria_ref_w, 
				ds_irrelevante_w, 
				ds_irrelevante_w, 
				ds_irrelevante_w, 
				ds_irrelevante_w, 
				ds_irrelevante_w, 
				ds_irrelevante_w, 
				ds_irrelevante_w, 
				ie_glosa_w, 
				ds_irrelevante_w, 
				ds_irrelevante_w, 
				ds_irrelevante_w, 
				ds_irrelevante_w, 
				ds_irrelevante_w, 
				ds_irrelevante_w, 
				ds_irrelevante_w, 
				nr_seq_regra_w;                             -- nr_seq_orcamento_p	 in
		if (ie_glosa_w in ('G','T','D','F')) then
			/* O material ds_material_w será glosado. */

			CALL wheb_mensagem_pck.exibir_mensagem_abort(190271,'DS_MATERIAL_W=' || ds_material_w);
		end if;

		vl_mat_ref_w	:= obter_preco_material(cd_estabelecimento_w,
							cd_convenio_partic_w,
							cd_categoria_partic_w,
							coalesce(dt_conta_w,clock_timestamp()),
							cd_material_w,
							0,
							coalesce(ie_tipo_atendimento_w,0),
							coalesce(cd_setor_atendimento_w,0),
							null,
							0,
							0);

		if (vl_mat_ref_w <= 0) and (coalesce(nr_seq_proc_pacote_w,0) = 0) then
			/* O preço do material ds_material_w está zerado, poderá será glosado. */

			CALL wheb_mensagem_pck.exibir_mensagem_abort(190274,'DS_MATERIAL_W=' || ds_material_w);
		end if;

	end if;

	if (DT_FIM_CONTA_w IS NOT NULL AND DT_FIM_CONTA_w::text <> '') then
		update 	atendimento_paciente
		set 	dt_fim_conta   	 = NULL,
			ie_fim_conta	= 'A',
			dt_alta_interno	= coalesce(dt_alta, to_date('30/12/2999','dd/mm/yyyy'))
		where 	nr_atendimento 	= nr_atendimento_w;
	end if;

	/* Conta Particular */

	SELECT	nextval('material_atend_paciente_seq')
	INTO STRICT	nr_seq_mat_atend_w
	;

	INSERT	INTO material_atend_paciente(nr_sequencia,
		nr_atendimento,
		dt_entrada_unidade,
		cd_material,
		dt_atendimento,
		dt_conta,
		cd_unidade_medida,
		qt_material,
		dt_atualizacao,
		nm_usuario,
		cd_convenio,
		cd_categoria,
		nr_doc_convenio,
		ie_tipo_guia,
		dt_prescricao,
		cd_material_prescricao,
		cd_material_exec,
		cd_acao,
		cd_setor_atendimento,
		nm_usuario_original,
		nr_seq_atepacu,
		qt_executada,
		qt_ajuste_conta,
		ie_valor_informado,
		ie_guia_informada,
		ie_auditoria,
		cd_situacao_glosa,
		nr_seq_cor_exec,
		cd_local_estoque,
		NR_SEQ_TIPO_BAIXA,
		cd_senha,
		nr_interno_conta,
		dt_acerto_conta,
		ie_emite_conta,
		nr_seq_conta_reversao)
	VALUES (nr_seq_mat_atend_w,
		nr_atendimento_w,
		dt_entrada_unidade_w,
		cd_material_w,
		dt_atendimento_w,
		dt_conta_w,
		cd_unidade_medida_w,
		qt_glosa_w,
		clock_timestamp(),
		nm_usuario_p,
		cd_convenio_partic_w,
		cd_categoria_partic_w,
		nr_doc_convenio_mat_w,
		ie_tipo_guia_mat_w,
		dt_prescricao_mat_w,
		cd_material_prescricao_mat_w,
		cd_material_exec_mat_w,
		cd_acao_mat_w,
		cd_setor_atendimento_w,
		nm_usuario_p,
		nr_seq_interno_w,
		qt_executada_mat_w,
		qt_ajuste_conta_mat_w,
		CASE WHEN ie_valor_inf_reversao_w='S' THEN ie_valor_informado_mat_w  ELSE null END ,
		ie_guia_informada_mat_w,
		ie_auditoria_mat_w,
		cd_situacao_glosa_mat_w,
		nr_seq_cor_exec_mat_w,
		null,
		NR_SEQ_TIPO_BAIXA_mat_w,
		cd_senha_mat_w,
		nr_interno_conta_nova_w,
		dt_acerto_conta_item_w,
		ie_emite_conta_w,
		nr_interno_conta_p);

	CALL Atualiza_Preco_Material(nr_seq_mat_atend_w,nm_usuario_p);


	/*Gerar conta negativa*/

	SELECT	nextval('material_atend_paciente_seq')
	INTO STRICT	nr_seq_mat_neg_w
	;


	INSERT	INTO material_atend_paciente(nr_sequencia,
		nr_atendimento,
		dt_entrada_unidade,
		cd_material,
		dt_atendimento,
		dt_conta,
		cd_unidade_medida,
		qt_material,
		dt_atualizacao,
		nm_usuario,
		cd_convenio,
		cd_categoria,
		nr_doc_convenio,
		ie_tipo_guia,
		dt_prescricao,
		cd_material_prescricao,
		cd_material_exec,
		cd_acao,
		cd_setor_atendimento,
		nm_usuario_original,
		nr_seq_atepacu,
		qt_executada,
		qt_ajuste_conta,
		ie_valor_informado,
		ie_guia_informada,
		ie_auditoria,
		cd_situacao_glosa,
		nr_seq_cor_exec,
		cd_local_estoque,
		NR_SEQ_TIPO_BAIXA,
		cd_senha,
		vl_material,
		vl_tabela_original,
		vl_unitario,
		nr_interno_conta,
		dt_acerto_conta,
		ie_emite_conta,
		nr_seq_conta_reversao)
	VALUES	(nr_seq_mat_neg_w,
		nr_atendimento_w,
		dt_entrada_unidade_w,
		cd_material_w,
		dt_atendimento_w,
		dt_conta_w,
		cd_unidade_medida_w,
		(qt_glosa_w  * -1),
		clock_timestamp(),
		nm_usuario_p,
		cd_convenio_mat_w,
		cd_categoria_mat_w,
		nr_doc_convenio_mat_w,
		ie_tipo_guia_mat_w,
		dt_prescricao_mat_w,
		cd_material_prescricao_mat_w,
		cd_material_exec_mat_w,
		cd_acao_mat_w,
		cd_setor_atendimento_w,
		nm_usuario_p,
		nr_seq_interno_w,
		CASE WHEN coalesce(qt_executada_mat_w::text, '') = '' THEN null  ELSE (qt_glosa_w  * -1) END ,
		CASE WHEN coalesce(qt_ajuste_conta_mat_w::text, '') = '' THEN null  ELSE (qt_glosa_w  * -1) END ,
		ie_valor_informado_mat_w,
		ie_guia_informada_mat_w,
		ie_auditoria_mat_w,
		cd_situacao_glosa_mat_w,
		nr_seq_cor_exec_mat_w,
		null,
		NR_SEQ_TIPO_BAIXA_mat_w,
		cd_senha_mat_w,
		((qt_glosa_w * dividir_sem_round(vl_material_w,qt_material_w))  * -1),
		(vl_tabela_original_w * -1),
		(vl_unitario_w * -1),
		nr_interno_conta_neg_w,
		dt_acerto_conta_item_w,
		ie_emite_conta_w,
		nr_interno_conta_p);

	update	lote_audit_hist_item
	set 	NR_SEQ_MATPACI_PARTIC = nr_seq_mat_atend_w
	where 	nr_sequencia = nr_seq_audit_hist_item_w;

	update	conta_paciente a
	set	a.nr_seq_conta_origem = nr_interno_conta_p
	where	a.nr_interno_conta = (	SELECT 	max(x.nr_interno_conta)
					from 	material_atend_paciente x
					where	x.nr_sequencia = nr_seq_mat_atend_w);

END LOOP;
CLOSE c02;

update	conta_paciente
set	nr_seq_audit_hist_glosa = nr_seq_lote_audit_hist_p,
	ie_status_acerto = 2
where	nr_interno_conta = nr_interno_conta_neg_w;

CALL gerar_conta_paciente_repasse(nr_interno_conta_neg_w, nm_usuario_p);

update	conta_paciente
set	nr_seq_audit_hist_glosa = nr_seq_lote_audit_hist_p,
	nr_seq_conta_origem	=  nr_interno_conta_p,
	ie_cancelamento		= 'E'
where	nr_interno_conta 	= nr_interno_conta_neg_w;

update	conta_paciente
set	nr_seq_audit_hist_glosa = nr_seq_lote_audit_hist_p,
	nr_seq_conta_origem	= nr_interno_conta_p	
where	nr_interno_conta 	= nr_interno_conta_nova_w;

if (coalesce(ie_conta_definitivo_w,'N') = 'S') then

	update	conta_paciente
	set	ie_status_acerto = 2
	where	nr_interno_conta = nr_interno_conta_nova_w;

	begin
	CALL Atualizar_Resumo_Conta(nr_interno_conta_nova_w, 2);
	exception
	when others then
		/* nr_interno_conta= nr_interno_conta_neg_w */

		CALL wheb_mensagem_pck.exibir_mensagem_abort(190275,'NR_INTERNO_CONTA_NEG_W=' || nr_interno_conta_nova_w);
	end;
end if;
	
begin
CALL Atualizar_Resumo_Conta(nr_interno_conta_neg_w, 2);
exception
when others then
	/* nr_interno_conta= nr_interno_conta_neg_w */

	CALL wheb_mensagem_pck.exibir_mensagem_abort(190275,'NR_INTERNO_CONTA_NEG_W=' || nr_interno_conta_neg_w);
end;

delete from w_item_reversao_glosa where nm_usuario = nm_usuario_p or dt_atualizacao < clock_timestamp() - interval '1 days';

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reverter_itens_glosados (cd_estabelecimento_p bigint, nr_seq_lote_audit_hist_p bigint, nr_interno_conta_p bigint, cd_convenio_partic_p bigint, cd_categoria_partic_p text, cd_plano_p text, ie_consiste_plano_p text, nm_usuario_p text) FROM PUBLIC;

