-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_resumo_ressarcimento_v (nr_seq_processo, nr_seq_conta, ie_status_conta, ds_status_conta, ie_instancia_conta, ds_instancia_conta, ie_status_pagamento, ds_status_pagamento, vl_deferido, vl_pendente, vl_ressarcir, vl_conta, dt_processo, ie_tipo_defesa, ds_tipo_defesa, vl_pago, dt_conta, cd_abi) AS select	a.nr_sequencia nr_seq_processo,
	b.nr_sequencia nr_seq_conta,
	b.ie_status_conta,
	substr(obter_valor_dominio(2527,b.ie_status_conta),1,255) ds_status_conta,
	b.ie_instancia_conta,
	substr(obter_valor_dominio(2528,b.ie_instancia_conta),1,255) ds_instancia_conta,
	b.ie_status_pagamento,
	substr(obter_valor_dominio(2526,b.ie_status_pagamento),1,255) ds_status_pagamento,
	coalesce(b.vl_deferido,0) vl_deferido,
	coalesce(b.vl_pendente,0) vl_pendente,
	coalesce(b.vl_ressarcir,0) vl_ressarcir,
	coalesce(pls_conta_processo_obter_valor(b.nr_sequencia),0) vl_conta,
	a.dt_processo,
	d.ie_tipo_defesa,
	substr(obter_valor_dominio(2531,d.ie_tipo_defesa),1,255) ds_tipo_defesa,
	0 vl_pago,
	b.dt_competencia dt_conta,
	a.cd_abi
FROM	pls_processo a,
	pls_processo_conta b,
	pls_impugnacao c,
	pls_impugnacao_defesa d
where	a.nr_sequencia	= b.nr_seq_processo
and	b.nr_sequencia	= c.nr_seq_conta
and	c.nr_sequencia	= d.nr_seq_impugnacao

union all

select	a.nr_sequencia nr_seq_processo,
	b.nr_sequencia nr_seq_conta,
	b.ie_status_conta,
	substr(obter_valor_dominio(2527,b.ie_status_conta),1,255) ds_status_conta,
	b.ie_instancia_conta,
	substr(obter_valor_dominio(2528,b.ie_instancia_conta),1,255) ds_instancia_conta,
	b.ie_status_pagamento,
	substr(obter_valor_dominio(2526,b.ie_status_pagamento),1,255) ds_status_pagamento,
	coalesce(b.vl_deferido,0) vl_deferido,
	coalesce(b.vl_pendente,0) vl_pendente,
	coalesce(b.vl_ressarcir,0) vl_ressarcir,
	coalesce(pls_conta_processo_obter_valor(b.nr_sequencia),0) vl_conta,
	a.dt_processo,
	d.ie_tipo_defesa,
	substr(obter_valor_dominio(2531,d.ie_tipo_defesa),1,255) ds_tipo_defesa,
	0 vl_pago,
	b.dt_competencia dt_conta,
	a.cd_abi
from	pls_processo a,
	pls_processo_conta b,
	pls_formulario c,
	pls_formulario_defesa d
where	a.nr_sequencia	= b.nr_seq_processo
and	b.nr_sequencia	= c.nr_seq_conta
and	c.nr_sequencia	= d.nr_seq_formulario;

