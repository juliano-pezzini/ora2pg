-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fin_gerar_classif_tit_rec_gv ( nr_titulo_p titulo_receber.nr_titulo%type, nr_seq_fat_gv_p fin_faturamento_gv.nr_sequencia%type, nm_usuario_p text, ie_commit_p text default 'N') AS $body$
DECLARE



cd_empresa_w				empresa.cd_empresa%type;
dt_emissao_w				titulo_receber.dt_Emissao%type;
i					integer	:= 0;
nr_seq_classif_w			titulo_receber_classif.nr_sequencia%type;
vl_transporte_w				via_reserva.vl_reserva%type;
vl_hospedagem_w				via_reserva.vl_reserva%type;

type reg_classif is table of titulo_receber_classif%rowtype index by integer;

titulo_receber_classif_w		reg_classif;

c_despesas_gv CURSOR FOR
SELECT	b.nr_seq_viagem,
	b.vl_despesa
from	fin_faturamento_gv_vinc b,
	fin_faturamento_gv a
where	a.nr_sequencia	= b.nr_seq_fat_gv
and	a.nr_sequencia	= nr_seq_fat_gv_p;

c02 CURSOR(nr_seq_viagem_p	bigint) FOR
SELECT	a.cd_centro_custo,
	a.nr_seq_classif_desp,
	a.ie_responsavel_custo,
	a.vl_despesa
from	via_despesa a,
	via_relat_desp b
where	a.nr_seq_relat = b.nr_sequencia
and	b.nr_seq_viagem= nr_seq_viagem_p
and	a.ie_responsavel_custo = 'T'
and	a.ie_tipo_despesa <> 'T';

c03 CURSOR(nr_seq_viagem_p	bigint) FOR
SELECT	a.ie_responsavel_custo,
	a.cd_centro_custo,
	sum(coalesce(a.vl_reserva, 0)) vl_reserva
from	via_reserva a
where	a.nr_seq_viagem 	= nr_seq_viagem_p
and	a.ie_responsavel_custo 	= 'T'
and	(a.nr_seq_meio_transp IS NOT NULL AND a.nr_seq_meio_transp::text <> '')
and 	coalesce(ie_cancelamento, 'X') <> 'C'
group by a.ie_responsavel_custo,
	 a.cd_centro_custo;

c04 CURSOR(nr_seq_viagem_p	bigint) FOR
SELECT	a.ie_responsavel_custo,
	a.cd_centro_custo,
	sum(coalesce(obter_valor_total_hotel(a.nr_sequencia),0)) vl_reserva
from	via_reserva a
where	a.nr_seq_viagem 	= nr_seq_viagem_p
and	a.ie_responsavel_custo	= 'T'
and	(a.nr_seq_hotel IS NOT NULL AND a.nr_seq_hotel::text <> '')
and 	coalesce(ie_cancelamento, 'X') <> 'C'
group by 	a.ie_responsavel_custo,
		a.cd_centro_custo;
BEGIN

titulo_receber_classif_w.delete;

select	obter_empresa_estab(a.cd_estabelecimento),
	dt_emissao
into STRICT	cd_empresa_w,
	dt_emissao_w
from	titulo_receber a
where	a.nr_titulo	= nr_titulo_p;

for viagem in c_despesas_gv loop
	begin


	/* Reserva de viagem*/

	for vet in c03(viagem.nr_seq_viagem) loop
		begin
		i	:= i + 1;

		titulo_receber_classif_w[i].nr_titulo		:= nr_titulo_p;
		titulo_receber_classif_w[i].nr_sequencia	:= i;
		titulo_receber_classif_w[i].cd_centro_custo	:= vet.cd_centro_custo;
		titulo_receber_classif_w[i].cd_conta_contabil	:= ctb_obter_conta_desp_viagem(cd_empresa_w, 'R', null, vet.ie_responsavel_custo, 'RV', dt_emissao_w);
		titulo_receber_classif_w[i].vl_classificacao	:= vet.vl_reserva;
		end;
	end loop;

	/*Reserva de hospedagem*/

	for vet in c04(viagem.nr_seq_viagem) loop
		begin
		i	:= i + 1;

		titulo_receber_classif_w[i].nr_titulo		:= nr_titulo_p;
		titulo_receber_classif_w[i].nr_sequencia	:= i;
		titulo_receber_classif_w[i].cd_centro_custo	:= vet.cd_centro_custo;
		titulo_receber_classif_w[i].cd_conta_contabil	:= ctb_obter_conta_desp_viagem(cd_empresa_w, 'R', null, vet.ie_responsavel_custo, 'RH', dt_emissao_w);
		titulo_receber_classif_w[i].vl_classificacao	:= vet.vl_reserva;
		end;
	end loop;


	for vet in c02(viagem.nr_seq_viagem) loop
		begin
		i	:= i + 1;

		titulo_receber_classif_w[i].nr_titulo		:= nr_titulo_p;
		titulo_receber_classif_w[i].nr_sequencia	:= i;
		titulo_receber_classif_w[i].cd_centro_custo	:= vet.cd_centro_custo;
		titulo_receber_classif_w[i].cd_conta_contabil	:= ctb_obter_conta_desp_viagem(cd_empresa_w, 'R', vet.nr_seq_classif_desp, vet.ie_responsavel_custo, 'RD', dt_emissao_w);
		titulo_receber_classif_w[i].vl_classificacao	:= vet.vl_despesa;

		end;
	end loop;
	end;
end loop;

if (i >0) then
	delete	FROM titulo_receber_classif
	where	nr_titulo	= nr_titulo_p;
end if;

for i in 1..titulo_receber_classif_w.Count loop
	begin
	select	coalesce(max(a.nr_sequencia),0)
	into STRICT	nr_seq_classif_w
	from	titulo_receber_classif a
	where	nr_titulo		= nr_titulo_p
	and	cd_centro_custo		= titulo_receber_classif_w[i].cd_centro_custo
	and	cd_conta_contabil	= titulo_receber_classif_w[i].cd_conta_contabil;

	if (nr_seq_classif_w != 0) then
		update	titulo_receber_classif a
		set	vl_classificacao	= vl_classificacao + coalesce(titulo_receber_classif_w[i].vl_classificacao,0)
		where	nr_titulo	= nr_titulo_p
		and	nr_sequencia	= nr_seq_classif_w;
	else
		select	coalesce(max(a.nr_sequencia),0) + 1
		into STRICT	nr_seq_classif_w
		from	titulo_receber_classif a
		where	nr_titulo		= nr_titulo_p;

		insert into titulo_receber_classif(
			nr_titulo,
			nr_sequencia,
			cd_centro_custo,
			cd_conta_contabil,
			vl_classificacao,
			nm_usuario,
			dt_atualizacao)
		values (	nr_titulo_p,
			nr_seq_classif_w,
			titulo_receber_classif_w[i].cd_centro_custo,
			titulo_receber_classif_w[i].cd_conta_contabil,
			titulo_receber_classif_w[i].vl_classificacao,
			nm_usuario_p,
			clock_timestamp());
	end if;
	end;
end loop;

if (nr_seq_classif_w > 0) then
	begin
	if (ie_commit_p = 'S') then
		commit;
	end if;

	titulo_receber_classif_w.delete;

	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fin_gerar_classif_tit_rec_gv ( nr_titulo_p titulo_receber.nr_titulo%type, nr_seq_fat_gv_p fin_faturamento_gv.nr_sequencia%type, nm_usuario_p text, ie_commit_p text default 'N') FROM PUBLIC;

