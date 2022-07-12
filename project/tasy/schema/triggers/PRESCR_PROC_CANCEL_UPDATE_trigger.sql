-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS prescr_proc_cancel_update ON prescr_proc_cancel CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_prescr_proc_cancel_update() RETURNS trigger AS $BODY$
declare
nr_sequencia_w	bigint;
cd_convenio_w	integer;
BEGIN 
if (NEW.ie_status = 'C') and (OLD.ie_status = 'S') then 
	select	coalesce(min(nr_sequencia),0), 
		coalesce(min(cd_convenio),0) 
	into STRICT	nr_sequencia_w, 
		cd_convenio_w 
	from procedimento_paciente 
	where nr_prescricao = NEW.nr_prescricao 
	 and nr_sequencia_prescricao = NEW.nr_seq_prescr;
	if (nr_sequencia_w > 0) then 
		nr_sequencia_w := Duplicar_Proc_Paciente(nr_sequencia_w, NEW.nm_usuario_confirm, nr_sequencia_w);
		update procedimento_paciente 
		set qt_procedimento = qt_procedimento * -1 
		where nr_sequencia = nr_sequencia_w;
		CALL atualiza_preco_procedimento(nr_sequencia_w, cd_convenio_w, NEW.nm_usuario_confirm);
	end if;
end if;
 
if (NEW.ie_status = 'R') and /* Bruna 03/09/2007 OS 67641 */
 
	(OLD.ie_status = 'S') then 
 
	update 	prescr_procedimento 
	set	ie_suspenso = 'N', 
		nm_usuario_susp  = NULL, 
		dt_suspensao  = NULL 
	where	nr_prescricao = NEW.nr_prescricao 
	and	nr_sequencia = NEW.nr_seq_prescr;
 
end if;
 
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_prescr_proc_cancel_update() FROM PUBLIC;

CREATE TRIGGER prescr_proc_cancel_update
	BEFORE UPDATE ON prescr_proc_cancel FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_prescr_proc_cancel_update();

