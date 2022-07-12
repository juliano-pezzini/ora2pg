-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE campos AS (ds_nome_w		varchar(255));


CREATE OR REPLACE FUNCTION obter_usuarios_aniv_admissao ( nr_seq_regra_p text) RETURNS varchar AS $body$
DECLARE

 
 
cd_usuarios_w		varchar(2000);
nm_usuario_w		varchar(40);	
ie_inclui_w		varchar(5);
ie_existe_w		varchar(5);

 
nm_usuario_origem_w	varchar(40);
cd_perfil_origem_w	varchar(40);
cd_setor_origem_w	varchar(40);
ie_geral_origem_w	varchar(40);

nm_usuarios_origem_w	varchar(200);
cd_perfis_origem_w	varchar(200);
cd_setores_origem_w	varchar(200);
ie_gerais_origem_w	varchar(200);
type Vetor is table of campos index by integer;
vt_usuario_w		vetor;

i			integer;
k			integer;

 
C01 CURSOR FOR 
SELECT	nm_usuario_origem, 
	cd_perfil, 
	cd_setor_atendimento, 
	ie_geral	 
from	comunic_aniv_origem 
where	nr_seq_regra 	= nr_seq_regra_p;

 
C02 CURSOR FOR 
SELECT	u.nm_usuario 
from	pessoa_fisica p, 
	usuario u 
where	p.cd_pessoa_fisica 	= u.cd_pessoa_fisica	 
/*and	to_char(trunc(p.dt_nascimento),'DDMM') = to_char(trunc(to_date('23/01/2000','dd/mm/yyyy')),'DDMM'); */
 
and	to_char(trunc(coalesce(p.dt_primeira_admissao,p.dt_admissao_hosp)),'DDMM') = to_char(trunc(clock_timestamp()),'DDMM');

 
 
 

BEGIN 
 
open C01;
i := 0;
loop 
	fetch C01 into 
		nm_usuario_origem_w, 
		cd_perfil_origem_w, 
		cd_setor_origem_w, 
		ie_geral_origem_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
 
	begin 
		if (nm_usuario_origem_w IS NOT NULL AND nm_usuario_origem_w::text <> '') then 
			i := I + 1;
			vt_usuario_w[i].ds_nome_w	:= nm_usuario_origem_w;
		end if;
			if (cd_perfil_origem_w IS NOT NULL AND cd_perfil_origem_w::text <> '') then 
			cd_perfis_origem_w := cd_perfis_origem_w || cd_perfil_origem_w || ',';
		end if;
			if (cd_setor_origem_w IS NOT NULL AND cd_setor_origem_w::text <> '') then 
			cd_setores_origem_w := cd_setores_origem_w || cd_setor_origem_w || ',';
		end if;
			if (ie_geral_origem_w = 'S') then 
			ie_gerais_origem_w := 'S';
		end if;	
	end;
end loop;
close C01;
 
if (cd_perfis_origem_w IS NOT NULL AND cd_perfis_origem_w::text <> '') then 
	cd_perfis_origem_w := substr(cd_perfis_origem_w, 1,(length(cd_perfis_origem_w) - 1));
end if;
 
if (cd_setores_origem_w IS NOT NULL AND cd_setores_origem_w::text <> '') then 
	cd_setores_origem_w := substr(cd_setores_origem_w, 1,(length(cd_setores_origem_w) - 1));
end if;
 
 
open C02;
loop 
	fetch C02 into 
		nm_usuario_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
 
	begin 
		ie_inclui_w := 'N';
 
 
		if (nm_usuario_w IS NOT NULL AND nm_usuario_w::text <> '') then 
			if (ie_gerais_origem_w = 'S') then 
				ie_inclui_w := 'S';
 
			elsif (ie_inclui_w = 'N') then 
				ie_existe_w := 'N';
				FOR k IN 1..i LOOP 				 
					select	coalesce(max('S'),'N') 
					into STRICT	ie_existe_w 
					from	usuario 
					where	nm_usuario = nm_usuario_w 
					and	nm_usuario = vt_usuario_w[k].ds_nome_w;
				 
					if (ie_existe_w = 'S') then 
						ie_inclui_w := 'S';
					end if;
				END LOOP;		
			end if;
		 
 
			if (ie_inclui_w = 'N') then		 
				select	coalesce(max('S'),'N') 
				into STRICT	ie_inclui_w 
				from	usuario_perfil 
				where	nm_usuario = nm_usuario_w 
				and (obter_se_contido(cd_perfil, cd_perfis_origem_w) = 'S');
			end if;
 
			if (ie_inclui_w = 'N') then		 
				select	coalesce(max('S'),'N') 
				into STRICT	ie_inclui_w 
				from	usuario_setor 
				where	nm_usuario_param = nm_usuario_w 
				and (obter_se_contido(cd_setor_atendimento, cd_setores_origem_w) = 'S');
			end if;
			 
	 
			if (ie_inclui_w = 'S') then		 
				cd_usuarios_w := cd_usuarios_w || obter_pessoa_fisica_usuario(nm_usuario_w, 'C') || ',';
			end if;	
		end if;
	end;
end loop;
close C02;
 
if (cd_usuarios_w IS NOT NULL AND cd_usuarios_w::text <> '') then 
	cd_usuarios_w := substr(cd_usuarios_w, 1,(length(cd_usuarios_w) - 1));
end if;
 
 
 
return	cd_usuarios_w;
 
 
end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_usuarios_aniv_admissao ( nr_seq_regra_p text) FROM PUBLIC;
