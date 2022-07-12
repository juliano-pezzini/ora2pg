-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



CREATE OR REPLACE PROCEDURE pls_gerenciar_reembolso_pck.pls_gerar_apropriacao ( nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type, nm_usuario_p text) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  	Gerar os registros de apropriacao para procedimento e materiais (pls_conta_mat_aprop e
		pls_conta_proc_aprop) dos protocolo de reembolso.
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta:
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

Alteracoes:
------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


vl_item_w			pls_conta_proc.vl_procedimento%type;
vl_total_apropriado_w		pls_conta_proc.vl_procedimento%type;
vl_apropriado_w			pls_conta_proc_aprop.vl_apropriado%type;
vl_diferenca_w			pls_conta_proc.vl_procedimento%type;
nr_seq_conta_proc_aprop_w	pls_conta_proc.nr_sequencia%type;
nr_seq_conta_mat_aprop_w	pls_conta_mat.nr_sequencia%type;
vl_coparticipacao_w		pls_conta_proc.vl_coparticipacao%type;
v_participacao_w		pls_conta_mat.vl_participacao%type;

-- procedimentos e materiais da conta

c01 CURSOR(nr_seq_conta_pc	pls_conta.nr_sequencia%type) FOR
	SELECT 	a.nr_sequencia nr_seq_conta_proc,
		null nr_seq_conta_mat,
		a.nr_seq_regra_acao_reemb nr_seq_regra_acao_reemb,
		a.vl_procedimento_imp vl_apresentado,
		a.vl_procedimento vl_calculado,
		a.vl_liberado,
		a.qt_procedimento qt_item
	from	pls_conta_proc a
	where	a.nr_seq_conta		= nr_seq_conta_pc
	and	(nr_seq_conta_pc IS NOT NULL AND nr_seq_conta_pc::text <> '')
	and	(a.nr_seq_regra_acao_reemb IS NOT NULL AND a.nr_seq_regra_acao_reemb::text <> '')
	
union all

	SELECT 	a.nr_sequencia nr_seq_conta_proc,
		null nr_seq_conta_mat,
		a.nr_seq_regra_acao_reemb nr_seq_regra_acao_reemb,
		a.vl_procedimento_imp vl_apresentado,
		a.vl_procedimento vl_calculado,
		a.vl_liberado,
		a.qt_procedimento qt_item
	from	pls_conta_proc a
	where	a.nr_sequencia = nr_seq_conta_proc_p
	and	(nr_seq_conta_proc_p IS NOT NULL AND nr_seq_conta_proc_p::text <> '')
	and	(a.nr_seq_regra_acao_reemb IS NOT NULL AND a.nr_seq_regra_acao_reemb::text <> '')
	
union all

	select	null nr_seq_conta_proc,
		a.nr_sequencia nr_seq_conta_mat,
		a.nr_seq_regra_acao_reemb nr_seq_regra_acao_reemb,
		a.vl_material_imp vl_apresentado,
		a.vl_material vl_calculado,
		a.vl_liberado,
		a.qt_material qt_item
	from	pls_conta_mat a
	where	a.nr_seq_conta		= nr_seq_conta_pc
	and	(nr_seq_conta_pc IS NOT NULL AND nr_seq_conta_pc::text <> '')
	and	(a.nr_seq_regra_acao_reemb IS NOT NULL AND a.nr_seq_regra_acao_reemb::text <> '')
	
union all

	select	null nr_seq_conta_proc,
		a.nr_sequencia nr_seq_conta_mat,
		a.nr_seq_regra_acao_reemb nr_seq_regra_acao_reemb,
		a.vl_material_imp vl_apresentado,
		a.vl_material vl_calculado,
		a.vl_liberado,
		a.qt_material qt_item
	from	pls_conta_mat a
	where	a.nr_sequencia = nr_seq_conta_mat_p
	and	(nr_seq_conta_mat_p IS NOT NULL AND nr_seq_conta_mat_p::text <> '')
	and	(a.nr_seq_regra_acao_reemb IS NOT NULL AND a.nr_seq_regra_acao_reemb::text <> '');
	
-- Apropriacao PLS_REGRA_REEMB_ACAO -> PLS_REGRA_REEMB_APROP

