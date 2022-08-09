-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_permissao_unica ( nr_sequencia_p bigint, nm_usuario_p text, ie_liberar_inativar_p text) AS $body$
BEGIN

/* 	Objeto utilizado na função Cadastro Médico,
	para liberação ou inativação do registro de permissão única do médico (autorizá-lo a realizar atendimento médico na instituição).*/
if (ie_liberar_inativar_p = 'L') then

update 	medico_permissao_unica
set	dt_liberacao = clock_timestamp(),
	nm_usuario_liberacao = nm_usuario_p,
	dt_atualizacao = clock_timestamp(),
	nm_usuario = nm_usuario_p
where 	coalesce(dt_inativacao::text, '') = ''
and	coalesce(dt_liberacao::text, '') = ''
and	nr_sequencia = nr_sequencia_p;

commit;

/*Envio de CI após liberação da permissão única*/

CALL envia_comunic_permissao_unica(nr_sequencia_p, nm_usuario_p);

elsif (ie_liberar_inativar_p = 'I') then

update 	medico_permissao_unica
set	dt_inativacao = clock_timestamp(),
	nm_usuario_inativacao = nm_usuario_p,
	dt_atualizacao = clock_timestamp(),
	nm_usuario = nm_usuario_p
where 	coalesce(dt_inativacao::text, '') = ''
and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
and	nr_sequencia = nr_sequencia_p;

commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_permissao_unica ( nr_sequencia_p bigint, nm_usuario_p text, ie_liberar_inativar_p text) FROM PUBLIC;
