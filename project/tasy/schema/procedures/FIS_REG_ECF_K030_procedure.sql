-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_reg_ecf_k030 ( nr_seq_controle_p text, ds_separador_p text, cd_estabelecimento_p text, nm_usuario_p text, cd_empresa_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint, ie_scp_p text) AS $body$
DECLARE


nr_seq_registro_w			bigint := nr_sequencia_p;
nr_linha_w			bigint := qt_linha_p;
ds_arquivo_w			varchar(4000);
ds_arquivo_compl_w		varchar(4000);
ds_linha_w			varchar(4000);
sep_w				varchar(2) := ds_separador_p;

tp_registro			varchar(5);
dt_inicio_apuracao_w		timestamp;
dt_fim_apuracao_w			timestamp;
ie_forma_apuracao_w		fis_regra_ecf_0020.ie_forma_apuracao%type;
nr_seq_apuracao_w		bigint;
ie_tipo_apuracao_w		varchar(1);
dt_inicio_w			timestamp;
dt_fim_w				timestamp;

cd_conta_contabil_w		varchar(40);
vl_saldo_inicial_ww			varchar(80);
vl_debito_ww			varchar(80);
vl_credito_ww			varchar(80);
vl_saldo_final_ww			varchar(80);
ie_apres_conta_ctb_w		fis_lote_ecf.ie_apres_conta_ctb%type;
nr_seq_lote_w			fis_lote_ecf.nr_sequencia%type;

-- Registro K030
c01 CURSOR FOR
	SELECT  b.dt_mes_apuracao,
		a.ie_anual_trimestral,
		a.ie_forma_apuracao
	from	fis_estrutura_calculo	a,
		fis_lote_apuracao 	b
	where	a.nr_sequencia 		= b.nr_seq_estrutura
	and 	b.dt_mes_apuracao	between dt_inicio_apuracao_w and dt_fim_apuracao_w
	and (a.ie_lalur_lacs 	= 'LC'
		or a.ie_lalur_lacs 	= 'CS')
	and 	b.ie_lote_anual 	= 'N'
	and	(((ie_scp_p = 'S') 
		and (coalesce(a.ie_scp, 'N') = 'S')
		and (a.cd_estabelecimento_scp = cd_estabelecimento_p))
	or	((ie_scp_p = 'N') 
		and (coalesce(a.ie_scp, 'N') = 'N')))
	and	a.cd_empresa 		= cd_empresa_p
	order by	b.dt_mes_apuracao;
vet01	c01%RowType;

-- Registro K155
c02 CURSOR FOR
	SELECT	a.cd_conta_contabil,
		a.cd_classificacao,
		a.cd_centro_custo,
		substr(ctb_obter_situacao_saldo(a.cd_conta_contabil, sum(coalesce(a.vl_saldo_inicial,0))),1,1) ie_debito_credito_inicial,
			max((SELECT sum(coalesce(w.vl_saldo_inicial,0))
			from  ecd_saldo_periodico_v w
			where w.cd_conta_contabil = a.cd_conta_contabil
			and   w.cd_empresa    =  a.cd_empresa
			and   w.tp_registro   = 2
			and   w.dt_inicial    between dt_inicio_w and dt_inicio_w)) vl_saldo_inicial,   
		sum(coalesce(a.vl_debito,0)) vl_debito,
		sum(coalesce(a.vl_credito,0)) vl_credito,
			max((select sum(coalesce(w.vl_saldo_final,0)) 
			from  ecd_saldo_periodico_v w
			where w.cd_conta_contabil = a.cd_conta_contabil
			and   w.cd_empresa    =  a.cd_empresa
			and   w.tp_registro   = 2
			and   w.dt_inicial    between trunc(dt_fim_w, 'mm') and dt_fim_w)) vl_saldo_final,
		substr(ctb_obter_situacao_saldo(a.cd_conta_contabil, sum(coalesce(a.vl_saldo_final,0))),1,1) ie_debito_credito_final
	from	ecd_saldo_periodico_v	a,
		estabelecimento		b,
		conta_contabil 		c
	
	where	a.cd_empresa 		= cd_empresa_p
	and	a.cd_estabelecimento 	= b.cd_estabelecimento
	and	a.cd_conta_contabil   	= c.cd_conta_contabil
	and	c.ie_natureza_sped	in ('01','02','03')
	and	a.tp_registro		= 2
	and	coalesce(b.ie_gerar_sped,'S')	= 'S'
	and	a.dt_inicial 		between dt_inicio_w and dt_fim_w
	and    ((ie_scp_p = 'S' AND b.cd_estabelecimento 	= cd_estabelecimento_p)
	or (ie_scp_p = 'N') 
	       and (b.cd_estabelecimento 	in (	select cd_estabelecimento
							from   estabelecimento
							where  coalesce(ie_scp, 'N') = 'N')))
	group	by	a.cd_conta_contabil,
			a.cd_classificacao,
			a.cd_centro_custo;
