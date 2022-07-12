-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_reajuste_tabela_v (nr_seq_reajuste_tabela, nr_seq_reajuste, nr_seq_tabela, nr_seq_plano, dt_liberacao, nm_usuario_liberacao, dt_inicio_vigencia, dt_contrato, nr_seq_contrato, ie_origem_tabela, nm_tabela, nm_produto, cd_pf_estipulante, cd_cgc_estipulante, nr_contrato, nr_contrato_tabela, cd_contrato, dt_reajuste_contrato, ie_tipo_operacao, nr_seq_processo, tx_reajuste) AS select	e.nr_sequencia 	nr_seq_reajuste_tabela,
	b.nr_sequencia	nr_seq_reajuste,
	c.nr_sequencia	nr_seq_tabela,
	d.nr_sequencia	nr_seq_plano,
	e.dt_liberacao,
	e.nm_usuario_liberacao,
	e.dt_inicio_vigencia,
	a.dt_contrato,
	e.nr_seq_contrato,
	e.ie_origem_tabela,
	substr(c.nm_tabela,1,255) nm_tabela,
	substr(d.ds_plano,1,255) nm_produto,
	a.cd_pf_estipulante,
	a.cd_cgc_estipulante,
	a.nr_contrato,
	c.nr_contrato nr_contrato_tabela,
	a.nr_contrato cd_contrato,
	a.dt_reajuste dt_reajuste_contrato,
	d.ie_tipo_operacao,
	e.nr_seq_processo,
	e.tx_reajuste
FROM pls_plano d, pls_tabela_preco c, pls_reajuste b, pls_reajuste_tabela e
LEFT OUTER JOIN pls_contrato a ON (e.nr_seq_contrato = a.nr_sequencia)
WHERE e.nr_seq_tabela		= c.nr_sequencia and e.nr_seq_reajuste	= b.nr_sequencia  and e.nr_seq_plano		= d.nr_sequencia;

