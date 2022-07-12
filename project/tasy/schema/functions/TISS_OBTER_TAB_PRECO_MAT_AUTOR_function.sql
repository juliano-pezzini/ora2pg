-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tiss_obter_tab_preco_mat_autor ( nr_seq_mat_autor_p material_autorizado.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, ie_retorno_p text default 'T') RETURNS bigint AS $body$
DECLARE

							
cd_tab_mat_preco_w 		bigint;
ie_origem_preco_w 		bigint;
vl_retorno_w			bigint;
dt_referencia_w			timestamp;

/*
ie_retorno_p
'T' => cd_tab_mat_preco_w
'O' => ie_origem_preco_w

*/
							

BEGIN

	vl_retorno_w := null;
	
	if	coalesce(nr_seq_mat_autor_p, 0) > 0 then
	
	select	max(a.dt_autorizacao)
	into STRICT	dt_referencia_w
	from	autorizacao_convenio a,
		material_autorizado b
	where	b.nr_sequencia = nr_seq_mat_autor_p
	and	b.nr_sequencia = nr_seq_mat_autor_p;

	SELECT * FROM obter_tabela_preco_mat(
				nr_seq_mat_autor_p, nm_usuario_p, cd_tab_mat_preco_w, ie_origem_preco_w, dt_referencia_w
	) INTO STRICT cd_tab_mat_preco_w, ie_origem_preco_w;
	
	
	
	if ie_retorno_p = 'T' then
		vl_retorno_w := cd_tab_mat_preco_w;
	elsif ie_retorno_p = 'O' then
		vl_retorno_w := ie_origem_preco_w;
	end if;
	
	end if;

	
	
	return vl_retorno_w;
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tiss_obter_tab_preco_mat_autor ( nr_seq_mat_autor_p material_autorizado.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, ie_retorno_p text default 'T') FROM PUBLIC;

