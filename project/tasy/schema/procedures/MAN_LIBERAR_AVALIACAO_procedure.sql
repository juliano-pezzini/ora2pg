-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_liberar_avaliacao ( nr_sequencia_p bigint, nm_usuario_p text, ds_pergunta_p INOUT text) AS $body$
BEGIN

update 	man_ordem_serv_avaliacao
set 	nm_usuario = nm_usuario_p,
	dt_liberacao = clock_timestamp()
where 	nr_sequencia = nr_sequencia_p;

commit;

ds_pergunta_p := obter_texto_tasy(183893, wheb_usuario_pck.get_nr_seq_idioma);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_liberar_avaliacao ( nr_sequencia_p bigint, nm_usuario_p text, ds_pergunta_p INOUT text) FROM PUBLIC;

