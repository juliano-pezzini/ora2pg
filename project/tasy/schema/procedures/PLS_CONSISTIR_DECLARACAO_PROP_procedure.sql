-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consistir_declaracao_prop ( nr_seq_proposta_p bigint, cd_estabelecimento_p bigint, ds_mensagem_p INOUT text) AS $body$
DECLARE

 
nr_seq_benef_proposta_w		bigint;
qt_vidas_proposta_w		bigint;
qt_vidas_contrato_w		bigint;
qt_vidas_contrato_princ_w	bigint;
qt_total_vidas_w		bigint;
nr_seq_regra_declaracao_w	bigint;
ie_tipo_proposta_w		smallint;
ie_tipo_contratacao_w		varchar(2);
nr_contrato_w			bigint;
nr_seq_contrato_w		bigint;
nr_seq_parentesco_w		bigint;
nr_seq_titular_contrato_w	bigint;
nr_seq_beneficiario_mig_w	bigint;
ie_regulamentacao_benef_w	varchar(10);
dt_inclusao_operadora_w		timestamp;
dt_rescisao_w			timestamp;
qt_dias_operadora_w		bigint;
qt_dias_rescindidos_w		bigint;
ie_nascido_plano_w		varchar(1);
ie_regulamentacao_titular_w	varchar(10);
qt_dias_titular_ativo_w		bigint;
ie_exige_w			varchar(3);
nr_seq_beneficiario_w		bigint;
nm_beneficiario_w		varchar(255);
ds_lista_benef_w		varchar(32764)	:= '';
ie_tipo_contratacao_ant_w	varchar(10);
ie_possui_declaracao_w		varchar(10);
cd_pessoa_fisica_ant_w		varchar(10);
qt_declaracao_ant_w		bigint;
ds_obser_declaracao_ant_w	varchar(255);
qt_registros_w			bigint;
nr_seq_plano_w			bigint;
ie_tipo_operacao_w		varchar(10);
cd_beneficiario_w		varchar(10);
dt_declaracao_ant_w		timestamp;
dt_admissao_w			timestamp;
ie_exige_declaracao_saude_w	pls_proposta_beneficiario.ie_exige_declaracao_saude%type;

dt_inicio_vigencia_regra_w	timestamp;
dt_fim_vigencia_regra_w		timestamp;
ie_tipo_data_w			varchar(2);
qt_dias_inicial_w		bigint;
qt_dias_final_w			bigint;
dt_inicio_proposta_w		timestamp;
ie_segmentacao_w		pls_plano.ie_segmentacao%type;
nr_contrato_principal_w		pls_contrato.nr_sequencia%type;
qt_portabilidade_w		bigint;
ie_portabilidade_w		varchar(1);	
dt_casamento_w			pessoa_fisica.dt_emissao_cert_casamento%type;
dt_nascimento_w			pessoa_fisica.dt_nascimento%type;
qt_dias_w			bigint;

 
/*aaschlote 08/03/2011 OS - 290276 - Alterações realizadas para novos tipos de regras*/
 
 
C01 CURSOR FOR 
	SELECT	nr_sequencia, 
		substr(obter_nome_pf(cd_beneficiario),1,200), 
		cd_beneficiario 
	from	pls_proposta_beneficiario 
	where	nr_seq_proposta		= nr_seq_proposta_p 
	and	pls_obter_dec_saude_proposta(nr_sequencia,'C')	= 1 
	and	coalesce(dt_cancelamento::text, '') = '';

