-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE undo_financial_discharge (nr_atendimento_p bigint, nm_usuario_p text, ds_justificativa_p text) AS $body$
DECLARE
 dt_alta_tesouraria_w	timestamp;
BEGIN
 
select	dt_alta_tesouraria 
 
into STRICT	dt_alta_tesouraria_w 
 
from	atendimento_paciente 
 
where	nr_atendimento = nr_atendimento_p;
 
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (dt_alta_tesouraria_w IS NOT NULL AND dt_alta_tesouraria_w::text <> '') then 
 
	update	atendimento_paciente 
 
	set	dt_alta_tesouraria 	 = NULL, 
 
		nm_usuario		= nm_usuario_p, 
		 
		dt_atualizacao		= 	clock_timestamp() 
 
	where	nr_atendimento		= nr_atendimento_p;
 
	 
	CALL Gravar_Hist_Alta_Saida_Real(nr_atendimento_p, obter_desc_expressao(10652294, 'Undo Financial Discharge')|| ' ' || substr(ds_justificativa_p,1,255), clock_timestamp(), nm_usuario_p);
 
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE undo_financial_discharge (nr_atendimento_p bigint, nm_usuario_p text, ds_justificativa_p text) FROM PUBLIC;

