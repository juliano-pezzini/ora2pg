-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tre_lib_des_pesquisa ( nm_usuario_p text, nr_seq_pesquisa_p bigint, ie_opcao_p text) AS $body$
BEGIN

if (ie_opcao_p = 'LB') then
	begin
	update 	tre_pesquisa
	set 	dt_liberacao = clock_timestamp(),
		nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp()
	where nr_sequencia = nr_seq_pesquisa_p;
	end;

elsif (ie_opcao_p = 'DL') then
	begin
	update 	tre_pesquisa
	set 	dt_liberacao = '',
		nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp()
	where nr_sequencia = nr_seq_pesquisa_p;
	end;

elsif (ie_opcao_p = 'CA') then
	begin
	update 	tre_pesquisa
	set 	dt_cancelamento  = clock_timestamp(),
		nm_usuario_cancelamento = nm_usuario_p
	where 	nr_sequencia  = nr_seq_pesquisa_p;
	end;

elsif (ie_opcao_p = 'DC') then
	begin
	update 	tre_pesquisa
	set 	nm_usuario = nm_usuario_p,
		dt_cancelamento = '',
		dt_atualizacao = clock_timestamp()
	where nr_sequencia = nr_seq_pesquisa_p;
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tre_lib_des_pesquisa ( nm_usuario_p text, nr_seq_pesquisa_p bigint, ie_opcao_p text) FROM PUBLIC;

