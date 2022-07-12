-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_pagador_lote_fat ( nr_seq_lote_p bigint, nr_seq_segurado_p bigint, nr_seq_conta_p bigint, nr_seq_evento_p bigint, nr_seq_lib_fat_conta_evento_p pls_lib_fat_conta_evento.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Obter se o pagador do beneficiario pertence ao lote de faturamento conforme as 
regras
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[ X ]  Objetos do dicionario [  ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
-------------------------------------------------------------------------------------------------------------------

Referencias:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
cd_estabelecimento_w		varchar(20);
cd_cgc_outorgante_w		varchar(14);
ie_fatura_congenere_coop_w	varchar(10);
ie_tipo_faturamento_w		varchar(255);
ie_tipo_segurado_w		varchar(3);
ie_tipo_congenere_w		varchar(2);
sg_estado_w			pessoa_juridica.sg_estado%type;
sg_estado_int_w			pessoa_juridica.sg_estado%type;
ie_tipo_intercambio_w		varchar(2);
ie_pagador_lote_w		varchar(1)	:= 'N';
ie_entra_regra_w		varchar(1)	:= 'N';
ie_regra_restritiva_w		varchar(1)	:= 'N';
nr_seq_regra_fat_w		bigint;
nr_seq_congenere_w		bigint	:= null;
nr_seq_camara_w			bigint	:= null;
nr_seq_contrato_w		bigint;
qt_registro_w			integer;
nr_seq_pagador_w		bigint;
nr_seq_intercambio_w		bigint;
nr_seq_ops_congenere_w		bigint;
nr_seq_regra_w			bigint;
nr_seq_pag_ops_cong_w		bigint;
nr_seq_congenere_prot_w		pls_congenere.nr_sequencia%type;
nr_seq_protocolo_w		pls_protocolo_conta.nr_sequencia%type;
nr_seq_grupo_intercambio_w	pls_intercambio.nr_seq_grupo_intercambio%type;
ie_evento_restritivo_w		pls_parametro_faturamento.ie_evento_restritivo%type;
ie_nacional_w			pls_congenere.ie_nacional%type;
cd_guia_referencia_w		pls_conta.cd_guia_referencia%type;
ie_tipo_protocolo_w		pls_protocolo_conta.ie_tipo_protocolo%type;
ie_origem_protocolo_w		pls_protocolo_conta.ie_origem_protocolo%type;

ie_benef_remido_w		pls_regra_div_fat_benef.ie_benef_remido%type;
ie_tipo_exportacao_w		pls_congenere.ie_tipo_exportacao%type;
ie_tipo_lote_w			pls_lote_faturamento.ie_tipo_lote%type;

C01 CURSOR FOR
	SELECT	a.nr_seq_regra,
		a.ie_entra_regra
	from	pls_regra_fat_pagador	a,
		pls_regra_faturamento	b
	where	b.nr_sequencia = a.nr_seq_regra
	and	b.ie_situacao = 'A'
	and	((a.ie_tipo_faturamento		= ie_tipo_faturamento_w 	or coalesce(a.ie_tipo_faturamento::text, '') = '') or
		((a.ie_tipo_faturamento = 'ICOOP') and (ie_tipo_faturamento_w = 'IC') and (ie_tipo_congenere_w = 'CO'))) -- Edgar 29/10/2013, OS 663352, tratado o novo dominio 'ICOOP', para itenrcambio somente entre cooperativas
	and (a.nr_seq_camara		= nr_seq_camara_w 		or coalesce(a.nr_seq_camara::text, '') = '')
	and (a.nr_seq_contrato		= nr_seq_contrato_w 		or coalesce(a.nr_seq_contrato::text, '') = '')
	and (a.nr_seq_intercambio 		= nr_seq_intercambio_w 		or coalesce(a.nr_seq_intercambio::text, '') = '')
	and (a.nr_seq_ops_congenere		= nr_seq_ops_congenere_w	or coalesce(a.nr_seq_ops_congenere::text, '') = '')
	and (a.nr_seq_grupo_intercambio	= nr_seq_grupo_intercambio_w	or coalesce(a.nr_seq_grupo_intercambio::text, '') = '')
	and (ie_evento_restritivo_w		= 'N'				or a.nr_seq_regra = nr_seq_regra_fat_w)
	and	((coalesce(a.ie_tipo_intercambio,'A') = 'A') 			or (coalesce(a.ie_tipo_intercambio,'A') 	= coalesce(ie_tipo_intercambio_w,'A')))	
	and	((coalesce(a.ie_fatura_congenere_coop,'A') = 'A') 			or (coalesce(a.ie_fatura_congenere_coop,'A') = coalesce(ie_fatura_congenere_coop_w,'A')))
	and	(((a.nr_seq_cooperativa		= nr_seq_congenere_w 		or coalesce(a.nr_seq_cooperativa::text, '') = '') and a.ie_coop_inferiores = 'N')
		or coalesce(a.nr_seq_cooperativa,coalesce(nr_seq_congenere_w,0)) = coalesce(nr_seq_congenere_w,0))
	and	(((pls_obter_se_unimed_superior(nr_seq_congenere_w, a.nr_seq_cooperativa) = 'S' or coalesce(a.nr_seq_cooperativa::text, '') = '') and a.ie_coop_inferiores  = 'S')
		or coalesce(a.nr_seq_cooperativa,coalesce(nr_seq_congenere_w,0)) = coalesce(nr_seq_congenere_w,0))
	--and	a.ie_entra_regra = 'S'
	and	exists (SELECT	1
			from	pls_evento_faturamento 	y,
				pls_regra_fat_evento 	x
			where	y.ie_situacao	= 'A'
			and	y.nr_sequencia	= x.nr_seq_evento
			and	x.nr_seq_regra 	= a.nr_seq_regra
			and	x.nr_seq_evento	= nr_seq_evento_p)
	order by
		coalesce(a.ie_tipo_intercambio,' '),
		coalesce(a.nr_seq_intercambio,0),
		coalesce(a.nr_seq_contrato,0),
		coalesce(a.nr_seq_cooperativa,0),
		coalesce(a.nr_seq_ops_congenere,0),
		coalesce(a.nr_seq_grupo_intercambio,0),
		coalesce(a.nr_seq_camara,0),
		coalesce(a.ie_tipo_faturamento,' '),
		coalesce(a.ie_fatura_congenere_coop,' '),
		CASE WHEN a.nr_seq_regra=nr_seq_regra_fat_w THEN  1  ELSE 0 END;


BEGIN
if	((nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '') and (nr_seq_segurado_p IS NOT NULL AND nr_seq_segurado_p::text <> '') and (nr_seq_conta_p IS NOT NULL AND nr_seq_conta_p::text <> '')) or (nr_seq_lib_fat_conta_evento_p IS NOT NULL AND nr_seq_lib_fat_conta_evento_p::text <> '') then
	
	if (nr_seq_lib_fat_conta_evento_p IS NOT NULL AND nr_seq_lib_fat_conta_evento_p::text <> '') then
		select	a.nr_seq_regra_fat,
			d.cd_estabelecimento
		into STRICT	nr_seq_regra_fat_w,
			cd_estabelecimento_w
		from	pls_lib_faturamento d,
			pls_lib_fat_conta c,
			pls_lib_fat_conta_pos b,
			pls_lib_fat_conta_evento a
		where	c.nr_seq_lib_fat		= d.nr_sequencia
		and	b.nr_seq_lib_fat_conta		= c.nr_sequencia
		and	a.nr_seq_lib_fat_conta_pos	= b.nr_sequencia
		and	a.nr_sequencia			= nr_seq_lib_fat_conta_evento_p;
	else
		select	a.nr_seq_regra_fat,
			a.cd_estabelecimento
		into STRICT	nr_seq_regra_fat_w,
			cd_estabelecimento_w
		from	pls_lote_faturamento	a
		where	a.nr_sequencia	= nr_seq_lote_p;
	end if;
	
	select	coalesce(max(ie_evento_restritivo),'N')
	into STRICT	ie_evento_restritivo_w
	from	pls_parametro_faturamento
	where	cd_estabelecimento	= cd_estabelecimento_w;	
	
	select	max(x.nr_seq_congenere),
		max(x.nr_sequencia),
		max(c.cd_guia_referencia),
		max(x.ie_tipo_protocolo),
		max(c.ie_tipo_segurado),
		max(x.ie_origem_protocolo),
		pls_obter_se_benef_remido(nr_seq_segurado_p, max(c.dt_atendimento_referencia)) benef_remido
	into STRICT	nr_seq_congenere_prot_w,
		nr_seq_protocolo_w,
		cd_guia_referencia_w,
		ie_tipo_protocolo_w,
		ie_tipo_segurado_w,
		ie_origem_protocolo_w,
		ie_benef_remido_w
	from	pls_protocolo_conta x,
		pls_conta c
	where	x.nr_sequencia	= c.nr_seq_protocolo
	and	c.nr_sequencia	= nr_seq_conta_p;
	
	/* Obter dados segurado */

	select	a.nr_seq_pagador,
		a.nr_seq_contrato,
		coalesce(ie_tipo_segurado_w,a.ie_tipo_segurado),
		a.nr_seq_intercambio
	into STRICT	nr_seq_pagador_w,
		nr_seq_contrato_w,
		ie_tipo_segurado_w,
		nr_seq_intercambio_w
	from	pls_segurado	a
	where	a.nr_sequencia	= nr_seq_segurado_p;
	
	/* Usuario eventual */

	if (coalesce(nr_seq_pagador_w::text, '') = '') then
	--if	(ie_tipo_segurado_w in ('I','H')) then
		
		select	nr_seq_ops_congenere,
			nr_seq_congenere
		into STRICT	nr_seq_ops_congenere_w,
			nr_seq_congenere_w
		from	pls_segurado a
		where	a.nr_sequencia	= nr_seq_segurado_p;
		
		-- quando e reembolso, prioriza o congenere do protocolo, caso existir
		if	((ie_tipo_protocolo_w = 'R') or (ie_origem_protocolo_w = 'G')) and (nr_seq_congenere_prot_w IS NOT NULL AND nr_seq_congenere_prot_w::text <> '') then
		
			nr_seq_congenere_w := nr_seq_congenere_prot_w;
		
		end if;

		if (nr_seq_congenere_w IS NOT NULL AND nr_seq_congenere_w::text <> '') then
			select	coalesce(max(a.ie_fatura_congenere_coop), 'A')
			into STRICT	ie_fatura_congenere_coop_w
			from	pls_congenere a
			where	a.nr_sequencia = coalesce(nr_seq_ops_congenere_w, nr_seq_congenere_w);
			
			select	max(cd_cgc_outorgante)
			into STRICT	cd_cgc_outorgante_w
			from	pls_outorgante
			where	cd_estabelecimento	= cd_estabelecimento_w;
			
			/* Obter a UF da operadora  - Tasy*/

			select	coalesce(max(sg_estado), 'X')
			into STRICT	sg_estado_w
			from	pessoa_juridica
			where	cd_cgc	= cd_cgc_outorgante_w;
			
			select	max(ie_tipo_congenere)
			into STRICT	ie_tipo_congenere_w
			from	pls_congenere
			where	nr_sequencia	= nr_seq_congenere_w;
						
			/* Obter a UF da operadora do beneficiario eventual ou que enviou o protocolo*/

			select	coalesce(max(a.sg_estado), 'X'),
				max(b.ie_tipo_congenere),
				coalesce(max(b.ie_nacional),'N')
			into STRICT	sg_estado_int_w,
				ie_tipo_congenere_w,
				ie_nacional_w
			from	pessoa_juridica	a,
				pls_congenere	b
			where	a.cd_cgc	= b.cd_cgc
			and	b.nr_sequencia	= nr_seq_congenere_w;			
			
			if (ie_nacional_w = 'S') then
				ie_tipo_intercambio_w := 'N';
				
			elsif (sg_estado_w <> 'X') and (sg_estado_int_w <> 'X') then
				if (sg_estado_w = sg_estado_int_w) then
					ie_tipo_intercambio_w	:= 'E';
				else	
					ie_tipo_intercambio_w	:= 'N';
				end if;
			else
				ie_tipo_intercambio_w	:= 'A';
			end if;			
			
			select	max(a.nr_sequencia)
			into STRICT	nr_seq_pagador_w
			from	pls_contrato_pagador	a
			where	a.nr_seq_congenere	= nr_seq_congenere_w
			and	coalesce(a.dt_rescisao::text, '') = '';

				ie_tipo_faturamento_w	:= 'IC'; -- Intercambio entre cooperativas ou congeneres - Usuario eventual
			select	max(a.nr_seq_camara)
			into STRICT	nr_seq_camara_w
			from	pls_congenere_camara a
			where	a.nr_seq_congenere	= nr_seq_congenere_w
			and	clock_timestamp() between a.dt_inicio_vigencia_ref and a.dt_fim_vigencia_ref;
			
			if (ie_fatura_congenere_coop_w = 'S') then
				select	max(nr_sequencia)
				into STRICT	nr_seq_pag_ops_cong_w
				from	pls_contrato_pagador
				where	nr_seq_congenere	= nr_seq_ops_congenere_w
				and	coalesce(dt_rescisao::text, '') = '';
				
				if (nr_seq_pag_ops_cong_w IS NOT NULL AND nr_seq_pag_ops_cong_w::text <> '') then
					nr_seq_camara_w := null;
				end if;
			end if;
		end if;
	/* Contrato de intercambio */

	else	
		select	max(c.ie_tipo_congenere) ie_tipo_congenere,
			coalesce(nr_seq_intercambio_w,max(b.nr_sequencia)) nr_seq_intercambio,
			max(b.nr_seq_congenere) nr_seq_congenere,
			max(b.nr_seq_grupo_intercambio)
		into STRICT	ie_tipo_congenere_w,
			nr_seq_intercambio_w,
			nr_seq_congenere_w,
			nr_seq_grupo_intercambio_w
		from	pls_congenere		c,
			pls_intercambio 	b,
			pls_contrato_pagador 	a
		where	b.nr_sequencia	= a.nr_seq_pagador_intercambio
		and	c.nr_sequencia	= b.nr_seq_congenere
		and	a.nr_sequencia	= nr_seq_pagador_w;
		
		select	max(a.nr_seq_ops_congenere)
		into STRICT	nr_seq_ops_congenere_w
		from	pls_segurado a
		where 	a.nr_sequencia = nr_seq_segurado_p;
		
		if (nr_seq_ops_congenere_w IS NOT NULL AND nr_seq_ops_congenere_w::text <> '') then
			nr_seq_congenere_w	:= nr_seq_ops_congenere_w;
			
			select	max(ie_tipo_congenere)
			into STRICT	ie_tipo_congenere_w
			from	pls_congenere
			where	nr_sequencia = nr_seq_congenere_w;
		end if;
		
		if (coalesce(nr_seq_congenere_w::text, '') = '') then
			select	max(a.nr_seq_congenere)
			into STRICT	nr_seq_congenere_w
			from	pls_contrato_pagador	a
			where	a.nr_sequencia	= nr_seq_pagador_w;
		end if;
		
		-- quando e reembolso, prioriza o congenere do protocolo, caso existir
		if	((ie_tipo_protocolo_w = 'R') or (ie_origem_protocolo_w = 'G')) and (nr_seq_congenere_prot_w IS NOT NULL AND nr_seq_congenere_prot_w::text <> '') then
		
			nr_seq_congenere_w := nr_seq_congenere_prot_w;
		
		end if;

		if (nr_seq_congenere_w IS NOT NULL AND nr_seq_congenere_w::text <> '') then
			select	coalesce(max(a.ie_fatura_congenere_coop), 'A')
			into STRICT	ie_fatura_congenere_coop_w
			from	pls_congenere a
			where	a.nr_sequencia	= nr_seq_congenere_w;
		
			/* Obter a UF da operadora  - Tasy*/

			select	coalesce(max(sg_estado), 'X')
			into STRICT	sg_estado_w
			from	pessoa_juridica
			where	cd_cgc	=	(SELECT	max(cd_cgc_outorgante)
						from	pls_outorgante
						where	cd_estabelecimento	= cd_estabelecimento_w);
			
			if (ie_tipo_congenere_w = 'OP') and (ie_tipo_segurado_w = 'T') then
				nr_seq_congenere_w := coalesce(nr_seq_congenere_prot_w,nr_seq_congenere_w);
			end if;
			
			-- quando e reembolso, prioriza o congenere do protocolo, caso existir
			if	((ie_tipo_protocolo_w = 'R') or (ie_origem_protocolo_w = 'G')) and (nr_seq_congenere_prot_w IS NOT NULL AND nr_seq_congenere_prot_w::text <> '') then
			
				nr_seq_congenere_w := nr_seq_congenere_prot_w;
			
			end if;

			/* Obter a UF da operadora do beneficiario eventual ou que enviou o protocolo*/

			select	coalesce(max(a.sg_estado), 'X'),
				coalesce(max(b.ie_nacional),'N')
			into STRICT	sg_estado_int_w,
				ie_nacional_w
			from	pessoa_juridica	a,
				pls_congenere	b
			where	a.cd_cgc	= b.cd_cgc
			and	b.nr_sequencia	= nr_seq_congenere_w;
			
			if (ie_nacional_w = 'S') then
				ie_tipo_intercambio_w	:= 'N';
			
			elsif (sg_estado_w <> 'X') and (sg_estado_int_w <> 'X') then
				if (sg_estado_w	= sg_estado_int_w) then
					ie_tipo_intercambio_w	:= 'E';
				else	
					ie_tipo_intercambio_w	:= 'N';
				end if;
			else
				ie_tipo_intercambio_w	:= 'A';
			end if;			
		end if;
		
		if (coalesce(ie_tipo_congenere_w::text, '') = '') then
			select	max(c.ie_tipo_congenere) ie_tipo_congenere,
				max(b.nr_sequencia) nr_seq_intercambio,
				max(b.nr_seq_grupo_intercambio)
			into STRICT	ie_tipo_congenere_w,
				nr_seq_intercambio_w,
				nr_seq_grupo_intercambio_w
			from	pls_congenere		c,
				pls_intercambio 	b,
				pls_contrato_pagador 	a
			where	b.nr_sequencia	= a.nr_seq_pagador_intercambio
			and	c.nr_sequencia	= b.nr_seq_oper_congenere
			and	a.nr_sequencia	= nr_seq_pagador_w;
		end if;
		
		-- OS 2001572 - Unimed Rio Preto - Jtrindade - Caso nao encontre o IE_TIPO_CONGENERE_W, faz o mesmo select que faz no if acima para obter o IE_TIPO_CONGENERE_W

		-- Foi realizado alteracoes para a Unimed litoral onde impactou na hora de obter o ie_tipo_congenere_w, pois as contas que entravam no if acima com o ie_tipo_segurado_w in ('I','H') passou a entrar no else, onde nao tinha esse select

		-- para obter o ie_tipo_congenere_w pelo nr_seq_congenere_w - 08/11/2019 
		if (coalesce(ie_tipo_congenere_w::text, '') = '') then
			select	max(ie_tipo_congenere)
			into STRICT	ie_tipo_congenere_w
			from	pls_congenere
			where	nr_sequencia	= nr_seq_congenere_w;
		end if;
		
		if (coalesce(nr_seq_intercambio_w::text, '') = '') then
			select	max(b.nr_sequencia) nr_seq_intercambio
			into STRICT	nr_seq_intercambio_w
			from	pls_intercambio 	b,
				pls_contrato_pagador 	a
			where	b.nr_sequencia	= a.nr_seq_pagador_intercambio
			and	a.nr_sequencia	= nr_seq_pagador_w;
		end if;

		select	max(a.nr_seq_camara)
		into STRICT	nr_seq_camara_w
		from	pls_congenere_camara a
		where	a.nr_seq_congenere	= nr_seq_congenere_w
		and	clock_timestamp() between a.dt_inicio_vigencia_ref and a.dt_fim_vigencia_ref;
		
		if (ie_fatura_congenere_coop_w = 'S') then
			select	max(nr_sequencia)
			into STRICT	nr_seq_pag_ops_cong_w
			from	pls_contrato_pagador
			where	nr_seq_congenere	= nr_seq_congenere_w
			and	coalesce(dt_rescisao::text, '') = '';
			
			if (nr_seq_pag_ops_cong_w IS NOT NULL AND nr_seq_pag_ops_cong_w::text <> '') then
				nr_seq_camara_w := null;
			end if;
		end if;
		
		if (ie_tipo_congenere_w IS NOT NULL AND ie_tipo_congenere_w::text <> '') then
			if (ie_tipo_congenere_w = 'CO') then
				ie_tipo_faturamento_w 	:= 'PI'; --Contratos entre cooperativas medicas			
			elsif (ie_tipo_congenere_w = 'OP') then
				ie_tipo_faturamento_w 	:= 'PO'; --Contratos entre operadoras congenere 
				ie_tipo_intercambio_w := coalesce(ie_tipo_intercambio_w,'X');
			end if;
		elsif (ie_tipo_segurado_w in ('I','H')) then
			ie_tipo_faturamento_w	:= 'IC'; -- Intercambio entre cooperativas ou congeneres - Usuario eventual
		elsif (ie_benef_remido_w = 'S')	then
			ie_tipo_faturamento_w := 'R';
		else
			ie_tipo_faturamento_w	:= 'P'; -- Padrao pos - contrato OPS
		end if;			
	end if;

	/* Verificar pagadores que incidem na regra */

	open C01;
	loop
	fetch C01 into	
		nr_seq_regra_w,
		ie_entra_regra_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	end loop;
	close C01;
	
	if (coalesce(nr_seq_regra_w, nr_seq_regra_fat_w) <> nr_seq_regra_fat_w) then
		ie_entra_regra_w := 'N';
	end if;
	
	/* Verificar se nao esta nas excecoes do lote */

	if (ie_entra_regra_w = 'S') then
		select	count(1)
		into STRICT	qt_registro_w
		from	pls_lote_fat_excecao a
		where	a.nr_seq_lote		= nr_seq_lote_p
		and (a.nr_seq_cooperativa	= nr_seq_congenere_w 	or coalesce(a.nr_seq_cooperativa::text, '') = '')
		and (a.nr_seq_contrato	= nr_seq_contrato_w 	or coalesce(a.nr_seq_contrato::text, '') = '')
		and (a.nr_seq_conta		= nr_seq_conta_p 	or coalesce(a.nr_seq_conta::text, '') = '')
		and (a.nr_seq_protocolo	= nr_seq_protocolo_w	or coalesce(a.nr_seq_protocolo::text, '') = '')
		and (a.nr_seq_intercambio	= nr_seq_intercambio_w 	or coalesce(a.nr_seq_intercambio::text, '') = '')
		and (a.cd_guia_referencia	= cd_guia_referencia_w 	or coalesce(a.cd_guia_referencia::text, '') = '')
		and (pls_cons_regra_atend_cart(nr_seq_segurado_p, a.nr_seq_regra_atend_cart) = 'S' or coalesce(a.nr_seq_regra_atend_cart::text, '') = '')  LIMIT 1;
		
		if (qt_registro_w > 0) then
			ie_pagador_lote_w	:= 'N';
		else
			ie_pagador_lote_w	:= 'S';
		end if;
	else
		ie_pagador_lote_w	:= 'N';
	end if;
	
	if (nr_seq_congenere_w IS NOT NULL AND nr_seq_congenere_w::text <> '') then
		select	coalesce(con.ie_tipo_exportacao, 'TXT')
		into STRICT	ie_tipo_exportacao_w
		from	pls_congenere	con
		where	con.nr_sequencia	= nr_seq_congenere_w;
		
		select	coalesce(fat.ie_tipo_lote, 'C')
		into STRICT	ie_tipo_lote_w
		from	pls_lote_faturamento	fat
		where	fat.nr_sequencia	= nr_seq_lote_p;
		
		if (ie_tipo_exportacao_w = 'TXT') and (ie_tipo_lote_w = 'A')then
			ie_pagador_lote_w	:= 'N';
		end if;
	end if;
end if;

return ie_pagador_lote_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_pagador_lote_fat ( nr_seq_lote_p bigint, nr_seq_segurado_p bigint, nr_seq_conta_p bigint, nr_seq_evento_p bigint, nr_seq_lib_fat_conta_evento_p pls_lib_fat_conta_evento.nr_sequencia%type) FROM PUBLIC;

