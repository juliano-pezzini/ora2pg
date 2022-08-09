-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_conta_part_ret_glosa ( cd_estabelecimento_p conta_paciente.cd_estabelecimento%type, nm_usuario_p conta_paciente.nm_usuario%type, nr_seq_retorno_p conta_paciente.nr_seq_ret_glosa%type, nr_interno_conta_p conta_paciente.nr_interno_conta%type, ds_seq_proc_p text, ds_seq_mat_p text, cd_convenio_partic_p parametro_faturamento.cd_convenio_partic%type, cd_categoria_partic_p parametro_faturamento.cd_categoria_partic%type, ds_seq_ret_glosa_p text, cd_plano_p conta_paciente.cd_plano_retorno_conv%type, ie_consiste_plano_p text, nr_seq_categoria_iva_p conta_paciente.nr_seq_categoria_iva%type default null) AS $body$
DECLARE


cd_convenio_partic_w		conta_paciente.cd_convenio_calculo%type;
cd_categoria_partic_w		conta_paciente.cd_categoria_calculo%type;
nr_interno_conta_neg_w		conta_paciente.nr_interno_conta%type;
nr_interno_conta_nova_w		conta_paciente.nr_interno_conta%type;
cd_convenio_ref_w		conta_paciente.cd_convenio_calculo%type;
cd_categoria_ref_w		conta_paciente.cd_categoria_calculo%type;

dt_entrada_unidade_w		procedimento_paciente.dt_entrada_unidade%type;
nr_sequencia_proc_w		procedimento_paciente.nr_sequencia%type;
nr_seq_interno_w		procedimento_paciente.nr_seq_atepacu%type;
nr_atendimento_w		procedimento_paciente.nr_atendimento%type;
cd_setor_atendimento_w		procedimento_paciente.cd_setor_atendimento%type;
ie_via_acesso_w			procedimento_paciente.ie_via_acesso%type;
cd_procedimento_w		procedimento_paciente.cd_procedimento%type;
ie_origem_proced_w		procedimento_paciente.ie_origem_proced%type;
qt_procedimento_w		procedimento_paciente.qt_procedimento%type;
dt_prescricao_w			procedimento_paciente.dt_prescricao%type;
nr_prescricao_w			procedimento_paciente.nr_prescricao%type;
nr_sequencia_prescricao_w	procedimento_paciente.nr_sequencia_prescricao%type;
cd_acao_w			procedimento_paciente.cd_acao%type;
cd_cgc_prestador_w		procedimento_paciente.cd_cgc_prestador%type;
nr_doc_convenio_w		procedimento_paciente.nr_doc_convenio%type;
nr_seq_proc_interno_w		procedimento_paciente.nr_seq_proc_interno%type;
cd_medico_executor_w		procedimento_paciente.cd_medico_executor%type;
cd_senha_w			procedimento_paciente.cd_senha%type;
nr_seq_exame_w			procedimento_paciente.nr_seq_exame%type;
ie_tecnica_utilizada_w		procedimento_paciente.ie_tecnica_utilizada%type;
cd_convenio_w			procedimento_paciente.cd_convenio%type;
cd_categoria_w			procedimento_paciente.cd_categoria%type;
vl_adic_plant_w			procedimento_paciente.vl_adic_plant%type;
vl_anestesista_w		procedimento_paciente.vl_anestesista%type;
vl_auxiliares_w			procedimento_paciente.vl_auxiliares%type;
vl_custo_operacional_w		procedimento_paciente.vl_custo_operacional%type;
vl_materiais_w			procedimento_paciente.vl_materiais%type;
vl_medico_w			procedimento_paciente.vl_medico%type;
vl_original_tabela_w		procedimento_paciente.vl_original_tabela%type;
vl_procedimento_w		procedimento_paciente.vl_procedimento%type;
nr_sequencia_proc_neg_w		procedimento_paciente.nr_sequencia%type;
ie_valor_informado_w		procedimento_paciente.ie_valor_informado%type;
dt_acerto_conta_item_w		procedimento_paciente.dt_acerto_conta%type;
nr_seq_ret_propaci_w		procedimento_paciente.nr_sequencia%type;
ie_funcao_medico_w		procedimento_paciente.ie_funcao_medico%type;
dt_procedimento_w		procedimento_paciente.dt_procedimento%type;
dt_conta_w			procedimento_paciente.dt_conta%type;
nr_seq_proc_pacote_w		procedimento_paciente.nr_seq_proc_pacote%type;
vl_proc_obtido_w		procedimento_paciente.vl_procedimento%type;
ie_emite_conta_w		procedimento_paciente.ie_emite_conta%type;
nr_seq_pacote_w			procedimento_paciente.nr_sequencia%type := null;
tx_procedimento_w		procedimento_paciente.tx_procedimento%type;

