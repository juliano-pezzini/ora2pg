-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qtd_aval_migr_valor ( nm_usuario_p text, dt_inicial_p timestamp, dt_final_p timestamp) RETURNS varchar AS $body$
DECLARE


ds_avaliacoes_w 	varchar(255);
qt_total_w 		bigint;
qt_avaliacao_w 		integer;
qt_porcentagem_w	integer;


BEGIN
if (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	select	count(ie_avaliacao)
	into STRICT	qt_total_w
	from	w_migracao_ordem_servico
	where	nm_usuario_nrec = nm_usuario_p
	and	(ie_avaliacao IS NOT NULL AND ie_avaliacao::text <> '')
	and	trunc(dt_avaliacao,'dd') between dt_inicial_p and dt_final_p;

	if (qt_total_w IS NOT NULL AND qt_total_w::text <> '') then
		begin
		--qtd total de avaliacoes recebidas;
		ds_avaliacoes_w := lpad(qt_total_w,6,' ');
		-- qtd avaliações de avaliações "Ruim";
		select	count(ie_avaliacao)
		into STRICT	qt_avaliacao_w
		from	w_migracao_ordem_servico
		where	nm_usuario_nrec = nm_usuario_p
		and	ie_avaliacao = 'R'
		and	trunc(dt_avaliacao,'dd') between dt_inicial_p and dt_final_p;
		ds_avaliacoes_w := ds_avaliacoes_w || lpad(qt_avaliacao_w,6, ' ') || ' (' || lpad(round(obter_perc_valor(qt_avaliacao_w, qt_total_w)) || '%',4,' ') || ')';
		-- qtd avaliações de avaliações "Regular";
		select	count(ie_avaliacao)
		into STRICT	qt_avaliacao_w
		from	w_migracao_ordem_servico
		where	nm_usuario_nrec = nm_usuario_p
		and	ie_avaliacao = 'G'
		and	trunc(dt_avaliacao,'dd') between dt_inicial_p and dt_final_p;
		ds_avaliacoes_w := ds_avaliacoes_w || lpad(qt_avaliacao_w,6, ' ') || ' (' || lpad(round(obter_perc_valor(qt_avaliacao_w, qt_total_w)) || '%',4,' ') || ')';
		-- qtd avaliações de avaliações "Boa";
		select	count(ie_avaliacao)
		into STRICT	qt_avaliacao_w
		from	w_migracao_ordem_servico
		where	nm_usuario_nrec = nm_usuario_p
		and	ie_avaliacao = 'B'
		and	trunc(dt_avaliacao,'dd') between dt_inicial_p and dt_final_p;
		ds_avaliacoes_w := ds_avaliacoes_w || lpad(qt_avaliacao_w,6, ' ') || ' (' || lpad(round(obter_perc_valor(qt_avaliacao_w, qt_total_w)) || '%',4,' ') || ')';
		-- qtd avaliações de avaliações "Ótima";
		select	count(ie_avaliacao)
		into STRICT	qt_avaliacao_w
		from	w_migracao_ordem_servico
		where	nm_usuario_nrec = nm_usuario_p
		and	ie_avaliacao = 'O'
		and	trunc(dt_avaliacao,'dd') between dt_inicial_p and dt_final_p;
		ds_avaliacoes_w := ds_avaliacoes_w || lpad(qt_avaliacao_w,6, ' ') || ' (' || lpad(round(obter_perc_valor(qt_avaliacao_w, qt_total_w)) || '%',4,' ') || ')';
		-- qtd avaliações de avaliações "Não se aplica";
		select	count(ie_avaliacao)
		into STRICT	qt_avaliacao_w
		from	w_migracao_ordem_servico
		where	nm_usuario_nrec = nm_usuario_p
		and	ie_avaliacao = 'N'
		and	trunc(dt_avaliacao,'dd') between dt_inicial_p and dt_final_p;
		ds_avaliacoes_w := ds_avaliacoes_w || lpad(qt_avaliacao_w,6, ' ') || ' (' || lpad(round(obter_perc_valor(qt_avaliacao_w, qt_total_w)) || '%',4,' ') || ')';
		end;
	end if;
	end;
end if;
return ds_avaliacoes_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qtd_aval_migr_valor ( nm_usuario_p text, dt_inicial_p timestamp, dt_final_p timestamp) FROM PUBLIC;