vet02	c02%RowType;

-- Registro K355
c03 CURSOR FOR
	SELECT	a.cd_conta_contabil,
		a.cd_classificacao,
		CASE WHEN c.ie_centro_custo='S' THEN  a.cd_centro_custo  ELSE null END  cd_centro_custo,
		(coalesce(sum(a.vl_saldo),0) - coalesce(sum(vl_encerramento),0)) vl_saldo,
		substr(ctb_obter_situacao_saldo(a.cd_conta_contabil,  coalesce(sum(a.vl_saldo),0) - coalesce(sum(vl_encerramento),0)),1,1) ie_debito_credito
	from	centro_custo    	f,
		estabelecimento 	e,
		ctb_grupo_conta		d,
		conta_contabil		c,
		ctb_saldo		a
	where	c.cd_conta_contabil	= a.cd_conta_contabil
	and	d.cd_grupo		= c.cd_grupo
	and	f.cd_centro_custo	= a.cd_centro_custo
	and	f.cd_estabelecimento	= e.cd_estabelecimento
	and	e.cd_empresa		= cd_empresa_p
	and	c.ie_tipo		= 'A'
	--and	a.cd_estabelecimento	= cd_estabelecimento_p
	and	d.ie_tipo 		in ('R','C','D')
	and	ctb_obter_mes_ref(a.nr_seq_mes_ref)  = trunc(dt_fim_w, 'month')
	and	substr(obter_se_conta_vigente2(c.cd_conta_contabil,c.dt_inicio_vigencia,c.dt_fim_vigencia,dt_fim_w),1,1) = 'S'
	and    ((ie_scp_p	= 'S' AND e.cd_estabelecimento 	= cd_estabelecimento_p)
	or (ie_scp_p	= 'N')
	       and (e.cd_estabelecimento 	in (	SELECT cd_estabelecimento
							from   estabelecimento
							where  coalesce(ie_scp, 'N') = 'N')))
	group by	a.cd_conta_contabil,
			a.cd_classificacao,
			CASE WHEN c.ie_centro_custo='S' THEN  a.cd_centro_custo  ELSE null END;
vet03	c03%RowType;


BEGIN

select  max(dt_inicio_apuracao),
	max(dt_fim_apuracao),
	max(nr_seq_lote)
into STRICT	dt_inicio_apuracao_w,
	dt_fim_apuracao_w,
	nr_seq_lote_w
from	fis_controle_ecf
where	nr_sequencia = nr_seq_controle_p;

select  max(ie_forma_apuracao)
into STRICT	ie_forma_apuracao_w
from	fis_regra_ecf_0020
where	nr_seq_lote	= nr_seq_lote_w
and	cd_empresa = cd_empresa_p;

select	coalesce(max(a.ie_apres_conta_ctb),'CD')
into STRICT	ie_apres_conta_ctb_w
from	fis_lote_ecf a,
	fis_controle_ecf b
where	a.nr_sequencia = b.nr_seq_lote
and	b.nr_sequencia = nr_seq_controle_p;

