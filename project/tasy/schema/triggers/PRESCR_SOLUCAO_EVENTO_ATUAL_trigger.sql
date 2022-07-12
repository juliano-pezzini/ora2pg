-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS prescr_solucao_evento_atual ON prescr_solucao_evento CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_prescr_solucao_evento_atual() RETURNS trigger AS $BODY$
BEGIN

if (coalesce(OLD.nr_sequencia,0) = 0) then
	NEW.ds_stack	:= substr(dbms_utility.format_call_stack,1,2000);
end if;	


if (   coalesce(NEW.nr_seq_cpoe, OLD.nr_seq_cpoe) is null
		and coalesce(NEW.ie_tipo_solucao, OLD.ie_tipo_solucao) = 1 ) then
    
    NEW.nr_seq_cpoe	:= obter_nr_seq_cpoe_sol(
				nr_prescricao_p     =>  coalesce(NEW.nr_prescricao, OLD.nr_prescricao),
				nr_seq_solucao_p    =>  coalesce(NEW.nr_seq_solucao, OLD.nr_seq_solucao)
				);
end if;

if ( coalesce(NEW.qt_vol_restante, OLD.qt_vol_restante, 0) < 0 ) then
    NEW.qt_vol_restante    :=  0;
end if;	

RETURN NEW;
END;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_prescr_solucao_evento_atual() FROM PUBLIC;

CREATE TRIGGER prescr_solucao_evento_atual
	BEFORE INSERT OR UPDATE ON prescr_solucao_evento FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_prescr_solucao_evento_atual();
