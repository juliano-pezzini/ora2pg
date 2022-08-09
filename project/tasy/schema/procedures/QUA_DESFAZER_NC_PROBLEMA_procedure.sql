-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE qua_desfazer_nc_problema ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_nao_conform_w	bigint;


BEGIN
select	nr_seq_rnc
into STRICT	nr_seq_nao_conform_w
from	qua_analise_problema
where   nr_sequencia    = nr_sequencia_p;

if (coalesce(nr_seq_nao_conform_w,0) > 0) then
	begin
	update	qua_analise_problema
	set	nr_seq_rnc	 = NULL
	where	nr_sequencia	= nr_sequencia_p;

	delete from qua_nao_conformidade
	where nr_sequencia = nr_seq_nao_conform_w;

	exception when others then
		/*(-20011,'Ocorreu um problema ao desvincular a não conformidade' || chr(10) || 	Sqlerrm);*/

		CALL wheb_mensagem_pck.exibir_mensagem_abort(263171,'DS_ERRO=' || Sqlerrm);
	end;

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qua_desfazer_nc_problema ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
