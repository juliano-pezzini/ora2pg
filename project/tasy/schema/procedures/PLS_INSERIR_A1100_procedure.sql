-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_inserir_a1100 ( ds_conteudo_p text, nm_usuario_p text) AS $body$
BEGIN

insert	into w_scs_importacao(nr_sequencia, dt_atualizacao, nm_usuario,
	 ds_valores)
values (nextval('w_scs_importacao_seq'), clock_timestamp(), nm_usuario_p,
	 ds_conteudo_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_inserir_a1100 ( ds_conteudo_p text, nm_usuario_p text) FROM PUBLIC;
