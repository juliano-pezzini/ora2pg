-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS codificacao_atendimento_update ON codificacao_atendimento CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_codificacao_atendimento_update() RETURNS trigger AS $BODY$
declare

BEGIN

if (NEW.ie_status = 'AI') then

	CALL gerar_codificacao_atend_log(NEW.nr_sequencia, obter_desc_expressao(890440), NEW.nm_usuario);

elsif (NEW.ie_status = 'PA') then

	CALL gerar_codificacao_atend_log(NEW.nr_sequencia, obter_desc_expressao(889626), NEW.nm_usuario);

elsif (NEW.ie_status = 'AF')  then

	CALL gerar_codificacao_atend_log(NEW.nr_sequencia, obter_desc_expressao(495422), NEW.nm_usuario);

end if;


RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_codificacao_atendimento_update() FROM PUBLIC;

CREATE TRIGGER codificacao_atendimento_update
	BEFORE UPDATE ON codificacao_atendimento FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_codificacao_atendimento_update();
