-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_conta_item_imp_v (nr_seq_protocolo, nr_seq_conta, nr_seq_item, ie_tipo_item, cd_tipo_tabela, ie_tipo_despesa) AS select	a.nr_sequencia nr_seq_protocolo,
	b.nr_sequencia nr_seq_conta,
	c.nr_sequencia nr_seq_item,
	c.ie_tipo_item,
	c.cd_tipo_tabela,
	c.ie_tipo_despesa
FROM	pls_protocolo_conta_imp a,
	pls_conta_imp b,
	pls_conta_item_imp c
where	b.nr_seq_protocolo = a.nr_sequencia
and	c.nr_seq_conta = b.nr_sequencia;

