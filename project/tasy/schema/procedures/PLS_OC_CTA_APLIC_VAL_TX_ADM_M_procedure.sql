-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_aplic_val_tx_adm_m () AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Aplicar a validação para cada regra de interCâmbio nos materiais das contas
	da tabela de seleção.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------
Pontos de atenção:

AO ALTERAR ESTA ROTINA VERIFICAR A NECESSIDADE DE REPLICAR A ALTERAÇÃO NA ROTINA PLS_OC_CTA_APLIC_VAL_TX_ADM_P

Alterações:
-------------------------------------------------------------------------------------------------------------------
jjung OS 606930 - 31/08/2013 - Criação da rotina.
-------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
BEGIN

-- ESTA PROCEDURE FOI DESCONTINUADA POR NÃO SER MAIS NECESSÁRIA
null;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_aplic_val_tx_adm_m () FROM PUBLIC;

