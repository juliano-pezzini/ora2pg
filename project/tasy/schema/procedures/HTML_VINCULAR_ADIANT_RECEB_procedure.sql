-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE html_vincular_adiant_receb (nr_seq_caixa_rec_p bigint, nr_adiantamento_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_w	bigint;


BEGIN

if (nr_adiantamento_p > 0) then

	select	count(*)
	into STRICT	qt_w
	from    adiantamento a,
		caixa_receb b
	where	a.nr_seq_caixa_rec 	= b.nr_sequencia
	and	a.nr_adiantamento	= nr_adiantamento_p
	and	coalesce(b.dt_cancelamento::text, '') = '';

	if (qt_w > 0) then
		--O adiantamento selecionado já está sendo utilizado em outra movimentação
		CALL wheb_mensagem_pck.exibir_mensagem_abort(124096);
	else
		update	adiantamento
		set	nr_seq_caixa_rec 	= nr_seq_caixa_rec_p,
			nm_usuario		= nm_usuario_p,
			dt_atualizacao		= clock_timestamp()
		where 	nr_adiantamento 	= nr_adiantamento_p;

		commit;

	end if;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE html_vincular_adiant_receb (nr_seq_caixa_rec_p bigint, nr_adiantamento_p bigint, nm_usuario_p text) FROM PUBLIC;
