-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


/*Necessaria a criacao/duplicacao das function por conta da OS 2020797. Isso porque para a visualizacao da situacao de utilizacao do item na OPS - Autorizacoes nao fazia a validacao
do atendimento como um todo (levando em consideracao somente a guia principal). Para nao acarretar problemas de performance na apresentacao automatica e demais processos que 
utilizam essa rotina, criamos essa para a utilizacao nos campos functions que leva em consideracao o cd_guia_ok da pls_conta para contar os itens do atendimento*/
CREATE OR REPLACE FUNCTION pls_conta_autor_pck.pls_obter_ie_utilizado_guia_ds ( nr_seq_guia_p pls_guia_plano.nr_sequencia%type, nr_seq_guia_proc_p pls_guia_plano_proc.nr_sequencia%type, nr_seq_guia_mat_p pls_guia_plano_mat.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) RETURNS varchar AS $body$
DECLARE

ie_retorno_w		varchar(1)	:= 'N';


BEGIN

	ie_retorno_w := pls_conta_autor_pck.pls_obter_ie_utilizado_item_ds(nr_seq_guia_p, nr_seq_guia_proc_p, nr_seq_guia_mat_p, cd_estabelecimento_p);

return ie_retorno_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_conta_autor_pck.pls_obter_ie_utilizado_guia_ds ( nr_seq_guia_p pls_guia_plano.nr_sequencia%type, nr_seq_guia_proc_p pls_guia_plano_proc.nr_sequencia%type, nr_seq_guia_mat_p pls_guia_plano_mat.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;