-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_verifica_autent_prot_web (nr_seq_protocolo_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w		varchar(1) := 'S';/*  Se retornar 'S' e porque o arquivo esta autenticado */
nr_seq_prestador_w	pls_protocolo_conta.nr_seq_prestador_imp%type;
cd_versao_tiss_w        pls_protocolo_conta.cd_versao_tiss%type;
nm_usuario_ws_w		pls_autenticacao_tiss.nm_usuario_ws%type := null;
ds_senha_ws_w		pls_autenticacao_tiss.ds_senha_ws%type := null;
validar_w		pls_versao_tiss.ie_valida_autenticacao%type;

c01 CURSOR(	nr_seq_prestador_pc	pls_protocolo_conta.nr_seq_prestador_imp%type,
		cd_versao_tiss_pc	pls_protocolo_conta.cd_versao_tiss%type) FOR
	SELECT	nm_usuario_ws nm_usuario_ws_prest,
		ds_senha_ws ds_senha_ws_prest
	from	pls_prest_autent_tiss
	where	nr_seq_prestador = nr_seq_prestador_pc
	and (coalesce(cd_versao_tiss::text, '') = '' or cd_versao_tiss = cd_versao_tiss_pc)
	and	clock_timestamp() >= dt_inicio_vigencia
	and (coalesce(dt_fim_vigencia::text, '') = '' or clock_timestamp() < dt_fim_vigencia);

BEGIN
	
select	nr_seq_prestador_imp_ref,
	cd_versao_tiss
into STRICT	nr_seq_prestador_w,
	cd_versao_tiss_w
from	pls_protocolo_conta
where	nr_sequencia = nr_seq_protocolo_p;

select 	coalesce(max(ie_valida_autenticacao), 'N')
into STRICT	validar_w
from	pls_versao_tiss
where 	cd_versao_tiss = cd_versao_tiss_w;

if (validar_w = 'S') then
	begin
		select	nm_usuario_ws,
			ds_senha_ws
		into STRICT	nm_usuario_ws_w,
			ds_senha_ws_w
		from	pls_autenticacao_tiss
		where	nr_seq_prot_conta = nr_seq_protocolo_p;
	exception
	when others then
		nm_usuario_ws_w := null;
		ds_senha_ws_w := null;
	end;

	--somente pode validar se tem a tag do usuario
	if (nr_seq_prestador_w IS NOT NULL AND nr_seq_prestador_w::text <> '' AND nm_usuario_ws_w IS NOT NULL AND nm_usuario_ws_w::text <> '') then
		
		-- para cada usuario cadastrado par ao prestador
		for r01 in c01(nr_seq_prestador_w, cd_versao_tiss_w) loop
		
			if ((nm_usuario_ws_w IS NOT NULL AND nm_usuario_ws_w::text <> '') or r01.nm_usuario_ws_prest is  not null or
				 (ds_senha_ws_w IS NOT NULL AND ds_senha_ws_w::text <> '') or (r01.ds_senha_ws_prest IS NOT NULL AND r01.ds_senha_ws_prest::text <> '')) then
				 ie_retorno_w := 'N';
				
				 if    (((nm_usuario_ws_w IS NOT NULL AND nm_usuario_ws_w::text <> '') and r01.nm_usuario_ws_prest is  not null and
					(ds_senha_ws_w IS NOT NULL AND ds_senha_ws_w::text <> '') and (r01.ds_senha_ws_prest IS NOT NULL AND r01.ds_senha_ws_prest::text <> '')) and (upper(nm_usuario_ws_w) = upper(r01.nm_usuario_ws_prest) and upper(ds_senha_ws_w) = upper(r01.ds_senha_ws_prest))) then
					ie_retorno_w := 'S';
					exit;
				end if;
				
			end if;
		
		end loop;
		
	end if;
end if;
	
return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_verifica_autent_prot_web (nr_seq_protocolo_p bigint) FROM PUBLIC;

