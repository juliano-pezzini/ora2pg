-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE dime_reg_credito_especial ( nr_seq_controle_p bigint, cd_estabelecimento_p text, nm_usuario_p text, dt_referencia_p timestamp, ds_separador_p text, nr_seq_dime_p bigint, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Gerar informações referentes à Créditos por Autorizações Especiais do DIME
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [  ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
-------------------------------------------------------------------------------------------------------------------
Referências:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_arquivo_w			varchar(4000);
ds_arquivo_compl_w		varchar(4000);
ds_linha_w			varchar(8000);
ds_quadro_w			varchar(2);
tp_registro_w			varchar(2);
separador_w			varchar(1)	:= ds_separador_p;
vl_contabil_w			double precision;
nr_linha_w			bigint	:= qt_linha_p;
nr_seq_registro_w		bigint 	:= nr_sequencia_p;
qt_reg_especial_w		bigint;
dt_final_w			timestamp;

cd_ident_reg_especial_w		fis_regra_dime_reg_46.cd_ident_reg_especial%type;
cd_conta_devol_icms_w		fis_regra_dime_reg_46.cd_conta_devol_icms%type;
ie_origem_credito_w		fis_regra_dime_reg_46.ie_origem_credito%type;


BEGIN
select	max(cd_ident_reg_especial),
	max(cd_conta_devol_icms),
	max(ie_origem_credito),
	count(1)
into STRICT	cd_ident_reg_especial_w,
	cd_conta_devol_icms_w,
	ie_origem_credito_w,
	qt_reg_especial_w
from	fis_regra_dime_reg_46	a
where	nr_seq_regra_dime	= nr_seq_dime_p;

if (qt_reg_especial_w > 0) then
	tp_registro_w	:= '46';
	ds_quadro_w	:= '46';
	dt_final_w	:= pkg_date_utils.start_of(dt_referencia_p,'MONTH',0);
	--dt_final_w	:= add_months(dt_final_w,11);
	if (coalesce(cd_conta_devol_icms_w,'X') <> 'X') then
		begin

		select	sum(a.vl_saldo)
		into STRICT	vl_contabil_w
		from	ctb_mes_ref	b,
			ctb_saldo	a
		where	b.nr_sequencia		= a.nr_seq_mes_ref
		and	b.dt_referencia 	= dt_final_w
		and	a.cd_conta_contabil	= cd_conta_devol_icms_w;

		end;
	else

		select	sum(a.vl_icms_devolucao)
		into STRICT	vl_contabil_w
		from	fis_livro_fiscal a
		where	a.ie_tipo_livro_fiscal	= 'I'
		and	dt_final_w between a.dt_inicial and a.dt_final;

	end if;

	vl_contabil_w	:= coalesce(vl_contabil_w,0);

	/*	Sequência 1	*/

	ds_linha_w	:=	tp_registro_w								|| separador_w || -- campo 01: tipo de registro [tamanho 02] preencher com "46"
				ds_quadro_w								|| separador_w || -- campo 02:  quadro [tamanho 02] preencher com "46"
				'001'									|| separador_w || -- campo 03: sequência [tamanho 03]
				lpad(coalesce(cd_ident_reg_especial_w,0),15,'0')				|| separador_w || -- campo 04: identificação [tamanho 15] Identificação do Regime ou da Autorização Especial
				lpad(replace(campo_mascara(coalesce(vl_contabil_w,0),2),'.',''),17,'0')	|| separador_w || -- campo 05: valor [tamanho 17] Valor do crédito utilizado na apuração
				lpad(coalesce(ie_origem_credito_w,0),2,'0');							  -- campo 06: origem [tamanho 02] Preencher com: 1 ¿ Crédito por transferência de créditos; 14 ¿ Créditos por DCIP;
	ds_arquivo_w		:= substr(ds_linha_w,1,4000);
	ds_arquivo_compl_w	:= substr(ds_linha_w,4001,4000);
	nr_seq_registro_w	:= nr_seq_registro_w + 1;
	nr_linha_w		:= nr_linha_w + 1;

	-- insert na tabela do DIME
	insert into w_dime_arquivo(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_controle_dime,
		nr_linha,
		cd_registro,
		ds_arquivo)
	values (nextval('w_dime_arquivo_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_controle_p,
		nr_linha_w,
		tp_registro_w,
		ds_arquivo_w);

	/*	Totalizador	*/

	ds_linha_w	:=	tp_registro_w								|| separador_w || -- campo 01: tipo de registro [tamanho 02] preencher com "46"
				ds_quadro_w								|| separador_w || -- campo 02:  quadro [tamanho 02] preencher com "46"
				'990'									|| separador_w || -- campo 03: sequência [tamanho 03]
				lpad('0',15,'0')							|| separador_w || -- campo 04: identificação [tamanho 15] Identificação do Regime ou da Autorização Especial
				lpad(replace(campo_mascara(coalesce(vl_contabil_w,0),2),'.',''),17,'0')	|| separador_w || -- campo 05: valor [tamanho 17] Valor do crédito utilizado na apuração
				lpad('0',2,'0'); 									  -- campo 06: origem [tamanho 02] Preencher com: 1 ¿ Crédito por transferência de créditos; 14 ¿ Créditos por DCIP;
	ds_arquivo_w		:= substr(ds_linha_w,1,4000);
	ds_arquivo_compl_w	:= substr(ds_linha_w,4001,4000);
	nr_seq_registro_w	:= nr_seq_registro_w + 1;
	nr_linha_w		:= nr_linha_w + 1;

	-- insert na tabela do DIME
	insert into w_dime_arquivo(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_controle_dime,
		nr_linha,
		cd_registro,
		ds_arquivo)
	values (nextval('w_dime_arquivo_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_controle_p,
		nr_linha_w,
		tp_registro_w,
		ds_arquivo_w);
end if;

commit;

qt_linha_p	:= nr_linha_w;
nr_sequencia_p	:= nr_seq_registro_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dime_reg_credito_especial ( nr_seq_controle_p bigint, cd_estabelecimento_p text, nm_usuario_p text, dt_referencia_p timestamp, ds_separador_p text, nr_seq_dime_p bigint, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) FROM PUBLIC;
