-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualizar_vl_lote_fatura ( nr_seq_lote_p pls_lote_faturamento.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, ie_consiste_val_p text, ie_commit_p text) AS $body$
DECLARE


nr_seq_fatura_w			pls_fatura.nr_sequencia%type;
nr_seq_fatura_evento_w		pls_fatura_evento.nr_sequencia%type;
nr_seq_fatura_conta_w		pls_fatura_conta.nr_sequencia%type;
vl_fatura_w			double precision:=0;
vl_evento_w			double precision:=0;
vl_faturado_proc_w		double precision:=0;
vl_faturado_mat_w		double precision:=0;
vl_faturado_proc_ndc_w		double precision:=0;
vl_faturado_mat_ndc_w		double precision:=0;
vl_faturado_w			double precision:=0;
vl_faturado_ndc_w		double precision:=0;
vl_ato_aux_w			pls_fatura.vl_ato_aux%type;
vl_ato_princ_w			pls_fatura.vl_ato_princ%type;
vl_ato_secundario_w		pls_fatura.vl_ato_princ%type;
vl_ato_aux_tot_w		pls_fatura.vl_ato_aux%type;
vl_ato_princ_tot_w		pls_fatura.vl_ato_princ%type;
vl_ato_secundario_tot_w		pls_fatura.vl_ato_princ%type;
ie_origem_conta_w		pls_conta.ie_origem_conta%type;
ie_gerar_fat_contab_w		pls_parametro_faturamento.ie_gerar_fat_contab%type;
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;
ie_novo_pos_estab_w		pls_visible_false.ie_novo_pos_estab%type := 'N';

vl_conta_w			pls_fatura_conta.vl_faturado%type;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_fatura	
	where	nr_seq_lote = nr_seq_lote_p;

C02 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_fatura_evento
	where	nr_seq_fatura = nr_seq_fatura_w;
	
C03 CURSOR FOR
	SELECT	b.nr_sequencia,
		a.ie_origem_conta
	from	pls_fatura_conta	b,
		pls_conta		a
	where	a.nr_sequencia		= b.nr_seq_conta
	and (b.ie_tipo_cobranca	<> '5' or coalesce(b.ie_tipo_cobranca::text, '') = '')
	and	nr_seq_fatura_evento 	= nr_seq_fatura_evento_w
	
union all

	-- Ressarcimento ao SUS
	SELECT	b.nr_sequencia,
		'S' ie_origem_conta
	from	pls_fatura_conta	b,
		pls_processo_conta	a
	where	a.nr_sequencia		= b.nr_seq_conta_sus
	and	b.ie_tipo_cobranca	= '5'
	and	nr_seq_fatura_evento 	= nr_seq_fatura_evento_w;
	

BEGIN

