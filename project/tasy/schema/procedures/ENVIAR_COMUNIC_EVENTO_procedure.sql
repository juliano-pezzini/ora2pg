-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function enviar_comunic_evento as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE PROCEDURE enviar_comunic_evento ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

BEGIN
	v_query := 'CALL enviar_comunic_evento_atx ( ' || quote_nullable(nr_sequencia_p) || ',' || quote_nullable(nm_usuario_p) || ' )';
	PERFORM * FROM dblink(v_conn_str, v_query) AS p (ret boolean);

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE PROCEDURE enviar_comunic_evento_atx ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE

			 
nr_seq_evento_w		bigint;
ds_evento_w		varchar(4000);
ds_mensagem_w		varchar(32000);
nm_paciente_w		varchar(250);
quebra_w			varchar(10)	:= chr(13)||chr(10);
ds_perfis_w		varchar(4000);
ds_setores_w		varchar(4000);
ds_usuarios_w		varchar(4000);
cd_perfil_w		bigint;
ds_titulo_w		varchar(255);
nr_atendimento_w		bigint;
IE_CLASSIFICACAO_w	varchar(10);
cd_empresa_w		bigint;
ds_setor_Atendimento_w	varchar(255);
cd_setor_atendimento_w	integer;
nm_usuario_destino_w	varchar(255);
cd_setor_evento_w		integer;
ds_classif_evento_w	varchar(255);
ds_grupo_w		varchar(255);
nr_seq_grupo_usu_w	bigint;

C01 CURSOR FOR 
	SELECT	cd_perfil, 
		cd_setor_atendimento, 
		nm_usuario_destino, 
		nr_seq_grupo_usuario 
	from	qua_evento_comunic 
	where	nr_seq_evento	= nr_seq_evento_w 
	and	coalesce(cd_setor_evento,coalesce(cd_setor_evento_w,0)) = coalesce(cd_setor_evento_w,0);
BEGIN
begin 
select	nr_seq_evento, 
	ds_evento, 
	obter_nome_pf(cd_pessoa_fisica), 
	nr_atendimento, 
	ie_classificacao, 
	obter_empresa_estab(cd_estabelecimento), 
	obter_nome_setor(cd_setor_atendimento), 
	cd_setor_atendimento, 
	obter_desc_evento_classif(nr_seq_classif_evento) 
into STRICT	nr_seq_evento_w, 
	ds_evento_w, 
	nm_paciente_w, 
	nr_atendimento_w, 
	ie_classificacao_w, 
	cd_empresa_w, 
	ds_setor_atendimento_w, 
	cd_setor_evento_w, 
	ds_classif_evento_w 
from	qua_evento_paciente 
where	nr_sequencia	= nr_sequencia_p;
 
open C01;
loop 
fetch C01 into	 
	cd_perfil_w, 
	cd_setor_atendimento_w, 
	nm_usuario_destino_w, 
	nr_seq_grupo_usu_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	if (coalesce(cd_perfil_w,0) > 0) then 
		ds_perfis_w	:= substr(cd_perfil_w ||','|| ds_perfis_w,1,4000);
	end if;
	if (coalesce(cd_setor_atendimento_w,0) > 0) then 
		ds_setores_w	:= substr(cd_setor_atendimento_w ||','|| ds_setores_w,1,4000);
	end if;
	if (coalesce(nm_usuario_destino_w,'X') <> 'X') then 
		ds_usuarios_w	:= substr(nm_usuario_destino_w ||','|| ds_usuarios_w,1,4000);
	end if;
	if (coalesce(nr_seq_grupo_usu_w,0) > 0) then 
		ds_grupo_w	:= substr(nr_seq_grupo_usu_w ||','|| ds_grupo_w,1,255);
	end if;
	end;
end loop;
close C01;
 
ds_titulo_w	:= 	wheb_mensagem_pck.get_texto(305960,'nm_paciente_w=' || nm_paciente_w);
ds_mensagem_w	:= wheb_mensagem_pck.get_texto(305961, 'nm_paciente_w=' || nm_paciente_w || ';quebra_w=' || quebra_w);
ds_mensagem_w	:= wheb_mensagem_pck.get_texto(305965,'ds_mensagem_w=' || ds_mensagem_w ||';nr_atendimento_w='|| nr_atendimento_w|| ';quebra_w=' || quebra_w ||';quebra_w=' || quebra_w);
ds_mensagem_w	:= wheb_mensagem_pck.get_texto(306255,'ds_mensagem_w=' || ds_mensagem_w || ';ds_setor_atendimento_w=' || ds_setor_atendimento_w ||';quebra_w='||quebra_w ||';quebra_w='||quebra_w);
ds_mensagem_w	:= wheb_mensagem_pck.get_texto(305969,'ds_mensagem_w=' || ds_mensagem_w)||substr(obter_descricao_padrao('QUA_EVENTO','DS_EVENTO',NR_SEQ_EVENTO_w),1,100) ||quebra_w;
if (ie_classificacao_w IS NOT NULL AND ie_classificacao_w::text <> '') then 
	ds_mensagem_w	:= ds_mensagem_w|| ' ' ||wheb_mensagem_pck.get_texto(306007)|| ' '||obter_desc_classif_evento(ie_classificacao_w,cd_empresa_w)||quebra_w;
end if;
if (ds_classif_evento_w IS NOT NULL AND ds_classif_evento_w::text <> '') then 
	ds_mensagem_w	:= ds_mensagem_w|| ' '||wheb_mensagem_pck.get_texto(306009) || ' '||ds_classif_evento_w||quebra_w;
end if;
 
ds_mensagem_w	:= ds_mensagem_w||quebra_w;
 
ds_mensagem_w	:= ds_mensagem_w|| ' ' ||wheb_mensagem_pck.get_texto(306012)|| ' '||DS_EVENTO_w;
 
 
if (ds_perfis_w IS NOT NULL AND ds_perfis_w::text <> '') or (ds_setores_w IS NOT NULL AND ds_setores_w::text <> '') or (ds_usuarios_w IS NOT NULL AND ds_usuarios_w::text <> '') or (ds_grupo_w IS NOT NULL AND ds_grupo_w::text <> '') then 
	insert into 	comunic_interna(  
			dt_comunicado, 
			ds_titulo, 
			ds_comunicado, 
			nm_usuario, 
			dt_atualizacao, 
			ie_geral, 
			nm_usuario_destino, 
			nr_sequencia, 
			ie_gerencial, 
			nr_seq_classif, 
			cd_perfil, 
			cd_setor_destino, 
			cd_estab_destino, 
			ds_setor_adicional, 
			dt_liberacao, 
			ds_perfil_adicional, 
			ds_grupo) 
		values (clock_timestamp(), 
			ds_titulo_w, 
			ds_mensagem_w, 
			nm_usuario_p, 
			clock_timestamp(), 
			'N', 
			ds_usuarios_w, 
			nextval('comunic_interna_seq'), 
			'N', 
			7, 
			null, 
			null, 
			null, 
			ds_setores_w, 
			clock_timestamp(), 
			ds_perfis_w, 
			ds_grupo_w);
end if;
 
/*exception 
	when others then 
	null;*/
 
end;
 
commit;
 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE enviar_comunic_evento ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC; -- REVOKE ALL ON PROCEDURE enviar_comunic_evento_atx ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
