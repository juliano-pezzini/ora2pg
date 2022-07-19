-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tre_liberar_agenda (nr_seq_agenda_p bigint, nm_usuario_p text) AS $body$
DECLARE

			    
		 
 
nr_seq_tipo_w			bigint;
quebra_w				varchar(10) := chr(13)||chr(10);	
ds_perfil_w				varchar(4000);	
ds_setor_w				varchar(255);
cd_setor_Atendimento_w	bigint;
cd_perfil_w				bigint;	
ds_comunicado_w			text;
ds_agenda_w				varchar(255);	
dt_inicio_w				timestamp;
dt_termino_w			timestamp;
nm_palestrante_w		varchar(80);
ds_modulo_w				varchar(80);
QT_CARGA_HORARIA_w		double precision;
nr_seq_modulo_w			bigint;	
nm_palestrante_adic_w	varchar(2000);
	
		 
c01 CURSOR FOR 
	SELECT	cd_perfil, 
		cd_setor_atendimento 
	from	tre_regra_envio_comunic 
	where	nr_seq_tipo	= nr_seq_tipo_w;
	
C02 CURSOR FOR 
	SELECT	substr(Obter_descricao_modulo(nr_seq_modulo),1,255), 
		substr(obter_nome_pf(cd_palestrante),1,80), 
		qt_carga_horaria, 
		nr_sequencia 
	from	TRE_AGENDA_MODULO a 
	where	a.nr_seq_agenda	 =nr_seq_agenda_p;
	
C03 CURSOR FOR 
	SELECT	substr(obter_nome_pf(cd_pessoa_fisica),1,80) 
	from	tre_eve_mod_palestrante 
	where	nr_seq_modulo = nr_seq_modulo_w;

BEGIN
begin 
select 	a.nr_seq_tipo, 
	ds_agenda, 
	coalesce(dt_inicio_real,dt_inicio), 
	coalesce(dt_termino_real,dt_termino) 
into STRICT	nr_seq_tipo_w, 
	ds_agenda_w, 
	dt_inicio_w, 
	dt_termino_w 
from	tre_curso a, 
	tre_agenda b 
where	a.nr_sequencia	= b.nr_seq_curso 
and	b.nr_sequencia	= nr_seq_agenda_p;
exception 
	when others then 
		null;
	end;
	 
update 	tre_agenda 
set 	dt_liberacao = clock_timestamp(), 
	nm_usuario  = nm_usuario_p 
where 	nr_sequencia = nr_seq_agenda_p;
 
open C01;
loop 
fetch C01 into	 
	cd_perfil_w, 
	cd_setor_Atendimento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	if (cd_perfil_w IS NOT NULL AND cd_perfil_w::text <> '') then 
		ds_perfil_w	:= ds_perfil_w ||','||cd_perfil_w;
	end if;
	if (cd_setor_Atendimento_w IS NOT NULL AND cd_setor_Atendimento_w::text <> '') then 
		ds_setor_w	:= ds_setor_w ||','||cd_setor_Atendimento_w;
	end if;
	end;
end loop;
close C01;
RAISE NOTICE 'ds_setor_w=%', ds_setor_w;
RAISE NOTICE 'ds_perfil_w=%', ds_perfil_w;
if (ds_setor_w IS NOT NULL AND ds_setor_w::text <> '') or (ds_perfil_w IS NOT NULL AND ds_perfil_w::text <> '') then 
	ds_comunicado_w		:= quebra_w||ds_agenda_w ||quebra_w||quebra_w;
	ds_comunicado_w		:= ds_comunicado_w ||obter_desc_expressao(286964)	||': '/*' Data início: '*/||to_char(dt_inicio_w,'dd/mm/yyyy hh24:mi:ss')||quebra_w;
	ds_comunicado_w		:= ds_comunicado_w ||obter_desc_expressao(287236)	||': '/*' Data término: '*/||to_char(dt_termino_w,'dd/mm/yyyy hh24:mi:ss')||quebra_w;
	ds_comunicado_w		:= ds_comunicado_w||quebra_w||quebra_w;
	ds_comunicado_w		:= ds_comunicado_w || obter_desc_expressao(314230)	||': '/*' Módulos: '*/||quebra_w;
	 
	open C02;
	loop 
	fetch C02 into	 
		ds_modulo_w, 
		nm_palestrante_w, 
		QT_CARGA_HORARIA_w, 
		nr_seq_modulo_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin 
			open C03;
				loop 
				fetch C03 into	 
					nm_palestrante_adic_w;
				EXIT WHEN NOT FOUND; /* apply on C03 */
					begin 
					nm_palestrante_w := nm_palestrante_w+', '+ nm_palestrante_adic_w;
					end;
				end loop;
			close C03;
		 
		ds_comunicado_w	:=	ds_comunicado_w||' - '||ds_modulo_w||obter_desc_expressao(284620)/*' Carga horária: '*/||QT_CARGA_HORARIA_w 
					|| ' Palestrantes: '||nm_palestrante_w ||quebra_w;
		end;
	end loop;
	close C02;
	INSERT INTO comunic_interna(  
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
			ds_perfil_adicional, 
			cd_setor_destino, 
			cd_estab_destino, 
			ds_setor_adicional, 
			dt_liberacao) 
	VALUES (clock_timestamp(), 
		ds_agenda_w, 
		ds_comunicado_w, 
		nm_usuario_p, 
		clock_timestamp(), 
		'N', 
		null, 
		nextval('comunic_interna_seq'), 
		'N', 
		7, 
		substr(ds_perfil_w,2,2000)||',', 
		null, 
		null, 
		substr(ds_setor_w,2,2000)||',', 
		clock_timestamp());
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tre_liberar_agenda (nr_seq_agenda_p bigint, nm_usuario_p text) FROM PUBLIC;

