-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_contas_a700 ( nr_seq_servico_p ptu_servico_pre_pagto.nr_sequencia%type, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


/*
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
**************************************************************************************************************************************************************************************
**************************************************************************************************************************************************************************************
**************************************************************************************************************************************************************************************
************** SE FOR ALTERAR ALGUMA COISA NESTA ROTINA, FAVOR VERIFICAR A pls_gerar_contas_a700_pck. ELA É UTILIZADA NO NOVO PROCESSO DE CONTAS MÉDICAS. *****************
**************************************************A NOVA ROTINA FOI CRIADA COM BASE NESTA ROTINA (pls_gerar_contas_a700) . *******************************************************
**************************************** HOUVE DUPLICAÇÃO DE CÓDIGO PARA MANTERMOS TUDO FUNCIONANDO DURANTE A TRANSIÇÃO ************************************************
**************************************************************************************************************************************************************************************
**************************************************************************************************************************************************************************************
**************************************************************************************************************************************************************************************
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/
BEGIN

null;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_contas_a700 ( nr_seq_servico_p ptu_servico_pre_pagto.nr_sequencia%type, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

