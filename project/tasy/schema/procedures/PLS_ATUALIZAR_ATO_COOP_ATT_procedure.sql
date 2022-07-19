-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE lotes_pagamentos_c AS (	nr_sequencia		bigint);
CREATE TYPE contas_pagamento_c AS (	nr_sequencia		bigint);


CREATE OR REPLACE PROCEDURE pls_atualizar_ato_coop_att ( nr_seq_atualizacao_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ ] Objetos do dicionário [ ] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção: 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
 
cd_tipo_lote_contabil_w			pls_atualizacao_contabil.cd_tipo_lote_contabil%type;
nr_seq_lote_pagamento_w			pls_lote_pagamento.nr_sequencia%type;
ds_erro_w				varchar(255);
nr_seq_movimento_w			bigint;
nr_vetor_w				bigint	:= 0;
w2					bigint	:= 0;
dt_referencia_w				timestamp;
dt_ref_inicial_w			timestamp;
dt_ref_final_w				timestamp;

C01 CURSOR FOR 
	SELECT	a.nr_sequencia nr_seq_movimento 
	from	pls_movimento_contabil a 
	where	a.nr_seq_atualizacao	= nr_seq_atualizacao_p 
	and	exists (	SELECT	1 
				from	pls_movto_contab_inconsist x 
				where	x.nr_seq_movimento = a.nr_sequencia 
				and	x.nr_seq_inconsistencia = 2);
				
TYPE 		fetch_array IS TABLE OF C01%ROWTYPE;
s_array 	fetch_array;
w		integer := 1;
type Vetor is table of fetch_array index by integer;
vetor_w		Vetor;
				
c_mensalidades CURSOR FOR 
	SELECT	a.nr_seq_protocolo 
	from	pls_conta	a 
	where	exists (SELECT	1 
			from	pls_mensalidade_seg_item	x, 
				pls_mensalidade_segurado	y, 
				pls_mensalidade			w, 
				pls_lote_mensalidade		z 
			where	y.nr_sequencia	= x.nr_seq_mensalidade_seg 
			and	w.nr_sequencia	= y.nr_seq_mensalidade 
			and	z.nr_sequencia	= w.nr_seq_lote 
			and	a.nr_sequencia	= x.nr_seq_conta 
			and	z.dt_mesano_referencia between dt_ref_inicial_w and dt_ref_final_w) 
	group by 
		a.nr_seq_protocolo;
	
c_contas_reembolso CURSOR FOR 
	SELECT	a.nr_sequencia nr_seq_protocolo 
	from	pls_protocolo_conta	a 
	where	a.dt_mes_competencia between dt_ref_inicial_w and dt_ref_final_w 
	and	a.ie_tipo_protocolo	= 'R';
	
c_contas_intercambio CURSOR FOR 
	SELECT	a.nr_sequencia nr_seq_protocolo 
	from	pls_protocolo_conta	a 
	where	a.dt_mes_competencia between dt_ref_inicial_w and dt_ref_final_w 
	and	a.ie_status in ('2','3','4','5','6') 
	and	a.ie_situacao not in ('I','RE','A') 
	and	coalesce(a.ie_tipo_protocolo,'C')	= 'I' 
	and	not exists (SELECT 1 
				from	pls_conta		b, 
					ptu_fatura		c 
				where	c.nr_sequencia	= b.nr_seq_fatura 
				and	a.nr_sequencia	= b.nr_seq_protocolo) 
	
union
 
	select	a.nr_sequencia nr_seq_protocolo 
	from	pls_protocolo_conta	a 
	where	a.ie_status in ('2','3','4','5','6') 
	and	a.ie_situacao not in ('I','RE','A') 
	and	coalesce(a.ie_tipo_protocolo,'C')	= 'I' 
	and	a.nr_sequencia in (select	b.nr_seq_protocolo 
					from	pls_conta		b, 
						ptu_fatura		c 
					where	c.nr_sequencia	= b.nr_seq_fatura 
					and	c.dt_mes_competencia between dt_ref_inicial_w and dt_ref_final_w);
					
c_discussao CURSOR FOR	 
	SELECT	a.nr_seq_protocolo 
	from	pls_conta	a 
	where	exists (SELECT	1 
			from	pls_lote_contestacao	x, 
				pls_lote_discussao	y, 
				pls_contestacao		w 
			where 	y.ie_status	= 'F' 
			and	y.dt_fechamento between dt_ref_inicial_w and dt_ref_final_w 
			and	x.nr_sequencia		= y.nr_seq_lote_contest 
			and	x.nr_sequencia		= w.nr_seq_lote 
			and	a.nr_sequencia		= w.nr_seq_conta 
			and	x.cd_estabelecimento	= cd_estabelecimento_p) 
	group by 
		a.nr_seq_protocolo;
		
