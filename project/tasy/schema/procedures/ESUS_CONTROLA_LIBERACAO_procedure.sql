-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE esus_controla_liberacao ( nm_tabela_p text, nr_sequencia_p text, nm_usuario_p text, ie_acao_p text) AS $body$
DECLARE


ds_comando_w varchar(255);

BEGIN

if (ie_acao_p = 'L') then
	begin
		ds_comando_w := ' update ' || nm_tabela_p ||
		' set 	dt_liberacao	=  sysdate, ' ||
		'		dt_atualizacao 	=  sysdate, ' ||
		'		nm_usuario = ''' || nm_usuario_p ||
		''' where 	nr_sequencia 	= ' || nr_sequencia_p;
	end;
else
	begin
		ds_comando_w := ' update ' || nm_tabela_p ||
		' set 	dt_liberacao	=  null, ' ||
		'		dt_atualizacao 	=  sysdate, ' ||
		'		nm_usuario = ''' || nm_usuario_p  ||
		''' where 	nr_sequencia 	= ' || nr_sequencia_p;
	end;
end if;


CALL exec_sql_dinamico(nm_usuario_p,ds_comando_w);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE esus_controla_liberacao ( nm_tabela_p text, nr_sequencia_p text, nm_usuario_p text, ie_acao_p text) FROM PUBLIC;

