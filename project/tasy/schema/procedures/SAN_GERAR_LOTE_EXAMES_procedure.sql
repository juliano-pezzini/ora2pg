-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE san_gerar_lote_exames ( nr_sequencia_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, nm_usuario_p text) AS $body$
DECLARE


nr_seq_exame_lote_w		bigint;
nr_seq_exame_w  			bigint;

c01 CURSOR FOR
SELECT	a.nr_seq_exame_lote,
	a.nr_seq_exame
from	san_exame_realizado a
where	a.dt_realizado	between dt_inicio_p and dt_fim_p
and (san_obter_destino_exame(a.nr_seq_exame,3) = 'S' or san_obter_destino_exame(a.nr_seq_exame,0) = 'S')
and	not exists (select 1
		from	san_lote_hemoterapia_item x
		where	x.nr_seq_exame = a.nr_seq_exame
		and	x.nr_seq_exame_lote = a.nr_seq_exame_lote);

BEGIN

update	san_lote_hemoterapia
set	dt_geracao	=	clock_timestamp()
where	nr_sequencia	=	nr_sequencia_p;

open C01;
loop
fetch C01 into
	nr_seq_exame_lote_w,
	nr_seq_exame_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	insert into san_lote_hemoterapia_item(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_lote,
				nr_seq_exame,
				nr_seq_exame_lote)
			values (
				nextval('san_lote_hemoterapia_item_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_sequencia_p,
				nr_seq_exame_w,
				nr_seq_exame_lote_w);
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE san_gerar_lote_exames ( nr_sequencia_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, nm_usuario_p text) FROM PUBLIC;
