-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_convenio_ret_glosa (nr_seq_ret_item_p bigint, cd_motivo_glosa_ant_p bigint, cd_motivo_glosa_novo_p bigint, vl_glosa_ant_p bigint, vl_glosa_novo_p bigint, vl_amaior_ant_p bigint, vl_amaior_novo_p bigint, nm_usuario_p text, ie_acao_glosa_ant_p text, ie_acao_glosa_novo_p text, ds_observacao_p INOUT text) AS $body$
DECLARE


ie_acao_glosa_ant_w		varchar(2);
ie_acao_glosa_novo_w		varchar(2);
ie_status_retorno_w		varchar(2);
ie_atualiza_vl_guia_w		varchar(1);
cd_estabelecimento_w		bigint;
ie_glosando_propor_w		bigint;
ie_gerando_retorno_glosa_w	bigint;
vl_glosa_atual_w		double precision;
vl_amenor_atual_w		double precision;
ie_libera_repasse_w		varchar(5);
cd_convenio_w			integer;
vl_pago_w			double precision;
vl_glosado_w			double precision;
vl_amenor_w			double precision;
ie_gerando_itens_glosa_conta_w	bigint;
ie_tf_glosa_w			bigint;
ie_estornando_repasse_w		bigint;
ie_altera_acao_glosa_w		varchar(1);
ie_troca_acao_sem_motivo_w	varchar(1) := 'N';

BEGIN


begin
select	b.ie_status_retorno,
	b.cd_estabelecimento
into STRICT	ie_status_retorno_w,
	cd_estabelecimento_w
from	convenio_retorno b,
	convenio_retorno_item a
where	a.nr_seq_retorno	= b.nr_sequencia
and	a.nr_sequencia	= nr_seq_ret_item_p;
exception
when others then
	ie_status_retorno_w := null;
	cd_estabelecimento_w := null;
end;

ie_atualiza_vl_guia_w := obter_param_usuario(27, 25, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_atualiza_vl_guia_w);
ie_altera_acao_glosa_w := obter_param_usuario(27, 204, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_altera_acao_glosa_w);



select	count(*)
into STRICT	ie_glosando_propor_w
from	v$session
where	audsid		= (SELECT userenv('sessionid') )
and	upper(action) 	= 'GLOSAR_RETORNO_PROPORCIONAL';

select	count(*)
into STRICT	ie_gerando_retorno_glosa_w
from	v$session
where	audsid		= (SELECT userenv('sessionid') )
and	upper(action) 	= 'GERAR_RETORNO_GLOSA';

select	count(*)
into STRICT	ie_gerando_itens_glosa_conta_w
from	v$session
where	audsid		= (SELECT userenv('sessionid') )
and	upper(action) 	= 'GERAR_ITENS_GLOSADOS_CONTA';

select	count(*)
into STRICT	ie_estornando_repasse_w
from	v$session
where	audsid		= (SELECT userenv('sessionid') )
and	upper(action) 	= 'ESTORNAR_BAIXA_TITULO_CONVENIO';

select	count(*)
into STRICT	ie_tf_glosa_w
from	v$session
where	audsid		= (SELECT userenv('sessionid') )
and	upper(action) 	= 'GERAR_TRANS_FINANC_GLOSA';

ie_acao_glosa_ant_w	:= ie_acao_glosa_ant_p;
ie_acao_glosa_novo_w	:= ie_acao_glosa_novo_p;

