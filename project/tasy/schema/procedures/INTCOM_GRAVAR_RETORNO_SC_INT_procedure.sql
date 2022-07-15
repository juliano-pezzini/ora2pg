-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE intcom_gravar_retorno_sc_int ( nr_seq_registro_p bigint, ie_status_p text, ie_sistema_origem_p text, ds_erro_p text, ds_retorno_p text, ds_xml_p text, nm_usuario_p text) AS $body$
DECLARE

qt_existe_w		bigint;
ie_tipo_operacao_w	varchar(30);
nr_solic_compra_w	bigint;


BEGIN

select	count(*)
into STRICT	qt_existe_w
from	registro_integr_com_xml
where	nr_seq_registro	= nr_seq_registro_p
and	ie_operacao	= 'E'
and	ie_status		= 'NP';

if (qt_existe_w = 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(173194);
end if;

select	nr_solic_compra
into STRICT	nr_solic_compra_w
from	registro_integr_compras
where	nr_sequencia = nr_seq_registro_p;

select	coalesce(max(ie_tipo_operacao),'')
into STRICT	ie_tipo_operacao_w
from	registro_integr_compras
where	nr_sequencia = nr_seq_registro_p;

insert into registro_integr_com_xml(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_seq_registro,
	ie_status,
	ie_operacao,
	ie_sistema_origem,
	ds_erro,
	ds_retorno,
	ds_xml,
	ie_tipo_operacao)
values (	nextval('registro_integr_com_xml_seq'),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_registro_p,
	ie_status_p,
	'R',
	ie_sistema_origem_p,
	ds_erro_p,
	ds_retorno_p,
	ds_xml_p,
	ie_tipo_operacao_w);
	
if (ie_status_p = 'P') then	
	
	update	solic_compra
	set	nr_documento_externo = (ds_retorno_p)::numeric
	where	nr_solic_compra = nr_solic_compra_w;
		
	insert into solic_compra_hist(	
		nr_sequencia,
		nr_solic_compra,
		dt_atualizacao,
		nm_usuario,
		dt_historico,
		ds_titulo,
		ds_historico,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ie_tipo,
		cd_evento,
		dt_liberacao)
	values (	nextval('solic_compra_hist_seq'),
		nr_solic_compra_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		WHEB_MENSAGEM_PCK.get_texto(279973),
		WHEB_MENSAGEM_PCK.get_texto(279974),
		clock_timestamp(),
		nm_usuario_p,
		'S',
		'V',
		clock_timestamp());	
	
elsif (ie_status_p = 'E') then

	insert into solic_compra_hist(	
		nr_sequencia,
		nr_solic_compra,
		dt_atualizacao,
		nm_usuario,
		dt_historico,
		ds_titulo,
		ds_historico,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ie_tipo,
		cd_evento,
		dt_liberacao)
	values (	nextval('solic_compra_hist_seq'),
		nr_solic_compra_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		WHEB_MENSAGEM_PCK.get_texto(279975),
		WHEB_MENSAGEM_PCK.get_texto(279976) || chr(13) || chr(10) || WHEB_MENSAGEM_PCK.get_texto(279977) || ds_erro_p,
		clock_timestamp(),
		nm_usuario_p,
		'S',
		'V',
		clock_timestamp());
		
	/* Caso erro no envio, desmarca os itens como integrados */

	update solic_compra_item
	set IE_ENVIADO_INTEGR = 'N'
	where nr_solic_compra = nr_solic_compra_w;
		
	end if;

update	registro_integr_com_xml
set	ie_status	= ie_status_p,
	dt_atualizacao	= clock_timestamp(),
	nm_usuario	= nm_usuario_p,
	id_pdc		= ds_retorno_p
where	nr_seq_registro = nr_seq_registro_p
and	ie_operacao	= 'E';

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE intcom_gravar_retorno_sc_int ( nr_seq_registro_p bigint, ie_status_p text, ie_sistema_origem_p text, ds_erro_p text, ds_retorno_p text, ds_xml_p text, nm_usuario_p text) FROM PUBLIC;

