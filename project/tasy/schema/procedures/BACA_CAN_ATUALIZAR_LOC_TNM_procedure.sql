-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_can_atualizar_loc_tnm () AS $body$
DECLARE


cd_topografia_w		varchar(10);
NR_SEQ_LOC_TNM_w	bigint;

c01 CURSOR FOR
	SELECT 	cd_topografia,
		NR_SEQ_LOC_TNM
	from	cido_topografia
	where	(NR_SEQ_LOC_TNM IS NOT NULL AND NR_SEQ_LOC_TNM::text <> '');


BEGIN

open c01;
loop
fetch c01 into  cd_topografia_w,
		NR_SEQ_LOC_TNM_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	insert into can_tnm_local_topo(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			cd_topografia,
			nr_seq_loc_tnm)
		values (nextval('can_tnm_local_topo_seq'),
			clock_timestamp(),
			'TASY',
			clock_timestamp(),
			'TASY',
			cd_topografia_w,
			NR_SEQ_LOC_TNM_w);

	end;
end loop;
close c01;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_can_atualizar_loc_tnm () FROM PUBLIC;
