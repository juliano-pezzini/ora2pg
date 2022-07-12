-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_paciente_alerta ( cd_pessoa_fisica_p text, cd_pessoa_usuario_p text, cd_estabelecimento_p bigint, nr_atendimento_p bigint default null) RETURNS varchar AS $body$
DECLARE


ds_retorno_w 			varchar(1):= 'N';
ie_lib_historico_saude_w	varchar(1);
ie_exibir_nega_alergias_w	varchar(1);
nr_seq_nivel_w			varchar(1);
				

BEGIN

nr_seq_nivel_w := Obter_Param_Usuario(-970, 5, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, cd_estabelecimento_p, nr_seq_nivel_w);

select 	max(ie_liberar_hist_saude)
into STRICT	ie_lib_historico_saude_w
from 	parametro_medico 
where 	cd_estabelecimento = cd_estabelecimento_p;

select  coalesce(max(ie_exibir_nega_alergia),'S')
into STRICT	ie_exibir_nega_alergias_w	
from    parametro_medico
where	cd_estabelecimento = cd_estabelecimento_p;

if (ie_lib_historico_saude_w = 'N')  then

	select 	coalesce(max('S'),'N')
	into STRICT	ds_retorno_w
	from 	alerta_v a
	where 	a.cd_pessoa_alerta = cd_pessoa_fisica_p
	and 	 (( nr_seq_nivel_w = 'N') or ( nr_seq_nivel_w = 'S' and  (nr_seq_nivel IS NOT NULL AND nr_seq_nivel::text <> '')))
	and 	consiste_se_exibe_alerta(a.ie_tipo_alerta, cd_pessoa_usuario_p) = 'S'
	and     ((a.ie_tipo_alerta <> 'A')  or (( ie_exibir_nega_alergias_w = 'S') 
	and     ((ie_tipo_alerta <> 'I') or ((coalesce(a.nr_atendimento,0) = 0) or (coalesce(nr_atendimento_p,0) = 0) or (a.nr_atendimento = nr_atendimento_p)))
		or exists (	SELECT 	1 
				from 	paciente_alergia x 
				where 	x.nr_sequencia = a.nr_seq_alerta 
				and 	coalesce(x.ie_nega_alergias,'N') = 'N')));
else

	select 	coalesce(max('S'),'N')
	into STRICT	ds_retorno_w
	from 	alerta_v a 
	where 	a.cd_pessoa_alerta = cd_pessoa_fisica_p 
        and 	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') 
	and	(( nr_seq_nivel_w = 'N') or ( nr_seq_nivel_w = 'S' and  (nr_seq_nivel IS NOT NULL AND nr_seq_nivel::text <> '')))
        and 	consiste_se_exibe_alerta(a.ie_tipo_alerta,cd_pessoa_usuario_p) = 'S'
	and     ((ie_tipo_alerta <> 'I') or ((coalesce(a.nr_atendimento,0) = 0) or (coalesce(nr_atendimento_p,0) = 0) or (a.nr_atendimento = nr_atendimento_p)))
        and 	((a.ie_tipo_alerta <> 'A')  or (( ie_exibir_nega_alergias_w = 'S') or exists (SELECT 1 from paciente_alergia x where x.nr_sequencia = a.nr_seq_alerta and coalesce(x.ie_nega_alergias,'N') = 'N')));

end if;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_paciente_alerta ( cd_pessoa_fisica_p text, cd_pessoa_usuario_p text, cd_estabelecimento_p bigint, nr_atendimento_p bigint default null) FROM PUBLIC;
