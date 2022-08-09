-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_desfazer_sip ( nr_seq_lote_sip_p bigint, nm_usuario_p text) AS $body$
BEGIN

/* Anexo II */

delete	from w_sip_item_despesa
where	nr_seq_lote_sip	= nr_seq_lote_sip_p;

delete	from pls_desp_sip_diops_conta
where	nr_seq_lote_sip	= nr_seq_lote_sip_p;

delete	from w_sip_grupo_beneficiario
where	nr_seq_lote_sip	= nr_seq_lote_sip_p;

/* Anexo III */

delete	from w_sip_anexo
where	nr_seq_lote_sip	= nr_seq_lote_sip_p;

delete	from sip_anexo_iii_procedimento
where	nr_seq_lote_sip	= nr_seq_lote_sip_p;

/* Anexo IV */

delete	from w_sip_atencao_saude
where	nr_seq_lote_sip	= nr_seq_lote_sip_p;

delete	from sip_anexo_iv_procedimento
where	nr_seq_lote_sip	= nr_seq_lote_sip_p;

/* Validação */

delete from pls_despesa_sip_diops
where	nr_seq_lote_sip	= nr_seq_lote_sip_p;

delete	from pls_sip_valor_contabil
where	nr_seq_lote_sip	= nr_seq_lote_sip_p;

update	pls_lote_sip
set	dt_geracao_sip	 = NULL,
	nm_usuario	= nm_usuario_p,
	dt_atualizacao	= clock_timestamp(),
	vl_despesas	= 0
where	nr_sequencia	= nr_seq_lote_sip_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_desfazer_sip ( nr_seq_lote_sip_p bigint, nm_usuario_p text) FROM PUBLIC;
