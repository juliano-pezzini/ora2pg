-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hd_agenda_conc ( cd_pessoa_fisica_p text, ie_classificacao_p text, cd_estabelecimento_p bigint, nm_usuario_p text, cd_perfil_p bigint, cd_setor_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

			 
cd_agenda_w		bigint;
cd_agenda_conc_w	varchar(2000);			
			 
C01 CURSOR FOR 
	SELECT		a.cd_agenda			 
	from   	med_permissao b, 
			agenda a 
	where  	a.cd_tipo_agenda = 5 
	and   	a.cd_agenda   = b.cd_agenda 
	and   	b.cd_pessoa_fisica = cd_pessoa_fisica_p 
	and   	b.ie_agenda    <> 'N' 
	and   	((a.ie_classificacao  = ie_classificacao_p) or (ie_classificacao_p = 'A')) 
	and   	a.ie_situacao = 'A' 
	and   	((a.cd_estabelecimento = cd_estabelecimento_p) or (cd_estabelecimento_p = 0 and 
							 a.cd_estabelecimento in (SELECT x.cd_estabelecimento 
										 from  usuario_estabelecimento x 
										 where x.nm_usuario_param = nm_usuario_p))) 
	
union
 
	select		a.cd_agenda					 
	from   	med_permissao b, 
			agenda a 
	where  	a.cd_tipo_agenda = 5 
	and   	a.cd_agenda   = b.cd_agenda 
	and   	b.cd_perfil  = cd_perfil_p 
	and   	b.ie_agenda    <> 'N' 
	and   	((a.ie_classificacao  = ie_classificacao_p) or (ie_classificacao_p = 'A')) 
	and   	a.ie_situacao = 'A' 
	and   	((a.cd_estabelecimento = cd_estabelecimento_p) or (cd_estabelecimento_p = 0 and 
							 a.cd_estabelecimento in (select x.cd_estabelecimento 
										 from  usuario_estabelecimento x 
										 where x.nm_usuario_param = nm_usuario_p))) 
	
union
 
	select		a.cd_agenda			 
	from   	med_permissao b, 
			agenda a 
	where  	a.cd_tipo_agenda = 5 
	and   	a.cd_agenda   = b.cd_agenda 
	and   	b.cd_setor_atendimento = cd_setor_atendimento_p 
	and   	b.ie_agenda    <> 'N' 
	and   	((a.ie_classificacao  = ie_classificacao_p) or (ie_classificacao_p = 'A')) 
	and   	a.ie_situacao = 'A' 
	and   	((a.cd_estabelecimento = cd_estabelecimento_p) or (cd_estabelecimento_p = 0 and 
							 a.cd_estabelecimento in (select x.cd_estabelecimento 
										 from  usuario_estabelecimento x 
										 where x.nm_usuario_param = nm_usuario_p))) 
	
union
 
	select		cd_agenda		 
	from   	agenda a 
	where  	cd_tipo_agenda = 5 
	and   	((a.ie_classificacao  = ie_classificacao_p) or (ie_classificacao_p = 'A')) 
	and   	a.ie_situacao = 'A' 
	and   	a.ie_situacao = 'A' 
	and not exists (select 1 
		from 	med_permissao 
		where	cd_agenda	= a.cd_agenda) 
	and   ((a.cd_estabelecimento = cd_estabelecimento_p) or (cd_estabelecimento_p = 0 and 
							 a.cd_estabelecimento in (select x.cd_estabelecimento 
										 from  usuario_estabelecimento x 
										 where x.nm_usuario_param = nm_usuario_p))) 
	order by cd_agenda;

BEGIN
open C01;
loop 
fetch C01 into	 
	cd_agenda_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	cd_agenda_conc_w := cd_agenda_w||','||cd_agenda_conc_w;
	end;
end loop;
close C01;
 
return	cd_agenda_conc_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hd_agenda_conc ( cd_pessoa_fisica_p text, ie_classificacao_p text, cd_estabelecimento_p bigint, nm_usuario_p text, cd_perfil_p bigint, cd_setor_atendimento_p bigint) FROM PUBLIC;
