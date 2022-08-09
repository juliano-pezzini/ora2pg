-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_dividir_fat_benef_remido ( nr_seq_lote_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ie_origem_conta_p text default 'A') AS $body$
DECLARE


/* 
	ie_origem_conta_p
	M - Conta de Vinculo Manual
	A - Conta Geracao Lote 
*/
ie_benef_remido_w		pls_regra_div_fat_benef.ie_benef_remido%type;
nr_seq_fatura_w			pls_fatura.nr_sequencia%type;
qt_registro_w			integer;
nr_seq_evento_pagador_w		bigint;
nr_seq_pagador_w		bigint;
ie_impedimento_cobranca_w	pls_fatura.ie_impedimento_cobranca%type;
nr_seq_fatura_nova_w		bigint := null;
nr_seq_evento_fatura_w		bigint;
nr_seq_evento_w			bigint;
nr_seq_conta_w			bigint;
nr_seq_fatura_evento_w		bigint;
nr_seq_segurado_w		bigint;
nr_seq_fatura_conta_w		bigint;
nr_seq_regra_w			pls_regra_divisao_fat_emp.nr_sequencia%type;
dt_atendimento_referencia_w	pls_conta.dt_atendimento_referencia%type;
nr_agrupamento_fat_w		pls_fatura.nr_agrupamento%type;
nr_seq_conta_sus_w		pls_fatura_conta.nr_seq_conta_sus%type;
nr_seq_fat_conta_w		pls_fatura_conta.nr_sequencia%type;
ie_forma_impedimento_cobr_w	varchar(3);
nr_seq_regra_fat_w		bigint;

C01 CURSOR FOR
	SELECT	a.nr_sequencia
	from	pls_regra_div_fat_benef a
	where	a.cd_estabelecimento	= cd_estabelecimento_p
	and	ie_benef_remido		= ie_benef_remido_w
	and	trunc(clock_timestamp(),'dd') between trunc(a.dt_inicio_vigencia,'dd') and fim_dia(a.dt_fim_vigencia)
	and	ie_benef_remido		= 'S';

C02 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.nr_seq_pagador,
		a.ie_impedimento_cobranca,
		a.nr_agrupamento
	from	pls_fatura		a
	where	a.nr_seq_lote	= nr_seq_lote_p
	order by a.nr_seq_pagador;

C03 CURSOR FOR
	SELECT	b.nr_seq_conta,
		a.nr_seq_evento,
		a.nr_sequencia,
		b.nr_seq_segurado,
		b.nr_sequencia,
		b.nr_seq_conta_sus
	from	pls_segurado		c,
		pls_fatura_conta 	b,
		pls_fatura_evento 	a
	where	a.nr_seq_fatura = nr_seq_fatura_w
	and	a.nr_sequencia	= b.nr_seq_fatura_evento
	and	c.nr_sequencia	= b.nr_seq_segurado
	group by b.nr_seq_conta,
		a.nr_seq_evento,
		a.nr_sequencia,
		b.nr_seq_segurado,
		b.nr_sequencia,
		b.nr_seq_conta_sus
	order by b.nr_seq_segurado;


BEGIN

