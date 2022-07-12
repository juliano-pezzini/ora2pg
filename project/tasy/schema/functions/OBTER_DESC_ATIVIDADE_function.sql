-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_atividade (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w		varchar(2000);

cd_tipo_w		desenv_atividade.cd_tipo%type;
nm_pessoa_fisica_w	pessoa_fisica.nm_pessoa_fisica%type;
nr_story_w		desenv_atividade.nr_story%type;
nm_sprint_w		desenv_sprint.nm_sprint%type;
ds_story_w		desenv_story.ds_story%type;
nr_sprint_destino_w	desenv_atividade.nr_sprint_destino%type;
		

BEGIN 
 
select	cd_tipo, 
	obter_pessoa_fisica_usuario(nm_usuario,'N'), 
	nr_story, 
	nr_sprint_destino 
into STRICT	cd_tipo_w, 
	nm_pessoa_fisica_w, 
	nr_story_w, 
	nr_sprint_destino_w 
from	desenv_atividade 
where	nr_sequencia = nr_sequencia_p;
 
if (cd_tipo_w = 'SC') then --User story criada	 
	select	substr(max(ds_story),0,100), 
		coalesce(max(b.nm_sprint),'Backlog') 
	into STRICT	ds_story_w, 
		nm_sprint_w 
	FROM desenv_story a, desenv_story_sprint c
LEFT OUTER JOIN desenv_sprint b ON (c.nr_sprint = b.nr_sequencia)
WHERE a.nr_sequencia = c.nr_story and a.nr_sequencia = nr_story_w;
	 
	ds_retorno_w := nm_pessoa_fisica_w || ' created the Story ' || ds_story_w || ' in ' || nm_sprint_w;
elsif (cd_tipo_w = 'SP') then --User story planejada (atribuída a um Sprint)	 
	select	substr(max(ds_story),0,100), 
		coalesce(max(b.nm_sprint),'Backlog') 
	into STRICT	ds_story_w, 
		nm_sprint_w 
	FROM desenv_story a, desenv_story_sprint c
LEFT OUTER JOIN desenv_sprint b ON (c.nr_sprint = b.nr_sequencia)
WHERE a.nr_sequencia = c.nr_story and a.nr_sequencia = nr_story_w;
 
	ds_retorno_w := nm_pessoa_fisica_w || ' moved the Story ' || ds_story_w || ' to ' || coalesce(nm_sprint_w,'Backlog');
elsif (cd_tipo_w = 'SD') then --User story excluída 
	select	substr(ds_story,0,100) 
	into STRICT	ds_story_w 
	from	desenv_story a 
	where	a.nr_sequencia = nr_story_w;
	 
	ds_retorno_w := nm_pessoa_fisica_w || ' deleted the Story ' || ds_story_w;
elsif (cd_tipo_w = 'SU') then --User story alterada 
	select	substr(ds_story,0,100) 
	into STRICT	ds_story_w 
	from	desenv_story a 
	where	a.nr_sequencia = nr_story_w;
	 
	ds_retorno_w := nm_pessoa_fisica_w || ' changed the Story ' || ds_story_w;
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_atividade (nr_sequencia_p bigint) FROM PUBLIC;
