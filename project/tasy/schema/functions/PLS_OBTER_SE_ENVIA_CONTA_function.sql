-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_envia_conta ( dt_conta_p timestamp, dt_prev_envio_p timestamp, nr_seq_congenere_p bigint, nr_seq_segurado_p bigint, nr_seq_conta_p bigint, ie_trucando_p text default 'S') RETURNS varchar AS $body$
DECLARE


ie_pcmso_w			varchar(10);
ie_envia_w			varchar(1)	:= 'S';
ie_consiste_prest_w		varchar(1)	:= 'N';
ie_seguro_obito_w		varchar(1);
nr_seq_grupo_coop_w		bigint;
nr_seq_plano_w			bigint;
qt_atraso_w			double precision;
nr_seq_intercambio_w		bigint;
qt_dias_envio_conta_w		bigint;
qt_dias_envio_w			bigint;
qt_prestador_a400_w		integer;
cd_estabelecimento_w		smallint;
ie_intercambio_w		varchar(1) := 'S';
nr_seq_regra_atend_cart_w	pls_regra_intercambio.nr_seq_regra_atend_cart%type;
ie_atend_pcmso_w		varchar(1) := 'A';
ie_tipo_intercambio_w		pls_regra_intercambio.ie_tipo_intercambio%type;

C01 CURSOR FOR
	SELECT	a.qt_dias_envio_conta,
		a.nr_seq_regra_atend_cart
	from	pls_regra_intercambio a
	where	dt_conta_p between a.dt_inicio_vigencia_ref and a.dt_fim_vigencia_ref
	and	coalesce(a.ie_situacao, 'A') = 'A'
	and	((pls_obter_tipo_intercambio(nr_seq_congenere_p,cd_estabelecimento_w) = coalesce(a.ie_tipo_intercambio,'A')) or (coalesce(a.ie_tipo_intercambio,'A') = 'A'))
	and (a.nr_seq_intercambio = nr_seq_intercambio_w or coalesce(a.nr_seq_intercambio::text, '') = '')
	and	coalesce(ie_cobranca_pagamento,'C') = 'C'
	and	(((a.nr_seq_grupo_congenere IS NOT NULL AND a.nr_seq_grupo_congenere::text <> '') and exists (	SELECT	1
									from	pls_cooperativa_grupo	x
									where	x.nr_seq_grupo = a.nr_seq_grupo_congenere
									and	x.nr_seq_congenere = nr_seq_congenere_p )) or
		coalesce(a.nr_seq_grupo_congenere::text, '') = '')
	and (a.nr_seq_grupo_coop_seg = nr_seq_grupo_coop_w or coalesce(a.nr_seq_grupo_coop_seg::text, '') = '')
	and (a.nr_seq_plano = nr_seq_plano_w or coalesce(a.nr_seq_plano::text, '') = '')
	--and	((ie_seguro_obito_w = 'B' and nvl(a.ie_beneficio_obito,'N') = 'S') or ie_seguro_obito_w = 'N') Campo não esta em tela quando regra de faturamento
	and	((ie_pcmso = ie_pcmso_w) or (ie_pcmso = 'N'))
	and	((coalesce(a.ie_atend_pcmso,'A') = 'A') or (a.ie_atend_pcmso = ie_atend_pcmso_w))
	and	a.ie_tipo_regra != 'CE' -- Não tem campo para informar QT_DIAS_ENVIO_CONTA na tela da OPS - Operadoras Congeneres
	order by a.qt_dias_envio_conta;
	
C02 CURSOR FOR
	SELECT	a.qt_dias_envio_conta,
		a.nr_seq_regra_atend_cart
	from	pls_regra_intercambio	a
	where	dt_conta_p between a.dt_inicio_vigencia_ref and a.dt_fim_vigencia_ref
	and	coalesce(a.ie_situacao, 'A') = 'A'
	and	((a.ie_tipo_intercambio = 'A') or (coalesce(ie_tipo_intercambio_w,a.ie_tipo_intercambio) = a.ie_tipo_intercambio))
	and	((coalesce(nr_seq_congenere_p::text, '') = '') or (coalesce(a.nr_seq_congenere_sup,coalesce(a.nr_seq_congenere,nr_seq_congenere_p)) = nr_seq_congenere_p))
	and	coalesce(a.ie_cobranca_pagamento,'C') = 'C'
	and	(((a.nr_seq_grupo_congenere IS NOT NULL AND a.nr_seq_grupo_congenere::text <> '') and exists (	SELECT	1
									from	pls_cooperativa_grupo	x
									where	x.nr_seq_grupo = a.nr_seq_grupo_congenere
									and	x.nr_seq_congenere = nr_seq_congenere_p )) or
		coalesce(a.nr_seq_grupo_congenere::text, '') = '')	
	and (a.nr_seq_grupo_coop_seg = nr_seq_grupo_coop_w or coalesce(a.nr_seq_grupo_coop_seg::text, '') = '')
	and (a.nr_seq_plano = nr_seq_plano_w or coalesce(a.nr_seq_plano::text, '') = '')
	--and	((ie_seguro_obito_w = 'B' and nvl(a.ie_beneficio_obito,'N') = 'S') or ie_seguro_obito_w = 'N') Campo não esta em tela quando regra de faturamento
	and	((ie_pcmso = ie_pcmso_w) or (ie_pcmso = 'N'))
	and	((coalesce(a.ie_atend_pcmso,'A') = 'A') or (a.ie_atend_pcmso = ie_atend_pcmso_w))
	and	a.ie_tipo_regra != 'CE' -- Não tem campo para informar QT_DIAS_ENVIO_CONTA na tela da OPS - Operadoras Congeneres
	order by a.qt_dias_envio_conta;


