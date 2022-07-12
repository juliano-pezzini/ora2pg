-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_iniciar_analise_pos ( nr_seq_analise_p bigint) RETURNS varchar AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ ] Objetos do dicionário [ ] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção: 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
 
ie_retorno_w			varchar(255)	:= 'S';
ie_status_w			varchar(255);
nr_seq_conta_w			bigint;
nr_seq_analise_pag_w		bigint;
qt_analise_pend_w		bigint	:= 0;

C01 CURSOR FOR 
	SELECT	distinct a.nr_seq_conta 
	from	pls_conta_pos_estabelecido	a 
	where	a.nr_seq_analise	= nr_seq_analise_p 
	and	((a.ie_situacao	= 'A') or (coalesce(a.ie_situacao::text, '') = ''));


BEGIN 
open C01;
loop 
fetch C01 into	 
	nr_seq_conta_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	select	max(a.nr_seq_analise) 
	into STRICT	nr_seq_analise_pag_w 
	from	pls_conta	a 
	where	a.nr_sequencia	= nr_seq_conta_w;
	 
	if (nr_seq_analise_pag_w IS NOT NULL AND nr_seq_analise_pag_w::text <> '') then 
		qt_analise_pend_w	:= qt_analise_pend_w + 1;
		 
		select	max(a.ie_status) 
		into STRICT	ie_status_w 
		from	pls_analise_conta	a 
		where	a.nr_sequencia	= nr_seq_analise_pag_w;
		 
		if (ie_status_w in ('S', 'T')) then 
			qt_analise_pend_w	:= qt_analise_pend_w - 1;
		end if;
	end if;
	end;
end loop;
close C01;
 
if (qt_analise_pend_w > 0) then 
	ie_retorno_w	:= 'N';
end if;
 
return ie_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_iniciar_analise_pos ( nr_seq_analise_p bigint) FROM PUBLIC;

