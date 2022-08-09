-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_gerar_interf_i150_ecd ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Gerar as informações dos registros de:
	"SALDOS PERIÓDICOS ¿ IDENTIFICAÇÃO DO PERÍODO" - I150
	"DETALHE DOS SALDOS PERIÓDICOS" - I155
	"TRANSFERÊNCIA DE SALDOS DE PLANO DE CONTAS ANTERIOR" - I157
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta:
[ X ]  Objetos do dicionário [  ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atenção:
	IE_CONSOLIDA_EMPRESA, pois irá gerar um registro para cada estabelecimento
	da empresa se estiver como "Sim".

	IE_APRES_CONTA_CTB - Campo "Apresentação conta" da pasta "Regra"
		CD - Código
		CL - Classificação
		CP - Classificação sem os pontos
-------------------------------------------------------------------------------------------------------------------

Referências:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
dt_inicio_w			timestamp;
dt_fim_w			timestamp;
cd_conta_contabil_w		varchar(40);
/* Valores formatados */

vl_saldo_inicial_ww		varchar(80);
vl_debito_ww			varchar(80);
vl_credito_ww			varchar(80);
vl_saldo_final_ww		varchar(80);
nr_linha_w			bigint	:= qt_linha_p;
nr_seq_registro_w		bigint	:= nr_sequencia_p;
ds_arquivo_w			varchar(4000);
ds_compl_arquivo_w		varchar(4000);
ds_linha_w			varchar(8000);
sep_w				varchar(1)	:= '|';
tp_registro_w			varchar(15);
ie_apres_conta_ctb_w		varchar(15);
nr_seq_mes_ref_w		ctb_saldo_alteracao_conta.nr_seq_mes_ref%type;
nr_seq_mes_ref_ant_w		ctb_saldo_alteracao_conta.nr_seq_mes_ref_ant%type;
cd_conta_contabi_w		ctb_saldo_alteracao_conta.cd_conta_contabil%type;
cd_conta_contabil_ant_w		ctb_saldo_alteracao_conta.cd_conta_contabil_ant%type;
cd_centro_custo_w		ctb_saldo_alteracao_conta.cd_centro_custo%type;
vl_saldo_w			ctb_saldo_alteracao_conta.vl_saldo%type;
ie_consolida_empresa_w		ctb_regra_sped.ie_consolida_empresa%type;
nr_seq_regra_sped_w		bigint;
ie_gerar_157_w			varchar(2);
dt_fim_contabil_w		centro_custo.dt_fim_contabil%type;
dt_sit_esp_w			timestamp;
nr_seq_sit_esp_w		ctb_sit_especial_empresa.nr_sequencia%type;
vl_saldo_ini_w			double precision;
ie_debito_credito_inicial_w	varchar(1);
dt_referencia_w			timestamp;
nr_seq_mes_ant_w		ctb_mes_ref.nr_sequencia%type;

c_periodo CURSOR FOR
	SELECT	distinct
		CASE WHEN trunc(a.dt_inicial,'mm')=trunc(dt_inicio_p, 'mm') THEN  trunc(dt_inicio_p)  ELSE a.dt_inicial END  dt_inicial,
		CASE WHEN trunc(a.dt_final,'mm')=trunc(dt_fim_p, 'mm') THEN  fim_dia(dt_fim_p)  ELSE a.dt_final END  dt_final
	from   	ecd_saldo_periodico_v a
	where	a.cd_empresa 		= cd_empresa_p
	and	a.cd_estabelecimento 	= cd_estabelecimento_p
	and	a.tp_registro 		= 1
	and	ie_consolida_empresa_w	= 'N'
	and	a.dt_inicial between trunc(dt_inicio_p,'mm') and fim_dia(dt_fim_p)
	
union all

	SELECT	distinct
		CASE WHEN trunc(a.dt_inicial,'mm')=trunc(dt_inicio_p, 'mm') THEN  trunc(dt_inicio_p)  ELSE trunc(a.dt_inicial) END  dt_inicial,
		CASE WHEN trunc(a.dt_final,'mm')=trunc(dt_fim_p, 'mm') THEN  fim_dia(dt_fim_p)  ELSE fim_dia(a.dt_final) END  dt_final
	from   	ecd_saldo_periodico_v a,
		estabelecimento b
	where	a.cd_empresa 		= cd_empresa_p
	and	a.cd_estabelecimento	= b.cd_estabelecimento
	and	coalesce(b.ie_gerar_sped,'S') = 'S'
	and	a.tp_registro 		= 1
	and	ie_consolida_empresa_w	= 'S'
	and	a.dt_inicial between trunc(dt_inicio_p,'mm') and fim_dia(dt_fim_p)
	order by
		1;

c_detalhe_saldo CURSOR FOR
	SELECT	a.cd_conta_contabil,
		a.cd_classificacao,
		CASE WHEN a.ie_centro_custo='S' THEN  a.cd_centro_custo  ELSE null END  cd_centro_custo,
		a.ie_debito_credito_inicial,
		sum(coalesce(a.vl_saldo_inicial,0)) vl_saldo_inicial,
		sum(coalesce(a.vl_debito,0)) vl_debito,
		sum(coalesce(a.vl_credito,0)) vl_credito,
		sum(coalesce(a.vl_saldo_final,0)) vl_saldo_final,
		substr(ctb_obter_situacao_saldo(a.cd_conta_contabil, a.vl_saldo_final),1,1) ie_debito_credito_final
	from	ecd_saldo_periodico_v	a,
		estabelecimento b
	where	a.cd_estabelecimento 	= cd_estabelecimento_p
	and	a.cd_empresa 		= cd_empresa_p
	and	a.cd_estabelecimento 	= b.cd_estabelecimento
	and	a.tp_registro		= 2
	/* and	substr(obter_se_conta_vigente(a.cd_conta_contabil, a.dt_inicial), 1, 1) = 'S' */

	and	exists (
		SELECT	1
		
		where	coalesce(a.cd_conta_contabil::text, '') = ''
		
union all

		select	1
		from	conta_contabil x
		where	x.cd_conta_contabil = a.cd_conta_contabil
		and	substr(obter_se_vigencia_periodo(x.dt_inicio_vigencia,x.dt_fim_vigencia,dt_inicio_p,dt_fim_p,'S'),1,1) = 'S'
		)
	and	ie_consolida_empresa_w	= 'N'
	and	coalesce(b.ie_gerar_sped,'S')	= 'S'
	and	a.dt_inicial between dt_inicio_w and dt_fim_w
	group	by	a.cd_conta_contabil,
			a.cd_classificacao,
			CASE WHEN a.ie_centro_custo='S' THEN  a.cd_centro_custo  ELSE null END ,
			a.ie_debito_credito_inicial,
			substr(ctb_obter_situacao_saldo(a.cd_conta_contabil, a.vl_saldo_final),1,1)
	
union all

	select	a.cd_conta_contabil,
		a.cd_classificacao,
		CASE WHEN a.ie_centro_custo='S' THEN  a.cd_centro_custo  ELSE null END  cd_centro_custo,
		substr(ctb_obter_situacao_saldo(a.cd_conta_contabil, sum(coalesce(a.vl_saldo_inicial,0))),1,1) ie_debito_credito_inicial,
		sum(coalesce(a.vl_saldo_inicial,0)) vl_saldo_inicial,
		sum(coalesce(a.vl_debito,0)) vl_debito,
		sum(coalesce(a.vl_credito,0)) vl_credito,
		sum(coalesce(a.vl_saldo_final,0)) vl_saldo_final,
		substr(ctb_obter_situacao_saldo(a.cd_conta_contabil, sum(coalesce(a.vl_saldo_final,0))),1,1) ie_debito_credito_final
	from	ecd_saldo_periodico_v	a,
		estabelecimento b
	where	a.cd_empresa 		= cd_empresa_p
	and	a.cd_estabelecimento	= b.cd_estabelecimento
	and	a.tp_registro		= 2
	/* and	substr(obter_se_conta_vigente(a.cd_conta_contabil, a.dt_inicial), 1, 1) = 'S' */

	and	exists (
		select	1
		
		where	coalesce(a.cd_conta_contabil::text, '') = ''
		
union all

		select	1
		from	conta_contabil x
		where	x.cd_conta_contabil = a.cd_conta_contabil
		and	substr(obter_se_vigencia_periodo(x.dt_inicio_vigencia,x.dt_fim_vigencia,dt_inicio_p,dt_fim_p,'S'),1,1) = 'S'
		)
	and	ie_consolida_empresa_w	= 'S'
	and coalesce(b.ie_scp, 'N')	!= 'S'
	and	coalesce(b.ie_gerar_sped,'S')	= 'S'
	and	a.dt_inicial between dt_inicio_w and dt_fim_w
	group	by	a.cd_conta_contabil,
			a.cd_classificacao,
			CASE WHEN a.ie_centro_custo='S' THEN  a.cd_centro_custo  ELSE null END;

vet02	c_detalhe_saldo%RowType;

c_trans_saldo CURSOR FOR
	SELECT	a.cd_conta_contabil_ant,
		a.cd_centro_custo,
		a.vl_saldo
	from	ctb_mes_ref			b,
		ctb_saldo_alteracao_conta	a
	where	b.nr_sequencia		= a.nr_seq_mes_ref
	and	a.cd_conta_contabil	= vet02.cd_conta_contabil
	and	b.dt_referencia	between dt_inicio_w and dt_fim_w;

c01 CURSOR FOR
	SELECT	a.vl_debito,
		a.vl_credito,
		a.vl_saldo_ant,
		a.vl_saldo,
		a.cd_conta_contabil,
		a.cd_centro_custo,
		a.ie_deb_cred_ant,
		a.ie_deb_cred,
		a.cd_estabelecimento
	from	ctb_saldo_periodo a
	where	a.nr_seq_sit_especial = nr_seq_sit_esp_w
	and	trunc(a.dt_saldo) between trunc(dt_inicio_p) and fim_dia(dt_fim_p)
	and	((a.vl_debito <> 0) or (a.vl_credito <> 0) or (a.vl_saldo_ant <> 0) or (a.vl_saldo <> 0));

c01_w		c01%rowtype;

nr_vetor_w			bigint := 0;
type registro is table of ctb_sped_registro%RowType index by integer;
ctb_sped_registro_w		registro;


BEGIN
select	coalesce(max(a.ie_apres_conta_ctb), 'CD'),
	coalesce(max(a.ie_consolida_empresa), 'N')
into STRICT	ie_apres_conta_ctb_w,
	ie_consolida_empresa_w
from	ctb_regra_sped		a,
	ctb_sped_controle	b
where	a.nr_sequencia	= b.nr_seq_regra_sped
and	b.nr_sequencia	= nr_seq_controle_p;


select	coalesce(nr_seq_regra_sped,0)
into STRICT	nr_seq_regra_sped_w
from	ctb_sped_controle
where	nr_sequencia	= nr_seq_controle_p;

if (nr_seq_regra_sped_w <> 0)then

	select	max(coalesce(ie_gerar,'N'))
	into STRICT	ie_gerar_157_w
	from	ctb_regra_sped_registro
	where	nr_seq_regra_sped	= nr_seq_regra_sped_w
	and	cd_registro = 'I157'
	order by
		nr_sequencia;
end if;

open c_periodo;
loop
fetch c_periodo into
	dt_inicio_w,
	dt_fim_w;
EXIT WHEN NOT FOUND; /* apply on c_periodo */
	begin
	tp_registro_w	:= 'I150';
	ds_linha_w	:= substr(	sep_w || 'I150' 				||
					sep_w || to_char(dt_inicio_w,'ddmmyyyy') 	||
					sep_w || to_char(dt_fim_w,'ddmmyyyy') 		||
					sep_w ,1,8000);

	ds_arquivo_w		:= substr(ds_linha_w,1,4000);
	ds_compl_arquivo_w	:= substr(ds_linha_w,4001,4000);
	nr_seq_registro_w	:= nr_seq_registro_w + 1;
	nr_linha_w		:= nr_linha_w + 1;

	nr_vetor_w		:= nr_vetor_w + 1;

	ctb_sped_registro_w[nr_vetor_w].nr_sequencia		:= nr_seq_registro_w;
	ctb_sped_registro_w[nr_vetor_w].ds_arquivo		:= ds_arquivo_w;
	ctb_sped_registro_w[nr_vetor_w].dt_atualizacao		:= clock_timestamp();
	ctb_sped_registro_w[nr_vetor_w].nm_usuario		:= nm_usuario_p;
	ctb_sped_registro_w[nr_vetor_w].dt_atualizacao_nrec	:= clock_timestamp();
	ctb_sped_registro_w[nr_vetor_w].nm_usuario_nrec		:= nm_usuario_p;
	ctb_sped_registro_w[nr_vetor_w].nr_seq_controle_sped	:= nr_seq_controle_p;
	ctb_sped_registro_w[nr_vetor_w].ds_arquivo_compl	:= ds_compl_arquivo_w;
	ctb_sped_registro_w[nr_vetor_w].cd_registro		:= tp_registro_w;
	ctb_sped_registro_w[nr_vetor_w].nr_linha		:= nr_linha_w;


	select	coalesce(max(a.nr_sequencia),0)
	into STRICT	nr_seq_sit_esp_w
	from	ctb_sit_especial_empresa a
	where	trunc(a.dt_situacao,'mm') = trunc(dt_inicio_w,'mm')
	and	a.cd_empresa = cd_empresa_p
	and	coalesce(a.cd_estabelecimento,cd_estabelecimento_p) = cd_estabelecimento_p;

	if (nr_seq_sit_esp_w <> 0) then
		begin
		select	trunc(a.dt_situacao)
		into STRICT	dt_sit_esp_w
		from	ctb_sit_especial_empresa a
		where	a.nr_sequencia = nr_seq_sit_esp_w;
		end;
	end if;

	if (nr_seq_sit_esp_w <> 0) then
		begin
		open c01;
		loop
		fetch c01 into
			c01_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			begin
			/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			INICIO
			+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
			tp_registro_w	:= 'I155';
			vl_saldo_inicial_ww	:= replace(replace(campo_mascara_virgula(c01_w.vl_saldo_ant),'.',''),'-','');
			vl_debito_ww		:= replace(replace(campo_mascara_virgula(c01_w.vl_debito),'.',''),'-','');
			vl_credito_ww		:= replace(replace(campo_mascara_virgula(c01_w.vl_credito),'.',''),'-','');
			vl_saldo_final_ww	:= replace(replace(campo_mascara_virgula(c01_w.vl_saldo),'.',''),'-','');

			ds_linha_w	:= substr(	sep_w || 'I155'					||
							sep_w || c01_w.cd_conta_contabil		||
							sep_w || c01_w.cd_centro_custo			||
							sep_w || vl_saldo_inicial_ww			||
							sep_w || c01_w.ie_deb_cred_ant			||
							sep_w || vl_debito_ww				||
							sep_w || vl_credito_ww				||
							sep_w || vl_saldo_final_ww			||
							sep_w || c01_w.ie_deb_cred			||
							sep_w, 1,8000);

			ds_arquivo_w		:= substr(ds_linha_w,1,4000);
			ds_compl_arquivo_w	:= substr(ds_linha_w,4001,4000);
			nr_seq_registro_w	:= nr_seq_registro_w + 1;
			nr_linha_w		:= nr_linha_w + 1;

			nr_vetor_w		:= nr_vetor_w + 1;

			ctb_sped_registro_w[nr_vetor_w].nr_sequencia		:= nr_seq_registro_w;
			ctb_sped_registro_w[nr_vetor_w].ds_arquivo		:= ds_arquivo_w;
			ctb_sped_registro_w[nr_vetor_w].dt_atualizacao		:= clock_timestamp();
			ctb_sped_registro_w[nr_vetor_w].nm_usuario		:= nm_usuario_p;
			ctb_sped_registro_w[nr_vetor_w].dt_atualizacao_nrec	:= clock_timestamp();
			ctb_sped_registro_w[nr_vetor_w].nm_usuario_nrec		:= nm_usuario_p;
			ctb_sped_registro_w[nr_vetor_w].nr_seq_controle_sped	:= nr_seq_controle_p;
			ctb_sped_registro_w[nr_vetor_w].ds_arquivo_compl	:= ds_compl_arquivo_w;
			ctb_sped_registro_w[nr_vetor_w].cd_registro		:= tp_registro_w;
			ctb_sped_registro_w[nr_vetor_w].nr_linha		:= nr_linha_w;
			ctb_sped_registro_w[nr_vetor_w].nr_doc_origem		:= vet02.cd_conta_contabil;

			if (nr_vetor_w >= 1000) then
				begin
				forall m in ctb_sped_registro_w.first..ctb_sped_registro_w.last
					insert into ctb_sped_registro values ctb_sped_registro_w(m);

				nr_vetor_w := 0;
				ctb_sped_registro_w.delete;

				commit;
				end;
			end if;
			/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			FINAL
			+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
			end;
		end loop;
		close c01;
		end;
	else
		begin
		open c_detalhe_saldo;
		loop
		fetch c_detalhe_saldo into
			vet02;
		EXIT WHEN NOT FOUND; /* apply on c_detalhe_saldo */
			begin

			tp_registro_w	:= 'I155';

			cd_conta_contabil_w	:= vet02.cd_conta_contabil;

			if (ie_apres_conta_ctb_w = 'CL') then
				cd_conta_contabil_w	:= vet02.cd_classificacao;
			elsif (ie_apres_conta_ctb_w = 'CP') then
				cd_conta_contabil_w	:= substr(replace(vet02.cd_classificacao, '.', ''), 1, 40);
			end if;

			select	max(dt_fim_contabil)
			into STRICT	dt_fim_contabil_w
			from	centro_custo
			where	cd_centro_custo	= vet02.cd_centro_custo;

			if 	((coalesce(vet02.cd_centro_custo,0) = 0) or (coalesce(dt_fim_contabil_w::text, '') = '') or
				((coalesce(vet02.cd_centro_custo,0) <> 0) and (trunc(dt_inicio_w) <= trunc(dt_fim_contabil_w)))) then
				begin

				if 	((vet02.vl_saldo_inicial <> 0) or (vet02.vl_debito <> 0)  or (vet02.vl_credito <> 0)  or (vet02.vl_saldo_final <> 0)) then
					begin
					vl_saldo_inicial_ww	:= replace(replace(campo_mascara_virgula(vet02.vl_saldo_inicial),'.',''),'-','');
					vl_debito_ww		:= replace(replace(campo_mascara_virgula(vet02.vl_debito),'.',''),'-','');
					vl_credito_ww		:= replace(replace(campo_mascara_virgula(vet02.vl_credito),'.',''),'-','');
					vl_saldo_final_ww	:= replace(replace(campo_mascara_virgula(vet02.vl_saldo_final),'.',''),'-','');

					ds_linha_w	:= substr(	sep_w || 'I155'					||
									sep_w || cd_conta_contabil_w 			||
									sep_w || vet02.cd_centro_custo 			||
									sep_w || vl_saldo_inicial_ww			||
									sep_w || vet02.ie_debito_credito_inicial	||
									sep_w || vl_debito_ww				||
									sep_w || vl_credito_ww				||
									sep_w || vl_saldo_final_ww			||
									sep_w || vet02.ie_debito_credito_final 		||
									sep_w, 1,8000);

					ds_arquivo_w		:= substr(ds_linha_w,1,4000);
					ds_compl_arquivo_w	:= substr(ds_linha_w,4001,4000);
					nr_seq_registro_w	:= nr_seq_registro_w + 1;
					nr_linha_w		:= nr_linha_w + 1;

					nr_vetor_w		:= nr_vetor_w + 1;

					ctb_sped_registro_w[nr_vetor_w].nr_sequencia		:= nr_seq_registro_w;
					ctb_sped_registro_w[nr_vetor_w].ds_arquivo		:= ds_arquivo_w;
					ctb_sped_registro_w[nr_vetor_w].dt_atualizacao		:= clock_timestamp();
					ctb_sped_registro_w[nr_vetor_w].nm_usuario		:= nm_usuario_p;
					ctb_sped_registro_w[nr_vetor_w].dt_atualizacao_nrec	:= clock_timestamp();
					ctb_sped_registro_w[nr_vetor_w].nm_usuario_nrec		:= nm_usuario_p;
					ctb_sped_registro_w[nr_vetor_w].nr_seq_controle_sped	:= nr_seq_controle_p;
					ctb_sped_registro_w[nr_vetor_w].ds_arquivo_compl	:= ds_compl_arquivo_w;
					ctb_sped_registro_w[nr_vetor_w].cd_registro		:= tp_registro_w;
					ctb_sped_registro_w[nr_vetor_w].nr_linha		:= nr_linha_w;
					ctb_sped_registro_w[nr_vetor_w].nr_doc_origem		:= vet02.cd_conta_contabil;

				if (ie_gerar_157_w = 'S')	then
					open c_trans_saldo;
					loop
					fetch c_trans_saldo into
						cd_conta_contabil_ant_w,
						cd_centro_custo_w,
						vl_saldo_w;
					EXIT WHEN NOT FOUND; /* apply on c_trans_saldo */
						begin
						if (ie_apres_conta_ctb_w = 'CL') then
							cd_conta_contabil_w	:= substr(ctb_obter_classif_conta(cd_conta_contabil_ant_w,null,add_months(dt_inicio_p,-1)),1,40);
						elsif (ie_apres_conta_ctb_w = 'CP') then
							cd_conta_contabil_w	:= cd_conta_contabil_ant_w;
						end if;

						tp_registro_w		:= 'I157';


						ds_linha_w		:= substr(	sep_w || 'I157'									||
											sep_w || cd_conta_contabil_w							||
											sep_w || cd_centro_custo_w							||
											sep_w || replace(replace(campo_mascara_virgula(vl_saldo_w),'.',''),'-','')	||
											sep_w || vet02.ie_debito_credito_inicial					||
											sep_w,1,8000);

						ds_arquivo_w		:= substr(ds_linha_w,1,4000);
						ds_compl_arquivo_w	:= substr(ds_linha_w,4001,4000);
						nr_seq_registro_w	:= nr_seq_registro_w + 1;
						nr_linha_w		:= nr_linha_w + 1;

						nr_vetor_w		:= nr_vetor_w + 1;

						ctb_sped_registro_w[nr_vetor_w].nr_sequencia		:= nr_seq_registro_w;
						ctb_sped_registro_w[nr_vetor_w].ds_arquivo		:= ds_arquivo_w;
						ctb_sped_registro_w[nr_vetor_w].dt_atualizacao		:= clock_timestamp();
						ctb_sped_registro_w[nr_vetor_w].nm_usuario		:= nm_usuario_p;
						ctb_sped_registro_w[nr_vetor_w].dt_atualizacao_nrec	:= clock_timestamp();
						ctb_sped_registro_w[nr_vetor_w].nm_usuario_nrec		:= nm_usuario_p;
						ctb_sped_registro_w[nr_vetor_w].nr_seq_controle_sped	:= nr_seq_controle_p;
						ctb_sped_registro_w[nr_vetor_w].ds_arquivo_compl	:= ds_compl_arquivo_w;
						ctb_sped_registro_w[nr_vetor_w].cd_registro		:= tp_registro_w;
						ctb_sped_registro_w[nr_vetor_w].nr_linha		:= nr_linha_w;
						ctb_sped_registro_w[nr_vetor_w].nr_doc_origem		:= cd_conta_contabil_ant_w;

						if (nr_vetor_w >= 1000) then
							forall m in ctb_sped_registro_w.first..ctb_sped_registro_w.last
								insert into ctb_sped_registro values ctb_sped_registro_w(m);

							nr_vetor_w	:= 0;
							ctb_sped_registro_w.delete;

							commit;
						end if;
						end;
					end loop;
					close c_trans_saldo;
					end if;
					end;
				end if;
				end;
			end if;
			if (nr_vetor_w >= 1000) then
				forall m in ctb_sped_registro_w.first..ctb_sped_registro_w.last
					insert into ctb_sped_registro values ctb_sped_registro_w(m);

				nr_vetor_w	:= 0;
				ctb_sped_registro_w.delete;

				commit;
			end if;
			end;
		end loop;
		close c_detalhe_saldo;
		end;
	end if;

	if (nr_vetor_w >= 1000) then
		forall m in ctb_sped_registro_w.first..ctb_sped_registro_w.last
			insert into ctb_sped_registro values ctb_sped_registro_w(m);

		nr_vetor_w	:= 0;
		ctb_sped_registro_w.delete;

		commit;
	end if;
	end;
end loop;
close c_periodo;

forall m in ctb_sped_registro_w.first..ctb_sped_registro_w.last
	insert into ctb_sped_registro values ctb_sped_registro_w(m);

commit;
qt_linha_p	:= nr_linha_w;
nr_sequencia_p	:= nr_seq_registro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_gerar_interf_i150_ecd ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) FROM PUBLIC;
