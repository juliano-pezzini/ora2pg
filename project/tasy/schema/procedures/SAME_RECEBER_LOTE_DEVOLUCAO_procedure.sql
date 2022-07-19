-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE same_receber_lote_devolucao ( nr_seq_lote_p bigint, cd_pessoa_fisica_p text, ie_forma_controle_p text, nm_usuario_p text, cd_estabelecimento_p text) AS $body$
DECLARE

 
ds_prontuarios_w	varchar(4000);
ds_prontuarios_aux_w	varchar(255);
ie_altera_status_lote_w	varchar(1);
					
C01 CURSOR FOR 
	SELECT nr_sequencia 
	from  same_solic_pront 
	where  ie_status = 'V' 
	and	nr_seq_lote = nr_seq_lote_p 
	and   cd_pessoa_fisica = cd_pessoa_fisica_p;				
 

BEGIN 
open c01;
loop 
fetch c01 into ds_prontuarios_aux_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	 
	ds_prontuarios_w := ds_prontuarios_w || ds_prontuarios_aux_w || ',';
	 
	end;
end loop;
close c01;
 
CALL same_receber_devolucao(ds_prontuarios_w, ie_forma_controle_p, nm_usuario_p, cd_estabelecimento_p);
 
begin 
select 	'N' 
into STRICT	ie_altera_status_lote_w 
from	same_solic_pront 
where	ie_status <> 'D' 
and	nr_seq_lote = nr_seq_lote_p  LIMIT 1;
exception when others then 
	ie_altera_status_lote_w := 'S';
end;
 
if (ie_altera_status_lote_w = 'S') then 
	update	same_solic_pront_lote 
	set	ie_status	= 'D' 
	where	nr_sequencia	= nr_seq_lote_p;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE same_receber_lote_devolucao ( nr_seq_lote_p bigint, cd_pessoa_fisica_p text, ie_forma_controle_p text, nm_usuario_p text, cd_estabelecimento_p text) FROM PUBLIC;

