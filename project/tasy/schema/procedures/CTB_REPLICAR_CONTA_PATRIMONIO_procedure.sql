-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_replicar_conta_patrimonio (cd_empresa_origem_p pat_conta_contabil.cd_empresa%type, cd_estab_origem_p pat_conta_contabil.cd_estabelecimento%type, nr_sequencia_p pat_conta_contabil.nr_sequencia%type, ie_operacao_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_estab_matriz_origem_w	estabelecimento.cd_estabelecimento%type;
cd_estab_matriz_destino_w	estabelecimento.cd_estabelecimento%type;

nr_sequencia_w			pat_conta_contabil.nr_sequencia%type;
cd_conta_contabil_w		pat_conta_contabil.cd_conta_contabil%type;
dt_vigencia_w			pat_conta_contabil.dt_vigencia%type;
pr_depreciacao_w		pat_conta_contabil.pr_depreciacao%type;
cd_estabelecimento_w		pat_conta_contabil.cd_estabelecimento%type;
cd_conta_deprec_acum_w		pat_conta_contabil.cd_conta_deprec_acum%type;
cd_conta_deprec_res_w		pat_conta_contabil.cd_conta_deprec_res%type;
cd_historico_w			pat_conta_contabil.cd_historico%type;
cd_conta_baixa_w		pat_conta_contabil.cd_conta_baixa%type;
cd_hist_baixa_w			pat_conta_contabil.cd_hist_baixa%type;
cd_hist_transf_w		pat_conta_contabil.cd_hist_transf%type;
pr_deprec_fiscal_w		pat_conta_contabil.pr_deprec_fiscal%type;
ie_situacao_w			pat_conta_contabil.ie_situacao%type;
cd_conta_ajuste_pat_w		pat_conta_contabil.cd_conta_ajuste_pat%type;
cd_conta_cap_social_w		pat_conta_contabil.cd_conta_cap_social%type;
cd_hist_ajuste_pat_w		pat_conta_contabil.cd_hist_ajuste_pat%type;
cd_empresa_w			pat_conta_contabil.cd_empresa%type;
ds_regra_w			pat_conta_contabil.ds_regra%type;
ie_contab_entrada_aval_w	pat_conta_contabil.ie_contab_entrada_aval%type;
cd_hist_entrada_aval_w		pat_conta_contabil.cd_hist_entrada_aval%type;
cd_conta_entrada_aval_w		pat_conta_contabil.cd_conta_entrada_aval%type;
nr_seq_conta_ref_w		pat_conta_contabil.nr_seq_conta_ref%type;

qt_registro_w			integer;

c01 CURSOR FOR
	SELECT	a.cd_empresa
	from	grupo_emp_estrutura a
	where	a.nr_seq_grupo	= holding_pck.GET_GRUPO_EMP_USUARIO(cd_empresa_origem_p)
	and	a.cd_empresa <> cd_empresa_origem_p
	and	obter_se_periodo_vigente(a.dt_inicio_vigencia,a.dt_fim_vigencia,clock_timestamp()) = 'S'
	order by a.cd_empresa;

c01_w		c01%rowtype;


BEGIN

select	nr_sequencia,
	cd_conta_contabil,
	dt_vigencia,
	pr_depreciacao,
	cd_estabelecimento,
	cd_conta_deprec_acum,
	cd_conta_deprec_res,
	cd_historico,
	cd_conta_baixa,
	cd_hist_baixa,
	cd_hist_transf,
	pr_deprec_fiscal,
	ie_situacao,
	cd_conta_ajuste_pat,
	cd_conta_cap_social,
	cd_hist_ajuste_pat,
	cd_empresa,
	ds_regra,
	ie_contab_entrada_aval,
	cd_hist_entrada_aval,
	cd_conta_entrada_aval
into STRICT	nr_seq_conta_ref_w,
	cd_conta_contabil_w,
	dt_vigencia_w,
	pr_depreciacao_w,
	cd_estabelecimento_w,
	cd_conta_deprec_acum_w,
	cd_conta_deprec_res_w,
	cd_historico_w,
	cd_conta_baixa_w,
	cd_hist_baixa_w,
	cd_hist_transf_w,
	pr_deprec_fiscal_w,
	ie_situacao_w,
	cd_conta_ajuste_pat_w,
	cd_conta_cap_social_w,
	cd_hist_ajuste_pat_w,
	cd_empresa_w,
	ds_regra_w,
	ie_contab_entrada_aval_w,
	cd_hist_entrada_aval_w,
	cd_conta_entrada_aval_w
from	pat_conta_contabil
where	nr_sequencia = nr_sequencia_p
and	cd_empresa = cd_empresa_origem_p
and	((cd_estabelecimento = coalesce(cd_estab_origem_p,cd_estabelecimento)) or (coalesce(cd_estabelecimento::text, '') = ''));

begin
select  a.cd_estabelecimento
into STRICT	cd_estab_matriz_origem_w
from    estabelecimento a
where   a.cd_empresa = cd_empresa_origem_p
and	a.cd_estabelecimento = coalesce(cd_estab_origem_p, a.cd_estabelecimento)
and	a.ie_tipo_estab = 'M';
exception
when no_data_found then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1116521);
when too_many_rows then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1116523);
end;

