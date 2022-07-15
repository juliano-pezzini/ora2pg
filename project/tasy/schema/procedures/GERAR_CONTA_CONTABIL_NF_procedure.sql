-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_conta_contabil_nf ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ X ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
Parâmetro 40 - [469] -  Obter a conta contábil do emitente, nos casos de nota fiscal de saída para pessoa física
-------------------------------------------------------------------------------------------------------------------
Referências:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
cd_conta_contabil_w		varchar(20);
cd_estabelecimento_w		smallint;
cd_cgc_w			varchar(14);
nr_sequencia_w			bigint;
qt_registro_w			bigint;
pr_contabil_w			double precision;
vl_total_nota_w			double precision;
vl_contabil_w			double precision;
ie_regra_nf_mat_w		varchar(2);
vl_total_contabil_w		double precision;
vl_total_ajuste_w		double precision;
cd_operacao_nf_w		bigint;
cd_pessoa_fisica_w		nota_fiscal.cd_pessoa_fisica%type;
ie_cc_emitente_w		varchar(255);
ie_entrada_saida_w		varchar(255);
cd_cgc_emitente_w		nota_fiscal.cd_cgc_emitente%type;
cd_cgc_nf_w			nota_fiscal.cd_cgc%type;

c01 CURSOR FOR
	SELECT	a.nr_item_nf nr_item_nf,
		a.cd_material cd_material,
		a.vl_liquido vl_item,
		a.cd_procedimento,
		a.ie_origem_proced
	from	nota_fiscal_item a
	where	a.nr_sequencia	= nr_sequencia_p
	and	qt_registro_w > 0
	order by
		1;

Vet01 C01%RowType;

c02 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.cd_conta_contabil,
		a.vl_contabil
	from	nota_fiscal_conta a
	where	a.nr_seq_nf	= nr_sequencia_p
	and	a.vl_contabil	<> 0
	and	vl_total_contabil_w <> vl_total_nota_w;

vet02	C02%RowType;


BEGIN


select	cd_estabelecimento,
	--decode(obter_se_nota_entrada_saida(nr_sequencia),'E',cd_cgc_emitente,'S',cd_cgc),
	coalesce(vl_total_nota,0),
	cd_operacao_nf,
	cd_pessoa_fisica,
	obter_se_nota_entrada_saida(nr_sequencia) ie_entrada_saida,
	cd_cgc_emitente,
	cd_cgc
into STRICT	cd_estabelecimento_w,
	--cd_cgc_w,
	vl_total_nota_w,
	cd_operacao_nf_w,
	cd_pessoa_fisica_w,
	ie_entrada_saida_w,
	cd_cgc_emitente_w,
	cd_cgc_nf_w
from	nota_fiscal
where	nr_sequencia	= nr_sequencia_p;

cd_cgc_w	:= null;

if (ie_entrada_saida_w = 'E') then
	cd_cgc_w	:= cd_cgc_emitente_w;
elsif (ie_entrada_saida_w = 'S') then
	cd_cgc_w	:= cd_cgc_nf_w;
end if;

if (coalesce(cd_cgc_w,'X') <> 'X') then
	select	count(1)
	into STRICT	qt_registro_w
	from	pessoa_jur_conta_nf
	where	cd_cgc	= cd_cgc_w  LIMIT 1;
else
	ie_cc_emitente_w := Obter_Param_Usuario(40, 469, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_cc_emitente_w);

	if (coalesce(ie_cc_emitente_w, 'N') = 'S') then
		cd_pessoa_fisica_w	:= null;

		if (ie_entrada_saida_w = 'S') then
			cd_cgc_w	:= cd_cgc_emitente_w;
		end if;

		select	count(1)
		into STRICT	qt_registro_w
		from	pessoa_jur_conta_nf
		where	cd_cgc	= cd_cgc_w  LIMIT 1;
	else
		select	count(1)
		into STRICT	qt_registro_w
		from	pessoa_fis_conta_nf
		where	cd_pessoa_fisica	= cd_pessoa_fisica_w  LIMIT 1;
	end if;
end if;

