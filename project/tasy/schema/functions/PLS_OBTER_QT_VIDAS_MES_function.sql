-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_qt_vidas_mes ( dt_referencia_p timestamp, ie_opcao_p text, cd_estabelecimento_p bigint) RETURNS bigint AS $body$
DECLARE

qt_retorno_w		bigint;
dt_referencia_w		timestamp;
dt_referencia_inicio_w	timestamp;
dt_referencia_fim_w	timestamp;

BEGIN
dt_referencia_inicio_w	:= trunc(dt_referencia_p,'month');
dt_referencia_fim_w	:= Fim_Mes(dt_referencia_p);
if (ie_opcao_p = 'VIDAS') then
	select	count(*)
	into STRICT	qt_retorno_w
	from	w_pls_benef_movto_mensal a,
		pls_segurado		b,
		pls_contrato		d,
		pls_plano		c
	where	a.nr_seq_segurado	= b.nr_sequencia
	and	b.nr_seq_contrato	= d.nr_sequencia
	and	b.nr_Seq_plano		= c.nr_sequencia
	and	a.dt_referencia		= dt_referencia_inicio_w
	and	b.cd_estabelecimento	= cd_estabelecimento_p;
	/*select	count(*)
	into	qt_retorno_w
	from   	pls_segurado_historico	a,
		pls_segurado		b,
		pls_plano		c,
		pls_contrato		d
	where	b.nr_sequencia		= a.nr_seq_segurado
	and	c.nr_sequencia		= b.nr_seq_plano
	and	d.nr_sequencia		= b.nr_seq_contrato
	and	b.cd_estabelecimento	= cd_estabelecimento_p
	and 	a.ie_tipo_historico in ('2','22')
	and  	a.dt_historico = (	select	max(x.dt_historico)
					from  	pls_segurado_historico	x
					where 	a.nr_seq_segurado = x.nr_seq_segurado
					and	x.dt_historico	<= dt_referencia_fim_w
					and	x.ie_tipo_historico in ('2','22','1','5'));*/
elsif (ie_opcao_p = 'VENDAS') then
	dt_referencia_inicio_w	:= trunc(dt_referencia_p,'month');
	dt_referencia_fim_w	:= add_months(dt_referencia_inicio_w,1);
	dt_referencia_fim_w	:= trunc(dt_referencia_fim_w,'month');
	select	sum(qt)
	into STRICT	qt_retorno_w
	from (	SELECT	count(*) qt
		from   	pls_segurado_historico	a,
			pls_segurado		b,
			pls_plano		c,
			pls_contrato		d
		where	b.nr_sequencia		= a.nr_seq_segurado
		and	c.nr_sequencia		= b.nr_seq_plano
		and	d.nr_sequencia		= b.nr_seq_contrato
		and	b.cd_estabelecimento	= cd_estabelecimento_p
		and 	a.ie_tipo_historico in ('2','22','1','5')
		and	d.dt_contrato		>= dt_referencia_inicio_w
		and	d.dt_contrato		<= dt_referencia_fim_w
		and	coalesce(b.nr_seq_segurado_ant::text, '') = ''
		and  	a.dt_ocorrencia_sib = (	select	max(x.dt_ocorrencia_sib)
						from  	pls_segurado_historico	x
						where 	a.nr_seq_segurado = x.nr_seq_segurado
						and	x.dt_ocorrencia_sib	>= dt_referencia_inicio_w
						and	x.dt_ocorrencia_sib	<= dt_referencia_fim_w
						and	x.ie_tipo_historico in ('2','22','1','5'))
		and	not exists (	select	1
					from	pls_notificacao_pagador	z
					where	z.nr_seq_pagador	= b.nr_seq_pagador)
		
union all

		SELECT	count(*)
		from   	pls_segurado_historico	a,
			pls_segurado		b,
			pls_plano		c,
			pls_sub_estipulante	d
		where	b.nr_sequencia		= a.nr_seq_segurado
		and	c.nr_sequencia		= b.nr_seq_plano
		and	d.nr_sequencia		= b.nr_seq_subestipulante
		and	b.cd_estabelecimento	= cd_estabelecimento_p
		and 	a.ie_tipo_historico in ('2','22','1','5')
		and	d.dt_liberacao		>= dt_referencia_inicio_w
		and	d.dt_liberacao		<= dt_referencia_fim_w
		and	coalesce(b.nr_seq_segurado_ant::text, '') = ''
		and  	a.dt_ocorrencia_sib = (	select	max(x.dt_ocorrencia_sib)
						from  	pls_segurado_historico	x
						where 	a.nr_seq_segurado = x.nr_seq_segurado
						and	x.dt_ocorrencia_sib	>= dt_referencia_inicio_w
						and	x.dt_ocorrencia_sib	<= dt_referencia_fim_w
						and	x.ie_tipo_historico in ('2','22','1','5'))
		and	not exists (	select	1
					from	pls_notificacao_pagador	z
					where	z.nr_seq_pagador	= b.nr_seq_pagador)
		) alias15;
elsif (ie_opcao_p = 'EMPRESAS') then

	select	sum(qt)
	into STRICT	qt_retorno_w
	from (	SELECT	count(*) qt
		from	pls_contrato
		where	(cd_cgc_estipulante IS NOT NULL AND cd_cgc_estipulante::text <> '')
		and	trunc(dt_contrato,'Month')	<= dt_referencia_inicio_w
		and (coalesce(dt_rescisao_contrato::text, '') = '' or ((dt_rescisao_contrato IS NOT NULL AND dt_rescisao_contrato::text <> '') and dt_rescisao_contrato >= dt_referencia_inicio_w))
		
union all

		SELECT	count(*)
		from	pls_sub_estipulante	a
		where	(a.cd_cgc IS NOT NULL AND a.cd_cgc::text <> '')
		and	trunc(a.dt_liberacao,'Month') <= dt_referencia_inicio_w
		and (coalesce(DT_RESCISAO::text, '') = '' or ((DT_RESCISAO IS NOT NULL AND DT_RESCISAO::text <> '') and DT_RESCISAO >= dt_referencia_inicio_w))
		and	not exists (select	1
					from	pls_contrato	x
					where	x.nr_sequencia		= a.nr_seq_contrato
					and	x.cd_cgc_estipulante	= a.cd_cgc)) alias17;
end if;
return	qt_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_qt_vidas_mes ( dt_referencia_p timestamp, ie_opcao_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

