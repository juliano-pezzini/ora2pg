-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_calcular_estrutura_tributo ( nr_seq_tributo_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_centro_custo_w		centro_custo.cd_centro_custo%type;
cd_classif_centro_w		centro_custo.cd_classificacao%type;
cd_classif_w			conta_contabil.cd_classificacao%type;
cd_conta_contabil_w		conta_contabil.cd_conta_contabil%type;
cd_empresa_w			empresa.cd_empresa%type;
ds_termo_w			fis_estrutura_item.ds_origem%type;
ds_origem_w			fis_estrutura_item.ds_origem%type;
ds_valores_w			varchar(8000);
dt_inicial_w			timestamp;
dt_final_w			timestamp;
dt_referencia_w			timestamp;
ie_tipo_centro_w		centro_custo.ie_tipo%type;
ie_tipo_conta_w			conta_contabil.ie_tipo%type;
nr_seq_rubrica_w		fis_estrutura_item.nr_sequencia%type;
nr_pos_inicio_w			integer;
nr_pos_fim_w			integer;
nr_pos_centro_w			integer;
nr_seq_estrut_calc_w		ctb_tributo.nr_seq_estrut_calc%type;
vl_item_w			fis_calculo_estrut.vl_item%type;

c01 CURSOR FOR
SELECT	a.nr_sequencia,
	a.ie_origem_valor,
	a.ds_origem,
	a.ie_gerar_conta
from	fis_estrutura_calculo b,
	fis_estrutura_item a
where	b.nr_sequencia	= a.nr_seq_estrutura
and	b.nr_sequencia	= nr_seq_estrut_calc_w
order by a.nr_seq_apres, a.nr_seq_somat, a.nr_sequencia;

vet01	c01%RowType;

/* opções (ie_origem_valor)
	'S'	- Saldo da conta no mes (tira o encerramento)
	'SC'	- Saldo da conta no mes
	'SR'	- Somatória de rubricas
	'FR'	- Function com rubricas como variáveis
	'M'	- Movimento da conta no mes
	'MA'	- Movimento da conta ate o mes
	'MD'	- Movimento das contas (somente débitos)
	'MC'	- Movimento das contas (somente créditos)
	'MAD'	- Movimento ano até o mês (somente débitos)
	'MAC'	- Movimento ano até o mês (somente créditos)
	'MCSE'        - Movimento das contas (tira encerramento)
	'MASE'        - Movimento ano até o mês (tira encerramento)
	'OM'	- Orçamento do mes
	'OA'	- Orçamento da conta ate o mes
*/
BEGIN

delete	FROM fis_calculo_estrut
where	nr_seq_tributo	= nr_seq_tributo_p;

select	max(nr_seq_estrut_calc)
into STRICT	nr_seq_estrut_calc_w
from	ctb_tributo
where	nr_sequencia	= nr_seq_tributo_p;

open C01;
loop
fetch C01 into
	vet01;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	cd_empresa_w		:= obter_empresa_estab(cd_estabelecimento_p);
	ds_origem_w		:= vet01.ds_origem;
	ds_valores_w		:= vet01.ds_origem;

	select	max(dt_mesano_ref)
	into STRICT	dt_referencia_w
	from	ctb_tributo
	where	nr_sequencia = nr_seq_tributo_p;



	while(ds_origem_w IS NOT NULL AND ds_origem_w::text <> '') loop
		begin
		/*Inicializçaão de variaveis*/

		cd_centro_custo_w	:= null;
		cd_conta_contabil_w	:= '';
		ds_termo_w		:= '';
		nr_seq_rubrica_w	:= null;
		vl_item_w		:= 0;

		/* Obter o termo*/

		nr_pos_inicio_w		:= coalesce(position('#' in ds_origem_w),0);
		nr_pos_fim_w		:= coalesce(position('@' in ds_origem_w),0);
		ds_termo_w		:= substr(ds_origem_w, nr_pos_inicio_w, (nr_pos_fim_w - nr_pos_inicio_w + 1));
		/*Finaliza termo*/

		/* Verifica centro */

		nr_pos_centro_w		:= coalesce(position('$' in ds_termo_w),0);

		/* Decodifica conta/centro */

		if (nr_pos_centro_w > 0) then
			cd_conta_contabil_w	:= substr(ds_termo_w, 2, nr_pos_centro_w - 2);
			cd_centro_custo_w	:= substr(ds_termo_w, nr_pos_centro_w + 1, length(ds_termo_w) - (nr_pos_centro_w + 1));
		else
			cd_conta_contabil_w	:= substr(ds_termo_w, 2, length(ds_termo_w) - 2);
		end if;
		/*Fim decodifica conta/centro*/

		/*Decodifica rubrica*/

		if (substr(ds_termo_w,1,2) = '#R') and (coalesce(position('R@' in ds_termo_w),0) > 0) then
			nr_seq_rubrica_w	:= coalesce(somente_numero(substr(ds_termo_w, 3, position('R@' in ds_termo_w) - 3)),0);
		end if;
		/*Fim Decodifica rubrica*/

		if (coalesce(nr_seq_rubrica_w,0) <> 0) then
			begin

			select	coalesce(vl_item,0)
			into STRICT	vl_item_w
			from	fis_calculo_estrut
			where	nr_seq_tributo	= nr_seq_tributo_p
			and	nr_seq_estrut	= nr_seq_estrut_calc_w
			and	nr_seq_item	= nr_seq_rubrica_w;
			exception when others then
				vl_item_w	:= 0;

			end;

		elsif (cd_conta_contabil_w IS NOT NULL AND cd_conta_contabil_w::text <> '') then

			if (vet01.ie_origem_valor in ('MA','MAC','MAD','MASE', 'OA')) then
				dt_inicial_w	:= trunc(dt_referencia_w,'year');
				dt_final_w	:= dt_referencia_w;
			else
				dt_inicial_w	:= dt_referencia_w;
				dt_final_w	:= dt_referencia_w;
			end if;

			cd_classif_w		:= substr(ctb_obter_classif_conta(cd_conta_contabil_w, null, dt_referencia_w),1,40);
			cd_classif_centro_w	:= '';
			ie_tipo_centro_w	:= '';
			begin
			select	ie_tipo
			into STRICT	ie_tipo_conta_w
			from	conta_contabil
			where	cd_conta_contabil	= cd_conta_contabil_w;
			exception when others then
				ie_tipo_conta_w	:= '';
			end;

			if (coalesce(cd_centro_custo_w,0) <> 0) then
				begin
				select	ie_tipo,
					cd_classificacao
				into STRICT	ie_tipo_centro_w,
					cd_classif_centro_w
				from	centro_custo
				where	cd_centro_custo	= cd_centro_custo_w;
				exception when others then
					ie_tipo_centro_w	:= '';
					cd_classif_centro_w	:= '';
				end;
			end if;

			if (cd_centro_custo_w IS NOT NULL AND cd_centro_custo_w::text <> '') then
				begin
				select	CASE WHEN vet01.ie_origem_valor	='S' THEN 	coalesce(sum(vl_saldo),0) - coalesce(sum(vl_encerramento),0)									 WHEN vet01.ie_origem_valor	='SC' THEN  coalesce(sum(vl_saldo),0)									 WHEN vet01.ie_origem_valor	='M' THEN 	coalesce(sum(vl_movimento),0)									 WHEN vet01.ie_origem_valor	='MA' THEN 	coalesce(sum(vl_movimento),0)									 WHEN vet01.ie_origem_valor	='MD' THEN  coalesce(sum(vl_debito),0)									 WHEN vet01.ie_origem_valor	='MC' THEN  coalesce(sum(vl_credito),0)									 WHEN vet01.ie_origem_valor	='MAD' THEN  coalesce(sum(vl_debito),0)									 WHEN vet01.ie_origem_valor	='MAC' THEN  coalesce(sum(vl_credito),0)									 WHEN vet01.ie_origem_valor	='MASE' THEN  coalesce(sum(vl_movimento),0) - coalesce(sum(vl_encerramento),0)									 WHEN vet01.ie_origem_valor	='MCSE' THEN  coalesce(sum(vl_movimento),0) - coalesce(sum(vl_encerramento),0) END
				into STRICT	vl_item_w
				FROM ctb_mes_ref d, conta_contabil c, ctb_saldo a
LEFT OUTER JOIN centro_custo b ON (a.cd_centro_custo = b.cd_centro_custo)
WHERE a.nr_seq_mes_ref	= d.nr_sequencia and a.cd_conta_contabil	= c.cd_conta_contabil  and a.cd_estabelecimento	= cd_estabelecimento_p and c.cd_empresa		= cd_empresa_w and d.cd_empresa		= cd_empresa_w and d.dt_referencia between dt_inicial_w and dt_final_w and a.cd_conta_contabil	= cd_conta_contabil_w and CASE WHEN ie_tipo_conta_w='A' THEN a.cd_classificacao WHEN ie_tipo_conta_w='T' THEN  a.cd_classif_sup END 	= cd_classif_w and CASE WHEN coalesce(cd_centro_custo_w,0)=0 THEN 'N'  ELSE 'S' END  = substr(ctb_obter_se_centro_sup2(cd_classif_centro_w, b.cd_classificacao),1,1);

				if (vet01.ie_origem_valor = 'OM') or (vet01.ie_origem_valor = 'OA') then

					select	coalesce(sum(vl_orcado),0)
					into STRICT	vl_item_w
					from	conta_contabil c,
						centro_custo b,
						ctb_orcamento a,
						ctb_mes_ref d
					where	a.nr_seq_mes_ref	= d.nr_sequencia
					and	a.cd_centro_custo	= b.cd_centro_custo
					and	a.cd_conta_contabil	= c.cd_conta_contabil
					and	cd_estabelecimento_p	= a.cd_estabelecimento
					and	c.cd_empresa		= cd_empresa_w
					and	d.cd_empresa		= cd_empresa_w
					and	a.cd_conta_contabil 	= cd_conta_contabil_w
					and	a.cd_centro_custo	= cd_centro_custo_w
					and	d.dt_referencia between dt_inicial_w and dt_final_w;

				end if;
				end;
			elsif (coalesce(cd_centro_custo_w::text, '') = '') then
				begin


				select	CASE WHEN vet01.ie_origem_valor	='S' THEN 	coalesce(sum(vl_saldo),0) - coalesce(sum(vl_encerramento),0)									 WHEN vet01.ie_origem_valor	='SC' THEN  coalesce(sum(vl_saldo),0)									 WHEN vet01.ie_origem_valor	='M' THEN 	coalesce(sum(vl_movimento),0)									 WHEN vet01.ie_origem_valor	='MA' THEN 	coalesce(sum(vl_movimento),0)									 WHEN vet01.ie_origem_valor	='MD' THEN  coalesce(sum(vl_debito),0)									 WHEN vet01.ie_origem_valor	='MC' THEN  coalesce(sum(vl_credito),0)									 WHEN vet01.ie_origem_valor	='MAD' THEN  coalesce(sum(vl_debito),0)									 WHEN vet01.ie_origem_valor	='MAC' THEN  coalesce(sum(vl_credito),0)									 WHEN vet01.ie_origem_valor	='MASE' THEN  coalesce(sum(vl_movimento),0) - coalesce(sum(vl_encerramento),0)									 WHEN vet01.ie_origem_valor	='MCSE' THEN  coalesce(sum(vl_movimento),0) - coalesce(sum(vl_encerramento),0) END
				into STRICT	vl_item_w
				from	conta_contabil c,
					ctb_saldo a,
					ctb_mes_ref d
				where	a.nr_seq_mes_ref	= d.nr_sequencia
				and	a.cd_conta_contabil	= c.cd_conta_contabil
				and	a.cd_estabelecimento	= cd_estabelecimento_p
				and	c.cd_empresa		= cd_empresa_w
				and	d.cd_empresa		= cd_empresa_w
				and	a.cd_conta_contabil	= cd_conta_contabil_w
				and	CASE WHEN ie_tipo_conta_w='A' THEN a.cd_classificacao WHEN ie_tipo_conta_w='T' THEN  a.cd_classif_sup END 	= cd_classif_w
				and	d.dt_referencia between dt_inicial_w and dt_final_w;

				if (vet01.ie_origem_valor = 'OM') or (vet01.ie_origem_valor = 'OA') then

					select	sum(vl_orcado)
					into STRICT	vl_item_w
					from	conta_contabil c,
						ctb_orcamento a,
						ctb_mes_ref d
					where	a.nr_seq_mes_ref	= d.nr_sequencia
					and	a.cd_conta_contabil	= c.cd_conta_contabil
					and	cd_estabelecimento_p	= a.cd_estabelecimento
					and	c.cd_empresa		= cd_empresa_w
					and	d.cd_empresa		= cd_empresa_w
					and	a.cd_conta_contabil 	= cd_conta_contabil_w
					and	d.dt_referencia between dt_inicial_w and dt_final_w;


				end if;
				end;
			end if;

			/* Caso possua Conta contábil e a opção ie_gerar_conta esteja marcada, realizar insert com o valor da mesma.*/

			if (coalesce(vet01.ie_gerar_conta,'N') = 'S') then




				insert into fis_calculo_estrut(
					nr_sequencia,
					nr_seq_estrut,
					nr_seq_item,
					nr_seq_tributo,
					vl_item,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					cd_conta_contabil,
					ds_origem)
				values (	nextval('fis_calculo_estrut_seq'),
					nr_seq_estrut_calc_w,
					vet01.nr_sequencia,
					nr_seq_tributo_p,
					vl_item_w,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					cd_conta_contabil_w,
					vet01.ds_origem);
			end if;
		end if;
		vl_item_w	:= coalesce(vl_item_w,0);


		if (nr_pos_inicio_w > 0) and (nr_pos_fim_w > 0) then
			ds_valores_w	:= substr(replace(ds_valores_w,ds_termo_w,replace(replace(vl_item_w,'.',''),',','.')),1,8000);
		end if;

		if (nr_pos_fim_w = 0) then
			ds_origem_w	:= null;
		else
			ds_origem_w	:= substr(ds_origem_w,nr_pos_fim_w+1,4000);
		end if;

		end;
	end loop;



	if (ds_valores_w IS NOT NULL AND ds_valores_w::text <> '') then
		vl_item_w := obter_valor_dinamico('select ' || ds_valores_w || ' from dual', vl_item_w);
	end if;



	insert into fis_calculo_estrut(
		nr_sequencia,
		nr_seq_estrut,
		nr_seq_item,
		nr_seq_tributo,
		vl_item,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec)
	values (	nextval('fis_calculo_estrut_seq'),
		nr_seq_estrut_calc_w,
		vet01.nr_sequencia,
		nr_seq_tributo_p,
		coalesce(vl_item_w,0),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p);
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_calcular_estrutura_tributo ( nr_seq_tributo_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
