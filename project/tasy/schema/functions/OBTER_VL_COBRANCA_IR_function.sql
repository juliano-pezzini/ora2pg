-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_vl_cobranca_ir ( nr_seq_segurado_p bigint, dt_referencia_p timestamp) RETURNS bigint AS $body$
DECLARE


vl_cobranca_w		double precision := 0;


BEGIN

select	sum(d.vl_item) vl_item
into STRICT	vl_cobranca_w
FROM pls_segurado j, pls_lote_mens_ir i, pls_mens_pagador_ir h, pls_mens_beneficiario_ir g, titulo_receber c, pls_mensalidade_segurado b, pls_mensalidade a, pls_mensalidade_seg_item d
LEFT OUTER JOIN pls_tipo_lanc_adic e ON (d.nr_seq_tipo_lanc = e.nr_sequencia)
WHERE d.nr_seq_mensalidade_seg	= b.nr_sequencia and b.nr_seq_mensalidade	= a.nr_sequencia and c.nr_seq_mensalidade	= a.nr_sequencia  and b.nr_seq_segurado		= j.nr_sequencia and g.nr_seq_segurado		= j.nr_sequencia and h.nr_sequencia 		= g.nr_seq_pagador_ir and i.nr_sequencia 		= h.nr_seq_lote and i.ds_ano_base  		= to_char(dt_referencia_p, 'YYYY') and ((j.nr_sequencia		= nr_seq_segurado_p) or (j.nr_seq_titular = nr_seq_segurado_p)) and trunc(c.dt_liquidacao,'month')	= trunc(dt_referencia_p, 'month') and d.ie_tipo_item		= '20' and e.ie_operacao_motivo	= 'S' and c.ie_situacao		= '2' and coalesce(a.ie_cancelamento::text, '') = '';

return	vl_cobranca_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_vl_cobranca_ir ( nr_seq_segurado_p bigint, dt_referencia_p timestamp) FROM PUBLIC;
