-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE desvincular_nc_bordero ( nr_seq_bordero_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_seq_nc_w		bigint;

c01 CURSOR FOR 
SELECT	nr_seq_nota_credito 
from	bordero_nc_nota_credito 
where	nr_seq_bordero = nr_seq_bordero_p;


BEGIN 
 
open	c01;
loop 
fetch c01 into 
	nr_seq_nc_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
 
	CALL GERAR_BORDERO_NC_NOTA_CREDITO(nr_seq_bordero_p,nr_seq_nc_w,0,nm_usuario_p,'D');
 
	end;
end loop;
close c01;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE desvincular_nc_bordero ( nr_seq_bordero_p bigint, nm_usuario_p text) FROM PUBLIC;
