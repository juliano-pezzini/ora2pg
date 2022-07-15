-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_tempo_todos_medicos ( nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


nr_sequencia_w	bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	proc_interno
	where	ie_tipo_util = 'C';



BEGIN

open C01;
loop
fetch C01 into
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	CALL gerar_tempo_medico_proc(nr_sequencia_w, nm_usuario_p, cd_estabelecimento_p);

	end;
end loop;
close C01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_tempo_todos_medicos ( nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

