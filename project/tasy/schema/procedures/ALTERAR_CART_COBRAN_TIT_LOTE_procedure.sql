-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_cart_cobran_tit_lote ( nr_seq_carteira_cobr_p bigint, nr_titulo_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_registro_w		bigint := 0;
cd_banco_w		integer;
cd_estabelecimento_w	bigint;


BEGIN
if (nr_seq_carteira_cobr_p IS NOT NULL AND nr_seq_carteira_cobr_p::text <> '') and (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') then

	select	max(y.cd_banco),
		max(y.cd_estabelecimento)
	into STRICT	cd_banco_w,
		cd_estabelecimento_w
	from	titulo_receber		x,
		banco_estabelecimento	y
	where	x.nr_seq_conta_banco	= y.nr_sequencia
	and	x.nr_titulo		= nr_titulo_p;

	select	count(*)
	into STRICT	qt_registro_w
	from    banco_carteira	a
	where   a.ie_situacao 		= 'A'
	and     a.cd_banco 		= cd_banco_w
	and	a.nr_sequencia		= nr_seq_carteira_cobr_p
	and	((a.cd_estabelecimento	= cd_estabelecimento_w) or (coalesce(a.cd_estabelecimento::text, '') = ''));

	if (qt_registro_w > 0) then
		update	titulo_receber
		set	nr_seq_carteira_cobr	= nr_seq_carteira_cobr_p
		where	nr_titulo		= nr_titulo_p;

	commit;

	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_cart_cobran_tit_lote ( nr_seq_carteira_cobr_p bigint, nr_titulo_p bigint, nm_usuario_p text) FROM PUBLIC;
