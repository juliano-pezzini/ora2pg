-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW ptu_complemento_prestador_40_v (tp_registro, ie_ordem, ie_ordem_2, nr_sequencia, cd_tipo_registro, cd_unimed_des, cd_unimed_ori, dt_geracao, nr_versao_trans, cd_rede, nm_comercial_prod, ie_reg_plano_ans, nr_reg_plano_ans, ie_classif_plano, ie_situacao_ans, ie_seg_produto, qt_tot_r452, nr_seq_movimento) AS select	1				tp_registro,
	1				ie_ordem,
	1				ie_ordem_2,
	1				nr_sequencia,
	'451'				cd_tipo_registro,
	a.cd_unimed_destino		cd_unimed_des,
	a.cd_unimed_origem		cd_unimed_ori,
	a.dt_geracao			dt_geracao,
	02				nr_versao_trans,
	null				cd_rede,
	null				nm_comercial_prod,
	null				ie_reg_plano_ans,
	null				nr_reg_plano_ans,
	(null)::numeric 			ie_classif_plano,
	(null)::numeric 			ie_situacao_ans,
	null				ie_seg_produto,
	null				qt_tot_r452,
	a.nr_sequencia			nr_seq_movimento
FROM	ptu_movimento_prestador	a

union all

select	2								tp_registro,
	2								ie_ordem,
	3								ie_ordem_2,
	2								nr_sequencia,
	'452'								cd_tipo_registro,
	null								cd_unimed_des,
	null								cd_unimed_ori,
	null								dt_geracao,
	null								nr_versao_trans,
	rpad(d.cd_rede,4,' ')						cd_rede,
	rpad(elimina_acentuacao(pls_obter_dados_produto(e.nr_seq_plano,'NF')),40, ' ')	nm_comercial_prod,
	CASE WHEN substr(pls_obter_dados_produto(e.nr_seq_plano,'SCPA'),1,1) IS NULL THEN '1'  ELSE '2' END  ie_reg_plano_ans,
	rpad(coalesce(substr(elimina_acentuacao(pls_obter_dados_produto(e.nr_seq_plano,'PA')),1,20),' '),20,' ')	nr_reg_plano_ans,
	(coalesce(CASE WHEN substr(pls_obter_dados_produto(e.nr_seq_plano,'IC'),1,1)='I' THEN 1 WHEN substr(pls_obter_dados_produto(e.nr_seq_plano,'IC'),1,1)='CE' THEN 2 WHEN substr(pls_obter_dados_produto(e.nr_seq_plano,'IC'),1,1)='CA' THEN null  ELSE null END ,'0'))::numeric  ie_classif_plano,
	(coalesce(CASE WHEN substr(pls_obter_dados_produto(e.nr_seq_plano,'IS'),1,1)='A' THEN 1 WHEN substr(pls_obter_dados_produto(e.nr_seq_plano,'IS'),1,1)='S' THEN 2 WHEN substr(pls_obter_dados_produto(e.nr_seq_plano,'IS'),1,1)='C' THEN 3 WHEN substr(pls_obter_dados_produto(e.nr_seq_plano,'IS'),1,1)='I' THEN 2 END ,'0'))::numeric  ie_situacao_ans,
	lpad('0',2,'0')							ie_seg_produto,
	null								qt_tot_r452,
	a.nr_sequencia							nr_seq_movimento
from	ptu_rede_ref_produto	e,
	ptu_rede_referenciada	d,
	ptu_prestador_rede_ref	c,
	ptu_prestador		b,
	ptu_movimento_prestador	a
where	a.nr_sequencia		= b.nr_seq_movimento
and	c.nr_seq_prestador	= b.nr_sequencia
and	d.cd_rede		= c.cd_rede
and	e.cd_rede		= d.cd_rede
and	not exists (select	1
			from	ptu_movimento_rede_ref	x
			where	x.nr_seq_movimento	= a.nr_sequencia)

union all

select	2								tp_registro,
	2								ie_ordem,
	3								ie_ordem_2,
	2								nr_sequencia,
	'452'								cd_tipo_registro,
	null								cd_unimed_des,
	null								cd_unimed_ori,
	null								dt_geracao,
	null								nr_versao_trans,
	b.cd_rede							cd_rede,
	rpad(elimina_acentuacao(b.nm_com_prod),40,' ')			nm_comercial_prod,
	coalesce(b.ie_reg_plano_ans,' ')					ie_reg_plano_ans,
	rpad(coalesce(b.nr_reg_plano_ans,' '),20,' ')			nr_reg_plano_ans,
	(coalesce(b.ie_classif_plano,'0'))::numeric 				ie_classif_plano,
	(coalesce(b.ie_situacao_ans,'0'))::numeric 				ie_situacao_ans,
	lpad(coalesce(b.ie_seg_produto,'0'),2,'0')				ie_seg_produto,
	null								qt_tot_r452,
	a.nr_sequencia							nr_seq_movimento
from	ptu_movimento_rede_ref	b,
	ptu_movimento_prestador	a
where	b.nr_seq_movimento	= a.nr_sequencia

union all

select	7								tp_registro,
	99999999							ie_ordem,
	7								ie_ordem_2,
	999999								nr_sequencia,
	'459'								cd_tipo_registro,
	null								cd_unimed_des,
	null								cd_unimed_ori,
	null								dt_geracao,
	null								nr_versao_trans,
	null								cd_rede,
	null								nm_comercial_prod,
	null								ie_reg_plano_ans,
	null								nr_reg_plano_ans,
	(null)::numeric 							ie_classif_plano,
	(null)::numeric 							ie_situacao_ans,
	null								ie_seg_produto,
	substr(obter_qt_registro_ptu_a400(nr_sequencia,'452'),1,7)	qt_tot_r452,
	a.nr_sequencia							nr_seq_movimento
from	ptu_movimento_prestador	a;

