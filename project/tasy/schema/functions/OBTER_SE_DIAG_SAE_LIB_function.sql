-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_diag_sae_lib ( nr_seq_sae_p bigint, nr_seq_diagnostico_p bigint) RETURNS varchar AS $body$
DECLARE

ds_retorno_w		varchar(10)	:= 'S';
qt_reg_w		bigint;
cd_setor_Atendimento_w	bigint;
qt_idade_w		bigint;
ie_sexo_w		varchar(10);
cd_estabelecimento_w	bigint;

BEGIN

select	count(*)
into STRICT	qt_reg_w
from	PE_DIAGNOSTICO_REGRA
where	nr_seq_diagnostico	= nr_seq_diagnostico_p;

if (qt_reg_w	> 0) then

	select	coalesce(cd_setor_atendimento,0),
		coalesce(obter_idade(dt_nascimento,clock_timestamp(),'A'),0),
		coalesce(ie_sexo,'I')
	into STRICT	cd_setor_Atendimento_w,
		qt_idade_w,
		ie_sexo_w
	from	pe_prescricao a,
		pessoa_fisica b
	where	a.cd_pessoa_fisica	= b.cd_pessoa_fisica
	and	a.nr_sequencia		= nr_seq_sae_p;

	cd_estabelecimento_w := wheb_usuario_pck.get_cd_estabelecimento;

	select	count(*)
	into STRICT	qt_reg_w
	from	PE_DIAGNOSTICO_REGRA
	where	nr_seq_diagnostico	= nr_seq_diagnostico_p
	and	qt_idade_w between coalesce(qt_idade_min,0) and coalesce(qt_idade_max,999)
	and	coalesce(ie_sexo,ie_sexo_w)				= ie_sexo_w
	and	coalesce(cd_setor_atendimento,cd_setor_Atendimento_w) = cd_setor_Atendimento_w
	and	coalesce(cd_estabelecimento,cd_Estabelecimento_w) = cd_estabelecimento_w;

	if (qt_reg_w	= 0) then
		ds_retorno_w	:= 'N';
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_diag_sae_lib ( nr_seq_sae_p bigint, nr_seq_diagnostico_p bigint) FROM PUBLIC;
