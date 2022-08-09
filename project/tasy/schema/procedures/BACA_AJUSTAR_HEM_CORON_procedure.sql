-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_ajustar_hem_coron (nm_usuario_p text) AS $body$
DECLARE



nr_seq_coron_w		bigint;
nr_seq_segmento_coron_w		bigint;
nr_seq_segmento_w		bigint;


c01 CURSOR FOR
SELECT	a.nr_sequencia,
		a.nr_seq_segmento
from	hem_coronariografia a
where 	(a.nr_seq_segmento IS NOT NULL AND a.nr_seq_segmento::text <> '');



BEGIN

OPEN C01;
LOOP
FETCH C01 into
	nr_seq_coron_w,
	nr_seq_segmento_coron_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	select max(nr_seq_segmento)
	into STRICT nr_seq_segmento_w
	from hem_coron_localizacao
	where nr_seq_coron = nr_seq_coron_w
	and nr_seq_segmento = nr_seq_segmento_coron_w;

	if (coalesce(nr_seq_segmento_w::text, '') = '') then
		INSERT INTO hem_coron_localizacao(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_coron,
		nr_seq_segmento)
		VALUES (nextval('hem_coron_localizacao_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_coron_w,
		nr_seq_segmento_coron_w);

		commit;
	end if;


	end;
END LOOP;
CLOSE C01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_ajustar_hem_coron (nm_usuario_p text) FROM PUBLIC;
