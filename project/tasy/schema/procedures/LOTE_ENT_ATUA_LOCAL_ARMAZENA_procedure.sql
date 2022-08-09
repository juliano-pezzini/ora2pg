-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lote_ent_atua_local_armazena ( nr_seq_lote_p bigint, nr_seq_ficha_p bigint, nr_seq_local_p bigint, nr_seq_local_caixa_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_ficha_w		bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	lote_ent_sec_ficha
	where	nr_seq_lote_sec = nr_seq_lote_p
	order by 	1;


BEGIN

if (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '') then

	if (coalesce(nr_seq_ficha_p,0) > 0) then

		update	lote_ent_sec_ficha
		set		nr_seq_local = nr_seq_local_p,
				nr_seq_local_caixa = nr_seq_local_caixa_p
		where	nr_sequencia = nr_seq_ficha_p
		and		nr_seq_lote_sec = nr_seq_lote_p;

		insert into lote_ent_sec_ficha_hist(
			NR_SEQUENCIA,
			DT_ATUALIZACAO,
			DT_ATUALIZACAO_NREC,
			NM_USUARIO,
			NM_USUARIO_NREC,
			NR_SEQ_FICHA,
			NR_SEQ_LOCAL,
			NR_SEQ_LOCAL_CAIXA,
			NR_SEQ_LOTE_SEC
		) values (
			nextval('lote_ent_sec_ficha_hist_seq'),
			clock_timestamp(),
			clock_timestamp(),
			nm_usuario_p,
			nm_usuario_p,
			nr_seq_ficha_p,
			nr_seq_local_p,
			nr_seq_local_caixa_p,
			nr_seq_lote_p
		);

	end if;

	if (coalesce(nr_seq_ficha_p,0) = 0) then

		open C01;
		loop
		fetch C01 into
			nr_seq_ficha_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin

			update	lote_ent_sec_ficha
			set		nr_seq_local = nr_seq_local_p,
					nr_seq_local_caixa = nr_seq_local_caixa_p
			where	nr_sequencia = nr_seq_ficha_w
			and		nr_seq_lote_sec = nr_seq_lote_p;


			insert into lote_ent_sec_ficha_hist(
				NR_SEQUENCIA,
				DT_ATUALIZACAO,
				DT_ATUALIZACAO_NREC,
				NM_USUARIO,
				NM_USUARIO_NREC,
				NR_SEQ_FICHA,
				NR_SEQ_LOCAL,
				NR_SEQ_LOCAL_CAIXA,
				NR_SEQ_LOTE_SEC
			) values (
				nextval('lote_ent_sec_ficha_hist_seq'),
				clock_timestamp(),
				clock_timestamp(),
				nm_usuario_p,
				nm_usuario_p,
				nr_seq_ficha_w,
				nr_seq_local_p,
				nr_seq_local_caixa_p,
				nr_seq_lote_p
			);

			end;
		end loop;
		close C01;

	end if;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lote_ent_atua_local_armazena ( nr_seq_lote_p bigint, nr_seq_ficha_p bigint, nr_seq_local_p bigint, nr_seq_local_caixa_p bigint, nm_usuario_p text) FROM PUBLIC;