c_contas_prov_fat CURSOR FOR 
	SELECT	b.nr_seq_protocolo 
	from	pls_conta		b, 
		pls_protocolo_conta	a 
	where	a.nr_sequencia		= b.nr_seq_protocolo 
	and	a.dt_mes_competencia between dt_ref_inicial_w and dt_ref_final_w 
	and	not exists (SELECT 1 
				from	ptu_fatura		c 
				where	c.nr_sequencia	= b.nr_seq_fatura) 
	
union
 
	select	a.nr_seq_protocolo 
	from	pls_conta		a, 
		pls_protocolo_conta	b 
	where	a.nr_seq_protocolo	= b.nr_sequencia 
	and	a.nr_seq_fatura in (select c.nr_sequencia 
					from	ptu_fatura		c 
					where	c.dt_mes_competencia between dt_ref_inicial_w and dt_ref_final_w);
					
c_contas_faturamento CURSOR FOR 
	SELECT	e.nr_seq_protocolo 
	from	pls_conta		e, 
		pls_fatura_conta	d, 
		pls_fatura_evento	c, 
		pls_fatura		b, 
		pls_lote_faturamento	a 
	where	a.nr_sequencia	= b.nr_seq_lote 
	and	e.nr_sequencia	= d.nr_seq_conta 
	and	c.nr_sequencia	= d.nr_seq_fatura_evento 
	and	b.nr_sequencia	= c.nr_seq_fatura 
	and	coalesce(b.nr_seq_cancel_fat::text, '') = '' 
	and	b.dt_mes_competencia between dt_ref_inicial_w and dt_ref_final_w 
	group by e.nr_seq_protocolo 
	
union
 
	SELECT	e.nr_seq_protocolo 
	from	pls_conta		e, 
		pls_fatura_conta	d, 
		pls_fatura_evento	c, 
		pls_fatura		b, 
		pls_lote_faturamento	a 
	where	a.nr_sequencia	= b.nr_seq_lote 
	and	e.nr_sequencia	= d.nr_seq_conta 
	and	c.nr_sequencia	= d.nr_seq_fatura_evento 
	and	b.nr_sequencia	= c.nr_seq_fatura 
	and	coalesce(b.nr_seq_cancel_fat::text, '') = '' 
	and	a.dt_mesano_referencia between dt_ref_inicial_w and dt_ref_final_w 
	group by e.nr_seq_protocolo;
	
c_contas_pag_provisao CURSOR FOR 
	SELECT	a.nr_seq_protocolo 
	from	pls_conta		a, 
		pls_protocolo_conta	b 
	where	a.nr_seq_protocolo	= b.nr_sequencia 
	and	b.dt_mes_competencia between dt_ref_inicial_w and dt_ref_final_w 
	and	coalesce(b.ie_tipo_protocolo,'C')	= 'C' 
	and	b.ie_situacao not in ('I','RE','A') 
	and	not exists (SELECT 1 
				from	ptu_fatura		c 
				where	c.nr_sequencia	= a.nr_seq_fatura) 
	group by a.nr_seq_protocolo 
	
union
 
	select	a.nr_seq_protocolo 
	from	pls_conta		a, 
		pls_protocolo_conta	b 
	where	a.nr_seq_protocolo	= b.nr_sequencia 
	and	coalesce(b.ie_tipo_protocolo,'C')	= 'C' 
	and	b.ie_situacao not in ('I','RE','A') 
	and	a.nr_seq_fatura in (select c.nr_sequencia 
					from	ptu_fatura		c 
					where	c.dt_mes_competencia between dt_ref_inicial_w and dt_ref_final_w) 
	group by a.nr_seq_protocolo;
	
c_lote_pagamento CURSOR FOR 
	SELECT	nr_sequencia 
	from	pls_lote_pagamento 
	where	dt_mes_competencia between dt_ref_inicial_w and dt_ref_final_w;

type vetor_lotes_pagamentos_c is table of lotes_pagamentos_c index by integer;
vetor_lotes_pagamentos_w	vetor_lotes_pagamentos_c;

