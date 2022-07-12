-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_proximo_leito_desejado ( nr_atendimento_p bigint, nr_seq_interno_p bigint default null) RETURNS varchar AS $body$
DECLARE

ds_retorno_w		varchar(255);
vl_param_w		varchar(255);
nr_sequencia_w		gestao_vaga.nr_sequencia%type;
cd_setor_desejado_w	gestao_vaga.cd_setor_desejado%type;
cd_unidade_basica_w	gestao_vaga.cd_unidade_basica%type;
cd_unidade_compl_w	gestao_vaga.cd_unidade_compl%type;
cd_setor_atendimento_ww	unidade_atendimento.cd_setor_atendimento%type;
cd_unidade_basica_ww	unidade_atendimento.cd_unidade_basica%type;
cd_unidade_compl_ww	unidade_atendimento.cd_unidade_compl%type;

BEGIN

if (coalesce(nr_atendimento_p,0) > 0) then
	vl_param_w := Obter_param_Usuario(44, 315, obter_perfil_ativo, obter_usuario_ativo, obter_estabelecimento_ativo, vl_param_w);
	begin
		if (vl_param_w IS NOT NULL AND vl_param_w::text <> '') then
			select	max(nr_sequencia)
			into STRICT	nr_sequencia_w
			from 	gestao_vaga
			where	nr_atendimento = nr_atendimento_p
			and 	obter_se_contido_char(ie_status, vl_param_w) = 'N'
			and		(cd_setor_desejado IS NOT NULL AND cd_setor_desejado::text <> '')
			and		(cd_unidade_basica IS NOT NULL AND cd_unidade_basica::text <> '');
		else
			select	max(nr_sequencia)
			into STRICT	nr_sequencia_w
			from 	gestao_vaga
			where	nr_atendimento = nr_atendimento_p
			and		(cd_setor_desejado IS NOT NULL AND cd_setor_desejado::text <> '')
			and		(cd_unidade_basica IS NOT NULL AND cd_unidade_basica::text <> ''); 					
		end if;	
		if (coalesce(nr_sequencia_w,0) > 0) then
			select	max(obter_nome_setor(cd_setor_desejado) || ' - '||cd_unidade_basica||cd_unidade_compl),
				max(cd_setor_desejado),
				max(cd_unidade_basica),
				max(cd_unidade_compl)
			into STRICT	ds_retorno_w,
				cd_setor_desejado_w,
				cd_unidade_basica_w,
				cd_unidade_compl_w
			from 	gestao_vaga
			where	nr_sequencia = nr_sequencia_w;
			
			if (coalesce(nr_seq_interno_p,0) > 0) then
				select 	max(cd_setor_atendimento),
					max(cd_unidade_basica),
					max(cd_unidade_compl)
				into STRICT	cd_setor_atendimento_ww,
					cd_unidade_basica_ww,
					cd_unidade_compl_ww
				from 	unidade_atendimento
				where	nr_seq_interno = nr_seq_interno_p;
			
				if (cd_setor_desejado_w = cd_setor_atendimento_ww) and (cd_unidade_basica_w = cd_unidade_basica_ww) and (cd_unidade_compl_w = cd_unidade_compl_ww) then					
					ds_retorno_w := null;
				end if;
			end if;
		end if;
	exception
	when others then
		ds_retorno_w := null;
	end;
end if;
return	ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_proximo_leito_desejado ( nr_atendimento_p bigint, nr_seq_interno_p bigint default null) FROM PUBLIC;
