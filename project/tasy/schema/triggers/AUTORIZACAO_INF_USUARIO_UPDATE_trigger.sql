-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS autorizacao_inf_usuario_update ON autorizacao_inf_usuario CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_autorizacao_inf_usuario_update() RETURNS trigger AS $BODY$
declare
	ie_valor_p	varchar(1) := 'N';

BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger	= 'S')  then

  ie_valor_p    := substr(OBTER_VALOR_PARAM_USUARIO(0,215,Obter_perfil_Ativo, wheb_usuario_pck.get_nm_usuario, 0),1,1);

  if (ie_valor_p = '1') then
  	update	usuario
  	set		ie_termo_uso  = NULL,
			dt_aceite_termo_uso  = NULL
	where	ie_situacao = 'A'
	and		ie_termo_uso is not null;	
  end	if;
end if;
		

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_autorizacao_inf_usuario_update() FROM PUBLIC;

CREATE TRIGGER autorizacao_inf_usuario_update
	BEFORE INSERT OR UPDATE ON autorizacao_inf_usuario FOR EACH STATEMENT
	EXECUTE PROCEDURE trigger_fct_autorizacao_inf_usuario_update();

