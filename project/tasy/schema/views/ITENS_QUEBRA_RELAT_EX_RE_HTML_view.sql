-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW itens_quebra_relat_ex_re_html (ie_ordem, cd_selecionado, cd_n_selecionado, ds, nm) AS SELECT	01 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1028513) DS, 'NM_MEDICO_CRM' NM


UNION

SELECT	02 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103605) DS, 'NM_FUNCIONARIO'


UNION

SELECT	03 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103606) DS, 'DS_TIPO_EXAME' NM


UNION

SELECT	04 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1028507) DS, 'DS_PROCEDIMENTO' NM


UNION

SELECT	05 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103609) DS, 'DS_SETOR_ATENDIMENTO' NM


UNION

SELECT	06 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103610) DS, 'DS_SETOR_PACIENTE' NM


UNION

SELECT	07 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103611) DS, 'DS_EQUIPAMENTO' NM


UNION

SELECT	08 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103612) DS, 'NR_PROTOCOLO' NM


UNION

SELECT	09 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103613) DS, 'DT_REFERENCIA' NM


UNION

SELECT	10 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1028495) DS, 'DT_MESANO_REFER' NM


UNION

SELECT	11 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103614) DS, 'DS_CENTRO_CUSTO' NM


UNION

SELECT	12 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103615) DS, 'DS_CONTA_CONTABIL' NM


UNION

SELECT	13 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1028526) DS, 'NM_MUNICIPIO' NM


UNION

SELECT	14 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1028505) DS, 'NM_PESSOA_FISICA' NM


UNION

SELECT	15 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103616) DS, 'DT_PROC_MES' NM


UNION

SELECT	16 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103617) DS, 'DS_MUNICIPIO' NM


UNION

SELECT	17 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103618) DS, 'DS_TIPO_ATENDIMENTO' NM


UNION

SELECT	18 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103619) DS, 'NR_ATENDIMENTO' NM


UNION

SELECT	19 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103620) DS, 'DS_CATEGORIA' NM


UNION

SELECT	20 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103621) DS, 'DS_PROCEDENCIA' NM


UNION

SELECT	21 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103622) DS, 'DS_FORMA_ENTREGA_LAUDO' NM


UNION

SELECT	22 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103623) DS, 'DS_GRUPO_PROC' NM


UNION

SELECT	23 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103624) DS, 'DS_GRUPO_LABORATORIO' NM


UNION

SELECT	24 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103625) DS, 'DS_ESPECIALIDADE_PROCED' NM


UNION

SELECT	25 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103626) DS, 'CD_EXAME_LAB' NM


UNION

SELECT	26 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103627) DS, 'DS_SETOR_ENTREGA' NM


UNION

SELECT	27 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103628) DS, 'DS_FAIXA_ETARIA' NM


UNION

SELECT	28 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103629) DS, 'DS_ESPECIALIDADE_MEDICO' NM


UNION

SELECT	29 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103630) DS, 'DS_CARATER_ATENDIMENTO' NM


UNION

SELECT	30 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103631) DS, 'DS_SEXO' NM


UNION

SELECT	31 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103632) DS, 'DS_COR' NM


UNION

SELECT	32 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103633) DS, 'QT_IDADE' NM


UNION

SELECT	33 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103634) DS, 'DS_MUNICIPIO_IBGE' NM


UNION

SELECT	34 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103635) DS, 'DS_CREDENCIAMENTO_SUS' NM


UNION

SELECT	35 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103636) DS, 'DS_PRESTADOR' NM


UNION

SELECT	36 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103637) DS, 'DS_PLANO' NM


UNION

SELECT	37 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103638) DS, 'DS_GRUPO_SUS' NM


UNION

SELECT	38 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103639) DS, 'DS_SUBGRUPO_SUS' NM


UNION

SELECT	39 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103640) DS, 'DS_FORMAORG_SUS' NM


UNION

SELECT	40 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103641) DS, 'DS_CLINICA' NM


UNION

SELECT	41 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103642) DS, 'DS_COMPLEXIDADE' NM


UNION

SELECT	42 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103643) DS, 'DS_TIPO_FINANCIAMENTO' NM


UNION

SELECT	43 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103644) DS, 'DS_APURAR_VALOR' NM


UNION

SELECT	44 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103645) DS, 'DS_TIPO_CONVENIO' NM


UNION

SELECT	45 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103646) DS, 'DS_SETOR_RECEITA' NM


UNION

SELECT	46 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103647) DS, 'DS_CBO_EXECUTOR' NM


UNION

SELECT	47 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103648) DS, 'DS_BAIRRO' NM


UNION

SELECT	48 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103649) DS, 'DS_SETOR_COLETA' NM


UNION

SELECT	49 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103650) DS, 'DS_SETOR_ENTREGA_PRESC_PROC' NM


UNION

SELECT	50 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1028527) DS, 'DS_CID' NM


UNION

SELECT	51 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103651) DS, 'DS_SETOR_PRESCRICAO' NM


UNION

SELECT	52 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103652) DS, 'DS_PROC_INTERNO' NM


UNION

SELECT	53 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103653) DS, 'DS_CID_APAC' NM


UNION

SELECT	54 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103654) DS, 'DS_FUNCAO_MEDICO' NM


UNION

SELECT	55 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103655) DS, 'DT_NASCIMENTO' NM


UNION

SELECT	56 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103656) DS, 'DS_TIPO_PROTOCOLO' NM


UNION

SELECT	57 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103657) DS, 'DS_USUARIO_ORIGINAL' NM


UNION

SELECT	58 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103658) DS, 'HR_PROCEDIMENTO' NM


UNION

SELECT	59 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103659) DS, 'DS_RESP_CREDITO' NM


UNION

SELECT	60 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103660) DS, 'DS_EMPRESA_REF' NM


UNION

SELECT	61 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103661) DS, 'DS_CONVENIO_GLOSA' NM


UNION

SELECT	62 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103662) DS, 'DS_CAT_CONV_GLOSA' NM


UNION

SELECT	63 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103664) DS, 'DS_MOTIVO_COB_APAC' NM


UNION

SELECT	64 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103666) DS, 'NR_CONTA' NM


UNION

SELECT	65 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103667) DS, 'DS_COORDENADORIA' NM


UNION

SELECT	66 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103668) DS, 'DS_CONVENIO_ATEND' NM


UNION

SELECT	67 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103669) DS, 'DS_TIPO_UTIL' NM


UNION

SELECT	68 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103671) DS, 'DS_CID_AMA' NM


UNION

SELECT	69 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103672) DS, 'DS_CLASSIF_PROC_INT' NM


UNION

SELECT	70 IE_ORDEM, 'S' CD_SELECIONADO, 'N' CD_N_SELECIONADO, wheb_mensagem_pck.get_texto(1103674) DS, 'DS_CONVENIO' NM
;
