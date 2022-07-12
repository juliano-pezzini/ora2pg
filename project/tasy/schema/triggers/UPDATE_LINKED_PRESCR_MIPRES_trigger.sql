-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS update_linked_prescr_mipres ON prescr_mipres CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_update_linked_prescr_mipres() RETURNS trigger AS $BODY$
declare

ds_alteracao_w	varchar(4000);
ie_alteracao_w	varchar(15);
ds_justificativa_w varchar(4000);

BEGIN
	IF (wheb_usuario_pck.get_ie_executar_trigger = 'S') THEN
		/* Vinculando */

		if (NEW.nr_presc_mipres is not null) and (OLD.nr_presc_mipres is null) then
			NEW.ie_status := '2';
			NEW.dt_vinculo_mipres := LOCALTIMESTAMP;
			ie_alteracao_w := 1;
		/* Desvinculando */

		elsif (OLD.nr_presc_mipres is not null) and (NEW.nr_presc_mipres is null) then
			NEW.ie_status := '1';
			NEW.dt_vinculo_mipres := null;
            ds_justificativa_w := NEW.ds_justificativa;
			ie_alteracao_w := 2;
		end if;

		if (coalesce(NEW.nr_presc_mipres,0) <>  coalesce(OLD.nr_presc_mipres,0)) then
			ds_alteracao_w := obter_desc_expressao(1072400) || '(new): ' || NEW.nr_presc_mipres || '/ '|| obter_desc_expressao(1072400) || '(old): ' || OLD.nr_presc_mipres;
			CALL insert_prescr_mipres_alteracao(NEW.nr_sequencia, ie_alteracao_w, ds_alteracao_w, ds_justificativa_w, 'N');
		end if;	
	end if;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_update_linked_prescr_mipres() FROM PUBLIC;

CREATE TRIGGER update_linked_prescr_mipres
	BEFORE UPDATE ON prescr_mipres FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_update_linked_prescr_mipres();

