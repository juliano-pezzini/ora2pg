-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_aceite_termo_respons ( ie_tipo_termo_p wsuite_termo_uso.ie_tipo_termo%type, nr_seq_termo_uso_p wsuite_termo_uso.nr_sequencia%type, nr_seq_usuario_ops_p bigint, nm_usuario_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, ie_commit_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
Gerar o aceite dos termos de uso e aviso de privacidade no Portal Web.
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  ]  Objetos do dicionario [ ] Tasy (Delphi/Java) [ x ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 

nr_sequencia_w		wsuite_termo_uso_leitura.nr_sequencia%type;	


BEGIN

select	nextval('wsuite_termo_uso_leitura_seq')
into STRICT	nr_sequencia_w
;

insert	into wsuite_termo_uso_leitura(
	nr_sequencia,
	dt_confirmacao,
	nr_seq_termo_uso,
	ds_login,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_seq_usuario_ops,
	ds_termo)
values (
	nr_sequencia_w,
	clock_timestamp(),
	nr_seq_termo_uso_p,
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_usuario_ops_p,
	null);
					
					
CALL COPIA_CAMPO_LONG_DE_PARA_NOVO(
	'WSUITE_TERMO_USO',
	'DS_TERMO',
	'WHERE NR_SEQUENCIA = :NR_SEQ_TERMO_USO_P',
	'NR_SEQ_TERMO_USO_P='||nr_seq_termo_uso_p,
	'WSUITE_TERMO_USO_LEITURA',
	'DS_TERMO',
	'WHERE NR_SEQUENCIA = :NR_SEQUENCIA',
	'NR_SEQUENCIA='||nr_sequencia_w,
	'L');	
					

if (ie_commit_p = 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_aceite_termo_respons ( ie_tipo_termo_p wsuite_termo_uso.ie_tipo_termo%type, nr_seq_termo_uso_p wsuite_termo_uso.nr_sequencia%type, nr_seq_usuario_ops_p bigint, nm_usuario_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, ie_commit_p text) FROM PUBLIC;

