-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualizar_conta_contabil ( dt_referencia_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint, ie_opcao_p text, ie_geracao_p INOUT text) AS $body$
DECLARE


/* ie_opcao_p
	C = Contas medicas
	V = Vendedor repasse
	R = Reembolso
	M = Mensalidade
	S = Ressarcimento
	P = PPSC
	E = PEONA
	F = Eventos e Ocorrencias Financeiras
	FA = Faturamento
	TPPM = Tributo pagamento de producao medica,
	CM = Comissao de venda
*/
nr_seq_protocolo_w		bigint;
nr_seq_repasse_w		bigint;
nr_seq_lote_w			bigint;
nr_seq_processo_w		bigint;
nr_seq_lote_ppsc_w		bigint;
ie_esquema_contabil_w		varchar(1);
nr_seq_peona_w			bigint;
ie_provisao_producao_w		varchar(1);
dt_referencia_month_w		timestamp;
nr_seq_conta_w			bigint;
nr_seq_lote_evento_w		bigint;
nr_seq_conta_faturamento_w	bigint;
nr_seq_fatura_w			bigint;
qt_lote_gerado_mes_w		bigint;
nr_seq_lote_pagamento_w		bigint;
qt_contas_commit_w		bigint;
qt_vago_w			bigint	:= 0;
qt_movimento_w			bigint := 0;
nr_seq_lote_cancel_w		pls_cancel_rec_fatura.nr_seq_lote%type;
nr_seq_lote_comissao_w		pls_lote_comissao.nr_sequencia%type;
dt_referencia_fm_w		timestamp;
ie_contab_ppcng_w		pls_parametro_contabil.ie_contab_ppcng%type;
ie_performance_contab_w		pls_visible_false.ie_performance_contab%type;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_protocolo_conta
	where	trunc(dt_mes_competencia,'month') = dt_referencia_month_w
	and	ie_status in ('3','4','5','6')
	and	ie_situacao not in ('I','RE','A')
	and	ie_tipo_protocolo	= 'C';

C02 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_repasse_vend
	where	trunc(dt_referencia,'month') = dt_referencia_month_w;

C03 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_protocolo_conta
	where	trunc(dt_mes_competencia,'month') = dt_referencia_month_w
	and	ie_tipo_protocolo	= 'R';
	
C04 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_lote_mensalidade
	where (trunc(dt_mesano_referencia,'month') = dt_referencia_month_w
	or	trunc(dt_contabilizacao,'month') = dt_referencia_month_w)
	and	cd_estabelecimento = cd_estabelecimento_p;

C05 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_processo
	where	trunc(dt_processo,'month')	= dt_referencia_month_w;

C06 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_ppsc_lote
	where	trunc(dt_lote,'month')	= dt_referencia_month_w;

C07 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_peona
	where	trunc(dt_competencia,'month')	= dt_referencia_month_w;
	
C08 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_protocolo_conta
	where	trunc(dt_mes_competencia,'month') = dt_referencia_month_w
	and	ie_status in ('2','3','4','5','6')
	and	ie_situacao not in ('I','RE','A')
	and	coalesce(ie_tipo_protocolo,'C')	= 'I';

C09 CURSOR FOR
	SELECT	a.nr_sequencia
	from	pls_conta		a,
		pls_protocolo_conta	b
	where	a.nr_seq_protocolo	= b.nr_sequencia
	and	trunc(b.dt_mes_competencia,'month') = dt_referencia_month_w
	and	coalesce(b.ie_tipo_protocolo,'C')	= 'C';

C10 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_lote_evento
	where	trunc(dt_competencia,'month') = dt_referencia_month_w
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');

C11 CURSOR FOR
	SELECT	a.nr_sequencia
	from	pls_conta		a,
		pls_protocolo_conta	b
	where	a.nr_seq_protocolo	= b.nr_sequencia
	and	trunc(b.dt_mes_competencia,'month') = dt_referencia_month_w;

C12 CURSOR FOR
	SELECT	b.nr_sequencia
	from	pls_fatura		b,
		pls_lote_faturamento	a
	where	b.nr_seq_lote		= a.nr_sequencia
	and	trunc(coalesce(b.dt_mes_competencia,a.dt_mesano_referencia),'month') = dt_referencia_month_w;

