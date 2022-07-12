-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_retorno ( nr_seq_retorno_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE



/*	VR - Valor Recebido
	VB - Balor Baixa */
vl_recebido_w		double precision;
vl_baixa_w		double precision;


BEGIN

if (nr_seq_retorno_p IS NOT NULL AND nr_seq_retorno_p::text <> '') then
	select	sum(b.vl_pago + b.vl_adicional),
		sum(b.vl_pago + b.vl_glosado)
	into STRICT	vl_recebido_w,
		vl_baixa_w
	from	convenio_retorno a,
		convenio_retorno_item b
	where	a.nr_sequencia 	= b.nr_seq_retorno
	and	a.nr_sequencia	= nr_seq_retorno_p;

	if (ie_opcao_p = 'VR') then
		return vl_recebido_w;
	elsif (ie_opcao_p = 'VB') then
		return vl_baixa_w;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_retorno ( nr_seq_retorno_p bigint, ie_opcao_p text) FROM PUBLIC;
