-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_pend_painel_ocorr ( cd_pf_pj_p text, ie_tipo_pessoa_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


qt_pendencia_w			bigint;
ie_todos_visual_mens_w		varchar(1);
ie_permite_visual_boletim_w	varchar(1);
ie_vencimento_original_w	varchar(1);


BEGIN
ie_todos_visual_mens_w		:= coalesce(obter_valor_param_usuario(1266, 1, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_p),'S');
ie_permite_visual_boletim_w	:= coalesce(obter_valor_param_usuario(1266, 2, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_p),'S');
ie_vencimento_original_w	:= coalesce(obter_valor_param_usuario(1266, 3, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_p),'N');

delete from w_pls_painel_ocorrencia
where nm_usuario 	= nm_usuario_p;


if (ie_tipo_pessoa_p	= '0') then
	/* Dados inconsistentes */

	select	count(1)
	into STRICT	qt_pendencia_w
	from	pls_cad_inconsist_pessoa	b,
		pls_inconsistencia_pessoa	a
	where	a.nr_seq_inconsistencia		= b.nr_sequencia
	and	(a.cd_pessoa_fisica IS NOT NULL AND a.cd_pessoa_fisica::text <> '')
	and	a.cd_pessoa_fisica	= cd_pf_pj_p;
	
	if (qt_pendencia_w > 0) then
		insert into w_pls_painel_ocorrencia(ie_tipo_ocorrencia, cd_pessoa_fisica, qt_pendencia,
			 nm_usuario, dt_atualizacao)
		values (1, cd_pf_pj_p, qt_pendencia_w,
			 nm_usuario_p, clock_timestamp());
	end if;
	
	/* Mensalidades */

	if (ie_todos_visual_mens_w = 'S') then
		select	count(qt)
		into STRICT	qt_pendencia_w
		from	(SELECT	1 qt
			from	titulo_receber		d,
				pls_mensalidade		c,
				pls_mensalidade_segurado	b,
				pls_segurado		a
			where	a.nr_sequencia		= b.nr_seq_segurado
			and	b.nr_seq_mensalidade	= c.nr_sequencia
			and	c.nr_sequencia		= d.nr_seq_mensalidade
			and	coalesce(d.dt_liquidacao::text, '') = ''
			and	((ie_vencimento_original_w = 'S' and (trunc(d.dt_vencimento,'dd') 		< trunc(clock_timestamp(),'dd'))) or (ie_vencimento_original_w = 'N' and (trunc(d.dt_pagamento_previsto,'dd')	< trunc(clock_timestamp(),'dd'))))
			and	a.cd_pessoa_fisica	= cd_pf_pj_p
			
union

			SELECT	1 qt
			from	titulo_receber		d,
				pls_mensalidade		c,
				pls_contrato_pagador	b,
				pls_contrato		a
			where	c.nr_seq_pagador	= b.nr_sequencia
			and	b.nr_seq_contrato	= a.nr_sequencia
			and	c.nr_sequencia		= d.nr_seq_mensalidade
			and	coalesce(d.dt_liquidacao::text, '') = ''
			and	((ie_vencimento_original_w = 'S' and (trunc(d.dt_vencimento,'dd') 		< trunc(clock_timestamp(),'dd'))) or (ie_vencimento_original_w = 'N' and (trunc(d.dt_pagamento_previsto,'dd')	< trunc(clock_timestamp(),'dd'))))
			and	a.cd_pf_estipulante	= cd_pf_pj_p) alias26;
	else
		select	count(1)
		into STRICT	qt_pendencia_w
		from	titulo_receber		c,
			pls_mensalidade		b,
			pls_contrato_pagador	a
		where	a.nr_sequencia		= b.nr_seq_pagador
		and	b.nr_sequencia		= c.nr_seq_mensalidade
		and	coalesce(c.dt_liquidacao::text, '') = ''
		and	((ie_vencimento_original_w = 'S' and (trunc(c.dt_vencimento,'dd') 		< trunc(clock_timestamp(),'dd'))) or (ie_vencimento_original_w = 'N' and (trunc(c.dt_pagamento_previsto,'dd')	< trunc(clock_timestamp(),'dd'))))
		and	a.cd_pessoa_fisica	= cd_pf_pj_p;
	end if;
	
	if (qt_pendencia_w > 0) then
		insert into w_pls_painel_ocorrencia(ie_tipo_ocorrencia, cd_pessoa_fisica, qt_pendencia,
			 nm_usuario, dt_atualizacao)
		values (2, cd_pf_pj_p, qt_pendencia_w,
			 nm_usuario_p, clock_timestamp());
	end if;
	
	/* Autorizações */

	select	count(1)
	into STRICT	qt_pendencia_w
	from 	pls_segurado	b,
		pls_guia_plano	a
	where	a.nr_seq_segurado	= b.nr_sequencia
	and	a.ie_status		= '2'
	and	(b.cd_pessoa_fisica IS NOT NULL AND b.cd_pessoa_fisica::text <> '')
	and	b.cd_pessoa_fisica	= cd_pf_pj_p;
	
	if (qt_pendencia_w > 0) then
		insert into w_pls_painel_ocorrencia(ie_tipo_ocorrencia, cd_pessoa_fisica, qt_pendencia,
			 nm_usuario, dt_atualizacao)
		values (3, cd_pf_pj_p, qt_pendencia_w,
			 nm_usuario_p, clock_timestamp());
	end if;
	
	/* Boletim de ocorrência */

	if (ie_permite_visual_boletim_w = 'S') then
		SELECT	COUNT(1)
		into STRICT	qt_pendencia_w
		FROM	sac_boletim_ocorrencia	a
		WHERE	a.nr_sequencia = (SELECT MAX(b.nr_seq_bo)
								   FROM sac_resp_bol_ocor	b
								   WHERE b.nr_seq_bo = a.nr_sequencia
								   AND	b.ie_status NOT IN ('E','S'))
		AND	a.cd_pessoa_fisica	= cd_pf_pj_p
		and (coalesce(a.nr_seq_processo::text, '') = ''
		or	sac_obter_se_processo_lib(a.nr_seq_processo,nm_usuario_p) = 'S');	

		if (qt_pendencia_w > 0) then
			insert into w_pls_painel_ocorrencia(ie_tipo_ocorrencia, cd_pessoa_fisica, qt_pendencia,
				 nm_usuario, dt_atualizacao)
			values (4, cd_pf_pj_p, qt_pendencia_w,
				 nm_usuario_p, clock_timestamp());
		end if;
	end if;
	
	/* Atendimentos */

	select	count(1)
	into STRICT	qt_pendencia_w
	from	pls_atendimento	a
	where	ie_status	= 'P'
	and	(a.cd_pessoa_fisica IS NOT NULL AND a.cd_pessoa_fisica::text <> '')
	and	a.cd_pessoa_fisica	= cd_pf_pj_p;
	
	if (qt_pendencia_w > 0) then
		insert into w_pls_painel_ocorrencia(ie_tipo_ocorrencia, cd_pessoa_fisica, qt_pendencia,
			 nm_usuario, dt_atualizacao)
		values (5, cd_pf_pj_p, qt_pendencia_w,
			 nm_usuario_p, clock_timestamp());
	end if;
	
	/* Notificações */

	select	count(1)
	into STRICT	qt_pendencia_w
	from	pls_notificacao_atend	c,
		pls_auditoria		b,
		pls_segurado		a
	where	c.nr_seq_auditoria	= b.nr_sequencia
	and	b.nr_seq_segurado	= a.nr_sequencia
	and	c.ie_status		= 'AG'
	and	(a.cd_pessoa_fisica IS NOT NULL AND a.cd_pessoa_fisica::text <> '')
	and	a.cd_pessoa_fisica	= cd_pf_pj_p;
	
	if (qt_pendencia_w > 0) then
		insert into w_pls_painel_ocorrencia(ie_tipo_ocorrencia, cd_pessoa_fisica, qt_pendencia,
			 nm_usuario, dt_atualizacao)
		values (6, cd_pf_pj_p, qt_pendencia_w,
			 nm_usuario_p, clock_timestamp());
	end if;
	
	/* Liminares */

	select	count(1)
	into STRICT	qt_pendencia_w
	from	processo_judicial_liminar	b,
		pls_segurado			a
	where	b.nr_seq_segurado	= a.nr_sequencia
	and	b.ie_estagio		= 2
	and	clock_timestamp() between trunc(dt_inicio_validade) and fim_dia(coalesce(dt_fim_validade,clock_timestamp()))
	and	(a.cd_pessoa_fisica IS NOT NULL AND a.cd_pessoa_fisica::text <> '')
	and	a.cd_pessoa_fisica	= cd_pf_pj_p;
	
	if (qt_pendencia_w > 0) then
		insert into w_pls_painel_ocorrencia(ie_tipo_ocorrencia, cd_pessoa_fisica, qt_pendencia,
			 nm_usuario, dt_atualizacao)
		values (7, cd_pf_pj_p, qt_pendencia_w,
			 nm_usuario_p, clock_timestamp());
	end if;
	
	
	/* Cumprimento de Carências */

	select	sum(qt_pendencia)
	into STRICT	qt_pendencia_w
	from (SELECT	count(1) qt_pendencia
		from	pls_segurado	b,
			pls_carencia	a
		where	a.nr_seq_segurado	= b.nr_sequencia
		and	a.ie_cpt		= 'N'
		and	b.ie_situacao_atend	= 'A'
		and	clock_timestamp() <= coalesce(a.dt_inicio_vigencia,b.dt_inclusao_operadora) + a.qt_dias
		and	b.cd_pessoa_fisica	= cd_pf_pj_p
		
union all

		SELECT	count(1) qt_pendencia
		from	pls_segurado	b,
			pls_carencia	a,
			pls_contrato	c
		where	a.nr_seq_contrato	= c.nr_sequencia
		and	b.nr_seq_contrato	= c.nr_sequencia
		and	a.ie_cpt		= 'N'
		and	b.ie_situacao_atend	= 'A'
		and	clock_timestamp() <= coalesce(a.dt_inicio_vigencia,b.dt_inclusao_operadora) + a.qt_dias
		and	not exists (	select	1
						from	pls_carencia	x
						where	x.nr_seq_segurado	= b.nr_sequencia
						and	x.ie_cpt		= 'N')
		and	b.cd_pessoa_fisica	= cd_pf_pj_p
		
union all

		select	count(1) qt_pendencia
		from	pls_segurado	b,
			pls_carencia	a,
			pls_plano	c
		where	a.nr_seq_plano		= c.nr_sequencia
		and	b.nr_seq_plano		= c.nr_sequencia
		and	a.ie_cpt		= 'N'
		and	b.ie_situacao_atend	= 'A'
		and	clock_timestamp() <= coalesce(a.dt_inicio_vigencia,b.dt_inclusao_operadora) + a.qt_dias
		and	not exists (	select	1
						from	pls_carencia	x
						where	x.nr_seq_segurado	= b.nr_sequencia
						and	x.ie_cpt		= 'N')
		and	not exists (	select	1
						from	pls_carencia	x
						where	x.nr_seq_contrato	= b.nr_seq_contrato
						and	x.ie_cpt		= 'N')
		and	b.cd_pessoa_fisica	= cd_pf_pj_p
		
union all

		select	count(1) qt_pendencia
		from	pls_carencia_sca_v	a,
			pls_segurado		b
		where	a.nr_seq_segurado	= b.nr_sequencia
		and	b.ie_situacao_atend	= 'A'
		and	clock_timestamp() <= a.dt_inicio_vigencia + a.qt_dias
		and	b.cd_pessoa_fisica	= cd_pf_pj_p
		group by b.cd_pessoa_fisica) alias15;
	
	if (qt_pendencia_w > 0) then
		insert into w_pls_painel_ocorrencia(ie_tipo_ocorrencia, cd_pessoa_fisica, qt_pendencia,
			 nm_usuario, dt_atualizacao)
		values (8, cd_pf_pj_p, qt_pendencia_w,
			 nm_usuario_p, clock_timestamp());
	end if;
	
	/* Cumprimento de CPT */

	select	count(1)
	into STRICT	qt_pendencia_w
	from	pls_segurado	b,
		pls_carencia	a
	where	a.nr_seq_segurado	= b.nr_sequencia
	and	a.ie_cpt		= 'S'
	and	clock_timestamp() <= coalesce(a.dt_inicio_vigencia,b.dt_inclusao_operadora) + a.qt_dias
	and	b.cd_pessoa_fisica	= cd_pf_pj_p
	and	((coalesce(b.dt_rescisao::text, '') = '') or (b.dt_rescisao > clock_timestamp()));
	
	if (qt_pendencia_w > 0) then
		insert into w_pls_painel_ocorrencia(ie_tipo_ocorrencia, cd_pessoa_fisica, qt_pendencia,
			 nm_usuario, dt_atualizacao)
		values (9, cd_pf_pj_p, qt_pendencia_w,
			 nm_usuario_p, clock_timestamp());
	end if;
	
	/* Solicitações de alterações cadastrais */

		select 	count(1)
		into STRICT	qt_pendencia_w
		from 	tasy_solic_alteracao c
		where 	exists (SELECT  1
				from   	tasy_solic_alteracao a, tasy_solic_alt_campo b
				where 	a.nr_sequencia 	= c.nr_sequencia
				and	a.nr_sequencia = b.nr_seq_solicitacao
				and	b.nm_tabela in ('PESSOA_FISICA','COMPL_PESSOA_FISICA')
				and (b.ds_chave_simples = cd_pf_pj_p))
		and coalesce(dt_analise::text, '') = ''
		and ie_status = 'A';
				
		if (qt_pendencia_w = 0) then
			select 	count(1)
			into STRICT	qt_pendencia_w
			from 	tasy_solic_alteracao c
			where 	exists (SELECT  1
					from   	tasy_solic_alteracao a, tasy_solic_alt_campo b
					where 	a.nr_sequencia 	= c.nr_sequencia
					and	a.nr_sequencia = b.nr_seq_solicitacao
					and	b.nm_tabela in ('PESSOA_FISICA','COMPL_PESSOA_FISICA')
					and	(b.ds_chave_composta= ('CD_PESSOA_FISICA='||cd_pf_pj_p||'#@#@IE_TIPO_COMPLEMENTO=1')))
			and coalesce(dt_analise::text, '') = ''
			and ie_status = 'A';

			if (qt_pendencia_w = 0) then
				select 	count(1)
				into STRICT	qt_pendencia_w
				from 	tasy_solic_alteracao c
				where 	exists (SELECT  1
						from   	tasy_solic_alteracao a, tasy_solic_alt_campo b
						where 	a.nr_sequencia 	= c.nr_sequencia
						and	a.nr_sequencia = b.nr_seq_solicitacao
						and	b.nm_tabela in ('PESSOA_FISICA','COMPL_PESSOA_FISICA')
						and	(b.ds_chave_composta= ('CD_PESSOA_FISICA='||cd_pf_pj_p||'#@#@IE_TIPO_COMPLEMENTO=2')))
				and coalesce(dt_analise::text, '') = ''
				and ie_status = 'A';
						
				if (qt_pendencia_w = 0) then
					select 	count(1)
					into STRICT	qt_pendencia_w
					from 	tasy_solic_alteracao c
					where 	exists (SELECT  1
							from   	tasy_solic_alteracao a, tasy_solic_alt_campo b
							where 	a.nr_sequencia 	= c.nr_sequencia
							and	a.nr_sequencia = b.nr_seq_solicitacao
							and	b.nm_tabela in ('PESSOA_FISICA','COMPL_PESSOA_FISICA')
							and	(b.ds_chave_composta= ('CD_PESSOA_FISICA='||cd_pf_pj_p||'#@#@IE_TIPO_COMPLEMENTO=3')))
					and coalesce(dt_analise::text, '') = ''
					and ie_status = 'A';
					if (qt_pendencia_w = 0) then
						select 	count(1)
						into STRICT	qt_pendencia_w
						from 	tasy_solic_alteracao c
						where 	exists (SELECT  1
								from   	tasy_solic_alteracao a, tasy_solic_alt_campo b
								where 	a.nr_sequencia 	= c.nr_sequencia
								and	a.nr_sequencia = b.nr_seq_solicitacao
								and	b.nm_tabela in ('PESSOA_FISICA','COMPL_PESSOA_FISICA')
								and	(b.ds_chave_composta= ('CD_PESSOA_FISICA='||cd_pf_pj_p||'#@#@IE_TIPO_COMPLEMENTO=4')))
						and coalesce(dt_analise::text, '') = ''
						and ie_status = 'A';
								
						if (qt_pendencia_w = 0) then
							select 	count(1)
							into STRICT	qt_pendencia_w
							from 	tasy_solic_alteracao c
							where 	exists (SELECT  1
									from   	tasy_solic_alteracao a, tasy_solic_alt_campo b
									where 	a.nr_sequencia 	= c.nr_sequencia
									and	a.nr_sequencia = b.nr_seq_solicitacao
									and	b.nm_tabela in ('PESSOA_FISICA','COMPL_PESSOA_FISICA')
									and	(b.ds_chave_composta= ('CD_PESSOA_FISICA='||cd_pf_pj_p||'#@#@IE_TIPO_COMPLEMENTO=5')))
							and coalesce(dt_analise::text, '') = ''
							and ie_status = 'A';
							if (qt_pendencia_w = 0) then
								select 	count(1)
								into STRICT	qt_pendencia_w
								from 	tasy_solic_alteracao c
								where 	exists (SELECT  1
										from   	tasy_solic_alteracao a, tasy_solic_alt_campo b
										where 	a.nr_sequencia 	= c.nr_sequencia
										and	a.nr_sequencia = b.nr_seq_solicitacao
										and	b.nm_tabela in ('PESSOA_FISICA','COMPL_PESSOA_FISICA')
										and	(b.ds_chave_composta= ('CD_PESSOA_FISICA='||cd_pf_pj_p||'#@#@IE_TIPO_COMPLEMENTO=6')))
								and coalesce(dt_analise::text, '') = ''
								and ie_status = 'A';
								if (qt_pendencia_w = 0) then
									select 	count(1)
									into STRICT	qt_pendencia_w
									from 	tasy_solic_alteracao c
									where 	exists (SELECT  1
											from   	tasy_solic_alteracao a, tasy_solic_alt_campo b
											where 	a.nr_sequencia 	= c.nr_sequencia
											and	a.nr_sequencia = b.nr_seq_solicitacao
											and	b.nm_tabela in ('PESSOA_FISICA','COMPL_PESSOA_FISICA')
											and	(b.ds_chave_composta= ('CD_PESSOA_FISICA='||cd_pf_pj_p||'#@#@IE_TIPO_COMPLEMENTO=7')))
									and coalesce(dt_analise::text, '') = ''
									and ie_status = 'A';
											
									if (qt_pendencia_w = 0) then
										select 	count(1)
										into STRICT	qt_pendencia_w
										from 	tasy_solic_alteracao c
										where 	exists (SELECT  1
												from   	tasy_solic_alteracao a, tasy_solic_alt_campo b
												where 	a.nr_sequencia 	= c.nr_sequencia
												and	a.nr_sequencia = b.nr_seq_solicitacao
												and	b.nm_tabela in ('PESSOA_FISICA','COMPL_PESSOA_FISICA')
												and	(b.ds_chave_composta= ('CD_PESSOA_FISICA='||cd_pf_pj_p||'#@#@IE_TIPO_COMPLEMENTO=8')))
										and coalesce(dt_analise::text, '') = ''
										and ie_status = 'A';
									end if;
								end if;
							end if;
						end if;
					end if;
				end if;
			end if;
		end if;
	
	if (qt_pendencia_w > 0) then
		insert into w_pls_painel_ocorrencia(ie_tipo_ocorrencia, cd_pessoa_fisica, qt_pendencia,
			 nm_usuario, dt_atualizacao)
		values (10, cd_pf_pj_p, qt_pendencia_w,
			 nm_usuario_p, clock_timestamp());
	end if;
	
	select	count(1)
	into STRICT	qt_pendencia_w
	from	pls_solic_rescisao_benef a,
		pls_solicitacao_rescisao b,
		pls_segurado c
	where	b.nr_sequencia	= a.nr_seq_solicitacao
	and	c.nr_sequencia	= a.nr_seq_segurado
	and	c.cd_pessoa_fisica = cd_pf_pj_p
	and	b.ie_status = 2;
	
	if (qt_pendencia_w > 0) then
		insert into w_pls_painel_ocorrencia(ie_tipo_ocorrencia, cd_pessoa_fisica, qt_pendencia,
			 nm_usuario, dt_atualizacao)
		values (11, cd_pf_pj_p, qt_pendencia_w,
			 nm_usuario_p, clock_timestamp());
	end if;	
else
	/* Dados inconsistentes */

	select	count(1)
	into STRICT	qt_pendencia_w
	from	pls_cad_inconsist_pessoa	b,
		pls_inconsistencia_pessoa	a
	where	a.nr_seq_inconsistencia		= b.nr_sequencia
	and	(a.cd_cgc IS NOT NULL AND a.cd_cgc::text <> '')
	and	a.cd_cgc	= cd_pf_pj_p;
	
	if (qt_pendencia_w > 0) then
		insert into w_pls_painel_ocorrencia(ie_tipo_ocorrencia, cd_cgc, qt_pendencia,
			 nm_usuario, dt_atualizacao)
		values (1, cd_pf_pj_p, qt_pendencia_w,
			 nm_usuario_p, clock_timestamp());
	end if;
	
	/* Mensalidades */

	if (ie_todos_visual_mens_w = 'S') then
		select	count(1)
		into STRICT	qt_pendencia_w
		from	titulo_receber		d,
			pls_mensalidade		c,
			pls_contrato_pagador	b,
			pls_contrato		a
		where	c.nr_seq_pagador	= b.nr_sequencia
		and	b.nr_seq_contrato	= a.nr_sequencia
		and	c.nr_sequencia		= d.nr_seq_mensalidade
		and	coalesce(d.dt_liquidacao::text, '') = ''
		and	((ie_vencimento_original_w = 'S' and (trunc(d.dt_vencimento,'dd') 		< trunc(clock_timestamp(),'dd'))) or (ie_vencimento_original_w = 'N' and (trunc(d.dt_pagamento_previsto,'dd')	< trunc(clock_timestamp(),'dd'))))
		and	a.cd_cgc_estipulante	= cd_pf_pj_p;
	else
		select	count(1)
		into STRICT	qt_pendencia_w
		from	titulo_receber		c,
			pls_mensalidade		b,
			pls_contrato_pagador	a
		where	a.nr_sequencia		= b.nr_seq_pagador
		and	b.nr_sequencia		= c.nr_seq_mensalidade
		and	coalesce(c.dt_liquidacao::text, '') = ''
		and	((ie_vencimento_original_w = 'S' and (trunc(c.dt_vencimento,'dd') 		< trunc(clock_timestamp(),'dd'))) or (ie_vencimento_original_w = 'N' and (trunc(c.dt_pagamento_previsto,'dd')	< trunc(clock_timestamp(),'dd'))))
		and	a.cd_cgc		= cd_pf_pj_p;
	end if;
	
	if (qt_pendencia_w > 0) then
		insert into w_pls_painel_ocorrencia(ie_tipo_ocorrencia, cd_cgc, qt_pendencia,
			 nm_usuario, dt_atualizacao)
		values (2, cd_pf_pj_p, qt_pendencia_w,
			 nm_usuario_p, clock_timestamp());
	end if;
	
	/* Boletim de ocorrência */

	if (ie_permite_visual_boletim_w = 'S') then
		SELECT	COUNT(1)
		into STRICT	qt_pendencia_w
		FROM	sac_boletim_ocorrencia	a
		WHERE	a.nr_sequencia = (SELECT MAX(b.nr_seq_bo)
								   FROM sac_resp_bol_ocor	b
								   WHERE b.nr_seq_bo = a.nr_sequencia
								   AND	b.ie_status NOT IN ('E','S'))
		AND	a.cd_cgc	= cd_pf_pj_p
		and (coalesce(a.nr_seq_processo::text, '') = ''
		or	sac_obter_se_processo_lib(a.nr_seq_processo,nm_usuario_p) = 'S');
				
		if (qt_pendencia_w > 0) then
			insert into w_pls_painel_ocorrencia(ie_tipo_ocorrencia, cd_cgc, qt_pendencia,
				 nm_usuario, dt_atualizacao)
			values (4, cd_pf_pj_p, qt_pendencia_w,
				 nm_usuario_p, clock_timestamp());
		end if;
	end if;
	
	/* Atendimentos */

	select	count(1)
	into STRICT	qt_pendencia_w
	from	pls_atendimento	a
	where	ie_status	= 'P'
	and	(a.cd_cgc IS NOT NULL AND a.cd_cgc::text <> '')
	and	a.cd_cgc	= cd_pf_pj_p;
	
	if (qt_pendencia_w > 0) then
		insert into w_pls_painel_ocorrencia(ie_tipo_ocorrencia, cd_cgc, qt_pendencia,
			 nm_usuario, dt_atualizacao)
		values (5, cd_pf_pj_p, qt_pendencia_w,
			 nm_usuario_p, clock_timestamp());
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_pend_painel_ocorr ( cd_pf_pj_p text, ie_tipo_pessoa_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