C02 CURSOR FOR 
	SELECT	nr_sequencia 
	from	pls_regra_declaracao_prop 
	where	ie_situacao		= 'A' 
	and	cd_estabelecimento	= cd_estabelecimento_p 
	and	((ie_tipo_contratacao	= ie_tipo_contratacao_w and (ie_tipo_contratacao IS NOT NULL AND ie_tipo_contratacao::text <> '')) or (coalesce(ie_tipo_contratacao::text, '') = '')) 
	and	((coalesce(ie_considera_contratos_vinc,'N') = 'N') and (qt_total_vidas_w between coalesce(qt_vidas,0) and coalesce(qt_vidas_max,qt_total_vidas_w)) 
	or	((ie_considera_contratos_vinc = 'S') and ((qt_total_vidas_w + coalesce(qt_vidas_contrato_princ_w,0)) between coalesce(qt_vidas,0) and coalesce(qt_vidas_max,qt_total_vidas_w)))) 
	and	((ie_nascido_plano_w	= ie_nascido_plano) or (ie_nascido_plano = 'N')) 
	and	((nr_seq_grau_parentesco = nr_seq_parentesco_w and (nr_seq_grau_parentesco IS NOT NULL AND nr_seq_grau_parentesco::text <> '')) or (coalesce(nr_seq_grau_parentesco::text, '') = '')) 
	and	((ie_tipo_operacao	 = ie_tipo_operacao_w and (ie_tipo_operacao IS NOT NULL AND ie_tipo_operacao::text <> '')) or (coalesce(ie_tipo_operacao::text, '') = '')) 
	and	((ie_segmentacao	 = ie_segmentacao_w and (ie_segmentacao IS NOT NULL AND ie_segmentacao::text <> '')) or (coalesce(ie_segmentacao::text, '') = ''))	 
	and 	((ie_regulamentacao	= ie_regulamentacao_benef_w 
		and (ie_regulamentacao IS NOT NULL AND ie_regulamentacao::text <> '') 
		and (ie_regulamentacao_benef_w IS NOT NULL AND ie_regulamentacao_benef_w::text <> '')) or (coalesce(ie_regulamentacao::text, '') = '')) 
	and	((qt_dias_operadora_w >= qt_anos_vinculo_operadora 
		and (qt_anos_vinculo_operadora IS NOT NULL AND qt_anos_vinculo_operadora::text <> '') 
		and qt_dias_operadora_w > 0) or (coalesce(qt_anos_vinculo_operadora::text, '') = '')) 
	and	((qt_dias_rescindidos_w <= qt_max_dias_pf_inativo 
		and (qt_max_dias_pf_inativo IS NOT NULL AND qt_max_dias_pf_inativo::text <> '') 
		and qt_dias_rescindidos_w > 0) or (coalesce(qt_max_dias_pf_inativo::text, '') = '')) 
	and	((ie_tipo_contratacao_ant	= ie_tipo_contratacao_ant_w 
		and (ie_tipo_contratacao_ant IS NOT NULL AND ie_tipo_contratacao_ant::text <> '') 
		and (ie_tipo_contratacao_ant_w IS NOT NULL AND ie_tipo_contratacao_ant_w::text <> '')) or (coalesce(ie_tipo_contratacao_ant::text, '') = '')) 
	and	((coalesce(ie_possui_declaracao,'N')	= 'S' and ie_possui_declaracao_w = 'S') or (coalesce(ie_possui_declaracao,'N') = 'N')) 
	and	(((nr_seq_titular_contrato_w IS NOT NULL AND nr_seq_titular_contrato_w::text <> '') 
		and 	((ie_regulamentacao_tit	= ie_regulamentacao_titular_w and (ie_regulamentacao_tit IS NOT NULL AND ie_regulamentacao_tit::text <> '')) or (coalesce(ie_regulamentacao_tit::text, '') = '')) 
		and	((qt_dias_titular_ativo_w >= qt_minima_dias_tit_ativo and (qt_minima_dias_tit_ativo IS NOT NULL AND qt_minima_dias_tit_ativo::text <> '')) or (coalesce(qt_minima_dias_tit_ativo::text, '') = ''))) 
	or (coalesce(nr_seq_titular_contrato_w::text, '') = '')) 
	and	((ie_tipo_proposta = ie_tipo_proposta_w) or (coalesce(ie_tipo_proposta::text, '') = '')) 
	and	((ie_portabilidade = ie_portabilidade_w) or (coalesce(ie_portabilidade,'A') = 'A')) 
	and  	(((nr_contrato = nr_seq_contrato_w) or ((coalesce(nr_contrato::text, '') = '') 
	and 	not exists (SELECT 1 from 	pls_regra_declaracao_prop where nr_contrato = nr_seq_contrato_w and ie_situacao = 'A'))) 
	or	(ie_considera_contratos_vinc = 'S' AND nr_seq_contrato = nr_contrato_principal_w)) 
	order by 
		coalesce(nr_seq_contrato,0), 
		coalesce(ie_segmentacao,' '), 
		coalesce(ie_regulamentacao_tit,'A'), 
		coalesce(qt_minima_dias_tit_ativo,0), 
		coalesce(ie_regulamentacao,'A'), 
		coalesce(qt_anos_vinculo_operadora,0), 
		coalesce(qt_max_dias_pf_inativo,0), 
		coalesce(ie_tipo_contratacao_ant,'A'), 
		coalesce(nr_seq_grau_parentesco,-1), 
		CASE WHEN coalesce(ie_possui_declaracao,'S')='N' THEN -1  ELSE 1 END , 
		coalesce(ie_nascido_plano,'N'), 
		coalesce(ie_exige,'S'), 
		coalesce(ie_considera_contratos_vinc,'N') desc;


