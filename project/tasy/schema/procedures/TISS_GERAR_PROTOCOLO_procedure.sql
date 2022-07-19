-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tiss_gerar_protocolo (nr_seq_protocolo_p bigint, nr_seq_med_prot_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


ie_tiss_tipo_guia_w		varchar(20);
nr_seq_prot_guia_w	bigint;
nr_protocolo_w		varchar(100);
cd_convenio_w		bigint;
cd_estabelecimento_w	bigint;
ie_ordem_w		bigint;
cd_autor_protocolo_w	varchar(100);
ie_guia_protocolo_w	varchar(100);
nr_seq_conta_guia_w	bigint;
nr_seq_guia_w		bigint;
nr_seq_apresent_w		bigint;
NR_PROTOCOLO_RI_w	varchar(100);
NR_PROTOCOLO_HONOR_w	varchar(100);
NR_PROTOCOLO_SPSADT_w	varchar(100);
NR_PROTOCOLO_CONS_w	varchar(100);
ds_mascara_lote_w	varchar(100);
ie_separar_spsadt_honor_w	varchar(10);
ie_ordenacao_xml_w	varchar(10);
ie_honorario_w		varchar(255);
cd_cgc_w			varchar(255);
cd_interno_w		varchar(255);
cd_cgc_compl_w		varchar(255);
cd_interno_compl_w	varchar(255);
cd_cgc_cab_w		varchar(255);
cd_interno_cab_w		varchar(255);
cd_interno_honor_w	varchar(255);
nr_cpf_honor_w		varchar(255);
nr_lote_convenio_w	bigint;
nr_separador_w		bigint;
ie_regra_w		varchar(10);
nr_interno_conta_w		bigint;
ie_despesas_w		varchar(10);
ie_lote_xml_despesa_w	varchar(10);
cd_cgc_cabecalho_regra_w	varchar(14);
nr_lote_convenio_old_w		tiss_protocolo_guia.nr_protocolo%type;
nr_lote_convenio_atual_w 	tiss_parametros_convenio.nr_lote_atual%type;
cd_prestador_convenio_w		protocolo_convenio.cd_prestador_convenio%type;
cd_prestador_convenio_ri_w	protocolo_convenio.cd_prestador_convenio_ri%type;
dt_periodo_inicial_w		protocolo_convenio.dt_periodo_inicial%type;
cd_interno_xml_w            	Tiss_protocolo_guia.cd_interno_xml%type;
cd_cnpj_xml_w           	Tiss_protocolo_guia.cd_cnpj_xml%type;
CD_ANS_W			tiss_protocolo_guia.cd_ans_xml%type;
ie_lote_prest_seq_protoc_w 	tiss_parametros_convenio.ie_lote_prest_seq_protoc%type;
nr_lote_aux     tiss_parametros_convenio.nr_lote_atual%type := 0;
c01 CURSOR FOR
SELECT	1 ie_ordem,
	a.ie_tiss_tipo_guia,
	null,
	null,
	null,
	b.cd_cgc,
	b.cd_interno,
	b.cd_cgc_compl,
	b.cd_interno_compl,
	b.cd_interno_honor,
	b.nr_cpf_honor,
	a.cd_cgc cd_cgc_cab,
	a.cd_interno cd_interno_cab,
	null nr_separador,
	null ie_despesas
from	tiss_regra_arq_adic_crit b,
	tiss_regra_arquivo_adic a
where	a.nr_sequencia		= b.nr_seq_regra
and	a.cd_convenio		= cd_convenio_w
and	ie_lote_xml_despesa_w	= 'N'
and	a.cd_estabelecimento	= cd_estabelecimento_p

union

SELECT	distinct 2 ie_ordem, 
	b.ie_tiss_tipo_guia,
	CASE WHEN ie_guia_protocolo_w='S' THEN  b.nr_sequencia  ELSE null END ,
	CASE WHEN ie_guia_protocolo_w='S' THEN  coalesce(to_char(a.nr_conta_convenio), b.cd_autorizacao)  ELSE null END ,
	null ie_honorario,
	null cd_cgc,
	null cd_interno,
	null cd_cgc_compl,
	null cd_interno_compl,
	null cd_interno_honor,
	null nr_cpf_honor,
	cd_cgc_cabecalho_regra_w cd_cgc_cab,
	null cd_interno_cab,
	null nr_separador,
	null ie_despesas
from	tiss_conta_guia b,
	conta_paciente a
where	a.nr_interno_conta		= b.nr_interno_conta
and	a.nr_seq_protocolo		= nr_seq_protocolo_p
and	ie_separar_spsadt_honor_w	= 'N'
and	ie_lote_xml_despesa_w		= 'N'
and	ie_guia_protocolo_w		<> 'R'

union

select	distinct 3 ie_ordem, 
	b.ie_tiss_tipo_guia,
	CASE WHEN ie_guia_protocolo_w='S' THEN  b.nr_sequencia  ELSE null END ,
	CASE WHEN ie_guia_protocolo_w='S' THEN  coalesce(to_char(a.nr_conta_convenio), b.cd_autorizacao)  ELSE null END ,
	b.ie_honorario,
	null cd_cgc,
	null cd_interno,
	null cd_cgc_compl,
	null cd_interno_compl,
	null cd_interno_honor,
	null nr_cpf_honor,
	cd_cgc_cabecalho_regra_w cd_cgc_cab,
	null cd_interno_cab,
	null nr_separador,
	null ie_despesas
from	tiss_conta_guia b,
	conta_paciente a
where	a.nr_interno_conta		= b.nr_interno_conta
and	a.nr_seq_protocolo		= nr_seq_protocolo_p
and	ie_separar_spsadt_honor_w	= 'S'
and	ie_lote_xml_despesa_w		= 'N'
and	ie_guia_protocolo_w		= 'S'

union

select	distinct 2 ie_ordem, 
	b.ie_tiss_tipo_guia,
	null,
	to_char(CASE WHEN TISS_OBTER_REGRA_LOTE_GUIA(cd_estabelecimento_w,cd_convenio_w,b.ie_tiss_tipo_guia)='P' THEN null WHEN TISS_OBTER_REGRA_LOTE_GUIA(cd_estabelecimento_w,cd_convenio_w,b.ie_tiss_tipo_guia)='A' THEN a.nr_atendimento WHEN TISS_OBTER_REGRA_LOTE_GUIA(cd_estabelecimento_w,cd_convenio_w,b.ie_tiss_tipo_guia)='C' THEN a.nr_interno_conta WHEN TISS_OBTER_REGRA_LOTE_GUIA(cd_estabelecimento_w,cd_convenio_w,b.ie_tiss_tipo_guia)='G' THEN b.nr_sequencia END ),
	null ie_honorario,
	null cd_cgc,
	null cd_interno,
	null cd_cgc_compl,
	null cd_interno_compl,
	null cd_interno_honor,
	null nr_cpf_honor,
	cd_cgc_cabecalho_regra_w cd_cgc_cab,
	null cd_interno_cab,
	CASE WHEN TISS_OBTER_REGRA_LOTE_GUIA(cd_estabelecimento_w,cd_convenio_w,b.ie_tiss_tipo_guia)='P' THEN null WHEN TISS_OBTER_REGRA_LOTE_GUIA(cd_estabelecimento_w,cd_convenio_w,b.ie_tiss_tipo_guia)='A' THEN a.nr_atendimento WHEN TISS_OBTER_REGRA_LOTE_GUIA(cd_estabelecimento_w,cd_convenio_w,b.ie_tiss_tipo_guia)='C' THEN a.nr_interno_conta WHEN TISS_OBTER_REGRA_LOTE_GUIA(cd_estabelecimento_w,cd_convenio_w,b.ie_tiss_tipo_guia)='G' THEN b.nr_sequencia END  nr_separador,
	null ie_despesas
from	tiss_conta_guia b,
	conta_paciente a
where	a.nr_interno_conta		= b.nr_interno_conta
and	a.nr_seq_protocolo		= nr_seq_protocolo_p
and	ie_separar_spsadt_honor_w	= 'N'
and	ie_lote_xml_despesa_w		= 'N'
and	ie_guia_protocolo_w		= 'R'

union

select	distinct 3 ie_ordem, 
	b.ie_tiss_tipo_guia,
	null,
	null,
	b.ie_honorario,
	null cd_cgc,
	null cd_interno,
	null cd_cgc_compl,
	null cd_interno_compl,
	null cd_interno_honor,
	null nr_cpf_honor,
	cd_cgc_cabecalho_regra_w cd_cgc_cab,
	null cd_interno_cab,
	null nr_separador,
	null ie_despesas
from	tiss_conta_guia b,
	conta_paciente a
where	a.nr_interno_conta		= b.nr_interno_conta
and	a.nr_seq_protocolo		= nr_seq_protocolo_p
and	ie_separar_spsadt_honor_w	= 'S'
and	ie_lote_xml_despesa_w		= 'N'
and	ie_guia_protocolo_w		= 'N'

union

select	distinct 3 ie_ordem, 
	b.ie_tiss_tipo_guia,
	null,
	null,	
	b.ie_honorario,
	null cd_cgc,
	null cd_interno,
	null cd_cgc_compl,
	null cd_interno_compl,
	null cd_interno_honor,
	null nr_cpf_honor,
	cd_cgc_cabecalho_regra_w cd_cgc_cab,
	null cd_interno_cab,
	null nr_separador,
	'N' ie_despesas
from	tiss_conta_guia b,
	conta_paciente a
where	a.nr_interno_conta		= b.nr_interno_conta
and	a.nr_seq_protocolo		= nr_seq_protocolo_p
and	not exists (select 1 from tiss_conta_desp x where x.nr_seq_guia = b.nr_sequencia)
and	ie_separar_spsadt_honor_w	= 'N'
and	ie_lote_xml_despesa_w		= 'S'
and	ie_guia_protocolo_w		= 'N'

union

select	distinct 3 ie_ordem, 
	b.ie_tiss_tipo_guia,
	null,
	null,	
	b.ie_honorario,
	null cd_cgc,
	null cd_interno,
	null cd_cgc_compl,
	null cd_interno_compl,
	null cd_interno_honor,
	null nr_cpf_honor,
	cd_cgc_cabecalho_regra_w cd_cgc_cab,
	null cd_interno_cab,
	null nr_separador,
	'S' ie_despesas
from	tiss_conta_guia b,
	conta_paciente a
where	a.nr_interno_conta		= b.nr_interno_conta
and	a.nr_seq_protocolo		= nr_seq_protocolo_p
and	exists (select 1 from tiss_conta_desp x where x.nr_seq_guia = b.nr_sequencia)
and	ie_separar_spsadt_honor_w	= 'N'
and	ie_lote_xml_despesa_w		= 'S'
and	ie_guia_protocolo_w		= 'N'

union

select	distinct 4 ie_ordem, 
	b.ie_tiss_tipo_guia,
	null,
	null,
	null ie_honorario,
	null cd_cgc,
	null cd_interno,
	null cd_cgc_compl,
	null cd_interno_compl,
	null cd_interno_honor,
	null nr_cpf_honor,
	null cd_cgc_cab,
	null cd_interno_cab,
	null nr_separador,
	null ie_despesas
from	tiss_conta_guia b,
	med_faturamento a

where	b.nr_seq_prot_med	= a.nr_seq_protocolo
and	a.nr_atendimento		= nr_atend_med
and	a.nr_seq_protocolo		= nr_seq_med_prot_p
order	by 1;

c02 CURSOR FOR
SELECT	a.nr_sequencia
from	tiss_protocolo_guia b,
	tiss_conta_atend d,
	conta_paciente c,
	tiss_conta_guia a
where	a.nr_seq_prot_guia		= b.nr_sequencia
and	c.nr_interno_conta		= a.nr_interno_conta
and	b.nr_seq_protocolo		= nr_seq_protocolo_p
and	d.nr_interno_conta		= a.nr_interno_conta
and	coalesce(ie_ordenacao_xml_w,'P')	<> 'P'
order by	CASE WHEN ie_ordenacao_xml_w='S' THEN  c.nr_seq_apresent  ELSE 0 END ,
	CASE WHEN ie_ordenacao_xml_w='G' THEN  a.cd_autorizacao  ELSE 'X' END ,
	CASE WHEN ie_ordenacao_xml_w='D' THEN  d.dt_entrada END ,
	CASE WHEN ie_ordenacao_xml_w='V' THEN  c.nr_atendimento  ELSE 0 END ,
	CASE WHEN ie_ordenacao_xml_w='V' THEN  a.cd_senha  ELSE 'X' END ,
	CASE WHEN ie_ordenacao_xml_w='H' THEN  a.ie_honorario  ELSE 'X' END  desc,
	CASE WHEN ie_ordenacao_xml_w='H' THEN  a.nr_interno_conta  ELSE 0 END  desc,
	c.nr_atendimento;

c03 CURSOR FOR
SELECT	nr_interno_conta
from	conta_paciente
where	nr_seq_protocolo	= nr_seq_protocolo_p
group by nr_interno_conta;


BEGIN

if (coalesce(nr_seq_protocolo_p,0) > 0) then
	select	coalesce(max(nr_seq_doc_convenio), max(nr_seq_protocolo)),
		max(cd_convenio),
		max(cd_estabelecimento),
		max(NR_PROTOCOLO_RI),
		max(NR_PROTOCOLO_HONOR),
		max(NR_PROTOCOLO_SPSADT),
		max(NR_PROTOCOLO_CONS),
		max(tiss_obter_cgc_prest_protocolo(cd_estabelecimento,cd_setor_atendimento,ie_tipo_protocolo,cd_convenio,cd_categoria,cd_procedencia)),
		max(cd_prestador_convenio),
		max(cd_prestador_convenio_ri),
		max(dt_periodo_inicial)
	into STRICT	nr_protocolo_w,
		cd_convenio_w,
		cd_estabelecimento_w,
		NR_PROTOCOLO_RI_w,
		NR_PROTOCOLO_HONOR_w,
		NR_PROTOCOLO_SPSADT_w,
		NR_PROTOCOLO_CONS_w,
		cd_cgc_cabecalho_regra_w,
		cd_prestador_convenio_w,
		cd_prestador_convenio_ri_w,
		dt_periodo_inicial_w
	from	protocolo_convenio
	where	nr_seq_protocolo	= nr_seq_protocolo_p;

elsif (coalesce(nr_seq_med_prot_p,0) > 0) then

	select	max(nr_sequencia),
		max(cd_convenio),
		max(cd_estabelecimento_p)
	into STRICT	nr_protocolo_w,
		cd_convenio_w,
		cd_estabelecimento_w
	from	med_prot_convenio
	where	nr_sequencia	= nr_seq_med_prot_p;

end if;

select	coalesce(max(ie_guia_protocolo), 'N'),
	max(ds_mascara_lote),
	coalesce(max(ie_separar_spsadt_honor), 'N'),
	coalesce(max(ie_ordenacao_xml),'P'),
	coalesce(max(ie_lote_xml_despesa),'N')
into STRICT	ie_guia_protocolo_w,
	ds_mascara_lote_w,
	ie_separar_spsadt_honor_w,
	ie_ordenacao_xml_w,
	ie_lote_xml_despesa_w
from	tiss_parametros_convenio
where	cd_convenio		= cd_convenio_w
and	cd_estabelecimento	= cd_estabelecimento_w;

update	tiss_conta_guia a
set	a.nr_seq_prot_guia	 = NULL
where	exists (SELECT	/*+index(conpaci_pk) */			1
		from	conta_paciente x
		where	x.nr_interno_conta	= a.nr_interno_conta
		and	x.nr_seq_protocolo	= nr_seq_protocolo_p);

update	tiss_conta_guia a
set	a.nr_seq_prot_guia	 = NULL
where	exists (SELECT	1
		from	med_faturamento x
		where	x.nr_sequencia		= a.nr_seq_med_fatur
		and	x.nr_seq_protocolo	= nr_seq_med_prot_p);

if (coalesce(nr_seq_protocolo_p,0) > 0) then

	select	coalesce(min(nr_protocolo),0)
	into STRICT	nr_lote_convenio_old_w
	from 	tiss_protocolo_guia
	where	nr_seq_protocolo	= nr_seq_protocolo_p;

	delete	from tiss_protocolo_guia
	where	nr_seq_protocolo	= nr_seq_protocolo_p;
elsif (coalesce(nr_seq_med_prot_p,0) > 0) then
	delete	from tiss_protocolo_guia
	where	nr_seq_med_prot		= nr_seq_med_prot_p;
end if;

--pegar o valor da regra atual para atualizar no fim
select	max(nr_lote_atual),
	coalesce(max(ie_lote_prest_seq_protoc), 'N')
into STRICT	nr_lote_convenio_atual_w,
	ie_lote_prest_seq_protoc_w
from	tiss_parametros_convenio
where	cd_convenio		= cd_convenio_w
and		cd_estabelecimento	= cd_estabelecimento_w;

if (ie_lote_prest_seq_protoc_w = 'S' and	nr_seq_protocolo_p > 0) then
	nr_protocolo_w := nr_seq_protocolo_p;
end if;

open c01;
loop
fetch c01 into
	ie_ordem_w,
	ie_tiss_tipo_guia_w,
	nr_seq_conta_guia_w,
	cd_autor_protocolo_w,
	ie_honorario_w,
	cd_cgc_w,
	cd_interno_w,
	cd_cgc_compl_w,
	cd_interno_compl_w,
	cd_interno_honor_w,
	nr_cpf_honor_w,
	cd_cgc_cab_w,
	cd_interno_cab_w,
	nr_separador_w,
	ie_despesas_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	ie_regra_w	:= coalesce(TISS_OBTER_REGRA_LOTE_GUIA(cd_estabelecimento_w,cd_convenio_w,ie_tiss_tipo_guia_w),'P');

	select	max(nr_sequencia)
	into STRICT	nr_seq_prot_guia_w
	from	tiss_protocolo_guia
	where	((NR_SEQ_PROTOCOLO		= nr_seq_protocolo_p) or (nr_seq_Med_prot			= nr_seq_Med_prot_p))
	and	IE_TISS_TIPO_GUIA		= ie_tiss_tipo_guia_w
	and	NR_PROTOCOLO			= coalesce(cd_autor_protocolo_w, nr_protocolo_w)
	and	(((coalesce(cd_cgc_cab::text, '') = '')		and (coalesce(cd_cgc_cab_w::text, '') = '')) or	/* Edgar 29/04/2009, OS 139646, tratamento para arquivos adicionais */
		 (cd_cgc_cab = cd_cgc_cab_w))
	and	(((coalesce(cd_interno_cab::text, '') = '') and (coalesce(cd_interno_cab_w::text, '') = '')) or (cd_interno_cab = cd_interno_cab_w))
	and	((ie_separar_spsadt_honor_w 	= 'N') or (coalesce(ie_honorario,'N')			= coalesce(ie_honorario_w,'N')))
	and	((coalesce(ie_lote_xml_despesa_w,'N') = 'N') or (ie_despesas			= ie_despesas_w));

	if (ie_tiss_tipo_guia_w = '3') and (NR_PROTOCOLO_CONS_w IS NOT NULL AND NR_PROTOCOLO_CONS_w::text <> '') and (ie_guia_protocolo_w	= 'N') and (ie_separar_spsadt_honor_w = 'N') then
		cd_autor_protocolo_w	:= NR_PROTOCOLO_CONS_w;
	elsif (ie_tiss_tipo_guia_w = '4') and (NR_PROTOCOLO_SPSADT_w IS NOT NULL AND NR_PROTOCOLO_SPSADT_w::text <> '') and (ie_guia_protocolo_w	= 'N') and (ie_separar_spsadt_honor_w = 'N') then
		cd_autor_protocolo_w	:= NR_PROTOCOLO_SPSADT_w;
	elsif (ie_tiss_tipo_guia_w = '5') and (NR_PROTOCOLO_RI_w IS NOT NULL AND NR_PROTOCOLO_RI_w::text <> '') and (ie_guia_protocolo_w	= 'N') and (ie_separar_spsadt_honor_w = 'N') then
		cd_autor_protocolo_w	:= NR_PROTOCOLO_RI_w;
	elsif (ie_tiss_tipo_guia_w = '6') and (NR_PROTOCOLO_HONOR_w IS NOT NULL AND NR_PROTOCOLO_HONOR_w::text <> '') and (ie_guia_protocolo_w	= 'N') and (ie_separar_spsadt_honor_w = 'N') then
		cd_autor_protocolo_w	:= NR_PROTOCOLO_HONOR_w;
	end if;

	select	max(nr_lote_atual)
	into STRICT	nr_lote_convenio_w
	from	tiss_parametros_convenio
	where	cd_convenio		= cd_convenio_w
	and	cd_estabelecimento	= cd_estabelecimento_w;

	nr_protocolo_w			:= coalesce(cd_autor_protocolo_w, nr_protocolo_w);

	if (coalesce(nr_lote_convenio_w,0) > 0) then

        if nr_lote_convenio_old_w = 0 then

		update	tiss_parametros_convenio
		set	nr_lote_atual		= nr_lote_atual + 1,
			nm_usuario		= nm_usuario_p,
			dt_atualizacao		= clock_timestamp()
		where	cd_convenio		= cd_convenio_w
		and	cd_estabelecimento	= cd_estabelecimento_w
		returning nr_lote_atual into nr_protocolo_w;

        else
            if nr_lote_aux = 0 then
                nr_lote_aux := nr_lote_convenio_old_w;
            else
                nr_lote_aux := nr_lote_aux + 1;
            end if;

        end if;

		if (nr_lote_aux > 0) then
			nr_protocolo_w		:= nr_lote_aux;
		end 	if;

	end if;
	if	((ds_mascara_lote_w IS NOT NULL AND ds_mascara_lote_w::text <> '') and (length(nr_protocolo_w) < length(ds_mascara_lote_w)) and (somente_numero(nr_protocolo_w) > 0)) then
        nr_protocolo_w		:= trim(both to_char(somente_numero(nr_protocolo_w), ds_mascara_lote_w));
	end if;

	if (coalesce(nr_seq_prot_guia_w::text, '') = '') then

		select	nextval('tiss_protocolo_guia_seq')
		into STRICT	nr_seq_prot_guia_w
		;
		if	((ie_tiss_tipo_guia_w IN ('3','4','6')) and (cd_prestador_convenio_w IS NOT NULL AND cd_prestador_convenio_w::text <> '') and (coalesce(cd_interno_cab_w::text, '') = ''))then
			--VARCHAR2 DE 30
			cd_interno_cab_w := SUBSTR(cd_prestador_convenio_w,1,30);
		elsif	((ie_tiss_tipo_guia_w = '5') and ((coalesce(cd_prestador_convenio_ri_w, cd_prestador_convenio_w) IS NOT NULL AND (coalesce(cd_prestador_convenio_ri_w, cd_prestador_convenio_w))::text <> '')) and (coalesce(cd_interno_cab_w::text, '') = '')) then
			cd_interno_cab_w := substr(coalesce(cd_prestador_convenio_ri_w, cd_prestador_convenio_w),1,30);
		end if;
		
		if (nr_seq_protocolo_p > 0) then

			begin
			select	substr(coalesce(cd_interno_cab_w,
				coalesce(CASE WHEN ie_tiss_tipo_guia_w='3' THEN  				cd_prestador_convenio_w WHEN ie_tiss_tipo_guia_w='4' THEN  				cd_prestador_convenio_w WHEN ie_tiss_tipo_guia_w='6' THEN  				cd_prestador_convenio_w WHEN ie_tiss_tipo_guia_w='5' THEN  				coalesce(cd_prestador_convenio_ri_w, cd_prestador_convenio_w)  ELSE null END , 
				tiss_obter_codigo_prestador(cd_convenio_w, cd_estabelecimento_p,null,null, (null)::numeric , 'CI', dt_periodo_inicial_w, null))),1,20)
			into STRICT	cd_interno_xml_w
			;
			exception	
				when others then
				cd_interno_xml_w := null;
			end;
			
			begin				
			select	substr(CASE WHEN coalesce(cd_cgc_cab_w || cd_interno_cab_w, 'X')='X' THEN					CASE WHEN coalesce(cd_prestador_convenio_w, 'X')='X' THEN   					tiss_obter_codigo_prestador(cd_convenio_w,cd_estabelecimento_p,null,null, (null)::numeric , 'CGC', dt_periodo_inicial_w, null)  ELSE null END   ELSE CASE WHEN coalesce(cd_interno_cab_w, 'X')='X' THEN  cd_cgc_cab_w  ELSE null END  END ,1,14)
			into STRICT	cd_cnpj_xml_w
			;
			exception
				when others then
				cd_cnpj_xml_w := null;
			end;
			
			begin
			select	coalesce(a.cd_ans, coalesce(d.cd_ans,c.cd_ans))
			into STRICT	CD_ANS_W
			from	pessoa_juridica c,
				convenio_estabelecimento d,
				convenio b,
				protocolo_convenio a	
			where	a.cd_convenio		= b.cd_convenio
			and	b.cd_cgc			= c.cd_cgc
			and	d.cd_convenio 		= a.cd_convenio
			and	d.cd_estabelecimento = a.cd_estabelecimento
			and	a.nr_seq_protocolo	= nr_seq_protocolo_p;
			exception
				when others then
				CD_ANS_W := null;
			end;

		end if;		

		insert into tiss_protocolo_guia(NR_SEQUENCIA,
			DT_ATUALIZACAO,
			NM_USUARIO,
			DT_ATUALIZACAO_NREC,
			NM_USUARIO_NREC,
			NR_SEQ_PROTOCOLO,
			IE_TISS_TIPO_GUIA,
			NR_PROTOCOLO,
			ie_honorario,
			nr_seq_med_prot,
			cd_cgc_cab,
			cd_interno_cab,
			cd_cgc,
			cd_interno,
			cd_cgc_compl,
			cd_interno_compl,
			cd_interno_honor,
			nr_cpf_honor,
			ie_despesas,
			cd_interno_xml,
			cd_cnpj_xml,
			cd_ans_xml)
		values (nr_seq_prot_guia_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_protocolo_p,
			ie_tiss_tipo_guia_w,
			nr_protocolo_w,
			ie_honorario_w,
			nr_seq_med_prot_p,
			cd_cgc_cab_w,
			cd_interno_cab_w,
			cd_cgc_w,
			cd_interno_w,
			cd_cgc_compl_w,
			cd_interno_compl_w,
			cd_interno_honor_w,
			nr_cpf_honor_w,
			ie_despesas_w,
			cd_interno_xml_w,
			cd_cnpj_xml_w,
			CD_ANS_W);
	end if;

	if (ie_guia_protocolo_w <> 'R') then

		update	tiss_conta_guia a
		set	a.nr_seq_prot_guia		= nr_seq_prot_guia_w
		where	a.nr_seq_prot_conta		= nr_seq_protocolo_p
		and	a.ie_tiss_tipo_guia		= ie_tiss_tipo_guia_w		
		and	a.nr_sequencia			= coalesce(nr_seq_conta_guia_w, a.nr_sequencia)
		and	coalesce(a.nr_seq_prot_guia::text, '') = ''
		and	((ie_separar_spsadt_honor_w	= 'N') or (coalesce(ie_honorario,'N')		= coalesce(ie_honorario_w, 'N')))
		and	((coalesce(ie_lote_xml_despesa_w,'N') = 'N') or
			 ((ie_despesas_w	= 'N' and not exists (SELECT 1 from tiss_conta_desp x where x.nr_seq_guia = a.nr_sequencia)) or (ie_despesas_w	= 'S' and exists (select 1 from tiss_conta_desp x where x.nr_seq_guia = a.nr_sequencia)) or (coalesce(ie_despesas_w::text, '') = '')))		
		and	tiss_obter_se_prot_guia(nr_seq_prot_guia_w, a.nr_sequencia) = 'S';

	else /*Inicio tratamento para separar os arquivos conforme regra.*/
		if (ie_regra_w = 'A') then --Separar por atendimento		
			update	tiss_conta_guia a
			set	a.nr_seq_prot_guia				= nr_seq_prot_guia_w
			where	a.nr_seq_prot_conta				= nr_seq_protocolo_p
			and	a.ie_tiss_tipo_guia				= ie_tiss_tipo_guia_w
			and	obter_atendimento_conta(a.nr_interno_conta)	= nr_separador_w
			and	coalesce(a.nr_seq_prot_guia::text, '') = ''
			and	((ie_separar_spsadt_honor_w	= 'N') or (coalesce(ie_honorario,'N')		= coalesce(ie_honorario_w, 'N')))			
			and	tiss_obter_se_prot_guia(nr_seq_prot_guia_w, a.nr_sequencia) = 'S';

		elsif (ie_regra_w = 'C') then	--Separar por conta		
			update	tiss_conta_guia a
			set	a.nr_seq_prot_guia		= nr_seq_prot_guia_w
			where	a.nr_seq_prot_conta		= nr_seq_protocolo_p
			and	a.ie_tiss_tipo_guia		= ie_tiss_tipo_guia_w
			and	a.nr_interno_conta		= nr_separador_w
			and	coalesce(a.nr_seq_prot_guia::text, '') = ''
			and	((ie_separar_spsadt_honor_w	= 'N') or (coalesce(ie_honorario,'N')		= coalesce(ie_honorario_w, 'N')))			
			and	tiss_obter_se_prot_guia(nr_seq_prot_guia_w, a.nr_sequencia) = 'S';

		elsif (ie_regra_w in ('G','P')) then --Separa por guia ou de forma padrao		
			update	tiss_conta_guia a
			set	a.nr_seq_prot_guia		= nr_seq_prot_guia_w
			where	a.nr_seq_prot_conta		= nr_seq_protocolo_p
			and	a.ie_tiss_tipo_guia		= ie_tiss_tipo_guia_w
			and	a.nr_sequencia			= coalesce(nr_separador_w, a.nr_sequencia)
			and	coalesce(a.nr_seq_prot_guia::text, '') = ''
			and	((ie_separar_spsadt_honor_w	= 'N') or (coalesce(ie_honorario,'N')		= coalesce(ie_honorario_w, 'N')))			
			and	tiss_obter_se_prot_guia(nr_seq_prot_guia_w, a.nr_sequencia) = 'S';

		end if;		
	end if;

	if (coalesce(nr_seq_med_prot_p,0) > 0) then

		-- Tratar xml do TasyMed
		update	tiss_conta_guia a
		set	a.nr_seq_prot_guia	= nr_seq_prot_guia_w
		where	a.ie_tiss_tipo_guia	= ie_tiss_tipo_guia_w
		and	coalesce(a.nr_seq_prot_guia::text, '') = ''
		and	a.nr_sequencia		= coalesce(nr_seq_conta_guia_w, a.nr_sequencia)
		and	((ie_separar_spsadt_honor_w	= 'N') or (coalesce(ie_honorario,'N')		= coalesce(ie_honorario_w, 'N')))
		and	exists (SELECT	1
				from	med_faturamento x
				where	x.nr_sequencia		= a.nr_seq_med_fatur
				and	x.nr_seq_protocolo	= nr_seq_med_prot_p);
	end if;

	commit;

end loop;
close c01;

select	max(nr_lote_atual)
into STRICT	nr_lote_convenio_w
from	tiss_parametros_convenio
where	cd_convenio		= cd_convenio_w
and	cd_estabelecimento	= cd_estabelecimento_w;

if (coalesce(nr_lote_convenio_w,0) > 0)  and (nr_lote_aux > nr_lote_convenio_w) then

	update	tiss_parametros_convenio
	set	nr_lote_atual		= nr_lote_aux,
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp()
	where	cd_convenio		= cd_convenio_w
	and	cd_estabelecimento	= cd_estabelecimento_w;
end if;

delete	from tiss_protocolo_guia a
where 	a.nr_seq_protocolo	= nr_seq_protocolo_p
and	not exists (SELECT 1 from tiss_conta_guia x where x.nr_seq_prot_guia = a.nr_sequencia);

nr_seq_apresent_w	:= 1;

open c02;
loop
fetch c02 into
	nr_seq_guia_w;
EXIT WHEN NOT FOUND; /* apply on c02 */

	update	tiss_conta_guia
	set	nr_seq_apresentacao	= nr_seq_apresent_w
	where	nr_sequencia		= nr_seq_guia_w;

	nr_seq_apresent_w	:= nr_seq_apresent_w + 1;

	commit;

end loop;
close c02;

update	tiss_protocolo_guia x
set	x.vl_total_protocolo = 	(SELECT	sum(a.VL_TOTAL) VL_TOTAL
				from   	tiss_conta_guia a
				where  	a.nr_seq_prot_guia = x.nr_sequencia)
where	x.nr_sequencia in (	select  w.nr_sequencia
				from    tiss_protocolo_guia w
				where   w.nr_seq_protocolo = nr_seq_protocolo_p);
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tiss_gerar_protocolo (nr_seq_protocolo_p bigint, nr_seq_med_prot_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

