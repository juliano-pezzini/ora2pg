-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE desvincular_pessoas_enc_contas (nr_seq_lote_p bigint, nm_usuario_p text) AS $body$
DECLARE



nr_seq_pessoa_w			pessoa_encontro_contas.nr_sequencia%type;
qt_tit_rec_lote_w		bigint;
qt_tit_pag_lote_w		bigint;
vl_saldo_lote_w			double precision;

/*Cursor para buscar as pessoas do lote que so tem titulo a receber ou titulo a pagar*/

C01 CURSOR FOR
	SELECT	a.nr_sequencia
	from	pessoa_encontro_contas a
	where	a.nr_seq_lote	= nr_seq_lote_p
	and	((not exists (SELECT	1
						 from	encontro_contas_item x
						 where	x.nr_seq_pessoa = a.nr_sequencia
						 and	(x.nr_titulo_receber IS NOT NULL AND x.nr_titulo_receber::text <> ''))) or (not exists (select	1
						 from	encontro_contas_item x
						 where	x.nr_seq_pessoa = a.nr_sequencia
						 and	(x.nr_titulo_pagar IS NOT NULL AND x.nr_titulo_pagar::text <> ''))))
	order by a.nr_sequencia;

BEGIN

if (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '') then

	open C01;
	loop
	fetch C01 into
		nr_seq_pessoa_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		/*Confirmar quantidade de titulos a receber no lote para essa pessoa*/

		select	count(a.nr_sequencia)
		into STRICT	qt_tit_rec_lote_w
		from	encontro_contas_item a,
				pessoa_encontro_contas b
		where	a.nr_seq_pessoa		   = b.nr_sequencia
		and		a.nr_seq_pessoa		   = nr_seq_pessoa_w
		and		b.nr_seq_lote		   = nr_seq_lote_p
		and		(a.nr_titulo_receber IS NOT NULL AND a.nr_titulo_receber::text <> '');

		/*Confirmar quantidade de titulos a  pagar no lote para essa pessoa*/

		select	count(a.nr_sequencia)
		into STRICT	qt_tit_pag_lote_w
		from	encontro_contas_item a,
				pessoa_encontro_contas b
		where	a.nr_seq_pessoa		   = b.nr_sequencia
		and		a.nr_seq_pessoa		   = nr_seq_pessoa_w
		and		b.nr_seq_lote		   = nr_seq_lote_p
		and		(a.nr_titulo_pagar IS NOT NULL AND a.nr_titulo_pagar::text <> '');

		/*Se a quantidade de titulos a pagar ou a receebr for 0, nao se pode fazer o encontro dessa pessoa, entao vai excluir.*/

		if (qt_tit_rec_lote_w = 0) or (qt_tit_pag_lote_w = 0) then

				/*Deletar todos os titulos para essa pessoa no lote*/

				delete 	FROM encontro_contas_item
				where	nr_seq_pessoa	= nr_seq_pessoa_w;

				/*delete a pessoa do lote*/

				delete 	FROM pessoa_encontro_contas
				where	nr_sequencia	= nr_seq_pessoa_w
				and		nr_seq_lote		= nr_seq_lote_p;

				select	coalesce(sum(a.vl_saldo_credor),0) - coalesce(sum(a.vl_saldo_devedor),0)
				into STRICT	vl_saldo_lote_w
				from	pessoa_encontro_contas a
				where	a.nr_seq_lote	= nr_seq_lote_p;

				update	lote_encontro_contas
				set		nm_usuario		= nm_usuario_p,
						dt_atualizacao	= clock_timestamp(),
						vl_saldo		= vl_saldo_lote_w
				where	nr_sequencia	= nr_seq_lote_p;

				commit;

		end if;

		end;
	end loop;
	close C01;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE desvincular_pessoas_enc_contas (nr_seq_lote_p bigint, nm_usuario_p text) FROM PUBLIC;
