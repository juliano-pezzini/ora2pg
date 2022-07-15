-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_protocolo_guia_inf () AS $body$
BEGIN

delete from INTEGRIDADE_ATRIBUTO where nm_tabela = 'PROTOCOLO_GUIA_INF';
delete from INTEGRIDADE_REFERENCIAL where nm_tabela = 'PROTOCOLO_GUIA_INF';
delete from INDICE_ATRIBUTO where nm_tabela = 'PROTOCOLO_GUIA_INF';
delete from INDICE where nm_tabela = 'PROTOCOLO_GUIA_INF';

INSERT INTO INDICE(NM_TABELA, NM_INDICE, IE_TIPO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE, IE_CRIAR_ALTERAR, IE_SITUACAO, DT_CRIACAO, IE_IGNORADO_CLIENTE, IE_CLASSIFICACAO, DS_MENSAGEM) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PK', 'PK',  TO_Date('07/15/2019 01:57:43', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', 'Chave primária', 'M', 'A',  TO_Date('07/15/2019 01:57:43', 'MM/DD/YYYY HH:MI:SS'), NULL, 'IR', NULL);
INSERT INTO INDICE(NM_TABELA, NM_INDICE, IE_TIPO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE, IE_CRIAR_ALTERAR, IE_SITUACAO, DT_CRIACAO, IE_IGNORADO_CLIENTE, IE_CLASSIFICACAO, DS_MENSAGEM) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROTOCO_FK_I', 'I',  TO_Date('07/15/2019 02:12:01', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', ' ', 'I', 'A',  TO_Date('07/15/2019 02:12:01', 'MM/DD/YYYY HH:MI:SS'), NULL, 'IR', NULL);
INSERT INTO INDICE(NM_TABELA, NM_INDICE, IE_TIPO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE, IE_CRIAR_ALTERAR, IE_SITUACAO, DT_CRIACAO, IE_IGNORADO_CLIENTE, IE_CLASSIFICACAO, DS_MENSAGEM) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMEDL_FK_I', 'I',  TO_Date('07/15/2019 02:17:08', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', ' ', 'I', 'A',  TO_Date('07/15/2019 02:17:08', 'MM/DD/YYYY HH:MI:SS'), NULL, 'IR', NULL);
INSERT INTO INDICE(NM_TABELA, NM_INDICE, IE_TIPO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE, IE_CRIAR_ALTERAR, IE_SITUACAO, DT_CRIACAO, IE_IGNORADO_CLIENTE, IE_CLASSIFICACAO, DS_MENSAGEM) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PRSOBCS_FK_I', 'I',  TO_Date('07/15/2019 02:20:10', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', ' ', 'I', 'A',  TO_Date('07/15/2019 02:20:10', 'MM/DD/YYYY HH:MI:SS'), NULL, 'IR', NULL);
INSERT INTO INDICE(NM_TABELA, NM_INDICE, IE_TIPO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE, IE_CRIAR_ALTERAR, IE_SITUACAO, DT_CRIACAO, IE_IGNORADO_CLIENTE, IE_CLASSIFICACAO, DS_MENSAGEM) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PRMEJEJ_FK_I', 'I',  TO_Date('08/27/2019 04:11:44', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', ' ', 'I', 'A',  TO_Date('08/27/2019 04:11:44', 'MM/DD/YYYY HH:MI:SS'), NULL, 'IR', NULL);
INSERT INTO INDICE(NM_TABELA, NM_INDICE, IE_TIPO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE, IE_CRIAR_ALTERAR, IE_SITUACAO, DT_CRIACAO, IE_IGNORADO_CLIENTE, IE_CLASSIFICACAO, DS_MENSAGEM) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PRMENPT_FK_I', 'I',  TO_Date('08/27/2019 04:13:58', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', ' ', 'I', 'A',  TO_Date('08/27/2019 04:13:58', 'MM/DD/YYYY HH:MI:SS'), NULL, 'IR', NULL);
INSERT INTO INDICE(NM_TABELA, NM_INDICE, IE_TIPO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE, IE_CRIAR_ALTERAR, IE_SITUACAO, DT_CRIACAO, IE_IGNORADO_CLIENTE, IE_CLASSIFICACAO, DS_MENSAGEM) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROHDPR_FK_I', 'I',  TO_Date('07/15/2019 02:24:09', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', ' ', 'I', 'A',  TO_Date('07/15/2019 02:24:09', 'MM/DD/YYYY HH:MI:SS'), NULL, 'IR', NULL);
INSERT INTO INDICE(NM_TABELA, NM_INDICE, IE_TIPO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE, IE_CRIAR_ALTERAR, IE_SITUACAO, DT_CRIACAO, IE_IGNORADO_CLIENTE, IE_CLASSIFICACAO, DS_MENSAGEM) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PRMEGAS_FK_I', 'I',  TO_Date('07/15/2019 02:24:46', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', ' ', 'I', 'A',  TO_Date('07/15/2019 02:24:46', 'MM/DD/YYYY HH:MI:SS'), NULL, 'IR', NULL);
INSERT INTO INDICE(NM_TABELA, NM_INDICE, IE_TIPO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE, IE_CRIAR_ALTERAR, IE_SITUACAO, DT_CRIACAO, IE_IGNORADO_CLIENTE, IE_CLASSIFICACAO, DS_MENSAGEM) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_TIPPROT_FK_I', 'I',  TO_Date('07/15/2019 03:33:10', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', ' ', 'I', 'A',  TO_Date('07/15/2019 03:33:10', 'MM/DD/YYYY HH:MI:SS'), NULL, 'IR', NULL);
INSERT INTO INDICE(NM_TABELA, NM_INDICE, IE_TIPO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE, IE_CRIAR_ALTERAR, IE_SITUACAO, DT_CRIACAO, IE_IGNORADO_CLIENTE, IE_CLASSIFICACAO, DS_MENSAGEM) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMEDI_FK_I', 'I',  TO_Date('08/27/2019 04:14:40', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', ' ', 'I', 'A',  TO_Date('08/27/2019 04:14:40', 'MM/DD/YYYY HH:MI:SS'), NULL, 'IR', NULL);
INSERT INTO INDICE(NM_TABELA, NM_INDICE, IE_TIPO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE, IE_CRIAR_ALTERAR, IE_SITUACAO, DT_CRIACAO, IE_IGNORADO_CLIENTE, IE_CLASSIFICACAO, DS_MENSAGEM) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMEDT_FK_I', 'I',  TO_Date('08/27/2019 04:15:20', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', ' ', 'I', 'A',  TO_Date('08/27/2019 04:15:20', 'MM/DD/YYYY HH:MI:SS'), NULL, 'IR', NULL);
INSERT INTO INDICE(NM_TABELA, NM_INDICE, IE_TIPO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE, IE_CRIAR_ALTERAR, IE_SITUACAO, DT_CRIACAO, IE_IGNORADO_CLIENTE, IE_CLASSIFICACAO, DS_MENSAGEM) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMEMA_FK_I', 'I',  TO_Date('08/27/2019 04:15:56', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', ' ', 'I', 'A',  TO_Date('08/27/2019 04:15:56', 'MM/DD/YYYY HH:MI:SS'), NULL, 'IR', NULL);
INSERT INTO INDICE(NM_TABELA, NM_INDICE, IE_TIPO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE, IE_CRIAR_ALTERAR, IE_SITUACAO, DT_CRIACAO, IE_IGNORADO_CLIENTE, IE_CLASSIFICACAO, DS_MENSAGEM) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMEPR_FK_I', 'I',  TO_Date('08/27/2019 04:16:32', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', ' ', 'I', 'A',  TO_Date('08/27/2019 04:16:32', 'MM/DD/YYYY HH:MI:SS'), NULL, 'IR', NULL);
INSERT INTO INDICE(NM_TABELA, NM_INDICE, IE_TIPO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE, IE_CRIAR_ALTERAR, IE_SITUACAO, DT_CRIACAO, IE_IGNORADO_CLIENTE, IE_CLASSIFICACAO, DS_MENSAGEM) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMERE_FK_I', 'I',  TO_Date('08/27/2019 04:17:08', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', ' ', 'I', 'A',  TO_Date('08/27/2019 04:17:08', 'MM/DD/YYYY HH:MI:SS'), NULL, 'IR', NULL);
INSERT INTO INDICE(NM_TABELA, NM_INDICE, IE_TIPO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE, IE_CRIAR_ALTERAR, IE_SITUACAO, DT_CRIACAO, IE_IGNORADO_CLIENTE, IE_CLASSIFICACAO, DS_MENSAGEM) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMESO_FK_I', 'I',  TO_Date('08/27/2019 04:17:54', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', ' ', 'I', 'A',  TO_Date('08/27/2019 04:17:54', 'MM/DD/YYYY HH:MI:SS'), NULL, 'IR', NULL);

