-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_cta_val_obter_restr_benef (ie_opcao_p text, cursor_p integer, dados_filtro_benef_p pls_tipos_cta_val_pck.dados_filtro_benef) RETURNS varchar AS $body$
DECLARE


ds_restricao_w		varchar(4000);
ds_select_benef_w	varchar(4000);
ds_filtro_benef_w	varchar(4000);

BEGIN

--Inicializar as variáveis.
ds_filtro_benef_w	:= null;
ds_restricao_w		:= null;

-- Tipo de beneficiário
if (dados_filtro_benef_p.ie_tipo_segurado IS NOT NULL AND dados_filtro_benef_p.ie_tipo_segurado::text <> '') then
	if (ie_opcao_p = 'RESTRICAO') then
		ds_filtro_benef_w := ds_filtro_benef_w || pls_util_pck.enter_w || ' and	benef.ie_tipo_segurado = :ie_tipo_segurado ';
	else
		dbms_sql.bind_variable(cursor_p, ':ie_tipo_segurado',dados_filtro_benef_p.ie_tipo_segurado);
	end if;
end if;

if (ds_filtro_benef_w IS NOT NULL AND ds_filtro_benef_w::text <> '') then

	-- Montar o subselect base.
	ds_select_benef_w := pls_tipos_ocor_pck.enter_w||	'and	exists ('||pls_util_pck.enter_w||
					'			select	1 '||pls_util_pck.enter_w||
					'			from	pls_segurado_conta_cta_val_v benef '||pls_util_pck.enter_w||
					'			where	benef.nr_sequencia = proc.nr_seq_segurado ' ||pls_util_pck.enter_w||
					'			and	benef.nr_seq_conta = proc.nr_seq_conta ';

	ds_select_benef_w := ds_select_benef_w || pls_util_pck.enter_w || ds_filtro_benef_w ||'		)';
end if;

ds_restricao_w := ds_select_benef_w;

return	ds_restricao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_cta_val_obter_restr_benef (ie_opcao_p text, cursor_p integer, dados_filtro_benef_p pls_tipos_cta_val_pck.dados_filtro_benef) FROM PUBLIC;
