-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE verifica_se_obriga_cid ( nr_atendimento_p bigint, cd_motivo_alta_p bigint, ds_retorno_p INOUT text) AS $body$
DECLARE


ie_tipo_atendimento_w	smallint;
ie_exige_cid_w		varchar(1) := 'N';
cd_setor_atendimento_w	bigint;
cd_convenio_w		integer;
nr_sequencia_w		bigint;
ie_tipo_diag_regra_w	bigint;
ie_permite_w		varchar(1);
ds_retorno_w		varchar(255);
c01 CURSOR FOR
	SELECT	nr_sequencia,
		coalesce(ie_obriga,'S')
	from	regra_obriga_cid
	where	coalesce(ie_tipo_atendimento,ie_tipo_atendimento_w)		= ie_tipo_atendimento_w
	and	coalesce(cd_setor_atendimento,cd_setor_atendimento_w) 	= cd_setor_atendimento_w
	and	coalesce(Cd_motivo_alta,coalesce(cd_motivo_alta_p,0))	 	= coalesce(cd_motivo_alta_p,0)
	and     coalesce(cd_convenio,cd_convenio_w)				= cd_convenio_w
	order by  cd_motivo_alta desc;

BEGIN

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then

	select	coalesce(max(ie_tipo_atendimento),0),
		coalesce(max(cd_setor_atendimento),0),
		coalesce(max(cd_convenio),0)
	into STRICT	ie_tipo_atendimento_w,
		cd_setor_atendimento_w,
		cd_convenio_w
	from	resumo_atendimento_paciente_v
	where	nr_atendimento		=	nr_atendimento_p;

open C01;
loop
fetch C01 into	
	nr_sequencia_w,
	ie_exige_cid_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	nr_sequencia_w  :=	nr_sequencia_w;
	ie_exige_cid_w	:=	ie_exige_cid_w;
	end;
end loop;
close C01;

end if;

if (coalesce(nr_sequencia_w,0) > 0) then
	select	coalesce(max(ie_tipo_diag_regra),0)
	into STRICT	ie_tipo_diag_regra_w
	from	regra_obriga_cid
	where	nr_sequencia = nr_sequencia_w;
	
	if (coalesce(ie_tipo_diag_regra_w, 0) in (1, 2, 3)) then
		select	CASE WHEN count(1)=0 THEN  'N'  ELSE 'S' END
		into STRICT	ie_permite_w
		from	diagnostico_medico
		where	nr_atendimento = nr_atendimento_p
		and	ie_tipo_diagnostico = ie_tipo_diag_regra_w;
		
		if (ie_permite_w = 'N') then
			ds_retorno_w 	:= obter_desc_expressao(729723)|| nr_sequencia_w || chr(13) || chr(10);
		end if;
	elsif (coalesce(ie_tipo_diag_regra_w,0) = 999) then
		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ie_permite_w
		from	diagnostico_medico
		where	nr_atendimento = nr_atendimento_p;

		if (ie_permite_w = 'N') then
			ds_retorno_w 	:= obter_desc_expressao(729723)|| nr_sequencia_w || chr(13) || chr(10);
		end if;	
		
	end if;
end if;
if (ie_exige_cid_w = 'S') and (coalesce(ie_tipo_diag_regra_w,0) <> 999) and (coalesce(ds_retorno_w::text, '') = '') then
	ds_retorno_w :=  obter_desc_expressao(510483);
end if;
ds_retorno_p := ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE verifica_se_obriga_cid ( nr_atendimento_p bigint, cd_motivo_alta_p bigint, ds_retorno_p INOUT text) FROM PUBLIC;