INSERT INTO INDICE_ATRIBUTO(NM_TABELA, NM_INDICE, NR_SEQUENCIA, NM_ATRIBUTO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE_FUNCTION) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PK', 1, 'NR_SEQUENCIA',  TO_Date('07/15/2019 01:57:44', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);
INSERT INTO INDICE_ATRIBUTO(NM_TABELA, NM_INDICE, NR_SEQUENCIA, NM_ATRIBUTO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE_FUNCTION) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMEDT_FK_I', 3, 'NR_SEQ_DIETA',  TO_Date('08/27/2019 04:15:26', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);
INSERT INTO INDICE_ATRIBUTO(NM_TABELA, NM_INDICE, NR_SEQUENCIA, NM_ATRIBUTO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE_FUNCTION) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PRMEGAS_FK_I', 1, 'NR_SEQ_GAS',  TO_Date('07/15/2019 02:24:47', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);
INSERT INTO INDICE_ATRIBUTO(NM_TABELA, NM_INDICE, NR_SEQUENCIA, NM_ATRIBUTO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE_FUNCTION) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROHDPR_FK_I', 1, 'NR_SEQ_HD',  TO_Date('07/15/2019 02:24:10', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);
INSERT INTO INDICE_ATRIBUTO(NM_TABELA, NM_INDICE, NR_SEQUENCIA, NM_ATRIBUTO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE_FUNCTION) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PRMEJEJ_FK_I', 3, 'NR_SEQ_JEJUM',  TO_Date('08/27/2019 04:11:49', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);
INSERT INTO INDICE_ATRIBUTO(NM_TABELA, NM_INDICE, NR_SEQUENCIA, NM_ATRIBUTO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE_FUNCTION) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMEDL_FK_I', 1, 'NR_SEQ_LEITE',  TO_Date('07/15/2019 02:17:09', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);
INSERT INTO INDICE_ATRIBUTO(NM_TABELA, NM_INDICE, NR_SEQUENCIA, NM_ATRIBUTO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE_FUNCTION) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMEMA_FK_I', 3, 'NR_SEQ_MATERIAL',  TO_Date('08/27/2019 04:16:00', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);
INSERT INTO INDICE_ATRIBUTO(NM_TABELA, NM_INDICE, NR_SEQUENCIA, NM_ATRIBUTO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE_FUNCTION) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PRMENPT_FK_I', 3, 'NR_SEQ_NPT',  TO_Date('08/27/2019 04:14:03', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);
INSERT INTO INDICE_ATRIBUTO(NM_TABELA, NM_INDICE, NR_SEQUENCIA, NM_ATRIBUTO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE_FUNCTION) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMEPR_FK_I', 3, 'NR_SEQ_PROCEDIMENTO',  TO_Date('08/27/2019 04:16:37', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);
INSERT INTO INDICE_ATRIBUTO(NM_TABELA, NM_INDICE, NR_SEQUENCIA, NM_ATRIBUTO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE_FUNCTION) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROTOCO_FK_I', 1, 'NR_SEQ_PROTOCOLO',  TO_Date('07/15/2019 02:12:03', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);
INSERT INTO INDICE_ATRIBUTO(NM_TABELA, NM_INDICE, NR_SEQUENCIA, NM_ATRIBUTO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE_FUNCTION) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PRMEJEJ_FK_I', 1, 'NR_SEQ_PROTOCOLO',  TO_Date('08/27/2019 04:11:46', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);
INSERT INTO INDICE_ATRIBUTO(NM_TABELA, NM_INDICE, NR_SEQUENCIA, NM_ATRIBUTO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE_FUNCTION) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PRMENPT_FK_I', 1, 'NR_SEQ_PROTOCOLO',  TO_Date('08/27/2019 04:14:00', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);
INSERT INTO INDICE_ATRIBUTO(NM_TABELA, NM_INDICE, NR_SEQUENCIA, NM_ATRIBUTO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE_FUNCTION) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMEDI_FK_I', 1, 'NR_SEQ_PROTOCOLO',  TO_Date('08/27/2019 04:14:42', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);
INSERT INTO INDICE_ATRIBUTO(NM_TABELA, NM_INDICE, NR_SEQUENCIA, NM_ATRIBUTO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE_FUNCTION) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMEDT_FK_I', 1, 'NR_SEQ_PROTOCOLO',  TO_Date('08/27/2019 04:15:22', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);
INSERT INTO INDICE_ATRIBUTO(NM_TABELA, NM_INDICE, NR_SEQUENCIA, NM_ATRIBUTO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE_FUNCTION) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMEMA_FK_I', 1, 'NR_SEQ_PROTOCOLO',  TO_Date('08/27/2019 04:15:56', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);
INSERT INTO INDICE_ATRIBUTO(NM_TABELA, NM_INDICE, NR_SEQUENCIA, NM_ATRIBUTO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE_FUNCTION) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMEPR_FK_I', 1, 'NR_SEQ_PROTOCOLO',  TO_Date('08/27/2019 04:16:34', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);
INSERT INTO INDICE_ATRIBUTO(NM_TABELA, NM_INDICE, NR_SEQUENCIA, NM_ATRIBUTO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE_FUNCTION) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMERE_FK_I', 1, 'NR_SEQ_PROTOCOLO',  TO_Date('08/27/2019 04:17:10', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);
INSERT INTO INDICE_ATRIBUTO(NM_TABELA, NM_INDICE, NR_SEQUENCIA, NM_ATRIBUTO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE_FUNCTION) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMESO_FK_I', 1, 'NR_SEQ_PROTOCOLO',  TO_Date('08/27/2019 04:17:56', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);
INSERT INTO INDICE_ATRIBUTO(NM_TABELA, NM_INDICE, NR_SEQUENCIA, NM_ATRIBUTO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE_FUNCTION) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PRMEJEJ_FK_I', 2, 'NR_SEQ_PROTOCOLO_MEDIC',  TO_Date('09/20/2019 02:58:05', 'MM/DD/YYYY HH:MI:SS'), 'madacosta', NULL);
INSERT INTO INDICE_ATRIBUTO(NM_TABELA, NM_INDICE, NR_SEQUENCIA, NM_ATRIBUTO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE_FUNCTION) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PRMENPT_FK_I', 2, 'NR_SEQ_PROTOCOLO_MEDIC',  TO_Date('09/20/2019 02:58:28', 'MM/DD/YYYY HH:MI:SS'), 'madacosta', NULL);
INSERT INTO INDICE_ATRIBUTO(NM_TABELA, NM_INDICE, NR_SEQUENCIA, NM_ATRIBUTO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE_FUNCTION) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMEDI_FK_I', 2, 'NR_SEQ_PROTOCOLO_MEDIC',  TO_Date('08/27/2019 04:14:43', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);
INSERT INTO INDICE_ATRIBUTO(NM_TABELA, NM_INDICE, NR_SEQUENCIA, NM_ATRIBUTO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE_FUNCTION) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMEDT_FK_I', 2, 'NR_SEQ_PROTOCOLO_MEDIC',  TO_Date('09/20/2019 02:58:51', 'MM/DD/YYYY HH:MI:SS'), 'madacosta', NULL);
INSERT INTO INDICE_ATRIBUTO(NM_TABELA, NM_INDICE, NR_SEQUENCIA, NM_ATRIBUTO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE_FUNCTION) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMEMA_FK_I', 2, 'NR_SEQ_PROTOCOLO_MEDIC',  TO_Date('09/20/2019 02:59:27', 'MM/DD/YYYY HH:MI:SS'), 'madacosta', NULL);
INSERT INTO INDICE_ATRIBUTO(NM_TABELA, NM_INDICE, NR_SEQUENCIA, NM_ATRIBUTO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE_FUNCTION) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMEPR_FK_I', 2, 'NR_SEQ_PROTOCOLO_MEDIC',  TO_Date('09/20/2019 02:59:42', 'MM/DD/YYYY HH:MI:SS'), 'madacosta', NULL);
INSERT INTO INDICE_ATRIBUTO(NM_TABELA, NM_INDICE, NR_SEQUENCIA, NM_ATRIBUTO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE_FUNCTION) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMERE_FK_I', 2, 'NR_SEQ_PROTOCOLO_MEDIC',  TO_Date('09/20/2019 03:00:00', 'MM/DD/YYYY HH:MI:SS'), 'madacosta', NULL);
INSERT INTO INDICE_ATRIBUTO(NM_TABELA, NM_INDICE, NR_SEQUENCIA, NM_ATRIBUTO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE_FUNCTION) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMESO_FK_I', 2, 'NR_SEQ_PROTOCOLO_MEDIC',  TO_Date('09/20/2019 03:00:16', 'MM/DD/YYYY HH:MI:SS'), 'madacosta', NULL);
INSERT INTO INDICE_ATRIBUTO(NM_TABELA, NM_INDICE, NR_SEQUENCIA, NM_ATRIBUTO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE_FUNCTION) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMERE_FK_I', 3, 'NR_SEQ_RECOMENDACAO',  TO_Date('08/27/2019 04:17:13', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);
INSERT INTO INDICE_ATRIBUTO(NM_TABELA, NM_INDICE, NR_SEQUENCIA, NM_ATRIBUTO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE_FUNCTION) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PRSOBCS_FK_I', 1, 'NR_SEQ_SANGUE',  TO_Date('07/15/2019 02:20:11', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);
INSERT INTO INDICE_ATRIBUTO(NM_TABELA, NM_INDICE, NR_SEQUENCIA, NM_ATRIBUTO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE_FUNCTION) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMESO_FK_I', 3, 'NR_SEQ_SOLUCAO',  TO_Date('08/27/2019 04:17:59', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);
INSERT INTO INDICE_ATRIBUTO(NM_TABELA, NM_INDICE, NR_SEQUENCIA, NM_ATRIBUTO, DT_ATUALIZACAO, NM_USUARIO, DS_INDICE_FUNCTION) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_TIPPROT_FK_I', 1, 'NR_SEQ_TIPO_PROT',  TO_Date('07/15/2019 03:33:11', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);

