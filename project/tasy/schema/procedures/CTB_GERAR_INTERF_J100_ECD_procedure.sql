-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_gerar_interf_j100_ecd ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) AS $body$
DECLARE


ds_identificador_w				varchar(5);
cd_aglutinacao_w				varchar(40);
cd_aglutinacao_ww				varchar(40);
ie_nivel_aglutinacao_w				integer;
cd_grupo_w					varchar(1);
ds_aglutinacao_w				varchar(255);
nr_seq_mes_ref_w				bigint;
vl_conta_w					double precision;
ie_situacao_w					varchar(2);
ie_debito_credito_w				varchar(2);
cd_instit_resp_cadastro_w			varchar(4);
cd_instituicao_w				varchar(21);
ds_arquivo_w					varchar(4000);
ds_compl_arquivo_w				varchar(4000);
ds_linha_w					varchar(8000);
nr_linha_w					bigint := qt_linha_p;
nr_seq_registro_w				bigint := nr_sequencia_p;
sep_w						varchar(1) := '|';
tp_registro_w					varchar(15) := 'J100';
nr_seq_demo_bp_w				ctb_sped_controle.nr_seq_demo_bp%type;
cd_classificacao_w				varchar(40);
ie_apres_conta_ctb_w				varchar(15);
cd_versao_w					ctb_regra_sped.cd_versao%type;
ie_periodo_w					ctb_regra_sped.ie_periodo%type;
vl_saldo_ini_w					double precision;
ie_debito_credito_ww				varchar(2);
ie_consolida_empresa_w				ctb_regra_sped.ie_consolida_empresa%type;
dt_referencia_w         			timestamp;
ie_grupo_balanco_ecd_w          		varchar(1) := 'A';
ind_saldo_ini_w         			varchar(1) := 'C';
ind_saldo_fim_w         			varchar(1) := 'C';
dt_fim_w					timestamp;

c_balanco CURSOR(
	dt_fim_pc  timestamp
	) FOR
	SELECT  ds_identificador,
			cd_aglutinacao,
			ie_nivel_aglutinacao,
			cd_grupo,
			ds_aglutinacao,
			vl_conta,
			a.ie_debito_credito,
			a.cd_classificacao,
			a.dt_referencia dt_referencia
	from	ecd_balanco_patrimonial_v a
	where	a.dt_referencia 	= dt_fim_pc
	and		a.cd_estabelecimento	= cd_estabelecimento_p
	and		ie_consolida_empresa_w = 'N'
	
union all

	SELECT  ds_identificador,
		cd_aglutinacao,
		ie_nivel_aglutinacao,
		cd_grupo,
		ds_aglutinacao,
		sum(vl_conta),
		'' ie_debito_credito,
		a.cd_classificacao,
		a.dt_referencia dt_referencia
	from	estabelecimento b,
		ecd_balanco_patrimonial_v a
	where	a.dt_referencia 	= dt_fim_pc
	and	a.cd_estabelecimento	= b.cd_estabelecimento
	and	a.cd_empresa		= cd_empresa_p
	and	ie_consolida_empresa_w = 'S'
	group by ds_identificador,
			cd_aglutinacao,
			ie_nivel_aglutinacao,
			cd_grupo,
			ds_aglutinacao,
			a.cd_classificacao,
			a.dt_referencia,
			a.cd_classificacao
		order by
			dt_referencia,
			cd_classificacao;

c_demonstrativo CURSOR FOR
	SELECT	a.nr_seq_rubrica cd_aglutinacao,
		a.qt_desl_esq nr_nivel,
		b.ie_grupo_balanco_ecd,
		a.ds_rubrica ds_aglutinacao,
		CASE WHEN coalesce(b.ie_total,'N')='N' THEN 'D'  ELSE 'T' END  ie_cod_agl,
		b.nr_seq_rubrica_sup cd_aglutinacao_sup,
		a.vl_1_coluna vl_conta,
		substr(ctb_obter_situacao_saldo_ecd(a.nr_seq_rubrica, 'J100',dt_fim_p, a.vl_1_coluna),1,1) ie_saldo,
		a.vl_2_coluna,
		substr(ctb_obter_situacao_saldo_ecd(a.nr_seq_rubrica,'J100',dt_inicio_p, a.vl_2_coluna),1,1) ie_saldo_ini
	from	ctb_modelo_rubrica	b,
		ctb_demo_rubrica_v	a
	where	a.nr_seq_rubrica	= b.nr_sequencia
	and	a.nr_seq_demo		= nr_seq_demo_bp_w
	and	ie_situacao		= 'A'
	and ((coalesce(a.vl_1_coluna,0) <> 0) or (coalesce(a.vl_2_coluna,0) <> 0))
	order by
		a.nr_seq_apres;

