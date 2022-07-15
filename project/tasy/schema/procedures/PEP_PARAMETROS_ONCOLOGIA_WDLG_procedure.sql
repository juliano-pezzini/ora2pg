-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pep_parametros_oncologia_wdlg ( nr_seq_paciente_p bigint, nr_ciclo_inicio_p bigint, nr_ciclo_final_p bigint, nr_seq_atendimento_p bigint, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE

		 
nr_seq_atendimento_w	bigint;
ds_erro_w		varchar(2000);
		
c01 CURSOR FOR 
SELECT nr_seq_atendimento 
from  paciente_atendimento 
where	nr_seq_paciente  = nr_seq_paciente_p 
and   nr_ciclo between nr_ciclo_inicio_p and nr_ciclo_final_p;


BEGIN 
 
open C01;
loop 
fetch C01 into	 
	nr_seq_atendimento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	ds_erro_w := gerar_agend_serv_pac_atend(nr_seq_paciente_p, nr_seq_atendimento_w, nm_usuario_p, ds_erro_w);	
	 
	end;
end loop;
close C01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pep_parametros_oncologia_wdlg ( nr_seq_paciente_p bigint, nr_ciclo_inicio_p bigint, nr_ciclo_final_p bigint, nr_seq_atendimento_p bigint, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;

