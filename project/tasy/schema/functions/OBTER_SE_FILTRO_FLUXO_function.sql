-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_filtro_fluxo ( nr_seq_conta_banco_p bigint, nr_seq_cheque_p bigint, nr_seq_caixa_rec_p bigint, nm_usuario_p text, nr_seq_caixa_p bigint) RETURNS varchar AS $body$
DECLARE


/* ahoffelder - OS 325264 - 13/06/2011 - Alterei para buscar so o banco e/ou caixa que for especificado no filtro */

qt_banco_w		bigint;
qt_caixa_w		bigint;
cd_banco_w		banco_estabelecimento.cd_banco%type;
nr_seq_caixa_w		bigint;
ds_retorno_w		varchar(1);
qt_banco_ok_w		bigint;
qt_caixa_ok_w		bigint;


BEGIN

ds_retorno_w		:= 'S';

select	count(*)
into STRICT	qt_banco_w
from	w_filtro_fluxo a
where	a.nm_usuario		= nm_usuario_p
and	(a.cd_banco IS NOT NULL AND a.cd_banco::text <> '')
and	coalesce(a.nr_seq_proj_rec::text, '') = '';

select	count(*)
into STRICT	qt_caixa_w
from	w_filtro_fluxo a
where	a.nm_usuario		= nm_usuario_p
and	(a.nr_seq_caixa IS NOT NULL AND a.nr_seq_caixa::text <> '')
and	coalesce(a.nr_seq_proj_rec::text, '') = '';

if (qt_banco_w > 0) or (qt_caixa_w > 0) then

	ds_retorno_w	:= 'N';

	if (nr_seq_conta_banco_p IS NOT NULL AND nr_seq_conta_banco_p::text <> '') then
	
		select	max(a.cd_banco)
		into STRICT	cd_banco_w
		from	banco_estabelecimento a
		where	a.nr_sequencia	= nr_seq_conta_banco_p;

	elsif (nr_seq_cheque_p IS NOT NULL AND nr_seq_cheque_p::text <> '') then

		select	max(c.cd_banco)
		into STRICT	cd_banco_w
		from	banco_estabelecimento c,
			deposito b,
			deposito_cheque a
		where	b.nr_conta		= c.nr_sequencia
		and	a.nr_seq_deposito	= b.nr_sequencia
		and	a.nr_seq_cheque		= nr_seq_cheque_p;

	end if;

	if (nr_seq_caixa_rec_p IS NOT NULL AND nr_seq_caixa_rec_p::text <> '') then

		select	max(b.nr_seq_caixa)
		into STRICT	nr_seq_caixa_w
		from	caixa_saldo_diario b,
			caixa_receb a
		where	a.nr_seq_saldo_caixa	= b.nr_sequencia
		and	a.nr_sequencia		= nr_seq_caixa_rec_p;

	end if;

	if (coalesce(nr_seq_caixa_w::text, '') = '') then
		nr_seq_caixa_w	:= nr_seq_caixa_p;
	end if;

	if (qt_banco_w > 0) then

		select	count(*)
		into STRICT	qt_banco_ok_w
		from	w_filtro_fluxo a
		where	a.nm_usuario		= nm_usuario_p
		and	a.cd_banco		= cd_banco_w
		and	coalesce(a.nr_seq_proj_rec::text, '') = '';

	end if;

	if (qt_caixa_w > 0) then

		select	count(*)
		into STRICT	qt_caixa_ok_w
		from	w_filtro_fluxo a
		where	a.nm_usuario		= nm_usuario_p
		and	a.nr_seq_caixa		= nr_seq_caixa_w
		and	coalesce(a.nr_seq_proj_rec::text, '') = '';

	end if;

	if (qt_banco_ok_w > 0) or (qt_caixa_ok_w > 0) then

		ds_retorno_w	:= 'S';

	end if;

end if;

return	ds_retorno_w;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_filtro_fluxo ( nr_seq_conta_banco_p bigint, nr_seq_cheque_p bigint, nr_seq_caixa_rec_p bigint, nm_usuario_p text, nr_seq_caixa_p bigint) FROM PUBLIC;

