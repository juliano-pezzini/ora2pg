-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_nome_pasta_anexo ( nr_seq_guia_p bigint default null, nr_seq_requisicao_p bigint default null, ie_funcao_regra_p bigint DEFAULT NULL, nm_arquivo_atual_p text DEFAULT NULL, ie_tipo_consulta_p bigint DEFAULT NULL, cd_guia_p text default null, nr_arquivo_anexo_p bigint default null, nr_seq_conta_p bigint default null, nr_seq_protocolo_p bigint default null, nr_seq_recurso_p bigint default null) RETURNS varchar AS $body$
DECLARE


/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Obter o nome do arquivo e/ou pasta em OPS - Cadastro de Regras / OPS - Atendimento / Regra geracao arquivo
----------------------------------------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  ]  Objetos do dicionario [ x ] Tasy (Delphi/Java) [ X ] Portal [  ] Relatorios [ ] Outros:

Portal web: 
* OPSW - Solicitacoes pendentes

 ----------------------------------------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

IE_TIPO_CONSULTA_P
1 - Nome da pasta
2 - Nome do arquivo

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/				
					
ds_retorno_w			varchar(4000);
cd_guia_w				varchar(20);
cd_usuario_plano_w		varchar(255);
ds_caminho_arquivo_w	varchar(255);
ds_macro_caminho_w		varchar(255);
dt_atual_w				varchar(255);
nm_arquivo_w			varchar(255);
ds_extencao_w			varchar(255);
nm_arquivo_atual_w		varchar(255);
qt_registros_w			bigint;


BEGIN

