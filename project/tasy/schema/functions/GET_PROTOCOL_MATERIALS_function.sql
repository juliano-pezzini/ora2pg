-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_protocol_materials (cd_protocolo_p bigint, nr_sequencia_p bigint, nr_seq_pac_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE

					
cd_estabelecimento_w			bigint;
cd_pessoa_fisica_w				bigint;
cd_convenio_w					bigint;
Var_gerar_material_dia_apli_w   varchar(2);
ds_retorno_w					varchar(250) := '';

c01 CURSOR FOR
	SELECT  DISTINCT a.CD_PROTOCOLO, a.CD_MATERIAL
	FROM
		protocolo_medic_material b,
		protocolo_medic_material a,
		material c
	WHERE  
		a.cd_protocolo = cd_protocolo_p
		AND a.nr_sequencia = nr_sequencia_p
		AND (
			(
				a.cd_material = b.cd_material
				AND coalesce(a.nr_seq_diluicao::text, '') = ''
				AND coalesce(a.nr_seq_solucao::text, '') = ''
				AND coalesce(a.nr_seq_medic_material::text, '') = ''
				AND a.ie_agrupador = 1
				AND c.ie_situacao = 'A'
				AND 'S' = obter_permicao_conv_medic(cd_convenio_w, b.nr_sequencia, b.cd_protocolo, b.nr_seq_material)
			) 
			OR (
				a.cd_protocolo = b.cd_protocolo
				AND a.cd_material = c.cd_material
				AND a.nr_sequencia = b.nr_sequencia
				AND b.nr_seq_medic_material = a.nr_seq_material
				AND b.ie_agrupador = 2
				AND c.ie_situacao = 'A'
				AND 'S' = obter_permicao_conv_medic(cd_convenio_w, b.nr_sequencia, b.cd_protocolo, b.nr_seq_material)
				AND EXISTS (SELECT 1
							FROM paciente_protocolo_medic x
							WHERE x.nr_seq_paciente = nr_seq_pac_p
							AND x.nr_seq_material = b.nr_seq_medic_material)
			 )
			 OR (
				a.cd_material = b.cd_material
				AND coalesce(a.nr_seq_diluicao::text, '') = ''
				AND coalesce(a.nr_seq_solucao::text, '') = ''
				AND coalesce(a.nr_seq_medic_material::text, '') = ''
				AND a.ie_agrupador = 2
				AND c.ie_situacao = 'A'
				AND 'S' = obter_permicao_conv_medic(cd_convenio_w, b.nr_sequencia, b.cd_protocolo, b.nr_seq_material)
				AND coalesce(a.nr_seq_medic_material::text, '') = ''
				AND (a.ds_dias_aplicacao IS NOT NULL AND a.ds_dias_aplicacao::text <> '')
				AND Var_gerar_material_dia_apli_w = 'S'
			 )
			 OR (
				a.cd_material = c.cd_material
				AND a.cd_protocolo = b.cd_protocolo
				AND a.nr_sequencia = b.nr_sequencia
				AND b.nr_seq_diluicao = a.nr_seq_material
				AND b.ie_agrupador in (3,7,9)
				AND c.ie_situacao = 'A'
				AND 'S' = obter_permicao_conv_medic(cd_convenio_w, b.nr_sequencia, b.cd_protocolo, b.nr_seq_material)
				AND EXISTS (SELECT 1
							FROM paciente_protocolo_medic x
							WHERE x.nr_seq_paciente = nr_seq_pac_p
							AND x.nr_seq_material = b.nr_seq_diluicao)
			)
			 OR (
				coalesce(a.nr_seq_diluicao::text, '') = '' 
				AND a.ie_agrupador = 5
				AND a.nr_seq_proc in (SELECT nr_seq_proc
									FROM protocolo_medic_proc
									WHERE cd_protocolo = cd_protocolo_p
									AND nr_sequencia = nr_sequencia_p
									AND (ds_dias_aplicacao IS NOT NULL AND ds_dias_aplicacao::text <> ''))
			)
			 OR (
				a.cd_protocolo = b.cd_protocolo
				AND a.nr_sequencia = b.nr_sequencia
				AND b.nr_seq_solucao = a.nr_seq_solucao
				AND (a.ds_dias_aplicacao IS NOT NULL AND a.ds_dias_aplicacao::text <> '') 
				AND b.nr_seq_solucao in (SELECT nr_seq_solucao
										FROM protocolo_medic_solucao
										WHERE cd_protocolo = cd_protocolo_p
										AND nr_sequencia = nr_sequencia_p
										AND (ds_dias_aplicacao IS NOT NULL AND ds_dias_aplicacao::text <> ''))                                    
				AND b.ie_agrupador = 4
				AND 'S' = obter_permicao_conv_medic(cd_convenio_w, b.nr_sequencia, b.cd_protocolo, b.nr_seq_material)
			)
		);
c01_w c01%rowtype;


BEGIN

select coalesce(max(cd_estabelecimento),0),
		max(cd_pessoa_fisica)
into STRICT cd_estabelecimento_w,
		cd_pessoa_fisica_w
from paciente_setor
where nr_seq_paciente = nr_seq_pac_p;

if (cd_estabelecimento_w > 0) then
	Var_gerar_material_dia_apli_w := obter_param_usuario(281, 1322, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, Var_gerar_material_dia_apli_w);
end if;

select 	max(a.cd_convenio)
into STRICT	cd_convenio_w
from	paciente_setor_convenio a,
		paciente_setor b
where 	b.cd_protocolo		= cd_protocolo_p
and   	b.cd_pessoa_fisica  = cd_pessoa_fisica_w
and   	a.nr_seq_paciente 	= b.nr_seq_paciente
and		a.nr_seq_paciente	= nr_seq_pac_p;

if (coalesce(cd_convenio_w::text, '') = '') then
	select 	max(a.cd_convenio)
	into STRICT	cd_convenio_w
	from	paciente_setor_convenio a,
			paciente_setor b
	where 	b.cd_protocolo		= cd_protocolo_p
	and   	b.cd_pessoa_fisica  = cd_pessoa_fisica_w
	and   	a.nr_seq_paciente 	= b.nr_seq_paciente;
end if;

open C01;
loop
fetch C01 into
	c01_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
		if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
			ds_retorno_w := ds_retorno_w || ';';
		end if;
		
		ds_retorno_w := ds_retorno_w || c01_w.cd_material;
	end;
end loop;
close C01;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_protocol_materials (cd_protocolo_p bigint, nr_sequencia_p bigint, nr_seq_pac_p bigint, nm_usuario_p text) FROM PUBLIC;

