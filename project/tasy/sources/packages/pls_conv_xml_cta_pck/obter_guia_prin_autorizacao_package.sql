-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_conv_xml_cta_pck.obter_guia_prin_autorizacao ( cd_guia_principal_p pls_conta_imp.cd_guia_principal%type, nr_seq_segurado_p pls_segurado.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE


cd_guia_principal_w		pls_guia_plano.cd_guia_principal%type;
cd_guia_princ_conv_w		pls_guia_plano.cd_guia_principal%type;
nr_seq_guia_principal_w		pls_guia_plano.nr_sequencia%type;
						
C01 CURSOR(	nr_seq_segurado_pc	pls_segurado.nr_sequencia%type) FOR	
	SELECT	a.nr_sequencia,
		pls_converte_cd_guia_pesquisa(a.cd_guia) cd_guia
	from	pls_guia_plano a
	where	a.nr_seq_segurado = nr_seq_segurado_pc;

BEGIN

cd_guia_principal_w := cd_guia_principal_p;

-- Procurar primeiro pelo CD_GUIA_PESQUISA

select	max(nr_sequencia)
into STRICT	nr_seq_guia_principal_w
from	pls_guia_plano a
where	a.cd_guia_pesquisa = cd_guia_principal_w
and	a.nr_seq_segurado = nr_seq_segurado_p;

-- Se n_o achou, procurar por esse n_mero de guia em todas as guias desse benefici_rio 

if (coalesce(nr_seq_guia_principal_w::text, '') = '') then

	for r_c01_w in C01(nr_seq_segurado_p) loop
	
		-- se o cd_guia formatado for igual ao cd_guia_principal formatado

		if (r_c01_w.cd_guia = cd_guia_principal_w) then
		
			nr_seq_guia_principal_w := r_c01_w.nr_sequencia;
		end if;
	end loop;
end if;
-- Francisco - 07/08/2012 - Fim tratamento Performance


if (nr_seq_guia_principal_w IS NOT NULL AND nr_seq_guia_principal_w::text <> '') then
	select	max(cd_guia)
	into STRICT	cd_guia_princ_conv_w
	from	pls_guia_plano
	where	nr_sequencia = nr_seq_guia_principal_w;
end if;

-- caso n_o encontre nada retorna o que foi passado de parametro

if (coalesce(cd_guia_princ_conv_w::text, '') = '') then

	cd_guia_princ_conv_w := cd_guia_principal_p;
end if;

return	cd_guia_princ_conv_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_conv_xml_cta_pck.obter_guia_prin_autorizacao ( cd_guia_principal_p pls_conta_imp.cd_guia_principal%type, nr_seq_segurado_p pls_segurado.nr_sequencia%type) FROM PUBLIC;
