-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_validar_regist_invalidos ( nr_atendimento_p bigint, nm_usuario_p text) AS $body$
BEGIN
 
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '' AND nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then 
 
	update	cpoe_recomendacao 
	set		ie_item_valido = 'S' 
	where	nr_atendimento = nr_atendimento_p 
	and		nm_usuario	= nm_usuario_p 
	and		ie_item_valido = 'N';
 
	update	cpoe_material 
	set		ie_item_valido = 'S' 
	where	nr_atendimento = nr_atendimento_p 
	and		nm_usuario	= nm_usuario_p 
	and		ie_item_valido = 'N';
 
	update	cpoe_procedimento 
	set		ie_item_valido = 'S' 
	where	nr_atendimento = nr_atendimento_p 
	and		nm_usuario	= nm_usuario_p 
	and		ie_item_valido = 'N';
 
	update	cpoe_dieta 
	set		ie_item_valido = 'S' 
	where	nr_atendimento = nr_atendimento_p 
	and		nm_usuario	= nm_usuario_p 
	and		ie_item_valido = 'N';
 
	update	cpoe_dialise 
	set		ie_item_valido = 'S' 
	where	nr_atendimento = nr_atendimento_p 
	and		nm_usuario	= nm_usuario_p 
	and		ie_item_valido = 'N';
 
	update	cpoe_hemoterapia 
	set		ie_item_valido = 'S' 
	where	nr_atendimento = nr_atendimento_p 
	and		nm_usuario	= nm_usuario_p 
	and		ie_item_valido = 'N';
 
	update	cpoe_gasoterapia 
	set		ie_item_valido = 'S' 
	where	nr_atendimento = nr_atendimento_p 
	and		nm_usuario	= nm_usuario_p 
	and		ie_item_valido = 'N';
	 
	update	cpoe_anatomia_patologica 
	set		ie_item_valido = 'S' 
	where	nr_atendimento = nr_atendimento_p 
	and		nm_usuario	= nm_usuario_p 
	and		ie_item_valido = 'N';
 
	commit;
 
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_validar_regist_invalidos ( nr_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;