C13 CURSOR FOR
	SELECT	a.nr_sequencia
	from	pls_conta		a,
		pls_protocolo_conta	b
	where	a.nr_seq_protocolo	= b.nr_sequencia
	and	trunc(b.dt_mes_competencia,'month') = dt_referencia_month_w
	and	coalesce(ie_tipo_protocolo,'C')	= 'R';

C14 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_lote_pagamento
	where	trunc(dt_mes_competencia,'month') = dt_referencia_month_w;

c_cancelamento_faturamento CURSOR FOR
	SELECT	a.nr_sequencia
	from	pls_cancel_rec_fat_lote		a,
		pls_cancel_rec_fatura		c
	where	a.nr_sequencia	= c.nr_seq_lote
	and	a.dt_referencia between dt_referencia_month_w and dt_referencia_fm_w;

c_lote_comissao CURSOR FOR
	SELECT	a.nr_sequencia
	from	pls_lote_comissao	a
	where	a.dt_referencia between dt_referencia_month_w and dt_referencia_fm_w;
	

BEGIN
dt_referencia_month_w	:= trunc(dt_referencia_p,'month');
dt_referencia_fm_w	:= fim_dia(fim_mes(dt_referencia_month_w));	

select	coalesce(max(ie_performance_contab), 'N')
into STRICT	ie_performance_contab_w
from	pls_visible_false
where	cd_estabelecimento = cd_estabelecimento_p;

begin
select	coalesce(ie_esquema_contabil,'N'),
	coalesce(ie_provisao_producao,'N'),
	coalesce(ie_contab_ppcng,'N')
into STRICT	ie_esquema_contabil_w,
	ie_provisao_producao_w,
	ie_contab_ppcng_w
from	pls_parametro_contabil
where	cd_estabelecimento	= cd_estabelecimento_p;
exception
when others then
	ie_esquema_contabil_w	:= 'N';
	ie_provisao_producao_w	:= 'N';
	ie_contab_ppcng_w	:= 'N';
end;

CALL pls_atualizar_codificacao_pck.pls_atualizar_codificacao(dt_referencia_month_w);

if (ie_opcao_p = 'C') then
	if (coalesce(ie_provisao_producao_w,'N') = 'S') then
		qt_contas_commit_w	:= 0;
		open C09;
		loop
		fetch C09 into
			nr_seq_conta_w;
		EXIT WHEN NOT FOUND; /* apply on C09 */
			begin
			
			qt_contas_commit_w	:= qt_contas_commit_w + 1;
			
			qt_vago_w := ctb_pls_atualizar_prov_prod_in(nr_seq_conta_w, null, null, null, nm_usuario_p, cd_estabelecimento_p, qt_vago_w);
			qt_vago_w := ctb_pls_atualizar_prod_med_in(nr_seq_conta_w, null, null, null, nm_usuario_p, cd_estabelecimento_p, qt_vago_w);
			/*ctb_pls_atualizar_prod_med_res(	nr_seq_conta_w,
							null,
							null,
							null,
							nm_usuario_p,
							cd_estabelecimento_p,
							qt_vago_w);*/
			
			if (qt_contas_commit_w = 1000) then
				qt_contas_commit_w	:= 0;
				commit;
			end if;
			
			end;
		end loop;
		close C09;
		
		if (ie_esquema_contabil_w = 'S') then
			open C01;
			loop
			fetch C01 into
				nr_seq_protocolo_w;
			EXIT WHEN NOT FOUND; /* apply on C01 */
				begin
				qt_vago_w := ctb_pls_atualizar_desp_interc(nr_seq_protocolo_w, null, null, null, null, nm_usuario_p, cd_estabelecimento_p, qt_vago_w);
				end;
			end loop;
			close C01;
		end if;
		
		open C11;
		loop
		fetch C11 into
			nr_seq_conta_faturamento_w;
		EXIT WHEN NOT FOUND; /* apply on C11 */
			begin
			qt_vago_w := ctb_pls_atualizar_prov_fat(nr_seq_conta_faturamento_w, null, null, null, nm_usuario_p, cd_estabelecimento_p, qt_vago_w);
			end;
		end loop;
		close C11;
		
	else
		open C01;
		loop
		fetch C01 into
			nr_seq_protocolo_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			if (ie_esquema_contabil_w = 'S') then
				qt_vago_w := ctb_pls_atualizar_despesa_in(nr_seq_protocolo_w, null, nm_usuario_p, cd_estabelecimento_p, qt_vago_w, null);
				qt_vago_w := ctb_pls_atualizar_desp_interc(nr_seq_protocolo_w, null, null, null, null, nm_usuario_p, cd_estabelecimento_p, qt_vago_w);
			else
				CALL ctb_pls_atualizar_conta(nr_seq_protocolo_w, nm_usuario_p, cd_estabelecimento_p);
			end if;
			end;
		end loop;
		close C01;
	end if;
	
	if (ie_esquema_contabil_w = 'S') then
		open C08;
		loop
		fetch C08 into
			nr_seq_protocolo_w;
		EXIT WHEN NOT FOUND; /* apply on C08 */
			begin
			qt_vago_w := ctb_pls_atualizar_desp_interc(nr_seq_protocolo_w, null, null, null, null, nm_usuario_p, cd_estabelecimento_p, qt_vago_w);
			end;
		end loop;
		close C08;
		
		open C09;
		loop
		fetch C09 into
			nr_seq_conta_w;
		EXIT WHEN NOT FOUND; /* apply on C09 */
			begin
			qt_vago_w := ctb_pls_atualizar_prov_copart(nr_seq_conta_w, null, null, nm_usuario_p, cd_estabelecimento_p, qt_vago_w);
			end;
		end loop;
		close C09;
	end if;
	
	CALL pls_atualizar_tit_conta(dt_referencia_p, nm_usuario_p, cd_estabelecimento_p);
