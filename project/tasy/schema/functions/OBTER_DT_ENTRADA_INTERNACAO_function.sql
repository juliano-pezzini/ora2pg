-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dt_entrada_internacao (nr_atendimento_p bigint) RETURNS timestamp AS $body$
DECLARE


ie_considera_todas_classif_w	varchar(1);
dt_entrada_unidade_w		timestamp;


BEGIN

ie_considera_todas_classif_w := coalesce(Obter_Valor_Param_Usuario(916, 781, Obter_perfil_Ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento),'N');

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
	SELECT 	dt_entrada_unidade
	into STRICT	dt_entrada_unidade_w
	FROM 	atend_paciente_unidade
	WHERE 	nr_seq_interno = (SELECT	coalesce(MIN(f.nr_seq_interno),0)
				 FROM 		atend_paciente_unidade f,
						unidade_atendimento d,
						tipo_acomodacao e
				WHERE	f.nr_atendimento 	= nr_atendimento_p
				  AND	f.CD_SETOR_ATENDIMENTO  = d.CD_SETOR_ATENDIMENTO
				  AND	f.CD_UNIDADE_BASICA	= d.CD_UNIDADE_BASICA
				  AND	f.CD_UNIDADE_COMPL	= d.CD_UNIDADE_COMPL
				  AND	e.CD_TIPO_ACOMODACAO	= d.CD_TIPO_ACOMODACAO
				  AND	((coalesce(IE_SEM_ACOMODACAO,'N') = 'N') or (ie_considera_todas_classif_w = 'C'))
				  AND 	f.dt_entrada_unidade	=
					(SELECT MIN(b.dt_entrada_unidade)
					FROM 	Setor_Atendimento y,
						atend_paciente_unidade b,
						unidade_atendimento x,
						tipo_acomodacao z
					WHERE 	b.nr_atendimento 		= nr_atendimento_p
					  AND 	b.cd_setor_atendimento		= y.cd_setor_atendimento
					  AND	b.CD_SETOR_ATENDIMENTO  	= x.CD_SETOR_ATENDIMENTO
					  AND	b.CD_UNIDADE_BASICA		= x.CD_UNIDADE_BASICA
					  AND	b.CD_UNIDADE_COMPL		= x.CD_UNIDADE_COMPL
					  AND	z.CD_TIPO_ACOMODACAO		= x.CD_TIPO_ACOMODACAO
					  AND	coalesce(z.IE_SEM_ACOMODACAO,'N') 	= 'N'
					  AND 	((y.cd_classif_setor IN (3,4,8)) or (ie_considera_todas_classif_w in ('S','C'))) ));
end if;

return	dt_entrada_unidade_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dt_entrada_internacao (nr_atendimento_p bigint) FROM PUBLIC;
