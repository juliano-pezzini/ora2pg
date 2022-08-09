-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE codificacao_finalizar_analise ( nr_sequencia_p bigint, nm_usuario_p text ) AS $body$
DECLARE


ie_tipo_item_w			codificacao_atend_item.ie_tipo_item%type;
cd_doenca_cid_w			codificacao_atend_item.cd_doenca_cid%type;
nr_seq_proc_pac_w		codificacao_atend_item.nr_seq_proc_pac%type;
nr_seq_diag_pac_w 		codificacao_atend_item.nr_seq_diag_pac%type;
ie_classificacao_w		codificacao_atend_item.ie_classificacao%type;
nr_sequencia_w			codificacao_atend_item.nr_sequencia%type;
cd_cid_oncologia_w		codificacao_atend_item.cd_cid_oncologia%type;
qt_class_w				smallint;
qt_classi_w				smallint;
qt_diag_pac_w			smallint;
qt_diag_and_proc_w		smallint;
qt_proc_and_diag_w		smallint;
qt_diag_val_w			bigint;
qt_prod_val_w			bigint;
ie_classif_w			codificacao_atend_item.ie_classificacao%type;
cd_doenca_w				diagnostico_doenca.cd_doenca%type;
nr_seq_grupo_w			codificacao_grupo_perfil.nr_seq_grupo%type;
cd_grupo_atual_w		codificacao_atendimento.cd_grupo_atual%type;
cd_grupo_inicial_w		codificacao_atendimento.cd_grupo_inicial%type;
nr_ordem_atual_w		codificacao_grupo.nr_ordem%type;
nr_ordem_set_w			codificacao_grupo.nr_ordem%type;
cd_doenca_cid_set_w		codificacao_regra_lib.cd_doenca_cid%type;
cd_grupo_set_w			codificacao_regra_lib.cd_doenca_cid%type;
exige_cid_w				smallint;
nm_responsavel_w		codificacao_atendimento.nm_responsavel%type;
cd_grupo_anterior_w		codificacao_atendimento.cd_grupo_anterior%type;
dt_inicio_analise_w		codificacao_atendimento.dt_inicio_analise%type;
ie_permite_liberar_w	codificacao_grupo.ie_libera%type;
cd_espec_set_w			codificacao_regra_lib.cd_especialidade_cid%type;
cd_categoria_set_w		codificacao_regra_lib.cd_categoria_cid%type;

ie_regra_cid_w			varchar(1) := 'N';
ie_regra_espec_w		varchar(1) := 'N';
ie_regra_categ_w		varchar(1) := 'N';


cd_proximo_grupo_w		codificacao_atendimento.cd_grupo_atual%type;
nr_ordem_prox_grupo_w	codificacao_grupo.nr_ordem%type;

c01 CURSOR FOR
SELECT		ie_tipo_item,
		cd_doenca_cid,
		nr_seq_proc_pac,
		nr_seq_diag_pac,
		ie_classificacao,
		nr_sequencia,
		cd_cid_oncologia
from		codificacao_atend_item
where		nr_seq_codificacao = nr_sequencia_p;


