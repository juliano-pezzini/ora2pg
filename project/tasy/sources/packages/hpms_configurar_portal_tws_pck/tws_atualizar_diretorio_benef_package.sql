-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Atualizar os diretorio de anexos no storage, usado somente no Delphi
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 


CREATE OR REPLACE PROCEDURE hpms_configurar_portal_tws_pck.tws_atualizar_diretorio_benef ( nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type ) AS $body$
DECLARE



ds_diretorio_anexo_benef_w	pls_param_beneficiario_tws.ds_diretorio_anexo_benef%type;
ds_diretorio_anexo_pf_w		pls_param_beneficiario_tws.ds_diretorio_anexo_pf%type;
qt_storage_w			smallint;


BEGIN

select  max(ds_diretorio_anexo_benef),
        max(ds_diretorio_anexo_pf)
into STRICT	ds_diretorio_anexo_benef_w,
	ds_diretorio_anexo_pf_w
from    pls_param_beneficiario_tws
where   cd_estabelecimento = cd_estabelecimento_p;

if (ds_diretorio_anexo_benef_w IS NOT NULL AND ds_diretorio_anexo_benef_w::text <> '') then
	select  count(1)
	into STRICT	qt_storage_w
	from    file_storage_path
	where   nm_storage = 'HPMS_INSURED_FILE_DOC';
	
	if (qt_storage_w > 0) then
		
		update	file_storage_path
		set	ds_path = ds_diretorio_anexo_benef_w
		where   nm_storage = 'HPMS_INSURED_FILE_DOC'
		and	cd_uuid = '1236fdcf-5f8e-4a8e-95b7-43d3b646ffc4';
	else	
		insert into file_storage_path(nm_storage, cd_uuid, cd_estabelecimento,
			ds_path, ie_writable, ie_readable,
			dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
			nm_usuario_nrec, ie_driver)
		values ( 'HPMS_INSURED_FILE_DOC', '1236fdcf-5f8e-4a8e-95b7-43d3b646ffc4',cd_estabelecimento_p,
			ds_diretorio_anexo_benef_w, 'S', 'S',
			clock_timestamp(), nm_usuario_p, clock_timestamp(),
			nm_usuario_p, 'local');
	end if;
	
	commit;
end if;


qt_storage_w := 0;
if (ds_diretorio_anexo_pf_w IS NOT NULL AND ds_diretorio_anexo_pf_w::text <> '') then
	select  count(1)
	into STRICT	qt_storage_w
	from    file_storage_path
	where   nm_storage = 'PERSON_FILES';
	
	if (qt_storage_w > 0) then
		
		update	file_storage_path
		set	ds_path = ds_diretorio_anexo_pf_w
		where   nm_storage = 'PERSON_FILES'
		and	cd_uuid = '5274025e-ae68-4b4b-99fa-ab0acddf7d20';
	else	
		insert into file_storage_path(nm_storage, cd_uuid, cd_estabelecimento,
			ds_path, ie_writable, ie_readable,
			dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
			nm_usuario_nrec, ie_driver)
		values ( 'PERSON_FILES', '5274025e-ae68-4b4b-99fa-ab0acddf7d20',cd_estabelecimento_p,
			ds_diretorio_anexo_pf_w, 'S', 'S',
			clock_timestamp(), nm_usuario_p, clock_timestamp(),
			nm_usuario_p, 'local');
	end if;
	
	commit;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hpms_configurar_portal_tws_pck.tws_atualizar_diretorio_benef ( nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type ) FROM PUBLIC;
