-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_consist_ex_adic_mmed ( cd_agenda_p bigint, nr_seq_item_p bigint, ie_tipo_agendamento_p text, cd_convenio_p bigint, cd_categoria_p text, cd_estabelecimento_p bigint, cd_plano_p text, cd_profissional_p text, nr_seq_proc_interno_p bigint, ds_exames_p INOUT text) AS $body$
DECLARE

 
qt_regra_w		bigint;
ds_exame_w		varchar(100);
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
cd_area_proced_w		integer;
cd_espec_proced_w	integer;
cd_grupo_proced_w	bigint;
nr_seq_regra_w		bigint;
qt_exclusivo_w		bigint;
nr_seq_regra_final_w	bigint;
ie_permite_w		varchar(1);
nr_seq_grupo_w		bigint;
ds_exame_ww		varchar(255);
ds_exame_grupo_w		varchar(255);
nr_seq_grupo_selec_w	bigint;

C02 CURSOR FOR 
	SELECT	nr_sequencia 
	from	agenda_regra 
	where	coalesce(cd_estabelecimento, cd_Estabelecimento_p) = cd_estabelecimento_p 
	and	cd_agenda = cd_agenda_p 
	and	((cd_convenio = cd_convenio_p) or (coalesce(cd_convenio::text, '') = '')) 
	and	((cd_categoria = cd_categoria_p) or (coalesce(cd_categoria::text, '') = '')) 
	and	((cd_plano_convenio = cd_plano_p) or (coalesce(cd_plano_convenio::text, '') = '')) 
	and	((cd_area_proc = cd_area_proced_w) or (coalesce(cd_area_proc::text, '') = '')) 
	and	((cd_especialidade = cd_espec_proced_w) or (coalesce(cd_especialidade::text, '') = '')) 
	and	((cd_grupo_proc = cd_grupo_proced_w) or (coalesce(cd_grupo_proc::text, '') = '')) 
	and	((cd_procedimento = cd_procedimento_w) or (coalesce(cd_procedimento::text, '') = '')) 
	and	((coalesce(cd_procedimento::text, '') = '') or ((ie_origem_proced = ie_origem_proced_w) or (coalesce(ie_origem_proced::text, '') = ''))) 
	and	((nr_seq_proc_interno = nr_seq_proc_interno_p) or (coalesce(nr_seq_proc_interno::text, '') = '')) 
	and	((cd_medico = cd_profissional_p) or (coalesce(cd_medico::text, '') = '')) 
	and	ie_permite in ('S','N') 
	and	coalesce(nr_seq_grupo_ageint::text, '') = '' 
	and	coalesce(ie_situacao,'A') = 'A' 
	order by coalesce(cd_procedimento,0), 
		coalesce(nr_seq_proc_interno,0), 
		coalesce(cd_area_proc,0), 
		coalesce(cd_especialidade,0), 
		coalesce(cd_grupo_proc,0), 
		coalesce(cd_convenio, 0), 
		coalesce(cd_medico, 0);


BEGIN 
ds_exame_ww	:= '';
ie_permite_w	:= 'N';	
 
SELECT * FROM obter_proc_tab_interno_conv( 
			nr_seq_proc_interno_p, cd_estabelecimento_p, cd_convenio_p, cd_categoria_p, cd_plano_p, null, cd_procedimento_w, ie_origem_proced_w, null, clock_timestamp(), null, null, null, null, null, null, null, null) INTO STRICT cd_procedimento_w, ie_origem_proced_w;
 
select	coalesce(max(cd_area_procedimento),0), 
	coalesce(max(cd_especialidade),0), 
	coalesce(max(cd_grupo_proc),0) 
into STRICT	cd_area_proced_w, 
	cd_espec_proced_w, 
	cd_grupo_proced_w 
from	estrutura_procedimento_v 
where	cd_procedimento = cd_procedimento_w 
and	ie_origem_proced = ie_origem_proced_w;
 
