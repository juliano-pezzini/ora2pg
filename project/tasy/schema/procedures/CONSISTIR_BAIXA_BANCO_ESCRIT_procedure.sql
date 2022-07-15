-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_baixa_banco_escrit (nr_seq_banco_escrit_p bigint, ie_acao_p text, nm_usuario_p text) AS $body$
DECLARE


nr_titulo_w	bigint;
cont_w		bigint;

/*
ie_acao_p
	'I' - Inclusão de baixa
	'E' - Estorno de baixa
*/
BEGIN

if (ie_acao_p = 'I') then
	select	max(nr_titulo)
	into STRICT	nr_titulo_w
	from (
		SELECT	a.nr_titulo,
			sum(a.vl_baixa) vl_baixa
		from	titulo_pagar_baixa a
		where	a.nr_seq_escrit	= nr_seq_banco_escrit_p
		group by	a.nr_titulo
		) alias3
	where	vl_baixa	> 0;

	if (nr_titulo_w IS NOT NULL AND nr_titulo_w::text <> '') then
		/* Não foi possível fazer a baixa deste pagamento escritural!
		O título nr_titulo_w já foi baixado por este pagamento escritural. */
		CALL wheb_mensagem_pck.exibir_mensagem_abort(215128,'NR_TITULO_W=' || nr_titulo_w);
	end if;
elsif (ie_acao_p = 'E') then

	select	max(nr_titulo)
	into STRICT	nr_titulo_w
	from (
		SELECT	max(nr_titulo) nr_titulo
		from	titulo_pagar_baixa
		where	nr_seq_escrit	= nr_seq_banco_escrit_p
		having	sum(vl_baixa)	= 0
		) alias4;
	if (nr_titulo_w IS NOT NULL AND nr_titulo_w::text <> '') then
		/* Não foi possível estornar a baixa deste pagamento escritural!
		O título nr_titulo_w já foi estornado por este pagamento escritural ou ainda não foi baixado. */
		CALL wheb_mensagem_pck.exibir_mensagem_abort(215129,'NR_TITULO_W=' || nr_titulo_w);
	end if;

	select	count(*)
	into STRICT	cont_w
	from	titulo_pagar_baixa
	where	nr_seq_escrit	= nr_seq_banco_escrit_p;
	if (cont_w = 0) then
		/* Não foi possível estornar a baixa deste pagamento escritural!
		O título nr_titulo_w já foi estornado por este pagamento escritural ou ainda não foi baixado. */
		CALL wheb_mensagem_pck.exibir_mensagem_abort(215130,'NR_TITULO_W=' || nr_titulo_w);
	end if;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_baixa_banco_escrit (nr_seq_banco_escrit_p bigint, ie_acao_p text, nm_usuario_p text) FROM PUBLIC;