ds_procedimento_w		procedimento.ds_procedimento%type;
ie_classificacao_w		procedimento.ie_classificacao%type;

nr_seq_mat_atend_w		material_atend_paciente.nr_sequencia%type;
cd_material_w			material_atend_paciente.cd_material%type;
cd_unidade_medida_w		material_atend_paciente.cd_unidade_medida%type;
qt_material_w			material_atend_paciente.qt_material%type;
nr_doc_convenio_mat_w		material_atend_paciente.nr_doc_convenio%type;
ie_tipo_guia_mat_w		material_atend_paciente.ie_tipo_guia%type;
dt_prescricao_mat_w		material_atend_paciente.dt_prescricao%type;
cd_material_prescricao_mat_w	material_atend_paciente.cd_material_prescricao%type;
cd_material_exec_mat_w		material_atend_paciente.cd_material_exec%type;
nr_prescricao_mat_w		material_atend_paciente.nr_prescricao%type;
nr_sequencia_prescricao_mat_w	material_atend_paciente.nr_sequencia_prescricao%type;
cd_acao_mat_w			material_atend_paciente.cd_acao%type;
qt_executada_mat_w		material_atend_paciente.qt_executada%type;
qt_ajuste_conta_mat_w		material_atend_paciente.qt_ajuste_conta%type;
ie_valor_informado_mat_w	material_atend_paciente.ie_valor_informado%type;
ie_guia_informada_mat_w		material_atend_paciente.ie_guia_informada%type;
ie_auditoria_mat_w		material_atend_paciente.ie_auditoria%type;
cd_situacao_glosa_mat_w		material_atend_paciente.cd_situacao_glosa%type;
nr_seq_cor_exec_mat_w		material_atend_paciente.nr_seq_cor_exec%type;
NR_SEQ_TIPO_BAIXA_mat_w		material_atend_paciente.nr_seq_tipo_baixa%type;
cd_senha_mat_w			material_atend_paciente.cd_senha%type;
vl_material_w			material_atend_paciente.vl_material%type;
vl_tabela_original_w		material_atend_paciente.vl_tabela_original%type;
vl_unitario_w			material_atend_paciente.vl_unitario%type;
cd_convenio_mat_w		material_atend_paciente.cd_convenio%type;
cd_categoria_mat_w		material_atend_paciente.cd_categoria%type;
nr_seq_mat_neg_w		material_atend_paciente.nr_sequencia%type;
nr_seq_ret_matpaci_w		material_atend_paciente.nr_sequencia%type;
dt_atendimento_w		material_atend_paciente.dt_atendimento%type;
vl_mat_ref_w			material_atend_paciente.vl_material%type;
nr_seq_mat_simp_w		material_atend_paciente.nr_seq_mat_simp%type;

ds_material_w			material.ds_material%type;

dt_fim_conta_w			atendimento_paciente.dt_fim_conta%type;
ie_tipo_atendimento_w		atendimento_paciente.ie_tipo_atendimento%type;
cd_estabelecimento_w		atendimento_paciente.cd_estabelecimento%type;
cd_pessoa_fisica_w		atendimento_paciente.cd_pessoa_fisica%type;

nr_seq_ret_glosa_w		convenio_retorno_glosa.nr_sequencia%type;
qt_glosa_w			convenio_retorno_glosa.qt_glosa%type;
vl_glosa_w			convenio_retorno_glosa.vl_glosa%type;
qt_glosa_proced_w		convenio_retorno_glosa.qt_glosa%type;
vl_glosa_proced_w		convenio_retorno_glosa.vl_glosa%type;

