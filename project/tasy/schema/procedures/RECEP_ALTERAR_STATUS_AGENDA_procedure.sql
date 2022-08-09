-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE recep_alterar_status_agenda ( cd_agenda_p bigint, nr_seq_agenda_p bigint, ie_status_p text, cd_motivo_p text, ds_motivo_p text, ie_agenda_dia_p text, nm_usuario_p text) AS $body$
DECLARE

 
qt_agenda_cancelada_w	bigint;					
					 

BEGIN 
 
if (coalesce(nr_seq_agenda_p,0) > 0) then 
 
	select	count(*) 
	into STRICT	qt_agenda_cancelada_w 
	from	agenda_paciente 
	where 	nr_sequencia = nr_seq_agenda_p 
	and 	ie_status_agenda = 'C';
	 
	if (coalesce(qt_agenda_cancelada_w,0) = 0) then 
	 
		CALL Alterar_status_agenda(cd_agenda_p,nr_seq_agenda_p,ie_status_p,cd_motivo_p,ds_motivo_p,ie_agenda_dia_p,nm_usuario_p);
 
		CALL recep_atual_canc_autorizacao(nm_usuario_p,nr_seq_agenda_p);
	end if;
 
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE recep_alterar_status_agenda ( cd_agenda_p bigint, nr_seq_agenda_p bigint, ie_status_p text, cd_motivo_p text, ds_motivo_p text, ie_agenda_dia_p text, nm_usuario_p text) FROM PUBLIC;
