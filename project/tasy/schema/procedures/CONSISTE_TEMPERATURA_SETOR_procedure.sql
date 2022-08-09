-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_temperatura_setor ( cd_setor_atendimento_p bigint, nr_seq_turno_p bigint, qt_temp_inicial_p bigint, qt_temp_min_p bigint, qt_temp_max_p bigint, qt_umidade_p bigint, ds_erro_p INOUT text, nm_usuario_p text, cd_estabelecimento_p bigint, ie_gera_comunic_p text, ds_observacao_p text) AS $body$
DECLARE


qt_temp_min_w				double precision;
qt_temp_max_w				double precision;
qt_umidade_min_w				double precision;
qt_umidade_max_w				double precision;
ds_mensagem_w				varchar(4000);
ds_setor_w				varchar(4000);
cd_perfil_comunic_w			varchar(4000);
ds_erro_w				varchar(4000);
nm_usuario_destino_w			varchar(2000);

c01 CURSOR FOR
SELECT	qt_temp_min,
	qt_temp_max,
	qt_umidade_min,
	qt_umidade_max,
	ds_mensagem,
	cd_perfil_comunic,
	substr(obter_nome_setor(cd_setor_atendimento),1,254) ds_setor,
	nm_usuario_destino
from	turno_temp_setor
where	cd_setor_atendimento	= cd_setor_atendimento_p
and	nr_seq_turno		= nr_seq_turno_p;


BEGIN

ds_erro_w := ds_erro_p;

open c01;
loop
fetch c01 into
	qt_temp_min_w,
	qt_temp_max_w,
	qt_umidade_min_w,
	qt_umidade_max_w,
	ds_mensagem_w,
	cd_perfil_comunic_w,
	ds_setor_w,
	nm_usuario_destino_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	cd_perfil_comunic_w	:= cd_perfil_comunic_w;
	ds_setor_w		:= ds_setor_w;
	if (qt_temp_inicial_p IS NOT NULL AND qt_temp_inicial_p::text <> '') then
		if (qt_temp_inicial_p	< qt_temp_min_w) or (qt_temp_inicial_p	> qt_temp_max_w) then
			ds_erro_w		:= substr(WHEB_MENSAGEM_PCK.get_texto(279817) || campo_mascara(qt_temp_inicial_p,2) || ' ' || chr(13) || chr(10) ||
							ds_mensagem_w, 1, 3999);
			if (ds_observacao_p IS NOT NULL AND ds_observacao_p::text <> '') then
				ds_erro_w := substr(ds_erro_w || chr(13) || chr(10) || WHEB_MENSAGEM_PCK.get_texto(279818) || ds_observacao_p, 1, 3999);
			end if;

		end if;
	end if;

	if (qt_temp_min_p IS NOT NULL AND qt_temp_min_p::text <> '') then
		if (qt_temp_min_p	< qt_temp_min_w) or (qt_temp_min_p	> qt_temp_max_w) then
			ds_erro_w		:= substr(WHEB_MENSAGEM_PCK.get_texto(279819) || campo_mascara(qt_temp_min_p,2) || ' ' || chr(13) || chr(10) ||
							ds_mensagem_w, 1, 3999);
			if (ds_observacao_p IS NOT NULL AND ds_observacao_p::text <> '') then
				ds_erro_w := substr(ds_erro_w || chr(13) || chr(10) ||WHEB_MENSAGEM_PCK.get_texto(279818) || ds_observacao_p, 1, 3999);
			end if;
		end if;
	end if;

	if (qt_temp_max_p IS NOT NULL AND qt_temp_max_p::text <> '') then
		if (qt_temp_max_p	< qt_temp_min_w) or (qt_temp_max_p	> qt_temp_max_w) then
			ds_erro_w		:= substr(WHEB_MENSAGEM_PCK.get_texto(279821) || campo_mascara(qt_temp_max_p,2) || ' ' || chr(13) || chr(10) ||
							ds_mensagem_w, 1, 3999);
			if (ds_observacao_p IS NOT NULL AND ds_observacao_p::text <> '') then
				ds_erro_w := substr(ds_erro_w || chr(13) || chr(10) || WHEB_MENSAGEM_PCK.get_texto(279818) || ds_observacao_p, 1, 3999);
			end if;
		end if;
	end if;

	if	((qt_umidade_min_w IS NOT NULL AND qt_umidade_min_w::text <> '') or (qt_umidade_max_w IS NOT NULL AND qt_umidade_max_w::text <> '')) and (qt_umidade_p IS NOT NULL AND qt_umidade_p::text <> '') then
		if (qt_umidade_p	< qt_umidade_min_w) or (qt_umidade_p	> qt_umidade_max_w) then
			ds_erro_w		:= substr(WHEB_MENSAGEM_PCK.get_texto(279822) || campo_mascara(qt_umidade_p,2) || ' ' || chr(13) || chr(10) ||
							ds_mensagem_w, 1, 3999);
			if (ds_observacao_p IS NOT NULL AND ds_observacao_p::text <> '') then
				ds_erro_w := substr(ds_erro_w || chr(13) || chr(10) || WHEB_MENSAGEM_PCK.get_texto(279818) || ds_observacao_p, 1, 3999);
			end if;
		end if;
	end if;

end loop;
close c01;

if	((cd_perfil_comunic_w IS NOT NULL AND cd_perfil_comunic_w::text <> '') or (coalesce(nm_usuario_destino_w,'X') <> 'X')) and (coalesce(ds_erro_w,'X') <> 'X') and (ie_gera_comunic_p = 'S') then

	cd_perfil_comunic_w	:= cd_perfil_comunic_w || ',';

	CALL GERAR_COMUNIC_PADRAO(clock_timestamp(),
				WHEB_MENSAGEM_PCK.get_texto(279824) || ds_setor_w,
				ds_erro_w,
				nm_usuario_p,
				'N',
				nm_usuario_destino_w,
				'N',
				null,
				cd_perfil_comunic_w,
				cd_estabelecimento_p,
				null,
				clock_timestamp(),
				null,
				null);
end if;

ds_erro_p := substr(ds_erro_w,1,255);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_temperatura_setor ( cd_setor_atendimento_p bigint, nr_seq_turno_p bigint, qt_temp_inicial_p bigint, qt_temp_min_p bigint, qt_temp_max_p bigint, qt_umidade_p bigint, ds_erro_p INOUT text, nm_usuario_p text, cd_estabelecimento_p bigint, ie_gera_comunic_p text, ds_observacao_p text) FROM PUBLIC;
