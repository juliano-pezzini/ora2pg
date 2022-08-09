-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_valor_evol_pac_agenda (nm_usuario_p text, nr_seq_agenda_p bigint, cd_tipo_agenda_p bigint, cd_evolucao_p bigint, nr_seq_template_p bigint) AS $body$
DECLARE

 
cd_evolucao_w bigint;
nr_seq_template_w bigint;
			

BEGIN 
 
if (cd_tipo_agenda_p IS NOT NULL AND cd_tipo_agenda_p::text <> '') and (cd_tipo_agenda_p > 0) and (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') and (nr_seq_agenda_p > 0) and 
  ((cd_evolucao_p IS NOT NULL AND cd_evolucao_p::text <> '' AND cd_evolucao_p > 0)  or (nr_seq_template_p IS NOT NULL AND nr_seq_template_p::text <> '' AND nr_seq_template_p > 0))  then	 
	 
  if (cd_evolucao_p = 0) then 
    cd_evolucao_w := null;
else 
   cd_evolucao_w := cd_evolucao_p;
end if;	
 
  if (nr_seq_template_p = 0) then 
    nr_seq_template_w := null;
else 
    nr_seq_template_w := nr_seq_template_p;
end if;
	 
  insert into evolucao_paciente_agenda( 
		nr_sequencia, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		cd_evolucao, 
		nr_seq_agenda, 
		cd_tipo_agenda, 
		nr_seq_template) 
	values ( 
		nextval('evolucao_paciente_agenda_seq'), 
		clock_timestamp(), 
		nm_usuario_p, 
		cd_evolucao_w, 
		nr_seq_agenda_p, 
		cd_tipo_agenda_p, 
		nr_seq_template_w);
		 
	commit;
	 
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_valor_evol_pac_agenda (nm_usuario_p text, nr_seq_agenda_p bigint, cd_tipo_agenda_p bigint, cd_evolucao_p bigint, nr_seq_template_p bigint) FROM PUBLIC;
