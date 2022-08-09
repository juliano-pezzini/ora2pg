-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_questionario ( nr_seq_modelo_p bigint, nr_seq_evento_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text, nr_seq_questionario_p INOUT bigint) AS $body$
DECLARE


nr_seq_questionario_w		bigint;


BEGIN


select	coalesce(max(nr_sequencia), 0) nr_sequencia
into STRICT	nr_seq_questionario_w
from 	pesquisa_satisfacao
where 	nr_seq_modelo = nr_seq_modelo_p
and 	cd_pessoa_fisica = cd_pessoa_fisica_p
and 	nr_seq_evento = nr_seq_evento_p
and 	coalesce(dt_liberacao::text, '') = '';

if (nr_seq_questionario_w = 0) then
	select	nextval('pesquisa_satisfacao_seq')
	into STRICT	nr_seq_questionario_w
	;

	insert into pesquisa_satisfacao(
		nr_sequencia, dt_atualizacao, dt_atualizacao_nrec,
            	nm_usuario, nm_usuario_nrec, nr_seq_modelo,
            	cd_pessoa_fisica, nr_seq_evento, ie_status)
	values (nr_seq_questionario_w, clock_timestamp(), clock_timestamp(),
		nm_usuario_p, nm_usuario_p, nr_seq_modelo_p,
		cd_pessoa_fisica_p, nr_seq_evento_p, 'E');
end if;

nr_seq_questionario_p := nr_seq_questionario_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_questionario ( nr_seq_modelo_p bigint, nr_seq_evento_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text, nr_seq_questionario_p INOUT bigint) FROM PUBLIC;
