-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_assinat_digital_log ( nr_seq_assinatura_p bigint, ds_xml_p text, ie_evento_p text, ds_erro_p text, ds_hash_p text, ie_processo_ok_p text, nm_usuario_p text, ie_processo_assinado_p text, nr_sequencia_p INOUT bigint) AS $body$
DECLARE


nr_sequencia_w	bigint;
ie_evento_w	varchar(15);


BEGIN

select	nextval('tasy_assinat_dig_log_seq')
into STRICT	nr_sequencia_w
;

ie_evento_w	:= substr(ie_evento_p,1,15);

if (nr_seq_assinatura_p > 0) then

	insert into tasy_assinat_Dig_Log(
						nr_sequencia,
						nr_seq_assinatura,
						dt_evento,
						ie_evento,
						ds_erro,
						ds_xml,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						ds_hash,
						ie_processo_ok,
						ie_processo_assinado)
				values (
						nr_sequencia_w,
						nr_seq_assinatura_p,
						clock_timestamp(),
						ie_evento_w,
						substr(ds_erro_p,1,255),
						ds_xml_p,
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						ds_hash_p,
						ie_processo_ok_p,
						ie_processo_assinado_p);
end if;

nr_sequencia_p	:= nr_sequencia_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_assinat_digital_log ( nr_seq_assinatura_p bigint, ds_xml_p text, ie_evento_p text, ds_erro_p text, ds_hash_p text, ie_processo_ok_p text, nm_usuario_p text, ie_processo_assinado_p text, nr_sequencia_p INOUT bigint) FROM PUBLIC;
