-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_exige_guia_senha (cd_convenio_p bigint, ie_tipo_atendimento_p bigint, ie_funcao_p bigint, ie_guia_senha_p text, cd_estabelecimento_p bigint, cd_carater_internacao_p text, ie_clinica_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_classificacao_p bigint, nr_seq_proc_interno_p bigint, cd_categoria_P text, cd_plano_p text, cd_procedencia_p bigint) RETURNS varchar AS $body$
DECLARE


/*

ie_funcao_p
1 - Atendimento Paciente
2 - Conta Paciente

ie_guia_senha_p
S - Senha
G - Guia

*/
ie_exige_w			varchar(3);
IE_EXIGE_SENHA_ATEND_w	varchar(3);
IE_EXIGE_GUIA_w			varchar(3);
IE_EXIGE_SENHA_w		varchar(3);
IE_EXIGE_PLANO_W		varchar(1);
IE_EXIGE_CARTEIRA_W		varchar(1);
IE_EXIGE_VALIDADE_W		varchar(1);
IE_EXIGE_COMPL_USUARIO_W	varchar(1);

ie_exige_plano_atend_w		varchar(1);
ie_exige_carteira_atend_w		varchar(1);
ie_exige_validade_atend_w		varchar(1);
ie_exige_compl_usuario_atend_w	varchar(1);


cd_grupo_proc_w			bigint;
cd_especialidade_w		bigint;
cd_area_procedimento_w		bigint;
cd_perfil_w			integer;

nr_seq_regra_perfil_w		bigint;
nr_seq_regra_w			bigint;

ie_achou_w			varchar(1)	:=	'N';


c01 CURSOR FOR
SELECT	nr_sequencia
from 	regra_senha_convenio
where	cd_convenio			= cd_convenio_p
and (coalesce(ie_tipo_atendimento, ie_tipo_atendimento_p) = ie_tipo_atendimento_p)
and (coalesce(cd_carater_internacao, coalesce(cd_carater_internacao_p,0)) = coalesce(cd_carater_internacao_p,0))
and (coalesce(ie_clinica, coalesce(ie_clinica_p,0)) = coalesce(ie_clinica_p,0))
and (coalesce(cd_procedimento,coalesce(cd_procedimento_p,0)) = coalesce(cd_procedimento_p,0))
and (coalesce(ie_origem_proced,coalesce(ie_origem_proced_p,0)) = coalesce(ie_origem_proced_p,0))
and (coalesce(nr_seq_classificacao,coalesce(nr_seq_classificacao_p,0)) = coalesce(nr_seq_classificacao_p,0))
and (coalesce(cd_procedencia,coalesce(cd_procedencia_p,0)) = coalesce(cd_procedencia_p,0))
and (coalesce(nr_seq_proc_interno,coalesce(nr_seq_proc_interno_p,0)) = coalesce(nr_seq_proc_interno_p,0))
and (coalesce(cd_grupo_proc,coalesce(cd_grupo_proc_w,0)) = coalesce(cd_grupo_proc_w,0))
and (coalesce(cd_especialidade,coalesce(cd_especialidade_w,0)) = coalesce(cd_especialidade_w,0))
and (coalesce(cd_area_procedimento,coalesce(cd_area_procedimento_w,0)) = coalesce(cd_area_procedimento_w,0))
and (coalesce(cd_categoria,coalesce(cd_categoria_p,'0')) = coalesce(cd_categoria_p,'0'))
and (coalesce(cd_plano,coalesce(cd_plano_p,'0')) = coalesce(cd_plano_p,'0'))
and (coalesce(cd_estabelecimento, coalesce(cd_estabelecimento_p,0)) = coalesce(cd_estabelecimento_p,0))
and (cd_perfil = cd_perfil_w)
order by coalesce(nr_seq_classificacao,0) , coalesce(ie_clinica,0), coalesce(ie_tipo_atendimento,0), coalesce(cd_plano,0),
	coalesce(cd_categoria,0),
	coalesce(cd_carater_internacao,0),
	coalesce(cd_estabelecimento,0),
	coalesce(cd_procedencia,0);

