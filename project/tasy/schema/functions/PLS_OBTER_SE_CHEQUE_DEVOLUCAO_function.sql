-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_cheque_devolucao ( nr_seq_segurado_p bigint) RETURNS varchar AS $body$
DECLARE

				 
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: Retorna se é cheque devolvido. 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ x] Objetos do dicionário [ ] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção:Performance. 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
 
cd_pessoa_fisica_w		varchar(10);				
ie_retorno_w			varchar(1)	:= 'N';
nr_seq_pagador_w		bigint;
cd_cgc_w			pls_contrato_pagador.cd_cgc%type;


BEGIN 
begin 
select	nr_seq_pagador 
into STRICT	nr_seq_pagador_w 
from	pls_segurado 
where	nr_sequencia	= nr_seq_segurado_p;
exception 
when others then 
	nr_seq_pagador_w := 0;
end;
 
if (nr_seq_pagador_w <> 0) then 
	select	a.cd_pessoa_fisica, 
		a.cd_cgc 
	into STRICT	cd_pessoa_fisica_w, 
		cd_cgc_w 
	from	pls_contrato_pagador a 
	where	a.nr_sequencia = nr_seq_pagador_w;
	 
	if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then 
		select	CASE WHEN count(1)=0 THEN 'N'  ELSE 'S' END  
		into STRICT	ie_retorno_w 
		from	cheque_cr		a 
		where	a.cd_pessoa_fisica 	= cd_pessoa_fisica_w 
		and	obter_status_cheque(a.nr_seq_cheque) in (3,5,6,7,10)  LIMIT 1;
	end if;
 
	if (cd_cgc_w IS NOT NULL AND cd_cgc_w::text <> '') then 
		select	CASE WHEN count(1)=0 THEN 'N'  ELSE 'S' END  
		into STRICT	ie_retorno_w 
		from	cheque_cr		a 
		where	a.cd_cgc 	= cd_cgc_w 
		and	obter_status_cheque(a.nr_seq_cheque) in (3,5,6,7,10)  LIMIT 1;
	end if;
end if;
 
return	ie_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_cheque_devolucao ( nr_seq_segurado_p bigint) FROM PUBLIC;