INSERT INTO INTEGRIDADE_REFERENCIAL(NM_TABELA, NM_INTEGRIDADE_REFERENCIAL, NM_TABELA_REFERENCIA, DT_ATUALIZACAO, NM_USUARIO, IE_REGRA_DELECAO, DS_INTEGRIDADE_REFERENCIAL, IE_CRIAR_ALTERAR, IE_SITUACAO, DT_CRIACAO) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROTOCO_FK', 'PROTOCOLO',  TO_Date('07/15/2019 02:11:15', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', 'NO ACTION', NULL, 'I', 'A',  TO_Date('07/15/2019 02:10:40', 'MM/DD/YYYY HH:MI:SS'));
INSERT INTO INTEGRIDADE_REFERENCIAL(NM_TABELA, NM_INTEGRIDADE_REFERENCIAL, NM_TABELA_REFERENCIA, DT_ATUALIZACAO, NM_USUARIO, IE_REGRA_DELECAO, DS_INTEGRIDADE_REFERENCIAL, IE_CRIAR_ALTERAR, IE_SITUACAO, DT_CRIACAO) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMEDI_FK', 'PROTOCOLO_MEDICACAO',  TO_Date('08/26/2019 01:40:23', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', 'CASCADE', NULL, 'I', 'A',  TO_Date('07/15/2019 02:12:09', 'MM/DD/YYYY HH:MI:SS'));
INSERT INTO INTEGRIDADE_REFERENCIAL(NM_TABELA, NM_INTEGRIDADE_REFERENCIAL, NM_TABELA_REFERENCIA, DT_ATUALIZACAO, NM_USUARIO, IE_REGRA_DELECAO, DS_INTEGRIDADE_REFERENCIAL, IE_CRIAR_ALTERAR, IE_SITUACAO, DT_CRIACAO) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMESO_FK', 'PROTOCOLO_MEDIC_SOLUCAO',  TO_Date('08/26/2019 01:40:34', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', 'CASCADE', NULL, 'I', 'A',  TO_Date('07/15/2019 02:13:03', 'MM/DD/YYYY HH:MI:SS'));
INSERT INTO INTEGRIDADE_REFERENCIAL(NM_TABELA, NM_INTEGRIDADE_REFERENCIAL, NM_TABELA_REFERENCIA, DT_ATUALIZACAO, NM_USUARIO, IE_REGRA_DELECAO, DS_INTEGRIDADE_REFERENCIAL, IE_CRIAR_ALTERAR, IE_SITUACAO, DT_CRIACAO) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PRMENPT_FK', 'PROTOCOLO_MEDIC_NPT',  TO_Date('08/26/2019 01:40:58', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', 'CASCADE', NULL, 'I', 'A',  TO_Date('07/15/2019 02:13:38', 'MM/DD/YYYY HH:MI:SS'));
INSERT INTO INTEGRIDADE_REFERENCIAL(NM_TABELA, NM_INTEGRIDADE_REFERENCIAL, NM_TABELA_REFERENCIA, DT_ATUALIZACAO, NM_USUARIO, IE_REGRA_DELECAO, DS_INTEGRIDADE_REFERENCIAL, IE_CRIAR_ALTERAR, IE_SITUACAO, DT_CRIACAO) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMEDL_FK', 'PROTOCOLO_MEDIC_LEITE',  TO_Date('08/26/2019 01:49:34', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', 'CASCADE', NULL, 'I', 'A',  TO_Date('07/15/2019 02:15:47', 'MM/DD/YYYY HH:MI:SS'));
INSERT INTO INTEGRIDADE_REFERENCIAL(NM_TABELA, NM_INTEGRIDADE_REFERENCIAL, NM_TABELA_REFERENCIA, DT_ATUALIZACAO, NM_USUARIO, IE_REGRA_DELECAO, DS_INTEGRIDADE_REFERENCIAL, IE_CRIAR_ALTERAR, IE_SITUACAO, DT_CRIACAO) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMEDT_FK', 'PROTOCOLO_MEDIC_DIETA',  TO_Date('08/26/2019 01:50:10', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', 'CASCADE', NULL, 'I', 'A',  TO_Date('07/15/2019 02:17:37', 'MM/DD/YYYY HH:MI:SS'));
INSERT INTO INTEGRIDADE_REFERENCIAL(NM_TABELA, NM_INTEGRIDADE_REFERENCIAL, NM_TABELA_REFERENCIA, DT_ATUALIZACAO, NM_USUARIO, IE_REGRA_DELECAO, DS_INTEGRIDADE_REFERENCIAL, IE_CRIAR_ALTERAR, IE_SITUACAO, DT_CRIACAO) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PRMEJEJ_FK', 'PROTOCOLO_MEDIC_JEJUM',  TO_Date('08/26/2019 01:50:19', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', 'CASCADE', NULL, 'I', 'A',  TO_Date('07/15/2019 02:18:15', 'MM/DD/YYYY HH:MI:SS'));
INSERT INTO INTEGRIDADE_REFERENCIAL(NM_TABELA, NM_INTEGRIDADE_REFERENCIAL, NM_TABELA_REFERENCIA, DT_ATUALIZACAO, NM_USUARIO, IE_REGRA_DELECAO, DS_INTEGRIDADE_REFERENCIAL, IE_CRIAR_ALTERAR, IE_SITUACAO, DT_CRIACAO) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PRSOBCS_FK', 'PROT_SOLIC_BCO_SANGUE',  TO_Date('08/26/2019 01:50:28', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', 'CASCADE', NULL, 'I', 'A',  TO_Date('07/15/2019 02:19:00', 'MM/DD/YYYY HH:MI:SS'));
INSERT INTO INTEGRIDADE_REFERENCIAL(NM_TABELA, NM_INTEGRIDADE_REFERENCIAL, NM_TABELA_REFERENCIA, DT_ATUALIZACAO, NM_USUARIO, IE_REGRA_DELECAO, DS_INTEGRIDADE_REFERENCIAL, IE_CRIAR_ALTERAR, IE_SITUACAO, DT_CRIACAO) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMEPR_FK', 'PROTOCOLO_MEDIC_PROC',  TO_Date('08/26/2019 01:50:37', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', 'CASCADE', NULL, 'I', 'A',  TO_Date('07/15/2019 02:21:09', 'MM/DD/YYYY HH:MI:SS'));
INSERT INTO INTEGRIDADE_REFERENCIAL(NM_TABELA, NM_INTEGRIDADE_REFERENCIAL, NM_TABELA_REFERENCIA, DT_ATUALIZACAO, NM_USUARIO, IE_REGRA_DELECAO, DS_INTEGRIDADE_REFERENCIAL, IE_CRIAR_ALTERAR, IE_SITUACAO, DT_CRIACAO) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMEMA_FK', 'PROTOCOLO_MEDIC_MATERIAL',  TO_Date('08/26/2019 01:50:45', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', 'CASCADE', NULL, 'I', 'A',  TO_Date('07/15/2019 02:22:14', 'MM/DD/YYYY HH:MI:SS'));
INSERT INTO INTEGRIDADE_REFERENCIAL(NM_TABELA, NM_INTEGRIDADE_REFERENCIAL, NM_TABELA_REFERENCIA, DT_ATUALIZACAO, NM_USUARIO, IE_REGRA_DELECAO, DS_INTEGRIDADE_REFERENCIAL, IE_CRIAR_ALTERAR, IE_SITUACAO, DT_CRIACAO) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMERE_FK', 'PROTOCOLO_MEDIC_REC',  TO_Date('08/26/2019 01:50:54', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', 'CASCADE', NULL, 'I', 'A',  TO_Date('07/15/2019 02:23:11', 'MM/DD/YYYY HH:MI:SS'));
INSERT INTO INTEGRIDADE_REFERENCIAL(NM_TABELA, NM_INTEGRIDADE_REFERENCIAL, NM_TABELA_REFERENCIA, DT_ATUALIZACAO, NM_USUARIO, IE_REGRA_DELECAO, DS_INTEGRIDADE_REFERENCIAL, IE_CRIAR_ALTERAR, IE_SITUACAO, DT_CRIACAO) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROHDPR_FK', 'PROTOCOLO_HD_PRESCRICAO',  TO_Date('08/26/2019 01:51:16', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', 'CASCADE', NULL, 'I', 'A',  TO_Date('07/15/2019 02:23:46', 'MM/DD/YYYY HH:MI:SS'));
INSERT INTO INTEGRIDADE_REFERENCIAL(NM_TABELA, NM_INTEGRIDADE_REFERENCIAL, NM_TABELA_REFERENCIA, DT_ATUALIZACAO, NM_USUARIO, IE_REGRA_DELECAO, DS_INTEGRIDADE_REFERENCIAL, IE_CRIAR_ALTERAR, IE_SITUACAO, DT_CRIACAO) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PRMEGAS_FK', 'PROTOCOLO_MEDIC_GAS',  TO_Date('08/26/2019 01:51:24', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', 'CASCADE', NULL, 'I', 'A',  TO_Date('07/15/2019 02:24:21', 'MM/DD/YYYY HH:MI:SS'));
INSERT INTO INTEGRIDADE_REFERENCIAL(NM_TABELA, NM_INTEGRIDADE_REFERENCIAL, NM_TABELA_REFERENCIA, DT_ATUALIZACAO, NM_USUARIO, IE_REGRA_DELECAO, DS_INTEGRIDADE_REFERENCIAL, IE_CRIAR_ALTERAR, IE_SITUACAO, DT_CRIACAO) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_TIPPROT_FK', 'TIPO_PROTOCOLO',  TO_Date('07/15/2019 03:32:56', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', 'NO ACTION', NULL, 'I', 'A',  TO_Date('07/15/2019 03:32:39', 'MM/DD/YYYY HH:MI:SS'));

