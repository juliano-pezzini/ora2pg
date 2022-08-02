-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_lib_interface_v90 () AS $body$
BEGIN

begin
insert into interface(CD_INTERFACE, DS_INTERFACE, NM_ARQUIVO_SAIDA, DT_ATUALIZACAO, NM_USUARIO, IE_IMPLANTAR, CD_TIPO_INTERFACE, DS_COMANDO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_TIPO_PTU, IE_IMP_EXP)
values (2833, 'A500 - Notas de Fatura em Intercâmbio 9.0', 'C:', clock_timestamp(), 'wcbernardino', 'N', 'PTU9.0', 'select ds_conteudo from w_ptu_envio_arq where nm_usuario = :nm_usuario_cor order by nr_seq_apres', null, '', '', 'N');
exception
when others then
	null;
end;

begin
insert into interface(CD_INTERFACE, DS_INTERFACE, NM_ARQUIVO_SAIDA, DT_ATUALIZACAO, NM_USUARIO, IE_IMPLANTAR, CD_TIPO_INTERFACE, DS_COMANDO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_TIPO_PTU, IE_IMP_EXP)
values (2836, 'A500 - Notas de Fatura em Intercâmbio 9.0 - UTL_FILE', 'C:', clock_timestamp(), 'wcbernardino', 'N', 'PTU9.0', '', null, '', '', 'N');
exception
when others then
	null;
end;

begin
insert into interface(CD_INTERFACE, DS_INTERFACE, NM_ARQUIVO_SAIDA, DT_ATUALIZACAO, NM_USUARIO, IE_IMPLANTAR, CD_TIPO_INTERFACE, DS_COMANDO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_TIPO_PTU, IE_IMP_EXP)
values (2834, 'A550 - Questionamento da Câmara de Contestação 9.0', 'C:', clock_timestamp(), 'wcbernardino', 'N', 'PTU9.0',
'select	substr(ds_conteudo,1,255) ds_conteudo, substr(ds_conteudo,256,255) ds_conteudo_1, substr(ds_conteudo,511,255) ds_conteudo_2 from w_ptu_envio_arq where	nm_usuario = :nm_usuario_cor order by nr_sequencia',
null, '', '', 'N');
exception
when others then
	null;
end;

begin
insert into interface(CD_INTERFACE, DS_INTERFACE, NM_ARQUIVO_SAIDA, DT_ATUALIZACAO, NM_USUARIO, IE_IMPLANTAR, CD_TIPO_INTERFACE, DS_COMANDO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_TIPO_PTU, IE_IMP_EXP)
values (2835, 'A700 - Serviços prestados em Pré-Pagamento 9.0', 'C:', clock_timestamp(), 'wcbernardino', 'N', 'PTU9.0', 'select ds_conteudo from w_ptu_envio_arq where nm_usuario = :nm_usuario_cor order by nr_seq_apres', null, '', '', 'N');
exception
when others then
	null;
end;

begin
insert into interface(CD_INTERFACE, DS_INTERFACE, NM_ARQUIVO_SAIDA, DT_ATUALIZACAO, NM_USUARIO, IE_IMPLANTAR, CD_TIPO_INTERFACE, DS_COMANDO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, CD_TIPO_PTU, IE_IMP_EXP)
values (2837, 'A1200 - Pacotes e Tabelas Contratualizadas - 9.0', 'C:', clock_timestamp(), 'wcbernardino', 'N', 'PTU9.0',
'select	substr(ds_conteudo,1,255) ds_conteudo, substr(ds_conteudo,256,255) ds_conteudo_1, substr(ds_conteudo,511,255) ds_conteudo_2 from w_ptu_envio_arq where	nm_usuario = :nm_usuario_cor order by nr_seq_apres',
null, '', '', 'N');
exception
when others then
	null;
end;

begin
insert into interface_reg(CD_INTERFACE, CD_REG_INTERFACE, DS_REG_INTERFACE, IE_SEPARADOR_REG, IE_FORMATO_REG, DT_ATUALIZACAO, NM_USUARIO, IE_REGISTRO, IE_TIPO_REGISTRO)
values (2833, 1, 'Conteúdo', 'N', 'V', clock_timestamp(), 'wcbernardino', '1', '');
exception
when others then
	null;
end;

