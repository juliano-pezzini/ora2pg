-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_log_atualizacao_versao ( nr_sequencia_p bigint, ie_evento_p text, ie_status_p text, nr_seq_log_p INOUT bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w			bigint;
ds_module_name_w		varchar(40);
qt_invalidos_w			varchar(10);


BEGIN
/*
I - Inicio Evento
F - Fim Evento

*/
if (ie_status_p = 'I') then

	select nextval('log_atualizacao_seq')
	into STRICT	nr_sequencia_w
	;

	insert into Log_Atualizacao(
		nr_sequencia,
		nr_seq_atualizacao,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ie_evento,
		dt_evento)
	values (
		nr_sequencia_w,
		nr_sequencia_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		ie_evento_p,
		clock_timestamp());

	nr_seq_log_p	:= nr_sequencia_w;
	/*Seta para a sessão no oracle qual a sequencia do log  de atualização
	  Se houver algum erro durante a atualização de versão será tratado para pegar a sequencia do log e
	 registrar na tabela LOG_ATUALIZACAO_ERRO.
	*/
	ds_module_name_w	:= 'CORSIS_FO_NR_SEQ=' || nr_seq_log_p;
	/*dbms_application_info.set_module(ds_module_name_w, nm_usuario_p);*/

	/*wheb_usuario_pck.set_ds_form(ds_module_name_w);*/

else
	select	count(*)
	into STRICT	qt_invalidos_w
	from	objetos_invalidos_v;

	update	log_atualizacao
	set	dt_fim_evento		= clock_timestamp(),
		dt_atualizacao		= clock_timestamp(),
		ds_ocorrencia		= qt_invalidos_w
	where	nr_seq_atualizacao 	= nr_sequencia_p
	and	ie_evento		= ie_evento_p
	and	coalesce(dt_fim_evento::text, '') = '';

	nr_seq_log_p	:= nr_sequencia_p;

end	if;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_log_atualizacao_versao ( nr_sequencia_p bigint, ie_evento_p text, ie_status_p text, nr_seq_log_p INOUT bigint, nm_usuario_p text) FROM PUBLIC;