INSERT INTO INTEGRIDADE_ATRIBUTO(NM_TABELA, NM_INTEGRIDADE_REFERENCIAL, NM_ATRIBUTO, IE_SEQUENCIA_CRIACAO, DT_ATUALIZACAO, NM_USUARIO, NM_ATRIBUTO_REF) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PRMEGAS_FK', 'NR_SEQ_GAS', 1,  TO_Date('07/15/2019 02:24:43', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);
INSERT INTO INTEGRIDADE_ATRIBUTO(NM_TABELA, NM_INTEGRIDADE_REFERENCIAL, NM_ATRIBUTO, IE_SEQUENCIA_CRIACAO, DT_ATUALIZACAO, NM_USUARIO, NM_ATRIBUTO_REF) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PRMEJEJ_FK', 'NR_SEQ_PROTOCOLO', 1,  TO_Date('08/26/2019 02:46:39', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);
INSERT INTO INTEGRIDADE_ATRIBUTO(NM_TABELA, NM_INTEGRIDADE_REFERENCIAL, NM_ATRIBUTO, IE_SEQUENCIA_CRIACAO, DT_ATUALIZACAO, NM_USUARIO, NM_ATRIBUTO_REF) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PRMEJEJ_FK', 'NR_SEQ_PROTOCOLO_MEDIC', 2,  TO_Date('09/06/2019 01:19:08', 'MM/DD/YYYY HH:MI:SS'), 'madacosta', NULL);
INSERT INTO INTEGRIDADE_ATRIBUTO(NM_TABELA, NM_INTEGRIDADE_REFERENCIAL, NM_ATRIBUTO, IE_SEQUENCIA_CRIACAO, DT_ATUALIZACAO, NM_USUARIO, NM_ATRIBUTO_REF) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PRMEJEJ_FK', 'NR_SEQ_JEJUM', 3,  TO_Date('08/26/2019 01:28:50', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);
INSERT INTO INTEGRIDADE_ATRIBUTO(NM_TABELA, NM_INTEGRIDADE_REFERENCIAL, NM_ATRIBUTO, IE_SEQUENCIA_CRIACAO, DT_ATUALIZACAO, NM_USUARIO, NM_ATRIBUTO_REF) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PRMENPT_FK', 'NR_SEQ_PROTOCOLO', 1,  TO_Date('08/26/2019 02:46:30', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);
INSERT INTO INTEGRIDADE_ATRIBUTO(NM_TABELA, NM_INTEGRIDADE_REFERENCIAL, NM_ATRIBUTO, IE_SEQUENCIA_CRIACAO, DT_ATUALIZACAO, NM_USUARIO, NM_ATRIBUTO_REF) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PRMENPT_FK', 'NR_SEQ_PROTOCOLO_MEDIC', 2,  TO_Date('09/06/2019 01:19:41', 'MM/DD/YYYY HH:MI:SS'), 'madacosta', NULL);
INSERT INTO INTEGRIDADE_ATRIBUTO(NM_TABELA, NM_INTEGRIDADE_REFERENCIAL, NM_ATRIBUTO, IE_SEQUENCIA_CRIACAO, DT_ATUALIZACAO, NM_USUARIO, NM_ATRIBUTO_REF) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PRMENPT_FK', 'NR_SEQ_NPT', 3,  TO_Date('08/26/2019 01:41:04', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);
INSERT INTO INTEGRIDADE_ATRIBUTO(NM_TABELA, NM_INTEGRIDADE_REFERENCIAL, NM_ATRIBUTO, IE_SEQUENCIA_CRIACAO, DT_ATUALIZACAO, NM_USUARIO, NM_ATRIBUTO_REF) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROHDPR_FK', 'NR_SEQ_HD', 1,  TO_Date('07/15/2019 02:24:07', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);
INSERT INTO INTEGRIDADE_ATRIBUTO(NM_TABELA, NM_INTEGRIDADE_REFERENCIAL, NM_ATRIBUTO, IE_SEQUENCIA_CRIACAO, DT_ATUALIZACAO, NM_USUARIO, NM_ATRIBUTO_REF) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMEDI_FK', 'NR_SEQ_PROTOCOLO', 1,  TO_Date('08/26/2019 02:46:17', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);
INSERT INTO INTEGRIDADE_ATRIBUTO(NM_TABELA, NM_INTEGRIDADE_REFERENCIAL, NM_ATRIBUTO, IE_SEQUENCIA_CRIACAO, DT_ATUALIZACAO, NM_USUARIO, NM_ATRIBUTO_REF) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMEDI_FK', 'NR_SEQ_PROTOCOLO_MEDIC', 2,  TO_Date('08/26/2019 01:59:04', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);
INSERT INTO INTEGRIDADE_ATRIBUTO(NM_TABELA, NM_INTEGRIDADE_REFERENCIAL, NM_ATRIBUTO, IE_SEQUENCIA_CRIACAO, DT_ATUALIZACAO, NM_USUARIO, NM_ATRIBUTO_REF) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMEDL_FK', 'NR_SEQ_LEITE', 1,  TO_Date('07/15/2019 02:17:05', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);
INSERT INTO INTEGRIDADE_ATRIBUTO(NM_TABELA, NM_INTEGRIDADE_REFERENCIAL, NM_ATRIBUTO, IE_SEQUENCIA_CRIACAO, DT_ATUALIZACAO, NM_USUARIO, NM_ATRIBUTO_REF) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMEDT_FK', 'NR_SEQ_PROTOCOLO', 1,  TO_Date('08/26/2019 02:45:56', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);
INSERT INTO INTEGRIDADE_ATRIBUTO(NM_TABELA, NM_INTEGRIDADE_REFERENCIAL, NM_ATRIBUTO, IE_SEQUENCIA_CRIACAO, DT_ATUALIZACAO, NM_USUARIO, NM_ATRIBUTO_REF) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMEDT_FK', 'NR_SEQ_PROTOCOLO_MEDIC', 2,  TO_Date('09/06/2019 01:20:05', 'MM/DD/YYYY HH:MI:SS'), 'madacosta', NULL);
INSERT INTO INTEGRIDADE_ATRIBUTO(NM_TABELA, NM_INTEGRIDADE_REFERENCIAL, NM_ATRIBUTO, IE_SEQUENCIA_CRIACAO, DT_ATUALIZACAO, NM_USUARIO, NM_ATRIBUTO_REF) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMEDT_FK', 'NR_SEQ_DIETA', 3,  TO_Date('08/26/2019 01:32:37', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);
INSERT INTO INTEGRIDADE_ATRIBUTO(NM_TABELA, NM_INTEGRIDADE_REFERENCIAL, NM_ATRIBUTO, IE_SEQUENCIA_CRIACAO, DT_ATUALIZACAO, NM_USUARIO, NM_ATRIBUTO_REF) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMEMA_FK', 'NR_SEQ_PROTOCOLO', 1,  TO_Date('08/26/2019 02:45:46', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);
INSERT INTO INTEGRIDADE_ATRIBUTO(NM_TABELA, NM_INTEGRIDADE_REFERENCIAL, NM_ATRIBUTO, IE_SEQUENCIA_CRIACAO, DT_ATUALIZACAO, NM_USUARIO, NM_ATRIBUTO_REF) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMEMA_FK', 'NR_SEQ_PROTOCOLO_MEDIC', 2,  TO_Date('09/06/2019 01:20:17', 'MM/DD/YYYY HH:MI:SS'), 'madacosta', NULL);
INSERT INTO INTEGRIDADE_ATRIBUTO(NM_TABELA, NM_INTEGRIDADE_REFERENCIAL, NM_ATRIBUTO, IE_SEQUENCIA_CRIACAO, DT_ATUALIZACAO, NM_USUARIO, NM_ATRIBUTO_REF) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMEMA_FK', 'NR_SEQ_MATERIAL', 3,  TO_Date('08/26/2019 01:36:25', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);
INSERT INTO INTEGRIDADE_ATRIBUTO(NM_TABELA, NM_INTEGRIDADE_REFERENCIAL, NM_ATRIBUTO, IE_SEQUENCIA_CRIACAO, DT_ATUALIZACAO, NM_USUARIO, NM_ATRIBUTO_REF) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMEPR_FK', 'NR_SEQ_PROTOCOLO', 1,  TO_Date('08/26/2019 02:45:18', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);
INSERT INTO INTEGRIDADE_ATRIBUTO(NM_TABELA, NM_INTEGRIDADE_REFERENCIAL, NM_ATRIBUTO, IE_SEQUENCIA_CRIACAO, DT_ATUALIZACAO, NM_USUARIO, NM_ATRIBUTO_REF) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMEPR_FK', 'NR_SEQ_PROTOCOLO_MEDIC', 2,  TO_Date('09/06/2019 01:16:15', 'MM/DD/YYYY HH:MI:SS'), 'madacosta', NULL);
INSERT INTO INTEGRIDADE_ATRIBUTO(NM_TABELA, NM_INTEGRIDADE_REFERENCIAL, NM_ATRIBUTO, IE_SEQUENCIA_CRIACAO, DT_ATUALIZACAO, NM_USUARIO, NM_ATRIBUTO_REF) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMEPR_FK', 'NR_SEQ_PROCEDIMENTO', 3,  TO_Date('08/26/2019 01:59:57', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);
INSERT INTO INTEGRIDADE_ATRIBUTO(NM_TABELA, NM_INTEGRIDADE_REFERENCIAL, NM_ATRIBUTO, IE_SEQUENCIA_CRIACAO, DT_ATUALIZACAO, NM_USUARIO, NM_ATRIBUTO_REF) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMERE_FK', 'NR_SEQ_PROTOCOLO', 1,  TO_Date('08/26/2019 02:45:04', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);
INSERT INTO INTEGRIDADE_ATRIBUTO(NM_TABELA, NM_INTEGRIDADE_REFERENCIAL, NM_ATRIBUTO, IE_SEQUENCIA_CRIACAO, DT_ATUALIZACAO, NM_USUARIO, NM_ATRIBUTO_REF) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMERE_FK', 'NR_SEQ_PROTOCOLO_MEDIC', 2,  TO_Date('09/06/2019 01:20:31', 'MM/DD/YYYY HH:MI:SS'), 'madacosta', NULL);
INSERT INTO INTEGRIDADE_ATRIBUTO(NM_TABELA, NM_INTEGRIDADE_REFERENCIAL, NM_ATRIBUTO, IE_SEQUENCIA_CRIACAO, DT_ATUALIZACAO, NM_USUARIO, NM_ATRIBUTO_REF) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMERE_FK', 'NR_SEQ_RECOMENDACAO', 3,  TO_Date('08/26/2019 02:01:09', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);
INSERT INTO INTEGRIDADE_ATRIBUTO(NM_TABELA, NM_INTEGRIDADE_REFERENCIAL, NM_ATRIBUTO, IE_SEQUENCIA_CRIACAO, DT_ATUALIZACAO, NM_USUARIO, NM_ATRIBUTO_REF) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMESO_FK', 'NR_SEQ_PROTOCOLO', 1,  TO_Date('08/26/2019 02:44:53', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);
INSERT INTO INTEGRIDADE_ATRIBUTO(NM_TABELA, NM_INTEGRIDADE_REFERENCIAL, NM_ATRIBUTO, IE_SEQUENCIA_CRIACAO, DT_ATUALIZACAO, NM_USUARIO, NM_ATRIBUTO_REF) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMESO_FK', 'NR_SEQ_PROTOCOLO_MEDIC', 2,  TO_Date('09/06/2019 01:20:54', 'MM/DD/YYYY HH:MI:SS'), 'madacosta', NULL);
INSERT INTO INTEGRIDADE_ATRIBUTO(NM_TABELA, NM_INTEGRIDADE_REFERENCIAL, NM_ATRIBUTO, IE_SEQUENCIA_CRIACAO, DT_ATUALIZACAO, NM_USUARIO, NM_ATRIBUTO_REF) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROMESO_FK', 'NR_SEQ_SOLUCAO', 3,  TO_Date('08/26/2019 01:31:23', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);
INSERT INTO INTEGRIDADE_ATRIBUTO(NM_TABELA, NM_INTEGRIDADE_REFERENCIAL, NM_ATRIBUTO, IE_SEQUENCIA_CRIACAO, DT_ATUALIZACAO, NM_USUARIO, NM_ATRIBUTO_REF) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PROTOCO_FK', 'NR_SEQ_PROTOCOLO', 1,  TO_Date('07/15/2019 02:12:00', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);
INSERT INTO INTEGRIDADE_ATRIBUTO(NM_TABELA, NM_INTEGRIDADE_REFERENCIAL, NM_ATRIBUTO, IE_SEQUENCIA_CRIACAO, DT_ATUALIZACAO, NM_USUARIO, NM_ATRIBUTO_REF) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_PRSOBCS_FK', 'NR_SEQ_SANGUE', 1,  TO_Date('07/15/2019 02:20:08', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);
INSERT INTO INTEGRIDADE_ATRIBUTO(NM_TABELA, NM_INTEGRIDADE_REFERENCIAL, NM_ATRIBUTO, IE_SEQUENCIA_CRIACAO, DT_ATUALIZACAO, NM_USUARIO, NM_ATRIBUTO_REF) VALUES ('PROTOCOLO_GUIA_INF', 'PROTCINF_TIPPROT_FK', 'NR_SEQ_TIPO_PROT', 1,  TO_Date('07/15/2019 03:33:08', 'MM/DD/YYYY HH:MI:SS'), 'ncachoeira', NULL);