tp_registro	:= 'K001';
ds_linha_w  	:=  substr( 	sep_w || tp_registro		|| -- Texto Fixo Contendo a Identificao do Registro.
				sep_w || 0 		|| -- Indicador de movimento: 0 - Bloco com dados informados; 1 - Bloco sem dados informados.
				sep_w,1,8000);

ds_arquivo_w		:= substr(ds_linha_w,1,4000);
ds_arquivo_compl_w	:= substr(ds_linha_w,4001,4000);
nr_seq_registro_w	:= nr_seq_registro_w + 1;
nr_linha_w		:= nr_linha_w + 1;

insert into fis_ecf_arquivo(
	nr_sequencia,
	nm_usuario,
	dt_atualizacao,
	nm_usuario_nrec,
	dt_atualizacao_nrec,
	nr_seq_controle_ecf,
	nr_linha,
	cd_registro,
	ds_arquivo,
	ds_arquivo_compl)
values (	nr_seq_registro_w,
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nr_seq_controle_p,
	nr_linha_w,
	tp_registro,
	ds_arquivo_w,
	ds_arquivo_compl_w);

if (ie_forma_apuracao_w  = 'A') then
	tp_registro	:= 'K030'; --linha A00
	dt_inicio_w	:= dt_inicio_apuracao_w;
	dt_fim_w	:= dt_fim_apuracao_w;

	ds_linha_w  	:=  substr( 	sep_w || tp_registro	 			|| -- Texto Fixo Contendo a Identificao do Registro
					sep_w || to_char(dt_inicio_w,'ddmmyyyy')		|| -- Data do Incio do Perodo
					sep_w || to_char(dt_fim_w,'ddmmyyyy')		|| -- Data do Fim do Perodo
					sep_w || 'A00' 				|| -- Perodo de Apurao
					sep_w,1,8000);

	ds_arquivo_w		:= substr(ds_linha_w,1,4000);
	ds_arquivo_compl_w	:= substr(ds_linha_w,4001,4000);
	nr_seq_registro_w	:= nr_seq_registro_w + 1;
	nr_linha_w		:= nr_linha_w + 1;

	insert into fis_ecf_arquivo(
		nr_sequencia,
		nm_usuario,
		dt_atualizacao,
		nm_usuario_nrec,
		dt_atualizacao_nrec,
		nr_seq_controle_ecf,
		nr_linha,
		cd_registro,
		ds_arquivo,
		ds_arquivo_compl)
	values (	nr_seq_registro_w,
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nr_seq_controle_p,
		nr_linha_w,
		tp_registro,
		ds_arquivo_w,
		ds_arquivo_compl_w);
end if;

open c02;
loop
fetch c02 into
	vet02;
