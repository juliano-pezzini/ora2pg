-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS agenda_quimio_marcacao_delete ON agenda_quimio_marcacao CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_agenda_quimio_marcacao_delete() RETURNS trigger AS $BODY$
DECLARE
dt_atualizacao 	timestamp	:= LOCALTIMESTAMP;
BEGIN
  BEGIN
BEGIN

delete	from quimio_controle_horario
where	dt_agenda = trunc(OLD.dt_agenda)
and	nr_seq_local	 = OLD.nr_seq_local;

exception
	when others then
      	dt_atualizacao := LOCALTIMESTAMP;
end;

if (OLD.IE_GERADO = 'S') then
	insert into log_tasy(DT_ATUALIZACAO, NM_USUARIO, DS_LOG, CD_LOG)
	values (LOCALTIMESTAMP, OLD.nm_usuario,
	substr('Log Deleted - nr_seq_atendimento:' ||  OLD.nr_seq_atendimento || ' - nr_seq_local:' || OLD.nr_seq_local || ' - nr_seq_pend_agenda:' || OLD.nr_seq_pend_agenda || ' - ie_gerado:' || OLD.ie_gerado || ' - ie_encaixe:' || OLD.ie_encaixe || ' - ie_transferencia:' || OLD.ie_transferencia || ' - ' ||
	obter_funcao_ativa || ' - ' || obter_usuario_ativo || ' - ' || obter_perfil_ativo || ' - stack:' ||
		dbms_utility.format_call_stack(),1,2000), 43312);
end if;

  END;
RETURN OLD;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_agenda_quimio_marcacao_delete() FROM PUBLIC;

CREATE TRIGGER agenda_quimio_marcacao_delete
	BEFORE DELETE ON agenda_quimio_marcacao FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_agenda_quimio_marcacao_delete();

