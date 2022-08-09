-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pep_remover_agenda_list_esp_js ( nr_seq_agecons_p bigint, nm_usuario_p text ) AS $body$
BEGIN
 
if (nr_seq_agecons_p IS NOT NULL AND nr_seq_agecons_p::text <> '') then 
	begin 
	 
	delete from agenda_lista_espera 
	where nr_seq_agecons = nr_seq_agecons_p;
		 
	commit;
	 
	end;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pep_remover_agenda_list_esp_js ( nr_seq_agecons_p bigint, nm_usuario_p text ) FROM PUBLIC;
