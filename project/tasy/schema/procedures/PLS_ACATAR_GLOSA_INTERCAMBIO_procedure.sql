-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_acatar_glosa_intercambio ( nr_seq_contest_p bigint, nr_seq_proc_contest_p bigint, nr_seq_mat_contest_p bigint, nr_seq_discussao_p bigint, nr_seq_proc_disc_p bigint, nr_seq_mat_disc_p bigint, nr_seq_motivo_aceite_p bigint, cd_centro_custo_p bigint, nm_usuario_p usuario.nm_usuario%type, vl_prestador_p bigint, ds_observacao_p text, vl_assumido_p bigint, cd_centro_custo_desc_p bigint, cd_centro_custo_aceite_p bigint, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE

 
ie_procedimento_w		varchar(1);
ie_material_w			varchar(1);
ie_conta_w			varchar(1);
nr_seq_material_w		bigint;
nr_seq_procedimento_w		bigint;
qt_item_w			double precision;
vl_item_w			double precision;
nr_seq_motivo_glosa_aceita_w	bigint;
nr_sequencia_w			bigint;
ie_tipo_w			varchar(1);
qt_registro_w			bigint;
nr_seq_discussao_w		bigint;
nr_seq_lote_w			pls_lote_discussao.nr_sequencia%type;
ie_status_w			pls_lote_discussao.ie_status%type;
qt_evento_w			integer;
ie_desconta_prestador_w		pls_motivo_glosa_aceita.ie_desconta_prestador%type;
nr_seq_lote_contest_w		pls_lote_discussao.nr_seq_lote_contest%type;
ie_parametro_16_w		varchar(255);
vl_aceito_w			double precision;
nr_seq_conta_proc_w		pls_discussao_proc.nr_seq_conta_proc%type;
nr_seq_conta_mat_w		pls_discussao_mat.nr_seq_conta_mat%type;
vl_prestador_w			double precision;
vl_liberado_w			double precision;
vl_assumido_w			double precision;

C01 CURSOR FOR /* Cursor para pegar os itens da CONTESTAÇÃO */
 
	SELECT	'P' ie_tipo, 
		a.nr_sequencia 
	from	pls_contestacao		c, 
		pls_contestacao_proc	a 
	where	a.nr_seq_contestacao	= c.nr_sequencia 
	and	c.nr_sequencia		= nr_seq_contest_p 
	
union
 
	SELECT	'M' ie_tipo, 
		a.nr_sequencia 
	from	pls_contestacao		c, 
		pls_contestacao_mat	a 
	where	a.nr_seq_contestacao	= c.nr_sequencia 
	and	c.nr_sequencia		= nr_seq_contest_p;

C02 CURSOR FOR /* Cursor para pegar os itens da DISCUSSÃO */
 
	SELECT	'P' ie_tipo, 
		a.nr_sequencia 
	from	pls_contestacao_discussao	c, 
		pls_discussao_proc		a 
	where	a.nr_seq_discussao		= c.nr_sequencia 
	and	c.nr_sequencia			= nr_seq_discussao_p 
	
union
 
	SELECT	'M' ie_tipo, 
		a.nr_sequencia 
	from	pls_contestacao_discussao	c, 
		pls_discussao_mat		a 
	where	a.nr_seq_discussao		= c.nr_sequencia 
	and	c.nr_sequencia			= nr_seq_discussao_p;


BEGIN 
ie_parametro_16_w := Obter_Param_Usuario(1334, 16, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_parametro_16_w);
 
select	ie_procedimento, 
	ie_material, 
	ie_conta, 
	nr_sequencia, 
	ie_desconta_prestador 
into STRICT	ie_procedimento_w, 
	ie_material_w, 
	ie_conta_w, 
	nr_seq_motivo_glosa_aceita_w, 
	ie_desconta_prestador_w 
from	pls_motivo_glosa_aceita 
where	nr_sequencia = nr_seq_motivo_aceite_p;
 
if (nr_seq_contest_p IS NOT NULL AND nr_seq_contest_p::text <> '') and (coalesce(nr_seq_proc_contest_p::text, '') = '') and (coalesce(nr_seq_mat_contest_p::text, '') = '') then /* Se for conta em contestação */
 
	if (ie_conta_w = 'S') then 
		open C01;
		loop 
		fetch C01 into 
			ie_tipo_w, 
			nr_sequencia_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin 
			if (ie_tipo_w = 'M') then /* Material da contestação */
 
				if (ie_material_w = 'S') then 
					select	coalesce(vl_contestado,0), 
						coalesce(qt_contestada,0) 
					into STRICT	vl_item_w, 
						qt_item_w 
					from	pls_contestacao_mat 
					where	nr_sequencia = nr_sequencia_w;
					 
					update	pls_contestacao_mat 
					set	vl_aceito 			= vl_item_w, 
						qt_aceita 			= qt_item_w, 
						nr_seq_motivo_glosa_aceita	= nr_seq_motivo_glosa_aceita_w, 
						nr_seq_motivo_glosa_neg		 = NULL, 
						nm_usuario			= nm_usuario_p, 
						dt_atualizacao			= clock_timestamp() 
					where	nr_sequencia 			= nr_sequencia_w;
				else 
					CALL wheb_mensagem_pck.exibir_mensagem_abort(189147);
				end if;
			elsif (ie_tipo_w = 'P') then		/* Procedimento da contestação */
 
				if (ie_procedimento_w = 'S') then 
					 
					select	coalesce(qt_contestada,0), 
						coalesce(vl_contestado,0) 
					into STRICT	qt_item_w, 
						vl_item_w 
					from	pls_contestacao_proc 
					where	nr_sequencia = nr_sequencia_w;
					 
					update	pls_contestacao_proc 
					set	vl_aceito			= vl_item_w, 
						qt_aceita			= qt_item_w, 
						nr_seq_motivo_glosa_aceita	= nr_seq_motivo_glosa_aceita_w, 
						nr_seq_motivo_glosa_neg		 = NULL, 
						nm_usuario			= nm_usuario_p, 
						dt_atualizacao			= clock_timestamp() 
					where	nr_sequencia			= nr_sequencia_w;
				else 
					CALL wheb_mensagem_pck.exibir_mensagem_abort(189148);
				end if;
			else 
				CALL wheb_mensagem_pck.exibir_mensagem_abort(189149);
			end if;
			end;
		end loop;
		close C01;
	else 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(189150);
	end if;
end if;
 
if (nr_seq_proc_contest_p IS NOT NULL AND nr_seq_proc_contest_p::text <> '') then /* Se for procedimento em contestação */
 
	if (ie_procedimento_w = 'S') then 
		select	coalesce(qt_contestada,0), 
			coalesce(vl_contestado,0) 
		into STRICT	qt_item_w, 
			vl_item_w 
		from	pls_contestacao_proc 
		where	nr_sequencia = nr_seq_proc_contest_p;
		 
		update	pls_contestacao_proc 
		set	vl_aceito			= vl_item_w, 
			qt_aceita			= qt_item_w, 
			nr_seq_motivo_glosa_aceita	= nr_seq_motivo_glosa_aceita_w, 
			nr_seq_motivo_glosa_neg		 = NULL, 
			nm_usuario			= nm_usuario_p, 
			dt_atualizacao			= clock_timestamp() 
		where	nr_sequencia			= nr_seq_proc_contest_p;
	else 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(189148);
	end if;
end if;
 
if (nr_seq_mat_contest_p IS NOT NULL AND nr_seq_mat_contest_p::text <> '') then	/* Se for material em contestação */
 
	if (ie_material_w = 'S') then 
		select	coalesce(vl_contestado,0), 
			coalesce(qt_contestada,0) 
		into STRICT	vl_item_w, 
			qt_item_w 
		from	pls_contestacao_mat 
		where	nr_sequencia = nr_seq_mat_contest_p;
		 
		update	pls_contestacao_mat 
		set	vl_aceito			= vl_item_w, 
			qt_aceita			= qt_item_w, 
			nr_seq_motivo_glosa_aceita	= nr_seq_motivo_glosa_aceita_w, 
			nr_seq_motivo_glosa_neg		 = NULL, 
			nm_usuario			= nm_usuario_p, 
			dt_atualizacao			= clock_timestamp() 
		where	nr_sequencia			= nr_seq_mat_contest_p;
	else 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(189147);
	end if;
end if;
 
if (nr_seq_discussao_p IS NOT NULL AND nr_seq_discussao_p::text <> '') and (coalesce(nr_seq_proc_disc_p::text, '') = '') and (coalesce(nr_seq_mat_disc_p::text, '') = '') then /* Se for uma discussão */
 
	if (ie_conta_w = 'S') then 
		nr_seq_discussao_w := nr_seq_discussao_p;
		open C02;
		loop 
		fetch C02 into 
			ie_tipo_w, 
			nr_sequencia_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin 
			if (ie_tipo_w = 'M') then /* Material da discussão */
 
				select	coalesce(vl_contestado,0), 
					coalesce(qt_contestada,0) 
				into STRICT	vl_item_w, 
					qt_item_w 
				from	pls_discussao_mat 
				where	nr_sequencia = nr_sequencia_w;
				 
				update	pls_discussao_mat 
				set	vl_aceito			= CASE WHEN ie_parametro_16_w='S' THEN vl_aceito  ELSE vl_item_w END , 
					qt_aceita			= CASE WHEN ie_parametro_16_w='S' THEN qt_aceita  ELSE qt_item_w END , 
					nr_seq_motivo_glosa_aceita	= nr_seq_motivo_glosa_aceita_w, 
					nr_seq_motivo_glosa_neg		 = NULL, 
					cd_centro_custo			= cd_centro_custo_p, 
					vl_negado			= CASE WHEN ie_parametro_16_w='S' THEN vl_negado  ELSE 0 END , 
					qt_negada			= CASE WHEN ie_parametro_16_w='S' THEN qt_negada  ELSE 0 END , 
					ds_observacao			= coalesce(ds_observacao_p, ds_observacao), 
					cd_centro_custo_desc		= CASE WHEN ie_desconta_prestador_w='N' THEN cd_centro_custo_desc  ELSE cd_centro_custo_desc_p END , 
					cd_centro_custo_aceite		= CASE WHEN ie_desconta_prestador_w='S' THEN cd_centro_custo_aceite  ELSE cd_centro_custo_aceite_p END , 
					vl_prestador			= vl_prestador_p, 
					vl_assumido			= vl_assumido_p, 
					nm_usuario			= nm_usuario_p, 
					dt_atualizacao			= clock_timestamp() 
				where	nr_sequencia			= nr_sequencia_w;
				 
			elsif (ie_tipo_w = 'P') then /* Procedimento da discussão */
 
				 
				select	coalesce(vl_contestado,0), 
					coalesce(qt_contestada,0) 
				into STRICT	vl_item_w, 
					qt_item_w 
				from	pls_discussao_proc 
				where	nr_sequencia = nr_sequencia_w;
				 
				update	pls_discussao_proc 
				set	vl_aceito			= CASE WHEN ie_parametro_16_w='S' THEN vl_aceito  ELSE vl_item_w END , 
					qt_aceita			= CASE WHEN ie_parametro_16_w='S' THEN qt_aceita  ELSE qt_item_w END , 
					nr_seq_motivo_glosa_aceita	= nr_seq_motivo_glosa_aceita_w, 
					nr_seq_motivo_glosa_neg		 = NULL, 
					cd_centro_custo			= cd_centro_custo_p, 
					vl_negado			= CASE WHEN ie_parametro_16_w='S' THEN vl_negado  ELSE 0 END , 
					qt_negada			= CASE WHEN ie_parametro_16_w='S' THEN qt_negada  ELSE 0 END , 
					ds_observacao			= coalesce(ds_observacao_p, ds_observacao), 
					cd_centro_custo_desc		= CASE WHEN ie_desconta_prestador_w='N' THEN cd_centro_custo_desc  ELSE cd_centro_custo_desc_p END , 
					cd_centro_custo_aceite		= CASE WHEN ie_desconta_prestador_w='S' THEN cd_centro_custo_aceite  ELSE cd_centro_custo_aceite_p END , 
					vl_prestador			= vl_prestador_p, 
					vl_assumido			= vl_assumido_p, 
					nm_usuario			= nm_usuario_p, 
					dt_atualizacao			= clock_timestamp() 
				where	nr_sequencia			= nr_sequencia_w;
			else 
				wheb_mensagem_pck.exibir_mensagem_abort(189149);
			end if;
			end;
		end loop;
		close C02;
	else 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(189150);
	end if;
	 
	--aldellandrea os813642 - Tratamento para quando o lote vem de a500 ou Ajius . O lote vem com staus de fechado e precisa ser gerado os eventos e o cliente não pode reabrir pois pode duplicar os titulos 
	select	max(nr_seq_lote) 
	into STRICT	nr_seq_lote_w 
	from	pls_contestacao_discussao 
	where	nr_sequencia = nr_seq_discussao_w;
	 
	if (nr_seq_lote_w IS NOT NULL AND nr_seq_lote_w::text <> '') then 
		select	ie_status 
		into STRICT	ie_status_w 
		from	pls_lote_discussao 
		where	nr_sequencia = nr_seq_lote_w;
		 
		if (ie_status_w = 'F') or (coalesce(ie_parametro_16_w,'N') = 'S') then 
			CALL pls_gerar_evento_contestacao(nr_seq_lote_w, 'N', cd_estabelecimento_p, nm_usuario_p);
		end if;
	end if;
	--fim tratamento 
end if;
 
if (nr_seq_proc_disc_p IS NOT NULL AND nr_seq_proc_disc_p::text <> '') then		/* Se for procedimento em discussão */
 
	if (ie_procedimento_w = 'S') then 
	 
		select	coalesce(vl_contestado,0), 
			coalesce(qt_contestada,0), 
			coalesce(vl_aceito,0), 
			nr_seq_discussao, 
			nr_seq_conta_proc 
		into STRICT	vl_item_w, 
			qt_item_w, 
			vl_aceito_w, 
			nr_seq_discussao_w, 
			nr_seq_conta_proc_w 
		from	pls_discussao_proc 
		where	nr_sequencia = nr_seq_proc_disc_p;
		 
		begin 
			select	coalesce(sum(a.vl_liberado),0) 
			into STRICT	vl_liberado_w 
			from	pls_conta_medica_resumo a 
			where	a.nr_seq_conta_proc = nr_seq_conta_proc_w 
			and	coalesce(a.ie_status,'A') != 'I' 
			and	a.ie_tipo_item != 'I';
		exception 
		when others then 
			vl_liberado_w := 0;
		end;
		 
		vl_prestador_w	:= null;
		vl_assumido_w	:= null;
		if (ie_desconta_prestador_w = 'S') then 
			if (vl_aceito_w > vl_liberado_w) then 
				vl_prestador_w	:= vl_liberado_w;
				vl_assumido_w	:= vl_aceito_w - vl_liberado_w;
			else 
				vl_prestador_w	:= vl_aceito_w;
				vl_assumido_w	:= 0;
			end if;
		elsif (ie_desconta_prestador_w = 'N') then 
			vl_prestador_w	:= 0;
			vl_assumido_w	:= vl_aceito_w;
		end if;
		 
		update	pls_discussao_proc 
		set	vl_aceito			= CASE WHEN ie_parametro_16_w='S' THEN vl_aceito  ELSE vl_item_w END , 
			qt_aceita			= CASE WHEN ie_parametro_16_w='S' THEN qt_aceita  ELSE qt_item_w END , 
			nr_seq_motivo_glosa_aceita	= nr_seq_motivo_glosa_aceita_w, 
			nr_seq_motivo_glosa_neg		 = NULL, 
			cd_centro_custo			= cd_centro_custo_p, 
			vl_negado			= CASE WHEN ie_parametro_16_w='S' THEN vl_negado  ELSE 0 END , 
			qt_negada			= CASE WHEN ie_parametro_16_w='S' THEN qt_negada  ELSE 0 END , 
			vl_prestador			= coalesce(vl_prestador_w,vl_prestador_p), 
			ds_observacao			= coalesce(ds_observacao_p,ds_observacao), 
			vl_assumido			= coalesce(vl_assumido_w,vl_assumido_p), 
			cd_centro_custo_desc		= CASE WHEN ie_desconta_prestador_w='N' THEN cd_centro_custo_desc  ELSE cd_centro_custo_desc_p END , 
			cd_centro_custo_aceite		= CASE WHEN ie_desconta_prestador_w='S' THEN cd_centro_custo_aceite  ELSE cd_centro_custo_aceite_p END , 
			nm_usuario			= nm_usuario_p, 
			dt_atualizacao			= clock_timestamp() 
		where	nr_sequencia			= nr_seq_proc_disc_p;
	else 
		wheb_mensagem_pck.exibir_mensagem_abort(189148);
	end if;
	 
	if (coalesce(ie_parametro_16_w,'N') = 'S') then 
		select	max(nr_seq_lote) 
		into STRICT	nr_seq_lote_w 
		from	pls_contestacao_discussao 
		where	nr_sequencia = nr_seq_discussao_w;
		 
		if (nr_seq_lote_w IS NOT NULL AND nr_seq_lote_w::text <> '') then 
			CALL pls_gerar_evento_contestacao( nr_seq_lote_w, 'N', cd_estabelecimento_p, nm_usuario_p);
		end if;
	end if;
end if;
 
if (nr_seq_mat_disc_p IS NOT NULL AND nr_seq_mat_disc_p::text <> '') then /* Se for material em discussão */
 
	if (ie_material_w = 'S') then 
		 
		select	coalesce(vl_contestado,0), 
			coalesce(qt_contestada,0), 
			coalesce(vl_aceito,0), 
			nr_seq_discussao, 
			nr_seq_conta_mat 
		into STRICT	vl_item_w, 
			qt_item_w, 
			vl_aceito_w, 
			nr_seq_discussao_w, 
			nr_seq_conta_mat_w 
		from	pls_discussao_mat 
		where	nr_sequencia = nr_seq_mat_disc_p;
		 
		begin 
			select	coalesce(sum(a.vl_liberado),0) 
			into STRICT	vl_liberado_w 
			from	pls_conta_medica_resumo a 
			where	a.nr_seq_conta_mat = nr_seq_conta_mat_w 
			and	coalesce(a.ie_status,'A') != 'I' 
			and	a.ie_tipo_item != 'I';
		exception 
		when others then 
			vl_liberado_w := 0;
		end;
		 
		vl_prestador_w	:= null;
		vl_assumido_w	:= null;
		if (ie_desconta_prestador_w = 'S') then 
			if (vl_aceito_w > vl_liberado_w) then 
				vl_prestador_w	:= vl_liberado_w;
				vl_assumido_w	:= vl_aceito_w - vl_liberado_w;
			else 
				vl_prestador_w	:= vl_aceito_w;
				vl_assumido_w	:= 0;
			end if;
		elsif (ie_desconta_prestador_w = 'N') then 
			vl_prestador_w	:= 0;
			vl_assumido_w	:= vl_aceito_w;
		end if;
		 
		update	pls_discussao_mat 
		set	vl_aceito			= CASE WHEN ie_parametro_16_w='S' THEN vl_aceito  ELSE vl_item_w END , 
			qt_aceita			= CASE WHEN ie_parametro_16_w='S' THEN qt_aceita  ELSE qt_item_w END , 
			nr_seq_motivo_glosa_aceita	= nr_seq_motivo_glosa_aceita_w, 
			nr_seq_motivo_glosa_neg		 = NULL, 
			cd_centro_custo			= cd_centro_custo_p, 
			vl_negado			= CASE WHEN ie_parametro_16_w='S' THEN vl_negado  ELSE 0 END , 
			qt_negada			= CASE WHEN ie_parametro_16_w='S' THEN qt_negada  ELSE 0 END , 
			vl_prestador			= coalesce(vl_prestador_w,vl_prestador_p), 
			ds_observacao			= coalesce(ds_observacao_p, ds_observacao), 
			vl_assumido			= coalesce(vl_assumido_w,vl_assumido_p), 
			cd_centro_custo_desc		= CASE WHEN ie_desconta_prestador_w='N' THEN cd_centro_custo_desc  ELSE cd_centro_custo_desc_p END , 
			cd_centro_custo_aceite		= CASE WHEN ie_desconta_prestador_w='S' THEN cd_centro_custo_aceite  ELSE cd_centro_custo_aceite_p END , 
			nm_usuario			= nm_usuario_p, 
			dt_atualizacao			= clock_timestamp() 
		where	nr_sequencia			= nr_seq_mat_disc_p;
	else 
		wheb_mensagem_pck.exibir_mensagem_abort(189147);
	end if;
	 
	if (coalesce(ie_parametro_16_w,'N') = 'S') then 
		select	max(nr_seq_lote) 
		into STRICT	nr_seq_lote_w 
		from	pls_contestacao_discussao 
		where	nr_sequencia = nr_seq_discussao_w;
		 
		if (nr_seq_lote_w IS NOT NULL AND nr_seq_lote_w::text <> '') then 
			CALL pls_gerar_evento_contestacao( nr_seq_lote_w, 'N', cd_estabelecimento_p, nm_usuario_p);
		end if;
	end if;
end if;
 
/* Atualizar valores da discussão */
 
if (nr_seq_discussao_w IS NOT NULL AND nr_seq_discussao_w::text <> '') then 
	CALL pls_atualiza_valores_discussao(nr_seq_discussao_w);
end if;
 
CALL pls_atualizar_valores_contest(nr_seq_lote_contest_w,'N');
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_acatar_glosa_intercambio ( nr_seq_contest_p bigint, nr_seq_proc_contest_p bigint, nr_seq_mat_contest_p bigint, nr_seq_discussao_p bigint, nr_seq_proc_disc_p bigint, nr_seq_mat_disc_p bigint, nr_seq_motivo_aceite_p bigint, cd_centro_custo_p bigint, nm_usuario_p usuario.nm_usuario%type, vl_prestador_p bigint, ds_observacao_p text, vl_assumido_p bigint, cd_centro_custo_desc_p bigint, cd_centro_custo_aceite_p bigint, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;

