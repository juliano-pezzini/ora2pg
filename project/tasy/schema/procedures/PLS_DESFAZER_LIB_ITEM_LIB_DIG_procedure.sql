-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_desfazer_lib_item_lib_dig ( nr_seq_conta_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_seq_procedimento_w		bigint;
nr_seq_material_w		bigint;

C01 CURSOR FOR 
	SELECT	nr_sequencia 
	from	pls_conta_proc 
	where	nr_seq_conta	= nr_seq_conta_p;

C02 CURSOR FOR 
	SELECT	nr_sequencia 
	from	pls_conta_mat 
	where	nr_seq_conta	= nr_seq_conta_p;


BEGIN 
 
open C01;
loop 
fetch C01 into	 
	nr_seq_procedimento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
 
	CALL pls_desfazer_lib_item( nr_seq_procedimento_w, 'P', cd_estabelecimento_p, nm_usuario_p);
 
	end;
end loop;
close C01;
 
open C02;
loop 
fetch C02 into	 
	nr_seq_material_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin 
 
	CALL pls_desfazer_lib_item( nr_seq_material_w, 'M', cd_estabelecimento_p, nm_usuario_p);
 
	end;
end loop;
close C02;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_desfazer_lib_item_lib_dig ( nr_seq_conta_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
