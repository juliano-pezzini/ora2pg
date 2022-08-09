-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE qt_enviar_ci_exclusao_trat ( nr_seq_Atendimento_p bigint, dt_tratamento_p timestamp, nm_usuario_p text) AS $body$
DECLARE

 
cd_perfil_w				integer;
ds_lista_perfil_w		varchar(4000);
ds_titulo_w				varchar(255);
ds_comunicado_w			varchar(4000);
count_w					bigint;
nm_paciente_w			varchar(60);
ds_pessoa_destino_w		varchar(4000);
ds_setor_destino_w		varchar(4000);
qt_regra_w				bigint;
cd_pessoa_fisica_w		varchar(15);
cd_setor_atendimento_w 	bigint;

c01 CURSOR FOR 
SELECT	a.cd_perfil 
from	funcao_perfil a, 
		perfil b 
where	a.cd_perfil	= b.cd_perfil 
and		b.ie_situacao	= 'A' 
and		cd_funcao	= 865;

C02 CURSOR FOR 
	SELECT	obter_usuario_pf(cd_pessoa_fisica), 
			cd_perfil, 
			cd_setor_atendimento 
	from	qt_envio_ci_exclusao;
		

BEGIN 
 
select	count(*) 
into STRICT	qt_regra_w 
from	qt_envio_ci_exclusao;
 
if (qt_regra_w	> 0) then 
	open C02;
	loop 
	fetch C02 into	 
		cd_pessoa_fisica_w, 
		cd_perfil_w, 
		cd_setor_atendimento_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin 
 
		if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then 
			ds_pessoa_destino_w	:= substr(ds_pessoa_destino_w ||cd_pessoa_fisica_w||', ',1,4000);
		end if;
 
		if (cd_perfil_w IS NOT NULL AND cd_perfil_w::text <> '') then 
			ds_lista_perfil_w	:= substr(ds_lista_perfil_w ||cd_perfil_w||', ',1,4000);
		end if;
 
		if (cd_setor_atendimento_w IS NOT NULL AND cd_setor_atendimento_w::text <> '') then 
			ds_setor_destino_w	:= substr(ds_setor_destino_w ||cd_setor_atendimento_w||', ',1,4000);
		end if;
		 
		end;
	end loop;
	close C02;
else 
	open c01;
	loop 
	fetch c01 into 
		cd_perfil_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin 
		 
		if (ds_lista_perfil_w IS NOT NULL AND ds_lista_perfil_w::text <> '') then	 
			ds_lista_perfil_w := substr(ds_lista_perfil_w || ', ',1,4000);
		end if;	
		 
		ds_lista_perfil_w	:= substr(ds_lista_perfil_w || cd_perfil_w,1,4000);	
		 
		end;
	end loop;
	close c01;
end if;
 
if (ds_lista_perfil_w IS NOT NULL AND ds_lista_perfil_w::text <> '') or (qt_regra_w	> 0)	then 
	 
	select	max(SUBSTR(OBTER_NOME_PF(a.CD_PESSOA_FISICA),0,60)) 
	into STRICT	nm_paciente_w 
	from	pessoa_Fisica a, 
			paciente_atendimento b, 
			paciente_setor c 
	where	a.cd_pessoa_fisica	= c.cd_pessoa_fisica 
	and		b.nr_seq_paciente	= c.nr_seq_paciente 
	and		b.nr_seq_atendimento	= nr_seq_atendimento_p;
 
	insert into comunic_interna(  
		dt_comunicado, 
		ds_titulo, 
		ds_comunicado, 
		nm_usuario, 
		dt_atualizacao, 
		nr_sequencia, 
		ie_gerencial, 
		dt_liberacao,		 
		ds_perfil_adicional, 
		ds_setor_adicional, 
		nm_usuario_destino) 
	values (clock_timestamp(), 
		' ' || wheb_mensagem_pck.get_texto(795686), 
		' ' || wheb_mensagem_pck.get_texto(795690) || ' ' || to_char(dt_tratamento_p,'dd/mm/yyyy') || chr(10) || 
		' ' || wheb_mensagem_pck.get_texto(795685) || ' ' || nm_paciente_w || chr(10) || 
		' ' || wheb_mensagem_pck.get_texto(795691) || ' ' || nm_usuario_p || chr(10), 
		nm_usuario_p, 
		clock_timestamp(), 
		nextval('comunic_interna_seq'), 
		'N', 
		clock_timestamp(), 
		ds_lista_perfil_w, 
		ds_setor_destino_w, 
		ds_pessoa_destino_w);
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qt_enviar_ci_exclusao_trat ( nr_seq_Atendimento_p bigint, dt_tratamento_p timestamp, nm_usuario_p text) FROM PUBLIC;