c02 CURSOR FOR
SELECT	nr_sequencia
from 	regra_senha_convenio
where	cd_convenio			= cd_convenio_p
and (coalesce(ie_tipo_atendimento, ie_tipo_atendimento_p) = ie_tipo_atendimento_p)
and (coalesce(cd_carater_internacao, coalesce(cd_carater_internacao_p,0)) = coalesce(cd_carater_internacao_p,0))
and (coalesce(ie_clinica, coalesce(ie_clinica_p,0)) = coalesce(ie_clinica_p,0))
and (coalesce(cd_procedimento,coalesce(cd_procedimento_p,0)) = coalesce(cd_procedimento_p,0))
and (coalesce(ie_origem_proced,coalesce(ie_origem_proced_p,0)) = coalesce(ie_origem_proced_p,0))
and (coalesce(nr_seq_classificacao,coalesce(nr_seq_classificacao_p,0)) = coalesce(nr_seq_classificacao_p,0))
and (coalesce(cd_procedencia,coalesce(cd_procedencia_p,0)) = coalesce(cd_procedencia_p,0))
and (coalesce(nr_seq_proc_interno,coalesce(nr_seq_proc_interno_p,0)) = coalesce(nr_seq_proc_interno_p,0))
and (coalesce(cd_grupo_proc,coalesce(cd_grupo_proc_w,0)) = coalesce(cd_grupo_proc_w,0))
and (coalesce(cd_especialidade,coalesce(cd_especialidade_w,0)) = coalesce(cd_especialidade_w,0))
and (coalesce(cd_area_procedimento,coalesce(cd_area_procedimento_w,0)) = coalesce(cd_area_procedimento_w,0))
and (coalesce(cd_categoria,coalesce(cd_categoria_p,'0')) = coalesce(cd_categoria_p,'0'))
and (coalesce(cd_plano,coalesce(cd_plano_p,'0')) = coalesce(cd_plano_p,'0'))
and (coalesce(cd_estabelecimento, coalesce(cd_estabelecimento_p,0)) = coalesce(cd_estabelecimento_p,0))
and	coalesce(cd_perfil::text, '') = ''
order by coalesce(nr_seq_classificacao,0),
	coalesce(ie_clinica,0),
	coalesce(ie_tipo_atendimento,0),
	coalesce(cd_plano,0),
	coalesce(cd_categoria,0),
	coalesce(cd_carater_internacao,0),
	coalesce(cd_estabelecimento,0),
	coalesce(cd_procedencia,0);


BEGIN

select	max(cd_grupo_proc),
	max(cd_especialidade),
	max(cd_area_procedimento)
into STRICT	cd_grupo_proc_w,
	cd_especialidade_w,
	cd_area_procedimento_w
from	estrutura_procedimento_v
where	cd_procedimento 	= cd_procedimento_p
and	ie_origem_proced 	= ie_origem_proced_p;

cd_perfil_w	:= Obter_perfil_Ativo;

begin
select	coalesce(Obter_Valor_Conv_Estab(cd_convenio, cd_estabelecimento_p, 'IE_EXIGE_PLANO'),'N') ie_exige_plano,
	coalesce(Obter_Valor_Conv_Estab(cd_convenio, cd_estabelecimento_p, 'IE_EXIGE_CARTEIRA_ATEND'),'N') ie_exige_carteira_atend,
	coalesce(Obter_Valor_Conv_Estab(cd_convenio, cd_estabelecimento_p, 'IE_EXIGE_VALIDADE_ATEND'),'N') ie_exige_validade_atend,
	coalesce(Obter_Valor_Conv_Estab(cd_convenio, cd_estabelecimento_p, 'IE_EXIGE_COMPL_USUARIO'),'N'),
	coalesce(Obter_Valor_Conv_Estab(cd_convenio, cd_estabelecimento_p, 'IE_EXIGE_SENHA_ATEND'),'N')
into STRICT	ie_exige_plano_atend_w,
	ie_exige_carteira_atend_w,
	ie_exige_validade_atend_w,
	ie_exige_compl_usuario_atend_w,
	ie_exige_senha_atend_w
