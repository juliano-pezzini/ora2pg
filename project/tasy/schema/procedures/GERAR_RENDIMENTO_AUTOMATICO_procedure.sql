-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_rendimento_automatico (dt_rendimento_p timestamp) AS $body$
DECLARE


cd_estabelecimento_w		smallint;
tx_rendimento_w			conta_banco_tipo_aplic.vl_taxa_rend%type;
vl_rendimento_w			double precision;
vl_rendimento_estrang_w		double precision;
vl_complemento_w		double precision;
vl_cotacao_w			cotacao_moeda.vl_cotacao%type;
cd_moeda_w			integer;
nr_seq_aplicacao_w		bigint;
nr_seq_trans_fin_w		bigint;
vl_aplicacao_w			double precision;
nm_usuario_w			varchar(15);
nr_seq_conta_bco_aplic_w	bigint;
vl_aplicacao_estrang_w		double precision;
ie_cancela_rend_w		varchar(1);
nr_seq_saldo_bco_w		bigint;
dt_referencia_w			timestamp;
ie_saldo_fechado_w		varchar(1);
nr_seq_rendimento_w		bigint;
dt_rendimento_w			timestamp;

c01 CURSOR FOR 	SELECT	a.nr_sequencia,
			a.cd_estabelecimento,
			obter_total_aplicacao(a.nr_sequencia) vl_aplicacao,
			obter_dt_prox_rendimento(a.nr_sequencia) dt_rendimento,
			a.cd_moeda,
			a.nm_usuario,
			c.nr_seq_trans_fin_rend,
			a.nr_seq_conta_bco_aplic,
			a.vl_aplicacao_estrang,
			a.vl_cotacao
		from	banco_aplicacao a,
			banco_estabelecimento b,
			conta_banco_tipo_aplic c
		where	a.nr_seq_conta_bco_aplic = b.nr_sequencia
		and	a.nr_seq_aplicacao = c.nr_sequencia
		and	coalesce(a.ie_estorno,'N') = 'N'  -- aplicacoes nao estornadas
		and	b.ie_situacao = 'A'  -- Somente contas ativas
		and	c.ie_forma_lancamento = 'A'  -- Automatico
		and	trunc(obter_dt_prox_rendimento(a.nr_sequencia),'dd') = trunc(coalesce(dt_rendimento_p,clock_timestamp()),'dd')
		and	obter_total_aplicacao(a.nr_sequencia) > 0;  -- Aplicacao com saldo
BEGIN
ie_cancela_rend_w := 'N';

open c01;
loop
fetch c01 into
	nr_seq_aplicacao_w,
	cd_estabelecimento_w,
	vl_aplicacao_w,
	dt_rendimento_w,
	cd_moeda_w,
	nm_usuario_w,
	nr_seq_trans_fin_w,
	nr_seq_conta_bco_aplic_w,
	vl_aplicacao_estrang_w,
	vl_cotacao_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	
	select calc_taxa_rend_aplicacao(nr_seq_aplicacao_w,dt_rendimento_w,cd_estabelecimento_w)
	into STRICT tx_rendimento_w
	;

	-- Verifica saldo aberto da conta
	select	max(nr_sequencia),
		max(dt_referencia)
	into STRICT	nr_seq_saldo_bco_w,
		dt_referencia_w
	from	banco_saldo
	where	nr_seq_conta = nr_seq_conta_bco_aplic_w
	and	trunc(dt_referencia,'month') = trunc(dt_rendimento_w,'month')
	and	coalesce(dt_fechamento::text, '') = '';

	if (coalesce(nr_seq_saldo_bco_w::text, '') = '') then
		ie_cancela_rend_w := 'S';
	end if;
	select	obter_se_banco_fechado(nr_seq_conta_bco_aplic_w,dt_referencia_w)
	into STRICT	ie_saldo_fechado_w
	;
	if (coalesce(ie_saldo_fechado_w,'N') = 'S') then
		ie_cancela_rend_w := 'S';
	end if;
	
	-- Valida campos obrigatorios
	if (coalesce(cd_estabelecimento_w::text, '') = '' or coalesce(vl_aplicacao_w,0) <= 0
		or coalesce(nm_usuario_w::text, '') = '' or coalesce(tx_rendimento_w,0) <= 0
		or coalesce(nr_seq_trans_fin_w::text, '') = '') then
		
		ie_cancela_rend_w := 'S';
	end if;
	
	if (coalesce(ie_cancela_rend_w,'N') = 'N') then
		if (coalesce(vl_aplicacao_estrang_w,0) <> 0 and coalesce(vl_cotacao_w,0) > 0 and (cd_moeda_w IS NOT NULL AND cd_moeda_w::text <> '')) then
			select	max(vl_cotacao)
			into STRICT	vl_cotacao_w
			from	cotacao_moeda
			where	cd_moeda = cd_moeda_w
			and	dt_cotacao = 	(SELECT	max(dt_cotacao)
						from	cotacao_moeda
						where	cd_moeda = cd_moeda_w
						and	trunc(dt_cotacao) <= trunc(dt_rendimento_w));
			if (coalesce(vl_cotacao_w,0) = 0) then
				vl_cotacao_w := 1;
			end if;
			
			vl_rendimento_estrang_w := (vl_aplicacao_w * tx_rendimento_w) / 100;
			vl_rendimento_w := vl_rendimento_estrang_w * vl_cotacao_w;
			vl_complemento_w := vl_rendimento_w - vl_rendimento_estrang_w;
		else
			vl_rendimento_estrang_w := null;
			vl_complemento_w := null;
			vl_cotacao_w := null;
			
			vl_rendimento_w := (vl_aplicacao_w * tx_rendimento_w) / 100;
		end if;
		
		begin
			select	nextval('banco_rendimento_seq')
			into STRICT	nr_seq_rendimento_w
			;
			
			insert into banco_rendimento(
				nr_sequencia,
				nr_seq_aplicacao,
				nr_seq_trans_fin_rend,
				cd_estabelecimento,
				dt_rendimento,
				vl_taxa_rendimento,
				cd_moeda,
				vl_rendimento,
				vl_rendimento_estrang,
				vl_complemento,
				vl_cotacao,
				dt_atualizacao,
				nm_usuario)
			values (nr_seq_rendimento_w,
				nr_seq_aplicacao_w,
				nr_seq_trans_fin_w,
				cd_estabelecimento_w,
				dt_rendimento_w,
				tx_rendimento_w,
				cd_moeda_w,
				vl_rendimento_w,
				vl_rendimento_estrang_w,
				vl_complemento_w,
				vl_cotacao_w,
				clock_timestamp(),
				nm_usuario_w);
			
			CALL gerar_transacao_rendimento(nr_seq_rendimento_w,'I',nm_usuario_w);
			
		exception when others then
			null;
		end;
	end if;
	
	vl_rendimento_estrang_w := null;
	vl_complemento_w := null;
	vl_cotacao_w := null;
	vl_rendimento_w := null;
	ie_cancela_rend_w := 'N';
	nr_seq_saldo_bco_w := null;
	dt_referencia_w := null;
	ie_saldo_fechado_w := null;
	dt_rendimento_w := null;
	
	exception when others then
		null;
	end;
end loop;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_rendimento_automatico (dt_rendimento_p timestamp) FROM PUBLIC;

