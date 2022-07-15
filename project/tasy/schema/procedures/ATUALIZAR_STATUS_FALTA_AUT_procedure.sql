-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_status_falta_aut (dt_parametro_p timestamp) AS $body$
DECLARE

 
cd_Agenda_w	bigint;
nr_seq_agenda_w	bigint;

C01 CURSOR FOR 
	SELECT	cd_agenda, 
		nr_sequencia	 
	from	agenda_paciente 
	where	trunc(dt_agenda) 	= trunc(dt_parametro_p) 
	and	coalesce(nr_atendimento::text, '') = '' 
	and	ie_status_agenda not in ('L','C','B','F','II','R','I');


BEGIN 
 
open C01;
loop 
fetch C01 into	 
	cd_Agenda_w, 
	nr_seq_agenda_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	CALL Alterar_status_agenda(cd_agenda_w, nr_seq_agenda_w, 'I', null, wheb_mensagem_pck.get_texto(791599), 'N', 'TASY');
	end;
end loop;
close C01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_status_falta_aut (dt_parametro_p timestamp) FROM PUBLIC;