from	convenio
where	cd_convenio	= cd_convenio_p;

exception
when others then
	ie_exige_plano_atend_w		:= 'N';
	ie_exige_carteira_atend_w	:= 'N';
	ie_exige_validade_atend_w	:= 'N';
	ie_exige_compl_usuario_atend_w 	:= 'N';
	ie_exige_senha_atend_w		:= 'N';
end;

ie_exige_w		:= 'N';

if (IE_EXIGE_SENHA_ATEND_w = 'A') then

	ie_exige_w		:= 'S';

elsif (IE_EXIGE_SENHA_ATEND_w = 'E') then

	open C01;
	loop
	fetch C01 into
		nr_seq_regra_perfil_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		nr_seq_regra_perfil_w	:=	nr_seq_regra_perfil_w;
		ie_achou_w		:=	'S';
		end;
	end loop;
	close C01;

	if (nr_seq_regra_perfil_w > 0) then

		select	coalesce(max(IE_EXIGE_GUIA),'X'),
			coalesce(max(IE_EXIGE_SENHA),'X'),
			coalesce(max(IE_EXIGE_PLANO),ie_exige_plano_atend_w),
			coalesce(max(IE_EXIGE_COD_USUARIO),ie_exige_carteira_atend_w),
			coalesce(max(IE_EXIGE_VAL_CART),ie_exige_validade_atend_w),
			coalesce(max(IE_EXIGE_COMPLEMENTO),ie_exige_compl_usuario_atend_w)
		into STRICT	IE_EXIGE_GUIA_w,
			IE_EXIGE_SENHA_w,
			IE_EXIGE_PLANO_W,
			IE_EXIGE_CARTEIRA_W,
			IE_EXIGE_VALIDADE_W,
			IE_EXIGE_COMPL_USUARIO_W
		from	regra_senha_convenio
		where	nr_sequencia			= nr_seq_regra_perfil_w;

	else

		open C02;
		loop
		fetch C02 into
			nr_seq_regra_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			nr_seq_regra_w 		:= 	nr_seq_regra_w;
			ie_achou_w		:=	'S';
			end;
		end loop;
		close C02;

		if (nr_seq_regra_w > 0) then

		select	coalesce(max(IE_EXIGE_GUIA),'X'),
			coalesce(max(IE_EXIGE_SENHA),'X'),
			coalesce(max(IE_EXIGE_PLANO),ie_exige_plano_atend_w),
			coalesce(max(IE_EXIGE_COD_USUARIO),ie_exige_carteira_atend_w),
			coalesce(max(IE_EXIGE_VAL_CART),ie_exige_validade_atend_w),
			coalesce(max(IE_EXIGE_COMPLEMENTO),ie_exige_compl_usuario_atend_w)
		into STRICT	IE_EXIGE_GUIA_w,
			IE_EXIGE_SENHA_w,
			IE_EXIGE_PLANO_W,
			IE_EXIGE_CARTEIRA_W,
			IE_EXIGE_VALIDADE_W,
			IE_EXIGE_COMPL_USUARIO_W
		from	regra_senha_convenio
		where	nr_sequencia = nr_seq_regra_w;

		end if;

	end if;

	if (ie_achou_w = 'N') then	-- Caso não encontrar regra nenhuma tem que deixar isso porque sempre foi assim
		begin
		select	coalesce(max(IE_EXIGE_GUIA),'X'),
			coalesce(max(IE_EXIGE_SENHA),'X'),
			coalesce(max(IE_EXIGE_PLANO),ie_exige_plano_atend_w),
			coalesce(max(IE_EXIGE_COD_USUARIO),ie_exige_carteira_atend_w),
			coalesce(max(IE_EXIGE_VAL_CART),ie_exige_validade_atend_w),
			coalesce(max(IE_EXIGE_COMPLEMENTO),ie_exige_compl_usuario_atend_w)
		into STRICT	IE_EXIGE_GUIA_w,
			IE_EXIGE_SENHA_w,
			IE_EXIGE_PLANO_W,
			IE_EXIGE_CARTEIRA_W,
			IE_EXIGE_VALIDADE_W,
			IE_EXIGE_COMPL_USUARIO_W
		from	regra_senha_convenio
		where	cd_convenio			= cd_convenio_p
		and (coalesce(ie_tipo_atendimento, ie_tipo_atendimento_p) = ie_tipo_atendimento_p)
		and (coalesce(cd_carater_internacao, coalesce(cd_carater_internacao_p,0)) = coalesce(cd_carater_internacao_p,0))
		and (coalesce(ie_clinica, coalesce(ie_clinica_p,0)) = coalesce(ie_clinica_p,0))
		and (coalesce(cd_procedimento,coalesce(cd_procedimento_p,0)) = coalesce(cd_procedimento_p,0))
		and (coalesce(ie_origem_proced,coalesce(ie_origem_proced_p,0)) = coalesce(ie_origem_proced_p,0))
		and (coalesce(nr_seq_classificacao,coalesce(nr_seq_classificacao_p,0)) = coalesce(nr_seq_classificacao_p,0))
		and (coalesce(cd_procedencia,coalesce(cd_procedencia_p,0)) = coalesce(cd_procedencia_p,0))
		and (coalesce(nr_seq_proc_interno,coalesce(nr_seq_proc_interno_p,0)) = coalesce(nr_seq_proc_interno_p,0))
		and (coalesce(cd_grupo_proc,coalesce(cd_grupo_proc_w,0)) = coalesce(cd_grupo_proc_w,0))
		and (coalesce(cd_especialidade,coalesce(cd_especialidade_w,0)) = coalesce(cd_especialidade_w,0))
		and (coalesce(cd_area_procedimento,coalesce(cd_area_procedimento_w,0)) = coalesce(cd_area_procedimento_w,0))
		and (coalesce(cd_categoria,coalesce(cd_categoria_p,'0')) = coalesce(cd_categoria_p,'0'))
		and (coalesce(cd_plano,coalesce(cd_plano_p,'0')) = coalesce(cd_plano_p,'0'))
		and (coalesce(cd_estabelecimento, coalesce(cd_estabelecimento_p,0)) = coalesce(cd_estabelecimento_p,0))
		and (coalesce(cd_perfil::text, '') = '');
		end;
	end if;


	if (ie_guia_senha_p = 'G') then
		ie_exige_w		:= IE_EXIGE_GUIA_w;
	elsif (ie_guia_senha_p = 'S') then
		ie_exige_w		:= IE_EXIGE_SENHA_w;
	elsif (ie_guia_senha_p = 'P') then
		ie_exige_w		:= IE_EXIGE_PLANO_W;
	elsif (ie_guia_senha_p = 'C') then
		ie_exige_w		:= IE_EXIGE_CARTEIRA_W;
	elsif (ie_guia_senha_p = 'V') then
		ie_exige_w		:= IE_EXIGE_VALIDADE_W;
	elsif (ie_guia_senha_p = 'U') then
		ie_exige_w		:= IE_EXIGE_COMPL_USUARIO_W;

	end if;
elsif (IE_EXIGE_SENHA_ATEND_w = 'N') then
	ie_exige_w			:= 'N';
elsif (IE_EXIGE_SENHA_ATEND_w = 'T') then
	if (coalesce(ie_funcao_p,1) = 1) then
		ie_exige_w		:= 'S';
	end if;
elsif (IE_EXIGE_SENHA_ATEND_w = 'S') then
	if (coalesce(ie_funcao_p,2) = 2) then
		ie_exige_w		:= 'S';
	end if;
end if;

return	ie_exige_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_exige_guia_senha (cd_convenio_p bigint, ie_tipo_atendimento_p bigint, ie_funcao_p bigint, ie_guia_senha_p text, cd_estabelecimento_p bigint, cd_carater_internacao_p text, ie_clinica_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_classificacao_p bigint, nr_seq_proc_interno_p bigint, cd_categoria_P text, cd_plano_p text, cd_procedencia_p bigint) FROM PUBLIC;