ie_valor_inf_reversao_w		convenio_estabelecimento.ie_valor_inf_reversao%type;

ie_regra_w			regra_convenio_plano.ie_regra%type := null;
nr_seq_regra_w			regra_convenio_plano.nr_sequencia%type;

ie_glosa_plano_w		regra_ajuste_proc.ie_glosa%type;
nr_seq_regra_preco_w		regra_ajuste_proc.nr_sequencia%type;

qt_itens_conta_gerada_w		integer;
cont_w				integer;
qt_item_pacote_w		integer := 0;

ds_erro_autor_w			varchar(255) := null;
ie_bloqueia_agenda_w		varchar(3);
ie_proc_edicao_w		varchar(1) := 'S';
ds_irrelevante_w		varchar(30);
ie_glosa_w			varchar(2);
ie_pacote_convenio_w		varchar(1) := 'S';
ie_reverte_mesmo_conv_w		varchar(1);

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
	b.qt_glosa,
	b.vl_glosa,
	a.ie_emite_conta
from 	procedimento_paciente a,
	convenio_retorno_glosa b
where	a.nr_sequencia = b.nr_seq_propaci
and	a.nr_sequencia	in (	SELECT	x.nr_seq_propaci 
				from	w_ret_glosa x
				where	x.nm_usuario	= nm_usuario_p)
and	b.nr_sequencia 	in (	select	x.nr_seq_ret_glosa
				from	w_ret_glosa x
				where	x.nm_usuario	= nm_usuario_p)
--and	' ' || ds_seq_proc_p || ' ' like '% ' || a.nr_sequencia || ' %'		-- Edgar 18/05/2009, OS 143284, troquei o like por tabela w

--and 	' ' || ds_seq_ret_glosa_p || ' ' like '% ' || b.nr_sequencia || ' %'
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
	b.qt_glosa,
	b.vl_glosa,
	a.ie_emite_conta,
	a.nr_seq_mat_simp
from 	material_atend_paciente a,
	convenio_retorno_glosa b
where	a.nr_sequencia = b.nr_seq_matpaci
and	a.nr_sequencia	in (	SELECT	x.nr_seq_matpaci 
				from	w_ret_glosa x
				where	x.nm_usuario	= nm_usuario_p)
and	b.nr_sequencia 	in (	select	x.nr_seq_ret_glosa
				from	w_ret_glosa x
				where	x.nm_usuario	= nm_usuario_p)
--and	' ' || ds_seq_mat_p || ' ' like '% ' || a.nr_sequencia || ' %'	-- Edgar 18/05/2009, OS 143284, troquei o like por tabela w

--and 	' ' || ds_seq_ret_glosa_p || ' ' like '% ' || b.nr_sequencia || ' %'
and	a.nr_interno_conta	= nr_interno_conta_p;



BEGIN

/*Inicio lhalves OS 325009 em 31/05/2011 - Nao gerar o pacote e tambem os itens do pacote.*/

select	max(a.nr_sequencia)
into STRICT	nr_seq_pacote_w
from 	procedimento_paciente a,
	convenio_retorno_glosa b
where	a.nr_sequencia	= b.nr_seq_propaci
and	a.nr_sequencia	     in (	SELECT	x.nr_seq_propaci 
				from	w_ret_glosa x
				where	x.nm_usuario	= nm_usuario_p)
and	b.nr_sequencia 	     in (	select	x.nr_seq_ret_glosa
				from	w_ret_glosa x
				where	x.nm_usuario	= nm_usuario_p)
and	a.nr_seq_proc_pacote in (	select	x.nr_seq_propaci 
				from	w_ret_glosa x
				where	x.nm_usuario	= nm_usuario_p)
and	a.nr_sequencia		= a.nr_seq_proc_pacote
and	a.nr_interno_conta		= nr_interno_conta_p;

select	case count(a.nr_sequencia)
		when 0 then 0
		else 1
	end
