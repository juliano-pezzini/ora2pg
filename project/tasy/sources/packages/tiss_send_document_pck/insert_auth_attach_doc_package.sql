-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE tiss_send_document_pck.insert_auth_attach_doc (nr_seq_attach_p autorizacao_convenio_arq.nr_sequencia%type, nm_user_p usuario.nm_usuario%type, ds_doc_format_p text, result_seq_p INOUT tiss_envio_documento.nr_sequencia%type) AS $body$
DECLARE


nr_provider_form_w 	autorizacao_convenio.cd_autorizacao%type;
nr_hpms_form_w		autorizacao_convenio.cd_autorizacao%type;
nr_doc_w		autorizacao_convenio.nr_sequencia%type;
ie_tiss_doc_w		autorizacao_convenio_arq.ie_tipo_documento_tiss%type;
ds_obs_w		autorizacao_convenio.ds_observacao%type;
nr_seq_auth_w		autorizacao_convenio.nr_sequencia%type;
ie_doc_format_w		tiss_envio_documento.ie_formato_documento%type;
result_seq_w		tiss_envio_documento.nr_sequencia%type;


BEGIN

select	max(x.nr_sequencia)
into STRICT	result_seq_w
from	tiss_envio_documento x
where	x.nr_seq_autor_conv_anexo = nr_seq_attach_p;

begin
select  case when (a.cd_autorizacao_prest IS NOT NULL AND a.cd_autorizacao_prest::text <> '') then a.cd_autorizacao_prest else to_char(a.nr_sequencia) end as nr_guia_prestador,
	a.cd_autorizacao,
	a.nr_sequencia,
	b.ie_tipo_documento_tiss,
	a.ds_observacao,
	b.nr_sequencia
into STRICT 	nr_provider_form_w,
	nr_hpms_form_w,
	nr_doc_w,
	ie_tiss_doc_w,
	ds_obs_w,
	nr_seq_auth_w
from 	autorizacao_convenio a
join 	autorizacao_convenio_arq b
on 	b.nr_sequencia_autor = a.nr_sequencia
where   b.nr_sequencia = nr_seq_attach_p;
exception
	when no_data_found or too_many_rows then
	nr_hpms_form_w := null;
end;

ie_doc_format_w := tiss_send_document_pck.get_doc_format(ds_doc_format_p);

if 	coalesce(result_seq_w::text, '') = '' then


	result_seq_w := tiss_send_document_pck.execute_insert(nm_user_p, null, null, nr_provider_form_w, nr_hpms_form_w, nr_doc_w, current_setting('tiss_send_document_pck.ie_form_type_c')::tiss_envio_documento.ie_natureza_guia%type, ie_doc_format_w, null, ie_tiss_doc_w, ds_obs_w, nr_seq_auth_w, null, result_seq_w);
elsif	(nr_hpms_form_w IS NOT NULL AND nr_hpms_form_w::text <> '') then

	update	tiss_envio_documento
	set	nr_guia_operadora 	= nr_hpms_form_w,
		nr_guia_prestador 	= nr_provider_form_w,
		ie_formato_documento 	= ie_doc_format_w,
		dt_atualizacao	    	= clock_timestamp(),
		nm_usuario	     	= nm_user_p
	where	nr_sequencia		= result_seq_w;
			
	
end if;

result_seq_p := result_seq_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tiss_send_document_pck.insert_auth_attach_doc (nr_seq_attach_p autorizacao_convenio_arq.nr_sequencia%type, nm_user_p usuario.nm_usuario%type, ds_doc_format_p text, result_seq_p INOUT tiss_envio_documento.nr_sequencia%type) FROM PUBLIC;