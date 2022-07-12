-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS phy_exam_exec_after_insert ON phy_exam_exec_proc CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_phy_exam_exec_after_insert() RETURNS trigger AS $BODY$
declare
	cd_evolucao_w		bigint;
	nr_atendimento_w		bigint;
	dt_exam_exec_w		timestamp;
	ie_cancel_w		varchar(2);
	ds_proc_exame_w		varchar(255);
	ds_proc_dep_w		varchar(255);
	
BEGIN
	if (wheb_usuario_pck.get_ie_executar_trigger	= 'S')  then			
		select	p.nr_atendimento,
			i.dt_exam_exec,
			i.ie_cancel
		into STRICT	nr_atendimento_w,
			dt_exam_exec_w,
			ie_cancel_w
		from	phy_exam_exec_info i,
			prescr_medica p
		where	i.nr_sequencia = NEW.nr_seq_phy_exam_exec_info
		and 	p.nr_prescricao = i.nr_prescricao;

		select  a.ds_proc_exame
		into STRICT	   ds_proc_exame_w
		from    proc_interno a
		where   a.nr_sequencia = NEW.cd_procedure;
		
		if (ie_cancel_w = '0') then
			ds_proc_dep_w := ds_proc_exame_w || ' (Departament)';
		else
			ds_proc_dep_w := ds_proc_exame_w || ' (Departament Canceled)';
		end if;

		cd_evolucao_w := clinical_notes_pck.gerar_soap(nr_atendimento_w, 0, 'PHYSIOLOGY', null, 'P', 1, cd_evolucao_w, null, null, null, dt_exam_exec_w, ds_proc_exame_w, ds_proc_dep_w);
	end if;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_phy_exam_exec_after_insert() FROM PUBLIC;

CREATE TRIGGER phy_exam_exec_after_insert
	AFTER INSERT ON phy_exam_exec_proc FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_phy_exam_exec_after_insert();

