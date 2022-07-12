-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW titulo_convenio_v (nr_titulo, dt_emissao, dt_vencimento, dt_liquidacao, dt_pagamento_previsto, vl_titulo, vl_saldo_titulo, vl_saldo_juros, vl_saldo_multa, cd_convenio, nr_seq_protocolo, nr_protocolo, ie_tipo_protocolo, dt_envio, nm_usuario_envio, ds_arquivo_envio, ds_tipo_protocolo, ds_convenio, ds_conta_emissao) AS select	b.nr_titulo,
	b.dt_emissao,
	b.dt_vencimento,
	b.dt_liquidacao,
	b.dt_pagamento_previsto,
	b.vl_titulo,
	b.vl_saldo_titulo,
	b.vl_saldo_juros,
	b.vl_saldo_multa,
	a.cd_convenio,
	a.nr_seq_protocolo,
	a.nr_protocolo,
	a.ie_tipo_protocolo,
	a.dt_envio,
	a.nm_usuario_envio,
	a.ds_arquivo_envio,
	obter_valor_dominio(73, a.ie_tipo_protocolo) ds_tipo_protocolo,
	c.ds_convenio,
	d.ds_conta ds_conta_emissao
FROM convenio c, protocolo_convenio a, titulo_receber b
LEFT OUTER JOIN banco_estabelecimento_v d ON (b.nr_seq_conta_banco = d.nr_sequencia)
WHERE b.nr_seq_protocolo = a.nr_seq_protocolo and a.cd_convenio = c.cd_convenio;

