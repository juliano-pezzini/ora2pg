-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_se_obter_carencia_cumprida ( nr_seq_segurado_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);
dt_validade_carencia_w	timestamp;

C01 CURSOR FOR
	SELECT (coalesce(a.dt_inicio_vigencia,c.dt_inclusao_operadora) + a.qt_dias) dt_validade
	from	pls_carencia		a,
		pls_tipo_carencia	b,
		pls_segurado		c
	where	a.nr_seq_tipo_carencia	= b.nr_sequencia
	and	c.nr_sequencia		= a.nr_seq_segurado
	and	c.nr_sequencia		= nr_seq_segurado_p
	and	b.ie_cpt        = 'N'
	and	a.ie_origem_carencia_benef	= 'P'
	and	pls_consistir_sexo_carencia(nr_seq_segurado_p,b.nr_sequencia) = 'S'
	
union all

	SELECT (coalesce(a.dt_inicio_vigencia,c.dt_inclusao_operadora) + a.qt_dias) dt_validade
	from	pls_carencia		a,
		pls_tipo_carencia	b,
		pls_segurado		c,
		pls_contrato		d
	where	a.nr_seq_tipo_carencia	= b.nr_sequencia
	and	a.nr_seq_contrato	= d.nr_sequencia
	and	c.nr_seq_contrato	= d.nr_sequencia
	and	c.nr_sequencia		= nr_seq_segurado_p
	and	b.ie_cpt        = 'N'
	and	a.ie_origem_carencia_benef	= 'P'
	and	pls_consistir_sexo_carencia(nr_seq_segurado_p,b.nr_sequencia) = 'S'
	and	not exists (	select	1
				from	pls_carencia		a,
					pls_tipo_carencia	b,
					pls_segurado		c
				where	a.nr_seq_tipo_carencia	= b.nr_sequencia
				and	c.nr_sequencia		= a.nr_seq_segurado
				and	c.nr_sequencia		= nr_seq_segurado_p
				and	b.ie_cpt        = 'N'
				and	a.ie_origem_carencia_benef	= 'P'
				and	pls_consistir_sexo_carencia(nr_seq_segurado_p,b.nr_sequencia) = 'S')
	
union all

	select (coalesce(a.dt_inicio_vigencia,c.dt_inclusao_operadora) + a.qt_dias) dt_validade
	from	pls_carencia		a,
		pls_tipo_carencia	b,
		pls_segurado		c,
		pls_plano		d
	where	a.nr_seq_tipo_carencia	= b.nr_sequencia
	and	a.nr_seq_plano		= d.nr_sequencia
	and	c.nr_seq_plano		= d.nr_sequencia
	and	c.nr_sequencia		= nr_seq_segurado_p
	and	b.ie_cpt        	= 'N'
	and	a.ie_origem_carencia_benef	= 'P'
	and	pls_consistir_sexo_carencia(nr_seq_segurado_p,b.nr_sequencia) = 'S'
	and	not exists (	select	1
				from	pls_carencia		a,
					pls_tipo_carencia	b,
					pls_segurado		c
				where	a.nr_seq_tipo_carencia	= b.nr_sequencia
				and	c.nr_sequencia		= a.nr_seq_segurado
				and	c.nr_sequencia		= nr_seq_segurado_p
				and	b.ie_cpt        = 'N'
				and	a.ie_origem_carencia_benef	= 'P'
				and	pls_consistir_sexo_carencia(nr_seq_segurado_p,b.nr_sequencia) = 'S')
	and	not exists (	select	1
				from	pls_carencia		a,
					pls_tipo_carencia	b,
					pls_segurado		c,
					pls_contrato		d
				where	a.nr_seq_tipo_carencia	= b.nr_sequencia
				and	a.nr_seq_contrato	= d.nr_sequencia
				and	c.nr_seq_contrato	= d.nr_sequencia
				and	c.nr_sequencia		= nr_seq_segurado_p
				and	b.ie_cpt        = 'N'
				and	a.ie_origem_carencia_benef	= 'P'
				and	pls_consistir_sexo_carencia(nr_seq_segurado_p,b.nr_sequencia) = 'S');


BEGIN

open C01;
loop
fetch C01 into
	dt_validade_carencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	if (dt_validade_carencia_w	> clock_timestamp()) then
		ds_retorno_w	:= 'CARÊNCIA PADRÃO';
		goto final;
	end if;

	end;
end loop;
close C01;

ds_retorno_w	:= 'CARÊNCIA CUMPRIDA';

<<final>>
ds_retorno_w	:= ds_retorno_w;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_se_obter_carencia_cumprida ( nr_seq_segurado_p bigint) FROM PUBLIC;
