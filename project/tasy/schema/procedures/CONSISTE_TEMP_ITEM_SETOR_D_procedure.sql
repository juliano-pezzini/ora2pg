-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_temp_item_setor_d ( nr_seq_item_p bigint, qt_temp_inicial_p bigint, qt_temp_min_p bigint, qt_temp_max_p bigint, qt_umidade_p bigint, ds_erro_p INOUT text, nm_usuario_p text, cd_estabelecimento_p bigint, cd_setor_p bigint, ie_gera_comunic_p text, cd_perfil_comunic_p INOUT bigint, ds_observacao_p text, nm_usuario_comunic_p INOUT text, nr_seq_grupo_usuario_p INOUT bigint) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Gerar comunicacao interna para controle de temperatura e umidade do setor.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta: 
[  ]  Objetos do dicionario [ X ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atencao:
-------------------------------------------------------------------------------------------------------------------
Referencias:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
qt_temp_min_w			double precision;
qt_temp_max_w			double precision;
qt_umidade_min_w		double precision;
qt_umidade_max_w		double precision;
ds_mensagem_w			varchar(4000);
cd_perfil_comunic_w		bigint;
ds_perfil_mensagem_w		varchar(4000);
ds_setor_w			varchar(4000);
ds_setor_mensagem_w		varchar(4000);
ds_item_w			varchar(255);
nr_seq_grupo_usuario_w		bigint;
ds_erro_w			varchar(4000);

c01 CURSOR FOR
	SELECT	a.qt_temp_min,
		a.qt_temp_max,
		a.qt_umidade_min,
		a.qt_umidade_max,
		substr(a.ds_mensagem,1,4000) ds_mensagem,
		a.cd_perfil_comunic,
		substr(obter_nome_setor(coalesce(b.cd_setor_atendimento, cd_setor_p)),1,254) ds_setor,
		substr(b.ds_item,1,255) ds_item,
		a.nm_usuario_comunic,
		a.nr_seq_grupo_usuario
	from	item_temp_regra		a,
		item_temperatura	b
	where	b.nr_sequencia	= a.nr_seq_item
	and	a.nr_seq_item	= nr_seq_item_p
	and	coalesce(b.cd_setor_atendimento, coalesce(cd_setor_p, 0))	= coalesce(cd_setor_p, 0);


BEGIN
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
	ds_item_w,
	nm_usuario_comunic_p,
	nr_seq_grupo_usuario_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	ds_setor_mensagem_w	:= ds_setor_w;
	
	if (qt_temp_inicial_p IS NOT NULL AND qt_temp_inicial_p::text <> '') then
		if (qt_temp_inicial_p < qt_temp_min_w) or (qt_temp_inicial_p > qt_temp_max_w) then
			if (coalesce(position(upper(ds_item_w) in upper(ds_erro_w)),0) = 0) then
				ds_erro_w	:= substr(ds_erro_w || chr(13) || chr(10) || wheb_mensagem_pck.get_texto(280907) || ds_item_w || ': ',1,4000);
			end if;

			ds_erro_w	:= substr(ds_erro_w || chr(13) || chr(10) || wheb_mensagem_pck.get_texto(280908) || campo_mascara(qt_temp_inicial_p,2),1,4000);
		end if;
	end if;

	if (qt_temp_min_p IS NOT NULL AND qt_temp_min_p::text <> '') then
		if (qt_temp_min_p < qt_temp_min_w) or (qt_temp_min_p > qt_temp_max_w) then
			if (coalesce(position(upper(ds_item_w) in upper(ds_erro_w)),0) = 0) then
				ds_erro_w	:= substr(ds_erro_w || chr(13) || chr(10) || wheb_mensagem_pck.get_texto(280907) || ds_item_w || ': ',1,4000);
			end if;
			
			ds_erro_w	:= substr(ds_erro_w || chr(13) || chr(10) || wheb_mensagem_pck.get_texto(280909) || campo_mascara(qt_temp_min_p,2),1, 4000);
		end if;
	end if;

	if (qt_temp_max_p IS NOT NULL AND qt_temp_max_p::text <> '') then
		if (qt_temp_max_p < qt_temp_min_w) or (qt_temp_max_p > qt_temp_max_w) then
			if (coalesce(position(upper(ds_item_w) in upper(ds_erro_w)),0) = 0) then
				ds_erro_w	:= substr(ds_erro_w || chr(13) || chr(10) || wheb_mensagem_pck.get_texto(280907) || ds_item_w || ': ',1,4000);
			end if;
			
			ds_erro_w	:= substr(ds_erro_w || chr(13) || chr(10) || wheb_mensagem_pck.get_texto(280910) || campo_mascara(qt_temp_max_p,2),1,4000);
		end if;
	end if;

	if	((qt_umidade_min_w IS NOT NULL AND qt_umidade_min_w::text <> '') or (qt_umidade_max_w IS NOT NULL AND qt_umidade_max_w::text <> '')) and (qt_umidade_p IS NOT NULL AND qt_umidade_p::text <> '') then
		if (qt_umidade_p < qt_umidade_min_w) or (qt_umidade_p > qt_umidade_max_w) then
			if (coalesce(position(upper(ds_item_w) in upper(ds_erro_w)),0) = 0) then
				ds_erro_w	:= substr(ds_erro_w || chr(13) || chr(10) || wheb_mensagem_pck.get_texto(280907) || ds_item_w || ': ',1,4000);
			end if;
			
			ds_erro_w	:= substr(ds_erro_w || chr(13) || chr(10) || wheb_mensagem_pck.get_texto(280911) || campo_mascara(qt_umidade_p,2),1,4000);
		end if;
	end if;

	if (coalesce(ds_erro_w,'X') <> 'X') and (coalesce(ds_item_w,'X') <> 'X') then
		ds_erro_w	:= substr(ds_erro_w || chr(13) || chr(10) || ds_mensagem_w,1,4000);

		if (ds_observacao_p IS NOT NULL AND ds_observacao_p::text <> '') then
			ds_erro_w := substr(ds_erro_w || chr(13) || chr(10) || wheb_mensagem_pck.get_texto(280912) || ds_observacao_p,1,4000);
		end if;
		
		ds_perfil_mensagem_w	:= cd_perfil_comunic_w;
	end if;
end loop;
close c01;

cd_perfil_comunic_p	:= cd_perfil_comunic_w;
nr_seq_grupo_usuario_p	:= nr_seq_grupo_usuario_w;

if	((ds_perfil_mensagem_w IS NOT NULL AND ds_perfil_mensagem_w::text <> '') or (nr_seq_grupo_usuario_w IS NOT NULL AND nr_seq_grupo_usuario_w::text <> '')) and (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') and (coalesce(ie_gera_comunic_p,'N') = 'S') then

	ds_perfil_mensagem_w	:= ds_perfil_mensagem_w || ',';
	
	CALL gerar_comunic_padrao(	clock_timestamp(),
				wheb_mensagem_pck.get_texto(280913, 'DS_SETOR_ATENDIMENTO=' || ds_setor_mensagem_w),
				ds_erro_w,
				nm_usuario_p,
				'N',
				nm_usuario_comunic_p,
				'N',
				null,
				ds_perfil_mensagem_w,
				cd_estabelecimento_p,
				null,
				clock_timestamp(),
				nr_seq_grupo_usuario_w || ',',
				null);
end if;

ds_erro_p	:= substr(ds_erro_w,1,255);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_temp_item_setor_d ( nr_seq_item_p bigint, qt_temp_inicial_p bigint, qt_temp_min_p bigint, qt_temp_max_p bigint, qt_umidade_p bigint, ds_erro_p INOUT text, nm_usuario_p text, cd_estabelecimento_p bigint, cd_setor_p bigint, ie_gera_comunic_p text, cd_perfil_comunic_p INOUT bigint, ds_observacao_p text, nm_usuario_comunic_p INOUT text, nr_seq_grupo_usuario_p INOUT bigint) FROM PUBLIC;
