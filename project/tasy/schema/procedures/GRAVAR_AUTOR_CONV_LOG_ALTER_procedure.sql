-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_autor_conv_log_alter ( NR_SEQUENCIA_AUTOR_P bigint , DS_TITULO_P text , DS_HISTORICO_P text , NM_USUARIO_P text ) AS $body$
BEGIN

insert into autorizacao_conv_log_alter(
	nr_sequencia,
	ds_titulo,
	ds_historico,
	dt_atualizacao,
	NM_USUARIO,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_seq_autorizacao)
values (	nextval('autorizacao_conv_log_alter_seq'),
	ds_titulo_p,
	substr(ds_historico_p|| chr(13) ||chr(10)||
	' CallStack: '|| chr(13) || chr(10)|| dbms_utility.format_call_stack,1,3980),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	'TASY',
	nr_sequencia_autor_p);

if (coalesce(ds_titulo_p,'') = Wheb_mensagem_pck.get_texto(1044716)) then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_autor_conv_log_alter ( NR_SEQUENCIA_AUTOR_P bigint , DS_TITULO_P text , DS_HISTORICO_P text , NM_USUARIO_P text ) FROM PUBLIC;

