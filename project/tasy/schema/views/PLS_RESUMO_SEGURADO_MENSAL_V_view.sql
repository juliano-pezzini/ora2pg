-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_resumo_segurado_mensal_v (dt_referencia, ie_preco, ds_preco, ie_tipo_contrato, nr_seq_segurado, nr_protocolo_ans, dt_cancelamento, nr_seq_plano, nm_usuario, ie_regulamentacao) AS select	a.dt_referencia,
	b.ie_preco,
	substr(obter_valor_dominio(1669,b.ie_preco),1,255) ds_preco,
	CASE WHEN d.cd_cgc_estipulante IS NULL THEN 'PF'  ELSE 'PJ' END  ie_tipo_contrato,
	a.nr_seq_segurado,
	b.nr_protocolo_ans,
	c.dt_cancelamento,
	a.nr_seq_plano,
	a.nm_usuario,
	b.ie_regulamentacao
FROM	w_pls_benef_movto_mensal 	a,
	pls_plano 			b,
	pls_segurado 			c,
	pls_contrato 			d
where	a.nr_seq_plano	 		= b.nr_sequencia
and	a.nr_seq_segurado		= c.nr_sequencia
and	c.nr_seq_contrato		= d.nr_sequencia;
