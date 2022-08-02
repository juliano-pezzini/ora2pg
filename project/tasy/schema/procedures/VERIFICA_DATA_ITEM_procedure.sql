-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE verifica_data_item ( nr_sequencia_p bigint, dt_item_p timestamp, dt_conta_p timestamp, ie_consiste_periodo_p text, nm_usuario_p text) AS $body$
DECLARE


dt_periodo_inicial_w	timestamp;
dt_periodo_final_w		timestamp;
ie_retorno_w		varchar(1) := 'N';


BEGIN

if (ie_consiste_periodo_p <> 'N') then

	select 	max(dt_periodo_inicial),
		max(dt_periodo_final)
	into STRICT	dt_periodo_inicial_w,
		dt_periodo_final_w
	from 	auditoria_conta_paciente
	where 	nr_sequencia = nr_sequencia_p;

	select	coalesce(max('S'),'N')
	into STRICT	ie_retorno_w
	
	where	((((ie_consiste_periodo_p = 'S') or (ie_consiste_periodo_p = 'SC')) and (dt_conta_p between dt_periodo_inicial_w and dt_periodo_final_w)) or (ie_consiste_periodo_p = 'SI'))
	and	((((ie_consiste_periodo_p = 'S') or (ie_consiste_periodo_p = 'SI')) and (dt_item_p between dt_periodo_inicial_w and dt_periodo_final_w)) or (ie_consiste_periodo_p = 'SC'));

	if (ie_retorno_w <> 'S') then
		CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(280112);
	end if;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE verifica_data_item ( nr_sequencia_p bigint, dt_item_p timestamp, dt_conta_p timestamp, ie_consiste_periodo_p text, nm_usuario_p text) FROM PUBLIC;

