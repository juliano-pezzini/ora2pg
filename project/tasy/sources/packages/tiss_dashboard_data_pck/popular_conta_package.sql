-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE tiss_dashboard_data_pck.popular_conta (nr_seq_prot_fatur_p protocolo_faturado.nr_sequencia%type, nr_seq_protocolo_p protocolo_convenio.nr_seq_protocolo%type, dt_primeiro_retorno_p protocolo_faturado.dt_primeiro_retorno%type) AS $body$
DECLARE


c_conta CURSOR FOR
SELECT 	a.nr_interno_conta				nr_interno_conta,
	a.nr_seq_protocolo				nr_seq_protocolo,
	obter_nf_conta(a.nr_interno_conta, 1)		seq_nota_fiscal,
	obter_nf_conta(a.nr_interno_conta, 2)		nota_fiscal,
	substr(obter_titulo_conta(a.nr_interno_conta),1,255)		titulo,
	a.vl_conta					vl_conta,
	a.dt_mesano_referencia				dt_referencia,
	a.nm_usuario					nm_usuario,
	(select	max(x.dt_pagamento_previsto) from	titulo_receber x where	x.nr_interno_conta	= a.nr_interno_conta)	dt_vencimento_prot,
	tiss_dashboard_data_pck.obter_saldo_titulo_conta(a.nr_interno_conta) 	saldo_titulo	
from 	conta_paciente a	
where 	a.nr_seq_protocolo = nr_seq_protocolo_p;

vl_adic_w		conciliacao_conta_paciente.vl_adicional%type;
vl_desc_w		conciliacao_conta_paciente.vl_desconto_retorno%type;
vl_glosa_aceita_w	conciliacao_conta_paciente.vl_glosa_aceita%type;
vl_recebido_w		conciliacao_conta_paciente.vl_recebido%type;
vl_recursado_w		conciliacao_conta_paciente.vl_recursado%type;
vl_recurso_recuperado_w conciliacao_conta_paciente.vl_recurso_recuperado%type;
vl_pend_reapresentacao_w conciliacao_conta_paciente.vl_pend_reapresentacao%type;

dt_envio_recurso_w 		timestamp;
dt_previsao_pag_recurso_w 	timestamp;

nr_seq_conta_w	conciliacao_conta_paciente.nr_sequencia%type;

qt_item_prox_venc_w bigint;
vl_item_prox_venc_w double precision;

