-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

-- Retorna o tipo de regra que deve ser verificada para buscar a regra coerente para o tipo de beneficiario que esta sendo passado.



CREATE OR REPLACE FUNCTION pls_taxa_intercambio_pck.obter_tipo_regra ( nr_seq_congenere_p pls_segurado.nr_seq_congenere%type) RETURNS PLS_REGRA_INTERCAMBIO.IE_TIPO_REGRA%TYPE AS $body$
DECLARE


ie_tipo_regra_w		pls_regra_intercambio.ie_tipo_regra%type;
ie_tipo_congenere_w	pls_congenere.ie_tipo_congenere%type;	
		

BEGIN

/*
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

**************************************************************************************************************************************************************************************
**************************************************************************************************************************************************************************************
**************************************************************************************************************************************************************************************
********* SE FOR ALTERAR ALGUMA COISA NESTA ROTINA, FAVOR VERIFICAR A pls_cta_valorizacao_pck a function obter_tipo_regra ************************************************************
********* HOUVE DUPLICACAO DE CODIGO PARA MANTERMOS AS TAXAS DE INTERCAMBIO FUNCIONANDO NOS DOIS MODELOS ************************************************************
**************************************************************************************************************************************************************************************
**************************************************************************************************************************************************************************************
**************************************************************************************************************************************************************************************
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/


ie_tipo_regra_w := null;

select	max(ie_tipo_congenere)
into STRICT	ie_tipo_congenere_w
from	pls_congenere
where	nr_sequencia	= nr_seq_congenere_p;
-- Quando for beneficiario de Intercambio entre OPS congeneres (Resp. Assumida) entao a regra e de Congenere Empresa

-- se nao e de Cooperativa.

if (ie_tipo_congenere_w = 'OP') then

	-- Cobranca Empresa

	ie_tipo_regra_w := 'CE';
else	
	-- Cooperativas

	ie_tipo_regra_w := 'CO';
end if;

return ie_tipo_regra_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_taxa_intercambio_pck.obter_tipo_regra ( nr_seq_congenere_p pls_segurado.nr_seq_congenere%type) FROM PUBLIC;
