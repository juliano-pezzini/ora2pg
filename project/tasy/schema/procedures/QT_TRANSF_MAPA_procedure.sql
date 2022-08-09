-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE qt_transf_mapa ( nr_seq_local_p bigint, nr_seq_agenda_qui_p bigint, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE

 
dt_Agenda_w		timestamp;
qt_tempo_medic_w	bigint;
nr_seq_prof_w		bigint;
nr_seq_atendimento_w	bigint;
qt_ocup_local_w		bigint;
nr_seq_pend_agenda_w	bigint;
			

BEGIN 
 
select	count(*) 
into STRICT	qt_ocup_local_w 
from	agenda_quimio 
where	ie_status_Agenda	= 'Q' 
and	nr_seq_local		= nr_seq_local_p;
 
select	dt_agenda, 
	nr_minuto_duracao, 
	nr_Seq_prof, 
	nr_seq_atendimento 
into STRICT	dt_Agenda_w, 
	qt_tempo_medic_w, 
	nr_seq_prof_w, 
	nr_seq_atendimento_w 
from	agenda_quimio 
where	nr_sequencia	= nr_seq_agenda_qui_p;
 
select	nr_seq_pend_agenda 
into STRICT	nr_seq_pend_agenda_w 
from	paciente_atendimento 
where	nr_seq_atendimento	= nr_seq_atendimento_w;
 
if (qt_ocup_local_w	= 0) then 
	insert into agenda_quimio_marcacao(nr_sequencia, 
				dt_agenda, 
				nm_usuario, 
				nr_seq_local, 
				nr_duracao, 
				nr_seq_pend_agenda, 
				dt_atualizacao, 
				dt_atualizacao_nrec, 
				nm_usuario_nrec, 
				ie_gerado, 
				ie_transferencia, 
				nr_seq_prof) 
			values (nextval('agenda_quimio_marcacao_seq'), 
				dt_agenda_w, 
				nm_usuario_p, 
				nr_seq_local_p, 
				qt_tempo_medic_w, 
				nr_seq_pend_agenda_w, 
				clock_timestamp(), 
				clock_timestamp(), 
				nm_usuario_p, 
				'N', 
				'S', 
				nr_seq_prof_w);
				 
	CALL Qt_Confirmar_Transf(nr_seq_pend_agenda_w, nm_usuario_p);
else 
	ds_erro_p	:= WHEB_MENSAGEM_PCK.get_texto(277334,null);
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qt_transf_mapa ( nr_seq_local_p bigint, nr_seq_agenda_qui_p bigint, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;