commit;

CALL exec_sql_dinamico('TASY', 'Drop Index PROTCINF_PROTOCO_FK_I');
CALL exec_sql_dinamico('TASY', 'Drop Index PROTCINF_PROMEDL_FK_I');
CALL exec_sql_dinamico('TASY', 'Drop Index PROTCINF_PRSOBCS_FK_I');
CALL exec_sql_dinamico('TASY', 'Drop Index PROTCINF_PRMEJEJ_FK_I');
CALL exec_sql_dinamico('TASY', 'Drop Index PROTCINF_PRMENPT_FK_I');
CALL exec_sql_dinamico('TASY', 'Drop Index PROTCINF_PROHDPR_FK_I');
CALL exec_sql_dinamico('TASY', 'Drop Index PROTCINF_PRMEGAS_FK_I');
CALL exec_sql_dinamico('TASY', 'Drop Index PROTCINF_TIPPROT_FK_I');
CALL exec_sql_dinamico('TASY', 'Drop Index PROTCINF_PROMEDI_FK_I');
CALL exec_sql_dinamico('TASY', 'Drop Index PROTCINF_PROMEDT_FK_I');
CALL exec_sql_dinamico('TASY', 'Drop Index PROTCINF_PROMEMA_FK_I');
CALL exec_sql_dinamico('TASY', 'Drop Index PROTCINF_PROMEPR_FK_I');
CALL exec_sql_dinamico('TASY', 'Drop Index PROTCINF_PROMERE_FK_I');
CALL exec_sql_dinamico('TASY', 'Drop Index PROTCINF_PROMESO_FK_I');