BEGIN
begin
	cd_estabelecimento_w := wheb_usuario_pck.get_cd_estabelecimento;
exception
when others then
	cd_estabelecimento_w := null;
end;

/* Quantidade de dias envio*/

begin
	select	b.nr_seq_intercambio,
		coalesce(cd_estabelecimento_w,b.cd_estabelecimento),
		--b.nr_seq_plano,
		pls_obter_produto_benef(b.nr_sequencia, dt_conta_p),
		b.ie_pcmso,
		b.nr_seq_grupo_coop,
		a.ie_seguro_obito
	into STRICT	nr_seq_intercambio_w,
		cd_estabelecimento_w,
		nr_seq_plano_w,
		ie_pcmso_w,
		nr_seq_grupo_coop_w,
		ie_seguro_obito_w
	from	pls_segurado	b,
		pls_plano	a
	where	b.nr_sequencia	= nr_seq_segurado_p
	and	a.nr_sequencia	= b.nr_seq_plano;
exception
when others then
	nr_seq_intercambio_w	:= null;
	ie_seguro_obito_w	:= 'N';
end;

if (coalesce(ie_seguro_obito_w::text, '') = '') then
	ie_seguro_obito_w	:= 'N';
end if;	

begin
	select	coalesce(max(r.ie_pcmso),'N')
	into STRICT	ie_atend_pcmso_w
	from	pls_execucao_requisicao e,
		pls_requisicao r,
		pls_conta c
	where	r.nr_sequencia	= e.nr_seq_requisicao
	and	e.nr_seq_guia	= c.nr_seq_guia
	and	c.nr_sequencia	= nr_seq_conta_p;
exception
when others then
	ie_atend_pcmso_w := 'N';
end;

if (coalesce(ie_pcmso_w::text, '') = '') then
	ie_pcmso_w	:= 'N';
end if;

ie_tipo_intercambio_w	:= pls_obter_tipo_intercambio(nr_seq_congenere_p,cd_estabelecimento_w);

if (nr_seq_intercambio_w IS NOT NULL AND nr_seq_intercambio_w::text <> '') then
	open C01;
	loop
	fetch C01 into	
		qt_dias_envio_w,
		nr_seq_regra_atend_cart_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		ie_intercambio_w	:= 'S';
		if (nr_seq_regra_atend_cart_w IS NOT NULL AND nr_seq_regra_atend_cart_w::text <> '') then
			ie_intercambio_w := coalesce(pls_valida_regra_cart(nr_seq_segurado_p, nr_seq_regra_atend_cart_w), 'S');
		end if;
		
		if (ie_intercambio_w = 'S') then
			qt_dias_envio_conta_w := qt_dias_envio_w;
		end if;
		end;
	end loop;
	close C01;
end if;

if (coalesce(qt_dias_envio_conta_w::text, '') = '') then
	open C02;
	loop
	fetch C02 into	
		qt_dias_envio_w,
		nr_seq_regra_atend_cart_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		ie_intercambio_w := 'S';
		if (nr_seq_regra_atend_cart_w IS NOT NULL AND nr_seq_regra_atend_cart_w::text <> '') then
			ie_intercambio_w := coalesce(pls_valida_regra_cart(nr_seq_segurado_p, nr_seq_regra_atend_cart_w), 'S');			
		end if;
		
		if (ie_intercambio_w = 'S') then
			qt_dias_envio_conta_w := qt_dias_envio_w;
		end if;
		end;
	end loop;
	close C02;
end if;

if (coalesce(ie_trucando_p,'S') = 'S') then
	qt_atraso_w := trunc(dt_prev_envio_p) - trunc(dt_conta_p);
else
	qt_atraso_w := dt_prev_envio_p - dt_conta_p;
end if;

if (qt_dias_envio_conta_w > 0) and (qt_atraso_w > qt_dias_envio_conta_w) then
	ie_envia_w := 'N'; --Motivo: Conta fora do prazo limite
end if;

return ie_envia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_envia_conta ( dt_conta_p timestamp, dt_prev_envio_p timestamp, nr_seq_congenere_p bigint, nr_seq_segurado_p bigint, nr_seq_conta_p bigint, ie_trucando_p text default 'S') FROM PUBLIC;