into STRICT	qt_item_pacote_w
from 	procedimento_paciente a,
	convenio_retorno_glosa b
where	a.nr_sequencia	= b.nr_seq_propaci
and	a.nr_sequencia	in (	SELECT	x.nr_seq_propaci 
				from	w_ret_glosa x
				where	x.nm_usuario	= nm_usuario_p)
and	b.nr_sequencia 	in (	select	x.nr_seq_ret_glosa
				from	w_ret_glosa x
				where	x.nm_usuario	= nm_usuario_p)
and	a.nr_seq_proc_pacote	= nr_seq_pacote_w
and	a.nr_sequencia		<> nr_seq_pacote_w
and	a.nr_interno_conta		= nr_interno_conta_p;

if (nr_seq_pacote_w IS NOT NULL AND nr_seq_pacote_w::text <> '') and (qt_item_pacote_w > 0) then

	delete 	from W_RET_GLOSA
	where 	nm_usuario 	= nm_usuario_p;

	commit;
	
	/*r.aise_application_error(-20011,'Foram selecionados os itens do pacote e o pacote!' || chr(13) || chr(10) ||
				'Verifique os itens selecionados.');*/
	CALL wheb_mensagem_pck.exibir_mensagem_abort(263337);
end if;
/*Fim lhalves OS 325009 */

select 	case count(a.nr_sequencia)
		when 0 then 0
		else 1
	end
into STRICT   	qt_itens_conta_gerada_w
from 	convenio_retorno_glosa a

where	a.nr_sequencia 	in (	SELECT	x.nr_seq_ret_glosa
				from	w_ret_glosa x
				where	x.nm_usuario	= nm_usuario_p)
and 	((NR_SEQ_PROPACI_PARTIC IS NOT NULL AND NR_SEQ_PROPACI_PARTIC::text <> '') or (NR_SEQ_MATPACI_PARTIC IS NOT NULL AND NR_SEQ_MATPACI_PARTIC::text <> ''));

if (qt_itens_conta_gerada_w > 0) then
	--r.aise_application_error(-20011,'Ja foi gerado conta particular para os itens deste retorno');
	CALL wheb_mensagem_pck.exibir_mensagem_abort(263338);
end if;

select	case count(x.nr_sequencia)
		when 0 then 0
		else 1
	end
into STRICT	cont_w
from	w_ret_glosa x
where	x.nm_usuario		= nm_usuario_p
and	((x.nr_seq_propaci IS NOT NULL AND x.nr_seq_propaci::text <> '') or (x.nr_seq_matpaci IS NOT NULL AND x.nr_seq_matpaci::text <> ''));

--if	((ds_seq_mat_p is not null) or (ds_seq_proc_p is not null)) then
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
	--r.aise_application_error(-20011,'Verifique se o convenio e/ou a categoria particular estao informados no Parametros do Faturamento');
	CALL wheb_mensagem_pck.exibir_mensagem_abort(263339);
end if;

select	coalesce(max(ie_valor_inf_reversao),'N')
into STRICT	ie_valor_inf_reversao_w
from	convenio_estabelecimento
where	cd_estabelecimento = cd_estabelecimento_p
and	cd_convenio	   = cd_convenio_partic_w;


begin
select	'S'
into STRICT	ie_reverte_mesmo_conv_w
from	conta_paciente a
where	a.nr_interno_conta 	 = nr_interno_conta_p
and	a.cd_convenio_parametro  = cd_convenio_partic_w
and	a.cd_categoria_parametro = cd_categoria_partic_w;
exception
when others then
	ie_reverte_mesmo_conv_w := 'N';