EXIT WHEN NOT FOUND; /* apply on c02 */
	begin
	tp_registro		:= 'K155'; --da linha A00
	cd_conta_contabil_w	:= vet02.cd_conta_contabil;

	if (ie_apres_conta_ctb_w = 'CL') then
		cd_conta_contabil_w := vet02.cd_classificacao;
	elsif (ie_apres_conta_ctb_w = 'CP') then
		cd_conta_contabil_w := substr(replace(vet02.cd_classificacao, '.', ''), 1, 40);
	end if;

	if 	((vet02.vl_saldo_inicial <> 0) or (vet02.vl_debito <> 0)  or (vet02.vl_credito <> 0)  or (vet02.vl_saldo_final <> 0)) then
		vl_saldo_inicial_ww	:= replace(replace(campo_mascara_virgula(vet02.vl_saldo_inicial),'.',''),'-','');
		vl_debito_ww		:= replace(replace(campo_mascara_virgula(vet02.vl_debito),'.',''),'-','');
		vl_credito_ww		:= replace(replace(campo_mascara_virgula(vet02.vl_credito),'.',''),'-','');
		vl_saldo_final_ww	:= replace(replace(campo_mascara_virgula(vet02.vl_saldo_final),'.',''),'-','');

		ds_linha_w	:= substr(	sep_w || tp_registro			|| -- Texto Fixo Contendo a Identificao do Registro
						sep_w || cd_conta_contabil_w 	|| -- Cdigo da Conta Analtica Patrimonial
						sep_w || vet02.cd_centro_custo 	|| -- Cdigo do Centro de Custos
						sep_w || vl_saldo_inicial_ww		|| -- Valor do Saldo Inicial do Perodo.
						sep_w || vet02.ie_debito_credito_inicial	|| -- Indicador da Situao do Saldo Inicial: D - Devedor C - Credor
						sep_w || vl_debito_ww		|| -- Valor Total dos Dbitos no Perodo
						sep_w || vl_credito_ww		|| -- Valor Total dos Crditos no Perodo
						sep_w || vl_saldo_final_ww		|| -- Valor do Saldo Final do Perodo
						sep_w || vet02.ie_debito_credito_final 	|| -- Indicador da Situao do Saldo Final: D - Devedor C - Credor
						sep_w, 1,8000);

		ds_arquivo_w		:= substr(ds_linha_w,1,4000);
		ds_arquivo_compl_w	:= substr(ds_linha_w,4001,4000);
		nr_seq_registro_w	:= nr_seq_registro_w + 1;
		nr_linha_w		:= nr_linha_w + 1;

		insert into fis_ecf_arquivo(
			nr_sequencia,
			nm_usuario,
			dt_atualizacao,
			nm_usuario_nrec,
			dt_atualizacao_nrec,
			nr_seq_controle_ecf,
			nr_linha,
			cd_registro,
			ds_arquivo,
			ds_arquivo_compl)
		values (	nr_seq_registro_w,
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nr_seq_controle_p,
			nr_linha_w,
			tp_registro,
			ds_arquivo_w,
			ds_arquivo_compl_w);

	end if;
	end;
end loop;
close c02;

open c03;
loop
fetch c03 into
	vet03;
EXIT WHEN NOT FOUND; /* apply on c03 */
	begin
	tp_registro	:= 'K355';
	
	cd_conta_contabil_w	:= vet03.cd_conta_contabil;	

	if (ie_apres_conta_ctb_w = 'CL') then
		cd_conta_contabil_w	:= vet03.cd_classificacao;
	elsif (ie_apres_conta_ctb_w = 'CP') then
		cd_conta_contabil_w	:= substr(replace(vet03.cd_classificacao,'.',''),1,40);
	end if;

	ds_linha_w  	:=  substr( 	sep_w || tp_registro	 				|| -- Texto Fixo Contendo a Identificao do Registro
					sep_w || cd_conta_contabil_w			|| -- Cdigo da Conta Analtica de Resultado
					sep_w || vet03.cd_centro_custo			|| -- Cdigo do Centro de Custos
					sep_w || sped_obter_campo_valor(vet03.vl_saldo)		|| -- Valor do Saldo Final Antes do Lanamento de Encerramento
					sep_w || vet03.ie_debito_credito			|| -- Indicador da Situao do Saldo Final: D - Devedor C - Credor
					sep_w,1,8000);

	ds_arquivo_w		:= substr(ds_linha_w,1,4000);
	ds_arquivo_compl_w	:= substr(ds_linha_w,4001,4000);
	nr_seq_registro_w	:= nr_seq_registro_w + 1;
	nr_linha_w		:= nr_linha_w + 1;

	insert into fis_ecf_arquivo(
		nr_sequencia,
		nm_usuario,
		dt_atualizacao,
		nm_usuario_nrec,
		dt_atualizacao_nrec,
		nr_seq_controle_ecf,
		nr_linha,
		cd_registro,
		ds_arquivo,
		ds_arquivo_compl)
	values (	nr_seq_registro_w,
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nr_seq_controle_p,
		nr_linha_w,
		tp_registro,
		ds_arquivo_w,
		ds_arquivo_compl_w);

	end;
end loop;
close c03;

