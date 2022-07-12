-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_cons_regra_atend_cart ( nr_seq_segurado_p pls_segurado.nr_sequencia%type, nr_seq_regra_atend_cart_p pls_oc_atend_carteira.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE

					
ie_glosar_cart_w	varchar(1);


BEGIN

ie_glosar_cart_w := pls_consistir_regra_atend_cart(nr_seq_segurado_p, nr_seq_regra_atend_cart_p, ie_glosar_cart_w);

return ie_glosar_cart_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_cons_regra_atend_cart ( nr_seq_segurado_p pls_segurado.nr_sequencia%type, nr_seq_regra_atend_cart_p pls_oc_atend_carteira.nr_sequencia%type) FROM PUBLIC;

