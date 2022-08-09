-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_bloqueto_nf_periodo (dt_inicial_p timestamp, dt_final_p timestamp) AS $body$
DECLARE

 
nr_titulo_w	bigint;

c01 CURSOR FOR 
SELECT	b.nr_titulo 
from	titulo_receber b, 
	nota_fiscal a 
where	a.nr_sequencia	= b.nr_seq_nf_saida 
and	a.ie_situacao = 1 
and	coalesce(b.nr_bloqueto::text, '') = '' 
and	a.ie_tipo_nota in ('SD','SE','SF','ST') 
and	a.dt_emissao between trunc(dt_inicial_p) and fim_dia(trunc(dt_final_p)) 
order by 1;
			

BEGIN 
 
open c01;
	loop 
	fetch c01 into	 
		nr_titulo_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	 
	CALL Gerar_Bloqueto_Tit_Rec(nr_titulo_w, 'OPSGF');
     
	Update titulo_receber set 	ie_tipo_titulo = 1, 
					dt_emissao_bloqueto = clock_timestamp() 
	where nr_titulo = nr_titulo_w;
	commit;
	 
	end loop;
close c01;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_bloqueto_nf_periodo (dt_inicial_p timestamp, dt_final_p timestamp) FROM PUBLIC;
