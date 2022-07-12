-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS evolucao_paciente_atual_lib ON evolucao_paciente CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_evolucao_paciente_atual_lib() RETURNS trigger AS $BODY$
declare

ie_soap_w  varchar(1) := 'N';

BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger	= 'N')  then
	goto Final;
end if;

Select 	coalesce(max('S'),'N')
into STRICT	ie_soap_w
from 	evolucao_paciente_vinculo
where	cd_evolucao = NEW.cd_evolucao
and		ie_tipo_item = 'SOAP';

if (ie_soap_w = 'N') and (OLD.dt_liberacao = NEW.dt_liberacao) and (NEW.dt_liberacao is not null ) and (NEW.dt_inativacao is null) and (coalesce(NEW.nr_atendimento,0) = coalesce(OLD.nr_atendimento,0)) and (coalesce(NEW.nr_seq_formulario,0) = coalesce(OLD.nr_seq_formulario,0)) and (coalesce(NEW.nr_seq_assinatura,0)  = coalesce(OLD.nr_seq_assinatura,0)) and (coalesce(OLD.ie_relev_resumo_alta,'X') = coalesce(NEW.ie_relev_resumo_alta,'X')) and (coalesce(OLD.cd_medico,0) = coalesce(NEW.cd_medico,0))	then
	
	CALL gravar_log_tasy(13580, 	substr(' :new.cd_evolucao '||NEW.cd_evolucao||
							' :new.nr_atendimento '||NEW.nr_atendimento||
							' Usuario: '||OBTER_USUARIO_ATIVO||
							' Perfil: '||OBTER_PERFIL_ATIVO||
							' Funcao: '||OBTER_FUNCAO_ATIVA||
							' :new.qt_caracteres '||NEW.qt_caracteres||
							' :old.qt_caracteres '||OLD.qt_caracteres||
							' Stack: '||dbms_utility.format_call_stack,1,2000), 'TASY');
	
	if (OBTER_FUNCAO_ATIVA in (281,10030)) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(1098265);--Esta nota clinica nao pode ser alterada! Ja existe data de liberacao.
	end if;
	
end if;

<<Final>>
null;

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_evolucao_paciente_atual_lib() FROM PUBLIC;

CREATE TRIGGER evolucao_paciente_atual_lib
	BEFORE UPDATE ON evolucao_paciente FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_evolucao_paciente_atual_lib();

