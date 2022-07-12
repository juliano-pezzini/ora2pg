-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_desc_coluna_analise ( ie_tipo_item_p text, nm_coluna_p text, cd_prestador_exec_p text, nm_prestador_exec_p text, cd_medico_p text) RETURNS varchar AS $body$
DECLARE

 
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: Obter a forma de visualização da coluna conforme regra em: 
OPS - Gestão de Análise de Produção Médica -> Regras -> Forma de visualização de coluna 
 
Domínio: 5206 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ X ] Objetos do dicionário [ ] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção: 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
 
ds_coluna_w		varchar(255)	:= null;
ie_visualizacao_w	varchar(30)	:= null;
nm_medico_w		varchar(255);


BEGIN 
 
if (ie_tipo_item_p IS NOT NULL AND ie_tipo_item_p::text <> '') and (nm_coluna_p IS NOT NULL AND nm_coluna_p::text <> '') then 
 
	begin 
	select	a.ie_visualizacao 
	into STRICT	ie_visualizacao_w 
	from	pls_regra_analise_vis_cpo a 
	where	a.ie_tipo_item	= ie_tipo_item_p 
	and	a.nm_campo	= nm_coluna_p;
	exception 
		when others then 
		ie_visualizacao_w	:= null;
	end;
	 
	/* Valores default */
 
	if (coalesce(ie_visualizacao_w::text, '') = '') then 
		if (ie_tipo_item_p = 'HI') then 
			ie_visualizacao_w	:= 'HI_1';
		elsif (ie_tipo_item_p = 'R') then 
			ie_visualizacao_w	:= 'R_1';
		end if;
	end if;
	 
	/* Nome do prestador executor da conta */
 
	if (ie_visualizacao_w = 'HI_1') then 
		ds_coluna_w	:= nm_prestador_exec_p;
	/* Código + Nome do prestador executor da conta */
 
	elsif (ie_visualizacao_w = 'HI_2') then 
		ds_coluna_w	:= cd_prestador_exec_p || ' - ' || nm_prestador_exec_p;
	/* Nome do médico */
 
	elsif (ie_visualizacao_w = 'R_1') then 
		if (cd_medico_p IS NOT NULL AND cd_medico_p::text <> '') then 
			ds_coluna_w	:= obter_nome_medico(cd_medico_p,'PS');
		end if;
	/* Nome do médico + CRM do Médico */
 
	elsif (ie_visualizacao_w = 'R_2') then 
		if (cd_medico_p IS NOT NULL AND cd_medico_p::text <> '') then 
			ds_coluna_w	:= obter_nome_medico(cd_medico_p,'P');
		end if;
	end if;
end if;
 
return	ds_coluna_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_desc_coluna_analise ( ie_tipo_item_p text, nm_coluna_p text, cd_prestador_exec_p text, nm_prestador_exec_p text, cd_medico_p text) FROM PUBLIC;
