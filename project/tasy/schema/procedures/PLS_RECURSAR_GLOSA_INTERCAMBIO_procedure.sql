-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_recursar_glosa_intercambio ( nr_seq_contest_p pls_contestacao.nr_sequencia%type, nr_seq_proc_contest_p pls_contestacao_proc.nr_sequencia%type, nr_seq_mat_contest_p pls_contestacao_mat.nr_sequencia%type, nr_seq_discussao_p pls_contestacao_discussao.nr_sequencia%type, nr_seq_proc_disc_p pls_discussao_proc.nr_sequencia%type, nr_seq_mat_disc_p pls_discussao_mat.nr_sequencia%type, nr_seq_motivo_recurso_p pls_motivo_glosa_negada.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


ie_procedimento_w		pls_motivo_glosa_negada.ie_procedimento%type;
ie_material_w			pls_motivo_glosa_negada.ie_material%type;
ie_conta_w			pls_motivo_glosa_negada.ie_conta%type;
qt_item_w			pls_discussao_proc.qt_contestada%type;
vl_item_w			pls_discussao_proc.vl_contestado%type;
nr_seq_motivo_glosa_neg_w	pls_motivo_glosa_negada.nr_sequencia%type;
nr_sequencia_w			pls_contestacao_proc.nr_sequencia%type;
ie_tipo_w			varchar(1);
nr_seq_discussao_w		pls_contestacao_discussao.nr_sequencia%type;
nr_seq_lote_w			pls_lote_discussao.nr_sequencia%type;
ie_status_w			pls_lote_discussao.ie_status%type;
qt_evento_w			integer;
cd_estabelecimento_w		pls_lote_contestacao.cd_estabelecimento%type;
qt_reg_eve_w			integer := 0;
nr_seq_lote_evento_w		pls_lote_evento.nr_sequencia%type;

C01 CURSOR FOR				/* Cursor para pegar os itens da CONTESTAÇÃO */
	SELECT	'P' ie_tipo,
		a.nr_sequencia
	from	pls_contestacao		c,
		pls_contestacao_proc	a
	where	a.nr_seq_contestacao 	= c.nr_sequencia
	and	c.nr_sequencia	= nr_seq_contest_p
	
union

	SELECT	'M' ie_tipo,
		a.nr_sequencia
	from	pls_contestacao		c,
		pls_contestacao_mat	a
	where	a.nr_seq_contestacao 	= c.nr_sequencia
	and	c.nr_sequencia	= nr_seq_contest_p;

C02 CURSOR FOR				/* Cursor para pegar os itens da DISCUSSÃO */
	SELECT	'P' ie_tipo,
		a.nr_sequencia
	from	pls_contestacao_discussao	c,
		pls_discussao_proc		a
	where	a.nr_seq_discussao 	= c.nr_sequencia
	and	c.nr_sequencia		= nr_seq_discussao_p
	
union

	SELECT	'M' ie_tipo,
		a.nr_sequencia
	from	pls_contestacao_discussao	c,
		pls_discussao_mat		a
	where	a.nr_seq_discussao 	= c.nr_sequencia
	and	c.nr_sequencia		= nr_seq_discussao_p;


BEGIN
select	ie_procedimento,
	ie_material,
	ie_conta,
	nr_sequencia
into STRICT	ie_procedimento_w,
	ie_material_w,
	ie_conta_w,
	nr_seq_motivo_glosa_neg_w
from	pls_motivo_glosa_negada
where	nr_sequencia = nr_seq_motivo_recurso_p;

if (nr_seq_contest_p IS NOT NULL AND nr_seq_contest_p::text <> '') and (coalesce(nr_seq_proc_contest_p::text, '') = '') and (coalesce(nr_seq_mat_contest_p::text, '') = '') then		/* Se for conta em contestação */
	if (ie_conta_w = 'S') then
		open C01;
		loop
		fetch C01 into
			ie_tipo_w,
			nr_sequencia_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			if (ie_tipo_w = 'M') then		/* Material da contestação */
				if (ie_material_w = 'S') then
					update	pls_contestacao_mat
					set	vl_aceito 			= 0,
						qt_aceita 			= 0,
						nr_seq_motivo_glosa_aceita	 = NULL,
						nr_seq_motivo_glosa_neg 	= nr_seq_motivo_glosa_neg_w
					where	nr_sequencia 			= nr_sequencia_w;
				else
					CALL wheb_mensagem_pck.exibir_mensagem_abort(189151);
				end if;
			elsif (ie_tipo_w = 'P') then		/* Procedimento da contestação */
				if (ie_procedimento_w = 'S') then

					update	pls_contestacao_proc
					set	vl_aceito 			= 0,
						qt_aceita 			= 0,
						nr_seq_motivo_glosa_aceita	 = NULL,
						nr_seq_motivo_glosa_neg 	= nr_seq_motivo_glosa_neg_w
					where	nr_sequencia 			= nr_sequencia_w;
				else
					CALL wheb_mensagem_pck.exibir_mensagem_abort(189152);
				end if;
			else
				CALL wheb_mensagem_pck.exibir_mensagem_abort(189153);
			end if;
			end;
		end loop;
		close C01;
	else
		CALL wheb_mensagem_pck.exibir_mensagem_abort(189154);
	end if;
end if;

if (nr_seq_proc_contest_p IS NOT NULL AND nr_seq_proc_contest_p::text <> '') then		/* Se for procedimento em contestação */
	if (ie_procedimento_w = 'S') then
		update	pls_contestacao_proc
		set	vl_aceito 			= 0,
			qt_aceita 			= 0,
			nr_seq_motivo_glosa_aceita	 = NULL,
			nr_seq_motivo_glosa_neg 	= nr_seq_motivo_glosa_neg_w
		where	nr_sequencia 			= nr_seq_proc_contest_p;
	else
		CALL wheb_mensagem_pck.exibir_mensagem_abort(189152);
	end if;
end if;

if (nr_seq_mat_contest_p IS NOT NULL AND nr_seq_mat_contest_p::text <> '') then			/* Se for material em contestação */
	if (ie_material_w = 'S') then
		update	pls_contestacao_mat
		set	vl_aceito 			= 0,
			qt_aceita 			= 0,
			nr_seq_motivo_glosa_aceita	 = NULL,
			nr_seq_motivo_glosa_neg 	= nr_seq_motivo_glosa_neg_w
		where	nr_sequencia 			= nr_seq_mat_contest_p;
	else
		CALL wheb_mensagem_pck.exibir_mensagem_abort(189151);
	end if;
end if;

if (nr_seq_discussao_p IS NOT NULL AND nr_seq_discussao_p::text <> '') and (coalesce(nr_seq_proc_disc_p::text, '') = '') and (coalesce(nr_seq_mat_disc_p::text, '') = '') then		/* Se for uma discussão */
	if (ie_conta_w = 'S') then
		nr_seq_discussao_w := nr_seq_discussao_p;
		open C02;
		loop
		fetch C02 into
			ie_tipo_w,
			nr_sequencia_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			if (ie_tipo_w = 'M') then		/* Material da discussão */
				select	coalesce(vl_contestado,0),
					coalesce(qt_contestada,0)
				into STRICT	vl_item_w,
					qt_item_w
				from	pls_discussao_mat
				where	nr_sequencia = nr_sequencia_w;

				update	pls_discussao_mat
				set	vl_aceito 			= 0,
					qt_aceita 			= 0,
					vl_negado			= vl_item_w,
					qt_negada			= qt_item_w,
					nr_seq_motivo_glosa_aceita	 = NULL,
					nr_seq_motivo_glosa_neg 	= nr_seq_motivo_glosa_neg_w,
					cd_centro_custo			 = NULL
				where	nr_sequencia 			= nr_sequencia_w;

			elsif (ie_tipo_w = 'P') then		/* Procedimento da discussão */
				select	coalesce(vl_contestado,0),
					coalesce(qt_contestada,0)
				into STRICT	vl_item_w,
					qt_item_w
				from	pls_discussao_proc
				where	nr_sequencia = nr_sequencia_w;

				update	pls_discussao_proc
				set	vl_aceito 			= 0,
					qt_aceita 			= 0,
					vl_negado			= vl_item_w,
					qt_negada			= qt_item_w,
					nr_seq_motivo_glosa_aceita	 = NULL,
					nr_seq_motivo_glosa_neg 	= nr_seq_motivo_glosa_neg_w,
					cd_centro_custo			 = NULL
				where	nr_sequencia 			= nr_sequencia_w;
			else
				CALL wheb_mensagem_pck.exibir_mensagem_abort(189153);
			end if;
			end;
		end loop;
		close C02;
	else
		CALL wheb_mensagem_pck.exibir_mensagem_abort(189154);
	end if;

	--aldellandrea os813642 - Tratamento para desfazer os eventos quando a glosa for recusada com o lote já fechado
	select	max(nr_seq_lote)
	into STRICT	nr_seq_lote_w
	from	pls_contestacao_discussao
	where	nr_sequencia =  nr_seq_discussao_w;

	if (nr_seq_lote_w IS NOT NULL AND nr_seq_lote_w::text <> '')	then
		select	ie_status
		into STRICT	ie_status_w
		from	pls_lote_discussao
		where	nr_sequencia = nr_seq_lote_w;

		select	count(1)
		into STRICT	qt_evento_w
		from	pls_evento_movimento
		where	nr_seq_lote_disc = nr_seq_lote_w
		and	coalesce(ie_cancelamento::text, '') = '';

		if (ie_status_w = 'F') and (qt_evento_w > 0) then
			-- Desfazer os eventos
			select	count(1)
			into STRICT	qt_reg_eve_w
			from	pls_lote_evento		b,
				pls_evento_movimento	a
			where	b.nr_sequencia		= a.nr_seq_lote
			and	a.nr_seq_lote_disc	= nr_seq_lote_w
			and	(b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '')
			and	coalesce(a.ie_cancelamento::text, '') = ''  LIMIT 1;

			if (qt_reg_eve_w > 0) then
				select	max(b.nr_sequencia)
				into STRICT	nr_seq_lote_evento_w
				from	pls_lote_evento		b,
					pls_evento_movimento	a
				where	b.nr_sequencia		= a.nr_seq_lote
				and	a.nr_seq_lote_disc	= nr_seq_lote_w
				and	(b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '');

				CALL wheb_mensagem_pck.exibir_mensagem_abort(196092,'NR_SEQ_LOTE_EVENTO=' || nr_seq_lote_evento_w);
			else
				delete	FROM pls_evento_movimento
				where	nr_seq_lote_disc = nr_seq_lote_w;
			end if;
		end if;
	end if;
	--fim tratamento
end if;

if (nr_seq_proc_disc_p IS NOT NULL AND nr_seq_proc_disc_p::text <> '') then		-- Se for procedimento em discussão
	if (ie_procedimento_w = 'S') then

		select	coalesce(vl_contestado,0),
			coalesce(qt_contestada,0),
			nr_seq_discussao
		into STRICT	vl_item_w,
			qt_item_w,
			nr_seq_discussao_w
		from	pls_discussao_proc
		where	nr_sequencia = nr_seq_proc_disc_p;

		update	pls_discussao_proc
		set	vl_aceito 			= 0,
			qt_aceita 			= 0,
			vl_negado			= vl_item_w,
			qt_negada			= qt_item_w,
			nr_seq_motivo_glosa_aceita	 = NULL,
			nr_seq_motivo_glosa_neg 	= nr_seq_motivo_glosa_neg_w,
			cd_centro_custo			 = NULL
		where	nr_sequencia 			= nr_seq_proc_disc_p;
	else
		CALL wheb_mensagem_pck.exibir_mensagem_abort(189152);
	end if;
end if;

if (nr_seq_mat_disc_p IS NOT NULL AND nr_seq_mat_disc_p::text <> '') then		-- Se for material em discussão
	if (ie_material_w = 'S') then

		select	coalesce(vl_contestado,0),
			coalesce(qt_contestada,0),
			nr_seq_discussao
		into STRICT	vl_item_w,
			qt_item_w,
			nr_seq_discussao_w
		from	pls_discussao_mat
		where	nr_sequencia = nr_seq_mat_disc_p;

		update	pls_discussao_mat
		set	vl_aceito 			= 0,
			qt_aceita 			= 0,
			vl_negado			= vl_item_w,
			qt_negada			= qt_item_w,
			nr_seq_motivo_glosa_aceita	 = NULL,
			nr_seq_motivo_glosa_neg 	= nr_seq_motivo_glosa_neg_w,
			cd_centro_custo			 = NULL
		where	nr_sequencia 			= nr_seq_mat_disc_p;
	else
		CALL wheb_mensagem_pck.exibir_mensagem_abort(189151);
	end if;
end if;

/* Atualizar valores da discussão */

if (nr_seq_discussao_w IS NOT NULL AND nr_seq_discussao_w::text <> '') then
	CALL pls_atualiza_valores_discussao(nr_seq_discussao_w);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_recursar_glosa_intercambio ( nr_seq_contest_p pls_contestacao.nr_sequencia%type, nr_seq_proc_contest_p pls_contestacao_proc.nr_sequencia%type, nr_seq_mat_contest_p pls_contestacao_mat.nr_sequencia%type, nr_seq_discussao_p pls_contestacao_discussao.nr_sequencia%type, nr_seq_proc_disc_p pls_discussao_proc.nr_sequencia%type, nr_seq_mat_disc_p pls_discussao_mat.nr_sequencia%type, nr_seq_motivo_recurso_p pls_motivo_glosa_negada.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
