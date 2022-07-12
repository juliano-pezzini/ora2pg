-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_valores_pendentes (nr_seq_pagador_p pls_mensalidade.nr_sequencia%type, ie_liq_perda_p text, ie_tipo_valor_p text) RETURNS bigint AS $body$
DECLARE


vl_retorno_w	double precision	:= 0;

C01 CURSOR FOR
	SELECT	distinct a.nr_titulo, a.vl_saldo_titulo,
         	'A' ie_classif,
			0 vl_baixa_inad
	FROM titulo_receber a, pls_mensalidade b
LEFT OUTER JOIN pls_notificacao_item c ON (b.nr_sequencia = c.nr_seq_mensalidade)
LEFT OUTER JOIN pls_notificacao_pagador d ON (c.nr_seq_notific_pagador = d.nr_sequencia)
WHERE a.nr_seq_mensalidade	= b.nr_sequencia   and b.nr_seq_pagador    	= nr_seq_pagador_p and trunc(dt_pagamento_previsto,'dd')   <= trunc(clock_timestamp(),'dd') and (a.ie_situacao = '1' or (a.ie_situacao = '6'  and ie_liq_perda_p = 'S'))
	
union all

	SELECT	distinct a.nr_titulo, a.vl_saldo_titulo,
			'P' ie_classif,
			0 vl_baixa_inad
	FROM titulo_receber a, pls_mensalidade b
LEFT OUTER JOIN pls_notificacao_item c ON (b.nr_sequencia = c.nr_seq_mensalidade)
LEFT OUTER JOIN pls_notificacao_pagador d ON (c.nr_seq_notific_pagador = d.nr_sequencia)
WHERE a.nr_seq_mensalidade	= b.nr_sequencia   and b.nr_seq_pagador     	= nr_seq_pagador_p and trunc(dt_pagamento_previsto,'dd')   > trunc(clock_timestamp(),'dd') and (a.ie_situacao = '1' or (a.ie_situacao = '6'  and ie_liq_perda_p = 'S'))
	 
union all

	select	distinct a.nr_titulo, a.vl_saldo_titulo,
			'BI' ie_classif,
			obter_valor_baixa_inad_tit(a.nr_titulo) vl_baixa_inad
	FROM titulo_receber a, pls_mensalidade b
LEFT OUTER JOIN pls_notificacao_item c ON (b.nr_sequencia = c.nr_seq_mensalidade)
LEFT OUTER JOIN pls_notificacao_pagador d ON (c.nr_seq_notific_pagador = d.nr_sequencia)
WHERE a.nr_seq_mensalidade	= b.nr_sequencia   and b.nr_seq_pagador     	= nr_seq_pagador_p and a.ie_situacao = '2' and a.ie_liq_inadimplencia	= 'S' and coalesce(a.ie_negociado,'N')	= 'N';

BEGIN

for r_c01_w in C01() loop
	begin
	if (ie_tipo_valor_p = 'A') and (r_c01_w.ie_classif = 'A') then
		vl_retorno_w	:= vl_retorno_w + r_c01_w.vl_saldo_titulo;
	elsif (ie_tipo_valor_p = 'P') and (r_c01_w.ie_classif = 'P') then
		vl_retorno_w	:= vl_retorno_w + r_c01_w.vl_saldo_titulo;
	elsif (ie_tipo_valor_p = 'I') and (r_c01_w.ie_classif = 'BI') then
		vl_retorno_w	:= vl_retorno_w + r_c01_w.VL_BAIXA_INAD;
	end if;
	end;
end loop;

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_valores_pendentes (nr_seq_pagador_p pls_mensalidade.nr_sequencia%type, ie_liq_perda_p text, ie_tipo_valor_p text) FROM PUBLIC;
