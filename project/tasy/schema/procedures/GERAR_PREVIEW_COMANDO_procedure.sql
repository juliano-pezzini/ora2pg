-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_preview_comando (nr_seq_ajuste_versao_p bigint, nm_usuario_p text) AS $body$
DECLARE

				
qt_registro_w	bigint;
ds_script_w	text;
ds_comando_w	text;
				

C01 CURSOR FOR
	SELECT	ds_comando
	from	ajuste_versao_comando
	where	nr_seq_ajuste_versao = nr_seq_ajuste_versao_p
	order by nr_ordem, nr_sequencia;
	

BEGIN


EXECUTE 'drop table COMANDO_PREVIEW_clob_W';
EXECUTE 'create table COMANDO_PREVIEW_clob_W as select * from tasy.ajuste_versao_comando@whebl02_orcl';
EXECUTE 'insert into AJUSTE_VERSAO_COMANDO select * from COMANDO_PREVIEW_clob_W';
commit;

delete from COMANDO_PREVIEW_W
commit;

select	count(*)
into STRICT	qt_registro_w
from	ajuste_versao_comando a
where	nr_seq_ajuste_versao = nr_seq_ajuste_versao_p;

if (qt_registro_w > 0) then

	open C01;
	loop
	fetch C01 into	
		ds_comando_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin		
		ds_script_w:= ds_script_w||CHR(13)||CHR(10)||ds_comando_w||CHR(13)||CHR(10);
		end;
	end loop;
	close C01;	
	
insert into COMANDO_PREVIEW_W(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				ds_script)
			values (nextval('ajuste_versao_preview_w_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				ds_script_w);
commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_preview_comando (nr_seq_ajuste_versao_p bigint, nm_usuario_p text) FROM PUBLIC;
