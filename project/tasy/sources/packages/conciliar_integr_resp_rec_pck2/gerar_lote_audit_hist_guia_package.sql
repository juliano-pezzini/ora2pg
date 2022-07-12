-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE conciliar_integr_resp_rec_pck2.gerar_lote_audit_hist_guia ( nr_interno_conta_p imp_resp_recurso_guia.nr_interno_conta%type, cd_autorizacao_p imp_resp_recurso_guia.cd_autorizacao%type, nr_seq_lote_hist_seq_p lote_audit_hist.nr_sequencia%type, nm_usuario_p imp_resp_recurso_prot.nm_usuario%type, vl_informado_guia_p imp_resp_recurso_guia.vl_informado_guia%type, nr_seq_lote_guia_p INOUT lote_audit_hist_guia.nr_sequencia%type ) AS $body$
DECLARE


nr_seq_lote_hist_guia_w	lote_audit_hist_guia.nr_sequencia%type;


BEGIN

select	nextval('lote_audit_hist_guia_seq')
into STRICT	nr_seq_lote_hist_guia_w
;

insert	into lote_audit_hist_guia(cd_autorizacao,
						dt_atualizacao,
						dt_atualizacao_nrec,
						nm_usuario,
						nm_usuario_nrec,
						nr_interno_conta,
						nr_seq_lote_hist,
						nr_sequencia,
						nr_seq_retorno,
						ie_guia_sem_saldo,
						vl_saldo_guia,
						ds_observacao)
					values (cd_autorizacao_p,
						clock_timestamp(),
						clock_timestamp(),
						nm_usuario_p,
						nm_usuario_p,
						nr_interno_conta_p,
						nr_seq_lote_hist_seq_p,
						nr_seq_lote_hist_guia_w,
						null,
						'N',
						vl_informado_guia_p,
                        null);
commit;

nr_seq_lote_guia_p := nr_seq_lote_hist_guia_w;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE conciliar_integr_resp_rec_pck2.gerar_lote_audit_hist_guia ( nr_interno_conta_p imp_resp_recurso_guia.nr_interno_conta%type, cd_autorizacao_p imp_resp_recurso_guia.cd_autorizacao%type, nr_seq_lote_hist_seq_p lote_audit_hist.nr_sequencia%type, nm_usuario_p imp_resp_recurso_prot.nm_usuario%type, vl_informado_guia_p imp_resp_recurso_guia.vl_informado_guia%type, nr_seq_lote_guia_p INOUT lote_audit_hist_guia.nr_sequencia%type ) FROM PUBLIC;
