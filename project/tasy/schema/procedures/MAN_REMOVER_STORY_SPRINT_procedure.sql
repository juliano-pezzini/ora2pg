-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_remover_story_sprint ( nr_sprint_p bigint, nr_story_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_status_w	desenv_story_sprint.cd_status%type;


BEGIN

select	max(cd_status)
into STRICT	cd_status_w
from	desenv_story_sprint
where	nr_story = nr_story_p
and	nr_sprint = nr_sprint_p
and	coalesce(ie_cancelado_sprint,'N') <> 'S';

if (cd_status_w = 4) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(351399);
end if;

update	desenv_story_sprint
set	ie_cancelado_sprint = CASE WHEN coalesce(ie_cancelado_sprint,'N')='N' THEN 'S'  ELSE 'N' END ,
	dt_atualizacao = clock_timestamp(),
	nm_usuario = nm_usuario_p
where	nr_sprint = nr_sprint_p
and	nr_story = nr_story_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_remover_story_sprint ( nr_sprint_p bigint, nr_story_p bigint, nm_usuario_p text) FROM PUBLIC;
