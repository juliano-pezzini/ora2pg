-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW anexo_processo_gpi_v (ie_origem, ds_origem, nr_documento, ds_titulo, ds_arquivo, dt_registro, nm_usuario, nr_seq_proj_gpi) AS select	1 ie_origem,
	'GPI' ds_origem,
	a.nr_seq_projeto nr_documento,
	a.ds_titulo,
	a.ds_arquivo,
	a.dt_registro dt_registro,
	a.nm_usuario_nrec nm_usuario,
	a.nr_seq_projeto nr_seq_proj_gpi
FROM	gpi_projeto_doc a

union all

select	2 ie_origem,
	'Ordem Serviço' ds_origem,
	b.nr_sequencia,
	null,
	a.ds_arquivo,
	a.dt_atualizacao dt_registro,
	a.nm_usuario_nrec,
	b.nr_seq_proj_gpi
from	man_ordem_serv_arq a,
	man_ordem_servico b
where	a.nr_seq_ordem = b.nr_sequencia

union all

select	3 ie_origem,
	'Solicitação compras' ds_origem,
	a.nr_solic_compra,
	null,
	a.ds_arquivo,
	a.dt_atualizacao dt_registro,
	a.nm_usuario_nrec,
	b.nr_seq_proj_gpi
from	solic_compra_item_anexo a,
	solic_compra b
where	a.nr_solic_compra = b.nr_solic_compra
order by ie_origem,
	dt_registro;