select	count(*) 
into STRICT	qt_exclusivo_w 
from	agenda_regra 
where	coalesce(cd_estabelecimento, cd_Estabelecimento_p) = cd_estabelecimento_p 
and	cd_agenda 		= cd_agenda_p 
and	((cd_convenio = cd_convenio_p) or (coalesce(cd_convenio::text, '') = '')) 
and	((cd_medico = cd_profissional_p) or (coalesce(cd_medico::text, '') = '')) 
and	ie_permite = 'E';
	 
if (qt_exclusivo_w > 0) then 
	select	coalesce(max(nr_sequencia),0) 
	into STRICT	nr_seq_regra_w 
	from	agenda_regra 
	where	coalesce(cd_estabelecimento, cd_Estabelecimento_p) = cd_estabelecimento_p 
	and	cd_agenda 		= cd_agenda_p 
	and	((cd_convenio 		= cd_convenio_p) or (coalesce(cd_convenio::text, '') = '')) 
	and	((cd_categoria = cd_categoria_p) or (coalesce(cd_categoria::text, '') = '')) 
	and	((cd_plano_convenio = cd_plano_p) or (coalesce(cd_plano_convenio::text, '') = '')) 
	and	((cd_area_proc = cd_area_proced_w) or (coalesce(cd_area_proc::text, '') = '')) 
	and	((cd_especialidade = cd_espec_proced_w) or (coalesce(cd_especialidade::text, '') = '')) 
	and	((cd_grupo_proc = cd_grupo_proced_w) or (coalesce(cd_grupo_proc::text, '') = '')) 
	and	((cd_procedimento = cd_procedimento_w) or (coalesce(cd_procedimento::text, '') = '')) 
	and	((coalesce(cd_procedimento::text, '') = '') or ((ie_origem_proced = ie_origem_proced_w) or (coalesce(ie_origem_proced::text, '') = ''))) 
	and	((nr_seq_proc_interno = nr_seq_proc_interno_p) or (coalesce(nr_seq_proc_interno::text, '') = '')) 
	and	((cd_medico 		= cd_profissional_p) or (coalesce(cd_medico::text, '') = '')) 
	and	ie_permite = 'E';
 
	if (qt_regra_w	= 0) then 
		select	substr(ds_proc_exame,1,100) 
		into STRICT	ds_exame_w 
		from	proc_interno 
		where	nr_sequencia	= nr_seq_proc_interno_p;
 
		ds_exames_p	:= ds_exame_w;
	end if;
else			 
	open C02;
	loop 
	fetch C02 into	 
		nr_seq_regra_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin 
		nr_seq_regra_final_w	:= nr_seq_regra_w;
		end;
	end loop;
	close C02;
 
	select	coalesce(max(ie_permite),'N')	 
	into STRICT	ie_permite_w 
	from	agenda_regra 
	where	nr_sequencia	= nr_seq_regra_final_w;
 
	if (ie_permite_w	= 'N') then 
		select	substr(ds_proc_exame,1,100) 
		into STRICT	ds_exame_w 
		from	proc_interno 
		where	nr_sequencia	= nr_seq_proc_interno_p;
 
		ds_exame_ww	:= ds_exame_w;
	end if;
 
	if (ie_permite_w	= 'S') then 
		ds_exame_ww	:= '';
	end if;
	if (ds_exame_ww IS NOT NULL AND ds_exame_ww::text <> '') then 
		ds_exames_p	:= ds_exame_ww;
	end if;
end if;	
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_consist_ex_adic_mmed ( cd_agenda_p bigint, nr_seq_item_p bigint, ie_tipo_agendamento_p text, cd_convenio_p bigint, cd_categoria_p text, cd_estabelecimento_p bigint, cd_plano_p text, cd_profissional_p text, nr_seq_proc_interno_p bigint, ds_exames_p INOUT text) FROM PUBLIC;