BEGIN

	select	max(a.nr_seq_grupo),
		coalesce(max(b.ie_libera), 'N')
	into STRICT	nr_seq_grupo_w,
		ie_permite_liberar_w
	from	codificacao_grupo_perfil a,
		codificacao_grupo b
	where	a.cd_perfil = wheb_usuario_pck.get_cd_perfil
	and	a.nr_seq_grupo = b.nr_sequencia;

	select	max(a.cd_grupo_atual),
		max(a.cd_grupo_inicial),
		max(b.nr_ordem),
		max(a.nm_responsavel),
		max(a.cd_grupo_anterior),
		max(a.dt_inicio_analise)
	into STRICT	cd_grupo_atual_w,
		cd_grupo_inicial_w,
		nr_ordem_atual_w,
		nm_responsavel_w,
		cd_grupo_anterior_w,
		dt_inicio_analise_w
	from	codificacao_atendimento a,
		codificacao_grupo b
	where	a.nr_sequencia = nr_sequencia_p
	and	b.nr_sequencia = a.cd_grupo_atual;

	select	count(*)
	into STRICT	qt_class_w
	from	codificacao_atend_item
	where	(cd_doenca_cid IS NOT NULL AND cd_doenca_cid::text <> '')
	and	(ie_classificacao IS NOT NULL AND ie_classificacao::text <> '')
	and	nr_seq_codificacao = nr_sequencia_p
	and 	coalesce(dt_inativacao::text, '') = '';

	if (qt_class_w = 0 )then--// se caso nenhum dos itens do paciente tiver cid e classificação verificar se tem nr_seq_diag_pac
		select	count(*)
		into STRICT	qt_diag_pac_w
		from	codificacao_atend_item
		where	nr_seq_codificacao = nr_sequencia_p
		and	nr_seq_diag_pac is  not null;

		if (qt_diag_pac_w = 0 ) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(1043250);--É necessário classificar pelo menos um item da codificação como principal.
		end if;
	end if;

		select	count(*)
		into STRICT  	qt_diag_val_w
		from  	codificacao_atend_item a
		where 	a.nr_seq_codificacao = nr_sequencia_p
		and   	a.ie_tipo_item = 'D'
		and   	coalesce(a.dt_inativacao::text, '') = ''
		and   	coalesce(a.ie_classificacao, 'S') = 'P'
		and   	exists (SELECT 1 from codificacao_atend_item b where b.nr_seq_codificacao = a.nr_seq_codificacao and coalesce(b.dt_inativacao::text, '') = '')
		and   	not exists (select 1 from codificacao_atend_item c where c.nr_seq_codificacao = a.nr_seq_codificacao and coalesce(c.dt_inativacao::text, '') = '' and c.ie_classificacao = 'D' and c.ie_tipo_item = 'P');

		if (qt_diag_val_w <> 1 ) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(1060244);--É necessário classificar pelo menos um diagnóstico da codificação como principal.
		end if;
		
		select count(*)
		into STRICT 	qt_classi_w
		from	codificacao_atend_item a
		where	a.nr_seq_codificacao = nr_sequencia_p
		and	a.ie_tipo_item = 'P'
		and	coalesce(a.dt_inativacao::text, '') = ''
		and	coalesce(a.ie_classificacao, 'S') <> 'P'
		and	exists (SELECT 1 from codificacao_atend_item b where b.nr_seq_codificacao = a.nr_seq_codificacao and coalesce(b.dt_inativacao::text, '') = '')
		and	not exists (select 1 from codificacao_atend_item c where c.nr_seq_codificacao = a.nr_seq_codificacao and coalesce(c.dt_inativacao::text, '') = '' and c.ie_classificacao = 'P' and c.ie_tipo_item = 'P');

		if (qt_classi_w > 0) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(1060179);--Deve haver pelo menos um procedimento classificado como "Principal" para finalizar a análise.
		end if;

		select	count(*)
		into STRICT 	qt_prod_val_w
		from 	codificacao_atend_item
		where	nr_seq_codificacao = nr_sequencia_p
		and 	ie_tipo_item = 'P'
		and 	coalesce(dt_inativacao::text, '') = ''
		and 	coalesce(ie_classificacao::text, '') = '';

		if (qt_prod_val_w > 0 ) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(1060242);--Favor informar a classificação de todos os procedimentos.
		end if;

	open c01;
	loop
	fetch c01 into
		ie_tipo_item_w,
		cd_doenca_cid_w,
		nr_seq_proc_pac_w,
		nr_seq_diag_pac_w,
		ie_classificacao_w,
		nr_sequencia_w,
		cd_cid_oncologia_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

		if (coalesce(cd_doenca_cid_w::text, '') = '' and (nr_seq_diag_pac_w IS NOT NULL AND nr_seq_diag_pac_w::text <> '')) then--buscar o valor do cid doenca caso não tenha.
			select	cd_doenca
			into STRICT	cd_doenca_w
			from	diagnostico_doenca
			where	nr_seq_interno = nr_seq_diag_pac_w
			and	(cd_doenca IS NOT NULL AND cd_doenca::text <> '');

			if (cd_doenca_w IS NOT NULL AND cd_doenca_w::text <> '') then

				update	codificacao_atend_item
				set	cd_doenca_cid = cd_doenca_w
				where	nr_sequencia = nr_sequencia_w
				and	nr_seq_codificacao = nr_sequencia_p;

			end if;
		end if;

		if (coalesce(ie_classificacao_w::text, '') = '' and (nr_seq_diag_pac_w IS NOT NULL AND nr_seq_diag_pac_w::text <> '')) then -- buscar o valor da classificação caso não tenha
			select	ie_classificacao_doenca
			into STRICT	ie_classif_w
			from	diagnostico_doenca
			where	nr_seq_interno = nr_seq_diag_pac_w
			and	(ie_classificacao_doenca IS NOT NULL AND ie_classificacao_doenca::text <> '');

			if (ie_classif_w IS NOT NULL AND ie_classif_w::text <> '') then

				update	codificacao_atend_item
				set	ie_classificacao = ie_classif_w
				where	nr_sequencia = nr_sequencia_w
				and	nr_seq_codificacao = nr_sequencia_p;

			end if;
		end if;

		if (cd_doenca_cid_w IS NOT NULL AND cd_doenca_cid_w::text <> '' AND ie_classificacao_w IS NOT NULL AND ie_classificacao_w::text <> '') then

			select 	count(*)
			into STRICT	exige_cid_w
			from	codificacao_regra_lib
			where	(((cd_doenca_cid = cd_doenca_cid_w )
			or (obter_categoria_cid(cd_doenca_cid_w) = cd_categoria_cid) or (obter_especialidade_cid(cd_doenca_cid_w) = cd_especialidade_cid))
			and	coalesce(ie_exige_cid, 'N') = 'S'
			and	nr_seq_grupo = nr_seq_grupo_w)
			or	((coalesce(cd_doenca_cid::text, '') = '' and coalesce(cd_categoria_cid::text, '') = '' and coalesce(cd_especialidade_cid::text, '') = '')
			and	coalesce(ie_exige_cid, 'N') = 'S'
			and	nr_seq_grupo = nr_seq_grupo_w);

			if (exige_cid_w > 0 and coalesce(cd_cid_oncologia_w::text, '') = '') then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(1040817, 'DS_CAMPO='||'CD_CID_ONCOLOGIA');--O campo #@DS_CAMPO#@ deve ser preenchido.
			end if;

			select	max(cg.nr_ordem),
				max(cg.nr_sequencia),
				max(rg.cd_doenca_cid),
				max(rg.cd_especialidade_cid),
				max(rg.cd_categoria_cid)
			into STRICT	nr_ordem_set_w,
				cd_grupo_set_w,
				cd_doenca_cid_set_w,
				cd_espec_set_w,
				cd_categoria_set_w
			from	codificacao_grupo cg,
				codificacao_regra_lib rg
			where	cg.nr_sequencia = rg.nr_seq_grupo
			and	((coalesce(rg.cd_doenca_cid::text, '') = '' and coalesce(rg.cd_categoria_cid::text, '') = '' and coalesce(rg.cd_especialidade_cid::text, '') = '')
			or 	((rg.cd_doenca_cid = cd_doenca_cid_w) or (obter_categoria_cid(cd_doenca_cid_w) = rg.cd_categoria_cid) or (obter_especialidade_cid(cd_doenca_cid_w) = rg.cd_especialidade_cid)))
			and	cg.nr_ordem > nr_ordem_atual_w
			and	ie_permite_liberar_w = 'N'
			order by cd_doenca_cid, cg.nr_ordem desc LIMIT 1;

			if (coalesce(cd_proximo_grupo_w::text, '') = '') then

				cd_proximo_grupo_w := cd_grupo_set_w;
				nr_ordem_prox_grupo_w := nr_ordem_set_w;

				if (cd_doenca_cid_set_w IS NOT NULL AND cd_doenca_cid_set_w::text <> '') then
					ie_regra_cid_w := 'S';
				elsif (cd_espec_set_w IS NOT NULL AND cd_espec_set_w::text <> '') then
					ie_regra_espec_w := 'S';
				elsif (cd_categoria_set_w IS NOT NULL AND cd_categoria_set_w::text <> '') then
					ie_regra_categ_w := 'S';
				end if;

			elsif	((ie_regra_categ_w = 'N' and ie_regra_espec_w = 'N' and ie_regra_cid_w = 'N') and ((cd_doenca_cid_set_w IS NOT NULL AND cd_doenca_cid_set_w::text <> '') or (cd_espec_set_w IS NOT NULL AND cd_espec_set_w::text <> '') or (cd_categoria_set_w IS NOT NULL AND cd_categoria_set_w::text <> ''))) then

				cd_proximo_grupo_w := cd_grupo_set_w;
				nr_ordem_prox_grupo_w := nr_ordem_set_w;

				if (cd_doenca_cid_set_w IS NOT NULL AND cd_doenca_cid_set_w::text <> '') then

					ie_regra_cid_w := 'S';
					ie_regra_espec_w := 'N';
					ie_regra_categ_w := 'N';

				elsif (cd_espec_set_w IS NOT NULL AND cd_espec_set_w::text <> '') then

					ie_regra_cid_w := 'N';
					ie_regra_espec_w := 'S';
					ie_regra_categ_w := 'N';

				elsif (cd_categoria_set_w IS NOT NULL AND cd_categoria_set_w::text <> '') then

					ie_regra_cid_w := 'N';
					ie_regra_espec_w := 'N';
					ie_regra_categ_w := 'S';

				end if;

			elsif (ie_regra_cid_w = 'S' and (cd_doenca_cid_set_w IS NOT NULL AND cd_doenca_cid_set_w::text <> '')
				and nr_ordem_set_w < nr_ordem_prox_grupo_w) then

				cd_proximo_grupo_w := cd_grupo_set_w;
				nr_ordem_prox_grupo_w := nr_ordem_set_w;

			elsif	((ie_regra_cid_w = 'N') and (ie_regra_espec_w = 'S' and (cd_espec_set_w IS NOT NULL AND cd_espec_set_w::text <> ''))
				and (nr_ordem_set_w < nr_ordem_prox_grupo_w)) then

				cd_proximo_grupo_w := cd_grupo_set_w;
				nr_ordem_prox_grupo_w := nr_ordem_set_w;

			elsif	((ie_regra_cid_w = 'N') and (ie_regra_espec_w = 'N') and (ie_regra_categ_w = 'S' and (cd_categoria_set_w IS NOT NULL AND cd_categoria_set_w::text <> ''))
				and (nr_ordem_set_w < nr_ordem_prox_grupo_w)) then

				cd_proximo_grupo_w := cd_grupo_set_w;
				nr_ordem_prox_grupo_w := nr_ordem_set_w;

			elsif ((ie_regra_cid_w = 'N') and (ie_regra_espec_w = 'N') and (ie_regra_categ_w = 'N') and (coalesce(cd_doenca_cid_set_w::text, '') = '' and coalesce(cd_espec_set_w::text, '') = '' and coalesce(cd_categoria_set_w::text, '') = '')
				and (nr_ordem_set_w < nr_ordem_prox_grupo_w)) then

				cd_proximo_grupo_w := cd_grupo_set_w;
				nr_ordem_prox_grupo_w := nr_ordem_set_w;

			end if;
		end if;
	end;
	end loop;
	close C01;

	if (coalesce(cd_proximo_grupo_w::text, '') = '') then
		cd_proximo_grupo_w := cd_grupo_inicial_w;
	end if;

	if (ie_permite_liberar_w = 'N') then

		update	codificacao_atendimento
		set	cd_grupo_atual			= cd_proximo_grupo_w,
			cd_grupo_anterior		= cd_grupo_atual_w,
			nm_responsavel_atual	 = NULL,
			dt_inicio_analise		 = NULL,
			ie_status				 = NULL
		where	nr_sequencia 			= nr_sequencia_p;

		CALL gerar_codificacao_atend_log(nr_sequencia_p, obter_desc_expressao(892380) || ' ' || obter_desc_expressao(310214) || ' '
		|| Obter_Descricao_Padrao('CODIFICACAO_GRUPO', 'DS_GRUPO', cd_grupo_atual_w)  || ' ' || obter_desc_expressao(727816) || ' '
		|| Obter_Descricao_Padrao('CODIFICACAO_GRUPO', 'DS_GRUPO', cd_proximo_grupo_w), nm_usuario_p);

	end if;

	if ((coalesce(cd_grupo_set_w::text, '') = '' and cd_grupo_atual_w = cd_grupo_inicial_w  and nm_usuario_p = nm_responsavel_w and (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and coalesce(cd_grupo_anterior_w::text, '') = '')
	or (cd_grupo_atual_w = cd_grupo_inicial_w and (cd_grupo_anterior_w IS NOT NULL AND cd_grupo_anterior_w::text <> '') and  nm_usuario_p = nm_responsavel_w)
	or (ie_permite_liberar_w = 'S')) then

		update	codificacao_atendimento
	set		ie_status 			= 'AF',
			dt_inicio_analise	= dt_inicio_analise_w,
			dt_fim_analise 		= clock_timestamp(),
			dt_liberacao		= clock_timestamp(),
			dt_atualizacao		= clock_timestamp(),
			nm_usuario			= nm_usuario_p,
			cd_grupo_atual		= cd_grupo_atual_w,
			cd_grupo_anterior	= cd_grupo_anterior_w
		where	nr_sequencia 		= nr_sequencia_p;

	end if;

	commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE codificacao_finalizar_analise ( nr_sequencia_p bigint, nm_usuario_p text ) FROM PUBLIC;
