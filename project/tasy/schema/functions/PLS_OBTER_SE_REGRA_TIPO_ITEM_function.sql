-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_regra_tipo_item ( ie_tipo_item_p bigint, nr_seq_tipo_lanc_p bigint, nr_seq_sca_p bigint) RETURNS varchar AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Verificar e retornar se os itens passados se encaixam nas regras cadastradas na função OPS - Gestão de Operadoras / Parâmetros da OPS / Declaração de IR / Regras tipo de item.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:Performance.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_incide_declaracao_w		pls_regra_ir_tipo_item.ie_incide_declaracao%type := 'N';

C01 CURSOR FOR
	SELECT	coalesce(ie_incide_declaracao,'S')
	from	pls_regra_ir_tipo_item
	where (coalesce(ie_tipo_item::text, '') = '' 		or ie_tipo_item = ie_tipo_item_p)
	and (coalesce(nr_seq_tipo_lanc::text, '') = '' 	or nr_seq_tipo_lanc = nr_seq_tipo_lanc_p)
	and (coalesce(nr_seq_sca::text, '') = ''		or nr_seq_sca = nr_seq_sca_p)
	order by coalesce(nr_seq_sca,0),
		coalesce(nr_seq_tipo_lanc,0),
		coalesce(ie_tipo_item, ' ');


BEGIN

open C01;
loop
fetch C01 into
	ie_incide_declaracao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
end loop;
close C01;

return coalesce(ie_incide_declaracao_w,'N');

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_regra_tipo_item ( ie_tipo_item_p bigint, nr_seq_tipo_lanc_p bigint, nr_seq_sca_p bigint) FROM PUBLIC;