CALL exec_sql_dinamico('TASY', 'Alter Table PROTOCOLO_GUIA_INF drop constraint PROTCINF_PROTOCO_FK');
CALL exec_sql_dinamico('TASY', 'Alter Table PROTOCOLO_GUIA_INF drop constraint PROTCINF_PROMEDI_FK');
CALL exec_sql_dinamico('TASY', 'Alter Table PROTOCOLO_GUIA_INF drop constraint PROTCINF_PROMESO_FK');
CALL exec_sql_dinamico('TASY', 'Alter Table PROTOCOLO_GUIA_INF drop constraint PROTCINF_PRMENPT_FK');
CALL exec_sql_dinamico('TASY', 'Alter Table PROTOCOLO_GUIA_INF drop constraint PROTCINF_PROMEDL_FK');
CALL exec_sql_dinamico('TASY', 'Alter Table PROTOCOLO_GUIA_INF drop constraint PROTCINF_PROMEDT_FK');
CALL exec_sql_dinamico('TASY', 'Alter Table PROTOCOLO_GUIA_INF drop constraint PROTCINF_PRMEJEJ_FK');
CALL exec_sql_dinamico('TASY', 'Alter Table PROTOCOLO_GUIA_INF drop constraint PROTCINF_PRSOBCS_FK');
CALL exec_sql_dinamico('TASY', 'Alter Table PROTOCOLO_GUIA_INF drop constraint PROTCINF_PROMEPR_FK');
CALL exec_sql_dinamico('TASY', 'Alter Table PROTOCOLO_GUIA_INF drop constraint PROTCINF_PROMEMA_FK');
CALL exec_sql_dinamico('TASY', 'Alter Table PROTOCOLO_GUIA_INF drop constraint PROTCINF_PROMERE_FK');
CALL exec_sql_dinamico('TASY', 'Alter Table PROTOCOLO_GUIA_INF drop constraint PROTCINF_PROHDPR_FK');
CALL exec_sql_dinamico('TASY', 'Alter Table PROTOCOLO_GUIA_INF drop constraint PROTCINF_PRMEGAS_FK');
CALL exec_sql_dinamico('TASY', 'Alter Table PROTOCOLO_GUIA_INF drop constraint PROTCINF_TIPPROT_FK');

