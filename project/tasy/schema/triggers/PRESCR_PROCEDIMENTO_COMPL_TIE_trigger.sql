-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS prescr_procedimento_compl_tie ON prescr_procedimento_compl CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_prescr_procedimento_compl_tie() RETURNS trigger AS $BODY$
declare

   ds_param_integration_w  varchar(500);
   nm_usuario_w            prescr_procedimento.nm_usuario%type;

BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger    = 'S')  then

   if ( NEW.ie_status_report = 2  ) then

        select max(p.nm_usuario)
        into STRICT nm_usuario_w
                from prescr_procedimento p
                    join cpoe_procedimento   c
                on  c.nr_sequencia           =  p.nr_seq_proc_cpoe
                where     p.nr_seq_proc_compl     = NEW.nr_sequencia
                and get_patient_type(c.nr_atendimento) ='IN';

        if nm_usuario_w = 'ITECH' then

            ds_param_integration_w :=  '{"recordId" : "' || NEW.nr_sequencia|| '"' || '}';
            CALL execute_bifrost_integration(274,ds_param_integration_w);
        end if;
	end if;

end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_prescr_procedimento_compl_tie() FROM PUBLIC;

CREATE TRIGGER prescr_procedimento_compl_tie
	AFTER UPDATE ON prescr_procedimento_compl FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_prescr_procedimento_compl_tie();
