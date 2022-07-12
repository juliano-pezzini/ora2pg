-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_suep_liberado_usuario ( nr_seq_suep_p bigint, cd_pessoa_usuario_p text, nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

				
ie_liberado_w		varchar(1) := 'N';			
cd_perfil_w			bigint;
cd_especialidade_w	bigint;


BEGIN

select	CASE WHEN count(*)=0 THEN 'S'  ELSE 'N' END
into STRICT	ie_liberado_w
from	regra_liberacao_suep
where	nr_seq_suep = nr_seq_suep_p;

if (ie_liberado_w = 'N') then

		select 	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ie_liberado_w
		from	regra_liberacao_suep
		where	((cd_perfil = wheb_usuario_pck.get_cd_perfil) or (coalesce(cd_perfil::text, '') = ''))
		and     ((cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento) or (coalesce(cd_estabelecimento::text, '') = ''))
		and (cd_setor_atendimento = obter_setor_atual_paciente(nr_atendimento_p) or (coalesce(cd_setor_atendimento::text, '') = ''))
		and	((obter_se_especialidade_medico(cd_pessoa_usuario_p, cd_especialidade) = 'S') or (coalesce(cd_especialidade::text, '') = ''))
		and	((obter_se_atend_cid(cd_doenca, nr_atendimento_p) = 'S') or (coalesce(cd_doenca::text, '') = ''))
		and regra_lib_suep_complementar(nr_atendimento_p, nr_seq_suep_p) = 'X'
		and	nr_seq_suep = nr_seq_suep_p;
		
end if;


return	ie_liberado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_suep_liberado_usuario ( nr_seq_suep_p bigint, cd_pessoa_usuario_p text, nr_atendimento_p bigint) FROM PUBLIC;

