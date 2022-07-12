-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS smart_item_sae_aftinsert ON pe_prescr_proc CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_smart_item_sae_aftinsert() RETURNS trigger AS $BODY$
declare

reg_integracao_w		gerar_int_padrao.reg_integracao;

BEGIN
reg_integracao_w.cd_estab_documento := OBTER_ESTABELECIMENTO_ATIVO;

	if (OLD.DT_SUSPENSAO is null) and (NEW.DT_SUSPENSAO is not null) then
		BEGIN		
				reg_integracao_w := gerar_int_padrao.gravar_integracao('389', NEW.NR_SEQUENCIA, NEW.nm_usuario, reg_integracao_w, 'DS_OPERACAO_P=SUSPENCAO');
		END;	
	end if;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_smart_item_sae_aftinsert() FROM PUBLIC;

CREATE TRIGGER smart_item_sae_aftinsert
	AFTER INSERT OR UPDATE ON pe_prescr_proc FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_smart_item_sae_aftinsert();

