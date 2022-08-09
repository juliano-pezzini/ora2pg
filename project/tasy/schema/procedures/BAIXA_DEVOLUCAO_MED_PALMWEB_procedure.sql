-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baixa_devolucao_med_palmweb ( nr_devolucao_p bigint, cd_tipo_baixa_p text, cd_pessoa_fisica_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
C01 CURSOR FOR 
	SELECT	nr_sequencia, 
		qt_material, 
		cd_local_estoque 
	from	item_devolucao_material_pac 
	where	nr_devolucao = nr_devolucao_p;
	
nr_sequencia_w	item_devolucao_material_pac.nr_sequencia%type;
qt_material_w	item_devolucao_material_pac.qt_material%type;
cd_local_estoque_w	local_estoque.cd_local_estoque%type;


BEGIN 
 
if (nr_devolucao_p IS NOT NULL AND nr_devolucao_p::text <> '') then 
 
	open C01;
	loop 
	fetch C01 into	 
		nr_sequencia_w, 
		qt_material_w, 
		cd_local_estoque_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		CALL baixa_devolucao_med(nr_devolucao_p, nr_sequencia_w, nm_usuario_p, cd_tipo_baixa_p, qt_material_w, cd_pessoa_fisica_p, cd_local_estoque_w, 'B', cd_estabelecimento_p);
		end;
	end loop;
	close C01;
	 
	update	devolucao_material_pac 
	set	dt_baixa_total = clock_timestamp() 
	where	nr_devolucao = nr_devolucao_p;
 
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baixa_devolucao_med_palmweb ( nr_devolucao_p bigint, cd_tipo_baixa_p text, cd_pessoa_fisica_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
