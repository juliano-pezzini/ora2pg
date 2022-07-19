-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tasy_executar_jobs_versao ( nm_usuario_p text) AS $body$
DECLARE


comando_w				varchar(255);
nr_sequencia_w			bigint;
ie_sucesso_w			varchar(1);
nr_seq_versao_w			bigint;

c01 CURSOR FOR
	SELECT	ds_comando,
			nr_sequencia
	from	tasy_jobs_atualizacao
	where	ie_executado = 'N'
	and		nr_seq_atualizacao = nr_seq_versao_w;


BEGIN

select	max(nr_sequencia)
into STRICT	nr_seq_versao_w
from	atualizacao_versao;


open C01;
loop
fetch C01 into
	comando_w, nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ie_sucesso_w := 'S';
	begin
	EXECUTE ' exec '|| comando_w;
		exception
			when others then
				ie_sucesso_w := 'E';
		end;

	update	tasy_jobs_atualizacao
	set 	ie_executado = ie_sucesso_w
	where	nr_sequencia = nr_sequencia_w;


	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tasy_executar_jobs_versao ( nm_usuario_p text) FROM PUBLIC;