if	((coalesce(ie_atualiza_vl_guia_w,'N') <> 'N') or 			-- Edgar 11/05/2009, OS 129084, somente alterar valores do retorno qdo o parâmetro estiver liberado ou o retorno estiver aberto
	(ie_status_retorno_w = 'R')) and (ie_gerando_retorno_glosa_w = 0) and (ie_gerando_itens_glosa_conta_w = 0) and (ie_estornando_repasse_w = 0) and (ie_tf_glosa_w = 0) then

	-- Desfazer glosa anterior
	if (cd_motivo_glosa_ant_p IS NOT NULL AND cd_motivo_glosa_ant_p::text <> '') and
		((cd_motivo_glosa_ant_p <> cd_motivo_glosa_novo_p) or (coalesce(cd_motivo_glosa_novo_p::text, '') = '')) or (ie_acao_glosa_ant_p IS NOT NULL AND ie_acao_glosa_ant_p::text <> '') and (ie_acao_glosa_ant_p <> ie_acao_glosa_novo_p)then

		if (cd_motivo_glosa_ant_p = cd_motivo_glosa_novo_p) and (ie_acao_glosa_ant_p IS NOT NULL AND ie_acao_glosa_ant_p::text <> '') and (ie_acao_glosa_ant_p <> ie_acao_glosa_novo_p) then
			ie_troca_acao_sem_motivo_w := 'S';
		end if;

		if (coalesce(ie_acao_glosa_ant_w::text, '') = '') then

			select	ie_acao_glosa
			into STRICT	ie_acao_glosa_ant_w
			from	motivo_glosa
			where	cd_motivo_glosa	= cd_motivo_glosa_ant_p;

		end if;

		if (ie_acao_glosa_ant_w IS NOT NULL AND ie_acao_glosa_ant_w::text <> '') then

			if (ie_status_retorno_w = 'F') then
				/* Este retorno já está fechado e não pode ter seus valores alterados!
				Somente será possivel lançar um motivo de glosa que não possua ação. */
				CALL wheb_mensagem_pck.exibir_mensagem_abort(187153);
			end if;


			if (ie_atualiza_vl_guia_w = 'S') and (ie_glosando_propor_w = 0) then


				if (ie_acao_glosa_ant_w = 'A') then
					update	convenio_retorno_item
					set	vl_glosado	= vl_glosado - vl_glosa_ant_p,
						vl_pago		= vl_pago + vl_glosa_ant_p,
						dt_atualizacao	= clock_timestamp(),
						nm_usuario	= nm_usuario_p
					where	nr_sequencia	= nr_seq_ret_item_p
					  and	vl_glosado	>= vl_glosa_ant_p;
				elsif (ie_acao_glosa_ant_w = 'R') then


					update	convenio_retorno_item
					set	vl_pago		= vl_pago + vl_glosa_ant_p,
						vl_amenor	= vl_amenor - vl_glosa_ant_p,
						dt_atualizacao	= clock_timestamp(),
						nm_usuario	= nm_usuario_p
					where	nr_sequencia	= nr_seq_ret_item_p
					  and	vl_amenor	>= vl_glosa_ant_p;
				end if;
			else
				if (ie_acao_glosa_ant_w = 'A') then
					update	convenio_retorno_item
					set	vl_glosado	= vl_glosado - vl_glosa_ant_p,
						vl_amenor	= vl_amenor + vl_glosa_ant_p,
						dt_atualizacao	= clock_timestamp(),
						nm_usuario	= nm_usuario_p
					where	nr_sequencia	= nr_seq_ret_item_p
					  and	vl_glosado	>= vl_glosa_ant_p
	  				  and	ie_glosa 	<> 'S';

				elsif (ie_acao_glosa_ant_w = 'R') then


					update	convenio_retorno_item
					set	vl_glosado	= vl_glosado + vl_glosa_ant_p,
						vl_amenor	= vl_amenor - vl_glosa_ant_p,
						dt_atualizacao	= clock_timestamp(),
						nm_usuario	= nm_usuario_p
					where	nr_sequencia	= nr_seq_ret_item_p
					  and	vl_amenor	>= vl_glosa_ant_p
					  and (ie_glosa 	= 'S' or
						ie_troca_acao_sem_motivo_w = 'S');
				end if;

			end if;
		end if;
	end if;

	if (ie_glosando_propor_w = 0) and
		((ie_atualiza_vl_guia_w = 'S') and (coalesce(cd_motivo_glosa_ant_p::text, '') = '') and (vl_glosa_ant_p > 0)) then

		update	convenio_retorno_item
		set	vl_glosado	= vl_glosado - vl_glosa_ant_p,
			vl_pago		= vl_pago + vl_glosa_ant_p,
			dt_atualizacao	= clock_timestamp(),
			nm_usuario	= nm_usuario_p
		where	nr_sequencia	= nr_seq_ret_item_p
		and	vl_glosado	>= vl_glosa_ant_p;
	end if;


	-- Aplicar nova glosa
	if (cd_motivo_glosa_novo_p IS NOT NULL AND cd_motivo_glosa_novo_p::text <> '') and
		((cd_motivo_glosa_ant_p <> cd_motivo_glosa_novo_p) or (coalesce(cd_motivo_glosa_ant_p::text, '') = '')) then

		if (coalesce(ie_acao_glosa_novo_w::text, '') = '') then

			select	ie_acao_glosa
			into STRICT	ie_acao_glosa_novo_w
			from	motivo_glosa
			where	cd_motivo_glosa	= cd_motivo_glosa_novo_p;

		end if;

		if (ie_acao_glosa_novo_w IS NOT NULL AND ie_acao_glosa_novo_w::text <> '') then

			if (ie_status_retorno_w = 'F') then
				/* Este retorno já está fechado e não pode ter seus valores alterados!
				Somente será possivel lançar um motivo de glosa que não possua ação. */
				CALL wheb_mensagem_pck.exibir_mensagem_abort(187153);
			end if;

			if (ie_atualiza_vl_guia_w = 'S') and (ie_glosando_propor_w = 0) then
				if (ie_acao_glosa_novo_w = 'A') then

					update	convenio_retorno_item
					set	vl_glosado	= vl_glosado + vl_glosa_novo_p,
						vl_pago		= vl_pago - vl_glosa_novo_p,
						dt_atualizacao	= clock_timestamp(),
						nm_usuario	= nm_usuario_p
					where	nr_sequencia	= nr_seq_ret_item_p
					and	vl_pago		>= vl_glosa_novo_p;

				elsif (ie_acao_glosa_novo_w = 'R') then
					update	convenio_retorno_item
					set	vl_pago		= vl_pago - vl_glosa_novo_p,
						vl_amenor	= vl_amenor + vl_glosa_novo_p,
						dt_atualizacao	= clock_timestamp(),
						nm_usuario	= nm_usuario_p
					where	nr_sequencia	= nr_seq_ret_item_p
					and	vl_pago		>= vl_glosa_novo_p;	/*OS36756 - Bruna -  Inclusão para tratar quando a ação da glosa for reapresentação*/
				end if;
			else
				if (ie_acao_glosa_novo_w = 'A') then

					update	convenio_retorno_item
					set	vl_glosado	= vl_glosado + vl_glosa_novo_p,
						vl_amenor	= vl_amenor - vl_glosa_novo_p,
						dt_atualizacao	= clock_timestamp(),
						nm_usuario	= nm_usuario_p
					where	nr_sequencia	= nr_seq_ret_item_p
					and	vl_amenor	>= vl_glosa_novo_p
					and	obter_valor_conpaci_guia(nr_interno_conta, cd_autorizacao, 1) >= (vl_amenor - vl_glosa_novo_p)
					and	ie_glosa 	<> 'S';

				elsif (ie_acao_glosa_novo_w = 'R') then

					update	convenio_retorno_item
					set	vl_glosado	= vl_glosado - vl_glosa_novo_p,
						vl_amenor	= vl_amenor + vl_glosa_novo_p,
						dt_atualizacao	= clock_timestamp(),
						nm_usuario	= nm_usuario_p
					where	nr_sequencia	= nr_seq_ret_item_p
					and	vl_glosado	>= vl_glosa_novo_p			/*OS36756 - Bruna -  Inclusão para tratar quando a ação da glosa for reapresentação*/
					and	obter_valor_conpaci_guia(nr_interno_conta, cd_autorizacao, 1) >= (vl_amenor - vl_glosa_novo_p)
					and	ie_glosa 	= 'S';
				end if;

			end if;
		end if;
	end if;

	if (ie_glosando_propor_w = 0) and
		((ie_atualiza_vl_guia_w = 'S') and (coalesce(cd_motivo_glosa_novo_p::text, '') = '') and (vl_glosa_novo_p > 0)) then

		update	convenio_retorno_item
		set	vl_glosado	= vl_glosado + vl_glosa_novo_p,
			vl_pago		= vl_pago - vl_glosa_novo_p,
			dt_atualizacao	= clock_timestamp(),
			nm_usuario	= nm_usuario_p
		where	nr_sequencia	= nr_seq_ret_item_p
		and	vl_pago		>= vl_glosa_novo_p;
	end if;

	if (coalesce(ie_acao_glosa_novo_w::text, '') = '') then

		select	max(ie_acao_glosa)
		into STRICT	ie_acao_glosa_novo_w
		from	motivo_glosa
		where	cd_motivo_glosa	= cd_motivo_glosa_novo_p;

	end if;

	if (ie_glosando_propor_w = 0) and
		(ie_atualiza_vl_guia_w <> 'N' AND vl_amaior_ant_p > 0) and
		((cd_motivo_glosa_ant_p <> coalesce(cd_motivo_glosa_novo_p,0)) or (coalesce(cd_motivo_glosa_ant_p::text, '') = '')) and
		((coalesce(ie_acao_glosa_novo_w,'X') <> 'R') or (coalesce(cd_motivo_glosa_ant_p::text, '') = '')) then --lhalves OS263405 em 19/11/2010
		update	convenio_retorno_item
		set	vl_adicional	= vl_adicional - vl_amaior_ant_p,
			dt_atualizacao	= clock_timestamp(),
			nm_usuario	= nm_usuario_p
		where	nr_sequencia	= nr_seq_ret_item_p
		and	vl_adicional	>= vl_amaior_ant_p;

	end if;

	if (ie_glosando_propor_w = 0) and
		(ie_atualiza_vl_guia_w <> 'N' AND vl_amaior_novo_p > 0) and
		((cd_motivo_glosa_ant_p <> coalesce(cd_motivo_glosa_novo_p,0)) or (coalesce(cd_motivo_glosa_ant_p::text, '') = '')) and
		((coalesce(ie_acao_glosa_novo_w,'X') <> 'R') or (coalesce(cd_motivo_glosa_ant_p::text, '') = ''))  then --lhalves OS263405 em 19/11/2010
		update	convenio_retorno_item
		set	vl_adicional	= vl_adicional + vl_amaior_novo_p,
			dt_atualizacao	= clock_timestamp(),
			nm_usuario	= nm_usuario_p
		where	nr_sequencia	= nr_seq_ret_item_p;
	end if;

	-- Edgar 11/05/2010, OS 213502, tratar alteração de valor sem alterar o motivo de glosa
	/* ahoffelder - 19/05/2011 - fiz umas alterações no if */

	if (ie_glosando_propor_w = 0) and (cd_motivo_glosa_ant_p IS NOT NULL AND cd_motivo_glosa_ant_p::text <> '') and (cd_motivo_glosa_ant_p = cd_motivo_glosa_novo_p) and (vl_glosa_ant_p <> vl_glosa_novo_p) and (ie_status_retorno_w = 'R') and (ie_atualiza_vl_guia_w <> 'N') then

		if (coalesce(ie_acao_glosa_novo_w::text, '') = '') then

			select	max(ie_acao_glosa)
			into STRICT	ie_acao_glosa_novo_w
			from	motivo_glosa
			where	cd_motivo_glosa	= cd_motivo_glosa_novo_p;

		end if;

		vl_glosa_atual_w		:= 0;
		vl_amenor_atual_w		:= 0;

		if (ie_acao_glosa_novo_w = 'A') then
			vl_glosa_atual_w	:= vl_glosa_novo_p - vl_glosa_ant_p;
		elsif (ie_acao_glosa_novo_w = 'R') then
			vl_amenor_atual_w	:= vl_glosa_novo_p - vl_glosa_ant_p;
		end if;

		if (ie_atualiza_vl_guia_w = 'S') then

			update	convenio_retorno_item
			set	vl_adicional	= vl_adicional + (coalesce(vl_amaior_novo_p,0) - coalesce(vl_amaior_ant_p,0)),
				vl_amenor	= vl_amenor + vl_amenor_atual_w,
				vl_glosado	= vl_glosado + vl_glosa_atual_w,
				dt_atualizacao	= clock_timestamp(),
				nm_usuario	= nm_usuario_p,
				vl_pago		= vl_pago -  vl_amenor_atual_w - vl_glosa_atual_w
			where	nr_sequencia	= nr_seq_ret_item_p;

		elsif (ie_atualiza_vl_guia_w = 'A') then

			update	convenio_retorno_item
			set	vl_adicional	= vl_adicional + (vl_amaior_novo_p - vl_amaior_ant_p)
			where	nr_sequencia	= nr_seq_ret_item_p;

		end if;

	end if;

	/*lhalves OS333678 - tratamento abaixo para atualizar o valor adicional sem alterar o motivo de glosa*/

	if (ie_glosando_propor_w = 0) and (cd_motivo_glosa_ant_p IS NOT NULL AND cd_motivo_glosa_ant_p::text <> '') and (cd_motivo_glosa_ant_p = cd_motivo_glosa_novo_p) and (vl_amaior_ant_p <> vl_amaior_novo_p) and (ie_status_retorno_w = 'R') and (ie_atualiza_vl_guia_w <> 'N') then

		if (vl_amaior_ant_p > 0) then

			update	convenio_retorno_item
			set	vl_adicional	= vl_adicional - vl_amaior_ant_p,
				dt_atualizacao	= clock_timestamp(),
				nm_usuario	= nm_usuario_p
			where	nr_sequencia	= nr_seq_ret_item_p
			and	vl_adicional	>= vl_amaior_ant_p;
		end if;

		if (vl_amaior_novo_p > 0) then

			update	convenio_retorno_item
			set	vl_adicional	= vl_adicional + vl_amaior_novo_p,
				dt_atualizacao	= clock_timestamp(),
				nm_usuario	= nm_usuario_p
			where	nr_sequencia	= nr_seq_ret_item_p;

		end if;

	end if;

	/* ahoffelder - OS 259868 - 11/11/2010 - atualizar a liberação do repasse conforme regra */

	select	max(b.cd_convenio),
		max(a.vl_pago),
		max(a.vl_glosado),
		max(a.vl_amenor)
	into STRICT	cd_convenio_w,
		vl_pago_w,
		vl_glosado_w,
		vl_amenor_w
	from	convenio_retorno b,
		convenio_retorno_item a
	where	a.nr_sequencia		= nr_seq_ret_item_p
	and	a.nr_seq_retorno	= b.nr_sequencia;

	select	max(a.ie_libera_repasse)
	into STRICT	ie_libera_repasse_w
	from	regra_campo_lib_rep a
	where	a.cd_estabelecimento		= cd_estabelecimento_w
	and	coalesce(a.cd_convenio,cd_convenio_w) 	= cd_convenio_w
	and	((coalesce(vl_amenor_w,0) = 0 and coalesce(vl_glosado_w,0) = 0 and a.ie_regra = 1) or (coalesce(vl_amenor_w,0) <> 0 and a.ie_regra = 2) or (coalesce(vl_glosado_w,0) <> 0 and a.ie_regra = 3) or (coalesce(vl_pago_w,0) = 0 and a.ie_regra = 4));

	update	convenio_retorno_item
	set	ie_libera_repasse	= coalesce(ie_libera_repasse_w, ie_libera_repasse)
	where	nr_sequencia		= nr_seq_ret_item_p;

	-- dsantos comentou este bloco em 20/05/2011 - 316374.
	/*lhalves OS275798 em 18/01/2011*/

	/*
	update	convenio_retorno_item
	set	ie_glosa	= 'S'
	where	nr_sequencia		= nr_seq_ret_item_p
	and	vl_glosado		<> 0
	and	ie_atualiza_vl_guia_w 	<> 'N';
	*/
end if;

 --comentado por causa da OS's 1010679 e 999679
if (ie_altera_acao_glosa_w = 'S' and
	coalesce(ie_acao_glosa_ant_p,'X') <> ie_acao_glosa_novo_p and
	ie_status_retorno_w <> 'R')then
	ds_observacao_p	:= substr(wheb_mensagem_pck.get_texto(364510, 'ie_acao_glosa_ant_p=' || ie_acao_glosa_ant_p || ';ie_acao_glosa_novo_p=' || ie_acao_glosa_novo_p),1,255);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_convenio_ret_glosa (nr_seq_ret_item_p bigint, cd_motivo_glosa_ant_p bigint, cd_motivo_glosa_novo_p bigint, vl_glosa_ant_p bigint, vl_glosa_novo_p bigint, vl_amaior_ant_p bigint, vl_amaior_novo_p bigint, nm_usuario_p text, ie_acao_glosa_ant_p text, ie_acao_glosa_novo_p text, ds_observacao_p INOUT text) FROM PUBLIC;
