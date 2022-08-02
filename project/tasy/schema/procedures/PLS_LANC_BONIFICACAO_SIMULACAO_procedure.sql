-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_lanc_bonificacao_simulacao ( nr_seq_simul_item_p bigint, nr_seq_simulacao_p bigint, nm_usuario_p text) AS $body$
DECLARE

			
nr_seq_plano_w			bigint;
nr_seq_lanc_automotico_w	bigint;
nr_seq_regra_item_w		bigint;
nr_qtde_bonif_w			bigint;
nr_seq_bonificacao_vinculo_w	pls_bonificacao_vinculo.nr_sequencia%type;
ie_tipo_contratacao_w		pls_plano.ie_tipo_contratacao%type;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_regra_lanc_automatico
	where	ie_acao_regra 	= '6'
	and	(((nr_seq_grupo_produto IS NOT NULL AND nr_seq_grupo_produto::text <> '') and substr(pls_se_grupo_preco_produto(nr_seq_grupo_produto,nr_seq_plano_w),1,255) = 'S') or (coalesce(nr_seq_grupo_produto::text, '') = ''))
	and	((ie_tipo_contratacao = ie_tipo_contratacao_w) or (coalesce(ie_tipo_contratacao::text, '') = ''))
	and	(((nr_seq_plano IS NOT NULL AND nr_seq_plano::text <> '') and	nr_seq_plano = nr_seq_plano_w) or (coalesce(nr_seq_plano::text, '') = ''))
	and	ie_situacao	= 'A'
	and	clock_timestamp() between coalesce(dt_inicio_vigencia,clock_timestamp()) and coalesce(dt_fim_vigencia,clock_timestamp());
	
C02 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_regra_lanc_aut_item
	where	nr_seq_regra	= nr_seq_lanc_automotico_w
	and	(nr_seq_bonificacao IS NOT NULL AND nr_seq_bonificacao::text <> '')	
	and	ie_situacao	= 'A';
	
C03 CURSOR FOR
	SELECT	nr_sequencia	
	from	pls_bonificacao_vinculo
	where	nr_seq_segurado_simul	= nr_seq_simul_item_p;	
	

BEGIN
	open C03;
	loop
	fetch C03 into	
		nr_seq_bonificacao_vinculo_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin
		delete	FROM pls_simulacao_resumo
		where 	nr_seq_vinc_bonificacao	= nr_seq_bonificacao_vinculo_w;
	
		delete	FROM pls_bonificacao_vinculo
		where	nr_sequencia	= nr_seq_bonificacao_vinculo_w;		
		end;
	end loop;
	close C03;
	
	select	nr_seq_produto
	into STRICT	nr_seq_plano_w
	from	pls_simulpreco_individual
	where	nr_sequencia	= nr_seq_simul_item_p;
	
	if (nr_seq_plano_w IS NOT NULL AND nr_seq_plano_w::text <> '') then
		select	max(ie_tipo_contratacao)
		into STRICT	ie_tipo_contratacao_w
		from	pls_plano
		where	nr_sequencia = nr_seq_plano_w;
		
		open C01;
		loop
		fetch C01 into	
			nr_seq_lanc_automotico_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			open C02;
			loop
			fetch C02 into	
				nr_seq_regra_item_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
				begin	
				select	count(*)
				into STRICT	nr_qtde_bonif_w
				from 	pls_bonificacao_vinculo a
				where 	a.nr_seq_segurado_simul = nr_seq_simul_item_p;
				
				if (coalesce(nr_qtde_bonif_w,0) = 0 ) then				
					CALL pls_gerar_bonificacao_sca(nr_seq_simul_item_p, nr_seq_plano_w,6,nr_seq_simulacao_p,nm_usuario_p);				
				end if;
				end;
			end loop;
			close C02;
			end;
		end loop;
		close C01;
	end if;	
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_lanc_bonificacao_simulacao ( nr_seq_simul_item_p bigint, nr_seq_simulacao_p bigint, nm_usuario_p text) FROM PUBLIC;

