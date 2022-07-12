-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_gerencia_envio_ans_pck.popula_dados_adic_proc_lote ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


qt_registro_w			integer;
dados_proc_update_w		pls_gerencia_envio_ans_pck.dados_monitor_proc_update;
vl_glosa_w			pls_conta_proc.vl_glosa%type;
vl_liberado_w			pls_conta_medica_resumo.vl_liberado%type;
qt_pago_w			pls_conta_proc.qt_procedimento%type;
vl_coparticipacao_w		pls_conta_coparticipacao.vl_coparticipacao%type;
ie_origem_proced_w		pls_conta_proc.ie_origem_proced%type;
cd_tabela_ref_w			pls_monitor_tiss_proc_val.cd_tabela_ref%type;
nr_seq_regra_tab_w		pls_regra_tabela_tiss.nr_sequencia%type;
ie_origem_tab_ref_w		pls_monitor_tiss_proc.ie_origem_tab_ref%type;
cd_grupo_proc_w			pls_monitor_tiss_proc_val.cd_grupo_proc%type;
nr_seq_regra_gpo_proc_w		pls_monitor_tiss_reg_gpo.nr_sequencia%type;
ie_origem_grupo_proc_w		pls_monitor_tiss_proc_val.ie_origem_grupo_proc%type;
cd_procedimento_w		pls_conversao_proc.cd_proc_conversao%type;
nr_seq_regra_conversao_w	pls_conversao_proc.nr_sequencia%type;
ie_somente_codigo_w		pls_conversao_proc.ie_somente_codigo%type;
ie_converter_item_w		pls_monitor_tiss_param.ie_converte_item%type;
ie_pacote_intercambio_w	pls_pacote.ie_pacote_intercambio%type;
cd_serv_w				ptu_nota_servico.cd_servico%type;


-- insere todos os dados adicionais dos procedimentos que foram selecionados

C01 CURSOR(	nr_seq_lote_pc		pls_monitor_tiss_lote.nr_sequencia%type,
		cd_estabelecimento_pc	estabelecimento.cd_estabelecimento%type) FOR
	SELECT 	c.nr_sequencia nr_seq_upd,
		a.ie_origem_proced,
		coalesce(a.cd_procedimento,a.cd_procedimento_imp) cd_procedimento,
		CASE WHEN coalesce(f.dt_pagamento_recurso::text, '') = '' THEN CASE WHEN coalesce(f.dt_pagamento_previsto::text, '') = '' THEN 0  ELSE CASE WHEN a.qt_procedimento=0 THEN 1  ELSE a.qt_procedimento END  END   ELSE CASE WHEN a.qt_procedimento=0 THEN 1  ELSE a.qt_procedimento END  END  qt_pago,
		CASE WHEN coalesce(a.vl_provisao,0)=0 THEN  CASE WHEN coalesce(a.vl_procedimento_imp,0)=0 THEN a.vl_procedimento  ELSE a.vl_procedimento_imp END   ELSE a.vl_provisao END 	vl_apresentado,
		CASE WHEN coalesce(a.qt_procedimento_imp, 0)=0 THEN  a.qt_procedimento  ELSE a.qt_procedimento_imp END  qt_apresentado,
		CASE WHEN coalesce(f.dt_pagamento_recurso::text, '') = '' THEN CASE WHEN coalesce(f.dt_pagamento_previsto::text, '') = '' THEN 0  ELSE a.vl_liberado END   ELSE a.vl_liberado END  vl_pago,
		pls_gerencia_envio_ans_pck.obter_tipo_diaria(coalesce(a.cd_procedimento,a.cd_procedimento_imp), a.ie_origem_proced, a.dt_procedimento_referencia) ie_tipo_diaria,
		a.vl_glosa,
		a.cd_dente,
		pls_obter_cta_proc_face_dente(a.nr_sequencia) cd_face_dente,
		a.cd_regiao_boca,
		a.ie_tipo_despesa,
		a.nr_seq_pacote,
		f.dt_pagamento_previsto,
		a.nr_sequencia nr_seq_conta_proc,
		a.nr_seq_conta,
		a.dt_procedimento_referencia dt_procedimento,
		pls_gerencia_envio_ans_pck.obter_valor_coparticipacao(a.nr_seq_conta, f.ie_tipo_guia, f.ie_tipo_atendimento, a.nr_sequencia, null, 'N', f.nr_seq_conta_rec) vl_coparticipacao,
		e.nr_seq_prestador_exec,
		s.nr_seq_congenere_ok,
		s.nr_seq_contrato,
		s.nr_seq_intercambio,
		e.nr_seq_tipo_atendimento,		
		e.nr_seq_nota_cobranca,
		e.ie_origem_conta
	FROM pls_monitor_tiss_cta_val f, pls_monitor_tiss_proc_val c, pls_conta_proc a, pls_conta e
