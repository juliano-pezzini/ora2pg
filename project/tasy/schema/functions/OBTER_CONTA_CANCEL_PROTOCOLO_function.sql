-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_conta_cancel_protocolo ( nr_seq_protocolo_p bigint) RETURNS varchar AS $body$
DECLARE

			 
ie_cancelamento_w 	varchar(1);
ie_retorno_w		varchar(1):= 'N';

C01 CURSOR FOR 
	SELECT	Obter_Se_Conta_Cancelada(nr_interno_Conta) 
	from	conta_paciente 
	where	nr_seq_protocolo = nr_seq_protocolo_p;


BEGIN 
 
open C01;
loop 
fetch C01 into	 
	ie_cancelamento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	if (ie_cancelamento_w = 'S') then 
		ie_retorno_w := 'S';
	end if;
	 
	end;
end loop;
close C01;
 
return	ie_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_conta_cancel_protocolo ( nr_seq_protocolo_p bigint) FROM PUBLIC;
