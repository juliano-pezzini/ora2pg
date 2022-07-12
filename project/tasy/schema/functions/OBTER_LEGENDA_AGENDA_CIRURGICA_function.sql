-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_legenda_agenda_cirurgica (ie_status_agenda_p text, nr_seq_classif_agenda_p bigint, cd_pessoa_fisica_p text, ie_autorizacao_p text, nr_sequencia_p bigint, nr_atendimento_p bigint, dt_confirmacao_p timestamp) RETURNS bigint AS $body$
DECLARE

 
ie_legenda_custom_w 	varchar(1);

ie_param_176_w		varchar(1);
ie_param_135_w		varchar(1);
ie_param_186_w		varchar(1);
ie_param_501_w		varchar(1);
ie_param_463_w		varchar(1);

ie_internado_w		varchar(1) := 'N';
ie_autor_desdobrada_w	varchar(1);
ie_tipo_classif_w	varchar(200);
qt_internado_w		bigint;
nr_seq_legenda_w	bigint;


BEGIN 
 
select	count(*) ie_internado 
into STRICT	qt_internado_w 
from  setor_atendimento c, atendimento_paciente b, unidade_atendimento a 
where  a.nr_atendimento    = b.nr_atendimento 
and   a.cd_setor_atendimento = c.cd_setor_atendimento 
and   c.cd_classif_setor   in (3,4,8) 
and   b.cd_pessoa_fisica   = cd_pessoa_fisica_p;
 
	if (qt_internado_w > 0) then 
		ie_internado_w := 'S';
	end if;
 
ie_autor_desdobrada_w := substr(obter_se_autor_desdob_agenda(nr_sequencia_p),1,1);
 
ie_tipo_classif_w := substr(Obter_Tipo_Classif_Agenda(nr_seq_classif_agenda_p),1,200);
 
ie_legenda_custom_w := obter_valor_param_usuario(871, 514, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento);
 
ie_param_176_w := obter_valor_param_usuario(871, 176, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento);
ie_param_135_w := obter_valor_param_usuario(871, 135, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento);
ie_param_186_w := obter_valor_param_usuario(871, 186, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento);
ie_param_501_w := obter_valor_param_usuario(871, 501, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento);
ie_param_463_w := obter_valor_param_usuario(871, 463, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento);
 
	if (ie_legenda_custom_w <> 'S') then 
		begin 
			if (ie_status_agenda_p = 'L') then 
				nr_seq_legenda_w := 6941;
				 
			elsif (ie_status_agenda_p = 'IP') then 
				nr_seq_legenda_w := 6944;
				 
			elsif (ie_status_agenda_p = 'R' 
				and ((ie_param_176_w = 'S' 
				and ie_tipo_classif_w <> 'E') 
				or (ie_param_176_w <> 'S'))) then 
				nr_seq_legenda_w := 6937;
				 
			elsif (ie_param_135_w = 'S' 
				and ie_status_agenda_p <> 'E' 
				and ie_status_agenda_p <> 'C' 
				and ie_status_agenda_p <> 'B' 
				and (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') 
				and ie_internado_w = 'S') then 
				nr_seq_legenda_w := 6927;
			 
			elsif (ie_param_186_w = 'S' 
				and ie_tipo_classif_w = 'E' 
				and ie_status_agenda_p <> 'E' 
				and ie_status_agenda_p <> 'C') then 
				nr_seq_legenda_w := 6928;
			 
			elsif (ie_param_186_w = 'I' 
				and ie_tipo_classif_w = 'E' 
				and ie_status_agenda_p <> 'C') then 
				nr_seq_legenda_w := 6928;
			 
			elsif (ie_status_agenda_p = 'E') then 
				nr_seq_legenda_w := 6926;
			 
			elsif (ie_status_agenda_p = 'IT') then 
				nr_seq_legenda_w := 6946;
				 
			elsif (ie_status_agenda_p = 'C') then 
				nr_seq_legenda_w := 6925;
			 
			elsif (ie_status_agenda_p = 'PF') then 
				nr_seq_legenda_w := 6943;
			 
			elsif (ie_status_agenda_p = 'B') then 
				nr_seq_legenda_w := 6933;
			 
			elsif (ie_param_501_w = 'S' 
				and ie_status_agenda_p = 'PC') then 
				nr_seq_legenda_w := 6931;
			 
			elsif (ie_param_463_w <> 'S' 
				and ie_autorizacao_p = 'B' 
				and ie_autor_desdobrada_w = 'N') then 
				nr_seq_legenda_w := 6924;
			 
			elsif (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then 
				nr_seq_legenda_w := 6938;
 
			elsif (ie_param_463_w <> 'S' 
				and ie_autorizacao_p = 'AI' 
				and ie_autor_desdobrada_w = 'N') then 
				nr_seq_legenda_w := 6935;
 
			elsif (ie_param_463_w <> 'S' 
				and ie_autorizacao_p = 'A' 
				and ie_autor_desdobrada_w = 'N') then 
				nr_seq_legenda_w := 6929;
				 
			elsif (ie_param_463_w <> 'S' 
				and ie_autorizacao_p = 'A' 
				and ie_autor_desdobrada_w = 'S') then 
				nr_seq_legenda_w := 6940;
				 
			elsif (ie_param_463_w <> 'S' 
				and ie_autorizacao_p = 'PA' 
				and ie_autor_desdobrada_w = 'N') then 
				nr_seq_legenda_w := 6923;
			 
			elsif ((dt_confirmacao_p IS NOT NULL AND dt_confirmacao_p::text <> '') 
				and ie_status_agenda_p <> 'I') then 
				nr_seq_legenda_w := 6939;
			 
			elsif (ie_status_agenda_p = 'N') then 
				nr_seq_legenda_w := 6932;
				 
			elsif (ie_status_agenda_p = 'PC') then 
				nr_seq_legenda_w := 6931;
				 
			elsif (ie_status_agenda_p = 'PA') then 
				nr_seq_legenda_w := 6930;
				 
			elsif (ie_status_agenda_p = 'AT') then 
				nr_seq_legenda_w := 6934;
				 
			elsif (ie_status_agenda_p = 'I') then 
				nr_seq_legenda_w := 6936;
				 
			elsif (ie_status_agenda_p = 'A') then 
				nr_seq_legenda_w := 6945;
			 
			elsif (ie_status_agenda_p <> 'E' 
				and ie_status_agenda_p <> 'C' 
				and ie_status_agenda_p <> 'B' 
				and (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '')) then 
				nr_seq_legenda_w := 6927;
			end if;
		end;
	end if;
 
return	nr_seq_legenda_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_legenda_agenda_cirurgica (ie_status_agenda_p text, nr_seq_classif_agenda_p bigint, cd_pessoa_fisica_p text, ie_autorizacao_p text, nr_sequencia_p bigint, nr_atendimento_p bigint, dt_confirmacao_p timestamp) FROM PUBLIC;
