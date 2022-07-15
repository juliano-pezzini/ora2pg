-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fa_gerar_estorno_entrega ( nr_seq_entrega_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_seq_entrega_item_w	bigint;

C01 CURSOR FOR 
	SELECT 	nr_sequencia 
	from	fa_entrega_medicacao_item 
	where	nr_seq_fa_entrega = nr_seq_entrega_p 
	and	coalesce(dt_cancelamento::text, '') = '';

BEGIN
open C01;
loop 
fetch C01 into	 
	nr_seq_entrega_item_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	CALL fa_gerar_estorno_entrega_item(nr_seq_entrega_item_w, nm_usuario_p);	
	end;
end loop;
close C01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fa_gerar_estorno_entrega ( nr_seq_entrega_p bigint, nm_usuario_p text) FROM PUBLIC;

