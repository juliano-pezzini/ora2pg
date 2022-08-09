-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_lib_interface_a550_v70 () AS $body$
BEGIN

begin
insert into INTERFACE(CD_INTERFACE, DS_INTERFACE, NM_ARQUIVO_SAIDA, DT_ATUALIZACAO, NM_USUARIO, IE_IMPLANTAR, CD_TIPO_INTERFACE, DS_COMANDO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_TIPO_PTU, IE_IMP_EXP)
values (2746, 'A550 - Questionamento da Câmara de Contestação 7.0', 'C:\', to_date('04-04-2016 14:15:03', 'dd-mm-yyyy hh24:mi:ss'), 'wcbernardino', 'N', 'PTU7.0', 'select	substr(ds_conteudo,1,255) ds_conteudo,
	substr(ds_conteudo,256,255) ds_conteudo_1,
	substr(ds_conteudo,511,255) ds_conteudo_2
from	w_ptu_envio_arq
where	nm_usuario = :nm_usuario_cor
order by nr_sequencia', null, '', '', '');
exception
when others then
	null;
end;

-- '
begin
insert into INTERFACE_REG(CD_INTERFACE, CD_REG_INTERFACE, DS_REG_INTERFACE, IE_SEPARADOR_REG, IE_FORMATO_REG, DT_ATUALIZACAO, NM_USUARIO, IE_REGISTRO, IE_TIPO_REGISTRO)
values (2746, 1, 'Conteúdo', 'N', 'V', to_date('04-04-2016 14:14:39', 'dd-mm-yyyy hh24:mi:ss'), 'wcbernardino', '1', '');
exception
when others then
	null;
end;

begin
insert into INTERFACE_ATRIBUTO(CD_INTERFACE, CD_REG_INTERFACE, NR_SEQ_ATRIBUTO, NM_TABELA, NM_ATRIBUTO, IE_TIPO_ATRIBUTO, QT_TAMANHO, DT_ATUALIZACAO, NM_USUARIO, QT_DECIMAIS, DS_MASCARA_DATA, DS_VALOR, QT_POSICAO_INICIAL, IE_IMPORTA_TABELA, DS_REGRA_VALIDACAO, IE_IDENTIFICA_ERRO, IE_EXPORTA, IE_TIPO_CAMPO, IE_CONVERSAO, NM_ATRIB_USUARIO)
values (2746, 1, 1, '', 'DS_CONTEUDO', 'VARCHAR2', 255, to_date('04-04-2016 14:14:39', 'dd-mm-yyyy hh24:mi:ss'), 'wcbernardino', null, '', '', null, 'S', '', 'N', 'S', 'N', 'S', '');
exception
when others then
	null;
end;

begin
insert into INTERFACE_ATRIBUTO(CD_INTERFACE, CD_REG_INTERFACE, NR_SEQ_ATRIBUTO, NM_TABELA, NM_ATRIBUTO, IE_TIPO_ATRIBUTO, QT_TAMANHO, DT_ATUALIZACAO, NM_USUARIO, QT_DECIMAIS, DS_MASCARA_DATA, DS_VALOR, QT_POSICAO_INICIAL, IE_IMPORTA_TABELA, DS_REGRA_VALIDACAO, IE_IDENTIFICA_ERRO, IE_EXPORTA, IE_TIPO_CAMPO, IE_CONVERSAO, NM_ATRIB_USUARIO)
values (2746, 1, 2, '', 'DS_CONTEUDO_1', 'VARCHAR2', 255, to_date('04-04-2016 14:14:39', 'dd-mm-yyyy hh24:mi:ss'), 'wcbernardino', null, '', '', null, 'S', '', 'N', 'S', 'N', 'S', '');
exception
when others then
	null;
end;

begin
insert into INTERFACE_ATRIBUTO(CD_INTERFACE, CD_REG_INTERFACE, NR_SEQ_ATRIBUTO, NM_TABELA, NM_ATRIBUTO, IE_TIPO_ATRIBUTO, QT_TAMANHO, DT_ATUALIZACAO, NM_USUARIO, QT_DECIMAIS, DS_MASCARA_DATA, DS_VALOR, QT_POSICAO_INICIAL, IE_IMPORTA_TABELA, DS_REGRA_VALIDACAO, IE_IDENTIFICA_ERRO, IE_EXPORTA, IE_TIPO_CAMPO, IE_CONVERSAO, NM_ATRIB_USUARIO)
values (2746, 1, 3, '', 'DS_CONTEUDO_2', 'VARCHAR2', 255, to_date('04-04-2016 14:14:39', 'dd-mm-yyyy hh24:mi:ss'), 'wcbernardino', null, '', '', null, 'S', '', 'N', 'S', 'N', 'S', '');
exception
when others then
	null;
end;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_lib_interface_a550_v70 () FROM PUBLIC;
