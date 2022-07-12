-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW ptu_resp_contagem_benef_v40_v (ie_tipo_registro, cd_transacao, nr_sequencia, ie_tipo_cliente, cd_unimed_destino, cd_unimed_requisitante, nr_seq_execucao, ie_status_retorno, qt_ben_pf_co_loc, qt_ben_pf_pp_loc, qt_ben_pf_rec_co, qt_ben_pf_rec_pp, qt_ben_pf_rep_co, qt_ben_pf_rep_pp, qt_ben_pj_co_loc, qt_ben_pj_pp_loc, qt_ben_pj_rec_co, qt_ben_pj_rec_pp, qt_ben_pj_rep_co, qt_ben_pj_rep_pp, ds_fim) AS select	1				ie_tipo_registro,
	00431 				cd_transacao,
	nr_sequencia     		nr_sequencia,
	CASE WHEN ie_tipo_cliente='U' THEN 'UNIMED' WHEN ie_tipo_cliente='P' THEN 'PORTAL' WHEN ie_tipo_cliente='R' THEN 'PRESTADOR' END  ie_tipo_cliente,
	cd_unimed_destino		cd_unimed_destino,
	cd_unimed_requisitante		cd_unimed_requisitante,
	nr_seq_contagem_benef		nr_seq_execucao,
	ie_status_retorno		ie_status_retorno,
	qt_ben_pf_co_loc		qt_ben_pf_co_loc,
	qt_ben_pf_pp_loc		qt_ben_pf_pp_loc,
	qt_ben_pf_rec_co		qt_ben_pf_rec_co,
	qt_ben_pf_rec_pp		qt_ben_pf_rec_pp,
	qt_ben_pf_rep_co		qt_ben_pf_rep_co,
	qt_ben_pf_rep_pp		qt_ben_pf_rep_pp,
	qt_ben_pj_co_loc		qt_ben_pj_co_loc,
	qt_ben_pj_pp_loc		qt_ben_pj_pp_loc,
	qt_ben_pj_rec_co		qt_ben_pj_rec_co,
	qt_ben_pj_rec_pp		qt_ben_pj_rec_pp,
	qt_ben_pj_rep_co		qt_ben_pj_rep_co,
	qt_ben_pj_rep_pp		qt_ben_pj_rep_pp,
	''				ds_fim
FROM	ptu_resp_contagem_benef

union

select	2				ie_tipo_registro,
	null 				cd_transacao,
	nr_sequencia     		nr_sequencia,
	null 				ie_tipo_cliente,
	null				cd_unimed_destino,
	null				cd_unimed_requisitante,
	nr_seq_contagem_benef		nr_seq_execucao,
	null				ie_status_retorno,
	null				qt_ben_pf_co_loc,
	null				qt_ben_pf_pp_loc,
	null				qt_ben_pf_rec_co,
	null				qt_ben_pf_rec_pp,
	null				qt_ben_pf_rep_co,
	null				qt_ben_pf_rep_pp,
	null				qt_ben_pj_co_loc,
	null				qt_ben_pj_pp_loc,
	null				qt_ben_pj_rec_co,
	null				qt_ben_pj_rec_pp,
	null				qt_ben_pj_rep_co,
	null				qt_ben_pj_rep_pp,
	'FIM$'				ds_fim
from	ptu_resp_contagem_benef;

