-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_oc_cta_obter_sel_v_tx_adm () RETURNS varchar AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Obter os dados da restrição para regra de intercâmbio.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:

------------------------------------------------------------------------------------------------------------------
jjung OS 606930 - 19/08/2013 - Criação da rotina.
------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
BEGIN

-- ESTA FUNCTION FOI DESCONTINUADA POR NÃO SER MAIS ÚTIL.
return	null;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_oc_cta_obter_sel_v_tx_adm () FROM PUBLIC;

