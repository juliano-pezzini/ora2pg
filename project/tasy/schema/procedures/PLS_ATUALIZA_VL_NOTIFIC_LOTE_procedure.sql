-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualiza_vl_notific_lote (nr_seq_lote_p pls_notificacao_lote.nr_sequencia%type) AS $body$
DECLARE


vl_tot_saldo_titulo_w	pls_notificacao_lote.vl_saldo%type;
vl_tot_juros_w		pls_notificacao_lote.vl_juros%type;
vl_tot_multa_w		pls_notificacao_lote.vl_multa%type;
vl_tot_titulo_w		pls_notificacao_lote.vl_pagar%type;
vl_benef_rescisao_w	pls_notificacao_lote.vl_suspensao%type;
vl_benef_suspensao_w	pls_notificacao_lote.qt_benef_suspenso%type;

qt_pagador_w		bigint;
qt_benef_w		bigint;
qt_pag_rescindido_w	bigint;
qt_pag_suspenso_w	bigint;
qt_benef_rescisao_w	bigint;
qt_benef_suspensao_w	bigint;

BEGIN


select	count(*),
	sum(a.vl_pagador),
	sum(a.vl_juros),
	sum(a.vl_multa),
	sum(a.vl_pagar)
into STRICT	qt_pagador_w,
	vl_tot_saldo_titulo_w,
	vl_tot_juros_w,
	vl_tot_multa_w,
	vl_tot_titulo_w
from	pls_notificacao_pagador	a
where	a.nr_seq_lote	= nr_seq_lote_p;


vl_benef_rescisao_w		:= pls_obter_resc_susp_lote_not(nr_seq_lote_p,null,'VBR');
vl_benef_suspensao_w		:= pls_obter_resc_susp_lote_not(nr_seq_lote_p,null,'VBS');
qt_benef_w			:= pls_obter_resc_susp_lote_not(nr_seq_lote_p,null,'B');
qt_pag_rescindido_w		:= pls_obter_resc_susp_lote_not(nr_seq_lote_p,null,'PR');
qt_pag_suspenso_w		:= pls_obter_resc_susp_lote_not(nr_seq_lote_p,null,'PS');
qt_benef_suspensao_w		:= pls_obter_resc_susp_lote_not(nr_seq_lote_p,null,'BS');
qt_benef_rescisao_w		:= pls_obter_resc_susp_lote_not(nr_seq_lote_p,null,'BR');

update	pls_notificacao_lote
set	vl_saldo		= vl_tot_saldo_titulo_w,
	vl_titulo		= vl_tot_titulo_w,
	vl_juros		= vl_tot_juros_w,
	vl_multa		= vl_tot_multa_w,
	vl_pagar		= vl_tot_saldo_titulo_w + vl_tot_juros_w + vl_tot_multa_w,
	qt_benef_rescindido	= qt_benef_rescisao_w,
	qt_pagador		= qt_pagador_w,
	vl_rescisao		= vl_benef_rescisao_w,
	vl_suspensao		= vl_benef_suspensao_w,
	qt_benef_suspenso	= qt_benef_suspensao_w,
	qt_pagador_resc		= qt_pag_rescindido_w,
	qt_pagador_susp		= qt_pag_suspenso_w,
	qt_beneficiarios	= qt_benef_w
where	nr_sequencia		= nr_seq_lote_p;

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualiza_vl_notific_lote (nr_seq_lote_p pls_notificacao_lote.nr_sequencia%type) FROM PUBLIC;

