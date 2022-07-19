-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atual_susp_atend_inter ( nr_seq_suspensao_p bigint, nr_seq_notificacao_p bigint, ie_opcao_p text, nr_seq_motivo_susp_p bigint, ds_observacao_p text, nm_usuario_p text, ie_commit_p text, ie_suspender_depen_p text, ds_motivo_p text default null) AS $body$
DECLARE


/* ie_opcao_p
S - Suspender atendimento
D - Desfazer suspensão atendimento
*/
nr_seq_segurado_w		bigint;
ie_regulamentacao_plano_w	varchar(2)	:= null;
nr_seq_regra_susp_w		bigint;
dt_rescisao_w			timestamp;
dt_prev_inicio_susp_w		timestamp;
nr_seq_intercambio_w		pls_intercambio.nr_sequencia%type;
nr_seq_motivo_susp_w		pls_segurado_suspensao.nr_seq_motivo_susp%type;

c01 CURSOR FOR
	SELECT	distinct
		c.nr_sequencia nr_seq_segurado,
		c.dt_rescisao
	from	pls_intercambio e,
		pls_plano d,
		pls_segurado c,
		pls_contrato_pagador b,
		pls_notificacao_pagador a
	where	a.cd_pessoa_fisica	= b.cd_pessoa_fisica
	and	c.nr_seq_pagador	= b.nr_sequencia
	and	c.nr_seq_plano		= d.nr_sequencia
	and	e.nr_sequencia		= b.nr_seq_pagador_intercambio
	and	a.nr_sequencia		= nr_seq_notificacao_p
	and	coalesce(d.ie_regulamentacao,0)	= coalesce(ie_regulamentacao_plano_w,coalesce(d.ie_regulamentacao,0))
	and	(c.dt_liberacao IS NOT NULL AND c.dt_liberacao::text <> '')
	and	coalesce(c.dt_rescisao::text, '') = ''
	and	coalesce(c.ie_situacao_atend,'A') = 'A'
	
union all

	SELECT	distinct
		c.nr_sequencia nr_seq_segurado,
		c.dt_rescisao
	from	pls_intercambio e,
		pls_plano d,
		pls_segurado c,
		pls_contrato_pagador b,
		pls_notificacao_pagador a
	where	a.cd_cgc		= b.cd_cgc
	and	c.nr_seq_pagador	= b.nr_sequencia
	and	c.nr_seq_plano		= d.nr_sequencia
	and	e.nr_sequencia		= b.nr_seq_pagador_intercambio
	and	a.nr_sequencia		= nr_seq_notificacao_p
	and	coalesce(d.ie_regulamentacao,0)	= coalesce(ie_regulamentacao_plano_w,coalesce(d.ie_regulamentacao,0))
	and	(c.dt_liberacao IS NOT NULL AND c.dt_liberacao::text <> '')
	and	coalesce(c.dt_rescisao::text, '') = ''
	and	coalesce(c.ie_situacao_atend,'A') = 'A';

c02 CURSOR FOR
	SELECT	nr_sequencia nr_seq_segurado,
		dt_rescisao
	from	pls_segurado
	where	nr_seq_intercambio = nr_seq_intercambio_w
	and	(nr_seq_intercambio_w IS NOT NULL AND nr_seq_intercambio_w::text <> '')
	
union all

	SELECT	nr_sequencia nr_seq_segurado,
		dt_rescisao
	from	pls_segurado
	where	nr_sequencia = nr_seq_segurado_w
	and	(nr_seq_segurado_w IS NOT NULL AND nr_seq_segurado_w::text <> '');

BEGIN

