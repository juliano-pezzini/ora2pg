-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ptu_gerar_inco_receb_a700_pck.ptu_gerar_inconsistencias ( nr_seq_serv_pre_pgto_p ptu_servico_pre_pagto.nr_sequencia%type, nr_seq_nota_cobr_p ptu_nota_cobranca.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE

						
	nr_seq_nota_cobr_w			ptu_nota_cobranca.nr_sequencia%type;
	nr_seq_serv_pre_pagto_w			ptu_nota_cobranca.nr_seq_serv_pre_pagto%type;
	nr_seq_segurado_w			pls_segurado.nr_sequencia%type;
	nr_seq_nota_servico_w			ptu_nota_servico.nr_sequencia%type;
	cd_procedimento_w			ptu_nota_servico.cd_procedimento%type;
	ie_origem_proced_w			ptu_nota_servico.ie_origem_proced%type;
	ie_tipo_tabela_w			ptu_nota_servico.ie_tipo_tabela%type;
	nr_seq_material_w			ptu_nota_servico.nr_seq_material%type;
	qt_notas_cobr_w				bigint := 0;
	qt_notas_serv_w				bigint := 0;
	qt_limite_min_w				ptu_incons_qt_limite_a700.qt_limite_min%type;
	qt_limite_max_w				ptu_incons_qt_limite_a700.qt_limite_max%type;
						
	C01 CURSOR FOR
		SELECT	nr_sequencia,
			pls_obter_segurado_carteira(cd_unimed||cd_usuario_plano,cd_estabelecimento_p) cd_usuario_plano,
			nr_seq_serv_pre_pagto
		from	ptu_nota_cobranca
		where	((nr_seq_serv_pre_pagto = nr_seq_serv_pre_pgto_p) or (coalesce(nr_seq_serv_pre_pgto_p::text, '') = ''))
		and	((nr_sequencia		= nr_seq_nota_cobr_p) or (coalesce(nr_seq_nota_cobr_p::text, '') = ''));
		
	C02 CURSOR FOR
		SELECT	nr_sequencia,
			cd_procedimento,
			ie_origem_proced,
			ie_tipo_tabela,
			nr_seq_material
		from	ptu_nota_servico
		where	nr_seq_nota_cobr		= nr_seq_nota_cobr_w;
						
	
BEGIN
	
	/*Setar o usuário e estabelecimento*/

	CALL CALL CALL CALL CALL CALL CALL CALL ptu_gerar_inco_receb_a700_pck.set_nm_usuario(nm_usuario_p);
	CALL CALL CALL CALL CALL CALL CALL CALL CALL ptu_gerar_inco_receb_a700_pck.set_cd_estabelecimento(cd_estabelecimento_p);
	
	/*Armazena as inconsistências*/

	CALL ptu_gerar_inco_receb_a700_pck.armazenar_inconsistencias();
	
	CALL gravar_processo_longo('Gerar inconsistências' ,'PTU_GERAR_INCONSISTENCIAS',0);
	
	open C01;
	loop
	fetch C01 into	
		nr_seq_nota_cobr_w,
		nr_seq_segurado_w,
		nr_seq_serv_pre_pagto_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		
		if (qt_notas_cobr_w = 0) then
			select	count(1)
			into STRICT	qt_notas_cobr_w
			from	ptu_nota_cobranca
			where	nr_seq_serv_pre_pagto	= nr_seq_serv_pre_pagto_w;
		end if;
		
		CALL gravar_processo_longo('Gerando inconsistência da nota ' ||  c01%rowCount || ' de ' || qt_notas_cobr_w  ,'PTU_GERAR_INCONSISTENCIAS',-1);
		
		delete	FROM ptu_serv_pre_pagto_incons
		where	NR_SEQ_NOTA_COBR	= nr_seq_nota_cobr_w;
		
		PERFORM set_config('ptu_gerar_inco_receb_a700_pck.ie_consiste_nota_cobr_w', 'C', false);
		
		if (coalesce(nr_seq_segurado_w::text, '') = '') then
			CALL CALL CALL ptu_gerar_inco_receb_a700_pck.inserir_inconsistencia(nr_seq_nota_cobr_w,null,3);
		end if;
		
		open c02;
		loop
		fetch c02 into	
			nr_seq_nota_servico_w,
			cd_procedimento_w,
			ie_origem_proced_w,
			ie_tipo_tabela_w,
			nr_seq_material_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin
			
			PERFORM set_config('ptu_gerar_inco_receb_a700_pck.ie_consiste_servico_w', 'C', false);
			
			if (ie_tipo_tabela_w in (0,1,4)) then
				
				if (coalesce(cd_procedimento_w::text, '') = '') then
					CALL CALL CALL ptu_gerar_inco_receb_a700_pck.inserir_inconsistencia(nr_seq_nota_cobr_w,nr_seq_nota_servico_w,1);
				end if;
				
				if (coalesce(ie_origem_proced_w::text, '') = '') then
					CALL CALL CALL ptu_gerar_inco_receb_a700_pck.inserir_inconsistencia(nr_seq_nota_cobr_w,nr_seq_nota_servico_w,2);
				end if;
				
			elsif (ie_tipo_tabela_w in (2,3,5,6)) then
				
				if (coalesce(nr_seq_material_w::text, '') = '') then
					CALL CALL CALL ptu_gerar_inco_receb_a700_pck.inserir_inconsistencia(nr_seq_nota_cobr_w,nr_seq_nota_servico_w,1);
				end if;
				
			end if;
		
			select	sum(qt_procedimento)
			into STRICT	qt_notas_serv_w
			from	ptu_nota_servico
			where	nr_seq_nota_cobr	= nr_seq_nota_cobr_w;
			
			select	max(a.qt_limite_min), max(a.qt_limite_max)
			into STRICT	qt_limite_min_w, qt_limite_max_w
			from	ptu_incons_qt_limite_a700 a
			where	nr_sequencia = (SELECT max(nr_sequencia) from ptu_incons_qt_limite_a700);
			
			if	(qt_limite_min_w IS NOT NULL AND qt_limite_min_w::text <> '' AND qt_limite_min_w > qt_notas_serv_w) or (qt_limite_max_w IS NOT NULL AND qt_limite_max_w::text <> '' AND qt_limite_max_w < qt_notas_serv_w) then
				CALL CALL CALL ptu_gerar_inco_receb_a700_pck.inserir_inconsistencia(nr_seq_nota_cobr_w,nr_seq_nota_servico_w,4);
			end if;
			
			update	ptu_nota_servico
			set	IE_CONSISTENTE	= current_setting('ptu_gerar_inco_receb_a700_pck.ie_consiste_servico_w')::varchar(10)
			where	nr_sequencia	= nr_seq_nota_servico_w;
			
			if (current_setting('ptu_gerar_inco_receb_a700_pck.ie_consiste_nota_cobr_w')::varchar(10) <> 'IN') and (current_setting('ptu_gerar_inco_receb_a700_pck.ie_consiste_servico_w')::varchar(10) = 'IN') then
				PERFORM set_config('ptu_gerar_inco_receb_a700_pck.ie_consiste_nota_cobr_w', 'IN', false);
			elsif (current_setting('ptu_gerar_inco_receb_a700_pck.ie_consiste_nota_cobr_w')::varchar(10) = 'C') and (current_setting('ptu_gerar_inco_receb_a700_pck.ie_consiste_servico_w')::varchar(10) = 'IG') then
				PERFORM set_config('ptu_gerar_inco_receb_a700_pck.ie_consiste_nota_cobr_w', 'IG', false);
			end if;
			
			end;
		end loop;
		close c02;
		
		update	ptu_nota_cobranca
		set	IE_CONSISTENTE	= current_setting('ptu_gerar_inco_receb_a700_pck.ie_consiste_nota_cobr_w')::varchar(10)
		where	nr_sequencia	= nr_seq_nota_cobr_w;
		
		end;
	end loop;
	close C01;
	
	end;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_gerar_inco_receb_a700_pck.ptu_gerar_inconsistencias ( nr_seq_serv_pre_pgto_p ptu_servico_pre_pagto.nr_sequencia%type, nr_seq_nota_cobr_p ptu_nota_cobranca.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;