end;


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
	cd_plano_retorno_conv,
	ie_tipo_atend_conta,
	ie_tipo_atend_tiss,
	nr_seq_saida_consulta,
	nr_seq_saida_spsadt,
	nr_seq_saida_int,
	ie_tipo_consulta_tiss,
	ie_tipo_fatur_tiss,
	nr_seq_categoria_iva)
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
	cd_plano_p,
	a.ie_tipo_atend_conta,
	a.ie_tipo_atend_tiss,
	a.nr_seq_saida_consulta,
	a.nr_seq_saida_spsadt,
	a.nr_seq_Saida_int,
	a.ie_tipo_consulta_tiss,
	a.ie_tipo_fatur_tiss,
	nr_seq_categoria_iva_p
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
	nr_seq_ret_glosa_w,
	dt_procedimento_w,
	dt_conta_w,
	ie_funcao_medico_w,
	nr_seq_proc_pacote_w,
	qt_glosa_proced_w,
	vl_glosa_proced_w,
	ie_emite_conta_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	select	DT_FIM_CONTA,
		ie_tipo_atendimento,
		cd_estabelecimento,
		cd_pessoa_fisica
	into STRICT	DT_FIM_CONTA_w,
		ie_tipo_atendimento_w,
		cd_estabelecimento_w,
		cd_pessoa_fisica_w
	from	atendimento_paciente
	where	nr_atendimento	 = nr_atendimento_w;

	/* Francisco - 23/04/2009 - Consistir plano */

	if (ie_consiste_plano_p = 'S') then
		SELECT * FROM consiste_plano_convenio(nr_atendimento_w, cd_convenio_partic_w, cd_procedimento_w, ie_origem_proced_w, dt_procedimento_w, qt_glosa_proced_w, ie_tipo_atendimento_w, cd_plano_p, null, ds_erro_autor_w, cd_setor_atendimento_w, nr_seq_exame_w, ie_regra_w, null, nr_seq_regra_w, nr_seq_proc_interno_w, cd_categoria_partic_w, cd_estabelecimento_w, null, cd_medico_executor_w, cd_pessoa_fisica_w, ie_glosa_plano_w, nr_seq_regra_preco_w) INTO STRICT ds_erro_autor_w, ie_regra_w, nr_seq_regra_w, ie_glosa_plano_w, nr_seq_regra_preco_w;

		ds_procedimento_w	:= obter_desc_propaci_int(nr_seq_ret_propaci_w);

		if (ie_regra_w in ('1','2','5')) then
			--r.aise_application_error(-20011,'O procedimento "' || ds_procedimento_w || '" nao e autorizado para este convenio/plano, por favor verifique.');
			CALL wheb_mensagem_pck.exibir_mensagem_abort(263340,'DS_PROCEDIMENTO_W='||DS_PROCEDIMENTO_W);

		/*	Edgar 04/06/2009, OS 146703, a pedido do HSL tiramos esta consistencia
		elsif	(ie_regra_w in ('3','6','7')) then 
			r.aise_application_error(-20011,'O procedimento "' || ds_procedimento_w || '" requer autorizacao do convenio, por favor verifique.');
		*/
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

		/* Verifica se e de pacote */

		if (ie_proc_edicao_w = 'N') then
			ie_pacote_convenio_w	:= obter_se_pacote_convenio(cd_procedimento_w,
									ie_origem_proced_w,
									cd_convenio_partic_w,
									cd_estabelecimento_w);
		end if;

		if (ie_proc_edicao_w = 'N') and (ie_pacote_convenio_w = 'N') then
			--r.aise_application_error(-20011,'O procedimento "' || ds_procedimento_w || '" sera glosado pelo convenio.');
			CALL wheb_mensagem_pck.exibir_mensagem_abort(263341,'DS_PROCEDIMENTO_W='||DS_PROCEDIMENTO_W);
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
			--r.aise_application_error(-20011,'Nao ha preco para o procedimento "' || ds_procedimento_w || '", ele podera sera glosado.');	
			CALL wheb_mensagem_pck.exibir_mensagem_abort(263342,'DS_PROCEDIMENTO_W='||DS_PROCEDIMENTO_W);
		end if;		
	end if;

	if (DT_FIM_CONTA_w IS NOT NULL AND DT_FIM_CONTA_w::text <> '') then
		update 	atendimento_paciente
		set 	dt_fim_conta   	 = NULL,
			ie_fim_conta	= 'A',
			dt_alta_interno	= coalesce(dt_alta, to_date('30/12/2999','dd/mm/yyyy'))
		where 	nr_atendimento 	= nr_atendimento_w;
	end if;


	/*Convenio particular */

	select	max(nr_seq_interno), max(dt_entrada_unidade)
	into STRICT	nr_seq_interno_w, dt_entrada_unidade_w
	from	atend_paciente_unidade
	where	nr_atendimento		= nr_atendimento_w
	  and	cd_setor_atendimento	= cd_setor_atendimento_w;

	select nextval('procedimento_paciente_seq')
	into STRICT nr_sequencia_proc_w
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
		nr_interno_conta,
		dt_acerto_conta,
		dt_conta,
		ie_funcao_medico,
		ie_emite_conta,
		vl_adic_plant,
		vl_anestesista,
		vl_auxiliares,
		vl_custo_operacional,
		vl_materiais,
		vl_medico,
		vl_original_tabela,
		vl_procedimento,
		ie_valor_informado)
	values (	nr_sequencia_proc_w,
		nr_atendimento_w,
		dt_entrada_unidade_w,
		cd_procedimento_w,
		ie_origem_proced_w,
		dt_procedimento_w,
		qt_glosa_proced_w,
		clock_timestamp(),
		nm_usuario_p,
		cd_convenio_partic_w,
		cd_categoria_partic_w,
		dt_prescricao_w,
		cd_acao_w,
		cd_setor_atendimento_w,
		tx_procedimento_w,
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
		vl_adic_plant_w,
		vl_anestesista_w,
		vl_auxiliares_w,
		vl_custo_operacional_w,
		vl_materiais_w,
		vl_medico_w,
		vl_original_tabela_w,
		vl_procedimento_w,
		ie_valor_inf_reversao_w);

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
		ie_emite_conta)
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
		tx_procedimento_w,
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
		ie_emite_conta_w);


	update 	convenio_retorno_glosa
	set 	NR_SEQ_PROPACI_PARTIC = nr_sequencia_proc_w
	where 	nr_sequencia = nr_seq_ret_glosa_w;
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
	nr_seq_ret_glosa_w,
	dt_atendimento_w,
	dt_conta_w,
	nr_seq_proc_pacote_w,
	qt_glosa_w,
	vl_glosa_w,
	ie_emite_conta_w,
	nr_seq_mat_simp_w;
