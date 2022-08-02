-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE same_solicitar_prontuarios ( cd_setor_solicitante_p bigint, cd_agenda_p bigint, dt_desejada_p timestamp, nr_prontuario_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ds_retorno_p INOUT text ) AS $body$
DECLARE



nr_sequencia_w	bigint;
ds_retorno_w	varchar(255) := null;


BEGIN

ds_retorno_w := Consiste_solic_prontuario(0, nr_prontuario_p, cd_setor_solicitante_p, cd_agenda_p, dt_desejada_p, cd_estabelecimento_p, ds_retorno_w);
ds_retorno_p	:= ds_retorno_w;

if (coalesce(ds_retorno_w::text, '') = '') then
	begin
	select	nextval('same_cpi_solic_seq')
	into STRICT	nr_sequencia_w
	;

	insert 	into same_cpi_solic(
   		nr_sequencia,
	   	cd_estabelecimento,
	   	nr_prontuario,
	   	dt_atualizacao,
	   	nm_usuario,
	   	nr_seq_agenda,
	   	cd_setor_atendimento,
	   	dt_solicitacao,
	   	dt_desejada,
	   	ie_status_solic,
	   	nm_usuario_solic,
	   	dt_cancelamento,
 	 	nm_usuario_cancel,
  	 	cd_agenda)
	values (nr_sequencia_w,
   		cd_estabelecimento_p,
   		nr_prontuario_p,
   		clock_timestamp(),
   		nm_usuario_p,
   		null,
   		cd_setor_solicitante_p,
   		clock_timestamp(),
   		dt_desejada_p,
   		'A',
   		nm_usuario_p,
   		null,
   		null,
   		cd_agenda_p);
	commit;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE same_solicitar_prontuarios ( cd_setor_solicitante_p bigint, cd_agenda_p bigint, dt_desejada_p timestamp, nr_prontuario_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ds_retorno_p INOUT text ) FROM PUBLIC;

