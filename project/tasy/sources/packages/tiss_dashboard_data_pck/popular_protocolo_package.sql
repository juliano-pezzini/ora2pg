-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE tiss_dashboard_data_pck.popular_protocolo (dt_base_p timestamp, cd_estab_base_p estabelecimento.cd_estabelecimento%type, nr_seq_protocolo_p bigint default null, nm_usuario_p usuario.nm_usuario%type default 'JOB') AS $body$
DECLARE


c_protocolo CURSOR FOR
SELECT  a.cd_convenio 										cd_convenio,
	a.cd_estabelecimento 									cd_estabelecimento,
	a.dt_mesano_referencia 									dt_mesano_referencia,
	a.nr_seq_protocolo 									nr_seq_protocolo,
	obter_total_protocolo(a.nr_seq_protocolo)						vl_protocolo,
	a.nm_usuario										nm_usuario,
	tiss_dashboard_data_pck.obter_vencimento_protocolo(a.nr_seq_protocolo)						dt_vencimento,	
	tiss_dashboard_data_pck.obter_nota_fiscal(a.nr_seq_protocolo)							nota_fiscal,
	tiss_dashboard_data_pck.obter_seq_nota_fiscal_prot(a.nr_seq_protocolo)						seq_nota_fiscal,
	tiss_dashboard_data_pck.obter_dt_primeiro_retorno(a.nr_seq_protocolo)   					dt_primeiro_retorno,
	tiss_dashboard_data_pck.obter_saldo_titulo_prot(a.nr_seq_protocolo)						saldo_titulo,
	substr(obter_titulo_conta_protocolo(a.nr_seq_protocolo, 0),1, 255) 			titulo_protocolo,
	tiss_dashboard_data_pck.obter_se_saldo_difere_prot(a.nr_seq_protocolo)						saldo_difere,
	tiss_dashboard_data_pck.obter_possui_guia_grg_retorno(a.nr_seq_protocolo, a.cd_convenio, a.cd_estabelecimento) 	possui_guia
from 	protocolo_convenio a
where	a.dt_mesano_referencia >= dt_base_p
and (a.cd_estabelecimento = cd_estab_base_p or coalesce(cd_estab_base_p::text, '') = '')
and (coalesce(nr_seq_protocolo_p::text, '') = '' or nr_seq_protocolo_p = a.nr_seq_protocolo);

vl_adic_w		protocolo_faturado.vl_adicional%type;
vl_desc_w		protocolo_faturado.vl_desconto_retorno%type;
vl_glosa_aceita_w	protocolo_faturado.vl_glosa_aceita%type;
vl_recebido_w		protocolo_faturado.vl_recebido%type;
vl_recursado_w		protocolo_faturado.vl_recursado%type;
vl_recurso_recuperado_w protocolo_faturado.vl_recurso_recuperado%type;
vl_pend_reapresentacao_w protocolo_faturado.vl_pend_reapresentacao%type;

dt_envio_recurso_w 		timestamp;
dt_previsao_pag_recurso_w 	timestamp;

nr_seq_prot_fatur_w	protocolo_faturado.nr_sequencia%type;

vl_soma_saldo_tit_w	double precision;

dt_primeiro_retorno_w	protocolo_faturado.dt_primeiro_retorno%type;

qt_item_prox_venc_w 	bigint;
vl_item_prox_venc_w 	double precision;