c02 CURSOR(nr_seq_regra_reemb_acao_pc	pls_regra_reemb_acao.nr_sequencia%type) FOR
	SELECT 	b.nr_sequencia nr_seq_regra_aprop,
		b.nr_seq_regra_reemb nr_seq_regra_reemb,
		b.nr_seq_centro_aprop nr_seq_centro_aprop,
		b.ie_tipo_distribuicao ie_tipo_distribuicao,
		a.ie_acao ie_acao,
		b.pr_distribuicao pr_distribuicao,
		b.vl_fixo vl_fixo,
		b.vl_limite vl_limite,
		b.cd_conta_financ_rec cd_conta_financ_rec,
		b.cd_conta_financ_pag cd_conta_financ_pag,
		CASE WHEN c.ie_responsavel_apropriacao=2 THEN 'S'  ELSE 'N' END  ie_recuperar,
		b.ie_tipo_valor,
		CASE WHEN c.ie_responsavel_apropriacao=1 THEN CASE WHEN c.ie_coparticipacao='S' THEN 'S'  ELSE 'N' END   ELSE 'N' END  ie_coparticipacao
	from	pls_regra_reemb_acao a,
		pls_regra_reemb_aprop b,
		pls_centro_apropriacao c
	where	b.nr_seq_regra_acao = a.nr_sequencia
	and	b.nr_seq_centro_aprop 	= c.nr_sequencia
	and	a.nr_sequencia	= nr_seq_regra_reemb_acao_pc
	and	a.ie_acao in ('VA','RP')
	order by	b.ie_ordem;	
	
BEGIN

