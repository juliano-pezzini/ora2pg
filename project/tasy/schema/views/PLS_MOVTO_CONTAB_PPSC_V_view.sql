-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_movto_contab_ppsc_v (ie_status, nr_seq_conta_proc, nr_seq_conta_mat, cd_conta_credito, cd_conta_debito, cd_classif_cred, cd_classif_deb, nr_seq_esquema, nr_sequencia, nr_seq_item_mensalidade, ds_conta_glosa, nr_seq_conta_copartic, nr_seq_conta_pos_estab, nr_seq_atualizacao, nr_seq_ppsc_movimento, nr_seq_ppsc_mov_item, nr_seq_fatura_proc, nr_seq_fatura_mat, nr_seq_evento_movimento, nr_seq_pag_tributo) AS select	a.ie_status,
	a.nr_seq_conta_proc,
	a.nr_seq_conta_mat,
	b.cd_conta_credito,
	b.cd_conta_debito,
	b.cd_classif_cred,
	b.cd_classif_deb,
	b.nr_seq_regra_contabil nr_seq_esquema,
	a.nr_sequencia,
	a.nr_seq_item_mensalidade,
	'Normal' ds_conta_glosa,
	a.nr_seq_conta_copartic,
	a.nr_seq_conta_pos_estab,
	a.nr_seq_atualizacao,
	a.nr_seq_ppsc_movimento,
	a.nr_seq_ppsc_mov_item,
	a.nr_seq_fatura_proc,
	a.nr_seq_fatura_mat,
	a.nr_seq_evento_movimento,
	a.nr_seq_pag_tributo
FROM	pls_movimento_contabil	a,
	pls_ppsc_movimento	b
where	a.nr_seq_ppsc_movimento	= b.nr_sequencia
and	ie_conta_glosa	= 'M'

union all

select	a.ie_status,
	a.nr_seq_conta_proc,
	a.nr_seq_conta_mat,
	b.cd_conta_cred_reversao cd_conta_cred,
	b.cd_conta_deb_reversao cd_conta_deb,
	b.cd_classif_cred_reversao cd_classif_cred,
	b.cd_classif_deb_reversao cd_classif_deb,
	b.nr_seq_regra_cont_reversao nr_seq_esquema,
	a.nr_sequencia,
	a.nr_seq_item_mensalidade,
	'Reversão' ds_conta_glosa,
	a.nr_seq_conta_copartic,
	a.nr_seq_conta_pos_estab,
	a.nr_seq_atualizacao,
	a.nr_seq_ppsc_movimento,
	a.nr_seq_ppsc_mov_item,
	a.nr_seq_fatura_proc,
	a.nr_seq_fatura_mat,
	a.nr_seq_evento_movimento,
	a.nr_seq_pag_tributo
from	pls_movimento_contabil	a,
	pls_ppsc_movimento	b
where	a.nr_seq_ppsc_movimento	= b.nr_sequencia
and	ie_conta_glosa	= 'R'

union all

select	a.ie_status,
	a.nr_seq_conta_proc,
	a.nr_seq_conta_mat,
	b.cd_conta_cred,
	b.cd_conta_deb,
	b.cd_classif_cred,
	b.cd_classif_deb,
	b.nr_seq_regra_contabil nr_seq_esquema,
	a.nr_sequencia,
	a.nr_seq_item_mensalidade,
	'Normal' ds_conta_glosa,
	a.nr_seq_conta_copartic,
	a.nr_seq_conta_pos_estab,
	a.nr_seq_atualizacao,
	a.nr_seq_ppsc_movimento,
	a.nr_seq_ppsc_mov_item,
	a.nr_seq_fatura_proc,
	a.nr_seq_fatura_mat,
	a.nr_seq_evento_movimento,
	a.nr_seq_pag_tributo
from	pls_movimento_contabil	a,
	pls_ppsc_movimento_item	b
where	a.nr_seq_ppsc_mov_item	= b.nr_sequencia
and	ie_conta_glosa	= 'M'

union all

select	a.ie_status,
	a.nr_seq_conta_proc,
	a.nr_seq_conta_mat,
	b.cd_conta_cred_reversao cd_conta_cred,
	b.cd_conta_deb_reversao cd_conta_deb,
	b.cd_classif_cred_reversao cd_classif_cred,
	b.cd_classif_deb_reversao cd_classif_deb,
	b.nr_seq_regra_cont_reversao nr_seq_esquema,
	a.nr_sequencia,
	a.nr_seq_item_mensalidade,
	'Reversão' ds_conta_glosa,
	a.nr_seq_conta_copartic,
	a.nr_seq_conta_pos_estab,
	a.nr_seq_atualizacao,
	a.nr_seq_ppsc_movimento,
	a.nr_seq_ppsc_mov_item,
	a.nr_seq_fatura_proc,
	a.nr_seq_fatura_mat,
	a.nr_seq_evento_movimento,
	a.nr_seq_pag_tributo
from	pls_movimento_contabil	a,
	pls_ppsc_movimento_item	b
where	a.nr_seq_ppsc_mov_item	= b.nr_sequencia
and	ie_conta_glosa	= 'R';