vet02	c_demonstrativo%RowType;


BEGIN
dt_fim_w := trunc(dt_fim_p,'mm');

select	coalesce(max(b.nr_seq_demo_bp),0),
	coalesce(max(a.cd_versao), '9.0'),
	coalesce(max(a.ie_periodo), 'A'),
	coalesce(max(ie_consolida_empresa), 'N')
into STRICT	nr_seq_demo_bp_w,
	cd_versao_w,
	ie_periodo_w,
	ie_consolida_empresa_w
from	ctb_sped_controle	b,
	ctb_regra_sped		a
where	a.nr_sequencia	= b.nr_seq_regra_sped
and	b.nr_sequencia	= nr_seq_controle_p;

select	max(nr_sequencia)
into STRICT	nr_seq_mes_ref_w
from	ctb_mes_ref
where	cd_empresa	= cd_empresa_p
and	dt_referencia	= dt_fim_w;

select	coalesce(max(a.ie_apres_conta_ctb),'CD')
into STRICT	ie_apres_conta_ctb_w
from	ctb_regra_sped		a,
	ctb_sped_controle	b
where	b.nr_seq_regra_sped 	= a.nr_sequencia
and	b.nr_sequencia		= nr_seq_controle_p;

if (nr_seq_demo_bp_w = -10) then /*Senao tiver Demonstrativo especifico, e exportado Ativo e Passivo - Inativo para a escritucao referente a 2018*/
	begin
	open c_balanco(
		dt_fim_pc => dt_fim_w
		);
	loop
	fetch c_balanco into
		ds_identificador_w,
		cd_aglutinacao_w,
		ie_nivel_aglutinacao_w,
		cd_grupo_w,
		ds_aglutinacao_w,
		vl_conta_w,
		ie_debito_credito_w,
		cd_classificacao_w,
		dt_referencia_w;
	EXIT WHEN NOT FOUND; /* apply on c_balanco */
		begin
		cd_aglutinacao_ww	:= cd_aglutinacao_w;

		if (ie_apres_conta_ctb_w = 'CL') then
			cd_aglutinacao_w	:= cd_classificacao_w;
		elsif (ie_apres_conta_ctb_w = 'CP') then
			cd_aglutinacao_w	:= substr(replace(cd_classificacao_w,'.',''),1,40);
		end if;

		if (ie_consolida_empresa_w = 'S')then
			ie_debito_credito_w := substr(ctb_obter_situacao_saldo(cd_aglutinacao_w, vl_conta_w),1,1);
		end if;

		ie_debito_credito_w	:=	replace(ie_debito_credito_w,'|','');

		if (cd_versao_w = '6.0') then
			begin
			vl_saldo_ini_w	:= 0;

			if (ie_periodo_w = 'A') then
				vl_saldo_ini_w	:= CTB_Obter_Saldo_Data_ecd(cd_estabelecimento_p,
									cd_aglutinacao_ww,
									null,
									add_months(dt_fim_p,-12),
									cd_empresa_p,
									ie_consolida_empresa_w);
			elsif (ie_periodo_w = 'T') then
				vl_saldo_ini_w	:= CTB_Obter_Saldo_Data_ecd(cd_estabelecimento_p,
									cd_aglutinacao_ww,
									null,
									add_months(dt_fim_p,-3),
									cd_empresa_p,
									ie_consolida_empresa_w);
			elsif (ie_periodo_w = 'M') then
				vl_saldo_ini_w	:= CTB_Obter_Saldo_Data_ecd(cd_estabelecimento_p,
									cd_aglutinacao_ww,
									null,
									trunc(dt_fim_p,'mm'),
									cd_empresa_p,
									ie_consolida_empresa_w);
			end if;

			ie_debito_credito_ww	:= substr(ctb_obter_situacao_saldo(cd_aglutinacao_ww, vl_saldo_ini_w),1,1);

			ds_linha_w	:= substr(	'|J100'						|| --01
							sep_w || cd_aglutinacao_w 			|| --02
							sep_w || ie_nivel_aglutinacao_w 		|| --03
							sep_w || cd_grupo_w				|| --04
							sep_w || ds_aglutinacao_w			|| --05
							sep_w || sped_obter_campo_valor(vl_conta_w) 	|| --06
							sep_w || ie_debito_credito_w			|| --07
							sep_w || sped_obter_campo_valor(vl_saldo_ini_w)	|| --08
							sep_w || ie_debito_credito_ww			|| --09
							sep_w || ''					|| --10
							sep_w,1,8000);
			end;
		elsif (cd_versao_w in ('2.0', '3.0', '4.0', '5.0')) then
			begin
			vl_saldo_ini_w	:= 0;

			if (ie_periodo_w = 'A') then
				vl_saldo_ini_w	:= CTB_Obter_Saldo_Data_ecd(cd_estabelecimento_p,
									cd_aglutinacao_ww,
									null,
									add_months(dt_fim_p,-12),
									cd_empresa_p,
									ie_consolida_empresa_w);
			elsif (ie_periodo_w = 'T') then
				vl_saldo_ini_w	:= CTB_Obter_Saldo_Data_ecd(cd_estabelecimento_p,
									cd_aglutinacao_ww,
									null,
									add_months(dt_fim_p,-3),
									cd_empresa_p,
									ie_consolida_empresa_w);
			elsif (ie_periodo_w = 'M') then
				vl_saldo_ini_w	:= CTB_Obter_Saldo_Data_ecd(cd_estabelecimento_p,
									cd_aglutinacao_ww,
									null,
									trunc(dt_fim_p,'mm'),
									cd_empresa_p,
									ie_consolida_empresa_w);
			end if;

			ie_debito_credito_ww	:= substr(ctb_obter_situacao_saldo(cd_aglutinacao_ww, vl_saldo_ini_w),1,1);

			ds_linha_w	:= substr(	'|J100'						|| --01
							sep_w || cd_aglutinacao_w 			|| --02
							sep_w || ie_nivel_aglutinacao_w 		|| --03
							sep_w || cd_grupo_w				|| --04
							sep_w || ds_aglutinacao_w			|| --05
							sep_w || sped_obter_campo_valor(vl_conta_w) 	|| --06
							sep_w || ie_debito_credito_w			|| --07
							sep_w || sped_obter_campo_valor(vl_saldo_ini_w)	|| --08
							sep_w || ie_debito_credito_ww			|| --09
							sep_w,1,8000);
			end;
		elsif (cd_versao_w = '1.0') then
			begin
			ds_linha_w	:= substr(	'|J100'						|| --01
							sep_w || cd_aglutinacao_w 			|| --02
							sep_w || ie_nivel_aglutinacao_w 		|| --03
							sep_w || cd_grupo_w				|| --04
							sep_w || ds_aglutinacao_w			|| --05
							sep_w || sped_obter_campo_valor(vl_conta_w) 	|| --06
							sep_w || ie_debito_credito_w			|| --07
							sep_w,1,8000);
			end;
		end if;

		ds_arquivo_w		:= substr(ds_linha_w,1,4000);
		ds_compl_arquivo_w	:= substr(ds_linha_w,4001,4000);
		nr_seq_registro_w	:= nr_seq_registro_w + 1;
		nr_linha_w		:= nr_linha_w + 1;

		insert into ctb_sped_registro(nr_sequencia,
			ds_arquivo,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_controle_sped,
			ds_arquivo_compl,
			cd_registro,
			nr_linha)
		values (nr_seq_registro_w,
			ds_arquivo_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_controle_p,
			ds_compl_arquivo_w,
			tp_registro_w,
			nr_linha_w);
		end;
	end loop;
	close c_balanco;
	end;