elsif (ie_opcao_p = 'V') then
	open C02;
	loop
	fetch C02 into
		nr_seq_repasse_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		CALL ctb_pls_atualizar_repasse(nr_seq_repasse_w, nm_usuario_p, cd_estabelecimento_p);
		end;
	end loop;
	close C02;
elsif (ie_opcao_p = 'R') then
	open C03;
	loop
	fetch C03 into
		nr_seq_protocolo_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin
		if (ie_esquema_contabil_w = 'S') then
			qt_vago_w := ctb_pls_atualizar_reembolso_in(nr_seq_protocolo_w, null, null, null, null, nm_usuario_p, cd_estabelecimento_p, qt_vago_w);
		else
			CALL ctb_pls_atualizar_reemb(nr_seq_protocolo_w, nm_usuario_p, cd_estabelecimento_p);
		end if;
		end;
	end loop;
	close C03;
	
	if (ie_esquema_contabil_w = 'S') then
		open C13;
		loop
		fetch C13 into
			nr_seq_conta_w;
		EXIT WHEN NOT FOUND; /* apply on C13 */
			begin
			qt_vago_w := ctb_pls_atualizar_prov_copart(nr_seq_conta_w, null, null, nm_usuario_p, cd_estabelecimento_p, qt_vago_w);
			end;
		end loop;
		close C13;
	end if;
