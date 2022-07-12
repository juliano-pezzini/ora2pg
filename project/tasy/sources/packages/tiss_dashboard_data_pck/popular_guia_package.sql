-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE tiss_dashboard_data_pck.popular_guia (nr_seq_conc_pac_p conciliacao_conta_paciente.nr_sequencia%type, nr_interno_conta_p conta_paciente.nr_interno_conta%type) AS $body$
DECLARE


c_guia CURSOR FOR
SELECT	coalesce(a.cd_autorizacao, wheb_mensagem_pck.get_texto(1097738)) 										cd_autorizacao,
	a.nr_interno_conta 															nr_interno_conta,
	b.dt_mesano_referencia															dt_referencia,
	tiss_dashboard_data_pck.obter_se_guia_inadimplente(a.nr_interno_conta, coalesce(a.cd_autorizacao, wheb_mensagem_pck.get_texto(1097738)),  tiss_dashboard_data_pck.obter_pagamento_previsto(a.nr_interno_conta, coalesce(a.cd_autorizacao, wheb_mensagem_pck.get_texto(1097738))))		ie_inadimplente,
	obter_nf_conta(a.nr_interno_conta, 1)													seq_nota_fiscal,
	obter_nf_conta(a.nr_interno_conta, 2)													nota_fiscal,	
	a.vl_guia																vl_guia,
	b.nm_usuario																usuario,
	tiss_dashboard_data_pck.obter_dt_primeiro_retorno(b.nr_seq_protocolo) 												dt_primeiro_retorno,
	(select	max(x.dt_pagamento_previsto) from	titulo_receber x where	x.nr_titulo	= (obter_titulo_conta_guia(a.nr_interno_conta,a.cd_autorizacao,null,null))::numeric ) dt_vencimento,
	tiss_dashboard_data_pck.obter_dt_envio_recurso(a.nr_interno_conta, coalesce(a.cd_autorizacao, wheb_mensagem_pck.get_texto(1097738)))					dt_envio_recurso,
	tiss_dashboard_data_pck.obter_dt_previsao_pag_recurso(a.nr_interno_conta, coalesce(a.cd_autorizacao, wheb_mensagem_pck.get_texto(1097738)))				dt_previsao_pag_recurso,
	coalesce(tiss_dashboard_data_pck.obter_valores_guia(a.nr_interno_conta, coalesce(a.cd_autorizacao, wheb_mensagem_pck.get_texto(1097738)), 'ADIC'), 0)			vl_adicional,
	coalesce(tiss_dashboard_data_pck.obter_valores_guia(a.nr_interno_conta, coalesce(a.cd_autorizacao, wheb_mensagem_pck.get_texto(1097738)), 'DESC'), 0)			vl_desconto,
	coalesce(tiss_dashboard_data_pck.obter_valores_guia(a.nr_interno_conta, coalesce(a.cd_autorizacao, wheb_mensagem_pck.get_texto(1097738)), 'GLOSA'), 0)			vl_glosado,
	coalesce(tiss_dashboard_data_pck.obter_valores_guia(a.nr_interno_conta, coalesce(a.cd_autorizacao, wheb_mensagem_pck.get_texto(1097738)), 'RECEB'), 0)			vl_recebido,
	coalesce(tiss_dashboard_data_pck.obter_valores_guia(a.nr_interno_conta, coalesce(a.cd_autorizacao, wheb_mensagem_pck.get_texto(1097738)), 'REC'), 0)			vl_recursado,
	coalesce(tiss_dashboard_data_pck.obter_valores_guia(a.nr_interno_conta, coalesce(a.cd_autorizacao, wheb_mensagem_pck.get_texto(1097738)), null), 0)			vl_rec_recuperado,
	OBTER_TITULO_CONTA_GUIA(a.nr_interno_conta, coalesce(a.cd_autorizacao, wheb_mensagem_pck.get_texto(1097738)), null, null)			titulo,
	tiss_dashboard_data_pck.obter_saldo_titulo_guia(a.nr_interno_conta, coalesce(a.cd_autorizacao, wheb_mensagem_pck.get_texto(1097738)))				saldo_titulo
from	conta_paciente_guia a,
	conta_paciente b,
	protocolo_convenio c
