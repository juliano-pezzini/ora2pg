-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE aghos_registra_inf_contigencia () AS $body$
DECLARE

 
C01 CURSOR FOR 
	SELECT	nr_sequencia      	, 
		cd_estabelecimento	, 
		dt_atualizacao   	,   
		nm_usuario     	,  
		ie_tipo_integra   	,  
		ie_processado     	, 
		nr_internacao     	, 
		nr_seq_atepacu     	, 
		nr_atendimento     
	from	aghos_registra_inf_trigger 
	where	coalesce(ie_processado, 'N') = 'N' 
	order by ie_tipo_integra,nr_sequencia;
	
c01_w 		c01%ROWTYPE;	

BEGIN 
 
	open C01;
	loop 
	fetch C01 into	 
		c01_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		 
			if (c01_w.ie_tipo_integra = 'A') then 
			 
				CALL Aghos_internacao_solicitacao( c01_w.nr_internacao, c01_w.nr_atendimento, c01_w.nm_usuario, c01_w.cd_estabelecimento, c01_w.nr_sequencia);
 
			elsif (c01_w.ie_tipo_integra = 'U') then 
				 
				CALL Aghos_transferencia_interna( c01_w.nr_atendimento, c01_w.nr_seq_atepacu, c01_w.nm_usuario, c01_w.nr_sequencia);
				 
			end if;
			 
		end;
	end loop;
	close C01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE aghos_registra_inf_contigencia () FROM PUBLIC;