if (ie_tipo_consulta_p	= 1) then
	if ((nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') and nr_seq_guia_p > 0) then

		select	cd_guia,
				substr(pls_obter_dados_segurado(nr_seq_segurado,'C'),1,255)
		into STRICT	cd_guia_w,
				cd_usuario_plano_w
		from	pls_guia_plano
		where	nr_sequencia	= nr_seq_guia_p;
		
		if (cd_guia_p IS NOT NULL AND cd_guia_p::text <> '') then
			cd_guia_w := cd_guia_p;
		end if;
	end if;
	
	if (pls_obter_se_controle_estab('RE') = 'S') then
		select	max(ds_caminho_arquivo)
		into STRICT	ds_caminho_arquivo_w
		from	pls_regra_arquivo_atend
		where	ie_funcao_regra	= ie_funcao_regra_p
		and		ie_situacao	= 'A'
		and 	coalesce(cd_estabelecimento, wheb_usuario_pck.get_cd_estabelecimento) = wheb_usuario_pck.get_cd_estabelecimento;
	else
		select	max(ds_caminho_arquivo)
		into STRICT	ds_caminho_arquivo_w
		from	pls_regra_arquivo_atend
		where	ie_funcao_regra	= ie_funcao_regra_p
		and		ie_situacao	= 'A';
	end if;
	
	if (ds_caminho_arquivo_w IS NOT NULL AND ds_caminho_arquivo_w::text <> '') then

		select	substr(ds_caminho_arquivo_w,position('@' in ds_caminho_arquivo_w),length(ds_caminho_arquivo_w))
		into STRICT	ds_macro_caminho_w
		;
		
		if (coalesce(ds_macro_caminho_w, 'X') <> 'X') then
			if ((nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') and nr_seq_guia_p > 0) then
				select	replace(ds_caminho_arquivo_w,'@CD_GUIA',coalesce(cd_guia_w,nr_seq_guia_p))
				into STRICT	ds_caminho_arquivo_w
				;

				select	replace(ds_caminho_arquivo_w, '@CD_USUARIO_PLANO', cd_usuario_plano_w)
				into STRICT	ds_caminho_arquivo_w
				;
			elsif ((nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') and nr_seq_requisicao_p > 0) then
				select	replace(ds_caminho_arquivo_w, '@REQUISICAO', nr_seq_requisicao_p)
				into STRICT	ds_caminho_arquivo_w
				;
			elsif ((nr_seq_conta_p IS NOT NULL AND nr_seq_conta_p::text <> '') and nr_seq_conta_p > 0) then
				select	replace(ds_caminho_arquivo_w, '@CONTA', nr_seq_conta_p)
				into STRICT	ds_caminho_arquivo_w
				;
			elsif ((nr_seq_protocolo_p IS NOT NULL AND nr_seq_protocolo_p::text <> '') and nr_seq_protocolo_p > 0) then
				select	replace(ds_caminho_arquivo_w, '@PROTOCOLO', nr_seq_protocolo_p)
				into STRICT	ds_caminho_arquivo_w
				;	
			elsif ((nr_seq_recurso_p IS NOT NULL AND nr_seq_recurso_p::text <> '') and nr_seq_recurso_p > 0) then
				select	replace(ds_caminho_arquivo_w, '@RECURSO', nr_seq_recurso_p)
				into STRICT	ds_caminho_arquivo_w
				;
			end if;
		end if;
	
		ds_retorno_w	:= ds_caminho_arquivo_w;
	end if;
elsif (ie_tipo_consulta_p	= 2) then
	if ((nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') and nr_seq_guia_p > 0) then

		select	cd_guia
		into STRICT	cd_guia_w
		from	pls_guia_plano
		where	nr_sequencia	= nr_seq_guia_p;

		if (cd_guia_p IS NOT NULL AND cd_guia_p::text <> '') then
			cd_guia_w := cd_guia_p;
		end if;
	end if;
	
	if (pls_obter_se_controle_estab('RE') = 'S') then
		select	max(nm_arquivo)
		into STRICT	nm_arquivo_w
		from	pls_regra_arquivo_atend
		where	ie_funcao_regra	= ie_funcao_regra_p
		and		ie_situacao	= 'A'
		and 	coalesce(cd_estabelecimento, wheb_usuario_pck.get_cd_estabelecimento) = wheb_usuario_pck.get_cd_estabelecimento;
	else
		select	max(nm_arquivo)
		into STRICT	nm_arquivo_w
		from	pls_regra_arquivo_atend
		where	ie_funcao_regra	= ie_funcao_regra_p
		and		ie_situacao	= 'A';
	end if;
	
	if (nm_arquivo_w IS NOT NULL AND nm_arquivo_w::text <> '') then
		select	substr(nm_arquivo_w, position('@' in nm_arquivo_w), length(nm_arquivo_w)),
				substr(nm_arquivo_atual_p, position('.' in nm_arquivo_atual_p), length(nm_arquivo_atual_p)),
				substr(nm_arquivo_atual_p,1, position('.' in nm_arquivo_atual_p)-1)
		into STRICT	ds_macro_caminho_w,
				ds_extencao_w,
				nm_arquivo_atual_w
		;
		
		if ((nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') and nr_seq_guia_p > 0) then
			select	replace_macro(ds_macro_caminho_w, '@CD_GUIA',coalesce(cd_guia_w,nr_seq_guia_p))
			into STRICT	ds_macro_caminho_w
			;
		elsif ((nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') and nr_seq_requisicao_p > 0) then		
			select	replace_macro(ds_macro_caminho_w, '@REQUISICAO', nr_seq_requisicao_p)
			into STRICT	ds_macro_caminho_w
			;
		elsif ((nr_seq_conta_p IS NOT NULL AND nr_seq_conta_p::text <> '') and nr_seq_conta_p > 0) then
			select	replace_macro(ds_macro_caminho_w, '@CONTA', nr_seq_conta_p)
			into STRICT	ds_macro_caminho_w
			;
		elsif ((nr_seq_protocolo_p IS NOT NULL AND nr_seq_protocolo_p::text <> '') and nr_seq_protocolo_p > 0) then
			select	replace_macro(ds_macro_caminho_w, '@PROTOCOLO', nr_seq_protocolo_p)
			into STRICT	ds_macro_caminho_w
			;
		elsif ((nr_seq_recurso_p IS NOT NULL AND nr_seq_recurso_p::text <> '') and nr_seq_recurso_p > 0) then
			select	replace_macro(ds_macro_caminho_w, '@RECURSO', nr_seq_recurso_p)
			into STRICT	ds_macro_caminho_w
			;
		end if;		
		
		if ((nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') and nr_seq_guia_p > 0) then
			dt_atual_w := to_char(clock_timestamp(),'ddmmyyyyhh24miss');
		else
			dt_atual_w := to_char(clock_timestamp(),'ddmmyyyyhh24miss') + nr_arquivo_anexo_p;
		end if;
		
		select	replace_macro(ds_macro_caminho_w, '@DT_ATUAL', dt_atual_w)
		into STRICT	ds_macro_caminho_w
		;

		select	replace_macro(ds_macro_caminho_w, '@NM_ATUAL', nm_arquivo_atual_w)
		into STRICT	ds_macro_caminho_w
		;

		ds_retorno_w := ds_macro_caminho_w || ds_extencao_w;
		
		select	position('@' in ds_retorno_w)
		into STRICT	qt_registros_w
		;
		
		if (qt_registros_w	<> 0) then
			ds_retorno_w := null;
		end if;
	end if;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_nome_pasta_anexo ( nr_seq_guia_p bigint default null, nr_seq_requisicao_p bigint default null, ie_funcao_regra_p bigint DEFAULT NULL, nm_arquivo_atual_p text DEFAULT NULL, ie_tipo_consulta_p bigint DEFAULT NULL, cd_guia_p text default null, nr_arquivo_anexo_p bigint default null, nr_seq_conta_p bigint default null, nr_seq_protocolo_p bigint default null, nr_seq_recurso_p bigint default null) FROM PUBLIC;