BEGIN 
 
/*dados da proposta*/
 
select	ie_tipo_proposta, 
	ie_tipo_contratacao, 
	nr_seq_contrato, 
	dt_inicio_proposta 
into STRICT	ie_tipo_proposta_w, 
	ie_tipo_contratacao_w, 
	nr_contrato_w, 
	dt_inicio_proposta_w 
from	pls_proposta_adesao 
where	nr_sequencia	= nr_seq_proposta_p;
 
select	count(*) 
into STRICT	qt_vidas_proposta_w 
from	pls_proposta_beneficiario a, 
	pls_plano b 
where	a.nr_seq_plano		= b.nr_sequencia 
and	((b.ie_tipo_contratacao	= ie_tipo_contratacao_w and (ie_tipo_contratacao_w IS NOT NULL AND ie_tipo_contratacao_w::text <> '')) 
or (coalesce(ie_tipo_contratacao_w::text, '') = '')) 
and	a.nr_seq_proposta	= nr_seq_proposta_p 
and	coalesce(a.dt_cancelamento::text, '') = '';
 
if (nr_contrato_w IS NOT NULL AND nr_contrato_w::text <> '') then 
	select	nr_sequencia, 
		nr_contrato_principal 
	into STRICT	nr_seq_contrato_w, 
		nr_contrato_principal_w 
	from	pls_contrato 
	where	nr_contrato	= nr_contrato_w;
end if;
 
if (ie_tipo_proposta_w	in (2,4,6)) and (coalesce(nr_seq_contrato_w,0) <> 0) then 
	select	count(*) 
	into STRICT	qt_vidas_contrato_w 
	from	pls_segurado a, 
		pls_plano b 
	where	b.nr_sequencia		= a.nr_seq_plano 
	and	a.nr_seq_contrato	= nr_seq_contrato_w 
	and	((b.ie_tipo_contratacao	= ie_tipo_contratacao_w and (ie_tipo_contratacao_w IS NOT NULL AND ie_tipo_contratacao_w::text <> '')) 
	or (coalesce(ie_tipo_contratacao_w::text, '') = '')) 
	and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') 
	and	coalesce(a.dt_rescisao::text, '') = '';
	 
	if (coalesce(nr_contrato_principal_w,0) <> 0) then 
		select	count(*) 
		into STRICT	qt_vidas_contrato_princ_w 
		from	pls_segurado a, 
			pls_plano b 
		where	b.nr_sequencia		= a.nr_seq_plano 
		and	a.nr_seq_contrato	= nr_contrato_principal_w 
		and	((b.ie_tipo_contratacao	= ie_tipo_contratacao_w and (ie_tipo_contratacao_w IS NOT NULL AND ie_tipo_contratacao_w::text <> '')) 
		or (coalesce(ie_tipo_contratacao_w::text, '') = '')) 
		and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') 
		and	coalesce(a.dt_rescisao::text, '') = '';
	end if;		
end if;
 
qt_total_vidas_w	:= coalesce(qt_vidas_proposta_w,0) + coalesce(qt_vidas_contrato_w,0);
 