EXIT WHEN NOT FOUND; /* apply on c02 */

	select	DT_FIM_CONTA,
		cd_estabelecimento
	into STRICT	DT_FIM_CONTA_w,
		cd_estabelecimento_w
	from	atendimento_paciente
	where	nr_atendimento	 = nr_atendimento_w;

	/* Francisco - 23/04/2009 - Consistir plano */

	if (ie_consiste_plano_p = 'S') then
		SELECT * FROM consiste_mat_plano_convenio(cd_convenio_partic_p, cd_plano_p, cd_material_w, nr_atendimento_w, cd_setor_atendimento_w, ds_erro_autor_w, ie_bloqueia_agenda_w, ie_regra_w, nr_seq_regra_w, qt_glosa_w, clock_timestamp(), null, cd_estabelecimento_w, null, null, null, null, null, null, nr_seq_mat_simp_w) INTO STRICT ds_erro_autor_w, ie_bloqueia_agenda_w, ie_regra_w, nr_seq_regra_w;
		
		ds_material_w	:= obter_desc_matpaci(nr_seq_ret_matpaci_w);

		if (ie_regra_w in ('1','2','5','8')) then
			--r.aise_application_error(-20011,'O material "' || ds_material_w || '" nao e autorizado para este convenio/plano, por favor verifique.');
			CALL wheb_mensagem_pck.exibir_mensagem_abort(263343,'DS_MATERIAL_W='||DS_MATERIAL_W);

		/*	Edgar 04/06/2009, OS 146703, a pedido do HSL tiramos esta consistencia
		elsif	(ie_regra_w in ('3','6','7')) then 
			ra.ise_application_error(-20011,'O material "' || ds_material_w || '" requer autorizacao do convenio, por favor verifique.');
		*/
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
				ds_irrelevante_w,                -- vl_glosa_p		 out
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
			--ra.ise_application_error(-20011,'O material "' || ds_material_w || '" sera glosado.');
			CALL wheb_mensagem_pck.exibir_mensagem_abort(263344,'DS_MATERIAL_W='||DS_MATERIAL_W);
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
			--ra.ise_application_error(-20011,'O preco do material "' || ds_material_w || '" esta zerado, podera sera glosado.');
			CALL wheb_mensagem_pck.exibir_mensagem_abort(263346,'DS_MATERIAL_W='||DS_MATERIAL_W);
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

	select	max(nr_seq_interno), max(dt_entrada_unidade)
	into STRICT	nr_seq_interno_w, dt_entrada_unidade_w
	from	atend_paciente_unidade
	where	nr_atendimento		= nr_atendimento_w
	  and	cd_setor_atendimento	= cd_setor_atendimento_w;


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
		vl_material,
		vl_tabela_original,
		vl_unitario)
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
		ie_valor_inf_reversao_w,
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
		vl_material_w,
		vl_tabela_original_w,
		vl_unitario_w);

	CALL atualiza_Preco_Material(nr_seq_mat_atend_w,nm_usuario_p);


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
		ie_emite_conta)
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
		((qt_glosa_w * dividir_sem_round(vl_material_w,qt_material_w))  * -1), /* OS 182824 - Tive que tirar o vl unitario */
		(vl_tabela_original_w * -1),
		(vl_unitario_w * -1),
		nr_interno_conta_neg_w,
		dt_acerto_conta_item_w,
		ie_emite_conta_w);

	update 	convenio_retorno_glosa
	set 	NR_SEQ_MATPACI_PARTIC = nr_seq_mat_atend_w	
	where 	nr_sequencia = nr_seq_ret_glosa_w;


