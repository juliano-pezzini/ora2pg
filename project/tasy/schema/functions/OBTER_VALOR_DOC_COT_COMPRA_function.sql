-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_doc_cot_compra ( nr_cot_compra_p bigint) RETURNS bigint AS $body$
DECLARE


vl_documento_ref_moeda_w		double precision;


BEGIN

select	coalesce(sum(vl_documento_ref_moeda),0)
into STRICT	vl_documento_ref_moeda_w
from	cot_doc_importacao a,
	cot_tipo_doc_importacao b
where	a.nr_seq_tipo_doc = b.nr_sequencia
and	a.nr_cot_compra = nr_cot_compra_p
and	coalesce(ie_soma_cotacao,'N') = 'S'
and 	obter_dados_tit_pagar(a.nr_titulo_pagar,'S') <> 'C';


return	vl_documento_ref_moeda_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_doc_cot_compra ( nr_cot_compra_p bigint) FROM PUBLIC;
