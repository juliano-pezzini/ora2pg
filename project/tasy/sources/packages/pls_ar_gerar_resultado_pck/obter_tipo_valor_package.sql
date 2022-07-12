-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_ar_gerar_resultado_pck.obter_tipo_valor ( ie_tipo_protocolo_p pls_protocolo_conta.ie_tipo_protocolo%type, ie_tipo_segurado_p pls_segurado.ie_tipo_segurado%type, ie_tipo_contrato_p text) RETURNS varchar AS $body$
DECLARE

	
ds_retorno_w		pls_ar_regra_valor.ie_tipo_valor%type	:= 'C';

C01 CURSOR FOR
	SELECT	ie_tipo_valor
	from	pls_ar_regra_valor
	where	cd_estabelecimento = cd_estabelecimento_p
	and	ie_conta_medica = 'S'
	and	((ie_tipo_contrato = ie_tipo_contrato_p) or (ie_tipo_contrato = 'A'))
	and	((ie_tipo_segurado = ie_tipo_segurado_p) or (coalesce(ie_tipo_segurado::text, '') = ''))
	and	((ie_tipo_protocolo = ie_tipo_protocolo_p) or (coalesce(ie_tipo_protocolo::text, '') = ''))
	order by
		coalesce(ie_tipo_segurado, ' '),
		coalesce(ie_tipo_protocolo, ' '),
		coalesce(ie_tipo_contrato, 'A');

BEGIN

for r_c01_w in c01 loop
	begin
	ds_retorno_w	:= r_c01_w.ie_tipo_valor;
	end;
end loop;

return ds_retorno_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_ar_gerar_resultado_pck.obter_tipo_valor ( ie_tipo_protocolo_p pls_protocolo_conta.ie_tipo_protocolo%type, ie_tipo_segurado_p pls_segurado.ie_tipo_segurado%type, ie_tipo_contrato_p text) FROM PUBLIC;