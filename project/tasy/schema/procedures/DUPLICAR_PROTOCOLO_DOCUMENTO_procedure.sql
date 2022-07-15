-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplicar_protocolo_documento (nr_seq_protocolo_p bigint, nm_usuario_p text) AS $body$
DECLARE


dt_envio_w		timestamp;
dt_fechamento_w		timestamp;
dt_rec_destino_w		timestamp;
nm_usuario_envio_w	varchar(15);
ie_tipo_protocolo_w		varchar(3);
cd_pessoa_origem_w	varchar(10);
cd_pessoa_envio_w	varchar(10);/* afstringari - OS151895 03/07/2009 */
cd_pessoa_destino_w	varchar(10);
cd_cgc_destino_w		varchar(14);
nm_usuario_receb_w	varchar(15);
ds_obs_w		varchar(4000);
cd_setor_destino_w		integer;
cd_setor_origem_w		integer;
nr_seq_prot_novo_w	bigint;

ds_documento_w		varchar(2000);
nr_seq_interno_w		bigint;
nr_seq_tipo_item_w		bigint;
nr_documento_w		bigint;
nr_seq_item_w		integer;
dt_conferencia_w		timestamp;
dt_recebimento_w		timestamp;
ie_envio_atual_w		varchar(15);
ie_pessoa_vazio_w		varchar(15);
cd_estabelecimento_w		protocolo_documento.cd_estabelecimento%type;
nr_seq_tipo_doc_item_w		protocolo_documento.nr_seq_tipo_doc_item%type;

c01 CURSOR FOR
SELECT	nr_seq_item,
	nr_documento,
	ds_documento,
	nr_seq_interno,
	nr_seq_tipo_item,
	dt_conferencia,
	dt_recebimento
from	protocolo_doc_item
where	nr_sequencia	= nr_seq_protocolo_p;


BEGIN
ie_pessoa_vazio_w := coalesce(obter_valor_param_usuario(290,54,obter_perfil_ativo,nm_usuario_p,Wheb_usuario_pck.get_cd_estabelecimento),'S');
ie_envio_atual_w  := coalesce(obter_valor_param_usuario(290,55,obter_perfil_ativo,nm_usuario_p,Wheb_usuario_pck.get_cd_estabelecimento),'N');


select	obter_pessoa_fisica_usuario(nm_usuario_p,'C') /* afstringari - OS151895 03/07/2009 */
into STRICT	cd_pessoa_envio_w
;

if (coalesce(nr_seq_protocolo_p, 0) > 0) then

	select	dt_envio,
		nm_usuario_envio,
		ie_tipo_protocolo,
		cd_pessoa_origem,
		cd_setor_origem,
		cd_pessoa_destino,
		cd_setor_destino,
		cd_cgc_destino,
		dt_rec_destino,
		nm_usuario_receb,
		ds_obs,
		dt_fechamento,
		cd_estabelecimento,
		nr_seq_tipo_doc_item
	into STRICT	dt_envio_w,
		nm_usuario_envio_w,
		ie_tipo_protocolo_w,
		cd_pessoa_origem_w,
		cd_setor_origem_w,
		cd_pessoa_destino_w,
		cd_setor_destino_w,
		cd_cgc_destino_w,
		dt_rec_destino_w,
		nm_usuario_receb_w,
		ds_obs_w,
		dt_fechamento_w,
		cd_estabelecimento_w,
		nr_seq_tipo_doc_item_w
	from	protocolo_documento
	where	nr_sequencia	= nr_seq_protocolo_p;

	select	nextval('protocolo_documento_seq')
	into STRICT	nr_seq_prot_novo_w
	;
	--'Protocolo documento duplicado a partir do protocolo: '||nr_seq_protocolo_p
	ds_obs_w	:= substr(wheb_mensagem_pck.get_texto(305447,'NR_SEQ_PROTOCOLO_P='||nr_seq_protocolo_p)||chr(10)||chr(13)||ds_obs_w,1,4000); /* jcaraujo 25/03/11 - OS304210 */
	if (upper(ie_envio_atual_w) = 'S') then
		dt_envio_w := clock_timestamp();
	elsif (upper(ie_envio_atual_w) = 'X') then
		dt_envio_w := null;
	end if;

	if (ie_pessoa_vazio_w = 'N') then
		cd_pessoa_origem_w := null;
	end if;

	insert into protocolo_documento(nr_sequencia,
		dt_envio,
		nm_usuario_envio,
		ie_tipo_protocolo,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		cd_pessoa_origem,
		cd_setor_origem,
		cd_pessoa_destino,
		cd_setor_destino,
		cd_cgc_destino,
		dt_rec_destino,
		nm_usuario_receb,
		ds_obs,
		dt_fechamento,
		nr_seq_protocolo_origem,
		cd_estabelecimento,
		nr_seq_tipo_doc_item)
	values (	nr_seq_prot_novo_w,
		dt_envio_w,
		nm_usuario_p,		/* nm_usuario_envio_w,	 afstringari - OS151895 03/07/2009 */
		ie_tipo_protocolo_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		cd_pessoa_envio_w,	/* cd_pessoa_origem_w,	 afstringari - OS151895 03/07/2009 */
		cd_setor_origem_w,
		cd_pessoa_destino_w,
		cd_setor_destino_w,
		cd_cgc_destino_w,
		null,			/* dt_rec_destino_w,	ahoffelder - OS154829 20/07/2009 */
		null,			/* nm_usuario_receb_w,	ahoffelder - OS154829 20/07/2009 */
		ds_obs_w,
		null,			/* dt_fechamento_w	ahoffelder - OS154829 20/07/2009 */
		nr_seq_protocolo_p,
		cd_estabelecimento_w,
		nr_seq_tipo_doc_item_w);

	nr_seq_item_w	:= 0;

	open c01;
	loop
	fetch c01 into
		nr_seq_item_w,
		nr_documento_w,
		ds_documento_w,
		nr_seq_interno_w,
		nr_seq_tipo_item_w,
		dt_conferencia_w,
		dt_recebimento_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */

		insert into protocolo_doc_item(nr_seq_item,
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			nr_documento,
			ds_documento,
			nr_seq_interno,
			nr_seq_tipo_item,
			dt_conferencia,
			dt_recebimento,
			nm_usuario_receb)		/* ahoffelder - OS154829 20/07/2009 */
		values (nr_seq_item_w,
			nr_seq_prot_novo_w,
			clock_timestamp(),
			nm_usuario_p,
			nr_documento_w,
			ds_documento_w,
			nr_seq_interno_w,
			nr_seq_tipo_item_w,
			dt_conferencia_w,
			null,			/* dt_recebimento_w	ahoffelder - OS154829 20/07/2009 */
			null);

	end loop;
	close c01;

commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplicar_protocolo_documento (nr_seq_protocolo_p bigint, nm_usuario_p text) FROM PUBLIC;

