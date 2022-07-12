-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_qtd_vidas_mes ( dt_mes_referencia_p timestamp, ie_tipo_retorno_p text) RETURNS bigint AS $body$
DECLARE


/* ie_tipo_retorno_p
	A - Ativos
	AP - Ativos pré - estabelecido
	ACO - Ativos custo operacional

*/
qt_vidas_w			bigint	:= 0;


BEGIN

if (ie_tipo_retorno_p	= 'A') then
	select	count(1)
	into STRICT	qt_vidas_w
	from	w_pls_benef_movto_mensal
	where	trunc(dt_referencia,'month')	= trunc(dt_mes_referencia_p,'month');
elsif (ie_tipo_retorno_p	= 'AP') then
	select	count(*)
	into STRICT	qt_vidas_w
	from	pls_plano		c,
		pls_segurado		b,
		pls_segurado_historico	a
	where	a.nr_seq_segurado	= b.nr_sequencia
	and	pls_obter_produto_benef(b.nr_sequencia,dt_mes_referencia_p) = c.nr_sequencia
	and	c.ie_preco		= '1'
	and	a.ie_tipo_historico in ('2','22')
	and	a.dt_historico	=	(SELECT	max(x.dt_historico)
					from	pls_segurado_historico	x
					where	trunc(x.dt_historico,'month') <= trunc(dt_mes_referencia_p,'month')
					and	x.ie_tipo_historico in ('2','22','1','5')
					and 	a.nr_seq_segurado = x.nr_seq_segurado);
elsif (ie_tipo_retorno_p	= 'ACO') then
	select	count(*)
	into STRICT	qt_vidas_w
	from	pls_plano		c,
		pls_segurado		b,
		pls_segurado_historico	a
	where	a.nr_seq_segurado	= b.nr_sequencia
	and	pls_obter_produto_benef(b.nr_sequencia,dt_mes_referencia_p) = c.nr_sequencia
	and	c.ie_preco		= '3'
	and	a.ie_tipo_historico in ('2','22')
	and	a.dt_historico	=	(SELECT	max(x.dt_historico)
					from	pls_segurado_historico	x
					where	trunc(x.dt_historico,'month') <= trunc(dt_mes_referencia_p,'month')
					and	x.ie_tipo_historico in ('2','22','1','5')
					and 	a.nr_seq_segurado = x.nr_seq_segurado);
end if;

return	qt_vidas_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_qtd_vidas_mes ( dt_mes_referencia_p timestamp, ie_tipo_retorno_p text) FROM PUBLIC;
