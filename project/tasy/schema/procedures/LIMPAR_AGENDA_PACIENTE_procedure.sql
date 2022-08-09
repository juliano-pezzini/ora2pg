-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE limpar_agenda_paciente () AS $body$
BEGIN
 
update prescr_medica 
set nr_seq_agenda  = NULL 
where nr_seq_agenda in ( 
	SELECT a.nr_sequencia 
	from agenda_paciente a, agenda b 
	where a.cd_agenda = b.cd_agenda 
	 and qt_dia_historico <> 0 
	 and dt_agenda < clock_timestamp() - interval '1 days' 
	 and dt_agenda < clock_timestamp() - qt_dia_historico);
 
delete from Agenda_paciente 
where nr_sequencia in ( 
	SELECT a.nr_sequencia 
	from agenda_paciente a, agenda b 
	where a.cd_agenda = b.cd_agenda 
	and qt_dia_historico <> 0 
	and dt_agenda < clock_timestamp() - interval '1 days' 
	and dt_agenda < clock_timestamp() - qt_dia_historico 
	/* Francisco - OS 53294 - Não limpar agendas que tenham vinculo com autorização */
 
	and not exists (SELECT	1 
			from	autorizacao_convenio x 
			where	x.nr_seq_agenda	= a.nr_sequencia) 
	and not exists (select	1 
			from	autorizacao_convenio z, 
				autorizacao_cirurgia y 
			where	z.nr_seq_autor_cirurgia = y.nr_sequencia 
			and	y.nr_seq_agenda		= a.nr_sequencia) 
	and not exists (select	1 
			from	AUTOR_CONVENIO_EVENTO x 
			where	x.nr_seq_agenda	= a.nr_sequencia) 
	and not exists (select	1 
			from	AVAL_PRE_ANESTESICA w 
			where	w.nr_seq_agenda = a.nr_sequencia) 
	and not exists (select	1 
			from	med_avaliacao_paciente x 
			where	x.nr_Seq_agenda_pac	= a.nr_sequencia) 
	and not exists (select	1 
			from	agenda_integrada_item x 
			where	x.nr_Seq_agenda_exame	= a.nr_sequencia));
commit;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE limpar_agenda_paciente () FROM PUBLIC;