LEFT OUTER JOIN pls_segurado s ON (e.nr_seq_segurado = s.nr_sequencia)
WHERE f.nr_seq_lote_monitor 	= nr_seq_lote_pc and f.nr_sequencia in ( SELECT y.nr_sequencia
                            from pls_monitor_tiss_cta_val y,
                                 pls_monitor_tiss_alt x
                            where x.ie_tipo_evento not in ('AV', 'AD','FR')
                                and x.ie_status in ('P', 'N')
                                 and x.dt_evento between current_setting('pls_gerencia_envio_ans_pck.dt_mes_competencia_ini_w')::pls_monitor_tiss_lote.dt_mes_competencia%type and current_setting('pls_gerencia_envio_ans_pck.dt_mes_competencia_fim_w')::pls_monitor_tiss_lote.dt_mes_competencia%type
                                and  y.nr_seq_lote_monitor = nr_seq_lote_pc
                                and y.nr_seq_conta = x.nr_seq_conta) and f.ie_conta_atualizada 	= 'S' and e.nr_sequencia		= a.nr_seq_conta and c.nr_seq_cta_val 	= f.nr_sequencia  and a.nr_sequencia 		= c.nr_seq_conta_proc and a.ie_status in ('A', 'C', 'L', 'M', 'P', 'S', 'U');
BEGIN

qt_registro_w := 0;

select coalesce(max(ie_converte_item),'N') ie_converte_item,
		coalesce(max(ie_conv_pacote_int), 'N') ie_conv_pacote_int
  into STRICT 	ie_converter_item_w,
	current_setting('pls_gerencia_envio_ans_pck.ie_conv_pacote_int_w')::pls_monitor_tiss_param.ie_conv_pacote_int%type
  from pls_monitor_tiss_param
 where cd_estabelecimento = cd_estabelecimento_p;

---Obtem as informaes dos procedimentos da conta e insere na tabela para ajuste das informaes

