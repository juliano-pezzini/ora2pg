-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_dividir_faturas_lote ( nr_seq_lote_p pls_lote_faturamento.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


vl_conta_total_w		double precision := 0;
vl_evento_conta_w		double precision;
vl_total_fatura_w		double precision;		
vl_maximo_fatura_w		double precision;
vl_faturado_conta_w		double precision;
qt_max_conta_w			pls_regra_divisao_fatura.qt_max_conta%type;
nr_seq_conta_w			pls_conta.nr_sequencia%type;
nr_seq_fatura_w			pls_fatura.nr_sequencia%type;
nr_seq_camara_w			pls_camara_compensacao.nr_sequencia%type;
nr_seq_evento_w			pls_fatura_evento.nr_seq_evento%type;
nr_seq_congenere_w		pls_fatura.nr_seq_congenere%type;
nr_seq_pagador_w		pls_fatura.nr_seq_pagador%type;
nr_seq_fatura_evento_w		pls_fatura_evento.nr_sequencia%type;
nr_seq_evento_fatura_w		pls_fatura_evento.nr_sequencia%type;
nr_seq_fat_conta_w		pls_fatura_conta.nr_sequencia%type;
nr_seq_fatura_nova_w		pls_fatura.nr_sequencia%type := null;
qt_conta_total_w		integer := 0;
dt_mes_competencia_w		pls_lote_faturamento.dt_mesano_referencia%type;
dt_vencimento_fat_w		pls_fatura.dt_vencimento%type := null;
dt_vencimento_ndc_w		pls_fatura.dt_vencimento_ndc%type := null;
cd_guia_referencia_w		pls_fatura_conta.cd_guia_referencia%type;
nr_seq_segurado_w		pls_segurado.nr_sequencia%type;
nr_seq_fat_conta_fechada_w	pls_fatura_conta.nr_sequencia%type;
nr_seq_conta_fechada_w		pls_conta.nr_sequencia%type;
ie_conta_fechada_w		pls_fatura_conta.ie_conta_fechada%type;
nr_seq_fatura_fechada_w		pls_fatura.nr_sequencia%type;
qt_registro_w			integer;
ie_impedimento_cobranca_w	pls_fatura.ie_impedimento_cobranca%type;
nr_seq_regra_fat_w		pls_regra_faturamento.nr_sequencia%type;
ie_conta_fechada_regra_w	pls_regra_faturamento.ie_conta_fechada%type;
qt_max_guia_ref_w		pls_regra_divisao_fatura.qt_max_guia_ref%type;
qt_guia_total_w			integer := 0;
cd_guia_ref_old_w		pls_fatura_conta.cd_guia_referencia%type;
nr_seq_segurado_old_w		pls_segurado.nr_sequencia%type;
nr_seq_conta_sus_w		pls_fatura_conta.nr_seq_conta_sus%type;
ie_tipo_lote_w			pls_lote_faturamento.ie_tipo_lote%type;

C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		coalesce(a.vl_fatura,0) + coalesce(a.vl_total_ndc,0),
		a.nr_seq_congenere,
		a.nr_seq_pagador,
		a.dt_vencimento,
		a.dt_vencimento_ndc,
		a.ie_impedimento_cobranca
	from	pls_fatura	a
	where	a.nr_seq_lote	= nr_seq_lote_p;

C02 CURSOR FOR
	SELECT	a.vl_maximo_fatura,
		a.qt_max_conta,
		a.qt_max_guia_ref
	from	pls_regra_divisao_fatura	a
	where	a.cd_estabelecimento		= cd_estabelecimento_p
	and	((coalesce(a.nr_seq_congenere::text, '') = '') 	or (a.nr_seq_congenere = nr_seq_congenere_w))
	and	((coalesce(a.nr_seq_camara::text, '') = '') 	or (a.nr_seq_camara = nr_seq_camara_w))
	and	trunc(clock_timestamp(), 'dd') between trunc(a.dt_inicio_vigencia, 'dd') and fim_dia(a.dt_fim_vigencia)
	order by
		coalesce(a.dt_inicio_vigencia, clock_timestamp()) desc,
		coalesce(a.nr_seq_camara, 0),
		coalesce(a.nr_seq_congenere, 0);

C03 CURSOR FOR
	SELECT	b.nr_seq_conta,
		b.nr_sequencia,
		sum(coalesce(b.vl_faturado,0)) + sum(coalesce(b.vl_faturado_ndc,0)),
		b.cd_guia_referencia,
		b.nr_seq_segurado,
		b.ie_conta_fechada,
		b.nr_seq_conta_sus
	from	pls_fatura_conta	b,
		pls_fatura_evento	a
	where	a.nr_seq_fatura = nr_seq_fatura_w
	and	a.nr_sequencia	= b.nr_seq_fatura_evento
	group by
		b.nr_seq_conta,
		b.nr_sequencia,
		b.ie_conta_fechada,
		b.cd_guia_referencia,
		b.nr_seq_segurado,
		b.nr_seq_conta_sus
	order by
		coalesce(b.ie_conta_fechada,'X'),
		coalesce(b.cd_guia_referencia,'X'),
		sum(b.vl_faturado),
		sum(b.vl_faturado_ndc),
		b.nr_seq_conta,
		b.nr_seq_conta_sus;
		
c04 CURSOR FOR
	SELECT	b.nr_sequencia,
		b.nr_seq_conta,
		x.nr_sequencia,
		sum(coalesce(b.vl_faturado,0)) + sum(coalesce(b.vl_faturado_ndc,0)),
		b.nr_seq_conta_sus
	from	pls_fatura_conta	b,
		pls_fatura_evento	a,
		pls_fatura		x
	where	x.nr_sequencia	= a.nr_seq_fatura
	and	a.nr_sequencia	= b.nr_seq_fatura_evento
	and	x.nr_seq_lote	= nr_seq_lote_p
	and	b.cd_guia_referencia	= cd_guia_referencia_w
	and	b.nr_seq_segurado	= nr_seq_segurado_w
	and	x.nr_sequencia		<> nr_seq_fatura_nova_w
	group by b.nr_sequencia,	
		b.nr_seq_conta,
		b.nr_seq_conta_sus,
		x.nr_sequencia;


BEGIN
if (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '') then
	select	a.dt_mesano_referencia,
		a.nr_seq_regra_fat,
		a.ie_tipo_lote
	into STRICT	dt_mes_competencia_w,
		nr_seq_regra_fat_w,
		ie_tipo_lote_w
	from	pls_lote_faturamento a
	where	a.nr_sequencia	= nr_seq_lote_p;
	
	select	count(1)
	into STRICT	qt_registro_w
	from	pls_regra_divisao_fatura
	where	cd_estabelecimento	= cd_estabelecimento_p;
	
	select	coalesce(ie_conta_fechada,'N')
	into STRICT	ie_conta_fechada_regra_w
	from	pls_regra_faturamento
	where	nr_sequencia = nr_seq_regra_fat_w;

	if (qt_registro_w > 0) then
		-- Obter dados fatura
		open C01;
		loop
		fetch C01 into
			nr_seq_fatura_w,
			vl_total_fatura_w,
			nr_seq_congenere_w,
			nr_seq_pagador_w,
			dt_vencimento_fat_w,
			dt_vencimento_ndc_w,
			ie_impedimento_cobranca_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			begin	
			if (coalesce(dt_vencimento_fat_w::text, '') = '') then
				dt_vencimento_fat_w := null;
			end if;
			
			if (coalesce(dt_vencimento_ndc_w::text, '') = '') then
				dt_vencimento_ndc_w := null;
			end if;
			
			-- Obter camara da operadora para regra de valor para quebra das faturas
			select	max(nr_seq_camara)
			into STRICT	nr_seq_camara_w
			from	pls_congenere_camara
			where	nr_seq_congenere	= nr_seq_congenere_w;	
			
			-- Obter valor de fatura maximo e quantidade de contas maxima, para quebra das faturas
			open C02;
			loop
			fetch C02 into
				vl_maximo_fatura_w,
				qt_max_conta_w,
				qt_max_guia_ref_w;
			EXIT WHEN NOT FOUND; /* apply on c02 */
			end loop;
			close C02;
			
			nr_seq_fatura_nova_w	:= null;
			cd_guia_ref_old_w	:= null;
			nr_seq_segurado_old_w	:= null;
			vl_conta_total_w	:= 0;
			qt_conta_total_w	:= 0;
			qt_guia_total_w		:= 0;
			
			--Obter dados das contas ou guias
			if (coalesce(qt_max_conta_w,0) > 0) or (coalesce(qt_max_guia_ref_w,0) > 0) or
				((coalesce(vl_maximo_fatura_w,0) > 0) and (vl_total_fatura_w > coalesce(vl_maximo_fatura_w,0))) then
				
				open C03;
				loop
				fetch C03 into
					nr_seq_conta_w,
					nr_seq_fat_conta_w,
					vl_faturado_conta_w,
					cd_guia_referencia_w,
					nr_seq_segurado_w,
					ie_conta_fechada_w,
					nr_seq_conta_sus_w;
				EXIT WHEN NOT FOUND; /* apply on c03 */
					begin		
					qt_conta_total_w 	:= qt_conta_total_w + 1;
					vl_conta_total_w 	:= vl_conta_total_w + vl_faturado_conta_w;
					
					if	((coalesce(cd_guia_ref_old_w::text, '') = '') and (coalesce(nr_seq_segurado_old_w::text, '') = '')) or
						((cd_guia_ref_old_w != cd_guia_referencia_w) or
						(cd_guia_ref_old_w = cd_guia_referencia_w AND nr_seq_segurado_old_w != nr_seq_segurado_w)) then
						qt_guia_total_w	:= qt_guia_total_w + 1;
					end if;
					
					cd_guia_ref_old_w	:= cd_guia_referencia_w;
					nr_seq_segurado_old_w	:= nr_seq_segurado_w;
					
					if	(qt_conta_total_w > qt_max_conta_w AND qt_max_conta_w >= 1)
						or
						(qt_guia_total_w > qt_max_guia_ref_w AND qt_max_guia_ref_w >= 1)
						or						
						(vl_conta_total_w > vl_maximo_fatura_w AND vl_maximo_fatura_w > 0) then
						-- Cria uma nova fatura
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
							dt_mes_competencia,
							vl_fatura,
							dt_vencimento_ndc,
							vl_total_ndc,
							nr_fatura,
							nr_seq_fat_divisao,
							ie_impedimento_cobranca,
							ie_tipo_fatura)
						values (nr_seq_fatura_nova_w,
							clock_timestamp(),
							nm_usuario_p,
							clock_timestamp(),
							nm_usuario_p,
							nr_seq_pagador_w,
							nr_seq_lote_p,
							dt_vencimento_fat_w,
							nr_seq_congenere_w,
							dt_mes_competencia_w,
							0,
							dt_vencimento_ndc_w,
							0,
							nr_seq_fatura_nova_w,
							nr_seq_fatura_w,
							ie_impedimento_cobranca_w,
							ie_tipo_lote_w);
							
						vl_conta_total_w	:= vl_faturado_conta_w;
						qt_conta_total_w	:= 1;
						qt_guia_total_w		:= 1;
					end if;
					
					if (nr_seq_fatura_nova_w IS NOT NULL AND nr_seq_fatura_nova_w::text <> '') then				
						select	b.nr_seq_evento,
							b.nr_sequencia
						into STRICT	nr_seq_evento_w,
							nr_seq_fatura_evento_w
						from	pls_fatura_evento	b,
							pls_fatura_conta	a
						where	b.nr_sequencia	= a.nr_seq_fatura_evento
						and	a.nr_sequencia	= nr_seq_fat_conta_w;
						
						select	max(a.nr_sequencia)
						into STRICT	nr_seq_evento_fatura_w
						from	pls_fatura_evento	a
						where	a.nr_seq_fatura	= nr_seq_fatura_nova_w
						and	a.nr_seq_evento	= nr_seq_evento_w;
						
						if (coalesce(nr_seq_evento_fatura_w::text, '') = '') then
							select	nextval('pls_fatura_evento_seq')
							into STRICT	nr_seq_evento_fatura_w
							;
							
							insert into pls_fatura_evento(nr_sequencia,
								dt_atualizacao,
								nm_usuario,
								dt_atualizacao_nrec,
								nm_usuario_nrec,
								nr_seq_evento,
								nr_seq_fatura,
								vl_evento)
							values (nr_seq_evento_fatura_w,
								clock_timestamp(),
								nm_usuario_p,
								clock_timestamp(),
								nm_usuario_p,
								nr_seq_evento_w,
								nr_seq_fatura_nova_w,
								0);
						end if;
						
						if (nr_seq_conta_w IS NOT NULL AND nr_seq_conta_w::text <> '') then
							-- Atualizar a conta para a fatura nova
							update	pls_fatura_conta
							set	nr_seq_fatura_evento 	= nr_seq_evento_fatura_w
							where	nr_seq_conta 		= nr_seq_conta_w
							and	nr_seq_fatura_evento 	= nr_seq_fatura_evento_w;
						--Ressarcimento ao SUS
						elsif (nr_seq_conta_sus_w IS NOT NULL AND nr_seq_conta_sus_w::text <> '') then
							-- Atualizar a conta para a fatura nova
							update	pls_fatura_conta
							set	nr_seq_fatura_evento 	= nr_seq_evento_fatura_w
							where	nr_seq_conta_sus	= nr_seq_conta_sus_w
							and	nr_seq_fatura_evento 	= nr_seq_fatura_evento_w;
						end if;
					end if;
					
					-- Se a primeira conta teve contas fechadas na fatura anterior, deve buscar estas contas
					if (nr_seq_fatura_nova_w IS NOT NULL AND nr_seq_fatura_nova_w::text <> '') and (ie_conta_fechada_regra_w = 'S') then
						open C04;
						loop
						fetch C04 into	
							nr_seq_fat_conta_fechada_w,
							nr_seq_conta_fechada_w,
							nr_seq_fatura_fechada_w,
							vl_faturado_conta_w,
							nr_seq_conta_sus_w;
						EXIT WHEN NOT FOUND; /* apply on C04 */
							begin
							qt_conta_total_w 	:= qt_conta_total_w + 1;
							vl_conta_total_w 	:= vl_conta_total_w + vl_faturado_conta_w;
							
							if	(qt_max_conta_w >= 1 AND qt_conta_total_w < qt_max_conta_w) or
								(vl_maximo_fatura_w > 0 AND vl_conta_total_w < vl_maximo_fatura_w) then
								
								select	max(b.nr_seq_evento)
								into STRICT	nr_seq_evento_w
								from	pls_fatura_evento	b,
									pls_fatura_conta	a
								where	b.nr_sequencia	= a.nr_seq_fatura_evento
								and	a.nr_sequencia	= nr_seq_fat_conta_fechada_w;
								
								select	max(a.nr_sequencia)
								into STRICT	nr_seq_evento_fatura_w
								from	pls_fatura_evento	a
								where	a.nr_seq_fatura	= nr_seq_fatura_nova_w
								and	a.nr_seq_evento	= nr_seq_evento_w;
								
								if (coalesce(nr_seq_evento_fatura_w::text, '') = '') then
									select	nextval('pls_fatura_evento_seq')
									into STRICT	nr_seq_evento_fatura_w
									;
									
									insert into pls_fatura_evento(nr_sequencia,
										dt_atualizacao,
										nm_usuario,
										dt_atualizacao_nrec,
										nm_usuario_nrec,
										nr_seq_evento,
										nr_seq_fatura,
										vl_evento)
									values (nr_seq_evento_fatura_w,
										clock_timestamp(),
										nm_usuario_p,
										clock_timestamp(),
										nm_usuario_p,
										nr_seq_evento_w,
										nr_seq_fatura_nova_w,
										0);
								end if;
								
								-- Atualizar a conta para a fatura nova
								update	pls_fatura_conta
								set	nr_seq_fatura_evento 	= nr_seq_evento_fatura_w
								where	nr_sequencia		= nr_seq_fat_conta_fechada_w;
							else
								qt_conta_total_w 	:= qt_conta_total_w - 1;
								vl_conta_total_w 	:= vl_conta_total_w - vl_faturado_conta_w;
							end if;
							
							end;
						end loop;
						close C04;
						commit;
					end if;
					
					end;
				end loop;
				close C03;
			
			end if;
			end;
		end loop;
		close C01;
		commit;
		
		CALL pls_atualizar_vl_lote_fatura(nr_seq_lote_p, nm_usuario_p, 'N', 'S');
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_dividir_faturas_lote ( nr_seq_lote_p pls_lote_faturamento.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