if (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '') then
	-- Verificar se existe regra
	select	count(1)
	into STRICT	qt_registro_w
	from	pls_regra_div_fat_benef
	where	cd_estabelecimento	= cd_estabelecimento_p;
	
	select	a.nr_seq_regra_fat
	into STRICT	nr_seq_regra_fat_w
	from	pls_lote_faturamento a
	where	a.nr_sequencia = nr_seq_lote_p;
	
	select	coalesce(ie_forma_impedimento_cobr,'U')
	into STRICT	ie_forma_impedimento_cobr_w
	from	pls_regra_faturamento
	where	nr_sequencia = nr_seq_regra_fat_w;
	
	if (qt_registro_w > 0) then
		-- Abrir as faturas
		open C02;
		loop
		fetch C02 into	
			nr_seq_fatura_w,
			nr_seq_pagador_w,
			ie_impedimento_cobranca_w,
			nr_agrupamento_fat_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			
			nr_seq_fatura_nova_w	:= null;
			
			-- Verificar quais contas da fatura nao participam do agrupamento
			open C03;
			loop
			fetch C03 into	
				nr_seq_conta_w,
				nr_seq_evento_w,
				nr_seq_fatura_evento_w,
				nr_seq_segurado_w,
				nr_seq_fatura_conta_w,
				nr_seq_conta_sus_w;
			EXIT WHEN NOT FOUND; /* apply on C03 */
				begin
				
				nr_seq_regra_w	:= null;
				
				if (nr_seq_conta_w IS NOT NULL AND nr_seq_conta_w::text <> '') then
					select	max(a.dt_atendimento_referencia)
					into STRICT	dt_atendimento_referencia_w
					from	pls_conta	a
					where	a.nr_sequencia	= nr_seq_conta_w;

					ie_benef_remido_w	:= pls_obter_se_benef_remido( nr_seq_segurado_w, dt_atendimento_referencia_w);
				-- Ressarcimento ao SUS	
				elsif (nr_seq_conta_sus_w IS NOT NULL AND nr_seq_conta_sus_w::text <> '') then
					select	max(a.dt_internacao)
					into STRICT	dt_atendimento_referencia_w
					from	pls_processo_conta	a
					where	a.nr_sequencia	= nr_seq_conta_sus_w;
					
					ie_benef_remido_w	:= pls_obter_se_benef_remido( nr_seq_segurado_w, dt_atendimento_referencia_w);
				end if;
				
				-- Puxar as regras em que a conta/segurado se encaixa
				open C01;
				loop
				fetch C01 into	
					nr_seq_regra_w;
				EXIT WHEN NOT FOUND; /* apply on C01 */
				
				end loop;
				close C01;
				
				if (nr_seq_regra_w IS NOT NULL AND nr_seq_regra_w::text <> '') then
				
					if (ie_forma_impedimento_cobr_w = 'U') then
						select	max(b.nr_sequencia),
							max(c.nr_sequencia)
						into STRICT	nr_seq_evento_pagador_w,
							nr_seq_fat_conta_w
						from	pls_segurado		d,
							pls_fatura_conta	c,
							pls_fatura_evento	b,
							pls_fatura		a
						where	a.nr_sequencia 		= b.nr_seq_fatura
						and	b.nr_sequencia 		= c.nr_seq_fatura_evento
						and	d.nr_sequencia		= c.nr_seq_segurado
						and	c.nr_sequencia		<> nr_seq_fatura_conta_w
						and	a.nr_sequencia		<> nr_seq_fatura_w
						and	a.nr_seq_pagador 	= nr_seq_pagador_w
						and	a.nr_seq_lote  		= nr_seq_lote_p
						and 	coalesce(a.ie_remido,'N')	= 'S'
						and	coalesce(a.ie_impedimento_cobranca,'X') = coalesce(ie_impedimento_cobranca_w,'X')
						and	a.nr_agrupamento	= coalesce(nr_agrupamento_fat_w,a.nr_agrupamento);
						
					elsif (ie_forma_impedimento_cobr_w = 'A') then
						select	max(b.nr_sequencia),
							max(c.nr_sequencia)
						into STRICT	nr_seq_evento_pagador_w,
							nr_seq_fat_conta_w
						from	pls_segurado		d,
							pls_fatura_conta	c,
							pls_fatura_evento	b,
							pls_fatura		a
						where	a.nr_sequencia 		= b.nr_seq_fatura
						and	b.nr_sequencia 		= c.nr_seq_fatura_evento
						and	d.nr_sequencia		= c.nr_seq_segurado
						and	c.nr_sequencia		<> nr_seq_fatura_conta_w
						and	a.nr_sequencia		<> nr_seq_fatura_w
						and	a.nr_seq_pagador 	= nr_seq_pagador_w
						and	a.nr_seq_lote  		= nr_seq_lote_p
						and 	coalesce(a.ie_remido,'N')	= 'S'
						and	coalesce(a.ie_impedimento_cobranca,'X') = coalesce(ie_impedimento_cobranca_w,'X');
					else
						select	max(b.nr_sequencia),
							max(c.nr_sequencia)
						into STRICT	nr_seq_evento_pagador_w,
							nr_seq_fat_conta_w
						from	pls_segurado		d,
							pls_fatura_conta	c,
							pls_fatura_evento	b,
							pls_fatura		a
						where	a.nr_sequencia 		= b.nr_seq_fatura
						and	b.nr_sequencia 		= c.nr_seq_fatura_evento
						and	d.nr_sequencia		= c.nr_seq_segurado
						and	c.nr_sequencia		<> nr_seq_fatura_conta_w
						and	a.nr_sequencia		<> nr_seq_fatura_w
						and	a.nr_seq_pagador 	= nr_seq_pagador_w
						and	a.nr_seq_lote  		= nr_seq_lote_p
						and 	coalesce(a.ie_remido,'N')	= 'S'
						and	a.nr_agrupamento	= coalesce(nr_agrupamento_fat_w,a.nr_agrupamento);
					end if;
					
					if (coalesce(nr_seq_fat_conta_w::text, '') = '') and (coalesce(nr_seq_evento_pagador_w, nr_seq_fatura_evento_w) = nr_seq_fatura_evento_w)  then
					
						--Cria uma nova fatura 
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
							nr_agrupamento,
							ie_remido,
							ie_tipo_fatura)
						SELECT	nr_seq_fatura_nova_w,
							clock_timestamp(),
							nm_usuario_p,
							clock_timestamp(),
							nm_usuario_p,
							nr_seq_pagador,
							nr_seq_lote,
							dt_vencimento,
							nr_seq_congenere,
							dt_mes_competencia,
							0,
							dt_vencimento_ndc,
							0,
							nr_seq_fatura_nova_w,
							nr_seq_fatura_w,
							ie_impedimento_cobranca_w,
							nr_agrupamento_fat_w,
							'S',
							ie_tipo_fatura
						from	pls_fatura
						where	nr_sequencia = nr_seq_fatura_w;
					end if;
					
					if (nr_seq_fatura_nova_w IS NOT NULL AND nr_seq_fatura_nova_w::text <> '') then
						select	max(nr_sequencia)
						into STRICT	nr_seq_evento_fatura_w
						from 	pls_fatura_evento
						where	nr_seq_fatura = nr_seq_fatura_nova_w
						and	nr_seq_evento = nr_seq_evento_w;
						
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
							
							update	pls_fatura_motivo_imp_cob
							set	nr_seq_fatura		= nr_seq_fatura_nova_w
							where	nr_seq_conta		= nr_seq_conta_w
							and	nr_seq_fatura		= nr_seq_fatura_w;
						-- Ressarcimento ao SUS	
						elsif (nr_seq_conta_sus_w IS NOT NULL AND nr_seq_conta_sus_w::text <> '') then
							-- Atualizar a conta para a fatura nova 
							update	pls_fatura_conta
							set	nr_seq_fatura_evento 	= nr_seq_evento_fatura_w
							where	nr_seq_conta_sus	= nr_seq_conta_sus_w
							and	nr_seq_fatura_evento 	= nr_seq_fatura_evento_w;
						
							update	pls_fatura_motivo_imp_cob
							set	nr_seq_fatura		= nr_seq_fatura_nova_w
							where	nr_seq_conta_sus	= nr_seq_conta_sus_w
							and	nr_seq_fatura		= nr_seq_fatura_w;
						end if;

					elsif (nr_seq_evento_pagador_w IS NOT NULL AND nr_seq_evento_pagador_w::text <> '') then
						if (nr_seq_conta_w IS NOT NULL AND nr_seq_conta_w::text <> '') then
							update	pls_fatura_conta
							set	nr_seq_fatura_evento 	= nr_seq_evento_pagador_w
							where	nr_seq_conta 		= nr_seq_conta_w
							and	nr_seq_fatura_evento 	= nr_seq_fatura_evento_w;
							
							update	pls_fatura_motivo_imp_cob
							set	nr_seq_fatura		= nr_seq_fatura_w
							where	nr_seq_conta		= nr_seq_conta_w
							and	nr_seq_fatura		= nr_seq_fatura_w;
						-- Ressarcimento ao SUS
						elsif (nr_seq_conta_sus_w IS NOT NULL AND nr_seq_conta_sus_w::text <> '') then
							update	pls_fatura_conta
							set	nr_seq_fatura_evento 	= nr_seq_evento_pagador_w
							where	nr_seq_conta_sus	= nr_seq_conta_sus_w
							and	nr_seq_fatura_evento 	= nr_seq_fatura_evento_w;
							
							update	pls_fatura_motivo_imp_cob
							set	nr_seq_fatura		= nr_seq_fatura_w
							where	nr_seq_conta_sus	= nr_seq_conta_sus_w
							and	nr_seq_fatura		= nr_seq_fatura_w;
						end if;
					end if;
				elsif (ie_origem_conta_p = 'M') then
					update	pls_fatura
					set	ie_remido	= CASE WHEN ie_benef_remido_w='N' THEN  'N'  ELSE 'S' END
					where	nr_sequencia	= nr_seq_fatura_w;
				end if;
				end;

			end loop;
			close C03;
			end;
			commit;
		end loop;
		close C02;
		commit;
		
		-- Atualizar os valores das faturas
		if (nr_seq_fatura_nova_w IS NOT NULL AND nr_seq_fatura_nova_w::text <> '') then	
			CALL pls_atualizar_vl_lote_fatura(nr_seq_lote_p,nm_usuario_p,'N','S');
		end if;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_dividir_fat_benef_remido ( nr_seq_lote_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ie_origem_conta_p text default 'A') FROM PUBLIC;
