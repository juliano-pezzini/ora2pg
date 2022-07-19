-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_imp_nota_debito_a580 ( ds_conteudo_p text, nr_seq_fat_geral_p ptu_fatura_geral.nr_sequencia%type, nr_seq_referencia_p INOUT bigint, ie_versao_p INOUT text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_regra_tit_fat_p pls_regra_tit_fat_geral.nr_sequencia%type) AS $body$
DECLARE


/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
----------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [X] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ---------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/BEGIN
-- OBTER A VERSÃO DE TRANSAÇÃO
if (coalesce(ie_versao_p::text, '') = '') then
	select	substr(ds_conteudo_p,73,2)
	into STRICT	ie_versao_p
	;
end if;

if	((trim(both substr(ds_conteudo_p,9,2)) is not null) and ((substr(ds_conteudo_p,9,2) <> '58') and (substr(ds_conteudo_p,9,2) <> '99'))) then
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(363434);
end if;

-- VERSÃO PTU 6.3
if (ie_versao_p in ('05')) then
	CALL pls_importar_arquivo_a580_63( ds_conteudo_p, nr_seq_fat_geral_p, cd_estabelecimento_p, nm_usuario_p, nr_seq_regra_tit_fat_p );

-- VERSÃO PTU 8.0
elsif (ie_versao_p in ('06')) then
	CALL pls_importar_arquivo_a580_80( ds_conteudo_p, nr_seq_fat_geral_p, cd_estabelecimento_p, nm_usuario_p, nr_seq_regra_tit_fat_p );

-- VERSÃO PTU 9.1
elsif (ie_versao_p in ('07')) then
	CALL pls_importar_arquivo_a580_91( ds_conteudo_p, nr_seq_fat_geral_p, cd_estabelecimento_p, nm_usuario_p, nr_seq_regra_tit_fat_p );

-- VERSÃO PTU 11.1
elsif (ie_versao_p in ('08')) then
	CALL pls_importar_arquivo_a580_110( ds_conteudo_p, nr_seq_fat_geral_p, cd_estabelecimento_p, nm_usuario_p, nr_seq_regra_tit_fat_p );

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_imp_nota_debito_a580 ( ds_conteudo_p text, nr_seq_fat_geral_p ptu_fatura_geral.nr_sequencia%type, nr_seq_referencia_p INOUT bigint, ie_versao_p INOUT text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_regra_tit_fat_p pls_regra_tit_fat_geral.nr_sequencia%type) FROM PUBLIC;

