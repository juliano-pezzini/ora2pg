-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE enviar_sms_checkup ( ds_remetente_p text, ds_destinatario_p text, ds_mensagem_p text, nr_seq_checkup_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w			bigint;
id_sms_w				bigint;
ie_cons_perm_env_sms_pac_w	varchar(1);
cd_pessoa_fisica_w		varchar(20);
ie_perm_receb_sms_email_w		varchar(1);
nr_celular_w			varchar(50);
nr_pos_ddd0_w			bigint := 0;
sqlerrm_w				varchar(2000);
ie_cons_dest_sms_w		varchar(1);


BEGIN
ie_cons_dest_sms_w := obter_valor_param_usuario(0,214,0,nm_usuario_p,wheb_usuario_pck.get_cd_estabelecimento);
nr_celular_w := trim(both ds_destinatario_p);

if (ie_cons_dest_sms_w = 'S') then
	begin
	if (substr(nr_celular_w,1,2) <> '55') then
		nr_celular_w :=  '55'||ds_destinatario_p;
	end if;

	nr_pos_ddd0_w	:= position('550' in nr_celular_w);

	if (nr_pos_ddd0_w > 0)then
		nr_celular_w	:= replace(nr_celular_w,'550','55');
	end if;
	end;
end if;

ie_cons_perm_env_sms_pac_w := Obter_Param_Usuario(821, 395, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_cons_perm_env_sms_pac_w);

if (ie_cons_perm_env_sms_pac_w <> 'N')then
	select	max(a.cd_pessoa_fisica)
	into STRICT	cd_pessoa_fisica_w
	from	checkup a
	where	a.nr_sequencia	= nr_seq_checkup_p;

	if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '')then
		select	coalesce(max(a.ie_perm_sms_email),'N')
		into STRICT	ie_perm_receb_sms_email_w
		from	pessoa_fisica a
		where	a.cd_pessoa_fisica	= cd_pessoa_fisica_w;
	end if;
else
	ie_perm_receb_sms_email_w	:= 'S';

end if;

if (ds_remetente_p IS NOT NULL AND ds_remetente_p::text <> '') and (nr_celular_w IS NOT NULL AND nr_celular_w::text <> '') and (ds_mensagem_p IS NOT NULL AND ds_mensagem_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') and (ie_perm_receb_sms_email_w <> 'N')then

	/* enviar sms */

	begin
	id_sms_w := wheb_sms.enviar_sms(ds_remetente_p, nr_celular_w, ds_mensagem_p, nm_usuario_p, id_sms_w);

	exception
	when others then

	select	nextval('log_envio_sms_seq')
	into STRICT	nr_sequencia_w
	;

	sqlerrm_w	:= substr(sqlerrm,1,2000);

	insert into log_envio_sms(
		nr_sequencia,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		dt_atualizacao,
		nm_usuario,
		dt_envio,
		nr_telefone,
		ds_mensagem,
		id_sms)
	values (
		nr_sequencia_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		ds_destinatario_p,
		substr(wheb_mensagem_pck.get_texto(307466) || chr(10)||sqlerrm_w,1,2000), -- Ocorreu algum erro no envio de SMS.
		id_sms_w);

		commit;

		CALL Wheb_mensagem_pck.exibir_mensagem_abort( 262328 , 'DS_MENSAGEM='||wheb_mensagem_pck.get_texto(307466, 'SQLERRM=')||chr(10)||sqlerrm_w); -- Ocorreu algum erro no envio de SMS.
	end;

	/* gravar log */

	select	nextval('log_envio_sms_seq')
	into STRICT	nr_sequencia_w
	;

	insert into log_envio_sms(
		nr_sequencia,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		dt_atualizacao,
		nm_usuario,
		dt_envio,
		nr_telefone,
		ds_mensagem,
		id_sms)
	values (
		nr_sequencia_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		ds_destinatario_p,
		ds_mensagem_p,
		id_sms_w);

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE enviar_sms_checkup ( ds_remetente_p text, ds_destinatario_p text, ds_mensagem_p text, nr_seq_checkup_p bigint, nm_usuario_p text) FROM PUBLIC;
