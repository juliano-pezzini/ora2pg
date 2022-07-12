-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

 
-- retorna o tipo de interferência da ocorrência 
CREATE OR REPLACE FUNCTION pls_gerencia_dados_ocor_pck.pls_obter_interferencia_ocor ( nr_seq_ocorrencia_p pls_ocorrencia.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE

ie_tipo_inter_ocor_w	pls_analise_fluxo_item.ie_tipo_glosa%type;

C01 CURSOR(	nr_seq_ocorrencia_p	pls_ocorrencia.nr_sequencia%type) FOR 
	SELECT	coalesce(a.ie_glosar_pagamento,'S') ie_glosar_pagamento, 
		coalesce(a.ie_glosar_faturamento,'S') ie_glosar_faturamento 
	from	pls_ocorrencia a 
	where	a.nr_sequencia	= nr_seq_ocorrencia_p;

BEGIN 
-- por padrão, é nulo 
ie_tipo_inter_ocor_w := null;
 
for r_C01_w in C01(nr_seq_ocorrencia_p) loop 
	-- se for para pogamento e faturamento é ambos (A) 
	if (r_C01_w.ie_glosar_pagamento = 'S') and (r_C01_w.ie_glosar_faturamento = 'S') then 
		ie_tipo_inter_ocor_w	:= 'A';
	-- faturamento (F) 
	elsif (r_C01_w.ie_glosar_faturamento = 'S') then 
		ie_tipo_inter_ocor_w	:= 'F';
	-- se não for mais nada, só pode ser pagamento (P) 
	else 
		ie_tipo_inter_ocor_w	:= 'P';
	end if;
 
end loop;
 
return ie_tipo_inter_ocor_w;
 
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_gerencia_dados_ocor_pck.pls_obter_interferencia_ocor ( nr_seq_ocorrencia_p pls_ocorrencia.nr_sequencia%type) FROM PUBLIC;