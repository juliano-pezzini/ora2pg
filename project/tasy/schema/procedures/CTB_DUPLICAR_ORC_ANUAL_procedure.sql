-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_duplicar_orc_anual ( cd_empresa_p empresa.cd_empresa%type, cd_estab_p estabelecimento.cd_estabelecimento%type, cd_centro_custo_orig_p centro_custo.cd_centro_custo%type, cd_centro_custo_dest_p centro_custo.cd_centro_custo%type, dt_ano_orig_p timestamp, dt_ano_dest_p timestamp, ie_orcado_real_p text, ie_sobrepor_p text, nm_usuario_p text) AS $body$
DECLARE


cd_centro_custo_dest_w		centro_custo.cd_centro_custo%type	:= cd_centro_custo_dest_p;
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;
dt_inicial_orig_w		timestamp;
dt_final_orig_w			timestamp;
dt_liberacao_w			timestamp;
dt_referencia_w			timestamp;
ie_vigente_w			varchar(1);
ie_situacao_w			varchar(1);
nr_seq_mes_ref_w		ctb_mes_ref.nr_sequencia%type;
nr_seq_orcamento_w		ctb_orcamento.nr_sequencia%type;
vl_orcado_w			ctb_orcamento.vl_orcado%type;

c_orcamento CURSOR FOR
SELECT	a.cd_estabelecimento,
	a.cd_conta_contabil,
	a.cd_centro_custo,
	a.vl_orcado,
	a.vl_realizado,
	a.nr_seq_mes_ref,
	a.ds_observacao,
	c.dt_referencia
from	ctb_mes_ref c,
	estabelecimento b,
	ctb_orcamento a
where	a.cd_estabelecimento	= b.cd_estabelecimento
and	c.nr_sequencia		= a.nr_seq_mes_ref
and	c.cd_empresa		= b.cd_empresa
and	b.cd_empresa		= cd_empresa_p
and	a.cd_centro_custo = coalesce(cd_centro_custo_orig_p, a.cd_centro_custo)
and	substr(ctb_obter_se_centro_usu_estab(a.cd_centro_custo, cd_empresa_p, a.cd_estabelecimento, nm_usuario_p),1,1) = 'S'
and	c.dt_referencia between dt_inicial_orig_w and dt_final_orig_w
and	a.cd_estabelecimento = coalesce(cd_estab_p, a.cd_estabelecimento);

BEGIN

dt_inicial_orig_w	:= trunc(dt_ano_orig_p,'yyyy');
dt_final_orig_w		:= fim_ano(dt_ano_orig_p);

for vet in c_orcamento loop
	begin
	cd_centro_custo_dest_w	:= coalesce(cd_centro_custo_dest_p, vet.cd_centro_custo);
	dt_referencia_w		:= trunc(to_date('01/' || to_char(vet.dt_referencia,'MM') || '/' || to_char(dt_ano_dest_p,'YYYY'),'dd/mm/yyyy'),'mm');
	ie_vigente_w		:= substr(obter_se_conta_vigente(vet.cd_conta_contabil, dt_referencia_w),1,1);
	
	select	max(a.nr_sequencia)
	into STRICT	nr_seq_mes_ref_w
	from	ctb_mes_ref a
	where	a.cd_empresa	= cd_empresa_p
	and	a.dt_referencia	= dt_referencia_w;
	
	select ie_situacao
	into STRICT ie_situacao_w
	from conta_contabil
	where cd_conta_contabil = vet.cd_conta_contabil;
	
	select	max(a.nr_sequencia)
	into STRICT	nr_seq_orcamento_w
	from	ctb_orcamento a
	where	a.cd_estabelecimento	= vet.cd_estabelecimento
	and	a.cd_centro_custo	= cd_centro_custo_dest_w
	and	a.cd_conta_contabil	= vet.cd_conta_contabil
	and	a.nr_seq_mes_ref	= nr_seq_mes_ref_w;
	
	if (coalesce(nr_seq_orcamento_w::text, '') = '') and (ie_vigente_w = 'S') and (ie_situacao_w = 'A') and (nr_seq_mes_ref_w IS NOT NULL AND nr_seq_mes_ref_w::text <> '') then
	
		select	nextval('ctb_orcamento_seq')
		into STRICT	nr_seq_orcamento_w
		;
		
		insert into ctb_orcamento(
			nr_sequencia,
			nr_seq_mes_ref,
			dt_atualizacao,
			nm_usuario,
			cd_estabelecimento,
			cd_conta_contabil,
			cd_centro_custo,
			vl_original,
			vl_orcado,
			vl_realizado,
			ds_observacao,
			ie_cenario,
			ie_origem_orc)
		values (	nr_seq_orcamento_w,
			nr_seq_mes_ref_w,
			clock_timestamp(),
			nm_usuario_p,
			vet.cd_estabelecimento,
			vet.cd_conta_contabil,
			cd_centro_custo_dest_w,
			CASE WHEN ie_orcado_real_p='P' THEN  vet.vl_realizado  ELSE vet.vl_orcado END ,
			CASE WHEN ie_orcado_real_p='P' THEN  vet.vl_realizado  ELSE vet.vl_orcado END ,
			0,
			vet.ds_observacao,
			'N',
			'SIS');
			
	elsif (nr_seq_orcamento_w IS NOT NULL AND nr_seq_orcamento_w::text <> '') and (ie_sobrepor_p = 'S') and (ie_situacao_w = 'A') and (ie_vigente_w = 'S') then
		begin
		select	max(dt_liberacao)
		into STRICT	dt_liberacao_w
		from	ctb_orcamento
		where	nr_seq_mes_ref		= nr_seq_mes_ref_w
		and	cd_conta_contabil	= vet.cd_conta_contabil
		and	cd_centro_custo		= cd_centro_custo_dest_w
		and	cd_estabelecimento	= vet.cd_estabelecimento;

		if (coalesce(dt_liberacao_w::text, '') = '') then
			begin
			update	ctb_orcamento set
				dt_atualizacao		= clock_timestamp(),
				nm_usuario		= nm_usuario_p,
				vl_original		= CASE WHEN ie_orcado_real_p='P' THEN  vet.vl_realizado  ELSE vet.vl_orcado END ,
				vl_orcado		= CASE WHEN ie_orcado_real_p='P' THEN  vet.vl_realizado  ELSE vet.vl_orcado END
			where	nr_sequencia		= nr_seq_orcamento_w;
			end;
		end if;
		end;
	end if;
	
	end;
end loop;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_duplicar_orc_anual ( cd_empresa_p empresa.cd_empresa%type, cd_estab_p estabelecimento.cd_estabelecimento%type, cd_centro_custo_orig_p centro_custo.cd_centro_custo%type, cd_centro_custo_dest_p centro_custo.cd_centro_custo%type, dt_ano_orig_p timestamp, dt_ano_dest_p timestamp, ie_orcado_real_p text, ie_sobrepor_p text, nm_usuario_p text) FROM PUBLIC;
