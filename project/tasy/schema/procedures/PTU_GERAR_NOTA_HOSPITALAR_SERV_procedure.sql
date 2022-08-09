-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_gerar_nota_hospitalar_serv ( nr_seq_cobranca_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nm_hospital_w			varchar(25);
cd_cgc_w			varchar(14);
cd_doenca_w			varchar(10);
cd_guia_w			varchar(10);
ie_tipo_acomodacao_w		varchar(2);
ie_obito_w			varchar(2);
cd_motivo_saida_w		varchar(2);
ie_complicacao_puerperio_w	varchar(2);
ie_transtorno_w			varchar(1);
ie_atend_parto_w		varchar(1);
ie_compl_neonatal_w		varchar(1);
ie_baixo_peso_w			varchar(1);
ie_parto_cesaria_w		varchar(1);
ie_parto_normal_w		varchar(1);
ie_ind_acidente_w		varchar(1);
ie_tipo_faturamento_w		varchar(1);
ie_gestacao_w			varchar(1);
nr_nota_fiscal_w		bigint;
nr_seq_protocolo_w		bigint;
nr_seq_clinica_w		bigint;
nr_seq_tipo_acomodacao_w	bigint;
nr_seq_saida_w			bigint;
nr_seq_servico_w		bigint;
nr_seq_hospitalar_w		bigint;
nr_seq_conta_w			bigint;
nr_seq_segurado_w		bigint;
nr_seq_congenere_w		integer;
nr_seq_lote_w			integer;
nr_seq_prestador_w		integer;
cd_cnes_w			integer;
cd_cooperativa_w		varchar(10);
qt_nasc_vivos_pre_w		smallint;
qt_nasc_vivos_w			smallint;
qt_nasc_mortos_w		smallint;
qt_nasc_vivos_pre		smallint;
qt_obito_precoce_w		smallint;
qt_obito_tardio_w		smallint;
ie_tipo_internacao_w		smallint;
ie_obito_mulher_w		smallint;
dt_internacao_w			timestamp;
dt_alta_w			timestamp;

C01 CURSOR FOR 
	SELECT	b.nr_sequencia, 
		b.nr_seq_prestador, 
		a.nr_seq_clinica, 
		a.nr_seq_tipo_acomodacao, 
		a.ie_indicacao_acidente, 
		a.nr_seq_saida_int, 
		(a.qt_nasc_vivos_prematuros)::numeric , 
		coalesce(a.dt_entrada,clock_timestamp()), 
		CASE WHEN a.ie_tipo_faturamento='T' THEN 1 WHEN a.ie_tipo_faturamento='P' THEN 2  ELSE 1 END , 
		coalesce(a.dt_alta,clock_timestamp()), 
		coalesce((a.qt_nasc_vivos)::numeric ,0), 
		coalesce((a.qt_nasc_mortos)::numeric ,0), 
		coalesce((a.qt_obito_precoce)::numeric ,0), 
		coalesce((a.qt_obito_tardio)::numeric ,0), 
		coalesce(a.ie_gestacao,'N'), 
		coalesce(a.ie_obito,'N'), 
		coalesce(a.ie_transtorno,'N'), 
		coalesce(a.ie_complicacao_puerperio,'N'), 
		coalesce(a.ie_atend_rn_sala_parto,'N'), 
		coalesce(a.ie_complicacao_neonatal,'N'), 
		coalesce(a.ie_baixo_peso,'N'), 
		coalesce(a.ie_parto_cesaria,'N'), 
		coalesce(a.ie_parto_normal,'N'), 
		coalesce(a.ie_obito_mulher,0), 
		a.nr_sequencia, 
		b.nr_seq_segurado 
	from	pls_conta		a, 
		pls_protocolo_conta	b 
	where	a.nr_seq_protocolo	= b.nr_sequencia 
	and	pls_obter_se_internado(a.nr_sequencia,'X') = 'S' 
	and	a.nr_seq_serv_pre_pagto	= nr_seq_servico_w 
	and	coalesce(b.ie_tipo_protocolo,'C')	= 'C';

C02 CURSOR FOR 
	SELECT	a.qt_nasc_vivos, 
		a.qt_nasc_mortos, 
		b.cd_doenca	 
	from	pls_diagnostico_conta	b, 
		pls_conta		a 
	where	a.nr_sequencia	= b.nr_seq_conta 
	and	a.nr_sequencia	= nr_seq_conta_w;


BEGIN 
 
select	nr_seq_serv_pre_pagto 
into STRICT	nr_seq_servico_w 
from	ptu_nota_cobranca 
where	nr_sequencia	= nr_seq_cobranca_p;
 
open C01;
loop 
fetch C01 into 
	nr_seq_protocolo_w, 
	nr_seq_prestador_w, 
	nr_seq_clinica_w, 
	nr_seq_tipo_acomodacao_w, 
	ie_ind_acidente_w, 
	nr_seq_saida_w, 
	qt_nasc_vivos_pre_w, 
	dt_internacao_w, 
	ie_tipo_faturamento_w, 
	dt_alta_w, 
	qt_nasc_vivos_w, 
	qt_nasc_mortos_w, 
	qt_obito_precoce_w, 
	qt_obito_tardio_w, 
	ie_gestacao_w, 
	ie_obito_w, 
	ie_transtorno_w, 
	ie_complicacao_puerperio_w, 
	ie_atend_parto_w, 
	ie_compl_neonatal_w, 
	ie_baixo_peso_w, 
	ie_parto_cesaria_w, 
	ie_parto_normal_w, 
	ie_obito_mulher_w, 
	nr_seq_conta_w, 
	nr_seq_segurado_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
 
	select	max(nr_seq_congenere) 
	into STRICT	nr_seq_congenere_w 
	from	pls_segurado 
	where	nr_sequencia	= nr_seq_segurado_w;
	 
	select	coalesce(max(cd_doenca),1) 
	into STRICT	cd_doenca_w 
	from	pls_diagnostico_conta 
	where	nr_seq_conta	= nr_seq_conta_w 
	and	ie_classificacao = 'P';
	 
	select	substr(pls_obter_dados_prestador(nr_sequencia,'N'),1,25), 
		CASE WHEN coalesce(cd_pessoa_fisica::text, '') = '' THEN substr(obter_dados_pf_pj(null,cd_cgc,'CNES'),1,8)  ELSE substr(obter_dados_pf(cd_pessoa_fisica,'CNES'),1,8) END , 
		substr(cd_cgc,1,14) 
	into STRICT	nm_hospital_w, 
		cd_cnes_w, 
		cd_cgc_w 
	from	pls_prestador 
	where	nr_sequencia	= nr_seq_prestador_w;
	 
	select	max(cd_ptu) 
	into STRICT	cd_motivo_saida_w 
	from	pls_motivo_saida 
	where	nr_sequencia	= nr_seq_saida_w;
	 
	select	coalesce(max(ie_tipo_acomodacao_ptu),1) 
	into STRICT	ie_tipo_acomodacao_w 
	from	pls_tipo_acomodacao 
	where	nr_sequencia	= nr_seq_tipo_acomodacao_w;
	 
	select	coalesce(max(cd_clinica),1) 
	into STRICT	ie_tipo_internacao_w 
	from	pls_clinica 
	where	nr_sequencia = nr_seq_clinica_w;
	 
	select	coalesce(max(cd_cooperativa),1) 
	into STRICT	cd_cooperativa_w 
	from	pls_congenere 
	where	nr_sequencia	= nr_seq_congenere_w;
	 
	if (coalesce(ie_ind_acidente_w::text, '') = '') then 
		ie_ind_acidente_w	:= '0';
	elsif (ie_ind_acidente_w = '0') then 
		ie_ind_acidente_w	:= '1';
	elsif (ie_ind_acidente_w = '1') then 
		ie_ind_acidente_w	:= '2';
	elsif (ie_ind_acidente_w = '1') then 
		ie_ind_acidente_w	:= '3';
	end if;
	 
	nr_seq_lote_w	:= (nr_seq_conta_w+nr_seq_protocolo_w)::numeric;
	 
	select	nextval('ptu_nota_hospitalar_seq') 
	into STRICT	nr_seq_hospitalar_w 
	;
	 
	 
	insert into ptu_nota_hospitalar(nr_sequencia, dt_atualizacao, nm_usuario,dt_atualizacao_nrec, nm_usuario_nrec, 
		nr_seq_nota_cobr,nr_lote, nr_nota, cd_unimed_hospital, 
		cd_hospital, qt_obito_tardio, ie_int_gestacao,ie_int_aborto, 
		ie_int_transtorno, nm_hospital,ie_tipo_acomodacao, dt_internacao, 
		dt_alta,tx_mult_amb, ie_ind_acidente, cd_motivo_saida, 
		cd_cgc_hospital, ie_tipo_internacao, qt_nasc_vivos,qt_nasc_mortos, 
		qt_nasc_vivos_pre, qt_obito_precoce,ie_int_puerperio, ie_int_recem_nascido, 
		ie_int_neonatal,ie_int_baixo_peso, ie_int_parto_cesarea, ie_int_parto_normal, 
		ie_faturamento, cd_cid_obito, ie_obito_mulher,nr_declara_obito) 
	values (nr_seq_hospitalar_w, clock_timestamp(), nm_usuario_p,clock_timestamp(), nm_usuario_p, 
		nr_seq_cobranca_p,nr_seq_lote_w, nr_seq_conta_w, cd_cooperativa_w, 
		nr_seq_prestador_w, qt_obito_tardio_w, ie_gestacao_w,ie_obito_w, 
		ie_transtorno_w, nm_hospital_w,ie_tipo_acomodacao_w, dt_internacao_w, 
		dt_alta_w,1, ie_ind_acidente_w, cd_motivo_saida_w, 
		cd_cgc_w, ie_tipo_internacao_w, qt_nasc_vivos_w,qt_nasc_mortos_w, 
		qt_nasc_vivos_pre_w, qt_obito_precoce_w,ie_complicacao_puerperio_w, ie_atend_parto_w, 
		ie_compl_neonatal_w,ie_baixo_peso_w, ie_parto_cesaria_w, ie_parto_normal_w, 
		ie_tipo_faturamento_w, cd_doenca_w, ie_obito_mulher_w,'1');
		 
	open C02;
	loop 
	fetch C02 into 
		qt_nasc_vivos_w, 
		qt_nasc_mortos_w, 
		cd_doenca_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin 
		insert into ptu_nota_hosp_compl(nr_sequencia, nr_seq_nota_hosp, dt_atualizacao, 
			nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, 
			nr_declara_vivo, cd_cid_obito, nr_declara_obito) 
		values (nextval('ptu_nota_hosp_compl_seq'), nr_seq_hospitalar_w, clock_timestamp(), 
			nm_usuario_p, clock_timestamp(), nm_usuario_p, 
			qt_nasc_vivos_w, cd_doenca_w, qt_nasc_mortos_w);
		end;
	end loop;
	close C02;
 
	end;
end loop;
close C01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_gerar_nota_hospitalar_serv ( nr_seq_cobranca_p bigint, nm_usuario_p text) FROM PUBLIC;
