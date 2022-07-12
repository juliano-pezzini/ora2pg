-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS bloqueio_evolucao_paciente ON evolucao_paciente CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_bloqueio_evolucao_paciente() RETURNS trigger AS $BODY$
DECLARE
  IE_SOAP_W       varchar(1) := 'N';
  IE_INTEGRACAO_W varchar(1) := 'N';
  QT_REG_W		    smallint;
BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger	= 'N')  then
	goto Final;
end if;

  SELECT coalesce(MAX('S'),'N')
    INTO STRICT IE_INTEGRACAO_W
    FROM EVOLUCAO_PACIENTE_INT EPI
  WHERE EPI.NR_SEQ_EVOLUCAO = NEW.CD_EVOLUCAO;

Select 	coalesce(max('S'),'N')
into STRICT	ie_soap_w
from 	evolucao_paciente_vinculo
where	cd_evolucao = NEW.cd_evolucao
and	ie_tipo_item = 'SOAP';

	if ((ie_soap_w = 'N') and (IE_INTEGRACAO_W = 'N') AND (OLD.nm_usuario is not null) and (NEW.dt_liberacao < NEW.dt_atualizacao) and (NEW.dt_inativacao is null) and (coalesce(OLD.nr_seq_assinatura,0) = coalesce(NEW.nr_seq_assinatura,0))) then
		if (TG_OP = 'INSERT') then
			insert into log_tasy(
				cd_log,
				ds_log,
				dt_atualizacao,
				nm_usuario,
				nr_sequencia)
			values (
				54993,
				substr(' ;Insert ;cd_evolucao = ' || NEW.cd_evolucao ||
				' ;nr_atendimento = ' || NEW.nr_atendimento ||
				' ;dt_atualizacao_nrec = ' || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(NEW.dt_atualizacao_nrec, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)||
				' ;dt_atualizacao = ' || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(NEW.dt_atualizacao, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)||
				' ;dt_evolucao = ' || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(NEW.dt_evolucao, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)||
				' ;dt_liberacao = ' || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(NEW.dt_liberacao, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)||
				' ;nm_usuario = ' || NEW.nm_usuario ||
				' ;nm_usuario_nrec = ' || NEW.nm_usuario_nrec ||
				' ;Usuario = ' || OBTER_USUARIO_ATIVO ||
				' ;Perfil = ' || OBTER_PERFIL_ATIVO ||
				' ;Funcao = ' || OBTER_FUNCAO_ATIVA ||
				' ;new.cd_medico = '||NEW.cd_medico ||
				' ;old.cd_medico = '||OLD.cd_medico ||
				' ;old.nm_usuario = '||OLD.nm_usuario ||
				' ;old.dt_atualizacao_nrec = '||PKG_DATE_FORMATERS_TZ.TO_VARCHAR(OLD.dt_atualizacao_nrec, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)||
				' ;old.dt_atualizacao = ' || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(OLD.dt_atualizacao, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)||
				' ;old.dt_evolucao = ' || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(OLD.dt_evolucao, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)||PKG_DATE_FORMATERS_TZ.TO_VARCHAR(OLD.dt_liberacao, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)||
				' ;new.qt_caracteres = ' || NEW.qt_caracteres ||
				' ;old.qt_caracteres = ' || OLD.qt_caracteres ||
				' ;Stack: ' || substr(dbms_utility.format_call_stack,1,1900),1,1990),
				LOCALTIMESTAMP,
				OBTER_USUARIO_ATIVO,
				nextval('log_tasy_seq'));

		else
			insert into log_tasy(
				cd_log,
				ds_log,
				dt_atualizacao,
				nm_usuario,
				nr_sequencia)
			values (
				54993,
				substr(' ;Update ;cd_evolucao = ' || NEW.cd_evolucao ||
				' ;nr_atendimento = ' || NEW.nr_atendimento ||
				' ;dt_atualizacao_nrec = ' || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(NEW.dt_atualizacao_nrec, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)||
				' ;dt_atualizacao = ' || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(NEW.dt_atualizacao, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)||
				' ;dt_evolucao = ' || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(NEW.dt_evolucao, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)||
				' ;dt_liberacao = ' || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(NEW.dt_liberacao, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)||
				' ;nm_usuario = ' || NEW.nm_usuario ||
				' ;nm_usuario_nrec = ' || NEW.nm_usuario_nrec ||
				' ;Usuario = ' || OBTER_USUARIO_ATIVO ||
				' ;Perfil = ' || OBTER_PERFIL_ATIVO ||
				' ;Funcao = ' || OBTER_FUNCAO_ATIVA ||
				' ;new.cd_medico = '||NEW.cd_medico ||
				' ;old.cd_medico = '||OLD.cd_medico ||
				' ;old.nm_usuario = '||OLD.nm_usuario ||
				' ;old.dt_atualizacao_nrec = '||PKG_DATE_FORMATERS_TZ.TO_VARCHAR(OLD.dt_atualizacao_nrec, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)||
				' ;old.dt_atualizacao = ' || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(OLD.dt_atualizacao, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)||
				' ;old.dt_evolucao = ' || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(OLD.dt_evolucao, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)||
				' ;old.dt_liberacao = ' || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(OLD.dt_liberacao, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)||
				' ;new.qt_caracteres = ' || NEW.qt_caracteres ||
				' ;old.qt_caracteres = ' || OLD.qt_caracteres ||
				' ;Stack: ' || substr(dbms_utility.format_call_stack,1,1900),1,1990),
				LOCALTIMESTAMP,
				OBTER_USUARIO_ATIVO,
				nextval('log_tasy_seq'));
		end if;

		CALL wheb_mensagem_pck.exibir_mensagem_abort(1098265);--Esta nota clinica nao pode ser alterada! Ja existe data de liberacao.
	end if;

	if	((coalesce(NEW.nr_atendimento, 0) > 0) and (coalesce(NEW.cd_pessoa_fisica, '0') <> '0') and (NEW.cd_pessoa_fisica <> obter_pessoa_atendimento(NEW.nr_atendimento,'C'))) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(15270);--Nao foi possivel enviar a sua solicitacaoo. Favor contactar o Administrador.
	end if;
	
<<Final>>
qt_reg_w	:= 0;
RETURN NEW;
END;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_bloqueio_evolucao_paciente() FROM PUBLIC;

CREATE TRIGGER bloqueio_evolucao_paciente
	BEFORE INSERT OR UPDATE ON evolucao_paciente FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_bloqueio_evolucao_paciente();
