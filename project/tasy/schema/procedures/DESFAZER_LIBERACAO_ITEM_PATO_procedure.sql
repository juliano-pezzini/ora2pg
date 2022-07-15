-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE desfazer_liberacao_item_pato (nr_seq_questao_item_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (nr_seq_questao_item_p <> 0) then
	update 	laudo_questao_item
	set 	dt_liberacao  = NULL ,
		dt_atualizacao = clock_timestamp(),
		nm_usuario = nm_usuario_p
	where 	nr_sequencia = nr_seq_questao_item_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE desfazer_liberacao_item_pato (nr_seq_questao_item_p bigint, nm_usuario_p text) FROM PUBLIC;

