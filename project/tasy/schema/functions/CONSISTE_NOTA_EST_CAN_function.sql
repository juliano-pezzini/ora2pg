-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION consiste_nota_est_can ( nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

 
ie_cancelamento_w	varchar(5);
nr_interno_conta_w	bigint;
nr_nota_w		varchar(100);
nr_titulo_w		varchar(100);
ie_ok_w			varchar(1);

c01 CURSOR FOR 
	SELECT	nr_interno_conta, 
		ie_cancelamento, 
		substr(obter_nf_conta(nr_interno_conta,2),1,100), 
		substr(obter_titulo_conta_protocolo(0, nr_interno_conta),1,100) 
	from	conta_paciente 
	where	nr_atendimento = nr_atendimento_p 
	and	substr(obter_nf_conta(nr_interno_conta,2),1,100) is not null 
	and	substr(obter_titulo_conta_protocolo(0, nr_interno_conta),1,100) is not null;
			

BEGIN 
 
ie_ok_w := 'S';
 
open C01;
loop 
fetch C01 into	 
	nr_interno_conta_w, 
	ie_cancelamento_w, 
	nr_nota_w, 
	nr_titulo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	if (ie_ok_w = 'S') then 
		if (nr_nota_w IS NOT NULL AND nr_nota_w::text <> '') 
		or (nr_titulo_w IS NOT NULL AND nr_titulo_w::text <> '') then 
			if (coalesce(ie_cancelamento_w::text, '') = '') then 
				ie_ok_w := 'N';
			else	 
				ie_ok_w := 'S';
			end if;
		else 
			ie_ok_w := 'N';
		end if;
	end if;
	 
	end;	
end loop;
close C01;
 
return	ie_ok_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION consiste_nota_est_can ( nr_atendimento_p bigint) FROM PUBLIC;