c_contas_pagamento CURSOR FOR 
	SELECT	b.nr_seq_protocolo 
	from	pls_conta_medica_resumo	a, 
		pls_conta		b 
	where	b.nr_sequencia		= a.nr_seq_conta 
	and	a.nr_seq_lote_pgto	= nr_seq_lote_pagamento_w 
	group by b.nr_seq_protocolo;

type vetor_contas_pagamento_c is table of contas_pagamento_c index by integer;
vetor_contas_pagamento_w	vetor_contas_pagamento_c;

type 		fetch_array2 is table of c_contas_pagamento%rowtype;
s_array2 	fetch_array2;
i2		integer	:= 1;
type vetor2 is table of fetch_array2 index by integer;
vetor_contas_w	vetor2;
	
c_mensalidades_w		c_mensalidades%rowtype;
c_contas_reembolso_w		c_contas_reembolso%rowtype;
c_contas_intercambio_w		c_contas_intercambio%rowtype;
c_discussao_w			c_discussao%rowtype;
c_contas_prov_fat_w		c_contas_prov_fat%rowtype;
c_contas_faturamento_w		c_contas_faturamento%rowtype;
c_contas_pag_provisao_w		c_contas_pag_provisao%rowtype;

BEGIN 
select	trunc(dt_mes_competencia,'month'), 
	cd_tipo_lote_contabil 
into STRICT	dt_referencia_w, 
	cd_tipo_lote_contabil_w 
from	pls_atualizacao_contabil 
where	nr_sequencia	= nr_seq_atualizacao_p;
 
dt_ref_inicial_w	:= dt_referencia_w;
dt_ref_final_w		:= fim_dia(fim_mes(dt_referencia_w));
 
if (cd_tipo_lote_contabil_w = 21) then /* OPS Receitas - Mensalidades */
 
	open C01;
	loop 
	fetch C01 into	 
		c_mensalidades_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		ds_erro_w := pls_atualizar_ato_coop_prot(	c_mensalidades_w.nr_seq_protocolo, dt_referencia_w, nm_usuario_p, cd_estabelecimento_p, ds_erro_w);
		 
		commit;
		end;
	end loop;
	close C01;
elsif (cd_tipo_lote_contabil_w = 23) then /* OPS Despesas - Reembolso */
 
	open c_contas_reembolso;
	loop 
	fetch c_contas_reembolso into 
		c_contas_reembolso_w;
	EXIT WHEN NOT FOUND; /* apply on c_contas_reembolso */
		begin 
		ds_erro_w := pls_atualizar_ato_coop_prot(	c_contas_reembolso_w.nr_seq_protocolo, dt_referencia_w, nm_usuario_p, cd_estabelecimento_p, ds_erro_w);
		 
		commit;
		end;
	end loop;
	close c_contas_reembolso;
elsif (cd_tipo_lote_contabil_w = 33) then /* OPS Despesas - Contas Intercâmbio */
 
	open c_contas_intercambio;
	loop 
	fetch c_contas_intercambio into 
		c_contas_intercambio_w;
	EXIT WHEN NOT FOUND; /* apply on c_contas_intercambio */
		begin 
		ds_erro_w := pls_atualizar_ato_coop_prot(	c_contas_intercambio_w.nr_seq_protocolo, dt_referencia_w, nm_usuario_p, cd_estabelecimento_p, ds_erro_w);
		 
		commit;
		end;
	end loop;
	close c_contas_intercambio;
elsif (cd_tipo_lote_contabil_w = 38) then /* OPS - Discussão de glosas */
 
	open c_discussao;
	loop 
	fetch c_discussao into 
		c_discussao_w;
	EXIT WHEN NOT FOUND; /* apply on c_discussao */
		begin 
		ds_erro_w := pls_atualizar_ato_coop_prot(	c_discussao_w.nr_seq_protocolo, dt_referencia_w, nm_usuario_p, cd_estabelecimento_p, ds_erro_w);			
		 
		commit;
		end;
	end loop;
	close c_discussao;
elsif (cd_tipo_lote_contabil_w = 40) then /* OPS Despesas-Provisão de produção médica */
 
	open c_contas_pag_provisao;
	loop 
	fetch c_contas_pag_provisao into 
		c_contas_pag_provisao_w;
	EXIT WHEN NOT FOUND; /* apply on c_contas_pag_provisao */
		begin 
		ds_erro_w := pls_atualizar_ato_coop_prot(	c_contas_pag_provisao_w.nr_seq_protocolo, dt_referencia_w, nm_usuario_p, cd_estabelecimento_p, ds_erro_w);			
		 
		commit;
		end;
	end loop;
	close c_contas_pag_provisao;
