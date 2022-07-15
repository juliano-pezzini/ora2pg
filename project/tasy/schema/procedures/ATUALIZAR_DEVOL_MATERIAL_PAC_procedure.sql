-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_devol_material_pac ( ds_justificativa_p text, nr_devolucao_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_justificativa_w varchar(255);


BEGIN
select 	substr(ds_justificativa ||' '|| ds_justificativa_p,1,250)
into STRICT 	ds_justificativa_w
from 	devolucao_material_pac
where 	nr_devolucao = nr_devolucao_p;

update 	devolucao_material_pac
set	ds_justificativa 	= ds_justificativa_w,
	nm_usuario 		= nm_usuario_p,
	dt_atualizacao		= clock_timestamp()
where	nr_devolucao		= nr_devolucao_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_devol_material_pac ( ds_justificativa_p text, nr_devolucao_p bigint, nm_usuario_p text) FROM PUBLIC;