else
	begin
	open c_demonstrativo;
	loop
	fetch c_demonstrativo into
		vet02;
	EXIT WHEN NOT FOUND; /* apply on c_demonstrativo */
		begin
		if (cd_versao_w in ('7.0','8.0','9.0')) then
			begin

			if (vet02.ie_grupo_balanco_ecd = 2) then
				ie_grupo_balanco_ecd_w := 'P';
			else
				ie_grupo_balanco_ecd_w := 'A';
			end if;

			if (vet02.vl_2_coluna > 0 and vet02.ie_grupo_balanco_ecd = 1) then
				ind_saldo_ini_w := 'D';
			elsif (vet02.vl_2_coluna < 0 and vet02.ie_grupo_balanco_ecd = 1) then
				ind_saldo_ini_w := 'C';
			elsif (vet02.vl_2_coluna > 0 and vet02.ie_grupo_balanco_ecd = 2) then
				ind_saldo_ini_w := 'C';
			elsif (vet02.vl_2_coluna < 0 and vet02.ie_grupo_balanco_ecd = 2) then
				ind_saldo_ini_w := 'D';
			end if;

			if (vet02.vl_conta > 0 and vet02.ie_grupo_balanco_ecd = 1) then
				ind_saldo_fim_w := 'D';
			elsif (vet02.vl_conta < 0 and vet02.ie_grupo_balanco_ecd = 1) then
				ind_saldo_fim_w := 'C';
			elsif (vet02.vl_conta > 0 and vet02.ie_grupo_balanco_ecd = 2) then
				ind_saldo_fim_w := 'C';
			elsif (vet02.vl_conta < 0 and vet02.ie_grupo_balanco_ecd = 2) then
				ind_saldo_fim_w := 'D';
			end if;

			ds_linha_w	:= substr(	sep_w || tp_registro_w					|| --01
							sep_w || vet02.cd_aglutinacao 				|| --02
							sep_w || vet02.ie_cod_agl 				|| --03
							sep_w || vet02.nr_nivel 				|| --04
							sep_w || vet02.cd_aglutinacao_sup			|| --05
							sep_w || ie_grupo_balanco_ecd_w				|| --06
							sep_w || vet02.ds_aglutinacao				|| --07
							sep_w || sped_obter_campo_valor(vet02.vl_2_coluna)	|| --08
							sep_w || ind_saldo_ini_w				|| --09
							sep_w || sped_obter_campo_valor(vet02.vl_conta)		|| --10
							sep_w || ind_saldo_fim_w				|| --11
							sep_w || ''						|| --12
							sep_w,1,8000);
			end;
		elsif (cd_versao_w = '6.0') then
			begin
			ds_linha_w	:= substr(	sep_w || tp_registro_w					|| --01
							sep_w || vet02.cd_aglutinacao 				|| --02
							sep_w || vet02.nr_nivel 				|| --03
							sep_w || vet02.ie_grupo_balanco_ecd			|| --04
							sep_w || vet02.ds_aglutinacao				|| --05
							sep_w || sped_obter_campo_valor(vet02.vl_conta)		|| --06
							sep_w || vet02.ie_saldo					|| --07
							sep_w || sped_obter_campo_valor(vet02.vl_2_coluna)	|| --08
							sep_w || vet02.ie_saldo_ini				|| --09
							sep_w || ''						|| --10
							sep_w,1,8000);
			end;
		elsif (cd_versao_w in ('2.0', '3.0', '4.0', '5.0')) then
			begin
			ds_linha_w	:= substr(	sep_w || tp_registro_w					|| --01
							sep_w || vet02.cd_aglutinacao 				|| --02
							sep_w || vet02.nr_nivel 				|| --03
							sep_w || vet02.ie_grupo_balanco_ecd			|| --04
							sep_w || vet02.ds_aglutinacao				|| --05
							sep_w || sped_obter_campo_valor(vet02.vl_conta)		|| --06
							sep_w || vet02.ie_saldo					|| --07
							sep_w || sped_obter_campo_valor(vet02.vl_2_coluna)	|| --08
							sep_w || vet02.ie_saldo_ini				|| --09
							sep_w,1,8000);
			end;
		elsif (cd_versao_w = '1.0') then
			begin
			ds_linha_w	:= substr(	sep_w || tp_registro_w					|| --01
							sep_w || vet02.cd_aglutinacao 				|| --02
							sep_w || vet02.nr_nivel 				|| --03
							sep_w || vet02.ie_grupo_balanco_ecd			|| --04
							sep_w || vet02.ds_aglutinacao				|| --05
							sep_w || sped_obter_campo_valor(vet02.vl_conta)		|| --06
							sep_w || vet02.ie_saldo					|| --07
							sep_w,1,8000);
			end;
		end if;

		ds_arquivo_w		:= substr(ds_linha_w,1,4000);
		ds_compl_arquivo_w	:= substr(ds_linha_w,4001,4000);
		nr_seq_registro_w	:= nr_seq_registro_w + 1;
		nr_linha_w		:= nr_linha_w + 1;

		insert into ctb_sped_registro(nr_sequencia,
			ds_arquivo,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_controle_sped,
			ds_arquivo_compl,
			cd_registro,
			nr_linha)
		values (nr_seq_registro_w,
			ds_arquivo_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_controle_p,
			ds_compl_arquivo_w,
			tp_registro_w,
			nr_linha_w);
		end;
	end loop;
	close c_demonstrativo;
	end;
end if;

commit;

qt_linha_p	:= nr_linha_w;
nr_sequencia_p	:= nr_seq_registro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_gerar_interf_j100_ecd ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) FROM PUBLIC;