elsif (ie_opcao_p = 'M') then
	select	count(1)
	into STRICT	qt_lote_gerado_mes_w
	from	lote_contabil
	where	cd_tipo_lote_contabil in (21,49,50)
	and	trunc(dt_referencia,'month') = dt_referencia_month_w
	and	cd_estabelecimento = cd_estabelecimento_p
	and	(dt_geracao_lote IS NOT NULL AND dt_geracao_lote::text <> '');
	
	if (qt_lote_gerado_mes_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort( 188714, 'DT_REFERENCIA=' || to_char(dt_referencia_month_w,'mm/yyyy') );
	end if;
	
	if (ie_contab_ppcng_w = 'S') and (ie_performance_contab_w = 'M') then
		ie_geracao_p := pls_atualizar_contas_contabeis(dt_referencia_month_w, nm_usuario_p, cd_estabelecimento_p, 21, ie_geracao_p);
	else	
		open C04;
		loop
		fetch C04 into
			nr_seq_lote_w;
		EXIT WHEN NOT FOUND; /* apply on C04 */
			begin
			if (ie_esquema_contabil_w = 'S') then
				qt_movimento_w := ctb_pls_atualizar_receita_in(nr_seq_lote_w, null, null, null, nm_usuario_p, cd_estabelecimento_p, null, 'P', qt_movimento_w);
				ctb_pls_atualizar_imposto_in(nr_seq_lote_w, null, nm_usuario_p, cd_estabelecimento_p);
			else
				CALL CTB_PLS_Atualizar_mensal(nr_seq_lote_w, null, nm_usuario_p, cd_estabelecimento_p);
			end if;
			end;
		end loop;
		close C04;
	end if;
elsif (ie_opcao_p = 'S') then
	open C05;
	loop
	fetch C05 into
		nr_seq_processo_w;
	EXIT WHEN NOT FOUND; /* apply on C05 */
		begin
		qt_movimento_w := ctb_pls_atualizar_ressa(nr_seq_processo_w, nm_usuario_p, cd_estabelecimento_p, null, null, null, qt_movimento_w, null);
		end;
	end loop;
	close C05;
elsif (ie_opcao_p = 'P') then
	open C06;
	loop
	fetch C06 into
		nr_seq_lote_ppsc_w;
	EXIT WHEN NOT FOUND; /* apply on C06 */
		begin
		CALL ctb_pls_atualizar_ppsc(nr_seq_lote_ppsc_w, null, null, null, nm_usuario_p, cd_estabelecimento_p);
		end;
	end loop;
	close C06;
elsif (ie_opcao_p = 'E') then
	open C07;
	loop
	fetch C07 into
		nr_seq_peona_w;
	EXIT WHEN NOT FOUND; /* apply on C07 */
		begin
		CALL ctb_pls_atualizar_peona(nr_seq_peona_w, nm_usuario_p, cd_estabelecimento_p);
		end;
	end loop;
	close C07;
elsif (ie_opcao_p = 'F') then
	open C10;
	loop
	fetch C10 into
		nr_seq_lote_evento_w;
	EXIT WHEN NOT FOUND; /* apply on C10 */
		begin
		qt_vago_w := ctb_pls_atualizar_prod_eve_in(nr_seq_lote_evento_w, null, null, nm_usuario_p, cd_estabelecimento_p, qt_vago_w);
		end;
	end loop;
	close C10;
elsif (ie_opcao_p = 'FA') then
	open C12;
	loop
	fetch C12 into
		nr_seq_fatura_w;
	EXIT WHEN NOT FOUND; /* apply on C12 */
		begin
		CALL ctb_pls_atualizar_faturamento(	nr_seq_fatura_w,
						null,
						null,
						null,
						nm_usuario_p,
						cd_estabelecimento_p);
		end;
	end loop;
	close C12;
	
	open c_cancelamento_faturamento;
	loop
	fetch c_cancelamento_faturamento into
		nr_seq_lote_cancel_w;
	EXIT WHEN NOT FOUND; /* apply on c_cancelamento_faturamento */
		begin
		CALL ctb_pls_atualizar_cancel_fat(	nr_seq_lote_cancel_w,
						null,
						null,
						null,
						nm_usuario_p,
						cd_estabelecimento_p);
		end;
	end loop;
	close c_cancelamento_faturamento;
elsif (ie_opcao_p = 'TPPM') then
	/* Atualizar os tributos do pagamento de producao medica */

	open C14;
	loop
	fetch C14 into
		nr_seq_lote_pagamento_w;
	EXIT WHEN NOT FOUND; /* apply on C14 */
		begin
		qt_vago_w := ctb_pls_atualizar_trib_pag_in(nr_seq_lote_pagamento_w, null, null, nm_usuario_p, cd_estabelecimento_p, qt_vago_w);
		end;
	end loop;
	close C14;
	
elsif (ie_opcao_p = 'CM') then
	
	open c_lote_comissao;
	loop
	fetch c_lote_comissao into	
		nr_seq_lote_comissao_w;
	EXIT WHEN NOT FOUND; /* apply on c_lote_comissao */
		begin
	
		CALL cbt_pls_atualizar_comissao(nr_seq_lote_comissao_w, cd_estabelecimento_p, nm_usuario_p);
		
		end;
	end loop;
	close c_lote_comissao;
	
end if;

ie_geracao_p	:= 'S';

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_conta_contabil ( dt_referencia_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint, ie_opcao_p text, ie_geracao_p INOUT text) FROM PUBLIC;
