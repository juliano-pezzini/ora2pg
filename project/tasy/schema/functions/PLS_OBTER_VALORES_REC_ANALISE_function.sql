-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_valores_rec_analise ( nr_seq_analise_p pls_analise_conta.nr_sequencia%type, ie_tipo_valor_p text) RETURNS PLS_REC_GLOSA_CONTA.VL_TOTAL_RECURSADO%TYPE AS $body$
DECLARE


/*
ie_tipo_valor_p
VA - Valor acatado
VR - Valor recursado
*/
vl_retorno_w	pls_rec_glosa_conta.vl_total_recursado%type;
vl_recursado_w	pls_rec_glosa_conta.vl_total_recursado%type;
vl_acatado_w	pls_rec_glosa_conta.vl_total_acatado%type;


BEGIN

select	sum(vl_total_recursado),
	sum(vl_total_acatado)
into STRICT	vl_recursado_w,
	vl_acatado_w
from	pls_rec_glosa_conta
where	nr_seq_analise = nr_seq_analise_p;

if (ie_tipo_valor_p = 'VA') then
	vl_retorno_w := vl_acatado_w;
elsif (ie_tipo_valor_p = 'VR') then
	vl_retorno_w := vl_recursado_w;
end if;

return vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_valores_rec_analise ( nr_seq_analise_p pls_analise_conta.nr_sequencia%type, ie_tipo_valor_p text) FROM PUBLIC;