END LOOP;
CLOSE c02;

update	conta_paciente
set	nr_seq_ret_glosa =  nr_seq_retorno_p,
	ie_status_acerto = 2
where	nr_interno_conta = nr_interno_conta_neg_w;

/* Francisco - OS 128657 - 18/02/2009 - Forcar estorno do repasse */

CALL gerar_conta_paciente_repasse(nr_interno_conta_neg_w, nm_usuario_p);

update	conta_paciente
set	nr_seq_ret_glosa 	=  nr_seq_retorno_p,
	nr_seq_conta_origem	=  nr_interno_conta_p,
	ie_cancelamento		= 'E'
where	nr_interno_conta = nr_interno_conta_neg_w;

update	conta_paciente
set	nr_seq_ret_glosa = nr_seq_retorno_p,
	nr_seq_conta_origem	= nr_interno_conta_p
where	nr_interno_conta = nr_interno_conta_nova_w;

--Gerar_conta_paciente_guia(nr_interno_conta_neg_w, 2);
begin
CALL Atualizar_Resumo_Conta(nr_interno_conta_neg_w, 2);
exception
when others then
	--r.aise_application_error(-20011,'nr_interno_conta= ' || nr_interno_conta_neg_w);
	CALL wheb_mensagem_pck.exibir_mensagem_abort(263356,'NR_INTERNO_CONTA_NEG_W='||NR_INTERNO_CONTA_NEG_W);
end;

delete from W_RET_GLOSA where nm_usuario = nm_usuario_p or dt_atualizacao < clock_timestamp() - interval '1 days';

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_conta_part_ret_glosa ( cd_estabelecimento_p conta_paciente.cd_estabelecimento%type, nm_usuario_p conta_paciente.nm_usuario%type, nr_seq_retorno_p conta_paciente.nr_seq_ret_glosa%type, nr_interno_conta_p conta_paciente.nr_interno_conta%type, ds_seq_proc_p text, ds_seq_mat_p text, cd_convenio_partic_p parametro_faturamento.cd_convenio_partic%type, cd_categoria_partic_p parametro_faturamento.cd_categoria_partic%type, ds_seq_ret_glosa_p text, cd_plano_p conta_paciente.cd_plano_retorno_conv%type, ie_consiste_plano_p text, nr_seq_categoria_iva_p conta_paciente.nr_seq_categoria_iva%type default null) FROM PUBLIC;
