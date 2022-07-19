-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE verifica_horario_agend_futuro (dt_agenda_p timestamp, nr_seq_ageint_item_p bigint, cd_pessoa_fisica_p bigint, nm_usuario_p text, cd_estabelecimento_p text, ie_retorno_p INOUT text) AS $body$
DECLARE


qt_agendamento_w	 bigint;
cd_especialidade_w	 agenda.cd_especialidade%type;
ie_bloq_ag_esp_hor_w varchar(1) := 'F';							


BEGIN

ie_bloq_ag_esp_hor_w := obter_param_usuario(869, 482, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_bloq_ag_esp_hor_w);

select	max(cd_especialidade)
into STRICT	cd_especialidade_w
from	agenda_integrada_item
where	nr_sequencia = nr_seq_ageint_item_p;

select 	coalesce(max(1), 0)
into STRICT	qt_agendamento_w
from 	agenda_consulta ag,
		agenda a
where 	a.cd_agenda = ag.cd_agenda
and		a.cd_tipo_agenda = 3
and 	((ie_bloq_ag_esp_hor_w = 'F' AND ag.dt_agenda > dt_agenda_p)
		OR (ie_bloq_ag_esp_hor_w = 'A' AND trunc(ag.dt_agenda) >= trunc(dt_agenda_p)))
and 	a.cd_especialidade = cd_especialidade_w
and		ag.cd_pessoa_fisica = cd_pessoa_fisica_p
and		ag.ie_status_agenda not in ('C','F','I')  LIMIT 1;

if (qt_agendamento_w > 0) then
	ie_retorno_p := 'S';
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE verifica_horario_agend_futuro (dt_agenda_p timestamp, nr_seq_ageint_item_p bigint, cd_pessoa_fisica_p bigint, nm_usuario_p text, cd_estabelecimento_p text, ie_retorno_p INOUT text) FROM PUBLIC;

