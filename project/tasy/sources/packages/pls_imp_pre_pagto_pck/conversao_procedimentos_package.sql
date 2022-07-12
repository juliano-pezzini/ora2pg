-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_imp_pre_pagto_pck.conversao_procedimentos ( nr_seq_prot_gerado_p pls_faturamento_prot.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE

	
ie_somente_codigo_w			pls_regra_conv_mat_interc.ie_somente_codigo%type;	
cd_procedimento_w			procedimento.cd_procedimento%type;
ie_origem_proced_w			procedimento.ie_origem_proced%type;
ie_origem_proced_padrao_w	procedimento.ie_origem_proced%type;
ie_origem_proc_valido_w		pls_parametros.ie_origem_proc_valido%type;
nr_seq_regra_conv_w			bigint;
qt_proced_origem_w			integer := 0;
qt_proc_valido_w			integer := 0;

--Busca itens com tipo item = P e tambem aqueles iguais a OD que nao foram identificados anteriormente como sendo materiais.

C01 CURSOR FOR 	
	SELECT	a.cd_versao_tiss,
			c.cd_procedimento cd_item,
			c.dt_execucao,
			c.nr_sequencia
	from	pls_faturamento_prot a,
			pls_faturamento_conta b,
			pls_fat_conta_item c
	where	a.nr_sequencia = nr_seq_prot_gerado_p
	and		b.nr_seq_protocolo = a.nr_sequencia
	and		c.nr_seq_conta = b.nr_sequencia
	and 	c.ie_tipo_item = 'OD'
	and 	coalesce(c.ie_tipo_item_conv::text, '') = ''
	
union all

	SELECT	a.cd_versao_tiss,
			c.cd_procedimento cd_item,
			c.dt_execucao,
			c.nr_sequencia
	from	pls_faturamento_prot a,
			pls_faturamento_conta b,
			pls_fat_conta_item c
	where	a.nr_sequencia = nr_seq_prot_gerado_p
	and		b.nr_seq_protocolo = a.nr_sequencia
	and		c.nr_seq_conta = b.nr_sequencia
	and 	c.ie_tipo_item = 'P';
	
BEGIN

	select 	coalesce(max(ie_origem_proc_valido),'N')
	into STRICT	ie_origem_proc_valido_w
	from 	pls_parametros
	where 	cd_estabelecimento = cd_estabelecimento_p;

	for r_c01_w in C01 loop
		
		/*A origem do procedimento e buscado por regra existente no cadastro de regras / Procedimentos/ regra origem.*/


		pls_obter_proced_conversao(	r_c01_w.cd_item, null, null,
						cd_estabelecimento_p, 4, null,
						3, 'R', null,
						null, null, null,
						null, cd_procedimento_w, ie_origem_proced_w,
						nr_seq_regra_conv_w, ie_somente_codigo_w, clock_timestamp(),
						null, null, null);
		
		-- Obter a origem padrao para os itens conforme a regra.

		ie_origem_proced_padrao_w := pls_obter_origem_proced(cd_estabelecimento_p, null, 'R', r_c01_w.dt_execucao, null);
		
		if ( coalesce(ie_origem_proced_w::text, '') = '') then
			ie_origem_proced_w := ie_origem_proced_padrao_w;
		end if;
				
		if ( ie_origem_proc_valido_w	= 'S') then
			select	count(1)
			into STRICT	qt_proced_origem_w
			from	procedimento
			where	cd_procedimento = cd_procedimento_w
			and	ie_origem_proced = ie_origem_proced_w
			and	ie_situacao = 'A';
			
			/*Se este procedimento nao existir na origem padrao e selecionado o max origem proced*/


			if (qt_proced_origem_w = 0) then	
				-- Buscar a origem do procedimento ativo

				select	max(ie_origem_proced)
				into STRICT	ie_origem_proced_w
				from	procedimento
				where	cd_procedimento = cd_procedimento_w
				and	ie_situacao = 'A';	
				
				-- Se nao encontrar a origem em procedimentos ativos, busca em procedimentos que nao estiverem ativos.

				if (coalesce(ie_origem_proced_w::text, '') = '') then
					select	max(ie_origem_proced)
					into STRICT	ie_origem_proced_w
					from	procedimento
					where	cd_procedimento = cd_procedimento_w;	
				end if;
			end if;
		else
			select	count(1)
			into STRICT	qt_proced_origem_w
			from	procedimento
			where	cd_procedimento = cd_procedimento_w
			and	ie_origem_proced = ie_origem_proced_w;
			
			if (qt_proced_origem_w = 0) then	
			
				-- Buscar a origem do procedimento ativo

				select	coalesce(max(ie_origem_proced), ie_origem_proced_w)
				into STRICT	ie_origem_proced_w
				from	procedimento
				where	cd_procedimento = cd_procedimento_w
				and		ie_origem_proced in (	SELECT	ie_origem_proced
								from	pls_regra_origem_proced
								where	ie_origem_proced !=ie_origem_proced_w );	
			end if;
		end if;
		
		select	count(1)
		into STRICT	qt_proc_valido_w
		from	procedimento
		where	cd_procedimento	= cd_procedimento_w
		and	ie_origem_proced = ie_origem_proced_w;
		
		-- Tem que deixar o item como NAO ENCONTRADO

		if ( qt_proc_valido_w = 0) then
			cd_procedimento_w := null;
			ie_origem_proced_w := null;
		end if;
	
		update 	pls_fat_conta_item
		set		ie_tipo_item_conv = 'P',				
				cd_procedimento_conv = cd_procedimento_w,
				ie_origem_proced_conv = ie_origem_proced_w
		where	nr_sequencia = r_c01_w.nr_sequencia;
		
	end loop;

END;	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_imp_pre_pagto_pck.conversao_procedimentos ( nr_seq_prot_gerado_p pls_faturamento_prot.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
