-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS agenda_paciente_inf_adic_atual ON agenda_paciente_inf_adic CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_agenda_paciente_inf_adic_atual() RETURNS trigger AS $BODY$
declare
ds_alteracao_w		varchar(4000);

BEGIN

if (TG_OP = 'UPDATE') then
	if (coalesce(OLD.ds_informacoes_internacao,'X') <> coalesce(NEW.ds_informacoes_internacao,'X')) then
		ds_alteracao_w	:=	substr(wheb_mensagem_pck.get_texto(800130,
								'DS_INFORMACOES_INTERNACAO_OLD='||OLD.ds_informacoes_internacao||
								';DS_INFORMACOES_INTERNACAO_NEW='||NEW.ds_informacoes_internacao),1,4000);
	end if;
	if (ds_alteracao_w is not null) then
		CALL gravar_historico_montagem(NEW.nr_seq_agenda,'AF',ds_alteracao_w,NEW.nm_usuario);
	end if;
elsif (NEW.ds_informacoes_internacao	is not null) then
	ds_alteracao_w	:=	substr(wheb_mensagem_pck.get_texto(800129)||' '||NEW.ds_informacoes_internacao,1,4000);

	if (ds_alteracao_w is not null) then
		CALL gravar_historico_montagem(NEW.nr_seq_agenda,'IF',ds_alteracao_w,NEW.nm_usuario);
	end if;
end if;


RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_agenda_paciente_inf_adic_atual() FROM PUBLIC;

CREATE TRIGGER agenda_paciente_inf_adic_atual
	BEFORE INSERT OR UPDATE ON agenda_paciente_inf_adic FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_agenda_paciente_inf_adic_atual();
