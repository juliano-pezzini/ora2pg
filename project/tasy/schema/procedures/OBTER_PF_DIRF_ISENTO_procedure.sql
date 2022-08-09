-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_pf_dirf_isento ( nr_seq_lote_dirf_p bigint, cd_empresa_p bigint, cd_estabelecimento_p bigint, dt_mes_referencia_p timestamp) AS $body$
DECLARE


dt_inicial_w		timestamp := trunc(dt_mes_referencia_p,'mm');
dt_final_w		timestamp := fim_mes(dt_mes_referencia_p);
qt_registros_w		integer := 0;

C01 CURSOR FOR
	SELECT	a.cd_operacao_nf,
		a.cd_retencao,
		a.ie_tipo_registro,
		b.nr_seq_apresent
	from	valor_dominio b,
		dirf_regra_tipo_rend a
	where	a.ie_tipo_registro = b.vl_dominio
	and	b.cd_dominio = 7339
	and	coalesce(cd_estabelecimento,cd_estabelecimento_p) = cd_estabelecimento_p
	and	a.ie_situacao = 'A'
	group by
		a.cd_operacao_nf,
		a.cd_retencao,
		a.ie_tipo_registro,
		a.cd_estabelecimento,
		b.nr_seq_apresent
	order by 4,1;
c01_w		c01%rowtype;

C02 CURSOR FOR
	SELECT	a.nr_titulo,
		coalesce(b.vl_mercadoria, a.vl_titulo) vl_titulo,
		c01_w.cd_retencao,
		a.dt_liquidacao,
		b.cd_operacao_nf
	FROM nota_fiscal b, titulo_pagar a
LEFT OUTER JOIN nota_fiscal_venc c ON (a.nr_titulo = c.nr_titulo_pagar)
WHERE a.nr_seq_nota_fiscal	= b.nr_sequencia  and b.cd_operacao_nf	= c01_w.cd_operacao_nf and (a.cd_pessoa_fisica IS NOT NULL AND a.cd_pessoa_fisica::text <> '') and a.cd_estabelecimento	= cd_estabelecimento_p and obter_empresa_estab(a.cd_estabelecimento) = cd_empresa_p and a.dt_liquidacao between dt_inicial_w and dt_final_w and (((not exists (	SELECT 1
				from	titulo_pagar_imposto x
				where	x.nr_titulo = a.nr_titulo
				 LIMIT 1)) and (not exists (	select	1
				from	dirf_titulo_pagar y
				where	y.nr_titulo = a.nr_titulo 
				 LIMIT 1))) or (exists ( select	1
				from	nota_fiscal w,
					nota_fiscal_item z
				where	w.nr_sequencia = z.nr_sequencia
				and	w.nr_sequencia = b.nr_sequencia
				and	exists (select	1
						from	dirf_regra_item a
						where	obter_se_estrutura_mat(a.cd_grupo_material, a.cd_subgrupo_material, a.cd_classe_material, a.cd_material, z.cd_material, 'S') = 'S'
						and	w.cd_estabelecimento = coalesce(a.cd_estab_exclusivo, w.cd_estabelecimento)
						and	a.cd_empresa = obter_empresa_estab(c.cd_estabelecimento)
						and	dt_mes_referencia_p between trunc(coalesce(a.dt_inicio_vig,dt_mes_referencia_p)) and fim_dia(coalesce(a.dt_fim_vig,dt_mes_referencia_p))
						))));
c02_w		c02%rowtype;


BEGIN

-- Buscar todas as regras ativas para o estabelecimento do lote MENSAL
open C01;
loop
fetch C01 into
	c01_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	-- Buscar os títulos que se enquadram na regra
	open C02;
	loop
	fetch C02 into
		c02_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin

		select	coalesce(sum(a.vl_pago),0)
		into STRICT	c02_w.vl_titulo
		from	titulo_pagar_baixa a
		where	nr_titulo = c02_w.nr_titulo;


		insert into dirf_titulo_pagar(	nr_sequencia           ,
						dt_atualizacao         ,
						nm_usuario             ,
						dt_atualizacao_nrec    ,
						nm_usuario_nrec        ,
						nr_seq_lote_dirf       ,
						nr_titulo              ,
						vl_rendimento          ,
						vl_imposto             ,
						cd_tributo             ,
						cd_darf                ,
						dt_base_titulo         ,
						ie_origem              ,
						ie_registro,
						cd_operacao_nf)
		values (	nextval('dirf_titulo_pagar_seq'),
						clock_timestamp(),
						'Tasy',
						clock_timestamp(),
						'Tasy',
						nr_seq_lote_dirf_p,
						c02_w.nr_titulo,
						c02_w.vl_titulo,
						0,
						null,
						c02_w.cd_retencao,
						c02_w.dt_liquidacao,
						'S',
						c01_w.ie_tipo_registro,
						c01_w.cd_operacao_nf
					);

		-- Contador para commit
		qt_registros_w := qt_registros_w + 1;
		if (qt_registros_w > 100) then
			begin
			commit;
			qt_registros_w := 0;
			end;
		end if;
		end;
	end loop;
	close C02;
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_pf_dirf_isento ( nr_seq_lote_dirf_p bigint, cd_empresa_p bigint, cd_estabelecimento_p bigint, dt_mes_referencia_p timestamp) FROM PUBLIC;