CALL exec_sql_dinamico('TASY', 'Alter Table PROTOCOLO_GUIA_INF add (Constraint PROTCINF_PROTOCO_FK Foreign Key (NR_SEQ_PROTOCOLO) References PROTOCOLO (CD_PROTOCOLO))');
CALL exec_sql_dinamico('TASY', 'Alter Table PROTOCOLO_GUIA_INF add (Constraint PROTCINF_PROMEDI_FK Foreign Key (NR_SEQ_PROTOCOLO,NR_SEQ_PROTOCOLO_MEDIC) References PROTOCOLO_MEDICACAO (CD_PROTOCOLO,NR_SEQUENCIA) on delete cascade)');
CALL exec_sql_dinamico('TASY', 'Alter Table PROTOCOLO_GUIA_INF add (Constraint PROTCINF_PROMESO_FK Foreign Key (NR_SEQ_PROTOCOLO,NR_SEQ_PROTOCOLO_MEDIC,NR_SEQ_SOLUCAO) References PROTOCOLO_MEDIC_SOLUCAO (CD_PROTOCOLO,NR_SEQUENCIA,NR_SEQ_SOLUCAO) on delete cascade)');
CALL exec_sql_dinamico('TASY', 'Alter Table PROTOCOLO_GUIA_INF add (Constraint PROTCINF_PRMENPT_FK Foreign Key (NR_SEQ_PROTOCOLO,NR_SEQ_PROTOCOLO_MEDIC,NR_SEQ_NPT) References PROTOCOLO_MEDIC_NPT (CD_PROTOCOLO,NR_SEQUENCIA,NR_SEQ_NPT) on delete cascade)');
CALL exec_sql_dinamico('TASY', 'Alter Table PROTOCOLO_GUIA_INF add (Constraint PROTCINF_PROMEDL_FK Foreign Key (NR_SEQ_LEITE) References PROTOCOLO_MEDIC_LEITE (NR_SEQUENCIA) on delete cascade)');
CALL exec_sql_dinamico('TASY', 'Alter Table PROTOCOLO_GUIA_INF add (Constraint PROTCINF_PROMEDT_FK Foreign Key (NR_SEQ_PROTOCOLO,NR_SEQ_PROTOCOLO_MEDIC,NR_SEQ_DIETA) References PROTOCOLO_MEDIC_DIETA (CD_PROTOCOLO,NR_SEQUENCIA,NR_SEQ_DIETA) on delete cascade)');
CALL exec_sql_dinamico('TASY', 'Alter Table PROTOCOLO_GUIA_INF add (Constraint PROTCINF_PRMEJEJ_FK Foreign Key (NR_SEQ_PROTOCOLO,NR_SEQ_PROTOCOLO_MEDIC,NR_SEQ_JEJUM) References PROTOCOLO_MEDIC_JEJUM (CD_PROTOCOLO,NR_SEQUENCIA,NR_SEQ_JEJUM) on delete cascade)');
CALL exec_sql_dinamico('TASY', 'Alter Table PROTOCOLO_GUIA_INF add (Constraint PROTCINF_PRSOBCS_FK Foreign Key (NR_SEQ_SANGUE) References PROT_SOLIC_BCO_SANGUE (NR_SEQUENCIA) on delete cascade)');
CALL exec_sql_dinamico('TASY', 'Alter Table PROTOCOLO_GUIA_INF add (Constraint PROTCINF_PROMEPR_FK Foreign Key (NR_SEQ_PROTOCOLO,NR_SEQ_PROTOCOLO_MEDIC,NR_SEQ_PROCEDIMENTO) References PROTOCOLO_MEDIC_PROC (CD_PROTOCOLO,NR_SEQUENCIA,NR_SEQ_PROC) on delete cascade)');
CALL exec_sql_dinamico('TASY', 'Alter Table PROTOCOLO_GUIA_INF add (Constraint PROTCINF_PROMEMA_FK Foreign Key (NR_SEQ_PROTOCOLO,NR_SEQ_PROTOCOLO_MEDIC,NR_SEQ_MATERIAL) References PROTOCOLO_MEDIC_MATERIAL (CD_PROTOCOLO,NR_SEQUENCIA,NR_SEQ_MATERIAL) on delete cascade)');
CALL exec_sql_dinamico('TASY', 'Alter Table PROTOCOLO_GUIA_INF add (Constraint PROTCINF_PROMERE_FK Foreign Key (NR_SEQ_PROTOCOLO,NR_SEQ_PROTOCOLO_MEDIC,NR_SEQ_RECOMENDACAO) References PROTOCOLO_MEDIC_REC (CD_PROTOCOLO,NR_SEQUENCIA,NR_SEQ_REC) on delete cascade)');
CALL exec_sql_dinamico('TASY', 'Alter Table PROTOCOLO_GUIA_INF add (Constraint PROTCINF_PROHDPR_FK Foreign Key (NR_SEQ_HD) References PROTOCOLO_HD_PRESCRICAO (NR_SEQUENCIA) on delete cascade)');
CALL exec_sql_dinamico('TASY', 'Alter Table PROTOCOLO_GUIA_INF add (Constraint PROTCINF_PRMEGAS_FK Foreign Key (NR_SEQ_GAS) References PROTOCOLO_MEDIC_GAS (NR_SEQUENCIA) on delete cascade)');
CALL exec_sql_dinamico('TASY', 'Alter Table PROTOCOLO_GUIA_INF add (Constraint PROTCINF_TIPPROT_FK Foreign Key (NR_SEQ_TIPO_PROT) References TIPO_PROTOCOLO (CD_TIPO_PROTOCOLO))');

