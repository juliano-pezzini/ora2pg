-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_w_analise_item_conta ( nr_seq_analise_p bigint, nr_seq_conta_p bigint, nr_seq_grupo_p bigint, ie_minha_analise_p text, ie_pendentes_p text, nm_usuario_p text, ie_somente_ocor_p text default 'N', nr_id_transacao_p w_pls_analise_item.nr_id_transacao%type DEFAULT NULL) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Gerar as linhas de conta na tabela temporária (Análise Nova)
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_status_w			varchar(255);
ds_tipo_guia_w			varchar(200);
cd_guia_w			varchar(30);
ie_status_analise_w		varchar(10);
ie_pend_grupo_w			varchar(10)	:= null;
ie_nao_finalizar_w		varchar(3);
ie_tipo_guia_w			varchar(2);
ie_selecionado_w		varchar(1)	:= 'N';
ie_minha_analise_w		varchar(1);
ie_pendentes_w			varchar(1);
ie_sem_fluxo_w			varchar(1)	:= null;
nr_sequencia_w			bigint;
qt_glo_ocorr_w			bigint	:= 0;
qt_selecao_w			bigint;
qt_inf_guia_w			bigint	:= 0;
nr_nivel_w			bigint;
qt_exp_w			bigint;
ie_expandido_w			varchar(1)	:= 'N';
ds_ident_w			varchar(30);
qt_contas_guia_w		bigint;
ie_pcmso_w			varchar(1);
qt_somente_ocor_w		integer := 0;
nr_seq_guia_w			pls_conta.nr_seq_guia%type;


