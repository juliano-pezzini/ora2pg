-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_tasymed_importacao ( nm_usuario_p text, nr_seq_tipo_pepa_p bigint default null) AS $body$
DECLARE

				

cd_profissional_w		varchar(10);
				
C01 CURSOR FOR
	SELECT	distinct(a.cd_medico)
	from	med_cliente a
	where	coalesce(a.ie_exportado,'N') = 'N'
	order by a.cd_medico;
	

BEGIN

open C01;
loop
fetch C01 into
	cd_profissional_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	CALL baca_tasymed_profissional(cd_profissional_w, nm_usuario_p, nr_seq_tipo_pepa_p);
		
	end;
end loop;
close C01;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_tasymed_importacao ( nm_usuario_p text, nr_seq_tipo_pepa_p bigint default null) FROM PUBLIC;
