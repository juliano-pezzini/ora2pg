-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplicar_atend_ambulatorial ( nr_sequencia_p text, nm_usuario_p text) AS $body$
DECLARE

			 
 
nr_sequencia_w	bigint;			
			 
C01 CURSOR FOR 
	SELECT	* 
	from	atendimento_ambulatorial 
	where	nr_sequencia	= nr_sequencia_p;
	
	 
c01_w	c01%rowtype;			
 

BEGIN 
 
open C01;
loop 
fetch C01 into	 
	c01_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	select 	nextval('atendimento_ambulatorial_seq') 
	into STRICT	nr_sequencia_w 
	;
 
	insert into atendimento_ambulatorial( 
		nr_sequencia, 
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		dt_atendimento, 
		cd_profissional, 
		nr_seq_tipo_atend, 
		cd_especialidade_medico, 
		nr_atendimento, 
		ie_situacao) 
	values (	nr_sequencia_w, 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		clock_timestamp(), 
		Obter_Pessoa_Fisica_Usuario(nm_usuario_p,'C'), 
		c01_w.nr_seq_tipo_atend, 
		c01_w.cd_especialidade_medico, 
		c01_w.nr_atendimento, 
		'A');
		 
	CALL copia_campo_long_de_para(	'atendimento_ambulatorial', 
					'ds_atendimento', 
					' where nr_sequencia = :nr_sequencia ', 
					'nr_sequencia='||nr_sequencia_p, 
					'atendimento_ambulatorial', 
					'ds_atendimento', 
					' where nr_sequencia = :nr_sequencia', 
					'nr_sequencia='||nr_sequencia_w);		
		 
	end;
end loop;
 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplicar_atend_ambulatorial ( nr_sequencia_p text, nm_usuario_p text) FROM PUBLIC;

