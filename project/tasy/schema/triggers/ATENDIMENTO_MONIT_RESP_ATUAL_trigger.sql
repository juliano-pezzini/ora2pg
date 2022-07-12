-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS atendimento_monit_resp_atual ON atendimento_monit_resp CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_atendimento_monit_resp_atual() RETURNS trigger AS $BODY$
DECLARE

ds_hora_w	varchar(20);
dt_registro_w	timestamp;
dt_apap_w	timestamp;
qt_hora_w	double precision;
qt_reg_w	smallint;
qt_registro_atend_adic_w	bigint;

BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger	= 'N')  then
	goto Final;
end if;
if (NEW.nr_hora is null) or (NEW.dt_monitorizacao <> OLD.dt_monitorizacao) then
	BEGIN
	NEW.nr_hora	:= (to_char(round(NEW.dt_monitorizacao,'hh24'),'hh24'))::numeric;
	end;
end if;

if (coalesce(OLD.DT_MONITORIZACAO,LOCALTIMESTAMP + interval '10 days') <> NEW.DT_MONITORIZACAO) and (NEW.DT_MONITORIZACAO is not null) then
	NEW.ds_utc				:= obter_data_utc(NEW.DT_MONITORIZACAO, 'HV');	
end if;

if (coalesce(OLD.DT_LIBERACAO,LOCALTIMESTAMP + interval '10 days') <> NEW.DT_LIBERACAO) and (NEW.DT_LIBERACAO is not null) then
	NEW.ds_utc_atualizacao	:= obter_data_utc(NEW.DT_LIBERACAO,'HV');
end if;

if (NEW.nr_hora is not null) and
	((OLD.nr_hora is null) or (OLD.dt_monitorizacao is null) or (NEW.nr_hora <> OLD.nr_hora) or (NEW.dt_monitorizacao <> OLD.dt_monitorizacao)) then
	BEGIN
	ds_hora_w	:= substr(obter_valor_dominio(2119,NEW.nr_hora),1,2);
	dt_registro_w	:= trunc(NEW.dt_monitorizacao,'hh24');
	dt_apap_w	:= to_date(to_char(NEW.dt_monitorizacao,'dd/mm/yyyy') ||' '||ds_hora_w||':00:00','dd/mm/yyyy hh24:mi:ss');
	if (to_char(round(NEW.dt_monitorizacao,'hh24'),'hh24') = ds_hora_w) then
		NEW.dt_referencia	:= round(NEW.dt_monitorizacao,'hh24');
	else
		BEGIN
		qt_hora_w	:= (trunc(NEW.dt_monitorizacao,'hh24') - to_date(to_char(NEW.dt_monitorizacao,'dd/mm/yyyy') ||' '||ds_hora_w||':00:00','dd/mm/yyyy hh24:mi:ss')) * 24;
		if (qt_hora_w > 12) then
			NEW.dt_referencia	:= to_date(to_char(ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(NEW.dt_monitorizacao + 1),'dd/mm/yyyy') ||' '||ds_hora_w ||':00:00','dd/mm/yyyy hh24:mi:ss');
		elsif (qt_hora_w > 0) and (qt_hora_w <= 12) then
			NEW.dt_referencia	:= to_date(to_char(ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(NEW.dt_monitorizacao),'dd/mm/yyyy') ||' '||ds_hora_w ||':00:00','dd/mm/yyyy hh24:mi:ss');
		elsif (qt_hora_w >= -12) then
			NEW.dt_referencia	:= to_date(to_char(ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(NEW.dt_monitorizacao),'dd/mm/yyyy') ||' '||ds_hora_w ||':00:00','dd/mm/yyyy hh24:mi:ss');
		elsif (qt_hora_w < -12) then
			NEW.dt_referencia	:= to_date(to_char(ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(NEW.dt_monitorizacao - 1),'dd/mm/yyyy') ||' '||ds_hora_w ||':00:00','dd/mm/yyyy hh24:mi:ss');
		end if;
		end;
	end if;
	end;
end if;

if (TG_OP = 'INSERT') and (coalesce(NEW.ie_integracao,'N')	= 'S') then
   CALL record_integration_notify(null,NEW.nr_atendimento,'MR',NEW.nr_sequencia,null,'S');
end if;

select count(*) 
into STRICT qt_registro_atend_adic_w 
from atend_paciente_adic
where nr_atendimento = NEW.nr_atendimento;

if (NEW.dt_liberacao is not null
	and NEW.ie_respiracao in ('VMIFB', 'VMI')
	and qt_registro_atend_adic_w > 0) then
	BEGIN
		update atend_paciente_adic 
		set ie_ventilacao = 'S'
		where nr_atendimento = NEW.nr_atendimento;
	end;
elsif (NEW.dt_liberacao is not null
	   and NEW.ie_respiracao not in ('VMIFB', 'VMI')
	   and qt_registro_atend_adic_w > 0) then
	BEGIN
		update atend_paciente_adic 
		set ie_ventilacao = 'N'
		where nr_atendimento = NEW.nr_atendimento;
	end;
elsif (NEW.dt_liberacao is not null
	and NEW.ie_respiracao in ('VMIFB', 'VMI')
	and qt_registro_atend_adic_w = 0) then
	BEGIN
		insert into atend_paciente_adic(
			nr_sequencia,
			dt_atualizacao,
			nr_atendimento,
			nm_usuario,
			ie_ventilacao
		) SELECT nextval('atend_paciente_adic_seq'),
			LOCALTIMESTAMP,
			NEW.nr_atendimento,
			NEW.nm_usuario,
			'S';
	end;
elsif (NEW.dt_liberacao is not null
	   and NEW.ie_respiracao not in ('VMIFB', 'VMI')
	   and qt_registro_atend_adic_w = 0) then
	BEGIN
		insert into atend_paciente_adic(
			nr_sequencia,
			dt_atualizacao,
			nr_atendimento,
			nm_usuario,
			ie_ventilacao
		) SELECT nextval('atend_paciente_adic_seq'),
			LOCALTIMESTAMP,
			NEW.nr_atendimento,
			NEW.nm_usuario,
			'N';
	end;
end if;

<<Final>>
qt_reg_w	:= 0;

RETURN NEW;
END;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_atendimento_monit_resp_atual() FROM PUBLIC;

CREATE TRIGGER atendimento_monit_resp_atual
	BEFORE INSERT OR UPDATE ON atendimento_monit_resp FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_atendimento_monit_resp_atual();
