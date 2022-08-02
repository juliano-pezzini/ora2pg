-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_analise_lib_pag_total ( nr_seq_analise_p bigint, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type, nr_seq_proc_partic_p pls_proc_participante.nr_sequencia%type, nr_seq_mot_liberacao_p bigint, ds_observacao_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_grupo_atual_p bigint, nm_usuario_p usuario.nm_usuario%type, ie_origem_lib_p text, ie_lib_impeditiva_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Liberar pagamento total de um item da análise (Análise Nova)
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_ocorrencia_w			varchar(255);
ie_finalizar_analise_w		varchar(255);
ie_fechar_conta_w		varchar(255);
ie_pre_analise_w		varchar(255)	:= 'N';
ie_status_w			varchar(5);
ie_tipo_valor_w			varchar(3);
ie_status_pagamento_w		varchar(3);
ie_valor_base_w			varchar(1);
ie_liberado_w			varchar(1);
vl_calculado_w			double precision;
vl_pag_medico_conta_w		double precision	:= null;
vl_unitario_w			pls_conta_proc.vl_unitario%type;
vl_unitario_apres_w		pls_conta_proc.vl_unitario%type;
vl_unitario_calc_w		pls_conta_proc.vl_unitario%type;
vl_saldo_w			double precision;
vl_liberado_w			double precision;
vl_glosa_w			double precision;
qt_liberada_w			pls_conta_proc.qt_procedimento_imp%type;
vl_apresentado_w		double precision;
nr_seq_conta_w			bigint;
nr_seq_ocor_benef_w		bigint;
qt_fluxo_w			integer;
nr_seq_fluxo_padrao_w		bigint;
nr_seq_conta_glosa_w		bigint;
ie_status_item_w		varchar(5);
nr_seq_ocorrencia_w		bigint;
nr_seq_conta_proc_w		bigint;
nr_seq_glosa_w			bigint;
nr_nivel_liberacao_w		bigint;
nr_seq_nivel_lib_aud_w		bigint;
nr_nivel_liberacao_aud_w	bigint;
nr_id_w				bigint;
cd_motivo_tiss_w		bigint;
nr_seq_grupo_pre_analise_w	bigint;
nr_seq_conta_pos_estab_w	bigint;
ie_valida_ocor_grupo_w		pls_param_analise_conta.ie_valida_ocor_grupo%type;
ie_val_grupo_w			varchar(1);
qt_glosa_w			integer;
qt_conta_proc_w			integer;
ie_situacao_w			varchar(3);
nr_id_transacao_w		w_pls_analise_item.nr_id_transacao%type;

C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		(SELECT	count(1)
		from	pls_analise_glo_ocor_grupo x
		where	x.nr_seq_analise	= nr_seq_analise_p
		and	x.nr_seq_ocor_benef	= a.nr_sequencia) qt_fluxo,
		a.nr_seq_glosa,
		c.cd_motivo_tiss,
		coalesce(b.ie_finalizar_analise, 'S'),
		coalesce(b.ie_fechar_conta, 'S'),
		a.ie_situacao
	FROM pls_ocorrencia_benef a, pls_ocorrencia b
LEFT OUTER JOIN tiss_motivo_glosa c ON (b.nr_seq_motivo_glosa = c.nr_sequencia)
WHERE a.nr_seq_ocorrencia	= b.nr_sequencia  and a.nr_seq_conta_proc	= nr_seq_conta_proc_w and (((a.ie_documento_fisico = 'N') or (coalesce(a.ie_documento_fisico::text, '') = '')) or (ie_pre_analise_w = 'N')) and (nr_seq_conta_proc_w IS NOT NULL AND nr_seq_conta_proc_w::text <> '')
	
union all

	select	a.nr_sequencia,
		(select	count(1)
		from	pls_analise_glo_ocor_grupo x
		where	x.nr_seq_analise	= nr_seq_analise_p
		and	x.nr_seq_ocor_benef	= a.nr_sequencia) qt_fluxo,
		a.nr_seq_glosa,
		c.cd_motivo_tiss,
		coalesce(b.ie_finalizar_analise, 'S'),
		coalesce(b.ie_fechar_conta, 'S'),
		a.ie_situacao
	FROM pls_ocorrencia_benef a, pls_ocorrencia b
LEFT OUTER JOIN tiss_motivo_glosa c ON (b.nr_seq_motivo_glosa = c.nr_sequencia)
WHERE a.nr_seq_ocorrencia	= b.nr_sequencia  and a.nr_seq_conta_mat	= nr_seq_conta_mat_p and (((a.ie_documento_fisico = 'N') or (coalesce(a.ie_documento_fisico::text, '') = '')) or (ie_pre_analise_w = 'N')) and (nr_seq_conta_mat_p IS NOT NULL AND nr_seq_conta_mat_p::text <> '')
	 
union all

	select	a.nr_sequencia,
		(select	count(1)
		from	pls_analise_glo_ocor_grupo x
		where	x.nr_seq_analise	= nr_seq_analise_p
		and	x.nr_seq_ocor_benef	= a.nr_sequencia) qt_fluxo,
		a.nr_seq_glosa,
		c.cd_motivo_tiss,
		coalesce(b.ie_finalizar_analise, 'S'),
		coalesce(b.ie_fechar_conta, 'S'),
		a.ie_situacao
	FROM pls_ocorrencia_benef a, pls_ocorrencia b
LEFT OUTER JOIN tiss_motivo_glosa c ON (b.nr_seq_motivo_glosa = c.nr_sequencia)
WHERE a.nr_seq_ocorrencia = b.nr_sequencia  and a.nr_seq_proc_partic	= nr_seq_proc_partic_p and (((a.ie_documento_fisico = 'N') or (coalesce(a.ie_documento_fisico::text, '') = '')) or (ie_pre_analise_w = 'N')) and (nr_seq_proc_partic_p IS NOT NULL AND nr_seq_proc_partic_p::text <> '')
	 
union all

	select	a.nr_sequencia,
		(select	count(1)
		from	pls_analise_glo_ocor_grupo x
		where	x.nr_seq_analise	= nr_seq_analise_p
		and	x.nr_seq_ocor_benef	= a.nr_sequencia) qt_fluxo,
		a.nr_seq_glosa,
		null cd_motivo_tiss,
		coalesce(b.ie_finalizar_analise, 'S'),
		coalesce(b.ie_fechar_conta, 'S'),
		a.ie_situacao
	from	pls_ocorrencia b,
		pls_ocorrencia_benef a
	where	a.nr_seq_ocorrencia	= b.nr_sequencia
	and	a.nr_seq_conta	 	= nr_seq_conta_p
	and	(((a.ie_documento_fisico = 'N') or (coalesce(a.ie_documento_fisico::text, '') = '')) or (ie_pre_analise_w = 'N'))
	and	coalesce(a.nr_seq_proc_partic::text, '') = ''
	and	coalesce(a.nr_seq_conta_mat::text, '') = ''
	and	coalesce(a.nr_seq_conta_proc::text, '') = ''
	and	coalesce(nr_seq_proc_partic_p::text, '') = ''
	and	coalesce(nr_seq_conta_mat_p::text, '') = ''
	and	coalesce(nr_seq_conta_proc_w::text, '') = '';

/* Glosas sem fluxo */

C02 CURSOR FOR
	SELECT	a.nr_sequencia,
		(SELECT	count(1)
		from	pls_analise_glo_ocor_grupo x
		where	x.nr_seq_analise	= nr_seq_analise_p
		and	x.nr_seq_conta_glosa	= a.nr_sequencia
		and	x.nr_seq_grupo		= nr_seq_grupo_atual_p) qt_fluxo,
		b.cd_motivo_tiss
	FROM pls_conta_glosa a
LEFT OUTER JOIN tiss_motivo_glosa b ON (a.nr_seq_motivo_glosa = b.nr_sequencia)
WHERE a.ie_situacao	= 'A'  and a.nr_seq_conta_proc	= nr_seq_conta_proc_w and not exists (select	1
				from	pls_ocorrencia_benef x
				where	x.nr_seq_glosa = a.nr_sequencia)
	
union all

	select	a.nr_sequencia,
		(select	count(1)
		from	pls_analise_glo_ocor_grupo x
		where	x.nr_seq_analise	= nr_seq_analise_p
		and	x.nr_seq_conta_glosa	= a.nr_sequencia
		and	x.nr_seq_grupo		= nr_seq_grupo_atual_p) qt_fluxo,
		b.cd_motivo_tiss
	FROM pls_conta_glosa a
LEFT OUTER JOIN tiss_motivo_glosa b ON (a.nr_seq_motivo_glosa = b.nr_sequencia)
WHERE a.ie_situacao	= 'A'  and a.nr_seq_conta_mat	= nr_seq_conta_mat_p and not exists (select	1
				from	pls_ocorrencia_benef x
				where	x.nr_seq_glosa = a.nr_sequencia)
	 
union all

	select	a.nr_sequencia,
		(select	count(1)
		from	pls_analise_glo_ocor_grupo x
		where	x.nr_seq_analise	= nr_seq_analise_p
		and	x.nr_seq_conta_glosa	= a.nr_sequencia
		and	x.nr_seq_grupo		= nr_seq_grupo_atual_p) qt_fluxo,
		b.cd_motivo_tiss
	FROM pls_conta_glosa a
LEFT OUTER JOIN tiss_motivo_glosa b ON (a.nr_seq_motivo_glosa = b.nr_sequencia)
WHERE a.ie_situacao	= 'A'  and a.nr_seq_proc_partic	= nr_seq_proc_partic_p and not exists (select	1
				from	pls_ocorrencia_benef x
				where	x.nr_seq_glosa = a.nr_sequencia)
	 
union all

	select	a.nr_sequencia,
		(select	count(1)
		from	pls_analise_glo_ocor_grupo x
		where	x.nr_seq_analise	= nr_seq_analise_p
		and	x.nr_seq_conta_glosa	= a.nr_sequencia
		and	x.nr_seq_grupo		= nr_seq_grupo_atual_p) qt_fluxo,
		null cd_motivo_tiss
	from	pls_conta_glosa a
	where	a.nr_seq_conta	 = nr_seq_conta_p
	and	a.ie_situacao	= 'A'
	and	coalesce(a.nr_seq_proc_partic::text, '') = ''
	and	coalesce(a.nr_seq_conta_mat::text, '') = ''
	and	coalesce(a.nr_seq_conta_proc::text, '') = ''
	and	coalesce(nr_seq_proc_partic_p::text, '') = ''
	and	coalesce(nr_seq_conta_mat_p::text, '') = ''
	and	coalesce(nr_seq_conta_proc_w::text, '') = ''
	and 	not exists (select	1
				from	pls_ocorrencia_benef x
				where	x.nr_seq_glosa = a.nr_sequencia);


BEGIN

if (nr_seq_analise_p IS NOT NULL AND nr_seq_analise_p::text <> '') then
	begin
	select	max(nr_id_transacao)
	into STRICT	nr_id_transacao_w
	from	w_pls_analise_item
	where	nr_seq_analise	= nr_seq_analise_p
	and		nm_usuario		= nm_usuario_p;

	select	max(ie_valida_ocor_grupo)
	into STRICT	ie_valida_ocor_grupo_w
	from	pls_param_analise_conta
	where	cd_estabelecimento	= cd_estabelecimento_p;

	if (ie_valida_ocor_grupo_w	= 'S') then
		ie_val_grupo_w	:= 'N';
	else
		ie_val_grupo_w	:= 'S';
	end if;

	select	max(a.nr_seq_grupo_pre_analise)
	into STRICT	nr_seq_grupo_pre_analise_w
	from	pls_parametros	a
	where	a.cd_estabelecimento	= cd_estabelecimento_p;

	if (nr_seq_grupo_pre_analise_w = nr_seq_grupo_atual_p) then
		ie_pre_analise_w	:= 'S';
	else
		ie_pre_analise_w	:= 'N';
	end if;

	select	coalesce(a.nr_seq_nivel_lib, b.nr_seq_nivel_lib)
	into STRICT	nr_seq_nivel_lib_aud_w
	from	pls_membro_grupo_aud	a,
		pls_grupo_auditor	b
	where	a.nr_seq_grupo 		= nr_seq_grupo_atual_p
	and	a.nm_usuario_exec 	= nm_usuario_p
	and	a.nr_seq_grupo 		= b.nr_sequencia;
	exception
	when others then
		nr_seq_nivel_lib_aud_w	:= null;
	end;

	select	max(nr_nivel_liberacao)
	into STRICT	nr_nivel_liberacao_aud_w
	from	pls_nivel_liberacao
	where	nr_sequencia	= nr_seq_nivel_lib_aud_w;

	if (nr_seq_proc_partic_p IS NOT NULL AND nr_seq_proc_partic_p::text <> '') then
		/* Verificar se o item ainda está indefinido, daí não pode glosar direto o partic */

		select	b.ie_status_pagamento
		into STRICT	ie_status_pagamento_w
		from	pls_conta_proc b,
			pls_proc_participante a
		where	a.nr_seq_conta_proc = b.nr_sequencia
		and	a.nr_sequencia	= nr_seq_proc_partic_p;

		select	count(1)
		into STRICT	qt_conta_proc_w
		from	w_pls_analise_item
		where	nr_seq_analise		= nr_seq_analise_p
		and		coalesce(nr_seq_proc_partic::text, '') = ''
		and		nr_id_transacao		= nr_id_transacao_w
		and		nr_seq_conta_proc	= nr_seq_conta_proc_p
		and		ie_selecionado		= 'S';

		if (ie_status_pagamento_w = 'I') and (qt_conta_proc_w	= 0) then
			select	max(a.nr_identificador)
			into STRICT	nr_id_w
			from	w_pls_analise_item a
			where	a.nr_seq_analise		= nr_seq_analise_p
			and		a.nr_id_transacao		= nr_id_transacao_w
			and		a.nr_seq_proc_partic	= nr_seq_proc_partic_p;

			CALL wheb_mensagem_pck.exibir_mensagem_abort(214319,'NR_ID=' || nr_id_w, - 20012);
		end if;

		select	max(d.nr_nivel_liberacao)
		into STRICT	nr_nivel_liberacao_w
		FROM pls_nivel_liberacao d, pls_proc_participante c, pls_ocorrencia_benef b, pls_ocorrencia a
LEFT OUTER JOIN tiss_motivo_glosa e ON (a.nr_seq_motivo_glosa = e.nr_sequencia)
WHERE a.nr_sequencia	= b.nr_seq_ocorrencia and c.nr_sequencia	= b.nr_seq_proc_partic  and (coalesce(e.cd_motivo_tiss::text, '') = '' or e.cd_motivo_tiss not in ('1705','1706')) and c.nr_sequencia	= nr_seq_proc_partic_p and d.nr_sequencia	= a.nr_seq_nivel_lib and b.ie_situacao	= 'A';

		/* Participante não tem valor base, liberar sempre o calculado */

		select	a.vl_apresentado,
			a.vl_calculado,
			dividir_sem_round(a.vl_apresentado,b.qt_procedimento_imp),
			dividir_sem_round(a.vl_calculado,b.qt_procedimento_imp),
			b.qt_procedimento_imp
		into STRICT	vl_apresentado_w,
			vl_calculado_w,
			vl_unitario_apres_w,
			vl_unitario_calc_w,
			qt_liberada_w
		from	pls_conta_proc b,
			pls_proc_participante a
		where	a.nr_seq_conta_proc = b.nr_sequencia
		and	a.nr_sequencia	= nr_seq_proc_partic_p;

		nr_seq_conta_proc_w	:= null;

		vl_unitario_w	:= vl_unitario_calc_w;
		vl_liberado_w	:= vl_calculado_w;
		vl_glosa_w	:= 0;

		if (vl_calculado_w > vl_liberado_w) then
			vl_saldo_w	:= abs(vl_glosa_w);
		else
			vl_saldo_w	:= 0;
		end if;

		if (coalesce(nr_nivel_liberacao_aud_w,0) >= coalesce(nr_nivel_liberacao_w,0)) then
			vl_liberado_w := pls_atualiza_conta_item(nr_seq_proc_partic_p, 'R', /* Participante */
						null, /* Motivo de glosa */
						vl_unitario_w, vl_liberado_w, vl_glosa_w, vl_saldo_w, null, /* Vl prestador */
						qt_liberada_w, null, /* Observação da glosa */
						'A', /* Origem - Análise */
						cd_estabelecimento_p, nm_usuario_p, 'N', /* commit */
						vl_pag_medico_conta_w, 'N', /* Conta inteira */
						'C', /* Calculado */
						'S', /* Conta auditoria */
						null, null, null, null, null, null);
		end if;

		nr_seq_conta_pos_estab_w	:= null;

	elsif (nr_seq_conta_proc_p IS NOT NULL AND nr_seq_conta_proc_p::text <> '') then
		select	max(d.nr_nivel_liberacao),
			coalesce(min(a.ie_finalizar_analise),'S'),
			coalesce(min(a.ie_fechar_conta),'S')
		into STRICT	nr_nivel_liberacao_w,
			ie_finalizar_analise_w,
			ie_fechar_conta_w
		FROM pls_conta_proc c, pls_ocorrencia_benef b, pls_ocorrencia a
LEFT OUTER JOIN tiss_motivo_glosa e ON (a.nr_seq_motivo_glosa = e.nr_sequencia)
LEFT OUTER JOIN pls_nivel_liberacao d ON (a.nr_seq_nivel_lib = d.nr_sequencia)
WHERE a.nr_sequencia		= b.nr_seq_ocorrencia and c.nr_sequencia		= b.nr_seq_conta_proc  and (coalesce(e.cd_motivo_tiss::text, '') = '' or e.cd_motivo_tiss not in ('1705','1706') ) and c.nr_sequencia		= nr_seq_conta_proc_p  and b.ie_situacao	= 'A';

		select	a.nr_seq_conta,
			a.ie_valor_base,
			coalesce(a.vl_procedimento_imp,0),
			coalesce(a.vl_procedimento,0),
			a.ie_status
		into STRICT	nr_seq_conta_w,
			ie_valor_base_w,
			vl_apresentado_w,
			vl_calculado_w,
			ie_status_item_w
		from	pls_conta_proc a
		where	a.nr_sequencia	= nr_seq_conta_proc_p;

		nr_seq_conta_proc_w	:= nr_seq_conta_proc_p;

		select 	count(1)
		into STRICT	qt_glosa_w
		from	pls_conta_glosa		a,
			tiss_motivo_glosa	b
		where	a.nr_seq_conta_proc	= nr_seq_conta_proc_w
		and	a.nr_seq_motivo_glosa	= b.nr_sequencia
		and	b.cd_motivo_tiss 	= '1705';

		if (	ie_valor_base_w in ('1','4')) or (	qt_glosa_w	= 0) and
			not((ie_valor_base_w	in ('2','3')) and (vl_calculado_w > vl_apresentado_w))then
			ie_tipo_valor_w	:= 'A'; /* Aceitar valor apresentado */
		elsif (	coalesce(ie_valor_base_w::text, '') = '') and (	vl_apresentado_w > 0) 	and (	vl_calculado_w 	= 0 ) 	then
			ie_tipo_valor_w	:= 'A';
		else
			ie_tipo_valor_w	:= 'P'; /* Aceitar valor processo - Calculado */
		end if;

		if (coalesce(nr_nivel_liberacao_aud_w,0) >= coalesce(nr_nivel_liberacao_w,0))  and
			((ie_finalizar_analise_w = 'S' AND ie_fechar_conta_w = 'S') or (ie_lib_impeditiva_p = 'S'))then
			CALL pls_conta_aceitar_valor(null, /* Conta só deve passar quando for para toda conta */
						nr_seq_conta_proc_p,
						null,
						null, /* Opção deve ser nula, não necessário quando por item */
						ie_tipo_valor_w,
						cd_estabelecimento_p,
						'A',
						nm_usuario_p,
						nr_seq_analise_p,
						nr_seq_grupo_atual_p,
						ds_observacao_p);
		end if;

		begin
			select	a.nr_sequencia
			into STRICT	nr_seq_conta_pos_estab_w
			from	pls_conta_pos_estabelecido a
			where	a.nr_seq_conta_proc	= nr_seq_conta_proc_p
			and	((ie_situacao		= 'A')or (coalesce(ie_situacao::text, '') = ''));
		exception
			when others then
			nr_seq_conta_pos_estab_w	:= null;
		end;
	elsif (nr_seq_conta_mat_p IS NOT NULL AND nr_seq_conta_mat_p::text <> '') then
		select	max(d.nr_nivel_liberacao),
			coalesce(min(a.ie_finalizar_analise),'S'),
			coalesce(min(a.ie_fechar_conta),'S')
		into STRICT	nr_nivel_liberacao_w,
			ie_finalizar_analise_w,
			ie_fechar_conta_w
		FROM pls_conta_mat c, pls_ocorrencia_benef b, pls_ocorrencia a
LEFT OUTER JOIN tiss_motivo_glosa e ON (a.nr_seq_motivo_glosa = e.nr_sequencia)
LEFT OUTER JOIN pls_nivel_liberacao d ON (a.nr_seq_nivel_lib = d.nr_sequencia)
WHERE a.nr_sequencia		= b.nr_seq_ocorrencia and c.nr_sequencia		= b.nr_seq_conta_mat  and (coalesce(e.cd_motivo_tiss::text, '') = '' or e.cd_motivo_tiss not in ('1705','1706')) and c.nr_sequencia		= nr_seq_conta_mat_p  and b.ie_situacao		= 'A';

		select	a.ie_valor_base,
			coalesce(a.vl_material_imp,0),
			coalesce(a.vl_material,0)
		into STRICT	ie_valor_base_w,
			vl_apresentado_w,
			vl_calculado_w
		from	pls_conta_mat a
		where	a.nr_sequencia	= nr_seq_conta_mat_p;

		select 	count(1)
		into STRICT	qt_glosa_w
		from	pls_conta_glosa		a,
			tiss_motivo_glosa	b
		where	nr_seq_conta_mat	= nr_seq_conta_mat_p
		and	a.nr_seq_motivo_glosa	= b.nr_sequencia
		and	b.cd_motivo_tiss 	= '1705';

		if (	ie_valor_base_w in ('1','4')) or (	qt_glosa_w	= 0) and
			not((ie_valor_base_w	in ('2','3')) and (vl_calculado_w > vl_apresentado_w)) then
			ie_tipo_valor_w	:= 'A'; /* Aceitar valor apresentado */
		elsif (	coalesce(ie_valor_base_w::text, '') = '') and (	vl_apresentado_w > 0) 	and (	vl_calculado_w 	= 0 ) 	then
			ie_tipo_valor_w	:= 'A';
		else
			ie_tipo_valor_w	:= 'P'; /* Aceitar valor processo - Calculado */
		end if;

		if (coalesce(nr_nivel_liberacao_aud_w,0) >= coalesce(nr_nivel_liberacao_w,0)) and
			((ie_finalizar_analise_w = 'S' AND ie_fechar_conta_w = 'S') or (ie_lib_impeditiva_p = 'S'))then
			CALL pls_conta_aceitar_valor(null, /* Conta só deve passar quando for para toda conta */
						null,
						nr_seq_conta_mat_p,
						null, /* Opção deve ser nula, não necessário quando por item */
						ie_tipo_valor_w,
						cd_estabelecimento_p,
						'A',
						nm_usuario_p,
						nr_seq_analise_p,
						nr_seq_grupo_atual_p,
						ds_observacao_p);
		end if;

		begin
			select	a.nr_sequencia
			into STRICT	nr_seq_conta_pos_estab_w
			from	pls_conta_pos_estabelecido a
			where	a.nr_seq_conta_mat	= nr_seq_conta_mat_p
			and	((ie_situacao		= 'A')or (coalesce(ie_situacao::text, '') = ''));
		exception
			when others then
			nr_seq_conta_pos_estab_w	:= null;
		end;
	elsif (nr_seq_conta_p IS NOT NULL AND nr_seq_conta_p::text <> '') then
		/* Conta */

		null;
		nr_seq_conta_pos_estab_w	:= null;
	end if;

	/* Mudar o status das ocorrências do o grupo que está analisando */

	open C01;
	loop
	fetch C01 into
		nr_seq_ocor_benef_w,
		qt_fluxo_w,
		nr_seq_glosa_w,
		cd_motivo_tiss_w,
		ie_finalizar_analise_w,
		ie_fechar_conta_w,
		ie_situacao_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		select	max(a.nr_seq_ocorrencia)
		into STRICT	nr_seq_ocorrencia_w
		from	pls_ocorrencia_benef	a
		where	a.nr_sequencia	= nr_seq_ocor_benef_w;
		ie_liberado_w	:= 'S';

		if (ie_situacao_w = 'A') then
			ie_liberado_w	:= pls_obter_se_nivel_lib_auditor(nr_seq_ocorrencia_w, nr_seq_grupo_atual_p, nm_usuario_p, ie_val_grupo_w);
		end if;
		--Tratamento realizado para adequar a tratamento anterior onde as glosas de valor são desconsideradas para esta situação
		if (ie_liberado_w = 'N') and (ie_origem_lib_p <> 'S') and (coalesce(cd_motivo_tiss_w,'0') not in ('1705','1706')) then
			select	max(ds_ocorrencia)
			into STRICT	ds_ocorrencia_w
			from	pls_ocorrencia
			where	nr_sequencia	= nr_seq_ocorrencia_w;

			CALL wheb_mensagem_pck.exibir_mensagem_abort(207091,';DS_OCORR='||ds_ocorrencia_w);
		end if;

		ie_status_w	:= 'L';

		if (coalesce(cd_motivo_tiss_w,'0') in ('1705','1706') ) then
			ie_status_w := 'N'; -- alterado pois o status Glosado é N e não G
		end if;

		/* Se não tem fluxo para a ocorrência, dar insert do fluxo */

		if (qt_fluxo_w = 0) then
			insert into pls_analise_glo_ocor_grupo(nr_sequencia,
				nm_usuario,
				dt_atualizacao,
				nm_usuario_nrec,
				dt_atualizacao_nrec,
				nr_seq_analise,
				nr_seq_ocor_benef,
				nr_seq_grupo,
				nr_seq_fluxo,
				ie_fluxo_gerado,
				nm_usuario_analise,
				dt_analise,
				ie_status)
			values (nextval('pls_analise_glo_ocor_grupo_seq'),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nr_seq_analise_p,
				nr_seq_ocor_benef_w,
				nr_seq_grupo_atual_p,
				nr_seq_fluxo_padrao_w,
				'S',
				nm_usuario_p,
				clock_timestamp(),
				ie_status_w);
		else
			update	pls_analise_glo_ocor_grupo
			set	ie_status		= ie_status_w, -- Liberado
				nm_usuario		= nm_usuario_p,
				dt_atualizacao		= clock_timestamp(),
				nm_usuario_analise	= nm_usuario_p,
				dt_analise		= clock_timestamp()
			where	nr_seq_ocor_benef	= nr_seq_ocor_benef_w
			and	nr_seq_grupo		= nr_seq_grupo_atual_p;
		end if;

		/* Francisco - 23/11/2012 - Só inativar as ocorrências que não são de valor */

		if (coalesce(cd_motivo_tiss_w,'0') not in ('1705','1706')) and
			((ie_finalizar_analise_w = 'S' AND ie_fechar_conta_w = 'S') or (ie_lib_impeditiva_p = 'S')) then
			update	pls_ocorrencia_benef
			set	ie_situacao		= 'I',
				nm_usuario		= nm_usuario_p,
				dt_atualizacao		= clock_timestamp(),
				ie_forma_inativacao	= CASE WHEN ie_forma_inativacao='S' THEN 'US' WHEN ie_forma_inativacao='US' THEN 'US'  ELSE 'U' END
			where	nr_sequencia		= nr_seq_ocor_benef_w
			and	((ie_situacao	!= 'I') or (coalesce(ie_situacao::text, '') = ''));

			update	pls_ocorrencia_benef
			set	ie_situacao		= 'I',
				nm_usuario		= nm_usuario_p,
				dt_atualizacao		= clock_timestamp(),
				ie_forma_inativacao	= CASE WHEN ie_forma_inativacao='S' THEN 'US' WHEN ie_forma_inativacao='US' THEN 'US'  ELSE 'U' END
			where	nr_seq_ocor_pag		= nr_seq_ocor_benef_w
			and	((ie_situacao	!= 'I') or (coalesce(ie_situacao::text, '') = ''));

			if (coalesce(nr_seq_glosa_w::text, '') = '') then
				begin
				select	max(a.nr_sequencia)
				into STRICT	nr_seq_glosa_w
				from	pls_conta_glosa a
				where	a.nr_seq_ocorrencia_benef = nr_seq_ocor_benef_w;
				exception
				when others then
					nr_seq_glosa_w	:= null;
				end;
			end if;

			if (nr_seq_glosa_w IS NOT NULL AND nr_seq_glosa_w::text <> '') then
				update	pls_conta_glosa
				set	ie_situacao		= 'I',
					nm_usuario		= nm_usuario_p,
					dt_atualizacao		= clock_timestamp(),
					ie_forma_inativacao	= CASE WHEN ie_forma_inativacao='S' THEN 'US' WHEN ie_forma_inativacao='US' THEN 'US'  ELSE 'U' END
				where	nr_sequencia		= nr_seq_glosa_w
				and	((ie_situacao	!= 'I') or (coalesce(ie_situacao::text, '') = ''));
			end if;
		else
			update	pls_ocorrencia_benef
			set	nm_usuario		= nm_usuario_p,
				dt_atualizacao		= clock_timestamp(),
				ie_lib_manual		= 'N'
			where	nr_sequencia		= nr_seq_ocor_benef_w
			and	((ie_situacao	!= 'I') or (coalesce(ie_situacao::text, '') = ''));

			update	pls_ocorrencia_benef
			set	nm_usuario		= nm_usuario_p,
				dt_atualizacao		= clock_timestamp(),
				ie_lib_manual		= 'N'
			where	nr_seq_ocor_pag		= nr_seq_ocor_benef_w
			and	((ie_situacao	!= 'I') or (coalesce(ie_situacao::text, '') = ''));

			if (coalesce(nr_seq_glosa_w::text, '') = '') then
				begin
				select	max(a.nr_sequencia)
				into STRICT	nr_seq_glosa_w
				from	pls_conta_glosa a
				where	a.nr_seq_ocorrencia_benef	= nr_seq_ocor_benef_w;
				exception
				when others then
					nr_seq_glosa_w	:= null;
				end;
			end if;

			if (nr_seq_glosa_w IS NOT NULL AND nr_seq_glosa_w::text <> '') then
				update	pls_conta_glosa
				set	nm_usuario		= nm_usuario_p,
					dt_atualizacao		= clock_timestamp(),
					ie_lib_manual		= 'N'
				where	nr_sequencia		= nr_seq_glosa_w
				and	((ie_situacao	!= 'I') or (coalesce(ie_situacao::text, '') = ''));
			end if;

		end if;
		end;
	end loop;
	close C01;

	/* Criar um fluxo pro grupo que está analisando para marcar as glosas sem ocorrência vinculada (sem fluxo) */

	open C02;
	loop
	fetch C02 into
		nr_seq_conta_glosa_w,
		qt_fluxo_w,
		cd_motivo_tiss_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin

		ie_status_w	:= 'L';

		if (coalesce(cd_motivo_tiss_w,'0') in ('1705','1706') ) then
			ie_status_w	:= 'N';
		end if;

		if (qt_fluxo_w = 0) then
			insert into pls_analise_glo_ocor_grupo(nr_sequencia,
				nm_usuario,
				dt_atualizacao,
				nm_usuario_nrec,
				dt_atualizacao_nrec,
				nr_seq_analise,
				nr_seq_conta_glosa,
				nr_seq_grupo,
				nr_seq_fluxo,
				ie_fluxo_gerado,
				nm_usuario_analise,
				dt_analise,
				ie_status)
			values (nextval('pls_analise_glo_ocor_grupo_seq'),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nr_seq_analise_p,
				nr_seq_conta_glosa_w,
				nr_seq_grupo_atual_p,
				nr_seq_fluxo_padrao_w,
				'S',
				nm_usuario_p,
				clock_timestamp(),
				ie_status_w);
		else
			update	pls_analise_glo_ocor_grupo
			set	ie_status		= ie_status_w, /* Liberado */
				nm_usuario		= nm_usuario_p,
				dt_atualizacao		= clock_timestamp(),
				nm_usuario_analise	= nm_usuario_p,
				dt_analise		= clock_timestamp()
			where	nr_seq_conta_glosa	= nr_seq_conta_glosa_w
			and	nr_seq_grupo		= nr_seq_grupo_atual_p;
		end if;

		/*Inativar a glosa */

		if (coalesce(cd_motivo_tiss_w,'0') not in ('1705','1706') ) then
			update	pls_conta_glosa
			set	ie_situacao		= 'I',
				nm_usuario		= nm_usuario_p,
				dt_atualizacao		= clock_timestamp(),
				ie_forma_inativacao	= CASE WHEN ie_forma_inativacao='S' THEN 'US' WHEN ie_forma_inativacao='US' THEN 'US'  ELSE 'U' END
			where	nr_sequencia		= nr_seq_conta_glosa_w
			and	((ie_situacao	!= 'I') or (coalesce(ie_situacao::text, '') = ''));
		end if;
		end;
	end loop;
	close C02;

	/* Liberar faturamento pos */

	if (nr_seq_conta_pos_estab_w IS NOT NULL AND nr_seq_conta_pos_estab_w::text <> '') then
		CALL pls_analise_lib_fat_total_pos(nr_seq_analise_p,
					nr_seq_conta_pos_estab_w,
					nr_seq_conta_proc_p,
					nr_seq_conta_mat_p,
					nr_seq_proc_partic_p,
					nr_seq_mot_liberacao_p,
					ds_observacao_p,
					cd_estabelecimento_p,
					nr_seq_grupo_atual_p,
					nm_usuario_p);
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_analise_lib_pag_total ( nr_seq_analise_p bigint, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type, nr_seq_proc_partic_p pls_proc_participante.nr_sequencia%type, nr_seq_mot_liberacao_p bigint, ds_observacao_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_grupo_atual_p bigint, nm_usuario_p usuario.nm_usuario%type, ie_origem_lib_p text, ie_lib_impeditiva_p text) FROM PUBLIC;