BEGIN	
	PERFORM set_config('tiss_dashboard_data_pck.nm_usuario_job_w', nm_usuario_p, false);
	PERFORM set_config('tiss_dashboard_data_pck.tmp_ini_pkg_w', CURRENT_TIMESTAMP, false);	
	PERFORM set_config('tiss_dashboard_data_pck.qt_prot_w', 0, false);
	PERFORM set_config('tiss_dashboard_data_pck.qt_conta_w', 0, false);
	PERFORM set_config('tiss_dashboard_data_pck.qt_guia_w', 0, false);
	PERFORM set_config('tiss_dashboard_data_pck.qt_glosa_w', 0, false);

	for protocolo in c_protocolo loop

		if protocolo.saldo_difere = 'S' or protocolo.possui_guia = 'S' or tiss_dashboard_data_pck.obter_se_prot_possui_guia_inad(protocolo.nr_seq_protocolo) = 'S' then
			PERFORM set_config('tiss_dashboard_data_pck.qt_prot_w', current_setting('tiss_dashboard_data_pck.qt_prot_w')::bigint + 1, false);
			CALL CALL tiss_dashboard_data_pck.printlog('#@ INICIO LOG PROTOCOLO @#');
			CALL CALL tiss_dashboard_data_pck.printlog('protocolo = ' ||  protocolo.nr_seq_protocolo);
			CALL CALL tiss_dashboard_data_pck.printlog('protocolo.titulo_protocolo = ' || protocolo.titulo_protocolo);
			CALL CALL tiss_dashboard_data_pck.printlog('protocolo saldo difere = ' || protocolo.saldo_difere);
			CALL CALL tiss_dashboard_data_pck.printlog('cd_empresa = ' || obter_empresa_estab(protocolo.cd_estabelecimento));
			CALL CALL tiss_dashboard_data_pck.printlog('cd_estabelecimento = ' || protocolo.cd_estabelecimento);

			delete from protocolo_faturado
			where 	nr_seq_protocolo = protocolo.nr_seq_protocolo;
			
			if (protocolo.titulo_protocolo IS NOT NULL AND protocolo.titulo_protocolo::text <> '') then

				select	nextval('protocolo_faturado_seq')
				into STRICT	nr_seq_prot_fatur_w
				;

				insert into protocolo_faturado(
					cd_empresa,
					cd_estabelecimento,
					dt_referencia,
					dt_atualizacao,
					dt_atualizacao_nrec,
					nm_usuario,
					nm_usuario_nrec,
					nr_sequencia
				)
				values ( 
					obter_empresa_estab(protocolo.cd_estabelecimento),
					protocolo.cd_estabelecimento,
					protocolo.dt_mesano_referencia,
					clock_timestamp(),
					clock_timestamp(),
					current_setting('tiss_dashboard_data_pck.nm_usuario_job_w')::usuario.nm_usuario%type,
					current_setting('tiss_dashboard_data_pck.nm_usuario_job_w')::usuario.nm_usuario%type,
					nr_seq_prot_fatur_w
				);

				CALL tiss_dashboard_data_pck.popular_conta(nr_seq_prot_fatur_w, protocolo.nr_seq_protocolo, protocolo.dt_primeiro_retorno);

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
				from	conciliacao_conta_paciente a
				where	a.nr_seq_protoc_faturado = nr_seq_prot_fatur_w;

				select	min(a.dt_envio_recurso),
					min(a.dt_previsao_pag_recurso)
				into STRICT	dt_envio_recurso_w,
					dt_previsao_pag_recurso_w
				from	conciliacao_conta_paciente a
				where	a.nr_seq_protoc_faturado = nr_seq_prot_fatur_w;

				select 	sum(a.vl_item_rec_prox_venc),
					sum(a.qt_item_rec_prox_venc)
				into STRICT	vl_item_prox_venc_w,
					qt_item_prox_venc_w
				from	conciliacao_conta_paciente a
				where	a.nr_seq_protoc_faturado = nr_seq_prot_fatur_w;

				CALL CALL tiss_dashboard_data_pck.printlog('vl_adic_w = ' || vl_adic_w);
				CALL CALL tiss_dashboard_data_pck.printlog('vl_desc_w = ' || vl_desc_w);
				CALL CALL tiss_dashboard_data_pck.printlog('vl_glosa_aceita_w = ' || vl_glosa_aceita_w);
				CALL CALL tiss_dashboard_data_pck.printlog('vl_recebido_w = ' || vl_recebido_w);
				CALL CALL tiss_dashboard_data_pck.printlog('vl_recursado_w = ' || vl_recursado_w);
				CALL CALL tiss_dashboard_data_pck.printlog('vl_recurso_recuperado_w = ' || vl_recurso_recuperado_w);
				CALL CALL tiss_dashboard_data_pck.printlog('cd_convenio = ' || protocolo.cd_convenio);
				CALL CALL tiss_dashboard_data_pck.printlog('dt_mesano_referencia = ' || protocolo.dt_mesano_referencia);
				CALL CALL tiss_dashboard_data_pck.printlog('vl_protocolo = ' || protocolo.vl_protocolo);
				CALL CALL tiss_dashboard_data_pck.printlog('dt_vencimento = ' || protocolo.dt_vencimento);
				CALL CALL tiss_dashboard_data_pck.printlog('dt_primeiro_retorno_w = ' || protocolo.dt_primeiro_retorno);			
				CALL CALL tiss_dashboard_data_pck.printlog('titulo_protocolo = ' || protocolo.titulo_protocolo);
				CALL CALL tiss_dashboard_data_pck.printlog('nr_nota_fiscal = ' || protocolo.nota_fiscal);
				CALL CALL tiss_dashboard_data_pck.printlog('seq_nota_fiscal = ' || protocolo.seq_nota_fiscal);			
				CALL CALL tiss_dashboard_data_pck.printlog('saldo_titulo = ' || protocolo.saldo_titulo);
				CALL CALL tiss_dashboard_data_pck.printlog('dt_envio_recurso = ' || dt_envio_recurso_w);
				CALL CALL tiss_dashboard_data_pck.printlog('dt_previsao_pag_recurso = ' || dt_previsao_pag_recurso_w);

				CALL CALL tiss_dashboard_data_pck.printlog('#@ FIM LOG PROTOCOLO @#');

				update 	protocolo_faturado
				set	vl_adicional 			= vl_adic_w,
					vl_desconto_retorno 		= vl_desc_w,
					vl_glosa_aceita 		= vl_glosa_aceita_w,
					vl_recebido 			= vl_recebido_w,
					vl_recursado 			= vl_recursado_w,
					vl_recurso_recuperado 		= vl_recurso_recuperado_w,
					cd_convenio 			= protocolo.cd_convenio,
					dt_referencia 			= protocolo.dt_mesano_referencia,
					vl_protocolo 			= protocolo.vl_protocolo,
					nr_seq_protocolo 		= protocolo.nr_seq_protocolo,
					dt_previsao_primeiro_pag 	= protocolo.dt_vencimento,
					dt_primeiro_retorno 		= dt_primeiro_retorno_w,
					nr_titulo_receber 		= protocolo.titulo_protocolo,
					nr_nota_fiscal 			= protocolo.nota_fiscal,
					nr_seq_nota_fiscal 		= protocolo.seq_nota_fiscal,
					dt_envio_recurso 		= dt_envio_recurso_w,
					dt_previsao_pag_recurso 	= dt_previsao_pag_recurso_w,
					dt_atualizacao_nrec 		= clock_timestamp(),
					nm_usuario_nrec 		= protocolo.nm_usuario,
					vl_saldo_titulo			= protocolo.saldo_titulo,
					vl_item_rec_prox_venc		= coalesce(vl_item_prox_venc_w, 0),
					qt_item_rec_prox_venc		= coalesce(qt_item_prox_venc_w, 0),
					vl_pend_reapresentacao		= coalesce(vl_pend_reapresentacao_w, 0)				
				where	nr_sequencia 			= nr_seq_prot_fatur_w;
				
			end if;

		end if;

	end loop;
	CALL CALL tiss_dashboard_data_pck.printlog('Foram processados ' || current_setting('tiss_dashboard_data_pck.qt_prot_w')::bigint || ' protocolos.');
	CALL CALL tiss_dashboard_data_pck.printlog('Foram processadas ' || current_setting('tiss_dashboard_data_pck.qt_conta_w')::bigint || ' contas.');
	CALL CALL tiss_dashboard_data_pck.printlog('Foram processadas ' || current_setting('tiss_dashboard_data_pck.qt_guia_w')::bigint || ' guias.');
	CALL CALL tiss_dashboard_data_pck.printlog('Foram processadas ' || current_setting('tiss_dashboard_data_pck.qt_glosa_w')::bigint || ' glosas.');
	PERFORM set_config('tiss_dashboard_data_pck.tmp_fim_pkg_w', CURRENT_TIMESTAMP, false);
	CALL CALL tiss_dashboard_data_pck.printlog('O processo levou ' || extract(second from current_setting('tiss_dashboard_data_pck.tmp_fim_pkg_w')::timestamp - current_setting('tiss_dashboard_data_pck.tmp_ini_pkg_w')::timestamp) || ' segundos. ');	
	-- rollback;
	commit;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tiss_dashboard_data_pck.popular_protocolo (dt_base_p timestamp, cd_estab_base_p estabelecimento.cd_estabelecimento%type, nr_seq_protocolo_p bigint default null, nm_usuario_p usuario.nm_usuario%type default 'JOB') FROM PUBLIC;