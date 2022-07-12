-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_novo_pagto_escrit ( ie_remessa_retorno_p text, nr_titulo_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


ie_tit_remessa_w	varchar(1);
ds_retorno_w		varchar(1);
qt_tit_remessa_w	bigint;
qt_tit_estorno_w	bigint;
qt_tit_liquidado_w	bigint;


BEGIN

ie_tit_remessa_w	:= obter_valor_param_usuario(857,35,obter_perfil_ativo,nm_usuario_p, cd_estabelecimento_p);

if (coalesce(ie_tit_remessa_w,'N') = 'S') then

		ds_retorno_w	:= 'S';

elsif (coalesce(ie_tit_remessa_w,'N') = 'N') then

	select	count(*)
	into STRICT	qt_tit_remessa_w
	from	titulo_pagar_escrit a,
		banco_escritural b
	where	a.nr_seq_escrit		= b.nr_sequencia
	and	a.nr_titulo		= nr_titulo_p
	and	b.ie_remessa_retorno	= ie_remessa_retorno_p;

	if (coalesce(qt_tit_remessa_w,0) <> 0) then

		ds_retorno_w	:= 'N';

	else

		ds_retorno_w	:= 'S';

	end if;

elsif (coalesce(ie_tit_remessa_w,'N') = 'L') then

	/* Estorno */

	select	count(*)
	into STRICT	qt_tit_estorno_w
	from	erro_escritural c,
		banco a,
		banco_escritural b,
		titulo_pagar_escrit d
	where	coalesce(c.ie_estornar_baixa,'N')	= 'S'
	and	position(c.cd_erro in d.ds_erro)	> 0
	and	a.cd_banco		= c.cd_banco
	and	b.cd_banco		= a.cd_banco
	and	b.ie_remessa_retorno	= 'I'
	and	d.nr_seq_escrit		= b.nr_sequencia
	and	d.nr_titulo		= nr_titulo_p;

	/*Liquidação*/

	select	count(*)
	into STRICT	qt_tit_liquidado_w
	from	erro_escritural c,
		banco a,
		banco_escritural b,
		titulo_pagar_escrit d
	where	c.ie_rejeitado			= 'L'
	and	coalesce(c.ie_estornar_baixa,'N')	= 'N'
	and	position(c.cd_erro in d.ds_erro)	> 0
	and	a.cd_banco			= c.cd_banco
	and	b.cd_banco			= a.cd_banco
	and	b.ie_remessa_retorno		= 'I'
	and	d.nr_seq_escrit			= b.nr_sequencia
	and	d.nr_titulo			= nr_titulo_p;

	if (coalesce(qt_tit_liquidado_w,0) <= coalesce(qt_tit_estorno_w,0)) then

		ds_retorno_w	:= 'S';

	else

		ds_retorno_w	:= 'N';
	end if;

elsif (coalesce(ie_tit_remessa_w,'N') = 'R') then

	select	count(*)
	into STRICT	qt_tit_liquidado_w
	from	erro_escritural c,
			banco a,
			banco_escritural b,
			titulo_pagar_escrit d
	where	c.ie_rejeitado			= 'R'
	and		coalesce(c.ie_estornar_baixa,'N')	= 'S'
	and		position(c.cd_erro in d.ds_erro)	> 0
	and		a.cd_banco				= c.cd_banco
	and		b.cd_banco				= a.cd_banco
	and		b.ie_remessa_retorno	= 'I'
	and		d.nr_seq_escrit			= b.nr_sequencia
	and		d.nr_titulo				= nr_titulo_p;

	/*Se count retornar mais que 1, significa que existe registro do titulo com Rejeitado, ai conforme parametro 35 como R, deve pertmiri incluir titulos rejeitados em novos lotes. OS 962668*/

	if (coalesce(qt_tit_liquidado_w,0) > 0) then
		ds_retorno_w	:=	'S';
	else
		/*Se não achar em cima no if, precisa verificar aqui em baixo se o titulo está em algum lote de remessa, mesmo sem retorno de rejeicao, pois ai deve permitir, so deve bloquear se foi rejeitado*/

		select 	count(*)
		into STRICT	qt_tit_liquidado_w
		from	titulo_pagar_escrit a,
				banco_escritural b
		where	a.nr_seq_escrit		= b.nr_sequencia
		and		a.nr_titulo			= nr_titulo_p;
		/*Se nao tiver em nenhum lote ainda (count = 0) deve permitir. Se ja tiver em um lote nao deve, apenas se for rejeicao, que foi verificado no if acima*/

		if ( coalesce(qt_tit_liquidado_w,0) = 0) then
			ds_retorno_w 	:=	'S';
		else
			ds_retorno_w 	:=	'N';
		end if;
	end if;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_novo_pagto_escrit ( ie_remessa_retorno_p text, nr_titulo_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

