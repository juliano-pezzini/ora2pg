-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_dados_internar_paciente ( cd_pessoa_fisica_p text, nr_atendimento_p bigint, cd_convenio_reserva_p bigint, dt_entrada_p text, nm_usuario_p text, ds_confirm_internacao_p INOUT text, nr_seq_solic_vaga_p INOUT bigint, cd_setor_pac_p INOUT bigint, ds_confirm_leito_reserv_pac_p INOUT text, cd_setor_conv_p INOUT bigint, ds_confirm_leito_reserv_conv_p INOUT text, cd_unidade_basica_pac_p INOUT bigint, cd_unidade_compl_pac_p INOUT bigint, cd_unidade_basica_conv_p INOUT bigint, cd_unidade_compl_conv_p INOUT bigint, cd_setor_atendimento_p INOUT bigint, cd_unidade_basica_p INOUT bigint, cd_unidade_compl_p INOUT bigint) AS $body$
BEGIN
 
ds_confirm_internacao_p	:= substr(obter_texto_dic_objeto(88664, wheb_usuario_pck.get_nr_seq_idioma, 'dt_entrada='||dt_entrada_p),1,255);
 
nr_seq_solic_vaga_p	:= obter_se_leito_livre_reservado(cd_pessoa_fisica_p, 'V', 'L', 'PS', nr_atendimento_p);
 
select	max(cd_setor_atendimento) 
into STRICT	cd_setor_pac_p	 
from	ocupacao_unidade_v 
where	cd_paciente_reserva	= cd_pessoa_fisica_p 
and	ie_status_unidade in ('L','R');
	 
ds_confirm_leito_reserv_pac_p	:= substr(obter_texto_tasy(88938, wheb_usuario_pck.get_nr_seq_idioma),1,255);	
	 
select	max(cd_unidade_basica) 
into STRICT	cd_unidade_basica_pac_p 
from	ocupacao_unidade_v 
where	cd_paciente_reserva	= cd_pessoa_fisica_p 
and	ie_status_unidade in ('L','R');
 
select	max(cd_unidade_compl) 
into STRICT	cd_unidade_compl_pac_p 
from	ocupacao_unidade_v 
where	cd_paciente_reserva	= cd_pessoa_fisica_p 
and	ie_status_unidade in ('L','R');
 
select	max(cd_setor_atendimento) 
into STRICT	cd_setor_conv_p 
from	ocupacao_unidade_v 
where	cd_convenio_reserva	= cd_convenio_reserva_p 
and	coalesce(cd_paciente_reserva::text, '') = '' 
and	ie_status_unidade in ('L','R');
 
ds_confirm_leito_reserv_conv_p	:= substr(obter_texto_tasy(88938, wheb_usuario_pck.get_nr_seq_idioma),1,255);	
 
select	max(cd_unidade_basica) 
into STRICT	cd_unidade_basica_conv_p 
from	ocupacao_unidade_v 
where  cd_convenio_reserva	= cd_convenio_reserva_p 
and   coalesce(cd_paciente_reserva::text, '') = '' 
and	ie_status_unidade in ('L','R');
 
select	max(cd_unidade_compl) 
into STRICT	cd_unidade_compl_conv_p 
from	ocupacao_unidade_v 
where  cd_convenio_reserva	= cd_convenio_reserva_p 
and   coalesce(cd_paciente_reserva::text, '') = '' 
and	ie_status_unidade in ('L','R');
 
cd_setor_atendimento_p	:= obter_se_leito_livre_reservado(cd_pessoa_fisica_p, 'S', 'L', 'PS', nr_atendimento_p);
cd_unidade_basica_p	:= obter_se_leito_livre_reservado(cd_pessoa_fisica_p, 'UB', 'L', 'PS', nr_atendimento_p);
cd_unidade_compl_p	:= obter_se_leito_livre_reservado(cd_pessoa_fisica_p, 'UC', 'L', 'PS', nr_atendimento_p);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_dados_internar_paciente ( cd_pessoa_fisica_p text, nr_atendimento_p bigint, cd_convenio_reserva_p bigint, dt_entrada_p text, nm_usuario_p text, ds_confirm_internacao_p INOUT text, nr_seq_solic_vaga_p INOUT bigint, cd_setor_pac_p INOUT bigint, ds_confirm_leito_reserv_pac_p INOUT text, cd_setor_conv_p INOUT bigint, ds_confirm_leito_reserv_conv_p INOUT text, cd_unidade_basica_pac_p INOUT bigint, cd_unidade_compl_pac_p INOUT bigint, cd_unidade_basica_conv_p INOUT bigint, cd_unidade_compl_conv_p INOUT bigint, cd_setor_atendimento_p INOUT bigint, cd_unidade_basica_p INOUT bigint, cd_unidade_compl_p INOUT bigint) FROM PUBLIC;