CALL exec_sql_dinamico('TASY', 'Create Index PROTCINF_PROTOCO_FK_I on PROTOCOLO_GUIA_INF(NR_SEQ_PROTOCOLO)');
CALL exec_sql_dinamico('TASY', 'Create Index PROTCINF_PROMEDL_FK_I on PROTOCOLO_GUIA_INF(NR_SEQ_LEITE)');
CALL exec_sql_dinamico('TASY', 'Create Index PROTCINF_PRSOBCS_FK_I on PROTOCOLO_GUIA_INF(NR_SEQ_SANGUE)');
CALL exec_sql_dinamico('TASY', 'Create Index PROTCINF_PRMEJEJ_FK_I on PROTOCOLO_GUIA_INF(NR_SEQ_PROTOCOLO,NR_SEQ_PROTOCOLO_MEDIC,NR_SEQ_JEJUM)');
CALL exec_sql_dinamico('TASY', 'Create Index PROTCINF_PRMENPT_FK_I on PROTOCOLO_GUIA_INF(NR_SEQ_PROTOCOLO,NR_SEQ_PROTOCOLO_MEDIC,NR_SEQ_NPT)');
CALL exec_sql_dinamico('TASY', 'Create Index PROTCINF_PROHDPR_FK_I on PROTOCOLO_GUIA_INF(NR_SEQ_HD)');
CALL exec_sql_dinamico('TASY', 'Create Index PROTCINF_PRMEGAS_FK_I on PROTOCOLO_GUIA_INF(NR_SEQ_GAS)');
CALL exec_sql_dinamico('TASY', 'Create Index PROTCINF_TIPPROT_FK_I on PROTOCOLO_GUIA_INF(NR_SEQ_TIPO_PROT)');
CALL exec_sql_dinamico('TASY', 'Create Index PROTCINF_PROMEDI_FK_I on PROTOCOLO_GUIA_INF(NR_SEQ_PROTOCOLO,NR_SEQ_PROTOCOLO_MEDIC)');
CALL exec_sql_dinamico('TASY', 'Create Index PROTCINF_PROMEDT_FK_I on PROTOCOLO_GUIA_INF(NR_SEQ_PROTOCOLO,NR_SEQ_PROTOCOLO_MEDIC,NR_SEQ_DIETA)');
CALL exec_sql_dinamico('TASY', 'Create Index PROTCINF_PROMEMA_FK_I on PROTOCOLO_GUIA_INF(NR_SEQ_PROTOCOLO,NR_SEQ_PROTOCOLO_MEDIC,NR_SEQ_MATERIAL)');
CALL exec_sql_dinamico('TASY', 'Create Index PROTCINF_PROMEPR_FK_I on PROTOCOLO_GUIA_INF(NR_SEQ_PROTOCOLO,NR_SEQ_PROTOCOLO_MEDIC,NR_SEQ_PROCEDIMENTO)');
CALL exec_sql_dinamico('TASY', 'Create Index PROTCINF_PROMERE_FK_I on PROTOCOLO_GUIA_INF(NR_SEQ_PROTOCOLO,NR_SEQ_PROTOCOLO_MEDIC,NR_SEQ_RECOMENDACAO)');
CALL exec_sql_dinamico('TASY', 'Create Index PROTCINF_PROMESO_FK_I on PROTOCOLO_GUIA_INF(NR_SEQ_PROTOCOLO,NR_SEQ_PROTOCOLO_MEDIC,NR_SEQ_SOLUCAO)');

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_protocolo_guia_inf () FROM PUBLIC;

