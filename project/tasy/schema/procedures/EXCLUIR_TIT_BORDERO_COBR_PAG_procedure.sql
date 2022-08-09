-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_tit_bordero_cobr_pag ( nr_seq_banco_escrit_p bigint, nr_bordero_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_titulo_w	bigint;					
					 
C01 CURSOR FOR 
	SELECT	nr_titulo 
	from	titulo_pagar_bordero_v 
	where	nr_bordero = nr_bordero_p 
	order by 1;
					

BEGIN 
/* Excluir títulos do borderô selecionado */
 
if (nr_seq_banco_escrit_p IS NOT NULL AND nr_seq_banco_escrit_p::text <> '') and (nr_bordero_p IS NOT NULL AND nr_bordero_p::text <> '') then 
	open C01;
	loop 
	fetch C01 into	 
		nr_titulo_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin				 
		delete 
		from	titulo_pagar_escrit 
		where	nr_titulo 	= nr_titulo_w 
		and	nr_seq_escrit	= nr_seq_banco_escrit_p;
		 
		delete 
		from w_titulo_pagar_imposto 
		where nr_titulo = nr_titulo_w 
		and	 nr_seq_escrit	= nr_seq_banco_escrit_p;
		--Exclui o tributo do titulo vinculado no bordero 
		end;
 
	end loop;
	close C01;
	 
	commit;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_tit_bordero_cobr_pag ( nr_seq_banco_escrit_p bigint, nr_bordero_p bigint, nm_usuario_p text) FROM PUBLIC;
