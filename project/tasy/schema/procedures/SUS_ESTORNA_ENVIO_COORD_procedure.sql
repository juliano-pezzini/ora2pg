-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_estorna_envio_coord ( dt_inicial_p timestamp , dt_final_p timestamp , nm_usuario_p text ) AS $body$
DECLARE

				 
nr_interno_conta_w		bigint;

					 
c01 CURSOR FOR 
	SELECT	c.nr_interno_conta 
	from	conta_paciente a, 
		sus_aih_unif b, 
		w_susaih_interf_cab_coord c 
	where	a.nr_interno_conta	= b.nr_interno_conta 
	and	a.nr_interno_conta	= c.nr_interno_conta 
	and	a.ie_status_acerto	= 2 
	and	(c.dt_envio_coord IS NOT NULL AND c.dt_envio_coord::text <> '') 
	and	b.dt_final between dt_inicial_p and dt_final_p;
					

BEGIN 
 
open c01;
loop 
fetch c01 into	 
	nr_interno_conta_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	 
	update	w_susaih_interf_cab_coord 
	set	dt_envio_coord 	 = NULL, 
		nm_usuario_envio	 = NULL, 
		dt_atualizacao	= clock_timestamp(), 
		nm_usuario	= nm_usuario_p 
	where	nr_interno_conta	= nr_interno_conta_w;		
	 
	end;
end loop;
close c01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_estorna_envio_coord ( dt_inicial_p timestamp , dt_final_p timestamp , nm_usuario_p text ) FROM PUBLIC;

