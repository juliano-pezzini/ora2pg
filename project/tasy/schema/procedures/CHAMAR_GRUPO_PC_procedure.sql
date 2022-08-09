-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE chamar_grupo_pc ( nr_seq_agenda_int_p bigint, ie_opcao_p text, nm_usuario_p text) AS $body$
DECLARE

 
nr_atendimento_w	bigint;

C01 CURSOR FOR 
	SELECT	a.nr_atendimento 
	from	agenda_consulta a 
	where	a.nr_seq_agend_coletiva in (	SELECT	b.nr_sequencia 
					from	agendamento_coletivo b 
					where	b.nr_seq_agenda_int = nr_seq_agenda_int_p);


BEGIN 
 
open C01;
loop 
fetch C01 into	 
	nr_atendimento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	CALL chamar_paciente_pc(nr_atendimento_w,ie_opcao_p,nm_usuario_p);
	end;
end loop;
close C01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE chamar_grupo_pc ( nr_seq_agenda_int_p bigint, ie_opcao_p text, nm_usuario_p text) FROM PUBLIC;
