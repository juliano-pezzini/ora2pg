-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pep_consistir_diagnostico ( nr_atendimento_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, qt_existe_diag_p INOUT bigint, qt_sus_aih_unif_p INOUT bigint, cd_ultimo_cid_atend_pac_p INOUT text, ds_pac_nao_diag_p INOUT text, ds_conf_ult_diag_p INOUT text, ds_pac_long_perm_p INOUT text, ds_conf_ult_diag_02_p INOUT text) AS $body$
DECLARE

		
qt_existe_diag_w		bigint;
cd_ultimo_cid_atend_pac_w	varchar(255);
ds_ultimo_cid_atend_pac_w	varchar(255);
ie_alerta_longa_perm_w		varchar(255);
qt_sus_aih_unif_w		bigint;
				

BEGIN				
if (nr_atendimento_p > 0) then
	begin	
	select	count(*)
	into STRICT	qt_existe_diag_w
	from	diagnostico_doenca
	where   nr_atendimento = nr_atendimento_p
	and (dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
    and coalesce(dt_inativacao::text, '') = '';
	
	cd_ultimo_cid_atend_pac_w := obter_ultimo_cid_atend_pac(nr_atendimento_p,'P','C');
	ds_ultimo_cid_atend_pac_w := obter_ultimo_cid_atend_pac(nr_atendimento_p,'P','D');
	
	ie_alerta_longa_perm_w := obter_param_usuario(281, 605, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_alerta_longa_perm_w);

	select	count(*)
	into STRICT	qt_sus_aih_unif_w
	from	sus_aih_unif b,
		atendimento_paciente a 
	where	a.nr_atendimento = b.nr_atendimento 
	and	sus_obter_permanencia_unif(b.nr_atendimento,b.nr_interno_conta,2) = (sus_obter_permanencia_unif(b.nr_atendimento,b.nr_interno_conta,1) - ie_alerta_longa_perm_w) 
	and	a.nr_atendimento = nr_atendimento_p;	
	end;
end if;
-- Descricao do texto: "O paciente selecionado nao possui diagnostico informado para este atendimento (Parametro 20)."
ds_pac_nao_diag_p		:= substr(obter_texto_tasy(16996, wheb_usuario_pck.get_nr_seq_idioma),1,255);
-- Descricao do texto: "O Atendimento selecionado nao possui diagnostico informado. Deseja copiar o ultimo Diagnostico do paciente para este Atendimento? (Parametro 20)."
ds_conf_ult_diag_p		:= substr(obter_texto_tasy(16997, wheb_usuario_pck.get_nr_seq_idioma),1,255);
ds_conf_ult_diag_02_p		:= substr('CID: '|| cd_ultimo_cid_atend_pac_w || ' - '|| ds_ultimo_cid_atend_pac_w,1,150);
-- Descricao do texto: "O paciente entrara em longa permanencia em 2 dias."
ds_pac_long_perm_p		:= substr(obter_texto_tasy(16998, wheb_usuario_pck.get_nr_seq_idioma),1,255);

qt_existe_diag_p		:= qt_existe_diag_w;
qt_sus_aih_unif_p		:= qt_sus_aih_unif_w;
cd_ultimo_cid_atend_pac_p	:= cd_ultimo_cid_atend_pac_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pep_consistir_diagnostico ( nr_atendimento_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, qt_existe_diag_p INOUT bigint, qt_sus_aih_unif_p INOUT bigint, cd_ultimo_cid_atend_pac_p INOUT text, ds_pac_nao_diag_p INOUT text, ds_conf_ult_diag_p INOUT text, ds_pac_long_perm_p INOUT text, ds_conf_ult_diag_02_p INOUT text) FROM PUBLIC;

