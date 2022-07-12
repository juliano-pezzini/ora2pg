-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_conv_xml_cta_pck.alimenta_campos_nulo () AS $body$
BEGIN

-- Atualiza os campos da Tabela CBO_SAUDE

CALL pls_conv_xml_cta_pck.alimenta_campos_cbo_saude();

-- alimenta os campos referentes a regra de convers_o de tabela TISS

CALL pls_conv_xml_cta_pck.alimenta_campos_reg_tab_tiss();

-- alimenta os campos referentes a regra de importacao de materiais

CALL pls_conv_xml_cta_pck.alimenta_campo_reg_imp_mat();

-- alimenta os campos da tabela pls_pacote

CALL pls_conv_xml_cta_pck.alimenta_campo_pls_pacote();

-- alimenta os campos da pls_conversao_tuss

CALL pls_conv_xml_cta_pck.alimenta_campo_tuss_conversao();

-- alimenta os campos da pls_grau_participacao

CALL pls_conv_xml_cta_pck.alimenta_campo_grau_partic();

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_conv_xml_cta_pck.alimenta_campos_nulo () FROM PUBLIC;