open c01;
loop
fetch c01 into	
	c01_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	cd_estab_matriz_destino_w := null;
	
	if (cd_estabelecimento_w IS NOT NULL AND cd_estabelecimento_w::text <> '') then
		begin
		
		begin
		select  a.cd_estabelecimento
		into STRICT	cd_estab_matriz_destino_w
		from    estabelecimento a
		where   a.cd_empresa = c01_w.cd_empresa
		and	a.ie_tipo_estab = 'M';	
		exception
		when no_data_found then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(1116520);
		when too_many_rows then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(1116523);
		end;
		
		end;
	end if;

	select	count(1)
	into STRICT	qt_registro_w
	from	pat_conta_contabil
	where	cd_empresa = c01_w.cd_empresa
	and	((cd_estabelecimento = coalesce(cd_estab_matriz_destino_w,cd_estabelecimento)) or (coalesce(cd_estabelecimento::text, '') = ''))
	and	nr_seq_conta_ref = nr_seq_conta_ref_w;

	if	(ie_operacao_p = 3 AND qt_registro_w > 0) then
		begin

		delete
		from	pat_conta_contabil a
		where	cd_empresa = c01_w.cd_empresa
		and	((cd_estabelecimento = coalesce(cd_estab_matriz_destino_w,cd_estabelecimento)) or (coalesce(cd_estabelecimento::text, '') = ''))
		and	nr_seq_conta_ref = nr_seq_conta_ref_w;
		
		commit;
		
		end;

	elsif ((ie_operacao_p = 1) or (ie_operacao_p = 2)) then
		begin

		if (qt_registro_w = 0) then
			begin

			insert into pat_conta_contabil(nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						cd_conta_contabil,
						dt_vigencia,
						pr_depreciacao,
						cd_estabelecimento,
						cd_conta_deprec_acum,
						cd_conta_deprec_res,
						cd_historico,
						cd_conta_baixa,
						cd_hist_baixa,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						cd_hist_transf,
						pr_deprec_fiscal,
						ie_situacao,
						cd_conta_ajuste_pat,
						cd_conta_cap_social,
						cd_hist_ajuste_pat,
						cd_empresa,
						ds_regra,
						ie_contab_entrada_aval,
						cd_hist_entrada_aval,
						cd_conta_entrada_aval,
						nr_seq_conta_ref)
					values (nextval('pat_conta_contabil_seq'),
						clock_timestamp(),
						nm_usuario_p,
						holding_pck.get_conta_contab_ref(c01_w.cd_empresa, cd_conta_contabil_w),
						dt_vigencia_w,
						pr_depreciacao_w,
						cd_estab_matriz_destino_w,
						holding_pck.get_conta_contab_ref(c01_w.cd_empresa, cd_conta_deprec_acum_w),
						holding_pck.get_conta_contab_ref(c01_w.cd_empresa, cd_conta_deprec_res_w),
						holding_pck.get_hist_padrao_ref(c01_w.cd_empresa, cd_historico_w),
						holding_pck.get_conta_contab_ref(c01_w.cd_empresa, cd_conta_baixa_w),
						holding_pck.get_hist_padrao_ref(c01_w.cd_empresa, cd_hist_baixa_w),
						clock_timestamp(),
						nm_usuario_p,
						holding_pck.get_hist_padrao_ref(c01_w.cd_empresa, cd_hist_transf_w),
						pr_deprec_fiscal_w,
						ie_situacao_w,
						holding_pck.get_conta_contab_ref(c01_w.cd_empresa, cd_conta_ajuste_pat_w),
						holding_pck.get_conta_contab_ref(c01_w.cd_empresa, cd_conta_cap_social_w),
						holding_pck.get_hist_padrao_ref(c01_w.cd_empresa, cd_hist_ajuste_pat_w),
						c01_w.cd_empresa,
						ds_regra_w,
						ie_contab_entrada_aval_w,
						holding_pck.get_hist_padrao_ref(c01_w.cd_empresa, cd_hist_entrada_aval_w),
						holding_pck.get_conta_contab_ref(c01_w.cd_empresa, cd_conta_entrada_aval_w),
						nr_seq_conta_ref_w);

			commit;

			end;

		elsif (qt_registro_w > 0) then
			begin

			update	pat_conta_contabil
			set	dt_atualizacao		= clock_timestamp(),
				nm_usuario		= nm_usuario_p,
				cd_conta_contabil	= holding_pck.get_conta_contab_ref(c01_w.cd_empresa, cd_conta_contabil_w),
				dt_vigencia		= dt_vigencia_w,
				pr_depreciacao		= pr_depreciacao_w,
				cd_estabelecimento	= cd_estab_matriz_destino_w,
				cd_conta_deprec_acum	= holding_pck.get_conta_contab_ref(c01_w.cd_empresa, cd_conta_deprec_acum_w),
				cd_conta_deprec_res	= holding_pck.get_conta_contab_ref(c01_w.cd_empresa, cd_conta_deprec_res_w),
				cd_historico		= holding_pck.get_hist_padrao_ref(c01_w.cd_empresa, cd_historico_w),
				cd_conta_baixa		= holding_pck.get_conta_contab_ref(c01_w.cd_empresa, cd_conta_baixa_w),
				cd_hist_baixa		= holding_pck.get_hist_padrao_ref(c01_w.cd_empresa, cd_hist_baixa_w),
				cd_hist_transf		= holding_pck.get_hist_padrao_ref(c01_w.cd_empresa, cd_hist_transf_w),
				pr_deprec_fiscal	= pr_deprec_fiscal_w,
				ie_situacao		= ie_situacao_w,
				cd_conta_ajuste_pat	= holding_pck.get_conta_contab_ref(c01_w.cd_empresa, cd_conta_ajuste_pat_w),
				cd_conta_cap_social	= holding_pck.get_conta_contab_ref(c01_w.cd_empresa, cd_conta_cap_social_w),
				cd_hist_ajuste_pat	= holding_pck.get_hist_padrao_ref(c01_w.cd_empresa, cd_hist_ajuste_pat_w),
				cd_empresa		= c01_w.cd_empresa,
				ds_regra		= ds_regra_w,
				ie_contab_entrada_aval	= ie_contab_entrada_aval_w,
				cd_hist_entrada_aval	= holding_pck.get_hist_padrao_ref(c01_w.cd_empresa, cd_hist_entrada_aval_w),
				cd_conta_entrada_aval	= holding_pck.get_conta_contab_ref(c01_w.cd_empresa, cd_conta_entrada_aval_w)
			where	cd_empresa = c01_w.cd_empresa
			and	nr_seq_conta_ref = nr_seq_conta_ref_w
			and	((cd_estabelecimento = coalesce(cd_estab_matriz_destino_w,cd_estabelecimento)) or (coalesce(cd_estabelecimento::text, '') = ''));
			
			commit;
			
			end;
		end if;
		
		end;
	end if;	
	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_replicar_conta_patrimonio (cd_empresa_origem_p pat_conta_contabil.cd_empresa%type, cd_estab_origem_p pat_conta_contabil.cd_estabelecimento%type, nr_sequencia_p pat_conta_contabil.nr_sequencia%type, ie_operacao_p bigint, nm_usuario_p text) FROM PUBLIC;