begin
insert into interface_reg(CD_INTERFACE, CD_REG_INTERFACE, DS_REG_INTERFACE, IE_SEPARADOR_REG, IE_FORMATO_REG, DT_ATUALIZACAO, NM_USUARIO, IE_REGISTRO, IE_TIPO_REGISTRO)
values (2834, 1, 'Conteúdo', 'N', 'V', clock_timestamp(), 'wcbernardino', '1', '');
exception
when others then
	null;
end;

begin
insert into interface_reg(CD_INTERFACE, CD_REG_INTERFACE, DS_REG_INTERFACE, IE_SEPARADOR_REG, IE_FORMATO_REG, DT_ATUALIZACAO, NM_USUARIO, IE_REGISTRO, IE_TIPO_REGISTRO)
values (2835, 1, 'Conteúdo', 'N', 'V', clock_timestamp(), 'wcbernardino', '1', '');
exception
when others then
	null;
end;

begin
insert into interface_reg(CD_INTERFACE, CD_REG_INTERFACE, DS_REG_INTERFACE, IE_SEPARADOR_REG, IE_FORMATO_REG, DT_ATUALIZACAO, NM_USUARIO, IE_REGISTRO, IE_TIPO_REGISTRO)
values (2837, 1, 'Conteúdo', 'N', 'V', clock_timestamp(), 'wcbernardino', '1', '');
exception
when others then
	null;
end;

begin
insert into interface_atributo(CD_INTERFACE, CD_REG_INTERFACE, NR_SEQ_ATRIBUTO, NM_TABELA, NM_ATRIBUTO, IE_TIPO_ATRIBUTO, QT_TAMANHO, DT_ATUALIZACAO, NM_USUARIO, QT_DECIMAIS, DS_MASCARA_DATA, DS_VALOR, QT_POSICAO_INICIAL, IE_IMPORTA_TABELA, DS_REGRA_VALIDACAO, IE_IDENTIFICA_ERRO, IE_EXPORTA, IE_TIPO_CAMPO, IE_CONVERSAO, NM_ATRIB_USUARIO)
values (2833, 1, 1, '', 'DS_CONTEUDO', 'VARCHAR2', 1082, clock_timestamp(), 'wcbernardino', null, '', '', null, 'S', '', 'N', 'S', 'N', 'S', '');
exception
when others then
	null;
end;

begin
insert into interface_atributo(CD_INTERFACE, CD_REG_INTERFACE, NR_SEQ_ATRIBUTO, NM_TABELA, NM_ATRIBUTO, IE_TIPO_ATRIBUTO, QT_TAMANHO, DT_ATUALIZACAO, NM_USUARIO, QT_DECIMAIS, DS_MASCARA_DATA, DS_VALOR, QT_POSICAO_INICIAL, IE_IMPORTA_TABELA, DS_REGRA_VALIDACAO, IE_IDENTIFICA_ERRO, IE_EXPORTA, IE_TIPO_CAMPO, IE_CONVERSAO, NM_ATRIB_USUARIO)
values (2834, 1, 1, '', 'DS_CONTEUDO', 'VARCHAR2', 255, clock_timestamp(), 'wcbernardino', null, '', '', null, 'S', '', 'N', 'S', 'N', 'S', '');
exception
when others then
	null;
end;

begin
insert into interface_atributo(CD_INTERFACE, CD_REG_INTERFACE, NR_SEQ_ATRIBUTO, NM_TABELA, NM_ATRIBUTO, IE_TIPO_ATRIBUTO, QT_TAMANHO, DT_ATUALIZACAO, NM_USUARIO, QT_DECIMAIS, DS_MASCARA_DATA, DS_VALOR, QT_POSICAO_INICIAL, IE_IMPORTA_TABELA, DS_REGRA_VALIDACAO, IE_IDENTIFICA_ERRO, IE_EXPORTA, IE_TIPO_CAMPO, IE_CONVERSAO, NM_ATRIB_USUARIO)
values (2834, 1, 2, '', 'DS_CONTEUDO_1', 'VARCHAR2', 255, clock_timestamp(), 'wcbernardino', null, '', '', null, 'S', '', 'N', 'S', 'N', 'S', '');
exception
when others then
	null;
end;