if (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '') then

	select	coalesce(max(ie_novo_pos_estab),'N')
	into STRICT	ie_novo_pos_estab_w
	from	pls_visible_false;
	
	if (ie_novo_pos_estab_w = 'S') then
		CALL pls_faturamento_pck.atualizar_vl_lote_fatura(nr_seq_lote_p, nm_usuario_p, ie_consiste_val_p, ie_commit_p);
	else
		select	max(cd_estabelecimento)
		into STRICT	cd_estabelecimento_w
		from	pls_lote_faturamento
		where	nr_sequencia	= nr_seq_lote_p;
		
		select	coalesce(max(ie_gerar_fat_contab),'N')
		into STRICT	ie_gerar_fat_contab_w
		from	pls_parametro_faturamento
		where	cd_estabelecimento	= cd_estabelecimento_w;
		
		open C01;
		loop
		fetch C01 into
			nr_seq_fatura_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			vl_faturado_w := 0;
			vl_faturado_ndc_w := 0;
			
			vl_ato_aux_tot_w	:= 0;
			vl_ato_princ_tot_w	:= 0;
			vl_ato_secundario_tot_w	:= 0;
			
			open C02;
			loop
			fetch C02 into
				nr_seq_fatura_evento_w;
			EXIT WHEN NOT FOUND; /* apply on c02 */
				begin
				open C03;
				loop
				fetch C03 into
					nr_seq_fatura_conta_w,
					ie_origem_conta_w;
				EXIT WHEN NOT FOUND; /* apply on C03 */
					begin
					if (ie_origem_conta_w <> 'S') or (coalesce(ie_origem_conta_w::text, '') = '') then
						select	sum(vl_faturado),
							sum(vl_faturado_ndc)
						into STRICT	vl_faturado_proc_w,
							vl_faturado_proc_ndc_w
						from	pls_fatura_proc
						where	nr_seq_fatura_conta = nr_seq_fatura_conta_w;	
						
						select	sum(vl_faturado),
							sum(vl_faturado_ndc)
						into STRICT	vl_faturado_mat_w,
							vl_faturado_mat_ndc_w
						from	pls_fatura_mat
						where	nr_seq_fatura_conta = nr_seq_fatura_conta_w;
						
						update	pls_fatura_conta		
						set	vl_faturado 	= coalesce(vl_faturado_proc_w,0) + coalesce(vl_faturado_mat_w,0),
							vl_faturado_ndc	= coalesce(vl_faturado_proc_ndc_w,0) + coalesce(vl_faturado_mat_ndc_w,0),
							nm_usuario	= nm_usuario_p,
							dt_atualizacao	= clock_timestamp()
						where	nr_sequencia 	= nr_seq_fatura_conta_w;
						
						vl_faturado_w := vl_faturado_w + coalesce(vl_faturado_proc_w,0) + coalesce(vl_faturado_mat_w,0);
						vl_faturado_ndc_w := vl_faturado_ndc_w + coalesce(vl_faturado_proc_ndc_w,0) + coalesce(vl_faturado_mat_ndc_w,0);
					-- Ressarcimento ao sus
					elsif (ie_origem_conta_w = 'S') then
						select	max(vl_faturado)
						into STRICT	vl_conta_w
						from	pls_fatura_conta
						where	nr_sequencia 	= nr_seq_fatura_conta_w;
						
						vl_faturado_w	:= vl_faturado_w + coalesce(vl_conta_w, 0);
					end if;
					end;
				end loop;
				close C03;
				
				select	sum(vl_faturado) + sum(vl_faturado_ndc)
				into STRICT	vl_evento_w
				from	pls_fatura_conta
				where	nr_seq_fatura_evento = nr_seq_fatura_evento_w;
				
				update	pls_fatura_evento
				set	vl_evento 	= coalesce(vl_evento_w,0),
					nm_usuario	= nm_usuario_p,
					dt_atualizacao	= clock_timestamp()
				where	nr_sequencia	= nr_seq_fatura_evento_w;
				end;
			end loop;
			close C02;
			
			if (ie_origem_conta_w <> 'S') then
				if (ie_gerar_fat_contab_w	= 'S') then
					select	sum(coalesce(vl_ato_princ,0)),
						sum(coalesce(vl_ato_aux,0)),
						sum(coalesce(vl_ato_secundario,0))
					into STRICT	vl_ato_princ_tot_w,
						vl_ato_aux_tot_w,
						vl_ato_secundario_tot_w
					from (SELECT	CASE WHEN coalesce(b.ie_ato_cooperado,e.ie_ato_cooperado)='1' THEN coalesce(c.vl_faturado,0) + coalesce(c.vl_faturado_ndc,0)  ELSE 0 END  vl_ato_princ,
							CASE WHEN coalesce(b.ie_ato_cooperado,e.ie_ato_cooperado)='2' THEN coalesce(c.vl_faturado,0) + coalesce(c.vl_faturado_ndc,0)  ELSE 0 END  vl_ato_aux,
							CASE WHEN coalesce(b.ie_ato_cooperado,e.ie_ato_cooperado)='3' THEN coalesce(c.vl_faturado,0) + coalesce(c.vl_faturado_ndc,0)  ELSE 0 END  vl_ato_secundario
						FROM pls_fatura_evento g, pls_fatura_conta f, pls_conta_mat e, pls_fatura_mat c, pls_conta_pos_estab_contab d
LEFT OUTER JOIN pls_conta_medica_resumo b ON (d.nr_seq_conta_resumo = b.nr_sequencia AND D.nr_seq_conta = b.nr_seq_conta)
WHERE c.nr_seq_fatura_conta	= f.nr_sequencia and f.nr_seq_fatura_evento	= g.nr_sequencia and d.nr_sequencia		= c.nr_seq_conta_pos_contab   and e.nr_sequencia 		= c.nr_seq_conta_mat and g.nr_seq_fatura		= nr_seq_fatura_w
						
union all

						SELECT	CASE WHEN coalesce(b.ie_ato_cooperado,e.ie_ato_cooperado)='1' THEN coalesce(c.vl_faturado,0) + coalesce(c.vl_faturado_ndc,0)  ELSE 0 END  vl_ato_princ,
							CASE WHEN coalesce(b.ie_ato_cooperado,e.ie_ato_cooperado)='2' THEN coalesce(c.vl_faturado,0) + coalesce(c.vl_faturado_ndc,0)  ELSE 0 END  vl_ato_aux,
							CASE WHEN coalesce(b.ie_ato_cooperado,e.ie_ato_cooperado)='3' THEN coalesce(c.vl_faturado,0) + coalesce(c.vl_faturado_ndc,0)  ELSE 0 END  vl_ato_secundario
						FROM pls_fatura_evento g, pls_fatura_conta f, pls_conta_proc e, pls_fatura_proc c, pls_conta_pos_estab_contab d
LEFT OUTER JOIN pls_conta_medica_resumo b ON (d.nr_seq_conta_resumo = b.nr_sequencia AND D.nr_seq_conta = b.nr_seq_conta)
WHERE c.nr_seq_fatura_conta	= f.nr_sequencia and f.nr_seq_fatura_evento	= g.nr_sequencia and d.nr_sequencia		= c.nr_seq_conta_pos_contab   and e.nr_sequencia 		= c.nr_seq_conta_proc and g.nr_seq_fatura		= nr_seq_fatura_w ) alias26;
				
				else
					select	sum(coalesce(vl_ato_princ,0)),
						sum(coalesce(vl_ato_aux,0)),
						sum(coalesce(vl_ato_secundario,0))
					into STRICT	vl_ato_princ_tot_w,
						vl_ato_aux_tot_w,
						vl_ato_secundario_tot_w
					from (SELECT	CASE WHEN coalesce(b.ie_ato_cooperado,e.ie_ato_cooperado)='1' THEN coalesce(d.vl_custo_operacional,0)  ELSE 0 END  vl_ato_princ,
							CASE WHEN coalesce(b.ie_ato_cooperado,e.ie_ato_cooperado)='2' THEN coalesce(d.vl_custo_operacional,0)  ELSE 0 END  vl_ato_aux,
							CASE WHEN coalesce(b.ie_ato_cooperado,e.ie_ato_cooperado)='3' THEN coalesce(d.vl_custo_operacional,0)  ELSE 0 END  vl_ato_secundario
						FROM pls_fatura_evento g, pls_fatura_conta f, pls_conta_mat e, pls_fatura_mat c, pls_conta_pos_estab_contab d
LEFT OUTER JOIN pls_conta_medica_resumo b ON (d.nr_seq_conta_resumo = b.nr_sequencia AND d.nr_seq_conta = b.nr_seq_conta)
WHERE c.nr_seq_fatura_conta	= f.nr_sequencia and f.nr_seq_fatura_evento	= g.nr_sequencia and d.nr_seq_conta_pos	= c.nr_seq_conta_pos_estab   and e.nr_sequencia 		= c.nr_seq_conta_mat and g.nr_seq_fatura		= nr_seq_fatura_w
						
union all

						SELECT	CASE WHEN coalesce(b.ie_ato_cooperado,e.ie_ato_cooperado)='1' THEN coalesce(d.vl_custo_operacional,0)  ELSE 0 END  vl_ato_princ,
							CASE WHEN coalesce(b.ie_ato_cooperado,e.ie_ato_cooperado)='2' THEN coalesce(d.vl_custo_operacional,0)  ELSE 0 END  vl_ato_aux,
							CASE WHEN coalesce(b.ie_ato_cooperado,e.ie_ato_cooperado)='3' THEN coalesce(d.vl_custo_operacional,0)  ELSE 0 END  vl_ato_secundario
						FROM pls_fatura_evento g, pls_fatura_conta f, pls_conta_proc e, pls_fatura_proc c, pls_conta_pos_estab_contab d
LEFT OUTER JOIN pls_conta_medica_resumo b ON (d.nr_seq_conta_resumo = b.nr_sequencia AND D.nr_seq_conta = b.nr_seq_conta)
WHERE c.nr_seq_fatura_conta	= f.nr_sequencia and f.nr_seq_fatura_evento	= g.nr_sequencia and d.nr_seq_conta_pos	= c.nr_seq_conta_pos_estab   and e.nr_sequencia 		= c.nr_seq_conta_proc and g.nr_seq_fatura		= nr_seq_fatura_w ) alias18;
				end if;
			end if;			
			
			update	pls_fatura
			set	vl_fatura		= coalesce(vl_faturado_w,0),
				vl_total_ndc		= coalesce(vl_faturado_ndc_w,0),
				vl_ato_aux		= vl_ato_aux_tot_w,
				vl_ato_princ		= vl_ato_princ_tot_w,
				vl_ato_secundario	= vl_ato_secundario_tot_w,
				nm_usuario		= nm_usuario_p,
				dt_atualizacao		= clock_timestamp()
			where	nr_sequencia 		= nr_seq_fatura_w;
			end;
		end loop;
		close C01;
		
		if (coalesce(ie_consiste_val_p,'N') = 'S') then
			CALL pls_gerar_fatura_log(nr_seq_lote_p, null, null, 'PLS_ATUALIZAR_VL_LOTE_FATURA', 'AT', 'N', nm_usuario_p);
		end if;
		
		if (coalesce(ie_commit_p,'N') = 'S') then
			commit;
		end if;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_vl_lote_fatura ( nr_seq_lote_p pls_lote_faturamento.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, ie_consiste_val_p text, ie_commit_p text) FROM PUBLIC;
