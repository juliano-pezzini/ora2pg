-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION existe_motivo_adm_adep ( cd_perfil_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ie_opcao_p text, nr_seq_regra_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	char(1);
								

BEGIN

select	coalesce(max('S'), 'N')
into STRICT	ds_retorno_w
from	regra_adep_motivo_adm a,
		adep_motivo_admnistracao b
where	b.nr_sequencia = a.nr_seq_regra
and		coalesce(a.cd_perfil,cd_perfil_p)	= cd_perfil_p
and		coalesce(a.cd_estabelecimento,cd_estabelecimento_p)	= cd_estabelecimento_p
and		coalesce(a.nm_usuario_regra,nm_usuario_p) = nm_usuario_p
and     ((ie_opcao_p = 'SOL' and b.ie_solucao = 'S') or (ie_opcao_p = 'MED' and b.ie_medicamento = 'S'));

if (ie_opcao_p = 'SOL') then

     if (ds_retorno_w = 'N') then
	
	    select	coalesce(max('S'), 'N')
		into STRICT	ds_retorno_w
		from	adep_motivo_admnistracao
		where	nr_sequencia not in (	SELECT	b.nr_seq_regra
										from	regra_adep_motivo_adm b)
		and		ie_solucao = 'S';
	
	end if;

	return	ds_retorno_w;
	
elsif (ie_opcao_p = 'MED') then

    if (ds_retorno_w = 'N') then
	
	    select	coalesce(max('S'), 'N')
		into STRICT	ds_retorno_w
		from	adep_motivo_admnistracao
		where	nr_sequencia not in (	SELECT	b.nr_seq_regra
										from	regra_adep_motivo_adm b)
		and		ie_medicamento = 'S';
	
	end if;

	return	ds_retorno_w;	
	
else

	select	coalesce(max('S'), 'N')
	into STRICT	ds_retorno_w
	from	regra_adep_motivo_adm a		
	where	coalesce(a.cd_perfil,cd_perfil_p)	= cd_perfil_p
	and		coalesce(a.cd_estabelecimento,cd_estabelecimento_p)	= cd_estabelecimento_p
	and		coalesce(a.nm_usuario_regra,nm_usuario_p) = nm_usuario_p
	and		a.nr_seq_regra = nr_seq_regra_p;
	
	if (ds_retorno_w = 'N') then
	
	    select	coalesce(max('N'), 'S')
		into STRICT	ds_retorno_w
		from	regra_adep_motivo_adm
		where	nr_seq_regra = nr_seq_regra_p;
	
	end if;

	return	ds_retorno_w;
	
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION existe_motivo_adm_adep ( cd_perfil_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ie_opcao_p text, nr_seq_regra_p bigint) FROM PUBLIC;