where	a.nr_interno_conta = b.nr_interno_conta
and	b.nr_interno_conta = nr_interno_conta_p
and	b.nr_seq_protocolo = c.nr_seq_protocolo;

nr_seq_con_conta_pac_w	conciliacao_conta_pac_guia.nr_sequencia%type;

qt_item_vencido_w bigint;
vl_item_vencido_w double precision;

qt_item_prox_venc_w bigint;
vl_item_prox_venc_w double precision;

qt_item_fora_prazo_w bigint;
vl_item_fora_prazo_w double precision;

qt_item_pend_analise_w bigint;

BEGIN	
	for guia in c_guia loop
		PERFORM set_config('tiss_dashboard_data_pck.qt_guia_w', current_setting('tiss_dashboard_data_pck.qt_guia_w')::bigint + 1, false);
		CALL CALL tiss_dashboard_data_pck.printlog('#@ INICIO LOG GUIA @#');
		CALL CALL tiss_dashboard_data_pck.printlog('guia = ' || guia.cd_autorizacao);
		CALL CALL tiss_dashboard_data_pck.printlog('guia.dt_primeiro_retorno = ' || guia.dt_primeiro_retorno);
		CALL CALL tiss_dashboard_data_pck.printlog('guia.ie_inadimplente = ' || guia.ie_inadimplente);
		CALL CALL tiss_dashboard_data_pck.printlog('guia.dt_vencimento = ' || guia.dt_vencimento);
		CALL CALL tiss_dashboard_data_pck.printlog('guia.dt_envio_recurso = ' || guia.dt_envio_recurso);
		CALL CALL tiss_dashboard_data_pck.printlog('guia.dt_previsao_pag_recurso = ' || guia.dt_previsao_pag_recurso);
		CALL CALL tiss_dashboard_data_pck.printlog('guia.vl_adicional = ' || guia.vl_adicional);
		CALL CALL tiss_dashboard_data_pck.printlog('guia.vl_desconto = ' || guia.vl_desconto);
		CALL CALL tiss_dashboard_data_pck.printlog('guia.vl_glosado = ' || guia.vl_glosado);
		CALL CALL tiss_dashboard_data_pck.printlog('guia.vl_guia = ' || guia.vl_guia);
		CALL CALL tiss_dashboard_data_pck.printlog('guia.vl_recebido = ' || guia.vl_recebido);
		CALL CALL tiss_dashboard_data_pck.printlog('guia.vl_recursado = ' || guia.vl_recursado);
		CALL CALL tiss_dashboard_data_pck.printlog('guia.vl_rec_recuperado = ' || guia.vl_rec_recuperado);
		CALL CALL tiss_dashboard_data_pck.printlog('guia.titulo = ' || guia.titulo);
		CALL CALL tiss_dashboard_data_pck.printlog('guia.saldo_titulo = ' || guia.saldo_titulo);
		CALL CALL tiss_dashboard_data_pck.printlog('guia.cd_autorizacao = ' || guia.cd_autorizacao);
		CALL CALL tiss_dashboard_data_pck.printlog('guia.nr_interno_conta = ' || guia.nr_interno_conta);


		select 	nextval('conciliacao_conta_pac_guia_seq')
		into STRICT	nr_seq_con_conta_pac_w
		;

		SELECT * FROM tiss_dashboard_data_pck.calcula_item_datas(guia.nr_interno_conta, guia.cd_autorizacao, vl_item_prox_venc_w, qt_item_prox_venc_w, vl_item_vencido_w, qt_item_vencido_w, vl_item_fora_prazo_w, qt_item_fora_prazo_w) INTO STRICT vl_item_prox_venc_w, qt_item_prox_venc_w, vl_item_vencido_w, qt_item_vencido_w, vl_item_fora_prazo_w, qt_item_fora_prazo_w;

		qt_item_pend_analise_w := tiss_dashboard_data_pck.calcula_item_pendente(guia.nr_interno_conta, guia.cd_autorizacao, qt_item_pend_analise_w);
		
		CALL CALL tiss_dashboard_data_pck.printlog('vl_item_vencido_w = ' || vl_item_vencido_w);
		CALL CALL tiss_dashboard_data_pck.printlog('qt_item_vencido_w = ' || qt_item_vencido_w);
		CALL CALL tiss_dashboard_data_pck.printlog('vl_item_fora_prazo_w = ' || vl_item_fora_prazo_w);
		CALL CALL tiss_dashboard_data_pck.printlog('qt_item_fora_prazo_w = ' || qt_item_fora_prazo_w);
		CALL CALL tiss_dashboard_data_pck.printlog('vl_item_prox_venc_w = ' || vl_item_prox_venc_w);
		CALL CALL tiss_dashboard_data_pck.printlog('qt_item_prox_venc_w = ' || qt_item_prox_venc_w);
		CALL CALL tiss_dashboard_data_pck.printlog('qt_item_pend_analise_w = ' || qt_item_pend_analise_w);
		CALL CALL tiss_dashboard_data_pck.printlog('#@ FIM LOG GUIA @#');

		insert into conciliacao_conta_pac_guia(
			dt_atualizacao,
			dt_atualizacao_nrec,
			nm_usuario,
			nm_usuario_nrec,
			nr_sequencia,
			dt_primeiro_retorno,
			dt_previsao_primeiro_pag,
			dt_envio_recurso,
			dt_previsao_pag_recurso,
			vl_adicional,
			vl_desconto_retorno,
			vl_glosa_aceita,
			vl_guia,
			vl_recebido,
			vl_recursado,
			vl_recurso_recuperado,
			nr_titulo_receber,
			vl_saldo_titulo,
			cd_autorizacao,
			nr_interno_conta,
			ie_inadimplencia,
			nr_seq_conta_pac_conc,
			qt_item_recurso_venc, -- Vencido
			vl_item_recurso_venc,
			qt_item_rec_prox_venc, -- Proximo
			vl_item_rec_prox_venc,
			qt_item_fora_prazo_reap, -- Fora prazo reap
			vl_item_fora_prazo_reap,
			qt_item_pend_analise,
			vl_pend_reapresentacao,
			dt_referencia
		)
		values
		(
			clock_timestamp(),
			clock_timestamp(),
			current_setting('tiss_dashboard_data_pck.nm_usuario_job_w')::usuario.nm_usuario%type,
			current_setting('tiss_dashboard_data_pck.nm_usuario_job_w')::usuario.nm_usuario%type,
			nr_seq_con_conta_pac_w,
			guia.dt_primeiro_retorno,
			guia.dt_vencimento,
			guia.dt_envio_recurso,
			guia.dt_previsao_pag_recurso,
			guia.vl_adicional,
			guia.vl_desconto,
			guia.vl_glosado,
			guia.vl_guia,
			guia.vl_recebido,
			guia.vl_recursado,
			guia.vl_rec_recuperado,
			guia.titulo,
			guia.saldo_titulo,
			guia.cd_autorizacao,
			guia.nr_interno_conta,
			guia.ie_inadimplente,
			nr_seq_conc_pac_p,
			coalesce(qt_item_vencido_w, 0),
			coalesce(vl_item_vencido_w, 0),
			coalesce(qt_item_prox_venc_w, 0),
			coalesce(vl_item_prox_venc_w, 0),
			coalesce(qt_item_fora_prazo_w, 0),
			coalesce(vl_item_fora_prazo_w, 0),
			coalesce(qt_item_pend_analise_w, 0),
			(guia.vl_guia - (coalesce(guia.vl_recebido,0) + coalesce(guia.vl_rec_recuperado,0) + coalesce(guia.vl_glosado,0) + coalesce(guia.vl_recursado,0))),
			guia.dt_referencia
		);

		CALL tiss_dashboard_data_pck.popular_usuario_previsto(nr_seq_con_conta_pac_w, guia.nr_interno_conta, guia.cd_autorizacao);		
		CALL tiss_dashboard_data_pck.popular_glosa(nr_seq_con_conta_pac_w, guia.nr_interno_conta, guia.cd_autorizacao);
		CALL tiss_dashboard_data_pck.popular_item_conciliado(nr_seq_con_conta_pac_w, guia.nr_interno_conta, guia.cd_autorizacao);

	end loop;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tiss_dashboard_data_pck.popular_guia (nr_seq_conc_pac_p conciliacao_conta_paciente.nr_sequencia%type, nr_interno_conta_p conta_paciente.nr_interno_conta%type) FROM PUBLIC;
