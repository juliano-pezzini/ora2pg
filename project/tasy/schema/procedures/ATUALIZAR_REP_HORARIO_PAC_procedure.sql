-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_rep_horario_pac (nr_atendimento_p bigint, cd_material_p bigint, nm_usuario_p text, ie_tipo_item_p text, cd_procedimento_p bigint) AS $body$
BEGIN

if (ie_tipo_item_p in ('M', 'S', 'SNE')) then
	update	rep_horario_hor_pac
	set		dt_cancelamento	= clock_timestamp()
	where	nr_atendimento	= nr_atendimento_p
	and		cd_material	= cd_material_p
	and		coalesce(dt_cancelamento::text, '') = '';
elsif (ie_tipo_item_p = 'P') then
    update	rep_horario_hor_pac
	set		dt_cancelamento	= clock_timestamp()
	where	nr_atendimento	= nr_atendimento_p
	and		cd_procedimento		= cd_procedimento_p
	and		coalesce(dt_cancelamento::text, '') = '';
end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_rep_horario_pac (nr_atendimento_p bigint, cd_material_p bigint, nm_usuario_p text, ie_tipo_item_p text, cd_procedimento_p bigint) FROM PUBLIC;
