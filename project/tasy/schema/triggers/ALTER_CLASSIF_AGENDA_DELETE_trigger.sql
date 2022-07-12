-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS alter_classif_agenda_delete ON alteracao_classif_agenda CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_alter_classif_agenda_delete() RETURNS trigger AS $BODY$
DECLARE
PRAGMA AUTONOMOUS_TRANSACTION;
ds_proc_chamada_w varchar(2000);
qt_reg_w bigint;
param_ageint varchar(10);

BEGIN
	if (wheb_usuario_pck.get_ie_executar_trigger	= 'S')  then
		ds_proc_chamada_w := ' BEGIN ';
		ds_proc_chamada_w := ds_proc_chamada_w || ' alterar_classif_agenda ( ';
		ds_proc_chamada_w := ds_proc_chamada_w || 'to_date('''||to_char(LOCALTIMESTAMP,'dd/mm/yyyy hh24:mi:ss')||''',''dd/mm/yyyy hh24:mi:ss'')' || ', ';
		ds_proc_chamada_w := ds_proc_chamada_w || coalesce(OLD.CD_TIPO_AGENDA,0) || ', ';
		ds_proc_chamada_w := ds_proc_chamada_w || coalesce(OLD.CD_AGENDA,0) || ', ';
		ds_proc_chamada_w := ds_proc_chamada_w || coalesce(OLD.NR_TEMPO_ALTERACAO,0) || ', ';
		ds_proc_chamada_w := ds_proc_chamada_w || ''''||OLD.IE_GERAR_HORARIOS || ''', ';
		ds_proc_chamada_w := ds_proc_chamada_w || OLD.CD_ESTABELECIMENTO || ', ';
		ds_proc_chamada_w := ds_proc_chamada_w || ''''||OLD.IE_CLASSIF_NOVA || ''', ';
		ds_proc_chamada_w := ds_proc_chamada_w || coalesce(OLD.NR_SEQ_CLASSIF_NOVA,0)|| ', ';
		ds_proc_chamada_w := ds_proc_chamada_w || '''S''';
		ds_proc_chamada_w := ds_proc_chamada_w || ' ); END; ';

		select coalesce(max(1), 0)
		  into STRICT qt_reg_w
		  from user_scheduler_running_jobs
		  where job_name like 'AGINT_GERA_JOB%';

		IF (qt_reg_w = 0) THEN
			dbms_scheduler.create_job(job_name   => 'ALT_CLAS_AGENDA_D' ||
									  to_char(LOCALTIMESTAMP + interval '3 days'/24/60/60, 'JHH24MISS'),
									  job_type   => 'PLSQL_BLOCK',
									  job_action => ds_proc_chamada_w,
									  enabled    => TRUE,
									  auto_drop  => TRUE);
		END IF;
	end if;
RETURN OLD;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_alter_classif_agenda_delete() FROM PUBLIC;

CREATE TRIGGER alter_classif_agenda_delete
	BEFORE DELETE ON alteracao_classif_agenda FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_alter_classif_agenda_delete();

