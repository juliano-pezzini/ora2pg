-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_item_servico_mat ( cd_material_p bigint, nr_seq_item_serv_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
qt_registros_w		bigint;					
					 

BEGIN 
 
select	count(*) 
into STRICT	qt_registros_w 
from	material_fiscal 
where	cd_material = cd_material_p;
 
if (qt_registros_w > 0) then 
	update	material_fiscal 
	set	nr_seq_item_serv = nr_seq_item_serv_p, 
		nm_usuario = nm_usuario_p, 
		dt_atualizacao = clock_timestamp() 
	where	cd_material = cd_material_p;
 
else 
	insert into material_fiscal( 
		nr_sequencia, 
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		cd_material, 
		nr_seq_item_serv) 
	values (	nextval('material_fiscal_seq'), 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		cd_material_p, 
		nr_seq_item_serv_p);
end if;
		 
	 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_item_servico_mat ( cd_material_p bigint, nr_seq_item_serv_p bigint, nm_usuario_p text) FROM PUBLIC;

