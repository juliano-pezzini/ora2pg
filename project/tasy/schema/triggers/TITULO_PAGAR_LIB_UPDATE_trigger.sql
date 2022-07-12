-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS titulo_pagar_lib_update ON titulo_pagar CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_titulo_pagar_lib_update() RETURNS trigger AS $BODY$
declare

qt_reg_w			smallint;
ie_att_libs_w		varchar(1);
ds_resultado_p		varchar(1);

pragma autonomous_transaction;
BEGIN
if (coalesce(wheb_usuario_pck.get_ie_lote_contabil,'N') = 'N') and (coalesce(wheb_usuario_pck.get_ie_atualizacao_contabil,'N') = 'N') then

	if (wheb_usuario_pck.get_ie_executar_trigger	= 'N')  then
		goto Final;
	end if;	

	ie_att_libs_w := obter_param_usuario(851, 214, obter_perfil_ativo, NEW.nm_usuario, NEW.cd_estabelecimento, ie_att_libs_w);

	if (ie_att_libs_w = 'C') then
		ds_resultado_p := ATUALIZAR_LIB_TITULO_PAGAR(NEW.nr_titulo, NEW.nm_usuario, ds_resultado_p);

		if (ds_resultado_p	= 'S') then
			NEW.dt_liberacao 	:= LOCALTIMESTAMP;
			NEW.nm_usuario_lib 	:= NEW.nm_usuario;
		elsif (ds_resultado_p = 'N') then
			NEW.dt_liberacao 	:= null;
			NEW.nm_usuario_lib 	:= null;
		end if;
	end if;
	
end if;

<<Final>>

commit;

qt_reg_w	:= 0;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_titulo_pagar_lib_update() FROM PUBLIC;

CREATE TRIGGER titulo_pagar_lib_update
	BEFORE UPDATE ON titulo_pagar FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_titulo_pagar_lib_update();