BEGIN
if (nr_seq_analise_p IS NOT NULL AND nr_seq_analise_p::text <> '') and (nr_seq_conta_p IS NOT NULL AND nr_seq_conta_p::text <> '') then
	ie_minha_analise_w	:= coalesce(ie_minha_analise_p,'N');
	ie_pendentes_w		:= coalesce(ie_pendentes_p,'N');
	ie_pend_grupo_w		:= pls_obter_pend_grupo_analise(nr_seq_analise_p,nr_seq_conta_p, null, null, null, nr_seq_grupo_p, 'N');
	nr_nivel_w		:= pls_consulta_analise_pck.get_nr_nivel;

	select	ie_pcmso
	into STRICT	ie_pcmso_w
	from	pls_analise_conta
	where	nr_sequencia	= nr_seq_analise_p;

	select	max(a.ie_status),
		max(a.nr_seq_guia)
	into STRICT	ie_status_w,
		nr_seq_guia_w
	from	pls_conta	a
	where	a.nr_sequencia	= nr_seq_conta_p;

	if (ie_somente_ocor_p = 'S') then

		select	count(1)
		into STRICT	qt_somente_ocor_w
		
		where	exists (	SELECT	1
				from	pls_conta_glosa
				where	ie_situacao	= 'A'
				and	nr_seq_conta	= nr_seq_conta_p
				and	coalesce(nr_seq_conta_proc::text, '') = ''
				and	coalesce(nr_seq_conta_mat::text, '') = ''
				and	coalesce(nr_seq_proc_partic::text, '') = ''
				
union all

				SELECT	1
				from	pls_ocorrencia_benef
				where	ie_situacao	= 'A'
				and	nr_seq_conta	= nr_seq_conta_p
				and	coalesce(nr_seq_conta_proc::text, '') = ''
				and	coalesce(nr_seq_conta_mat::text, '') = ''
				and	coalesce(nr_seq_proc_partic::text, '') = '');
	end if;

	if	((ie_minha_analise_w = 'N' and ie_pendentes_w = 'N') or (ie_minha_analise_w = 'S' and (ie_pend_grupo_w IS NOT NULL AND ie_pend_grupo_w::text <> '')) or (ie_pendentes_w = 'S' and ie_pend_grupo_w = 'S')) and (ie_status_w <> 'C') and
		( (ie_somente_ocor_p = 'N') or (ie_somente_ocor_p = 'S' and qt_somente_ocor_w > 0))then

		/* Se for incluir a linha, verificar o tipo de guia, se for SP/SADT ou Honorário, criar linha agrupadora */

		ie_tipo_guia_w	:= pls_consulta_analise_pck.get_ie_tipo_guia;

		qt_inf_guia_w	:= 0;
		if (ie_tipo_guia_w in ('4','6')) then
			select	count(1)
			into STRICT	qt_inf_guia_w
			from	w_pls_analise_item a
			where	a.nr_seq_analise	= nr_seq_analise_p
			and	a.ie_tipo_linha = 'C'
			and	a.ie_tipo_guia	= ie_tipo_guia_w
			and	a.ie_informativo = 'S';

			select	count(1)
			into STRICT	qt_contas_guia_w
			from	pls_conta a
			where	a.nr_seq_analise	= nr_seq_analise_p
			and	a.ie_tipo_guia		= ie_tipo_guia_w;

			if (qt_inf_guia_w = 0) and (qt_contas_guia_w > 1) then
				nr_sequencia_w	:= pls_consulta_analise_pck.get_nr_seq_item;
				if (ie_tipo_guia_w = '4') then
					ds_tipo_guia_w	:= 'Guias de SP/SADT';
				elsif (ie_tipo_guia_w = '6') then
					ds_tipo_guia_w	:= 'Guias de Honorário Individual';
				end if;
				ie_status_analise_w	:= pls_obter_status_analise_item(nr_seq_analise_p,nr_seq_conta_p, null, null, null,null,'S');
				select	count(1)
				into STRICT	qt_selecao_w
				from	w_pls_analise_selecao_item	a
				where	a.nr_seq_analise	= nr_seq_analise_p
				and	a.nr_seq_w_item		= nr_sequencia_w;

				if (qt_selecao_w > 0) then
					ie_selecionado_w	:= 'S';
				else
					ie_selecionado_w	:= 'N';
				end if;

				select	CASE WHEN count(1)=0 THEN 'N'  ELSE 'S' END
				into STRICT	ie_expandido_w
				from	w_pls_analise_item_exp a
				where	a.nr_seq_analise	= nr_seq_analise_p
				and	a.ie_tipo_guia		= ie_tipo_guia_w
				and	a.nm_usuario		= nm_usuario_p
				and	coalesce(a.nr_seq_conta_proc::text, '') = '';

				/* Linha agrupadora */

				insert into w_pls_analise_item(nr_sequencia,
					nm_usuario,
					dt_atualizacao,
					nm_usuario_nrec,
					dt_atualizacao_nrec,
					nr_seq_analise,
					nr_seq_conta,
					ie_tipo_linha,
					ie_tipo_item,
					ie_tipo_despesa,
					ds_item,
					ie_status_analise,
					ie_selecionado,
					ie_pend_grupo,
					ie_sem_fluxo,
					ie_tipo_guia,
					ie_expandido,
					ie_informativo,
					ie_pcmso,
					nr_id_transacao,
					nr_seq_guia)
				values (nr_sequencia_w,
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nr_seq_analise_p,
					null,
					'C',
					'CO',
					'CON',
					ds_tipo_guia_w,
					ie_status_analise_w,
					ie_selecionado_w,
					ie_pend_grupo_w,
					ie_sem_fluxo_w,
					ie_tipo_guia_w,
					ie_expandido_w,
					'S',
					ie_pcmso_w,
					nr_id_transacao_p,
					nr_seq_guia_w);

				qt_inf_guia_w	:= 1;

				CALL pls_consulta_analise_pck.set_nr_seq_item(nr_sequencia_w + 1);
			end if;
		end if;

		select	count(1)
		into STRICT	qt_exp_w
		from	w_pls_analise_item_exp a
		where	a.nr_seq_analise	= nr_seq_analise_p
		and	a.ie_tipo_guia		= ie_tipo_guia_w
		and	a.nm_usuario		= nm_usuario_p
		and	coalesce(a.nr_seq_conta_proc::text, '') = '';

		if (qt_inf_guia_w = 0) or
			((nr_nivel_w > 2) or (qt_exp_w > 0)) then
			nr_sequencia_w	:= pls_consulta_analise_pck.get_nr_seq_item;
			cd_guia_w	:= pls_consulta_analise_pck.get_cd_guia;
			ds_tipo_guia_w	:= pls_consulta_analise_pck.get_ds_tipo_guia;
			ie_tipo_guia_w	:= pls_consulta_analise_pck.get_ie_tipo_guia;

			ds_ident_w	:= null;
			if (coalesce(cd_guia_w::text, '') = '') then
				cd_guia_w	:= 'Seq: ' || nr_seq_conta_p;
			end if;

			if (qt_inf_guia_w > 0) then
				ds_ident_w	:= '      ';
			end if;

			/* Status geral da análise */

			ie_status_analise_w	:= pls_obter_status_analise_item(nr_seq_analise_p,nr_seq_conta_p, null, null, null,null,'N');

			/* Obter se possui fluxo de análise */

			ie_sem_fluxo_w		:= pls_obter_se_item_sem_fluxo(nr_seq_analise_p,nr_seq_conta_p, null, null,null);

			select	count(1)
			into STRICT	qt_selecao_w
			from	w_pls_analise_selecao_item	a
			where	a.nr_seq_analise	= nr_seq_analise_p
			and	a.nr_seq_w_item		= nr_sequencia_w;

			if (qt_selecao_w > 0) then
				ie_selecionado_w	:= 'S';
			else
				ie_selecionado_w	:= 'N';
			end if;

			insert into w_pls_analise_item(nr_sequencia,
				nm_usuario,
				dt_atualizacao,
				nm_usuario_nrec,
				dt_atualizacao_nrec,
				nr_seq_analise,
				nr_seq_conta,
				ie_tipo_linha,
				ie_tipo_item,
				ie_tipo_despesa,
				ds_item,
				ie_status_analise,
				ie_selecionado,
				ie_pend_grupo,
				ie_sem_fluxo,
				ie_tipo_guia,
				ie_pcmso,
				nr_id_transacao,
				nr_seq_guia)
			values (nr_sequencia_w,
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nr_seq_analise_p,
				nr_seq_conta_p,
				'C',
				'CO',
				'CON',
				ds_ident_w || cd_guia_w || ' - ' || ds_tipo_guia_w,
				ie_status_analise_w,
				ie_selecionado_w,
				ie_pend_grupo_w,
				ie_sem_fluxo_w,
				ie_tipo_guia_w,
				ie_pcmso_w,
				nr_id_transacao_p,
				nr_seq_guia_w);

			CALL pls_consulta_analise_pck.set_nr_seq_item(nr_sequencia_w + 1);
		end if;

	end if;
end if;

/* Interna, sem commit */

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_w_analise_item_conta ( nr_seq_analise_p bigint, nr_seq_conta_p bigint, nr_seq_grupo_p bigint, ie_minha_analise_p text, ie_pendentes_p text, nm_usuario_p text, ie_somente_ocor_p text default 'N', nr_id_transacao_p w_pls_analise_item.nr_id_transacao%type DEFAULT NULL) FROM PUBLIC;
