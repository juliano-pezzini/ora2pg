-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_valores_lote_camara ( nr_seq_lote_p bigint, ie_tipo_valor_p text) RETURNS bigint AS $body$
DECLARE


/* TIPO DE VALOR
TP - TOTAL A PAGAR
TR - TOTAL A RECEBER
S - SALDO
*/
vl_retorno_w		double precision;
vl_saldo_pagar_w	double precision;
vl_saldo_receber_w	double precision;


BEGIN

if (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '') then
	select	coalesce(sum(a.vl_baixado),0)
	into STRICT	vl_saldo_pagar_w
	from	pls_titulo_lote_camara a
	where	a.nr_seq_lote_camara	= nr_seq_lote_p
	and	(a.nr_titulo_pagar IS NOT NULL AND a.nr_titulo_pagar::text <> '');

	if (vl_saldo_pagar_w = 0) then
		select	coalesce(sum(b.vl_saldo_titulo),0)
		into STRICT	vl_saldo_pagar_w
		from	titulo_pagar b,
			pls_titulo_lote_camara a
		where	a.nr_titulo_pagar	= b.nr_titulo
		and	a.nr_seq_lote_camara	= nr_seq_lote_p;
	end if;

	select	coalesce(sum(a.vl_baixado),0)
	into STRICT	vl_saldo_receber_w
	from	pls_titulo_lote_camara a
	where	a.nr_seq_lote_camara	= nr_seq_lote_p
	and	(a.nr_titulo_receber IS NOT NULL AND a.nr_titulo_receber::text <> '');

	if (vl_saldo_receber_w = 0) then
		select	coalesce(sum(b.vl_saldo_titulo),0)
		into STRICT	vl_saldo_receber_w
		from	titulo_receber b,
			pls_titulo_lote_camara a
		where	a.nr_titulo_receber	= b.nr_titulo
		and	a.nr_seq_lote_camara	= nr_seq_lote_p;
	end if;

	if (ie_tipo_valor_p = 'TP') then
		vl_retorno_w	:= vl_saldo_pagar_w;
	elsif (ie_tipo_valor_p = 'TR') then
		vl_retorno_w	:= vl_saldo_receber_w;
	elsif (ie_tipo_valor_p = 'S') then
		vl_retorno_w	:= vl_saldo_receber_w - vl_saldo_pagar_w;
	end if;
end if;

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_valores_lote_camara ( nr_seq_lote_p bigint, ie_tipo_valor_p text) FROM PUBLIC;
