-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_w_dem_pagamento_lote ( nr_seq_lote_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
			 
nr_seq_protocolo_w	bigint;			
						 
C01 CURSOR FOR 
	SELECT	nr_seq_protocolo 
	from	pls_prot_conta_titulo 
	where	nr_seq_lote = nr_seq_lote_p 
	order by 1;		
			 

BEGIN 
 
/*É apagado anterior a abertura do cursor porque esta não sera uma ação realizada demtro da procedure.*/
 
delete	from 	w_pls_protocolo 
where	nm_usuario	= nm_usuario_p;
 
open C01;
loop 
fetch C01 into	 
	nr_seq_protocolo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	CALL pls_gerar_w_dem_pagamento(nr_seq_protocolo_w, null, null, 'N', nm_usuario_p);
	 
	end;
end loop;
close C01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_w_dem_pagamento_lote ( nr_seq_lote_p bigint, nm_usuario_p text) FROM PUBLIC;
