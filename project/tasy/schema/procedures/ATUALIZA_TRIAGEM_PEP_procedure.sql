-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_triagem_pep ( nr_atendimento_p bigint, nr_seq_triagem_p bigint) AS $body$
BEGIN
 
	update  atendimento_sinal_vital  
	set   nr_atendimento 	= nr_atendimento_p 
	where  nr_seq_triagem 	= nr_seq_triagem_p;
	 
	update	 ehr_registro 
	set		 nr_atendimento 	= nr_atendimento_p 
	where	 nr_seq_triagem 	= nr_seq_triagem_p;
	 
	update	 escala_earq 
	set		 nr_atendimento 	= nr_atendimento_p 
	where	 nr_seq_triagem 	= nr_seq_triagem_p;
	 
	update 	 paciente_alergia 
	set		 nr_atendimento 	= nr_atendimento_p 
	where	 nr_seq_triagem 	= nr_seq_triagem_p;
 
	update  pe_prescricao  
	set   nr_atendimento		= nr_atendimento_p 
	where  nr_seq_triagem 	= nr_seq_triagem_p;
	 
exception 
	when others then 
	null;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_triagem_pep ( nr_atendimento_p bigint, nr_seq_triagem_p bigint) FROM PUBLIC;

