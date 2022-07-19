-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alterar_situacao_lanc_prog ( nr_seq_lancamento_p bigint, ie_opcao_p text, nm_usuario_p text) AS $body$
DECLARE


ds_alteracao_w	varchar(255);


BEGIN

begin
update	pls_segurado_mensalidade
set	ie_situacao	= ie_opcao_p
where	nr_sequencia	= nr_seq_lancamento_p;
exception
when others then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(265872,'');
	--Ocorreu um problema ao alterar a situação do lançamento programado!
end;

if (ie_opcao_p = 'A') then
	ds_alteracao_w	:= 'Lançamento programado ativado pelo usuário';
elsif (ie_opcao_p = 'I') then
	ds_alteracao_w	:= 'Lançamento programado inativado pelo usuário';
end if;

begin
insert	into	pls_mensalidade_prog_log(	nr_sequencia, nr_seq_lanc_prog, nm_usuario_alteracao,
		dt_alteracao, dt_atualizacao, nm_usuario,
		dt_atualizacao_nrec, nm_usuario_nrec, ds_alteracao)
	values (	nextval('pls_mensalidade_prog_log_seq'), nr_seq_lancamento_p, nm_usuario_p,
		clock_timestamp(), clock_timestamp(), nm_usuario_p,
		clock_timestamp(), nm_usuario_p, ds_alteracao_w);
exception
when others then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(265880,'');
	--Ocorreu um problema ao gravar o histórico da alteração do lançamento programado!
end;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alterar_situacao_lanc_prog ( nr_seq_lancamento_p bigint, ie_opcao_p text, nm_usuario_p text) FROM PUBLIC;

