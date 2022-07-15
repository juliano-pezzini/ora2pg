-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_etapa_orc ( nr_seq_cron_p bigint, nm_usuario_p text, nr_seq_orcamento_p bigint, nr_seq_conta_p bigint) AS $body$
DECLARE




nr_sequencia_w		bigint;

C01 CURSOR FOR
	SELECT	a.nr_sequencia
	from	gpi_cron_etapa a
	where	a.nr_seq_cronograma = nr_seq_cron_p
	and	not exists (	SELECT  1
				from	gpi_orc_item x
				where	a.nr_sequencia = x.nr_seq_etapa)
	order by 1;



BEGIN

open C01;
loop
fetch C01 into
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	insert into gpi_orc_item(	nr_sequencia,
					nr_seq_orcamento,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_seq_plano,
					vl_orcado,
					vl_realizado,
					nr_seq_etapa)
		values (	nextval('gpi_orc_item_seq'),
					nr_seq_orcamento_p,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_conta_p,
					0,
					0,
					nr_sequencia_w);



	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copiar_etapa_orc ( nr_seq_cron_p bigint, nm_usuario_p text, nr_seq_orcamento_p bigint, nr_seq_conta_p bigint) FROM PUBLIC;