if (ie_opcao_p	= 'S') then
	if (nr_seq_suspensao_p IS NOT NULL AND nr_seq_suspensao_p::text <> '') then
		select	max(a.nr_seq_segurado),
			max(dt_prev_inicio_susp),
			max(nr_seq_motivo_susp)
		into STRICT	nr_seq_segurado_w,
			dt_prev_inicio_susp_w,
			nr_seq_motivo_susp_w
		from	pls_segurado_suspensao a
		where	a.nr_sequencia	= nr_seq_suspensao_p;

		update	pls_segurado_suspensao
		set	dt_inicio_suspensao	= clock_timestamp(),
			nm_usuario		= nm_usuario_p,
			dt_atualizacao		= clock_timestamp()
		where	nr_sequencia		= nr_seq_suspensao_p;

		if (trunc(dt_prev_inicio_susp_w,'dd') <= trunc(clock_timestamp(),'dd')) then
			update	pls_segurado
			set	ie_situacao_atend	= 'S',
				nm_usuario		= nm_usuario_p,
				dt_atualizacao		= clock_timestamp(),
				nr_seq_motivo_susp	= nr_seq_motivo_susp_w
			where	nr_sequencia		= nr_seq_segurado_w;
		end if;

		if (ie_suspender_depen_p	= 'S') then
			CALL pls_suspender_atend_dependente(nr_seq_segurado_w,nr_seq_suspensao_p,'S',nm_usuario_p);
		end if;
	elsif (nr_seq_notificacao_p IS NOT NULL AND nr_seq_notificacao_p::text <> '') then
		select	a.nr_seq_regra_susp
		into STRICT	nr_seq_regra_susp_w
		from	pls_notificacao_pagador a
		where	a.nr_sequencia	= nr_seq_notificacao_p;

		if (nr_seq_regra_susp_w IS NOT NULL AND nr_seq_regra_susp_w::text <> '') then
			begin
			select	a.ie_regulamentacao_plano
			into STRICT	ie_regulamentacao_plano_w
			from	pls_regra_suspensao a
			where	a.nr_sequencia	= nr_seq_regra_susp_w;
			exception
			when others then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(296792);
			end;
		end if;

		open c01;
		loop
		fetch c01 into
			nr_seq_segurado_w,
			dt_rescisao_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			insert	into	pls_segurado_suspensao(nr_sequencia,
				nm_usuario,
				dt_atualizacao,
				nm_usuario_nrec,
				dt_atualizacao_nrec,
				nr_seq_segurado,
				dt_prev_inicio_susp,
				dt_inicio_suspensao,
				nr_seq_notificacao_pag,
				nr_seq_motivo_susp,
				ds_observacao)
			values (nextval('pls_segurado_suspensao_seq'),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nr_seq_segurado_w,
				clock_timestamp(),
				clock_timestamp(),
				nr_seq_notificacao_p,
				nr_seq_motivo_susp_p,
				ds_observacao_p);

			update	pls_segurado
			set	ie_situacao_atend	= 'S',
				nm_usuario		= nm_usuario_p,
				dt_atualizacao		= clock_timestamp(),
				nr_seq_motivo_susp	= nr_seq_motivo_susp_p
			where	nr_sequencia		= nr_seq_segurado_w;
		end loop;
		close c01;
	end if;
elsif (ie_opcao_p	= 'D') then
	if (nr_seq_suspensao_p IS NOT NULL AND nr_seq_suspensao_p::text <> '') then
		dt_rescisao_w	:= null;

		select	max(a.nr_seq_segurado),
			max(a.nr_seq_intercambio)
		into STRICT	nr_seq_segurado_w,
			nr_seq_intercambio_w
		from	pls_segurado_suspensao a
		where	a.nr_sequencia	= nr_seq_suspensao_p;

		update	pls_segurado_suspensao
		set	dt_fim_suspensao   = clock_timestamp(),
			nm_usuario	   = nm_usuario_p,
			dt_atualizacao	   = clock_timestamp(),
			ds_motivo_fim_susp = ds_motivo_p
		where	nr_sequencia	= nr_seq_suspensao_p;

		for c02_w in c02 loop
			if (coalesce(c02_w.dt_rescisao::text, '') = '' or c02_w.dt_rescisao > clock_timestamp()) then
				update	pls_segurado
				set	ie_situacao_atend	= 'A',
					nm_usuario		= nm_usuario_p,
					dt_atualizacao		= clock_timestamp(),
					nr_seq_motivo_susp	 = NULL
				where	nr_sequencia		= c02_w.nr_seq_segurado;
			end if;

			if (ie_suspender_depen_p	= 'S') then
				CALL pls_suspender_atend_dependente(c02_w.nr_seq_segurado,nr_seq_suspensao_p,'D',nm_usuario_p);
			end if;
		end loop;
	elsif (nr_seq_notificacao_p IS NOT NULL AND nr_seq_notificacao_p::text <> '') then
		open c01;
		loop
		fetch c01 into
			nr_seq_segurado_w,
			dt_rescisao_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			update	pls_segurado_suspensao
			set	dt_fim_suspensao = clock_timestamp(),
				nm_usuario	= nm_usuario_p,
				dt_atualizacao	= clock_timestamp()
			where	nr_seq_segurado	= nr_seq_segurado_w
			and	nr_seq_notificacao_pag	= nr_seq_notificacao_p;

			if (coalesce(dt_rescisao_w::text, '') = '' or dt_rescisao_w > clock_timestamp()) then
				update	pls_segurado
				set	ie_situacao_atend	= 'A',
					nm_usuario		= nm_usuario_p,
					dt_atualizacao		= clock_timestamp(),
					nr_seq_motivo_susp	 = NULL
				where	nr_sequencia		= nr_seq_segurado_w;
			end if;
		end loop;
		close c01;
	end if;
end if;

if (ie_commit_p	= 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atual_susp_atend_inter ( nr_seq_suspensao_p bigint, nr_seq_notificacao_p bigint, ie_opcao_p text, nr_seq_motivo_susp_p bigint, ds_observacao_p text, nm_usuario_p text, ie_commit_p text, ie_suspender_depen_p text, ds_motivo_p text default null) FROM PUBLIC;

