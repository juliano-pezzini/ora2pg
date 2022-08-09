-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE enviar_sms_agenda_exames ( nr_seq_agenda_p bigint, cd_agenda_p bigint, nr_telefone_celular_p text, ds_sms_p text, cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text) AS $body$
DECLARE


vl_parametro_w	varchar(255);
ds_remetente_w	varchar(255);


BEGIN

vl_parametro_w := Obter_Param_Usuario(0, 63, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, vl_parametro_w);

if (vl_parametro_w IS NOT NULL AND vl_parametro_w::text <> '') then
	ds_remetente_w	:= vl_parametro_w;
else
	ds_remetente_w	:= substr(obter_nome_estabelecimento(cd_estabelecimento_p),1,255);
end if;

CALL enviar_sms_agenda(ds_remetente_w, nr_telefone_celular_p, ds_sms_p, cd_agenda_p, nr_seq_agenda_p, nm_usuario_p);
CALL confirmar_agenda_paciente(nr_seq_agenda_p, nm_usuario_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE enviar_sms_agenda_exames ( nr_seq_agenda_p bigint, cd_agenda_p bigint, nr_telefone_celular_p text, ds_sms_p text, cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text) FROM PUBLIC;