open c01;
loop
fetch c01 into
	vet01;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	if (vet01.ie_forma_apuracao <> 'R') then
		tp_registro	:= 'K030';

		if (vet01.ie_anual_trimestral = 'A') then
			dt_inicio_w 		:= dt_inicio_apuracao_w;
			dt_fim_w		:= fim_mes(vet01.dt_mes_apuracao);
			ie_tipo_apuracao_w 	:= 'A';
			nr_seq_apuracao_w 	:= to_char(dt_fim_w, 'mm');
		else
			dt_inicio_w 		:= trunc(add_months(vet01.dt_mes_apuracao, -2), 'month');
			dt_fim_w		:= vet01.dt_mes_apuracao;
			ie_tipo_apuracao_w 	:= 'T';
			nr_seq_apuracao_w 	:= (to_char(dt_fim_w, 'mm') / 3);
		end if;

		ds_linha_w := substr(	sep_w || tp_registro	 				|| -- Texto Fixo Contendo a Identificao do Registro
					  sep_w || to_char(dt_inicio_w,'ddmmyyyy')			|| -- Data do Incio do Perodo
					  sep_w || to_char(dt_fim_w ,'ddmmyyyy')				|| -- Data do Fim do Perodo
					  sep_w || ie_tipo_apuracao_w || lpad(nr_seq_apuracao_w, 2, '0')	|| -- Perodo de Apurao
					  sep_w,1,8000);

		ds_arquivo_w		:= substr(ds_linha_w,1,4000);
		ds_arquivo_compl_w	:= substr(ds_linha_w,4001,4000);
		nr_seq_registro_w	:= nr_seq_registro_w + 1;
		nr_linha_w		:= nr_linha_w + 1;

		insert into fis_ecf_arquivo(
			nr_sequencia,
			nm_usuario,
			dt_atualizacao,
			nm_usuario_nrec,
			dt_atualizacao_nrec,
			nr_seq_controle_ecf,
			nr_linha,
			cd_registro,
			ds_arquivo,
			ds_arquivo_compl)
		values (	nr_seq_registro_w,
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nr_seq_controle_p,
			nr_linha_w,
			tp_registro,
			ds_arquivo_w,
			ds_arquivo_compl_w);

		-- Registro K155
		open c02;
		loop
		fetch c02 into
			vet02;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin
			tp_registro	:= 'K155';

			cd_conta_contabil_w := vet02.cd_conta_contabil;

			if (ie_apres_conta_ctb_w = 'CL') then
				cd_conta_contabil_w := vet02.cd_classificacao;
			elsif (ie_apres_conta_ctb_w = 'CP') then
				cd_conta_contabil_w := substr(replace(vet02.cd_classificacao, '.', ''), 1, 40);
			end if;

			if 	((vet02.vl_saldo_inicial <> 0) or (vet02.vl_debito <> 0)  or (vet02.vl_credito <> 0)  or (vet02.vl_saldo_final <> 0)) then
				vl_saldo_inicial_ww	:= replace(replace(campo_mascara_virgula(vet02.vl_saldo_inicial),'.',''),'-','');
				vl_debito_ww	:= replace(replace(campo_mascara_virgula(vet02.vl_debito),'.',''),'-','');
				vl_credito_ww	:= replace(replace(campo_mascara_virgula(vet02.vl_credito),'.',''),'-','');
				vl_saldo_final_ww	:= replace(replace(campo_mascara_virgula(vet02.vl_saldo_final),'.',''),'-','');

				ds_linha_w	:= substr(	sep_w || tp_registro				|| -- Texto Fixo Contendo a Identificao do Registro
								sep_w || cd_conta_contabil_w 		|| -- Cdigo da Conta Analtica Patrimonial
								sep_w || vet02.cd_centro_custo 		|| -- Cdigo do Centro de Custos
								sep_w || vl_saldo_inicial_ww			|| -- Valor do Saldo Inicial do Perodo.
								sep_w || vet02.ie_debito_credito_inicial		|| -- Indicador da Situao do Saldo Inicial: D - Devedor C - Credor
								sep_w || vl_debito_ww			|| -- Valor Total dos Dbitos no Perodo
								sep_w || vl_credito_ww			|| -- Valor Total dos Crditos no Perodo
								sep_w || vl_saldo_final_ww			|| -- Valor do Saldo Final do Perodo
								sep_w || vet02.ie_debito_credito_final 		|| -- Indicador da Situao do Saldo Final: D - Devedor C - Credor
								sep_w, 1,8000);

				ds_arquivo_w		:= substr(ds_linha_w,1,4000);
				ds_arquivo_compl_w	:= substr(ds_linha_w,4001,4000);
				nr_seq_registro_w	:= nr_seq_registro_w + 1;
				nr_linha_w		:= nr_linha_w + 1;

				insert into fis_ecf_arquivo(
					nr_sequencia,
					nm_usuario,
					dt_atualizacao,
					nm_usuario_nrec,
					dt_atualizacao_nrec,
					nr_seq_controle_ecf,
					nr_linha,
					cd_registro,
					ds_arquivo,
					ds_arquivo_compl)
				values (	nr_seq_registro_w,
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nr_seq_controle_p,
					nr_linha_w,
					tp_registro,
					ds_arquivo_w,
					ds_arquivo_compl_w);

			end if;
			end;
		end loop;
		close c02;

		open c03;
		loop
		fetch c03 into
			vet03;
		EXIT WHEN NOT FOUND; /* apply on c03 */
			begin
			tp_registro		:= 'K355';
			cd_conta_contabil_w	:= vet03.cd_conta_contabil;				

			if (ie_apres_conta_ctb_w = 'CL') then
				cd_conta_contabil_w	:= vet03.cd_classificacao;
			elsif (ie_apres_conta_ctb_w = 'CP') then
				cd_conta_contabil_w	:= substr(replace(vet03.cd_classificacao,'.',''),1,40);
			end if;

			ds_linha_w  	:=  substr(	sep_w || tp_registro	 				|| -- Texto Fixo Contendo a Identificao do Registro
							sep_w || cd_conta_contabil_w				|| -- Cdigo da Conta Analtica de Resultado
							sep_w || vet03.cd_centro_custo				|| -- Cdigo do Centro de Custos
							sep_w || sped_obter_campo_valor(vet03.vl_saldo)		|| -- Valor do Saldo Final Antes do Lanamento de Encerramento
							sep_w || vet03.ie_debito_credito			|| -- Indicador da Situao do Saldo Final: D - Devedor C - Credor
							sep_w,1,8000);

			ds_arquivo_w		:= substr(ds_linha_w,1,4000);
			ds_arquivo_compl_w	:= substr(ds_linha_w,4001,4000);
			nr_seq_registro_w	:= nr_seq_registro_w + 1;
			nr_linha_w		:= nr_linha_w + 1;

			insert into fis_ecf_arquivo(
				nr_sequencia,
				nm_usuario,
				dt_atualizacao,
				nm_usuario_nrec,
				dt_atualizacao_nrec,
				nr_seq_controle_ecf,
				nr_linha,
				cd_registro,
				ds_arquivo,
				ds_arquivo_compl)
			values (	nr_seq_registro_w,
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nr_seq_controle_p,
				nr_linha_w,
				tp_registro,
				ds_arquivo_w,
				ds_arquivo_compl_w);

			end;
		end loop;
		close c03;
	end if;
	end;
end loop;
close c01;

commit;

qt_linha_p	:= nr_linha_w;
nr_sequencia_p	:= nr_seq_registro_w;

SELECT * FROM fis_reg_ecf_K990(nr_seq_controle_p, ds_separador_p, cd_estabelecimento_p, nm_usuario_p, cd_empresa_p, qt_linha_p, nr_sequencia_p) INTO STRICT qt_linha_p, nr_sequencia_p;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_reg_ecf_k030 ( nr_seq_controle_p text, ds_separador_p text, cd_estabelecimento_p text, nm_usuario_p text, cd_empresa_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint, ie_scp_p text) FROM PUBLIC;
