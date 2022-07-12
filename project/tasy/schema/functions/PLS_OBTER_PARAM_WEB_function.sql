-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_param_web ( cd_funcao_p bigint, nr_sequencia_p bigint, cd_estabelecimento_p bigint, nr_seq_usu_prestador_p bigint, nr_seq_perfil_web_p bigint, nr_seq_segurado_p bigint, nr_seq_usu_estipulante_p bigint, ie_tipo_acesso_p text, nm_usuario_param_p text, nr_seq_usu_gru_cont_p bigint) RETURNS varchar AS $body$
DECLARE

			  
vl_parametro_w 		varchar(255);
vl_param_aux_w		varchar(255);
nr_seq_contrato_w	bigint;
			

BEGIN 
 
if ((nr_seq_perfil_web_p IS NOT NULL AND nr_seq_perfil_web_p::text <> '') and nr_seq_perfil_web_p > 0 and (nr_seq_usu_prestador_p IS NOT NULL AND nr_seq_usu_prestador_p::text <> '')) then 
		select	coalesce(max(a.vl_parametro), null) 
		into STRICT	vl_parametro_w 
		from	pls_web_param_usuario a, 
		    funcao_parametro b 
		where	a.nr_seq_funcao_param = b.nr_sequencia 
		and   a.cd_funcao = b.cd_funcao 
		and   a.cd_funcao = cd_funcao_p 
		and   a.nr_seq_funcao_param = nr_sequencia_p 
		and	a.nr_seq_usu_prestador = nr_seq_usu_prestador_p;
		 
	if (coalesce(vl_parametro_w::text, '') = '') then 
		select	max(a.vl_parametro) 
		into STRICT	vl_parametro_w 
		from	pls_web_param_usuario a 
		where	a.cd_funcao = cd_funcao_p 
		and   a.nr_seq_funcao_param = nr_sequencia_p 
		and	a.nr_seq_perfil_web = nr_seq_perfil_web_p;
	end if;
else 
	select	max(a.vl_parametro) 
	into STRICT	vl_parametro_w 
	from	pls_web_param_usuario a 
	where	a.cd_funcao = cd_funcao_p 
	and   a.nr_seq_funcao_param = nr_sequencia_p 
	and	((nr_seq_segurado_p 	> 0 and a.nr_seq_segurado = nr_seq_segurado_p) 
	or (nr_seq_usu_estipulante_p > 0 and a.nr_seq_usu_estipulante = nr_seq_usu_estipulante_p) 
	or (nr_seq_usu_prestador_p > 0 and a.nr_seq_usu_prestador = nr_seq_usu_prestador_p) 
	or (nr_seq_usu_gru_cont_p > 0 and a.nr_seq_usu_grupo_contrato = nr_seq_usu_gru_cont_p) 
	or ((nm_usuario_param_p IS NOT NULL AND nm_usuario_param_p::text <> '') and upper(a.nm_usuario_param) = upper(nm_usuario_param_p )));
end if;
 
/* Obter o número do contrato */
 
if (nr_seq_segurado_p IS NOT NULL AND nr_seq_segurado_p::text <> '') then 
	nr_seq_contrato_w := pls_obter_dados_segurado(nr_seq_segurado_p, 'NC');
elsif (nr_seq_usu_estipulante_p IS NOT NULL AND nr_seq_usu_estipulante_p::text <> '') then 
	select	max(nr_seq_contrato) 
	into STRICT	nr_seq_contrato_w 
	from	pls_estipulante_web 
	where	nr_sequencia = nr_seq_usu_estipulante_p;
end if;
 
/* Caso o valor do parâmetro seja nulo verifica o parâmetro no contrato obs: se for segurado ou estipulante */
 
if (vl_param_aux_w IS NOT NULL AND vl_param_aux_w::text <> '') then 
	vl_parametro_w := vl_param_aux_w;
elsif (nr_seq_contrato_w IS NOT NULL AND nr_seq_contrato_w::text <> '') then	 
	select	max(a.vl_parametro) 
	into STRICT	vl_param_aux_w 
	from	pls_web_param_contrato a 
	where	a.cd_funcao = cd_funcao_p 
	and   a.nr_seq_contrato = nr_seq_contrato_w 
	and	a.nr_seq_funcao_param 	= nr_sequencia_p;
	 
	if (vl_param_aux_w IS NOT NULL AND vl_param_aux_w::text <> '') then 
		vl_parametro_w := vl_param_aux_w;
	end if;		
end if;
 
/* Obter o parâmetro pelo tipo de acesso ( 'E' - Estipulante/Contratante, 'R' - Rede Própria, 'B' - Beneficiário, 'P' - Prestadores )  */
 
if (coalesce(vl_parametro_w::text, '') = '' and (ie_tipo_acesso_p IS NOT NULL AND ie_tipo_acesso_p::text <> '') ) then 
	select	max(a.vl_parametro) 
	into STRICT	vl_parametro_w 
	from	pls_web_param_usuario a 
	where	a.cd_funcao = cd_funcao_p 
	and   a.nr_seq_funcao_param = nr_sequencia_p 
	and ((ie_tipo_acesso_p IS NOT NULL AND ie_tipo_acesso_p::text <> '') and upper(a.ie_tipo_acesso) = upper(ie_tipo_acesso_p ));
end if;		
	 
if (coalesce(vl_parametro_w::text, '') = '') then 
	select CASE WHEN coalesce(vl_parametro::text, '') = '' THEN  vl_parametro_padrao  ELSE vl_parametro END  
	into STRICT  vl_parametro_w 
	from  funcao_parametro 
	where cd_funcao  = cd_funcao_p 
	and  nr_sequencia = nr_sequencia_p;
end if;
 
return vl_parametro_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_param_web ( cd_funcao_p bigint, nr_sequencia_p bigint, cd_estabelecimento_p bigint, nr_seq_usu_prestador_p bigint, nr_seq_perfil_web_p bigint, nr_seq_segurado_p bigint, nr_seq_usu_estipulante_p bigint, ie_tipo_acesso_p text, nm_usuario_param_p text, nr_seq_usu_gru_cont_p bigint) FROM PUBLIC;