if (qt_registro_w > 0) then
	begin
	delete from nota_fiscal_conta
	where	nr_seq_nf	= nr_sequencia_p;

	select	coalesce(max(ie_regra_nf_mat),'N')
	into STRICT	ie_regra_nf_mat_w
	from	parametro_compras;

	open C01;
	loop
	fetch C01 into
		Vet01;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		if (vet01.cd_material IS NOT NULL AND vet01.cd_material::text <> '')and (coalesce(cd_pessoa_fisica_w::text, '') = '') and (ie_regra_nf_mat_w = 'N')then
			cd_conta_contabil_w := obter_conta_pj_nf(	cd_estabelecimento_w, cd_cgc_w, Vet01.cd_material, cd_operacao_nf_w, cd_conta_contabil_w, nr_sequencia_p);
		end if;

		if (vet01.cd_material IS NOT NULL AND vet01.cd_material::text <> '')and (coalesce(cd_pessoa_fisica_w::text, '') = '') and (ie_regra_nf_mat_w = 'S')then
			cd_conta_contabil_w := obter_conta_pj_nf_rat(	cd_estabelecimento_w, cd_cgc_w, Vet01.cd_material, cd_operacao_nf_w, cd_conta_contabil_w, nr_sequencia_p);
		end if;

		if (cd_conta_contabil_w = '0')and (vet01.cd_material IS NOT NULL AND vet01.cd_material::text <> '')and (coalesce(cd_pessoa_fisica_w::text, '') = '') and (ie_regra_nf_mat_w = 'S')then
			cd_conta_contabil_w := obter_conta_pj(	cd_cgc_w, cd_conta_contabil_w);
		end if;
		if (vet01.cd_procedimento IS NOT NULL AND vet01.cd_procedimento::text <> '') and (coalesce(cd_pessoa_fisica_w::text, '') = '') and (vet01.ie_origem_proced IS NOT NULL AND vet01.ie_origem_proced::text <> '') then
			cd_conta_contabil_w := obter_conta_pj_proced_nf(	cd_estabelecimento_w, cd_cgc_w, vet01.cd_procedimento, vet01.ie_origem_proced, cd_operacao_nf_w, cd_conta_contabil_w, nr_sequencia_p);
		end if;

		if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then
			cd_conta_contabil_w := obter_conta_pf_nf(	cd_estabelecimento_w, cd_pessoa_fisica_w, vet01.cd_material, vet01.cd_procedimento, vet01.ie_origem_proced, cd_operacao_nf_w, cd_conta_contabil_w, null, nr_sequencia_p);
		end if;

		if (cd_conta_contabil_w IS NOT NULL AND cd_conta_contabil_w::text <> '') then
			select	count(1)
			into STRICT	qt_registro_w
			from	nota_fiscal_conta
			where	nr_seq_nf		= nr_sequencia_p
			and	cd_conta_contabil	= cd_conta_contabil_w  LIMIT 1;

			if (qt_registro_w = 0) then
				insert into nota_fiscal_conta(nr_sequencia,
					nr_seq_nf,
					cd_conta_contabil,
					vl_contabil,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec)
				values (nextval('nota_fiscal_conta_seq'),
					nr_sequencia_p,
					cd_conta_contabil_w,
					Vet01.vl_item,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p);
			else
				update 	nota_fiscal_conta
				set	vl_contabil		= coalesce(vl_contabil,0) + Vet01.vl_item
				where	nr_seq_nf		= nr_sequencia_p
				and	cd_conta_contabil	= cd_conta_contabil_w;
			end if;
		end if;
		end;
	end loop;
	close C01;

	select	coalesce(sum(vl_contabil),0)
	into STRICT	vl_total_contabil_w
	from	nota_fiscal_conta
	where	nr_seq_nf	= nr_sequencia_p;

	vl_total_ajuste_w	:= 0;

	open C02;
	loop
	fetch C02 into
		nr_sequencia_w,
		cd_conta_contabil_w,
		vl_contabil_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		pr_contabil_w		:= (dividir(vl_contabil_w, vl_total_contabil_w) * 100);
		vl_contabil_w		:= (vl_total_nota_w * dividir(pr_contabil_w,100));
		vl_total_ajuste_w	:= vl_total_ajuste_w + vl_contabil_w;

		update	nota_fiscal_conta
		set	vl_contabil	= vl_contabil_w
		where	nr_sequencia	= nr_sequencia_w;
		end;
	end loop;
	close C02;

	/*Ajuste possíveis diferenças de rateio no último registro ajustado*/

	if (vl_total_ajuste_w <> 0) then
		vl_contabil_w	:= coalesce(vl_total_nota_w - vl_total_ajuste_w,0);

		update	nota_fiscal_conta
		set	vl_contabil	= vl_contabil + vl_contabil_w
		where	nr_sequencia	= nr_sequencia_w;
	end if;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_conta_contabil_nf ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

