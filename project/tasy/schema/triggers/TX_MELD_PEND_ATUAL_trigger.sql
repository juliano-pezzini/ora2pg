-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS tx_meld_pend_atual ON tx_meld CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_tx_meld_pend_atual() RETURNS trigger AS $BODY$
declare
 
qt_reg_w		smallint;
ie_tipo_w		varchar(10);
 
BEGIN 
if (wheb_usuario_pck.get_ie_executar_trigger	= 'N') then 
	goto Final;
end if;
 
 
if (NEW.dt_liberacao is null) then 
	ie_tipo_w := 'ESC';
elsif (OLD.dt_liberacao is null) and (NEW.dt_liberacao is not null) then 
	ie_tipo_w := 'XESC';
end if;
 
if (ie_tipo_w	is not null) then 
	CALL Gerar_registro_pendente_PEP(ie_tipo_w, NEW.nr_sequencia, substr(obter_pessoa_atendimento(NEW.nr_atendimento,'C'),1,255), NEW.nr_atendimento, NEW.nm_usuario,null, null, null, null, null, null,'61');
end if;
	 
<<Final>> 
qt_reg_w	:= 0;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_tx_meld_pend_atual() FROM PUBLIC;

CREATE TRIGGER tx_meld_pend_atual
	AFTER INSERT OR UPDATE ON tx_meld FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_tx_meld_pend_atual();

