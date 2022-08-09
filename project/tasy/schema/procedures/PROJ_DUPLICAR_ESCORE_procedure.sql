-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proj_duplicar_escore ( nr_seq_escore_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_escore_w				bigint;
nr_seq_escore_item_w		bigint;
nr_seq_escore_item_ww		bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	proj_escore_item
	where	nr_seq_escore	= nr_seq_escore_p;


BEGIN

select	nextval('proj_escore_seq')
into STRICT	nr_seq_escore_w
;

insert into proj_escore(nr_sequencia, nr_seq_proj, dt_atualizacao,
	nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
	dt_escore, qt_escore, nr_seq_regra,
	dt_liberacao, nm_usuario_lib)
SELECT	nr_seq_escore_w, nr_seq_proj, clock_timestamp(),
	nm_usuario_p, clock_timestamp(), nm_usuario_p,
	PKG_DATE_UTILS.ADD_MONTH(dt_escore,1, 0), qt_escore, nr_seq_regra,
	null, null
from	proj_escore
where	nr_sequencia	= nr_seq_escore_p;

open C01;
loop
fetch C01 into
	nr_seq_escore_item_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	select	nextval('proj_escore_item_seq')
	into STRICT	nr_seq_escore_item_ww
	;

	insert into proj_escore_item(nr_sequencia, nr_seq_escore, dt_atualizacao,
		nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
		nr_seq_item, nr_seq_area, qt_escore,
		qt_nota, qt_escore_real, pr_escore_real,
		qt_nota_maxima)
	SELECT	nr_seq_escore_item_ww, nr_seq_escore_w, clock_timestamp(),
		nm_usuario_p, clock_timestamp(), nm_usuario_p,
		nr_seq_item, nr_seq_area, qt_escore,
		qt_nota, qt_escore_real, pr_escore_real,
		qt_nota_maxima
	from	proj_escore_item
	where	nr_sequencia	= nr_seq_escore_item_w;

	insert into proj_avaliacao_quesito(nr_sequencia, nr_seq_avaliacao, dt_atualizacao,
		nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
		ds_observacao, nr_seq_opcao, nr_seq_escore_item)
	SELECT	nextval('proj_avaliacao_quesito_seq'), nr_seq_avaliacao, clock_timestamp(),
		nm_usuario_p, clock_timestamp(), nm_usuario_p,
		ds_observacao, nr_seq_opcao, nr_seq_escore_item_ww
	from	proj_avaliacao_quesito
	where	nr_seq_escore_item	= nr_seq_escore_item_w;
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE proj_duplicar_escore ( nr_seq_escore_p bigint, nm_usuario_p text) FROM PUBLIC;
