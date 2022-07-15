-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hd_cancelar_dialise_dia () AS $body$
DECLARE

			 
nr_seq_motivo_fim_w	bigint;
nr_seq_dialise_w	bigint;	
ds_erro_w		varchar(255);
ds_retorno_w		varchar(255);
	
C01 CURSOR FOR 
	SELECT	nr_sequencia		 
	from	hd_dialise 
	where	coalesce(dt_inicio_dialise::text, '') = '' 
	and	coalesce(dt_cancelamento::text, '') = '';

BEGIN
select	max(nr_sequencia) 
into STRICT	nr_seq_motivo_fim_w 
from	motivo_fim 
where	ie_motivo_fim = 'H' 
and	ie_situacao = 'A';
 
if (nr_seq_motivo_fim_w IS NOT NULL AND nr_seq_motivo_fim_w::text <> '') then 
 
	open C01;
	loop 
	fetch C01 into	 
		nr_seq_dialise_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		SELECT * FROM HD_Cancelar_Dialise(nr_seq_dialise_w, clock_timestamp(), obter_desc_expressao(777072), nr_seq_motivo_fim_w, 'Tasy', ds_erro_w, ds_retorno_w) INTO STRICT ds_erro_w, ds_retorno_w;
		end;
	end loop;
	close C01;
end if;
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hd_cancelar_dialise_dia () FROM PUBLIC;

