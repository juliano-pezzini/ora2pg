-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS agenda_consulta_delete ON agenda_consulta CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_agenda_consulta_delete() RETURNS trigger AS $BODY$
DECLARE
dt_atualizacao 	timestamp	:= LOCALTIMESTAMP;
OSUSER_w	varchar(100);
BEGIN
  BEGIN

delete 	from agenda_consulta_envio
where	nr_seq_agenda = OLD.nr_sequencia;
BEGIN

if (OLD.ie_status_agenda <> 'L') and
	((OLD.ie_status_agenda <> 'B') and (coalesce(OLD.ie_bloqueado_manual,'N') = 'N')) then
	select	substr(max(coalesce(client_info,machine)),1,15)
	into STRICT	OSUSER_w
	from	v$session
	where	audsid = (SELECT userenv('sessionid') );

	if (position('USER=' in upper(OSUSER_w)) > 0) then
		osuser_w	:= substr(OSUSER_w,6,position(';' in OSUSER_w)-6);
	end	if;

	
	CALL gerar_agenda_consulta_hist(OLD.cd_agenda,OLD.nr_sequencia,'DEL',coalesce(OSUSER_w,OLD.nm_usuario),obter_desc_expressao(489910),OLD.cd_pessoa_fisica,OLD.nm_paciente,OLD.dt_agenda);
end if;

if (OLD.ie_status_agenda not in ('L','B','LF')) then
	delete FROM agenda_controle_horario
	where 	cd_agenda = OLD.cd_agenda
	and 	dt_agenda = trunc(OLD.dt_agenda);
end if;

delete	from same_cpi_solic
where	nr_seq_agenda	= OLD.nr_sequencia;


exception
	when others then
      	dt_atualizacao := LOCALTIMESTAMP;
end;
  END;
RETURN OLD;
END;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_agenda_consulta_delete() FROM PUBLIC;

CREATE TRIGGER agenda_consulta_delete
	BEFORE DELETE ON agenda_consulta FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_agenda_consulta_delete();
