-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_cta_val_obter_rest_pre_pad (dados_filtro_prest_p pls_tipos_cta_val_pck.dados_filtro_prest) RETURNS varchar AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: 	Obter o acesso a tabela pls_prestador que será utilizado  para verificar o select
	dos filtros de prestador.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:

Realizar tratamento para os campos IMP quando hourver necessidade

------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_filtro_prest_w	varchar(4000);

BEGIN

--Inicializar as variáveis.
ds_filtro_prest_w	:= null;

if (dados_filtro_prest_p.ie_tipo_prestador IS NOT NULL AND dados_filtro_prest_p.ie_tipo_prestador::text <> '') then
	-- Aqui verifca qual prestador da conta será utilizado, se atendimento, executor, solicitante ou de pagamento.
	if (dados_filtro_prest_p.ie_tipo_prestador = 'A') then
		ds_filtro_prest_w := ds_filtro_prest_w || pls_util_pck.enter_w || '			and	prest.nr_sequencia = proc.nr_seq_prestador_prot ';
	elsif (dados_filtro_prest_p.ie_tipo_prestador = 'E') then
		ds_filtro_prest_w := ds_filtro_prest_w || pls_util_pck.enter_w || '			and	prest.nr_sequencia = proc.nr_seq_prestador_exec ';
	elsif (dados_filtro_prest_p.ie_tipo_prestador = 'S') then
		ds_filtro_prest_w := ds_filtro_prest_w || pls_util_pck.enter_w || '			and	prest.nr_sequencia = proc.nr_seq_prestador_conta ';
	end if;
end if;

return	ds_filtro_prest_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_cta_val_obter_rest_pre_pad (dados_filtro_prest_p pls_tipos_cta_val_pck.dados_filtro_prest) FROM PUBLIC;