open C01;
loop 
fetch C01 into 
	nr_seq_benef_proposta_w, 
	nm_beneficiario_w, 
	cd_beneficiario_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	ie_exige_w			:= 'N';
	ds_obser_declaracao_ant_w	:= '';
	 
	/*obter dados do beneficiario da proposta*/
 
		 
	select	nr_seq_titular_contrato, 
		nr_seq_beneficiario, 
		ie_nascido_plano, 
		nr_seq_plano,	 
		nr_seq_parentesco, 
		dt_admissao 
	into STRICT	nr_seq_titular_contrato_w, 
		nr_seq_beneficiario_mig_w, 
		ie_nascido_plano_w, 
		nr_seq_plano_w, 
		nr_seq_parentesco_w, 
		dt_admissao_w 
	from	pls_proposta_beneficiario 
	where	nr_sequencia	= nr_seq_benef_proposta_w;
	 
	select	count(*) 
	into STRICT	qt_portabilidade_w 
	from 	pls_portab_pessoa 
	where 	cd_pessoa_fisica 	= cd_beneficiario_w 
	and 	ie_status 		= 'A' 
	and 	coalesce(ie_tipo_contratacao,ie_tipo_contratacao_w) 	= ie_tipo_contratacao_w;
	 
	if (qt_portabilidade_w > 0) then 
		ie_portabilidade_w := 'S';
	else 	 
		ie_portabilidade_w := 'N';
	end if;	
		 
	begin 
		select	ie_tipo_operacao, 
			ie_segmentacao 
		into STRICT	ie_tipo_operacao_w, 
			ie_segmentacao_w 
		from	pls_plano 
		where	nr_sequencia	= nr_seq_plano_w;
	exception 
	when others then 
		ie_tipo_operacao_w := null;
		ie_segmentacao_w  := null;
	end;
	 
	qt_dias_operadora_w	:= 0;
	qt_dias_rescindidos_w	:= 0;
	qt_dias_titular_ativo_w	:= 0;
	ie_possui_declaracao_w	:= 'N';
	ie_regulamentacao_benef_w	:= null;
	ie_tipo_contratacao_ant_w	:= null;
	 
	select	count(*) 
	into STRICT	qt_declaracao_ant_w 
	from	pls_declaracao_segurado 
	where	cd_pessoa_fisica	= cd_beneficiario_w 
	and	nr_seq_proposta_adesao	<> nr_seq_proposta_p;
	 
	if (qt_declaracao_ant_w	= 0) then 
		ie_possui_declaracao_w	:= 'N';
	else 
		ie_possui_declaracao_w	:= 'S';
	end if;		
	 
	 
	 
	if (nr_seq_beneficiario_mig_w IS NOT NULL AND nr_seq_beneficiario_mig_w::text <> '') then 
		select	a.ie_regulamentacao, 
			b.dt_inclusao_operadora, 
			b.dt_rescisao, 
			a.ie_tipo_contratacao, 
			b.cd_pessoa_fisica 
		into STRICT	ie_regulamentacao_benef_w, 
			dt_inclusao_operadora_w, 
			dt_rescisao_w, 
			ie_tipo_contratacao_ant_w, 
			cd_pessoa_fisica_ant_w 
		from	pls_segurado	b, 
			pls_plano	a 
		where	b.nr_seq_plano		= a.nr_sequencia 
		and	b.nr_sequencia	= nr_seq_beneficiario_mig_w;
		 
		if (coalesce(dt_rescisao_w::text, '') = '') then 
			qt_dias_operadora_w	:= round(clock_timestamp() - dt_inclusao_operadora_w);
			qt_dias_rescindidos_w	:= 0;
		else 
			qt_dias_operadora_w	:= round(dt_rescisao_w - dt_inclusao_operadora_w);
			qt_dias_rescindidos_w	:= round(clock_timestamp()	- dt_rescisao_w);
		end if;	
	end if;
	 
	if (nr_seq_titular_contrato_w IS NOT NULL AND nr_seq_titular_contrato_w::text <> '') then 
		select	a.ie_regulamentacao, 
			b.dt_inclusao_operadora, 
			b.dt_rescisao 
		into STRICT	ie_regulamentacao_titular_w, 
			dt_inclusao_operadora_w, 
			dt_rescisao_w 
		from	pls_segurado	b, 
			pls_plano	a 
		where	b.nr_seq_plano		= a.nr_sequencia 
		and	b.nr_sequencia		= nr_seq_titular_contrato_w;
		 
		if (coalesce(dt_rescisao_w::text, '') = '') then 
			qt_dias_titular_ativo_w	:= clock_timestamp() - dt_inclusao_operadora_w;
		else 
			qt_dias_titular_ativo_w	:= dt_rescisao_w - dt_inclusao_operadora_w;
		end if;	
	end if;	
	 
	open C02;
	loop 
	fetch C02 into 
		nr_seq_regra_declaracao_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
	 
		begin		 
		dt_inicio_vigencia_regra_w	:= null;
		dt_fim_vigencia_regra_w		:= null;
 
		select	d.dt_emissao_cert_casamento, 
			d.dt_nascimento 
		into STRICT	dt_casamento_w, 
			dt_nascimento_w 
		from	pessoa_fisica	d 
		where	cd_pessoa_fisica = cd_beneficiario_w;
 
		select	coalesce(ie_exige,'S'), 
			ie_tipo_data, 
			coalesce(qt_dias_inicial,0), 
			coalesce(qt_dias_final,0) 
		into STRICT	ie_exige_w, 
			ie_tipo_data_w, 
			qt_dias_inicial_w, 
			qt_dias_final_w 
		from	pls_regra_declaracao_prop 
		where	nr_sequencia	= nr_seq_regra_declaracao_w;		
		 
		if (ie_tipo_data_w = 'N') then 
			ie_exige_w	:= ie_exige_w;
		elsif (ie_tipo_data_w = 'A') then 
			dt_inicio_vigencia_regra_w	:= dt_admissao_w + qt_dias_inicial_w -1;
			dt_fim_vigencia_regra_w		:= dt_admissao_w + qt_dias_final_w;
			if	trunc(dt_inicio_proposta_w,'dd') between trunc(dt_inicio_vigencia_regra_w,'dd') and fim_dia(dt_fim_vigencia_regra_w) then 
				ie_exige_w	:= ie_exige_w;
			else 
				ie_exige_w	:= 'N';
			end if;
		elsif (ie_tipo_data_w = 'D') then 
			qt_dias_w := 	clock_timestamp() - dt_nascimento_w;
			if	coalesce(qt_dias_w,99999) between qt_dias_inicial_w and qt_dias_final_w then 
				ie_exige_w	:= ie_exige_w;
			else 
				ie_exige_w	:= 'N';
			end if;
		elsif (ie_tipo_data_w = 'C') then 
			qt_dias_w := 	clock_timestamp() - dt_casamento_w;
			if	coalesce(qt_dias_w,99999) between qt_dias_inicial_w and qt_dias_final_w then 
				ie_exige_w	:= ie_exige_w;
			else 
				ie_exige_w	:= 'N';
			end if;
		end if;
		end;
	end loop;
	close C02;
	 
	select	count(1) 
	into STRICT	qt_registros_w 
	from	pls_declaracao_segurado 
	where	cd_pessoa_fisica	= cd_beneficiario_w 
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');
	 
	/*aaschlote 14/03/2012 OS - 419781*/
 
	if (qt_registros_w > 0) then 
		select	max(dt_declaracao) 
		into STRICT	dt_declaracao_ant_w 
		from	pls_declaracao_segurado 
		where	cd_pessoa_fisica	= cd_beneficiario_w 
		and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');
		 
		ds_obser_declaracao_ant_w	:= substr(' - Obs: beneficiário já possui uma declaração realizada no dia '|| to_char(dt_declaracao_ant_w,'dd/mm/yyyy'),1,255);
	end if;
	 
	if (ie_exige_w	= 'S') then 
		update	pls_proposta_beneficiario 
		set	ie_exige_declaracao_saude = 'S' 
		where	nr_sequencia	= nr_seq_benef_proposta_w;
		 
		ds_lista_benef_w	:= substr(ds_lista_benef_w || nm_beneficiario_w || ds_obser_declaracao_ant_w ||chr(13) || chr(10),1,32764);
	else 
		update	pls_proposta_beneficiario 
		set	ie_exige_declaracao_saude = 'N' 
		where	nr_sequencia = nr_seq_benef_proposta_w;
	end if;	
	 
	if (length(ds_lista_benef_w) > 160) then 
		exit;
	end if;
	 
	end;
end loop;
close C01;
 
if (ds_lista_benef_w IS NOT NULL AND ds_lista_benef_w::text <> '') then 
	ds_mensagem_p	:= substr('O(s) beneficiário(s) não possuem declaração de saúde: ' || chr(13) || chr(10) || ds_lista_benef_w,1,255);
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_declaracao_prop ( nr_seq_proposta_p bigint, cd_estabelecimento_p bigint, ds_mensagem_p INOUT text) FROM PUBLIC;

