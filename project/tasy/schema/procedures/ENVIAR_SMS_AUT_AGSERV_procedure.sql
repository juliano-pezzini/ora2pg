-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE enviar_sms_aut_agserv () AS $body$
DECLARE


nr_seq_agenda_w		agenda_paciente.nr_sequencia%type;
nr_telefone_w		varchar(40);
cd_agenda_w		bigint;
dt_agenda_w		timestamp;
nm_estabelecimento_w	varchar(255);
nm_pessoa_fisica_w	varchar(60);
cd_estabelecimento_w	smallint;
nm_usuario_w		varchar(15);
ds_remetente_sms_w	varchar(255);
ie_utilizar_ddi_w	varchar(1);
				
C01 CURSOR FOR
	SELECT	nr_sequencia,
		a.dt_agenda,
		obter_nome_estabelecimento(b.cd_estabelecimento),
		b.cd_estabelecimento,
		b.nm_usuario
	from	agenda_consulta a,
		agenda b
	where	a.cd_agenda 		= b.cd_agenda
	and	b.cd_tipo_agenda	= 5
	and	trunc(a.dt_agenda)	= trunc(clock_timestamp() + interval '2 days')
	and	ie_status_agenda not in ('C','L','B','F','I')
	and	(a.cd_pessoa_fisica IS NOT NULL AND a.cd_pessoa_fisica::text <> '')
	order by 1;				
				

BEGIN

/* Setting locale based on client settings */

if coalesce(philips_param_pck.get_nr_seq_idioma::text, '') = '' then
	CALL philips_param_pck.set_nr_seq_idioma(OBTER_NR_SEQ_IDIOMA('Tasy'));
end if;

open C01;
loop
fetch C01 into	
	nr_seq_agenda_w,
	dt_agenda_w,
	nm_estabelecimento_w,
	cd_estabelecimento_w,
	nm_usuario_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	
	ie_utilizar_ddi_w := obter_param_usuario(0, 214, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, cd_estabelecimento_w, ie_utilizar_ddi_w);
	
	select	max(a.cd_agenda),
		CASE WHEN ie_utilizar_ddi_w='N' THEN max(b.nr_ddi_celular)||' '||max(b.nr_telefone_celular)  ELSE max(b.nr_telefone_celular) END ,
		max(SUBSTR(OBTER_NOME_PF(b.CD_PESSOA_FISICA), 0, 60)) nm_pessoa_fisica
	into STRICT	cd_agenda_w,
		nr_telefone_w,
		nm_pessoa_fisica_w
	from	pessoa_fisica b,
		agenda_consulta a
	where	b.cd_pessoa_fisica	= a.cd_pessoa_fisica
	and	a.nr_sequencia 		= nr_seq_agenda_w;
	
	if (cd_estabelecimento_w IS NOT NULL AND cd_estabelecimento_w::text <> '') then
		select	max(ds_remetente_sms)
		into STRICT	ds_remetente_sms_w
		from	parametro_agenda
		where	cd_estabelecimento	= cd_estabelecimento_w;
	end if;
	if (coalesce(ds_remetente_sms_w::text, '') = '') then
		ds_remetente_sms_w	:= nm_estabelecimento_w;
	end if;
	
	if (coalesce(cd_agenda_w,0) > 0) and (nr_telefone_w IS NOT NULL AND nr_telefone_w::text <> '') then
		CALL enviar_sms_agenda(ds_remetente_sms_w, nr_telefone_w, wheb_mensagem_pck.get_texto(793150,
											'nm_paciente_w='||nm_pessoa_fisica_w||
											';dt_agenda_dest_w='||to_char(dt_agenda_w, pkg_date_formaters.localize_mask('short', pkg_date_formaters.getUserLanguageTag(cd_estabelecimento_w, nm_usuario_w)))), cd_agenda_w, nr_seq_agenda_w, 'Tasy');													
	end if;
	
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE enviar_sms_aut_agserv () FROM PUBLIC;