begin
insert into interface_atributo(CD_INTERFACE, CD_REG_INTERFACE, NR_SEQ_ATRIBUTO, NM_TABELA, NM_ATRIBUTO, IE_TIPO_ATRIBUTO, QT_TAMANHO, DT_ATUALIZACAO, NM_USUARIO, QT_DECIMAIS, DS_MASCARA_DATA, DS_VALOR, QT_POSICAO_INICIAL, IE_IMPORTA_TABELA, DS_REGRA_VALIDACAO, IE_IDENTIFICA_ERRO, IE_EXPORTA, IE_TIPO_CAMPO, IE_CONVERSAO, NM_ATRIB_USUARIO)
values (2834, 1, 3, '', 'DS_CONTEUDO_2', 'VARCHAR2', 255, clock_timestamp(), 'wcbernardino', null, '', '', null, 'S', '', 'N', 'S', 'N', 'S', '');
exception
when others then
	null;
end;

begin
insert into interface_atributo(CD_INTERFACE, CD_REG_INTERFACE, NR_SEQ_ATRIBUTO, NM_TABELA, NM_ATRIBUTO, IE_TIPO_ATRIBUTO, QT_TAMANHO, DT_ATUALIZACAO, NM_USUARIO, QT_DECIMAIS, DS_MASCARA_DATA, DS_VALOR, QT_POSICAO_INICIAL, IE_IMPORTA_TABELA, DS_REGRA_VALIDACAO, IE_IDENTIFICA_ERRO, IE_EXPORTA, IE_TIPO_CAMPO, IE_CONVERSAO, NM_ATRIB_USUARIO)
values (2835, 1, 1, '', 'DS_CONTEUDO', 'VARCHAR2', 800, clock_timestamp(), 'wcbernardino', null, '', '', null, 'S', '', 'N', 'S', 'N', 'S', '');
exception
when others then
	null;
end;

begin
insert into interface_atributo(CD_INTERFACE, CD_REG_INTERFACE, NR_SEQ_ATRIBUTO, NM_TABELA, NM_ATRIBUTO, IE_TIPO_ATRIBUTO, QT_TAMANHO, DT_ATUALIZACAO, NM_USUARIO, QT_DECIMAIS, DS_MASCARA_DATA, DS_VALOR, QT_POSICAO_INICIAL, IE_IMPORTA_TABELA, DS_REGRA_VALIDACAO, IE_IDENTIFICA_ERRO, IE_EXPORTA, IE_TIPO_CAMPO, IE_CONVERSAO, NM_ATRIB_USUARIO)
values (2837, 1, 2, '', 'DS_CONTEUDO_1', 'VARCHAR2', 255, clock_timestamp(), 'wcbernardino', null, '', '', null, 'S', '', 'N', 'S', 'N', 'S', '');
exception
when others then
	null;
end;

begin
insert into interface_atributo(CD_INTERFACE, CD_REG_INTERFACE, NR_SEQ_ATRIBUTO, NM_TABELA, NM_ATRIBUTO, IE_TIPO_ATRIBUTO, QT_TAMANHO, DT_ATUALIZACAO, NM_USUARIO, QT_DECIMAIS, DS_MASCARA_DATA, DS_VALOR, QT_POSICAO_INICIAL, IE_IMPORTA_TABELA, DS_REGRA_VALIDACAO, IE_IDENTIFICA_ERRO, IE_EXPORTA, IE_TIPO_CAMPO, IE_CONVERSAO, NM_ATRIB_USUARIO)
values (2837, 1, 3, '', 'DS_CONTEUDO_2', 'VARCHAR2', 255, clock_timestamp(), 'wcbernardino', null, '', '', null, 'S', '', 'N', 'S', 'N', 'S', '');
exception
when others then
	null;
end;

begin
insert into interface_atributo(CD_INTERFACE, CD_REG_INTERFACE, NR_SEQ_ATRIBUTO, NM_TABELA, NM_ATRIBUTO, IE_TIPO_ATRIBUTO, QT_TAMANHO, DT_ATUALIZACAO, NM_USUARIO, QT_DECIMAIS, DS_MASCARA_DATA, DS_VALOR, QT_POSICAO_INICIAL, IE_IMPORTA_TABELA, DS_REGRA_VALIDACAO, IE_IDENTIFICA_ERRO, IE_EXPORTA, IE_TIPO_CAMPO, IE_CONVERSAO, NM_ATRIB_USUARIO)
values (2837, 1, 1, '', 'DS_CONTEUDO', 'VARCHAR2', 255, clock_timestamp(), 'wcbernardino', null, '', '', null, 'S', '', 'N', 'S', 'N', 'S', '');
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
-- REVOKE ALL ON PROCEDURE ptu_lib_interface_v90 () FROM PUBLIC;

