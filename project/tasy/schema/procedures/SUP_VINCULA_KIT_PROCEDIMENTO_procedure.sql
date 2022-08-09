-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sup_vincula_kit_procedimento ( cd_kit_material_p bigint, cd_procedimento_p bigint, ie_origem_proc_p bigint, nm_usuario_p text) AS $body$
BEGIN

update 	procedimento
set 	cd_kit_material 	= cd_kit_material_p
where 	cd_procedimento 	= cd_procedimento_p
and   	ie_origem_proced 	= ie_origem_proc_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sup_vincula_kit_procedimento ( cd_kit_material_p bigint, cd_procedimento_p bigint, ie_origem_proc_p bigint, nm_usuario_p text) FROM PUBLIC;
