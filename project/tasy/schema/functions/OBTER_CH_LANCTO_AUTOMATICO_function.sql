-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ch_lancto_automatico (cd_estabelecimento_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_convenio_p bigint, cd_categoria_p text, dt_vigencia_p timestamp, ie_tipo_atendimento_p bigint, nr_seq_exame_p bigint) RETURNS bigint AS $body$
DECLARE

 
vl_lancamento_w		double precision := 0;
nr_seq_lancto_w		bigint;
cd_proc_lancto_w	bigint;
ie_origem_lancto_w	bigint;
cd_material_lancto_w	integer;
qt_lancamento_w		double precision;
vl_material_w		double precision;
vl_procedimento_w	double precision;
vl_outros_w		double precision;
dt_ult_vigencia_w	timestamp;
cd_tab_preco_mat_w	bigint;
ie_origem_preco_w	bigint;
cd_edicao_amb_w		bigint;
nr_sequencia_w		bigint := 0;
cd_tipo_acomodacao_w	bigint := 0;
cd_setor_atendimento_w	bigint := 0;
qt_idade_w		bigint := 0;
cd_funcao_medico_w	bigint := 0;

c01 CURSOR FOR 
	SELECT	cd_procedimento, 
		ie_origem_proced, 
		cd_material, 
		qt_lancamento + 1 
	from	regra_lanc_aut_pac 
	where	nr_seq_regra	= nr_seq_lancto_w 
	and 	coalesce(ie_adic_orcamento,'N') = 'N' 
	and	(cd_procedimento IS NOT NULL AND cd_procedimento::text <> '');


BEGIN 
 
select	coalesce(max(nr_sequencia), 0) 
into STRICT	nr_seq_lancto_w 
from	regra_lanc_automatico 
where	cd_estabelecimento	= cd_estabelecimento_p 
and	cd_procedimento		= cd_procedimento_p 
and	ie_origem_proced	= ie_origem_proced_p 
and (coalesce(cd_convenio::text, '') = '' or cd_convenio 	= cd_convenio_p) 
and	coalesce(cd_categoria, cd_categoria_p)	= cd_categoria_p 
and	nr_seq_exame				= nr_seq_exame_p;
 
if (nr_seq_lancto_w > 0) then 
	begin 
	open	c01;
	loop 
	fetch	c01 into 
		cd_proc_lancto_w, 
		ie_origem_lancto_w, 
		cd_material_lancto_w, 
		qt_lancamento_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		 
		select	OBTER_PRECO_AMB(cd_proc_lancto_w, 
			cd_convenio_p, 
			cd_categoria_p, 
			cd_estabelecimento_p, 'P') 
		into STRICT	vl_procedimento_w 
		;
 
		vl_lancamento_w	:= vl_lancamento_w + (qt_lancamento_w * vl_procedimento_w);
 
	end loop;
	close	c01;
	end;
end if;
 
 
if (vl_lancamento_w = 0) then 
	select	OBTER_PRECO_AMB(cd_procedimento_p, 
		cd_convenio_p, 
		cd_categoria_p, 
		cd_estabelecimento_p, 
		'P') 
	into STRICT	vl_lancamento_w 
	;
end if;
 
return	vl_lancamento_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ch_lancto_automatico (cd_estabelecimento_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_convenio_p bigint, cd_categoria_p text, dt_vigencia_p timestamp, ie_tipo_atendimento_p bigint, nr_seq_exame_p bigint) FROM PUBLIC;