elsif (cd_tipo_lote_contabil_w = 41) then /* OPS Desp - Pagamento de produção médica */
 
	nr_vetor_w	:= 0;
	w2		:= 0;
	 
	open c_lote_pagamento;
	loop 
	fetch c_lote_pagamento into 
		nr_seq_lote_pagamento_w;
	EXIT WHEN NOT FOUND; /* apply on c_lote_pagamento */
		begin 
		nr_vetor_w						:= nr_vetor_w + 1;
		vetor_lotes_pagamentos_w[nr_vetor_w].nr_sequencia	:= nr_seq_lote_pagamento_w;
		end;
	end loop;
	close c_lote_pagamento;
	 
	nr_vetor_w	:= 0;
	w2		:= 0;
	 
	for w2 in 1..vetor_lotes_pagamentos_w.count loop 
		begin 
		nr_seq_lote_pagamento_w	:= vetor_lotes_pagamentos_w[w2].nr_sequencia;
		 
		/* Contas do lote de pagamento */
 
		open c_contas_pagamento;
		loop 
		fetch c_contas_pagamento bulk collect into s_array2 limit 1000;
			vetor_contas_w(i2)	:= s_array2;
			i2			:= i2 + 1;
		EXIT WHEN NOT FOUND; /* apply on c_contas_pagamento */
		end loop;
		close c_contas_pagamento;
		end;
	end loop;
	 
	for i2 in 1..vetor_contas_w.count loop 
		begin 
		s_array2 := vetor_contas_w(i2);
		for z in 1..s_array2.count loop 
			begin 
			nr_vetor_w						:= nr_vetor_w + 1;
			vetor_contas_pagamento_w[nr_vetor_w].nr_sequencia	:= s_array2[z].nr_seq_protocolo;
			end;
		end loop;
		end;
	end loop;
	 
	for w2 in 1..vetor_contas_pagamento_w.count loop 
		begin 
		ds_erro_w := pls_atualizar_ato_coop_prot(	vetor_contas_pagamento_w[w2].nr_sequencia, dt_referencia_w, nm_usuario_p, cd_estabelecimento_p, ds_erro_w);			
		 
		commit;
		end;
	end loop;
elsif (cd_tipo_lote_contabil_w = 43) then /* OPS - Provisão de Faturamento */
 
	open c_contas_prov_fat;
	loop 
	fetch c_contas_prov_fat into 
		c_contas_prov_fat_w;
	EXIT WHEN NOT FOUND; /* apply on c_contas_prov_fat */
		begin 
		ds_erro_w := pls_atualizar_ato_coop_prot(	c_contas_prov_fat_w.nr_seq_protocolo, dt_referencia_w, nm_usuario_p, cd_estabelecimento_p, ds_erro_w);
		 
		commit;
		end;
	end loop;
	close c_contas_prov_fat;
elsif (cd_tipo_lote_contabil_w = 44) then /* OPS - Receitas com Faturamento */
 
	open c_contas_faturamento;
	loop 
	fetch c_contas_faturamento into 
		c_contas_faturamento_w;
	EXIT WHEN NOT FOUND; /* apply on c_contas_faturamento */
		begin 
		ds_erro_w := pls_atualizar_ato_coop_prot(	c_contas_faturamento_w.nr_seq_protocolo, dt_referencia_w, nm_usuario_p, cd_estabelecimento_p, ds_erro_w);
		 
		commit;
		end;
	end loop;
	close c_contas_faturamento;
end if;
 
if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then 
	CALL wheb_mensagem_pck.exibir_mensagem_abort( 218177, 'DS_ERRO=' || ds_erro_w );
end if;
 
open C01;
loop 
FETCH C01 BULK COLLECT INTO s_array LIMIT 400;
	Vetor_w(w)	:= s_array;
	w		:= w + 1;
EXIT WHEN NOT FOUND; /* apply on C01 */
END LOOP;
CLOSE C01;
 
for k in 1..Vetor_w.COUNT loop 
	s_array	:= Vetor_w(k);
	for z in 1..s_array.COUNT loop 
		begin 
		nr_seq_movimento_w	:= s_array[z].nr_seq_movimento;
		 
		CALL pls_atualizar_contas_item(	nr_seq_movimento_w, 
						nm_usuario_p, 
						cd_estabelecimento_p);
		end;
	end loop;
end loop;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_ato_coop_att ( nr_seq_atualizacao_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

