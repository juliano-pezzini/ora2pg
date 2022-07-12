-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS trg_agendamento_build_log ON agendamento_build CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_trg_agendamento_build_log() RETURNS trigger AS $BODY$
DECLARE

  action_w varchar(2);	
	
  change_request_action CONSTANT varchar(2) := 'CR';
  pending_approval_action CONSTANT varchar(2) := 'PA';
  scheduled_build_action CONSTANT varchar(2) := 'SB';
  canceled_action CONSTANT varchar(2) := 'C';
  executed_build_action CONSTANT varchar(2) := 'EB';
  change_request_refused_action CONSTANT varchar(2) := 'RR';
  change_request_approved_action CONSTANT varchar(2) := 'RA';
  priority_build_action CONSTANT varchar(2) := 'P';
  rescheduled_build_action CONSTANT varchar(2) := 'RB';
  undefined_action CONSTANT varchar(2) := 'U';
  delete_action CONSTANT varchar(2) := 'D';
  lost_priority_action CONSTANT varchar(2) := 'LP';

  troca_pendente_aprovacao CONSTANT varchar(2) := 'TA';
  cancelado CONSTANT varchar(2) := 'C';
  build_agendado CONSTANT varchar(2) := 'BA';
  build_executado CONSTANT varchar(2) := 'BE';
  pendente_liberacao CONSTANT varchar(2) := 'PL';
  periodo_prioritario CONSTANT varchar(2) := 'P';
  periodo_vespertino CONSTANT varchar(2) := 'V';
  periodo_matutino CONSTANT varchar(2) := 'M';


BEGIN
	if (TG_OP = 'INSERT') then
		action_w := pending_approval_action;
	elsif (TG_OP = 'DELETE') then
		action_w := delete_action;
		insert into agendamento_build_log(nr_sequencia,
		 nm_usuario,
		 nr_seq_agendamento_build,
		 dt_atualizacao,
		 dt_agendamento,
		 ie_acao,
		 cd_versao,
		 ie_aplicacao,
		 ie_periodo
		 )
		values (nextval('agendamento_build_log_seq'),
		 OLD.nm_usuario,
		 OLD.nr_sequencia,
		 LOCALTIMESTAMP,
		 OLD.dt_agendamento,
	     delete_action,
		 OLD.cd_versao,
		 OLD.ie_aplicacao,
		 OLD.ie_periodo
		);
	elsif (TG_OP = 'UPDATE') then
	    if (OLD.ie_status = pendente_liberacao and NEW.ie_status = build_agendado) then 
			action_w :=  scheduled_build_action;
			
		elsif (NEW.ie_status = build_executado) then
			action_w :=  executed_build_action;
			
		elsif (NEW.ie_status = troca_pendente_aprovacao) then 
			action_w := change_request_action;
		elsif (OLD.ie_status = troca_pendente_aprovacao) then
			if (NEW.ie_status = cancelado) then
				action_w := change_request_refused_action;			
			elsif (coalesce(OLD.dt_agendamento, to_date('1999-01-01', 'yyyy-MM-dd')) = coalesce(NEW.dt_agendamento, to_date('1999-01-01', 'yyyy-MM-dd'))) then
				action_w := change_request_approved_action;
			end if;
		elsif (NEW.ie_status = cancelado) then
			action_w := canceled_action;
		elsif (NEW.ie_status = build_agendado and NEW.ie_periodo = periodo_prioritario and OLD.ie_periodo in (periodo_vespertino, periodo_matutino)) then
			action_w := priority_build_action;
		elsif (OLD.ie_periodo <> NEW.ie_periodo and NEW.ie_periodo <> periodo_prioritario)then
			action_w := rescheduled_build_action;
		elsif (NEW.ie_periodo <> OLD.ie_periodo and OLD.ie_periodo = periodo_prioritario)then
			action_w := lost_priority_action;
		else
			action_w :=  undefined_action;
		end if;
	end if;
		
	if (action_w <> delete_action) then
		insert into agendamento_build_log(nr_sequencia,
		 nm_usuario,
		 nr_seq_agendamento_build,
		 dt_atualizacao,
		 dt_agendamento,
		 ie_acao,
		 cd_versao,
		 ie_aplicacao,
		 ie_periodo
		 )
		values (nextval('agendamento_build_log_seq'),
		 NEW.nm_usuario,
		 NEW.nr_sequencia,
		 LOCALTIMESTAMP,
		 NEW.dt_agendamento,
		 action_w,
		 NEW.cd_versao,
		 NEW.ie_aplicacao,
		 NEW.ie_periodo
		);
	end if;
IF TG_OP = 'DELETE' THEN
	RETURN OLD;
ELSE
	RETURN NEW;
END IF;

end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_trg_agendamento_build_log() FROM PUBLIC;

CREATE TRIGGER trg_agendamento_build_log
	AFTER INSERT OR UPDATE OR DELETE ON agendamento_build FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_trg_agendamento_build_log();