for	r_c01_w in c01(nr_seq_conta_p) loop
	CALL pls_gerenciar_reembolso_pck.pls_reemb_limpa_apropriacao(nr_seq_conta_p,nr_seq_conta_proc_p,nr_seq_conta_mat_p);

	nr_seq_conta_proc_aprop_w:= 	null;
	nr_seq_conta_mat_aprop_w:= 	null;
	vl_total_apropriado_w := 0;

	for	r_c02_w in c02(r_c01_w.nr_seq_regra_acao_reemb) loop
		vl_item_w	:= r_c01_w.vl_liberado;
		
		if (coalesce(vl_item_w,0) > 0) then
			vl_apropriado_w := 0;
			if (r_c02_w.ie_tipo_distribuicao = 1) then	-- Valor fixo
				vl_apropriado_w := r_c02_w.vl_fixo;
			elsif (r_c02_w.ie_tipo_distribuicao = 2) then -- Percentual
				if (r_c02_w.ie_tipo_valor = 'C') then
					vl_apropriado_w := (r_c01_w.vl_calculado * r_c02_w.pr_distribuicao) / 100;
				elsif (r_c02_w.ie_tipo_valor = 'A') then
					vl_apropriado_w := (r_c01_w.vl_apresentado* r_c02_w.pr_distribuicao) / 100;
				else
					vl_apropriado_w := (vl_item_w * r_c02_w.pr_distribuicao) / 100;
				end if;
			elsif (r_c02_w.ie_tipo_distribuicao = 3) then	-- Percentual sobre diferenca
				if (r_c01_w.nr_seq_conta_proc IS NOT NULL AND r_c01_w.nr_seq_conta_proc::text <> '') then
					select 	coalesce(sum(a.vl_apropriado),0)
					into STRICT	vl_diferenca_w
					from	pls_conta_proc_aprop a
					where	a.nr_seq_conta_proc = r_c01_w.nr_seq_conta_proc;
				elsif (r_c01_w.nr_seq_conta_mat IS NOT NULL AND r_c01_w.nr_seq_conta_mat::text <> '') then
					select 	coalesce(sum(a.vl_apropriado),0)
					into STRICT	vl_diferenca_w
					from	pls_conta_mat_aprop a
					where	a.nr_seq_conta_mat = r_c01_w.nr_seq_conta_mat;
				end if;
				vl_apropriado_w := (vl_item_w - vl_diferenca_w) * r_c02_w.pr_distribuicao / 100;				
			end if;
			
			if (vl_apropriado_w > r_c02_w.vl_limite) then -- Verifica se valor obtido ultrapassa limite
				vl_apropriado_w := r_c02_w.vl_limite;
			end if;	
			
			if ((r_c01_w.nr_seq_conta_proc IS NOT NULL AND r_c01_w.nr_seq_conta_proc::text <> '') and coalesce(vl_apropriado_w,0) > 0) then
				select 	nextval('pls_conta_proc_aprop_seq')
				into STRICT	nr_seq_conta_proc_aprop_w
				;
				nr_seq_conta_mat_aprop_w:= 	null;
				vl_total_apropriado_w:= vl_total_apropriado_w + vl_apropriado_w;

				insert into pls_conta_proc_aprop(nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_seq_conta_proc,
						nr_seq_centro_aprop,
						nr_seq_regra_aprop,
						vl_apropriado,
						ie_recuperar,
						nr_seq_regra_copartic,
						cd_conta_financ_rec,
						cd_conta_financ_pag,
						qt_apropriada,
						ie_coparticipacao)
				values (nr_seq_conta_proc_aprop_w,
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						r_c01_w.nr_seq_conta_proc,
						r_c02_w.nr_seq_centro_aprop,
						r_c02_w.nr_seq_regra_aprop,
						vl_apropriado_w,
						r_c02_w.ie_recuperar,
						null,
						r_c02_w.cd_conta_financ_rec,
						r_c02_w.cd_conta_financ_pag,
						r_c01_w.qt_item,
						r_c02_w.ie_coparticipacao);
						
				/* Francisco - OS 816140 - Tratar coparticipacao */


				if (r_c02_w.ie_coparticipacao = 'S') then
					update	pls_conta_proc
					set	vl_coparticipacao = coalesce(vl_coparticipacao,0) + vl_apropriado_w
					where	nr_sequencia	= r_c01_w.nr_seq_conta_proc;
				end if;
			elsif ((r_c01_w.nr_seq_conta_mat IS NOT NULL AND r_c01_w.nr_seq_conta_mat::text <> '') and coalesce(vl_apropriado_w,0) > 0) then
				nr_seq_conta_proc_aprop_w:= 	null;
				select 	nextval('pls_conta_mat_aprop_seq')
				into STRICT	nr_seq_conta_mat_aprop_w
				;
				vl_total_apropriado_w:= vl_total_apropriado_w + vl_apropriado_w;

				insert into pls_conta_mat_aprop(nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_seq_conta_mat,
						nr_seq_centro_aprop,
						nr_seq_regra_aprop,
						vl_apropriado,
						ie_recuperar,
						nr_seq_regra_copartic,
						cd_conta_financ_rec,
						cd_conta_financ_pag,
						qt_apropriada,
						ie_coparticipacao)
				values (nr_seq_conta_mat_aprop_w,
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						r_c01_w.nr_seq_conta_mat,
						r_c02_w.nr_seq_centro_aprop,
						r_c02_w.nr_seq_regra_aprop,
						vl_apropriado_w,
						r_c02_w.ie_recuperar,
						null,
						r_c02_w.cd_conta_financ_rec,
						r_c02_w.cd_conta_financ_pag,
						r_c01_w.qt_item,
						r_c02_w.ie_coparticipacao);
				
				if (r_c02_w.ie_coparticipacao = 'S') then
					update	pls_conta_mat
					set	vl_participacao = coalesce(vl_participacao,0) + vl_apropriado_w
					where	nr_sequencia	= r_c01_w.nr_seq_conta_mat;
				end if;
			end if;
		end if;
	end loop;
	
	if ((nr_seq_conta_proc_aprop_w IS NOT NULL AND nr_seq_conta_proc_aprop_w::text <> '') or (nr_seq_conta_mat_aprop_w IS NOT NULL AND nr_seq_conta_mat_aprop_w::text <> '')) then
		-- Ajuste de possivel diferenca de arredondamneto

		if (vl_total_apropriado_w <> vl_item_w) then
			if (nr_seq_conta_proc_aprop_w IS NOT NULL AND nr_seq_conta_proc_aprop_w::text <> '') then
				update	pls_conta_proc_aprop
				set	vl_apropriado	= vl_apropriado + (vl_item_w - vl_total_apropriado_w)
				where	nr_sequencia 	= nr_seq_conta_proc_aprop_w;
			elsif (nr_seq_conta_mat_aprop_w IS NOT NULL AND nr_seq_conta_mat_aprop_w::text <> '') then
				update	pls_conta_mat_aprop
				set	vl_apropriado	= vl_apropriado + (vl_item_w - vl_total_apropriado_w)
				where	nr_sequencia 	= nr_seq_conta_mat_aprop_w;
			end if;
		end if;
		null;
	end if;
	
end loop;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerenciar_reembolso_pck.pls_gerar_apropriacao ( nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type, nm_usuario_p text) FROM PUBLIC;