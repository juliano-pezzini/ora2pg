-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_terminar_verif_stories ( nr_feature_p bigint, nr_sprint_p bigint, cd_estabelecimento_p bigint, cd_pessoa_fisica_p bigint, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE

		 
qt_stories_w		bigint;
nr_ordem_servico_w	bigint;

c01 CURSOR FOR 
	SELECT	a.nr_story, 
		a.nr_sprint 
	from	desenv_story_sprint a, 
		desenv_story b 
	where	a.nr_story = b.nr_sequencia 
	and	a.nr_sprint = nr_sprint_p 
	and	b.nr_feature = nr_feature_p 
	and	a.cd_status = 2;
	
v01	c01%rowtype;
		

BEGIN 
 
select	count(*) 
into STRICT	qt_stories_w 
from	desenv_story_sprint a, 
	desenv_story b 
where	a.nr_story = b.nr_sequencia 
and	a.nr_sprint = nr_sprint_p 
and	b.nr_feature = nr_feature_p 
and	a.cd_status < 2;
 
if (qt_stories_w > 0) then 
	ds_erro_p := wheb_mensagem_pck.get_texto(362587);
	return;
end if;
 
open c01;
loop 
fetch c01 into	 
	v01;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	 
	SELECT * FROM man_alterar_status_story(v01.nr_story, v01.nr_sprint, 3, cd_pessoa_fisica_p, nm_usuario_p, cd_estabelecimento_p, ds_erro_p, nr_ordem_servico_w, 'N') INTO STRICT ds_erro_p, nr_ordem_servico_w;
			 
	if (ds_erro_p IS NOT NULL AND ds_erro_p::text <> '') then 
		rollback;
		return;
	end if;
	end;
end loop;
close c01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_terminar_verif_stories ( nr_feature_p bigint, nr_sprint_p bigint, cd_estabelecimento_p bigint, cd_pessoa_fisica_p bigint, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;