BEGIN

	for conta in c_conta loop
		PERFORM set_config('tiss_dashboard_data_pck.qt_conta_w', current_setting('tiss_dashboard_data_pck.qt_conta_w')::bigint + 1, false);
		CALL CALL tiss_dashboard_data_pck.printlog('#@ INICIO LOG CONTA @#');
		CALL CALL tiss_dashboard_data_pck.printlog('conta = ' || conta.nr_interno_conta);

		select	nextval('conciliacao_conta_paciente_seq')
		into STRICT	nr_seq_conta_w
		;

		insert into conciliacao_conta_paciente(
			dt_atualizacao,
			dt_atualizacao_nrec,
			dt_referencia,
			nm_usuario,
			nm_usuario_nrec,
			nr_sequencia,
			nr_seq_protoc_faturado
		)
		values (
			clock_timestamp(),
			clock_timestamp(),
			conta.dt_referencia,
			current_setting('tiss_dashboard_data_pck.nm_usuario_job_w')::usuario.nm_usuario%type,
			current_setting('tiss_dashboard_data_pck.nm_usuario_job_w')::usuario.nm_usuario%type,
			nr_seq_conta_w,
			nr_seq_prot_fatur_p
		);

		CALL tiss_dashboard_data_pck.popular_guia(nr_seq_conta_w, conta.nr_interno_conta);

		select	sum(coalesce(a.vl_adicional, 0)),
			sum(coalesce(a.vl_desconto_retorno, 0)),
			sum(coalesce(a.vl_glosa_aceita, 0)),
			sum(coalesce(a.vl_recebido, 0)),
			sum(coalesce(a.vl_recursado, 0)),
			sum(coalesce(a.vl_recurso_recuperado, 0)),
			sum(coalesce(a.vl_pend_reapresentacao,0))
		into STRICT	vl_adic_w,
			vl_desc_w,
			vl_glosa_aceita_w,
			vl_recebido_w,
			vl_recursado_w,
			vl_recurso_recuperado_w,
			vl_pend_reapresentacao_w
		from	conciliacao_conta_pac_guia a
		where	a.nr_seq_conta_pac_conc 	= nr_seq_conta_w;

		select	min(a.dt_envio_recurso),
			min(a.dt_previsao_pag_recurso)
		into STRICT	dt_envio_recurso_w,
			dt_previsao_pag_recurso_w
		from	conciliacao_conta_pac_guia a
		where	a.nr_seq_conta_pac_conc 	= nr_seq_conta_w;

		select 	sum(a.vl_item_rec_prox_venc),
			sum(a.qt_item_rec_prox_venc)
		into STRICT	vl_item_prox_venc_w,
			qt_item_prox_venc_w
		from	conciliacao_conta_pac_guia a
		where	a.nr_seq_conta_pac_conc 	= nr_seq_conta_w;

		CALL CALL tiss_dashboard_data_pck.printlog('conta.nm_usuario = ' || conta.nm_usuario);
		CALL CALL tiss_dashboard_data_pck.printlog('conta.nr_interno_conta = ' || conta.nr_interno_conta);
		CALL CALL tiss_dashboard_data_pck.printlog('conta.nr_seq_protocolo = ' || conta.nr_seq_protocolo);
		CALL CALL tiss_dashboard_data_pck.printlog('conta.nota_fiscal = ' || conta.nota_fiscal);
		CALL CALL tiss_dashboard_data_pck.printlog('conta.seq_nota_fiscal = ' || conta.seq_nota_fiscal);
		CALL CALL tiss_dashboard_data_pck.printlog('conta.titulo = ' || conta.titulo);
		CALL CALL tiss_dashboard_data_pck.printlog('conta.vl_conta = ' || conta.vl_conta);
		CALL CALL tiss_dashboard_data_pck.printlog('conta.dt_referencia = ' || conta.dt_referencia);
		CALL CALL tiss_dashboard_data_pck.printlog('conta.dt_vencimento_prot = ' || conta.dt_vencimento_prot);
		CALL CALL tiss_dashboard_data_pck.printlog('dt_primeiro_retorno_p = ' || dt_primeiro_retorno_p);
		CALL CALL tiss_dashboard_data_pck.printlog('dt_envio_recurso_w = ' || dt_envio_recurso_w );
		CALL CALL tiss_dashboard_data_pck.printlog('dt_previsao_pag_recurso_w = ' || dt_previsao_pag_recurso_w);
		CALL CALL tiss_dashboard_data_pck.printlog('vl_adic_w = ' || vl_adic_w);
		CALL CALL tiss_dashboard_data_pck.printlog('vl_desc_w = ' || vl_desc_w);
		CALL CALL tiss_dashboard_data_pck.printlog('vl_glosa_aceita_w = ' || vl_glosa_aceita_w);
		CALL CALL tiss_dashboard_data_pck.printlog('vl_recebido_w = ' || vl_recebido_w);
		CALL CALL tiss_dashboard_data_pck.printlog('vl_recursado_w = ' || vl_recursado_w);
		CALL CALL tiss_dashboard_data_pck.printlog('vl_recurso_recuperado_w = ' || vl_recurso_recuperado_w);
		CALL CALL tiss_dashboard_data_pck.printlog('saldo_titulo = ' || conta.saldo_titulo);
		CALL CALL tiss_dashboard_data_pck.printlog('#@ FIM LOG CONTA @#');

		update	conciliacao_conta_paciente
		set	dt_atualizacao_nrec 		= clock_timestamp(),
			nm_usuario_nrec 		= conta.nm_usuario,
			nr_interno_conta 		= conta.nr_interno_conta,
			nr_seq_protocolo 		= conta.nr_seq_protocolo,
			nr_nota_fiscal 			= conta.nota_fiscal,
			nr_seq_nota_fiscal 		= conta.seq_nota_fiscal,
			nr_titulo_receber 		= conta.titulo,
			vl_saldo_titulo			= conta.saldo_titulo,
			vl_conta 			= conta.vl_conta,
			dt_referencia 			= conta.dt_referencia,			
			dt_previsao_primeiro_pag 	= conta.dt_vencimento_prot,
			dt_primeiro_retorno 		= dt_primeiro_retorno_p,
			dt_envio_recurso 		= dt_envio_recurso_w,
			dt_previsao_pag_recurso 	= dt_previsao_pag_recurso_w,
			vl_adicional 			= vl_adic_w,
			vl_desconto_retorno 		= vl_desc_w,
			vl_glosa_aceita 		= vl_glosa_aceita_w,
			vl_recebido 			= vl_recebido_w,
			vl_recursado 			= vl_recursado_w,
			vl_recurso_recuperado 		= vl_recurso_recuperado_w,
			vl_item_rec_prox_venc		= coalesce(vl_item_prox_venc_w, 0),
			qt_item_rec_prox_venc		= coalesce(qt_item_prox_venc_w, 0),
			vl_pend_reapresentacao		= coalesce(vl_pend_reapresentacao_w, 0)			
		where	nr_sequencia 			= nr_seq_conta_w;

	end loop;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tiss_dashboard_data_pck.popular_conta (nr_seq_prot_fatur_p protocolo_faturado.nr_sequencia%type, nr_seq_protocolo_p protocolo_convenio.nr_seq_protocolo%type, dt_primeiro_retorno_p protocolo_faturado.dt_primeiro_retorno%type) FROM PUBLIC;