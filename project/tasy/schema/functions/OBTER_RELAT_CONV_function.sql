-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_relat_conv ( nr_atendimento_p bigint, nr_prescricao_p bigint) RETURNS varchar AS $body$
DECLARE

 
cd_relatorio_w		bigint;
cd_convenio_w		integer;
ie_tipo_atendimento_w	smallint;
cd_setor_atendimento_w	integer;
cd_estabelecimento_w	smallint;

C01 CURSOR FOR 
	SELECT	x.cd_relatorio 
	from	CONVENIO_SOLIC_EXAME_REL a, 
		relatorio x 
	where	a.nr_seq_relatorio	= x.nr_sequencia 
	and	cd_estabelecimento	= cd_estabelecimento_w 
	and	((coalesce(a.cd_convenio::text, '') = '')		or (coalesce(cd_convenio_w::text, '') = '')		or (cd_convenio			= cd_convenio_w)) 
	and	((coalesce(a.cd_setor_atendimento::text, '') = '')	or (coalesce(cd_setor_atendimento_w::text, '') = '')	or (cd_setor_atendimento	= cd_setor_atendimento_w)) 
	and	((coalesce(a.ie_tipo_atendimento::text, '') = '')	or (coalesce(ie_tipo_atendimento_w::text, '') = '')	or (ie_tipo_atendimento		= ie_tipo_atendimento_w)) 
	order by	coalesce(cd_convenio,0), 
			coalesce(cd_setor_atendimento,0), 
			coalesce(ie_tipo_atendimento,0);


BEGIN 
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then 
	select	OBTER_CONVENIO_ATENDIMENTO(nr_atendimento_p), 
		a.cd_setor_atendimento, 
		b.ie_tipo_atendimento, 
		b.cd_estabelecimento	 
	into STRICT	cd_convenio_w, 
		cd_setor_atendimento_w, 
		ie_tipo_atendimento_w, 
		cd_estabelecimento_w 
	from	atendimento_paciente b, 
		prescr_medica a 
	where	a.nr_atendimento	= b.nr_atendimento 
	and	a.nr_prescricao		= nr_prescricao_p 
	and	b.nr_atendimento	= nr_atendimento_p;
	 
else 
	select	OBTER_CONVENIO_ATENDIMENTO(nr_atendimento_p), 
		obter_setor_atendimento(nr_atendimento_p), 
		b.ie_tipo_atendimento, 
		b.cd_estabelecimento	 
	into STRICT	cd_convenio_w, 
		cd_setor_atendimento_w, 
		ie_tipo_atendimento_w, 
		cd_estabelecimento_w 
	from	atendimento_paciente b 
	where	b.nr_atendimento	= nr_atendimento_p;
end if;
 
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then 
	OPEN C01;
		LOOP 
		FETCH C01 into 
			cd_relatorio_w;	
		EXIT WHEN NOT FOUND; /* apply on c01 */
			cd_relatorio_w	:= cd_relatorio_w;
		END LOOP;
	CLOSE C01;
end if;
 
return cd_relatorio_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_relat_conv ( nr_atendimento_p bigint, nr_prescricao_p bigint) FROM PUBLIC;

