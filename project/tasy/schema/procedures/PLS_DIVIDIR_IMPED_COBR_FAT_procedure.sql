-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_dividir_imped_cobr_fat ( nr_seq_lote_p bigint, cd_estabelecimento_p text, nm_usuario_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Dividir as faturas de acordo com a forma de impedimento de cobranca. OPS - Faturamento -> Cadastros -> Regra faturamento -> Forma de impedimento de cobranca
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta: 
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atencao:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 	

ie_forma_impedimento_cobr_w	varchar(3);
nr_seq_regra_w			bigint;
dt_vencimento_w			timestamp := null;
dt_vencimento_fat_w		timestamp := null;
dt_vencimento_ndc_w		timestamp := null;

-- Cursor C01 
ie_impedimento_cobranca_w	varchar(3);
vl_fatura_w			double precision;
vl_fatura_ndc_w			double precision;
nr_seq_fatura_w			bigint;		
nr_seq_congenere_w		bigint;
nr_seq_pagador_w		bigint;
qt_contas_fat_w			bigint;

-- Cursor C02 
ie_nova_fatura_w		varchar(1) := 'N';
ie_possui_outra_conta_fat_w	bigint := 0;
ie_possui_imp_w			bigint := 0;
qt_motivo_imp_cob_w		bigint := 0;
nr_seq_fatura_evento_w		bigint;
nr_seq_conta_w			bigint;
nr_seq_conta_sus_w		pls_fatura_conta.nr_seq_conta_sus%type;
nr_seq_fatura_nova_w		bigint;
nr_seq_evento_w			bigint;
nr_seq_evento_fatura_w		bigint;
nr_seq_novo_evento_fatura_w	bigint;
qt_contas_evento_w		bigint;
qt_eventos_fatura_w		bigint;
ie_tipo_vinculacao_w		varchar(30);
qt_registro_w			bigint;
dt_mesano_referencia_w		pls_lote_faturamento.dt_mesano_referencia%type;
nr_agrupamento_w		pls_fatura.nr_agrupamento%type;
qt_fat_conta_w			integer;
dt_atendimento_w		pls_conta.dt_atendimento_referencia%type;
ie_benef_remido_w		pls_regra_div_fat_benef.ie_benef_remido%type;
nr_seq_segurado_w		bigint;
ie_tipo_lote_w			pls_lote_faturamento.ie_tipo_lote%type;

C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.vl_fatura,
		a.nr_seq_congenere,
		a.nr_seq_pagador,
		a.ie_impedimento_cobranca,
		a.vl_total_ndc,
		a.dt_vencimento,
		a.dt_vencimento_ndc,
		a.nr_agrupamento
	from	pls_fatura		a
	where	a.nr_seq_lote	= nr_seq_lote_p
	and	(a.ie_impedimento_cobranca IS NOT NULL AND a.ie_impedimento_cobranca::text <> '');
	
C02 CURSOR FOR
	SELECT	a.nr_sequencia,
		b.nr_seq_conta,
		b.nr_seq_conta_sus,
		a.nr_seq_evento,
		coalesce(b.ie_tipo_vinculacao,'A'),
		b.nr_seq_segurado
	from	pls_fatura_conta b,
		pls_fatura_evento a
	where	a.nr_seq_fatura 	= nr_seq_fatura_w
	and	a.nr_sequencia		= b.nr_seq_fatura_evento
	and	exists (SELECT 1
			from	w_pls_lote_fat_item x
			where	x.nr_seq_conta	= b.nr_seq_conta
			and	x.nm_usuario	= nm_usuario_p
			and	x.ie_impedimento_cobranca = 'P'
			
union all

			select 1
			from	w_pls_lote_fat_item x
			where	x.nr_seq_conta	= b.nr_seq_conta_sus
			and	x.nm_usuario	= nm_usuario_p
			and	x.ie_impedimento_cobranca = 'P');
	

BEGIN
if (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '') then	

	select	a.dt_vencimento,
		a.nr_seq_regra_fat,
		a.dt_mesano_referencia,
		a.ie_tipo_lote
	into STRICT	dt_vencimento_w,
		nr_seq_regra_w,
		dt_mesano_referencia_w,
		ie_tipo_lote_w
	from	pls_lote_faturamento a
	where	a.nr_sequencia = nr_seq_lote_p;
	
	select	coalesce(a.ie_forma_impedimento_cobr,'U')
	into STRICT	ie_forma_impedimento_cobr_w
	from	pls_regra_faturamento a
	where	a.nr_sequencia = nr_seq_regra_w;
	
	if (ie_forma_impedimento_cobr_w <> 'T') then
		open C01;
		loop
		fetch C01 into	
			nr_seq_fatura_w,
			vl_fatura_w,
			nr_seq_congenere_w,
			nr_seq_pagador_w,
			ie_impedimento_cobranca_w,
			vl_fatura_ndc_w,
			dt_vencimento_fat_w,
			dt_vencimento_ndc_w,
			nr_agrupamento_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin	
			
			if (coalesce(dt_vencimento_fat_w::text, '') = '') then
				dt_vencimento_fat_w := clock_timestamp();
			end if;
			
			if (coalesce(dt_vencimento_ndc_w::text, '') = '') then
				dt_vencimento_ndc_w := clock_timestamp();
			end if;
			
			select	count(1)
			into STRICT	qt_contas_fat_w
			from	pls_fatura_conta 	c,
				pls_fatura_evento 	b,
				pls_fatura		a
			where	b.nr_sequencia		= c.nr_seq_fatura_evento
			and	a.nr_sequencia		= b.nr_seq_fatura
			and	a.nr_sequencia		= nr_seq_fatura_w  LIMIT 2;
			
			if (qt_contas_fat_w > 1) then
				nr_seq_fatura_nova_w	 := null;
				open C02;
				loop
				fetch C02 into
					nr_seq_fatura_evento_w,
					nr_seq_conta_w,
					nr_seq_conta_sus_w,
					nr_seq_evento_w,
					ie_tipo_vinculacao_w,
					nr_seq_segurado_w;
				EXIT WHEN NOT FOUND; /* apply on C02 */
					begin	
					
					if (nr_seq_conta_w IS NOT NULL AND nr_seq_conta_w::text <> '') then
						select	max(dt_atendimento_referencia)
						into STRICT	dt_atendimento_w
						from	pls_conta
						where	nr_sequencia	= nr_seq_conta_w;
						
						ie_benef_remido_w	:= pls_obter_se_benef_remido( nr_seq_segurado_w, dt_atendimento_w);
					
					elsif (nr_seq_conta_sus_w IS NOT NULL AND nr_seq_conta_sus_w::text <> '') then
						select	max(dt_internacao)
						into STRICT	dt_atendimento_w
						from	pls_processo_conta
						where	nr_sequencia	= nr_seq_conta_sus_w;
						
						
						ie_benef_remido_w	:= pls_obter_se_benef_remido( nr_seq_segurado_w, dt_atendimento_w);
					end if;
					
					qt_registro_w := 0;
					
					if (ie_tipo_vinculacao_w = 'M') then						
						select	count(1)
						into STRICT	qt_registro_w
						from	pls_fatura_motivo_imp_cob d,
							pls_fatura_conta 	c,
							pls_fatura_evento 	b,
							pls_fatura		a
						where	b.nr_sequencia		= c.nr_seq_fatura_evento
						and	a.nr_sequencia		= b.nr_seq_fatura
						and	d.nr_seq_conta		= c.nr_seq_conta
						and	a.nr_sequencia		= nr_seq_fatura_w
						and	c.ie_tipo_vinculacao	= 'M'
						and	a.nr_seq_pagador	= nr_seq_pagador_w
						and	a.nr_seq_lote		= nr_seq_lote_p
						and	coalesce(a.ie_impedimento_cobranca,'X') = ie_impedimento_cobranca_w  LIMIT 10;
						
						if (qt_registro_w > 1) then
							select	max(nr_sequencia)
							into STRICT	nr_seq_fatura_nova_w
							from	pls_fatura
							where	nr_seq_pagador		= nr_seq_pagador_w
							and	nr_seq_lote		= nr_seq_lote_p
							and	coalesce(ie_impedimento_cobranca,'X') = ie_impedimento_cobranca_w
							and (nr_agrupamento		= nr_agrupamento_w or coalesce(coalesce(nr_agrupamento,nr_agrupamento_w)::text, '') = '');
						end if;
					end if;

					if (coalesce(nr_seq_fatura_nova_w::text, '') = '') or (ie_forma_impedimento_cobr_w = 'U') then
						select	nextval('pls_fatura_seq')
						into STRICT	nr_seq_fatura_nova_w
						;
						
						insert into pls_fatura(nr_sequencia,
							dt_atualizacao,
							nm_usuario,
							dt_atualizacao_nrec,
							nm_usuario_nrec,
							nr_seq_pagador,
							nr_seq_lote,
							dt_vencimento,
							nr_seq_congenere,
							vl_fatura,
							ie_impedimento_cobranca,
							vl_total_ndc,
							dt_vencimento_ndc,
							nr_fatura,
							nr_seq_fat_divisao,
							dt_mes_competencia,
							ie_remido,
							ie_tipo_fatura)
						values (nr_seq_fatura_nova_w,
							clock_timestamp(),
							nm_usuario_p,
							clock_timestamp(),
							nm_usuario_p,
							nr_seq_pagador_w,
							nr_seq_lote_p,
							coalesce(dt_vencimento_w,dt_vencimento_fat_w),
							nr_seq_congenere_w,
							0,
							'P',
							0,
							coalesce(dt_vencimento_w,dt_vencimento_ndc_w),
							nr_seq_fatura_nova_w,
							nr_seq_fatura_w,
							dt_mesano_referencia_w,
							'N',
							ie_tipo_lote_w);
					end if;
					
					if (nr_seq_fatura_nova_w IS NOT NULL AND nr_seq_fatura_nova_w::text <> '') then
						select	max(nr_sequencia)
						into STRICT	nr_seq_evento_fatura_w
						from 	pls_fatura_evento
						where	nr_seq_fatura = nr_seq_fatura_nova_w
						and	nr_seq_evento = nr_seq_evento_w;
						
						nr_seq_novo_evento_fatura_w := null;
						
						if (coalesce(nr_seq_evento_fatura_w::text, '') = '') then
							select	nextval('pls_fatura_evento_seq')
							into STRICT	nr_seq_novo_evento_fatura_w
							;
							
							insert into pls_fatura_evento(nr_sequencia,
								dt_atualizacao,
								nm_usuario,
								dt_atualizacao_nrec,
								nm_usuario_nrec,
								nr_seq_evento,
								nr_seq_fatura,
								vl_evento)
							values (nr_seq_novo_evento_fatura_w,
								clock_timestamp(),
								nm_usuario_p,
								clock_timestamp(),
								nm_usuario_p,
								nr_seq_evento_w,
								nr_seq_fatura_nova_w,
								0);
						end if;
						
						-- Atualizar a conta para a fatura nova
						if (nr_seq_conta_w IS NOT NULL AND nr_seq_conta_w::text <> '') then
							update	pls_fatura_conta
							set	nr_seq_fatura_evento 	= coalesce(nr_seq_novo_evento_fatura_w,nr_seq_evento_fatura_w)
							where	nr_seq_conta 		= nr_seq_conta_w
							and	nr_seq_fatura_evento 	= nr_seq_fatura_evento_w;
						--Ressarcimento ao SUS
						elsif (nr_seq_conta_sus_w IS NOT NULL AND nr_seq_conta_sus_w::text <> '') then
							update	pls_fatura_conta
							set	nr_seq_fatura_evento	= coalesce(nr_seq_novo_evento_fatura_w,nr_seq_evento_fatura_w)
							where	nr_seq_conta_sus	= nr_seq_conta_sus_w
							and	nr_seq_fatura_evento	= nr_seq_fatura_evento_w;						
						end if;
						
						select 	count(1)
						into STRICT	qt_fat_conta_w
						from	pls_fatura_conta
						where   nr_seq_fatura_evento = nr_seq_fatura_evento_w;
						
						if (qt_fat_conta_w	= 0) then
							delete	FROM pls_fatura_evento
							where	nr_sequencia	= nr_seq_fatura_evento_w;	
						end if;
					end if;	
						
					if (nr_seq_conta_w IS NOT NULL AND nr_seq_conta_w::text <> '') then
						update	pls_fatura_motivo_imp_cob
						set	nr_seq_fatura	= nr_seq_fatura_nova_w
						where	nr_seq_conta	= nr_seq_conta_w
						and	nr_seq_fatura	= nr_seq_fatura_w;
						
					elsif (nr_seq_conta_sus_w IS NOT NULL AND nr_seq_conta_sus_w::text <> '') then
						update	pls_fatura_motivo_imp_cob
						set	nr_seq_fatura		= nr_seq_fatura_nova_w
						where	nr_seq_conta_sus	= nr_seq_conta_sus_w
						and	nr_seq_fatura		= nr_seq_fatura_w;
					end if;
					end;
				end loop;
				close C02;
				commit;
				
				select	count(1)
				into STRICT	ie_possui_imp_w
				from	pls_fatura_conta 	c,
					pls_fatura_evento 	b,
					pls_fatura		a
				where	b.nr_sequencia		= c.nr_seq_fatura_evento
				and	a.nr_sequencia		= b.nr_seq_fatura
				and	a.nr_sequencia		= nr_seq_fatura_w
				and (exists (SELECT 1
						from	w_pls_lote_fat_item x
						where	x.nr_seq_conta	= c.nr_seq_conta
						and	x.nm_usuario	= nm_usuario_p
						and	x.ie_impedimento_cobranca = 'P'
						
union all

						SELECT 1
						from	w_pls_lote_fat_item x
						where	x.nr_seq_conta	= c.nr_seq_conta_sus
						and	x.nm_usuario	= nm_usuario_p
						and	x.ie_impedimento_cobranca = 'P') or c.ie_tipo_vinculacao = 'M')  LIMIT 1;

				if (ie_possui_imp_w = 0) then
					select	count(1)
					into STRICT	ie_possui_imp_w
					from	pls_fatura_motivo_imp_cob
					where	nr_seq_fatura	= nr_seq_fatura_w;
					if (ie_possui_imp_w = 0) then
						update	pls_fatura
						set	ie_impedimento_cobranca  = NULL
						where	nr_sequencia 		= nr_seq_fatura_w;
					end if;
				end if;
				
				select	count(1)
				into STRICT	qt_contas_evento_w
				from	pls_fatura_conta 	c,
					pls_fatura_evento 	b,
					pls_fatura		a
				where	b.nr_sequencia		= c.nr_seq_fatura_evento
				and	a.nr_sequencia		= b.nr_seq_fatura
				and	a.nr_sequencia		= nr_seq_fatura_w  LIMIT 1;
				
				if (qt_contas_evento_w = 0) then
					delete 	from pls_fatura_evento
					where	nr_seq_fatura = nr_seq_fatura_w;
				end if;
				
				select	count(1)
				into STRICT	qt_eventos_fatura_w
				from	pls_fatura_evento 	b,
					pls_fatura		a
				where	a.nr_sequencia		= b.nr_seq_fatura
				and	a.nr_sequencia		= nr_seq_fatura_w  LIMIT 1;
				
				if (qt_eventos_fatura_w = 0) then
					update	pls_fatura
					set	nr_seq_fat_divisao  = NULL
					where	nr_seq_fat_divisao = nr_seq_fatura_w;
				
					delete 	from pls_fatura
					where	nr_sequencia = nr_seq_fatura_w;
				end if;					
			end if;
			end;
		end loop;
		close C01;
		commit;
		
		CALL pls_atualizar_vl_lote_fatura(nr_seq_lote_p,nm_usuario_p,'N','S');
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_dividir_imped_cobr_fat ( nr_seq_lote_p bigint, cd_estabelecimento_p text, nm_usuario_p text) FROM PUBLIC;