for	r_C01_w in C01( nr_seq_lote_p, cd_estabelecimento_p) loop

	vl_glosa_w		:= r_C01_w.vl_glosa;
	qt_pago_w		:= r_C01_w.qt_pago;
	cd_procedimento_w  := r_C01_w.cd_procedimento;
	ie_origem_proced_w := r_C01_w.ie_origem_proced;
		
	if (current_setting('pls_gerencia_envio_ans_pck.ie_conv_pacote_int_w')::pls_monitor_tiss_param.ie_conv_pacote_int%type = 'S' and ie_origem_proced_w = 4 and r_c01_w.ie_origem_conta = 'A') then
		
		select  coalesce(max(ie_pacote_intercambio),'N')
		into STRICT	ie_pacote_intercambio_w
		from	pls_pacote
		where 	cd_procedimento = cd_procedimento_w
		and 	ie_origem_proced = ie_origem_proced_w;
		
		if ( ie_pacote_intercambio_w = 'S') then
		
			select  max(c.cd_servico)
			into STRICT 	cd_serv_w
			from	ptu_nota_servico c
			where 	c.nr_seq_nota_cobr = r_C01_w.nr_seq_nota_cobranca
			and 	c.nr_seq_conta_proc = r_c01_w.nr_seq_conta_proc;		
		
			if (cd_serv_w IS NOT NULL AND cd_serv_w::text <> '') then
			
				cd_procedimento_w := cd_serv_w;
			
			end if;
		
		end if;
		
	
	elsif (ie_converter_item_w = 'S') then
		pls_obter_proced_conversao(	r_C01_w.cd_procedimento, r_C01_w.ie_origem_proced, r_c01_w.nr_seq_prestador_exec,
						cd_estabelecimento_p, 10,r_c01_w.nr_seq_congenere_ok,
						null,'E', r_c01_w.nr_seq_contrato,
						r_c01_w.nr_seq_intercambio,r_c01_w.nr_seq_congenere_ok, null,
						null, cd_procedimento_w, ie_origem_proced_w,
						nr_seq_regra_conversao_w, ie_somente_codigo_w, r_c01_w.dt_procedimento,
						r_c01_w.nr_seq_tipo_atendimento, null, null);
	end if;

	--se for pacote de pacote desconvertido para o codigo vindo no intercambio, necessario manter o codigo e origem convertidos na busca, para que seja possivel determinar a tab referencia.

	if (current_setting('pls_gerencia_envio_ans_pck.ie_origem_regra_conv_tab_w')::pls_monitor_tiss_param.ie_origem_regra_conv_tab%type != 'T' and (current_setting('pls_gerencia_envio_ans_pck.ie_conv_pacote_int_w')::pls_monitor_tiss_param.ie_conv_pacote_int%type = 'S' and ie_origem_proced_w = 4 and r_c01_w.ie_origem_conta = 'A')) then
		SELECT * FROM pls_gerencia_envio_ans_pck.obter_tipo_tabela_tiss(	r_c01_w.cd_procedimento, r_c01_w.ie_origem_proced, r_C01_w.nr_seq_pacote, r_C01_w.ie_tipo_despesa, null, cd_estabelecimento_p, cd_tabela_ref_w, nr_seq_regra_tab_w, ie_origem_tab_ref_w) INTO STRICT cd_tabela_ref_w, nr_seq_regra_tab_w, ie_origem_tab_ref_w;
	else
		SELECT * FROM pls_gerencia_envio_ans_pck.obter_tipo_tabela_tiss(	cd_procedimento_w, ie_origem_proced_w, r_C01_w.nr_seq_pacote, r_C01_w.ie_tipo_despesa, null, cd_estabelecimento_p, cd_tabela_ref_w, nr_seq_regra_tab_w, ie_origem_tab_ref_w) INTO STRICT cd_tabela_ref_w, nr_seq_regra_tab_w, ie_origem_tab_ref_w;
								

		
	end if;

	SELECT * FROM pls_gerencia_envio_ans_pck.obter_grupo_proc_ans(	cd_procedimento_w, ie_origem_proced_w, r_C01_w.ie_tipo_despesa, null, '', cd_estabelecimento_p, 'N', cd_grupo_proc_w, nr_seq_regra_gpo_proc_w, ie_origem_grupo_proc_w) INTO STRICT cd_grupo_proc_w, nr_seq_regra_gpo_proc_w, ie_origem_grupo_proc_w;
	vl_coparticipacao_w	:= 0;

	if (coalesce(vl_glosa_w,0) > coalesce(r_C01_w.vl_apresentado, 0)) then
		vl_glosa_w	:= r_C01_w.vl_apresentado;
	end if;

	if (vl_glosa_w < 0) then
		vl_glosa_w := 0;
	end if;

	vl_liberado_w	:= r_C01_w.vl_pago;

	if (coalesce(r_C01_w.vl_pago,0) > 0) and (r_C01_w.dt_pagamento_previsto IS NOT NULL AND r_C01_w.dt_pagamento_previsto::text <> '') then

		select	sum(coalesce(a.vl_liberado,0))
		into STRICT	vl_liberado_w
		from	pls_conta_medica_resumo		a,
			pls_pag_prest_vencimento	b,
			pls_pagamento_prestador		c,
			pls_pagamento_item		d,
			pls_lote_pagamento		e,
			titulo_pagar			f
		where	e.nr_sequencia 		= c.nr_seq_lote
		and	a.nr_seq_lote_pgto	= e.nr_sequencia
		and	a.nr_seq_pag_item	= d.nr_sequencia
		and	c.nr_sequencia		= d.nr_seq_pagamento
		and	c.nr_sequencia		= b.nr_seq_pag_prestador
		and	b.nr_titulo		= f.nr_titulo
		and	a.ie_situacao 		= 'A'
		and	a.nr_seq_conta		= r_C01_w.nr_seq_conta
		and	a.nr_seq_conta_proc	= r_C01_w.nr_seq_conta_proc
		and	f.dt_liquidacao between current_setting('pls_gerencia_envio_ans_pck.dt_mes_competencia_ini_w')::pls_monitor_tiss_lote.dt_mes_competencia%type and current_setting('pls_gerencia_envio_ans_pck.dt_mes_competencia_fim_w')::pls_monitor_tiss_lote.dt_mes_competencia%type;

		if (coalesce(vl_liberado_w,0) = 0) then
			vl_liberado_w	:= r_C01_w.vl_pago;
		end if;
	end if;

	if (coalesce(vl_liberado_w,0) = 0) and (qt_pago_w	> 0) then
		qt_pago_w	:= 0;
	end if;

	if (coalesce(ie_origem_proced_w::text, '') = '') then
		ie_origem_proced_w := pls_obter_origem_proced(cd_estabelecimento_p, null, 'R', r_C01_w.dt_procedimento, null);
	end if;

	--Armazena o valor que cada um dos campos da PLS_MONITOR_TISS_PROC_VAL receber

	dados_proc_update_w.nr_sequencia(qt_registro_w)		:= r_C01_w.nr_seq_upd;
	dados_proc_update_w.cd_grupo_proc(qt_registro_w)	:= cd_grupo_proc_w;
	dados_proc_update_w.ie_origem_proced(qt_registro_w)	:= ie_origem_proced_w;
	dados_proc_update_w.cd_procedimento(qt_registro_w)	:= cd_procedimento_w;
	dados_proc_update_w.cd_tabela_ref(qt_registro_w)	:= cd_tabela_ref_w;
	dados_proc_update_w.qt_liberado(qt_registro_w)		:= qt_pago_w;
	dados_proc_update_w.vl_procedimento(qt_registro_w)	:= coalesce(r_C01_w.vl_apresentado, 0);
	dados_proc_update_w.qt_procedimento(qt_registro_w)	:= coalesce(r_C01_w.qt_apresentado,1);
	dados_proc_update_w.vl_liberado(qt_registro_w)		:= vl_liberado_w;
	dados_proc_update_w.ie_tipo_diaria(qt_registro_w)	:= r_C01_w.ie_tipo_diaria;
	dados_proc_update_w.vl_glosa(qt_registro_w)		:= vl_glosa_w;
	dados_proc_update_w.cd_dente(qt_registro_w)		:= r_C01_w.cd_dente;
	dados_proc_update_w.cd_face_dente(qt_registro_w)	:= r_C01_w.cd_face_dente;
	dados_proc_update_w.cd_regiao_boca(qt_registro_w)	:= r_C01_w.cd_regiao_boca;
	dados_proc_update_w.ie_tipo_despesa(qt_registro_w)	:= r_C01_w.ie_tipo_despesa;
	dados_proc_update_w.nr_seq_pacote(qt_registro_w)	:= r_C01_w.nr_seq_pacote;
	dados_proc_update_w.vl_coparticipacao(qt_registro_w)	:= r_C01_w.vl_coparticipacao;
	dados_proc_update_w.ie_item_atualizado(qt_registro_w)	:= 'S';
	dados_proc_update_w.ie_origem_tab_ref(qt_registro_w)	:= ie_origem_tab_ref_w;
	dados_proc_update_w.nr_seq_regra_tab_ref(qt_registro_w) := nr_seq_regra_tab_w;
	dados_proc_update_w.nr_seq_regra_gpo_proc(qt_registro_w):= nr_seq_regra_gpo_proc_w;
	dados_proc_update_w.ie_origem_grupo_proc(qt_registro_w)	:= ie_origem_grupo_proc_w;

	if (qt_registro_w >= current_setting('pls_gerencia_envio_ans_pck.qt_registro_transacao_w')::integer) then

		CALL pls_gerencia_envio_ans_pck.atualizar_monitor_tiss_proc( dados_proc_update_w, nm_usuario_p);

		--Limpa as variveis do type DADOS_MONITOR_PROC_UPDATE

		dados_proc_update_w := pls_gerencia_envio_ans_pck.limpar_type_dados_proc_update(dados_proc_update_w);

		qt_registro_w := 0;
	else
		qt_registro_w := qt_registro_w + 1;
	end if;
end loop;

--Atualiza os dados da PLS_MONITOR_TISS_PROC_VAL que restaram nas variveis do type DADOS_MONITOR_PROC_UPDATE

CALL pls_gerencia_envio_ans_pck.atualizar_monitor_tiss_proc( dados_proc_update_w, nm_usuario_p);

--Limpa as variveis do type DADOS_MONITOR_PROC_UPDATE

dados_proc_update_w := pls_gerencia_envio_ans_pck.limpar_type_dados_proc_update(dados_proc_update_w);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerencia_envio_ans_pck.popula_dados_adic_proc_lote ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;