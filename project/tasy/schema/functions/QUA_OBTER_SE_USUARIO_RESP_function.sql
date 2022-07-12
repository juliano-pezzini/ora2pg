-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION qua_obter_se_usuario_resp ( cd_pessoa_fisica_p text, cd_funcao_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(1) := 'N';
cd_pessoa_fisisca_w		varchar(10);
nr_seq_modulo_w			bigint;
cd_funcao_w				integer;

-- obter modulos que pessoa é responsável
c01 CURSOR FOR
SELECT	a.nr_sequencia
from	aplicacao_soft_modulo a,
		aplicacao_soft_mod_resp b
where	a.nr_sequencia = b.nr_seq_modulo
and		b.cd_pessoa_fisica = cd_pessoa_fisica_p;

-- obter funções que pessoa física pode efetuar alteração
c02 CURSOR FOR
SELECT	a.cd_funcao
from	aplicacao_soft_modulo b,
		func_mod_software a
where	b.nr_sequencia = a.nr_seq_modulo
and		b.nr_sequencia = nr_seq_modulo_w;


BEGIN
open C01;
loop
fetch C01 into
	nr_seq_modulo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	open C02;
	loop
	fetch C02 into
		cd_funcao_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		if (cd_funcao_w = cd_funcao_p) then
			ds_retorno_w := 'S';
		end if;
		end;
	end loop;
	close C02;
	end;
end loop;
close C01;

return	ds_retorno_w;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION qua_obter_se_usuario_resp ( cd_pessoa_fisica_p text, cd_funcao_p bigint) FROM PUBLIC;
