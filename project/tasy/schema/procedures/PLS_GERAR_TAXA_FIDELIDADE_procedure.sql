-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_taxa_fidelidade ( nr_seq_lote_pgto_p pls_lote_pagamento.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

					
nr_evento_fidelidade_w		pls_evento.nr_sequencia%type;
nr_seq_lote_evento_w		pls_lote_evento.nr_sequencia%type;
dt_competencia_w		pls_lote_pagamento.dt_mes_competencia%type;
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;
vl_taxa_fidelidade_w		double precision;
nr_seq_prestador_w		pls_prestador.nr_sequencia%type;
nr_seq_pagamento_w		pls_pagamento_prestador.nr_sequencia%type;
nr_seq_pag_item_w		pls_pagamento_item.nr_sequencia%type;
nr_seq_evento_movimento_w	pls_evento_movimento.nr_sequencia%type;

C00 CURSOR(	nr_seq_lote_pgto_p	pls_lote_pagamento.nr_sequencia%type) FOR
	SELECT	b.nr_sequencia nr_seq_pagamento,
		b.nr_seq_prestador
	from	pls_pagamento_prestador	b,
		pls_lote_pagamento	a
	where	a.nr_sequencia		= b.nr_seq_lote
	and	a.nr_sequencia		= nr_seq_lote_pgto_p;
	
C01 CURSOR(	nr_seq_pagamento_pc	pls_pagamento_prestador.nr_sequencia%type) FOR
	SELECT	nr_seq_evento,
		vl_item
	from	pls_pagamento_item
	where	nr_seq_pagamento = nr_seq_pagamento_pc
	and	coalesce(ie_apropriar_total, 'N') = 'N';
	
C02 CURSOR(	nr_seq_evento_pc	pls_evento.nr_sequencia%type,
		nr_seq_prestador_pc	pls_prestador.nr_sequencia%type) FOR
	SELECT	tx_fidelidade,
		nr_seq_prestador_fidel
	from	pls_taxa_fidelidade
	where	nr_seq_evento = nr_seq_evento_pc
	and	coalesce(nr_seq_prestador, nr_seq_prestador_pc) = nr_seq_prestador_pc
	and	trunc(clock_timestamp()) between trunc(coalesce(dt_inicio_vigencia,clock_timestamp() - interval '1 days')) and trunc(coalesce(dt_fim_vigencia, clock_timestamp() + interval '1 days'))
	and	ie_situacao = 'A';
	
BEGIN

select	max(nr_sequencia)
into STRICT	nr_evento_fidelidade_w
from	pls_evento
where	ie_taxa_difelidade = 'S';

select	max(nr_sequencia),
	max(dt_competencia)
into STRICT	nr_seq_lote_evento_w,
	dt_competencia_w
from	pls_lote_evento
where	nr_seq_lote_pagamento = nr_seq_lote_pgto_p;

if (coalesce(nr_seq_lote_evento_w::text, '') = '') then
	select	max(cd_estabelecimento),
		max(dt_mes_competencia)
	into STRICT	cd_estabelecimento_w,
		dt_competencia_w
	from	pls_lote_pagamento
	where	nr_sequencia = nr_seq_lote_pgto_p;
	
	insert into pls_lote_evento(nr_sequencia,			dt_atualizacao,		nm_usuario,
		dt_atualizacao_nrec,		nm_usuario_nrec,	cd_estabelecimento,
		dt_competencia,			ie_origem,		nr_seq_lote_pagamento)
	values (nextval('pls_lote_evento_seq'),	clock_timestamp(),		nm_usuario_p,
		clock_timestamp(),			nm_usuario_p,		cd_estabelecimento_w,
		dt_competencia_w,		'A',			nr_seq_lote_pgto_p) returning nr_sequencia into nr_seq_lote_evento_w;
end if;

if (coalesce(nr_evento_fidelidade_w, 0) <> 0) then

	for r_c00_w in c00( nr_seq_lote_pgto_p ) loop
		nr_seq_pagamento_w	:= r_c00_w.nr_seq_pagamento;
		nr_seq_prestador_w	:= r_c00_w.nr_seq_prestador;
		
		for r_c01_w in c01( r_c00_w.nr_seq_pagamento ) loop
			vl_taxa_fidelidade_w	:= 0;
			
			for r_c02_w in c02( r_c01_w.nr_seq_evento , r_c00_w.nr_seq_prestador ) loop
				vl_taxa_fidelidade_w	:= coalesce(vl_taxa_fidelidade_w, 0) + dividir((coalesce(r_c02_w.tx_fidelidade, 1) * r_c01_w.vl_item), 100);
				
				if (r_c02_w.nr_seq_prestador_fidel IS NOT NULL AND r_c02_w.nr_seq_prestador_fidel::text <> '') then
					-- Define o prestador com o prestador da regra
					nr_seq_prestador_w := r_c02_w.nr_seq_prestador_fidel;
					
					-- Verifica se ha pagamento para o prestador da regra no lote de pagamento
					select	max(nr_sequencia)
					into STRICT	nr_seq_pagamento_w
					from	pls_pagamento_prestador
					where	nr_seq_prestador = nr_seq_prestador_w
					and	nr_seq_lote = nr_seq_lote_pgto_p;
					
					-- Se ainda nao ha pagamento para o prestador da regra insere o mesmo nesse lote
					if (coalesce(nr_seq_pagamento_w::text, '') = '') then
						insert into pls_pagamento_prestador(	nr_sequencia, 				nr_seq_lote, 		nr_seq_prestador,
											dt_atualizacao, 			nm_usuario, 		dt_atualizacao_nrec,
											nm_usuario_nrec, 			vl_pagamento)
									values (	nextval('pls_pagamento_prestador_seq'),	nr_seq_lote_pgto_p,	nr_seq_prestador_w,
											clock_timestamp(), 				nm_usuario_p,		clock_timestamp(),
											nm_usuario_p, 				0) returning nr_sequencia into nr_seq_pagamento_w;
					end if;
				end if;
			end loop;
			
			if (coalesce(vl_taxa_fidelidade_w,0) <> 0) then
				select	max(nr_sequencia)
				into STRICT	nr_seq_pag_item_w
				from	pls_pagamento_item
				where	nr_seq_pagamento	= nr_seq_pagamento_w
				and	nr_seq_evento		= nr_evento_fidelidade_w;
				
				if (coalesce(nr_seq_pag_item_w::text, '') = '') then
					insert into pls_pagamento_item(	nr_sequencia,				nr_seq_pagamento,	nr_seq_evento,
										dt_atualizacao,				nm_usuario,		vl_item,
										dt_atualizacao_nrec,			nm_usuario_nrec,	vl_glosa)
									values (nextval('pls_pagamento_item_seq'),	nr_seq_pagamento_w,	nr_evento_fidelidade_w,
										clock_timestamp(),				nm_usuario_p,		vl_taxa_fidelidade_w,
										clock_timestamp(),				nm_usuario_p,		0) returning nr_sequencia into nr_seq_pag_item_w;
				else
					update	pls_pagamento_item
					set	vl_item		= coalesce(vl_item, 0) + vl_taxa_fidelidade_w,
						dt_atualizacao	= clock_timestamp(),
						nm_usuario	= nm_usuario_p
					where	nr_sequencia = nr_seq_pag_item_w;
				end if;
				
				select	max(nr_sequencia)
				into STRICT	nr_seq_evento_movimento_w
				from	pls_evento_movimento	
				where	nr_seq_lote		= nr_seq_lote_evento_w
				and	nr_seq_prestador	= nr_seq_prestador_w
				and	nr_seq_evento		= nr_evento_fidelidade_w;
				
				if (coalesce(nr_seq_evento_movimento_w::text, '') = '') then
					insert into pls_evento_movimento(nr_sequencia,				nr_seq_lote,			nr_seq_prestador,
						nr_seq_evento,				dt_movimento,			dt_atualizacao,
						nm_usuario,				dt_atualizacao_nrec,		nm_usuario_nrec,
						vl_movimento,				nr_seq_lote_pgto,		nr_seq_lote_pgto_orig,
						dt_mes_comp_lote,			nr_seq_pagamento_item)
					values (nextval('pls_evento_movimento_seq'),	nr_seq_lote_evento_w,		nr_seq_prestador_w,
						nr_evento_fidelidade_w,			dt_competencia_w,		clock_timestamp(),
						nm_usuario_p,				clock_timestamp(),			nm_usuario_p,
						vl_taxa_fidelidade_w,			nr_seq_lote_pgto_p,		nr_seq_lote_pgto_p,
						dt_competencia_w,			nr_seq_pag_item_w);
				else
					update	pls_evento_movimento
					set	vl_movimento	= coalesce(vl_movimento, 0) + vl_taxa_fidelidade_w,
						dt_atualizacao	= clock_timestamp(),
						nm_usuario	= nm_usuario_p
					where	nr_sequencia 	= nr_seq_evento_movimento_w;
				end if;
				
				update	pls_pagamento_prestador
				set	vl_pagamento	= coalesce(vl_pagamento, 0) + coalesce(vl_taxa_fidelidade_w, 0)
				where	nr_sequencia	= nr_seq_pagamento_w;
			end if;
		end loop;
	end loop;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_taxa_fidelidade ( nr_seq_lote_pgto_p pls_lote_pagamento.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

