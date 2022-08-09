-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE same_transf_local_caixa ( nr_seq_caixa_p bigint, nr_seq_local_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

				 
nr_seq_same_w		bigint;	
nr_seq_agrup_w		bigint;			
ie_permite_util_pront_w	varchar(1);				
qt_prontuarios_w	integer;	
nr_seq_caixa_w		bigint;	
		 
				 
C01 CURSOR FOR 
	SELECT	nr_sequencia, 
		nr_seq_agrup 
	from	same_prontuario a 
	where	nr_seq_caixa = nr_seq_caixa_p;	
 
C02 CURSOR FOR 
	SELECT	nr_sequencia 
	from	same_caixa 
	where	nr_seq_caixa_superior = nr_seq_caixa_p;	
	 
C03 CURSOR FOR 
	SELECT	nr_sequencia, 
		nr_seq_agrup 
	from	same_prontuario a 
	where	nr_seq_caixa = nr_seq_caixa_w;	

BEGIN 
open C01;
loop 
fetch C01 into	 
	nr_seq_same_w, 
	nr_seq_agrup_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	CALL Consistir_prontuario_local(nr_seq_same_w,nr_seq_local_p,cd_estabelecimento_p,nm_usuario_p);
	end;
end loop;
close C01;
 
select	max(coalesce(ie_permite_util_pront,'N')) 
into STRICT	ie_permite_util_pront_w 
from	same_local 
where	nr_sequencia = nr_seq_local_p;
 
if (ie_permite_util_pront_w = 'S') then 
	select	count(*) 
	into STRICT	qt_prontuarios_w 
	from	same_prontuario 
	where	nr_seq_caixa = nr_seq_caixa_p;
	 
	if (qt_prontuarios_w > 1) then 
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(215117);
	end if;
 
end if;
 
update	same_caixa 
set	nr_seq_local = nr_seq_local_p 
where	nr_sequencia = nr_seq_caixa_p;
 
open C01;
loop 
fetch C01 into	 
	nr_seq_same_w, 
	nr_seq_agrup_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	CALL Gestao_Prontuario_Same(nr_seq_same_w,nm_usuario_p,'','',nr_seq_local_p,nr_seq_caixa_p,nr_seq_agrup_w,'',9,'','','',cd_estabelecimento_p);
	end;
end loop;
close C01;	
 
/*Altera as caixas que possuem a caixa como superior*/
 
open C02;
loop 
fetch C02 into	 
	nr_seq_caixa_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin 
			 
	open C03;
	loop 
	fetch C03 into	 
		nr_seq_same_w, 
		nr_seq_agrup_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin 
		CALL Consistir_prontuario_local(nr_seq_same_w,nr_seq_local_p,cd_estabelecimento_p,nm_usuario_p);
		end;
	end loop;
	close C03;
	 
	update	same_caixa 
	set	nr_seq_local = nr_seq_local_p 
	where	nr_sequencia = nr_seq_caixa_w;
	 
	open C03;
	loop 
	fetch C03 into	 
		nr_seq_same_w, 
		nr_seq_agrup_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin 
		CALL Gestao_Prontuario_Same(nr_seq_same_w,nm_usuario_p,'','',nr_seq_local_p,nr_seq_caixa_p,nr_seq_agrup_w,'',9,'','','',cd_estabelecimento_p);
		end;
	end loop;
	close C03;
	 
	end;
end loop;
close C02;
 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE same_transf_local_caixa ( nr_seq_caixa_p bigint, nr_seq_local_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
