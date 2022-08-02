-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alt_contrato_ativo_remido ( nr_seq_contrato_p pls_contrato.nr_sequencia%type, nm_usuario_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
BEGIN

update	pls_contrato
set	ie_exclusivo_benef_remido	= 'N',
	nm_usuario			= nm_usuario_p,
	dt_atualizacao			= clock_timestamp()
where	nr_sequencia			= nr_seq_contrato_p;

insert into pls_contrato_historico(nr_sequencia,
		cd_estabelecimento,
		nr_seq_contrato,
		nm_usuario,
		nm_usuario_nrec,
		dt_atualizacao,
		dt_historico,
		dt_atualizacao_nrec,
		ie_tipo_historico,
		ds_historico,
		ds_observacao)
	values (nextval('pls_contrato_historico_seq'),
		cd_estabelecimento_p,
		nr_seq_contrato_p,
		nm_usuario_p,
		nm_usuario_p,
		clock_timestamp(),
		clock_timestamp(),
		clock_timestamp(),
		'110',
		wheb_mensagem_pck.get_texto(1107832), --Opcao "Ativo somente para beneficiario(s) remido(s)" desmarcada
		null);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alt_contrato_ativo_remido ( nr_seq_contrato_p pls_contrato.nr_sequencia%type, nm_usuario_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;

