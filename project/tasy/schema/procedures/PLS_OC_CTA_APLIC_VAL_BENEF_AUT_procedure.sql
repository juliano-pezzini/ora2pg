-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_aplic_val_benef_aut () AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  Aplicar a validação das contas cujo beneficiário da autorização (guia) é diferente
do da conta
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:

Alterações:
------------------------------------------------------------------------------------------------------------------
jjung 29/06/2013

Alteração:	Adicionado parametro nos métodos de atualização dos campos IE_VALIDO e IE_VALIDO_TEMP
	da PLS_TIPOS_OCOR_PCK

Motivo:	Se tornou necessário diferenciar os filtros das validações na hora de realizar esta operação
	para que os filtros de exceção funcionem corretamente.
------------------------------------------------------------------------------------------------------------------
jjung 14/10/2013 - Substituída pela procedure PLS_OC_CTA_TRATAR_VAL_10
------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
BEGIN

null;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_aplic_val_benef_aut () FROM PUBLIC;
